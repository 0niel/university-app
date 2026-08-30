// miniapp-proxy — the single gateway for ALL mini app (BDUI/Stac) traffic.
//
// Клиент никогда не ходит на сервер мини-аппа напрямую: и экраны, и API-вызовы
// идут через эту функцию. Это даёт:
//  * аутентификацию (verify_jwt=true — анонимов отсекает гейтвей);
//  * проверку статуса приложения (published / владелец / модератор);
//  * SSRF-защиту: https-only, без редиректов, пиннинг хоста к origin_url,
//    запрет приватных/IP-литеральных хостов, таймаут и лимит размера ответа;
//  * rate limiting на пользователя (атомарно в Postgres);
//  * подписанную identity для бэкендов мини-аппов: HMAC на per-app секрете,
//    который владелец генерирует в приложении (см. доку).
//
// POST body:
//   {
//     "organizationId": "...",       // required
//     "slug": "my-app",              // required
//     "kind": "screen" | "api",      // default "screen"
//     "path": "/details",            // screen path or API path
//     "method": "GET" | "POST" | "PUT" | "DELETE",  // api only
//     "query": { ... },              // api only
//     "body": { ... }                // api only
//   }
//
// Screen response: the raw Stac widget JSON.
// API response: the upstream JSON body (status code is forwarded).
import { createClient } from "@supabase/supabase-js";

const REQUEST_TIMEOUT_MS = 10_000;
const MAX_RESPONSE_BYTES = 512 * 1024;
const RATE_LIMIT_PER_MINUTE = 180;

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, content-type, apikey",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

interface ProxyRequest {
  organizationId?: string;
  slug?: string;
  kind?: "screen" | "api";
  path?: string;
  method?: string;
  query?: Record<string, string>;
  body?: unknown;
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: CORS_HEADERS });
  }
  if (req.method !== "POST") {
    return json({ error: "Method not allowed" }, 405);
  }

  const authHeader = req.headers.get("Authorization") ?? "";
  const userClient = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!,
    { global: { headers: { Authorization: authHeader } } },
  );
  const { data: userData, error: userError } = await userClient.auth.getUser();
  if (userError || !userData?.user) {
    return json({ error: "Unauthorized" }, 401);
  }
  const user = userData.user;

  let body: ProxyRequest;
  try {
    body = await req.json();
  } catch {
    return json({ error: "Invalid JSON body" }, 400);
  }
  const organizationId = (body.organizationId ?? "").trim();
  const slug = (body.slug ?? "").trim().toLowerCase();
  const kind = body.kind === "api" ? "api" : "screen";
  const path = normalizePath(body.path);
  if (!organizationId || !slug) {
    return json({ error: "organizationId and slug are required" }, 400);
  }
  if (!/^[a-z0-9][a-z0-9-]{2,39}$/.test(slug)) {
    return json({ error: "Invalid slug" }, 400);
  }

  // App lookup + visibility + rate limit in one Postgres round trip.
  const serviceClient = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );
  const { data: context, error: contextError } = await serviceClient.rpc(
    "mini_app_proxy_context",
    {
      p_user_id: user.id,
      p_organization_id: organizationId,
      p_slug: slug,
      p_path: path,
      p_rate_limit: RATE_LIMIT_PER_MINUTE,
    },
  );
  if (contextError) {
    return json({ error: `Lookup failed: ${contextError.message}` }, 500);
  }
  if (!context?.allowed) {
    const reason = context?.reason ?? "forbidden";
    const status = reason === "rate_limited"
      ? 429
      : reason === "not_found"
      ? 404
      : 403;
    return json({ error: reason }, status);
  }

  const app = context.app as {
    sourceKind: string;
    originUrl: string | null;
    entryPath: string;
  };

  // Hosted apps: the screen JSON lives in Postgres, no outbound call at all.
  if (app.sourceKind === "hosted") {
    if (kind === "api") {
      return json({ error: "Hosted mini apps have no API origin" }, 400);
    }
    if (context.screen == null) {
      return json({ error: "Screen not found" }, 404);
    }
    return json(context.screen, 200);
  }

  // Service apps: first-party, served by an internal `miniapp-svc-<slug>`
  // edge function. Trusted target, so the SSRF host checks below don't apply;
  // we authenticate ourselves to it with the service-role key.
  if (app.sourceKind === "service") {
    return callServiceApp(organizationId, slug, kind, path, body, user.id);
  }

  // Remote apps: server-side fetch with SSRF protections.
  const target = buildTargetUrl(app.originUrl ?? "", path ?? app.entryPath, body.query);
  if (target instanceof Response) return target;

  const method = kind === "api"
    ? sanitizeMethod(body.method)
    : "GET";
  if (method == null) {
    return json({ error: "Unsupported method" }, 400);
  }

  const appMeta = context.app as { id: string };
  const headers: Record<string, string> = {
    "Accept": "application/json",
    "User-Agent": "MireaNinja-MiniAppProxy/1.0",
    ...(await identityHeaders(
      user.id,
      appMeta.id,
      (context.permissions ?? []) as string[],
      (context.identity ?? {}) as Record<string, unknown>,
      (context.signingSecret ?? null) as string | null,
      (context.previousSigningSecret ?? null) as string | null,
    )),
  };
  const init: RequestInit = {
    method,
    headers,
    redirect: "error",
    signal: AbortSignal.timeout(REQUEST_TIMEOUT_MS),
  };
  if (method !== "GET" && body.body !== undefined) {
    headers["Content-Type"] = "application/json";
    init.body = JSON.stringify(body.body);
  }

  let upstream: Response;
  try {
    upstream = await fetch(target, init);
  } catch (e) {
    const message = e instanceof Error ? e.message : String(e);
    const status = message.includes("timed out") ? 504 : 502;
    return json({ error: `Mini app origin unreachable: ${message}` }, status);
  }

  const payload = await readJsonCapped(upstream);
  if (payload instanceof Response) return payload;
  return json(payload, upstream.ok ? 200 : upstream.status);
});

/// Routes a service mini app to its internal `miniapp-svc-<slug>` edge
/// function. The proxy has already authenticated the user and checked the
/// status and rate limit; here we forward and return the function's JSON.
/// We authenticate to the function with the service-role key.
async function callServiceApp(
  organizationId: string,
  slug: string,
  kind: "screen" | "api",
  path: string | null,
  body: ProxyRequest,
  userId: string,
): Promise<Response> {
  const target =
    `${Deno.env.get("SUPABASE_URL")}/functions/v1/miniapp-svc-${slug}`;
  let upstream: Response;
  try {
    upstream = await fetch(target, {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        organizationId,
        slug,
        kind,
        path,
        method: body.method,
        query: body.query,
        body: body.body,
        userId,
      }),
      signal: AbortSignal.timeout(REQUEST_TIMEOUT_MS),
    });
  } catch (e) {
    const message = e instanceof Error ? e.message : String(e);
    const status = message.includes("timed out") ? 504 : 502;
    return json({ error: `Service app unreachable: ${message}` }, status);
  }

  const payload = await readJsonCapped(upstream);
  if (payload instanceof Response) return payload;
  return json(payload, upstream.ok ? 200 : upstream.status);
}

function normalizePath(path: string | undefined): string | null {
  const value = (path ?? "").trim();
  if (!value) return null;
  if (!value.startsWith("/") || value.includes("..")) return null;
  return value;
}

function sanitizeMethod(method: string | undefined): string | null {
  const value = (method ?? "GET").toUpperCase();
  return ["GET", "POST", "PUT", "DELETE", "PATCH"].includes(value)
    ? value
    : null;
}

/// Pins the request to the registered origin: scheme https, the exact host
/// from origin_url, no credentials, no private/IP-literal hosts.
function buildTargetUrl(
  originUrl: string,
  path: string,
  query: Record<string, string> | undefined,
): URL | Response {
  let origin: URL;
  try {
    origin = new URL(originUrl);
  } catch {
    return json({ error: "Mini app origin is misconfigured" }, 502);
  }
  if (origin.protocol !== "https:") {
    return json({ error: "Origin must be https" }, 502);
  }
  if (isForbiddenHost(origin.hostname)) {
    return json({ error: "Origin host is not allowed" }, 502);
  }

  const basePath = origin.pathname.replace(/\/$/, "");
  const target = new URL(origin.origin + basePath + path);
  if (target.hostname !== origin.hostname || target.protocol !== "https:") {
    return json({ error: "Path escapes the registered origin" }, 400);
  }
  for (const [key, value] of Object.entries(query ?? {})) {
    if (typeof value === "string" && key.length <= 64 && value.length <= 512) {
      target.searchParams.set(key, value);
    }
  }
  return target;
}

function isForbiddenHost(hostname: string): boolean {
  const host = hostname.toLowerCase();
  if (host === "localhost" || host.endsWith(".localhost")) return true;
  if (host.endsWith(".local") || host.endsWith(".internal")) return true;
  // IPv4 literals (covers 127.0.0.1, 10.x, 169.254.x — all private ranges
  // are rejected wholesale by banning IP literals entirely).
  if (/^\d{1,3}(\.\d{1,3}){3}$/.test(host)) return true;
  // IPv6 literals.
  if (host.includes(":") || host.startsWith("[")) return true;
  // Supabase-internal hosts must not be reachable through the proxy.
  if (host.endsWith(".supabase.co") || host.endsWith(".supabase.net")) {
    return true;
  }
  return false;
}

/// Consent-scoped identity headers. The Supabase session/JWT is NEVER
/// forwarded. Without grants a developer only sees a pseudonymous per-app
/// user id (stable per user+app, not linkable across apps). Granted scopes
/// add: identity → real UUID; email; profile → name (base64 utf-8) +
/// course; group → academic group (base64 utf-8).
///
/// Signature: HMAC-SHA256 over "<appUserId>.<timestamp>" with the app's own
/// secret (`signingSecret`, generated by the owner in-app). During a rotation
/// grace window the previous secret signs a second `X-MireaNinja-Signature-Prev`
/// header so an origin that has not redeployed keeps validating. A legacy
/// global MINIAPP_PROXY_SECRET is the fallback for apps without one.
async function identityHeaders(
  userId: string,
  appId: string,
  scopes: string[],
  identity: Record<string, unknown>,
  signingSecret: string | null,
  previousSecret: string | null,
): Promise<Record<string, string>> {
  // The app-user id must stay stable across secret rotations, so it is keyed
  // on a deployment-stable secret, never the rotating per-app signing secret.
  const pseudoSecret = Deno.env.get("MINIAPP_PROXY_SECRET") ??
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
  const appUserId = await hmacHex(
    pseudoSecret,
    `app-user:${appId}:${userId}`,
  );

  const headers: Record<string, string> = {
    "X-MireaNinja-App-User": appUserId,
    "X-MireaNinja-Scopes": scopes.join(","),
  };
  if (scopes.includes("identity")) {
    headers["X-MireaNinja-User"] = userId;
  }
  if (scopes.includes("email") && typeof identity.email === "string") {
    headers["X-MireaNinja-Email"] = identity.email;
  }
  if (scopes.includes("profile")) {
    if (typeof identity.name === "string" && identity.name) {
      headers["X-MireaNinja-Name"] = toBase64(identity.name);
    }
    if (identity.course != null) {
      headers["X-MireaNinja-Course"] = String(identity.course);
    }
  }
  if (scopes.includes("group") && typeof identity.group === "string") {
    headers["X-MireaNinja-Group"] = toBase64(identity.group);
  }

  const activeSecret = signingSecret ?? Deno.env.get("MINIAPP_PROXY_SECRET");
  if (!activeSecret) return headers;
  const timestamp = Math.floor(Date.now() / 1000).toString();
  headers["X-MireaNinja-Timestamp"] = timestamp;
  headers["X-MireaNinja-Signature"] = await hmacHex(
    activeSecret,
    `${appUserId}.${timestamp}`,
  );
  if (previousSecret) {
    headers["X-MireaNinja-Signature-Prev"] = await hmacHex(
      previousSecret,
      `${appUserId}.${timestamp}`,
    );
  }
  return headers;
}

async function hmacHex(secret: string, payload: string): Promise<string> {
  const key = await crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(secret),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const signature = await crypto.subtle.sign(
    "HMAC",
    key,
    new TextEncoder().encode(payload),
  );
  return toHex(new Uint8Array(signature));
}

function toBase64(value: string): string {
  return btoa(String.fromCharCode(...new TextEncoder().encode(value)));
}

function toHex(bytes: Uint8Array): string {
  return [...bytes].map((b) => b.toString(16).padStart(2, "0")).join("");
}

/// Reads the upstream body with a hard size cap and requires valid JSON —
/// the client renders the result directly, HTML/binary must never pass.
async function readJsonCapped(res: Response): Promise<unknown | Response> {
  const reader = res.body?.getReader();
  if (!reader) return json({ error: "Empty origin response" }, 502);

  const chunks: Uint8Array[] = [];
  let total = 0;
  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    total += value.byteLength;
    if (total > MAX_RESPONSE_BYTES) {
      await reader.cancel();
      return json({ error: "Origin response too large" }, 502);
    }
    chunks.push(value);
  }
  const buffer = new Uint8Array(total);
  let offset = 0;
  for (const chunk of chunks) {
    buffer.set(chunk, offset);
    offset += chunk.byteLength;
  }
  try {
    return JSON.parse(new TextDecoder().decode(buffer));
  } catch {
    return json({ error: "Origin returned invalid JSON" }, 502);
  }
}

function json(payload: unknown, status: number): Response {
  return new Response(JSON.stringify(payload), {
    status,
    headers: { "Content-Type": "application/json", ...CORS_HEADERS },
  });
}
