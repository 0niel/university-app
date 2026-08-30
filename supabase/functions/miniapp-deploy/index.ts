// miniapp-deploy — CI-деплой hosted-экранов мини-аппа по deploy-токену.
//
// Токен создаётся в приложении (Мини-аппы → Создать → токены) и передаётся
// как Bearer. Хранится только sha256-хеш. Деплой заменяет все экраны,
// снимает ревизию и отправляет апп на модерацию (submit=false → черновик).
//
//   curl -X POST https://<ref>.supabase.co/functions/v1/miniapp-deploy \
//     -H "Authorization: Bearer man_..." \
//     -H "Content-Type: application/json" \
//     -d '{"organizationId":"mirea","slug":"my-app",
//          "screens":[{"path":"/","json":{"type":"scaffold"}}]}'
//
// Ответ: { ok, version, status, validation: {unknownWidgets, unknownActions} }
import { createClient } from "@supabase/supabase-js";

const MAX_BODY_BYTES = 1024 * 1024;

Deno.serve(async (req: Request) => {
  if (req.method !== "POST") {
    return json({ error: "Method not allowed" }, 405);
  }

  const auth = req.headers.get("Authorization") ?? "";
  const token = auth.replace(/^Bearer\s+/i, "").trim();
  if (!/^man_[0-9a-f]{48}$/.test(token)) {
    return json({ error: "Invalid deploy token" }, 401);
  }

  const raw = await req.text();
  if (raw.length > MAX_BODY_BYTES) {
    return json({ error: "Body too large" }, 413);
  }
  let body: {
    organizationId?: string;
    slug?: string;
    screens?: unknown;
    submit?: boolean;
  };
  try {
    body = JSON.parse(raw);
  } catch {
    return json({ error: "Invalid JSON" }, 400);
  }
  if (!body.organizationId || !body.slug || !Array.isArray(body.screens)) {
    return json(
      { error: "organizationId, slug and screens[] are required" },
      400,
    );
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );
  const { data, error } = await supabase.rpc("mini_app_deploy", {
    p_token_hash: await sha256Hex(token),
    p_organization_id: body.organizationId,
    p_slug: body.slug,
    p_screens: body.screens,
    p_submit: body.submit ?? true,
  });
  if (error) {
    return json({ error: `Deploy failed: ${error.message}` }, 500);
  }
  if (!data?.ok) {
    const status = data?.reason === "invalid_token" ? 401 : 422;
    return json(data, status);
  }
  return json(data, 200);
});

async function sha256Hex(value: string): Promise<string> {
  const digest = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(value),
  );
  return [...new Uint8Array(digest)]
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

function json(payload: unknown, status: number): Response {
  return new Response(JSON.stringify(payload), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}
