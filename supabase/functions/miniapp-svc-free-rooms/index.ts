// miniapp-svc-free-rooms — a first-party "service" mini app.
//
// Not called by clients directly: the miniapp-proxy routes apps with
// source_kind = 'service' here (slug → function `miniapp-svc-<slug>`). The
// proxy already authenticated the user, checked the app status and rate
// limit, so this function only has to build the screen.
//
// Auth: the proxy calls with the service-role key as Bearer. We compare it
// to our own SUPABASE_SERVICE_ROLE_KEY so no one but the proxy can reach it.
//
// Request body (from the proxy):
//   { organizationId, slug, kind: "screen" | "api", path, userId }
// Response: the raw Stac widget JSON for the screen.
import { createClient } from "@supabase/supabase-js";
import { buildFreeRoomsScreen, type FreeRoom } from "./screens.ts";

Deno.serve(async (req: Request) => {
  if (req.method !== "POST") {
    return json({ error: "Method not allowed" }, 405);
  }
  if (!isFromProxy(req)) {
    return json({ error: "Forbidden" }, 403);
  }

  let body: {
    organizationId?: string;
    kind?: string;
    path?: string;
  };
  try {
    body = await req.json();
  } catch {
    return json({ error: "Invalid JSON body" }, 400);
  }

  const organizationId = (body.organizationId ?? "").trim();
  if (!organizationId) {
    return json({ error: "organizationId is required" }, 400);
  }
  if ((body.kind ?? "screen") === "api") {
    return json({ error: "Free rooms has no API surface" }, 400);
  }
  const path = normalizePath(body.path);

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );
  const { data, error } = await supabase.rpc("get_free_rooms", {
    p_organization_id: organizationId,
  });
  if (error) {
    return json({ error: `Lookup failed: ${error.message}` }, 502);
  }

  const rooms = (Array.isArray(data) ? data : []) as FreeRoom[];
  return json(buildFreeRoomsScreen(rooms, path), 200);
});

/// True when the caller presented our service-role key (constant-time).
function isFromProxy(req: Request): boolean {
  const expected = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
  const token = (req.headers.get("Authorization") ?? "").replace(
    /^Bearer\s+/i,
    "",
  );
  if (!expected || token.length !== expected.length) return false;
  return timingSafeEqual(token, expected);
}

function timingSafeEqual(a: string, b: string): boolean {
  let diff = 0;
  for (let i = 0; i < a.length; i++) {
    diff |= a.charCodeAt(i) ^ b.charCodeAt(i);
  }
  return diff === 0;
}

function normalizePath(path: string | undefined): string {
  const value = (path ?? "/").trim();
  if (!value.startsWith("/") || value.includes("..")) return "/";
  return value;
}

function json(payload: unknown, status: number): Response {
  return new Response(JSON.stringify(payload), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}
