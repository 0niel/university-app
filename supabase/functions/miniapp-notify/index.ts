// miniapp-notify — пуш-рассылка от мини-аппа его подписчикам.
//
// Auth: deploy-токен разработчика (Bearer man_...). Получатели — только
// пользователи, выдавшие аппу scope `notifications`; квота 2 пуша в сутки
// на пользователя на апп (форсируется в mini_app_notify_context). Тап по
// уведомлению открывает апп (route → диплинк-система приложения).
//
// Доставка — через Yandex Cloud Notification Service (см. cns.ts): один
// Publish на устройство, CNS сам доставляет в FCM/APNs/HMS/RuStore по
// типу канала эндпоинта. Эндпоинты создаются лениво и кешируются в
// core.user_devices.cns_endpoint_arn.
import { createClient } from "@supabase/supabase-js";
import {
  channelArnFor,
  cnsConfigFromEnv,
  createPlatformEndpoint,
  isStaleEndpointError,
  publishPush,
} from "./cns.ts";

Deno.serve(async (req: Request) => {
  if (req.method !== "POST") {
    return json({ error: "Method not allowed" }, 405);
  }

  const auth = req.headers.get("Authorization") ?? "";
  const token = auth.replace(/^Bearer\s+/i, "").trim();
  if (!/^man_[0-9a-f]{48}$/.test(token)) {
    return json({ error: "Invalid deploy token" }, 401);
  }

  const cns = cnsConfigFromEnv();
  if (!cns) {
    return json(
      { error: "CNS_ACCESS_KEY_ID / CNS_SECRET_KEY secrets are not set" },
      503,
    );
  }

  let body: {
    organizationId?: string;
    slug?: string;
    title?: string;
    body?: string;
    page?: string;
  };
  try {
    body = await req.json();
  } catch {
    return json({ error: "Invalid JSON" }, 400);
  }
  const title = (body.title ?? "").trim();
  if (!body.organizationId || !body.slug || !title) {
    return json(
      { error: "organizationId, slug and title are required" },
      400,
    );
  }
  if (title.length > 80 || (body.body ?? "").length > 200) {
    return json({ error: "title ≤ 80 chars, body ≤ 200 chars" }, 400);
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );
  const { data: context, error } = await supabase.rpc(
    "mini_app_notify_context",
    {
      p_token_hash: await sha256Hex(token),
      p_organization_id: body.organizationId,
      p_slug: body.slug,
    },
  );
  if (error) {
    return json({ error: `Lookup failed: ${error.message}` }, 500);
  }
  if (!context?.ok) {
    const status = context?.reason === "invalid_token" ? 401 : 422;
    return json(context, status);
  }

  const recipients = (context.recipients ?? []) as string[];
  if (recipients.length === 0) {
    return json({ ok: true, delivered: 0, reason: "no_recipients" });
  }
  const reservationId = context.reservationId as string | undefined;
  if (!reservationId) {
    return json({ error: "Notification reservation is missing" }, 500);
  }
  const finalizeReservation = async (userIds: string[]) => {
    const { error: finalizeError } = await supabase.rpc(
      "finalize_mini_app_push",
      {
        p_app_id: context.appId,
        p_reservation_id: reservationId,
        p_user_ids: userIds,
      },
    );
    if (finalizeError) throw finalizeError;
  };

  const page = typeof body.page === "string" && body.page.startsWith("/")
    ? `?page=${encodeURIComponent(body.page)}`
    : "";
  const push = {
    title: `${context.appName}: ${title}`,
    body: body.body ?? "",
    route: `/services/apps/${context.slug}/run${page}`,
    type: "mini_app",
  };

  const coreDb = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    { db: { schema: "core" } },
  );
  const { data: devices, error: devicesError } = await coreDb
    .from("user_devices")
    .select("user_id, fcm_token, platform, cns_endpoint_arn")
    .in("user_id", recipients);
  if (devicesError) {
    await finalizeReservation([]);
    return json(
      { error: `Device lookup failed: ${devicesError.message}` },
      500,
    );
  }
  if (!devices || devices.length === 0) {
    await finalizeReservation([]);
    return json({ ok: true, delivered: 0, reason: "no_devices" });
  }

  let delivered = 0;
  const staleTokens: string[] = [];
  const reached = new Set<string>();
  await Promise.all(
    devices.map(async (device) => {
      try {
        let arn = device.cns_endpoint_arn as string | null;
        if (!arn) {
          const channel = channelArnFor((device.platform as string) ?? "");
          if (!channel) return; // платформа без настроенного канала
          arn = await createPlatformEndpoint(
            cns,
            channel,
            device.fcm_token as string,
          );
          await coreDb
            .from("user_devices")
            .update({ cns_endpoint_arn: arn })
            .eq("fcm_token", device.fcm_token as string);
        }
        await publishPush(cns, arn, push);
        delivered++;
        reached.add(device.user_id as string);
      } catch (e) {
        if (isStaleEndpointError(e)) {
          staleTokens.push(device.fcm_token as string);
        }
      }
    }),
  );

  if (staleTokens.length > 0) {
    await coreDb.from("user_devices").delete().in("fcm_token", staleTokens);
  }
  await finalizeReservation([...reached]);

  return json({ ok: true, delivered, users: reached.size });
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

function json(payload: unknown, status = 200): Response {
  return new Response(JSON.stringify(payload), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}
