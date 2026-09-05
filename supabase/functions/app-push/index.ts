// app-push — generic push delivery for app events (mentor requests,
// team applications, etc.).
//
// Called by DB triggers via pg_net (internal.notify_app_push). Auth: shared
// secret header, NOT a user JWT — deployed with verify_jwt=false:
//
//   supabase secrets set PUSH_WEBHOOK_SECRET=<random> \
//     CNS_ACCESS_KEY_ID=<key id> CNS_SECRET_KEY=<secret> \
//     CNS_CHANNEL_ARN_FCM=<arn> [CNS_CHANNEL_ARN_APNS=<arn> ...]
//   insert into internal.app_config(key, value) values
//     ('app_push_url', 'https://<ref>.supabase.co/functions/v1/app-push'),
//     ('app_push_secret', '<the same random>');
//
// Доставка — через Yandex Cloud Notification Service (см. cns.ts): один
// Publish на устройство, CNS сам доставляет в FCM/APNs/HMS/RuStore по
// типу канала. Эндпоинты создаются лениво и кешируются в
// core.user_devices.cns_endpoint_arn.
//
// Payload: { recipient_id, title, body, route?, type? }
// The `route` lands in the push data and is opened by the app's deep-link
// system when the user taps the notification.
import { createClient } from "@supabase/supabase-js";
import {
  channelArnFor,
  cnsConfigFromEnv,
  createPlatformEndpoint,
  isStaleEndpointError,
  publishPush,
} from "./cns.ts";

interface PushPayload {
  recipient_id: string;
  title: string;
  body: string;
  route?: string;
  type?: string;
  notification_id?: string;
}

Deno.serve(async (req: Request) => {
  if (req.method !== "POST") {
    return json({ error: "Method not allowed" }, 405);
  }

  const secret = Deno.env.get("PUSH_WEBHOOK_SECRET");
  if (!secret || req.headers.get("x-push-secret") !== secret) {
    return json({ error: "Unauthorized" }, 401);
  }

  const cns = cnsConfigFromEnv();
  if (!cns) {
    return json(
      { error: "CNS_ACCESS_KEY_ID / CNS_SECRET_KEY secrets are not set" },
      503,
    );
  }

  let payload: PushPayload;
  try {
    payload = await req.json();
  } catch {
    return json({ error: "Invalid JSON" }, 400);
  }
  if (!payload.recipient_id || !payload.title) {
    return json({ error: "recipient_id and title are required" }, 400);
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    { db: { schema: "core" } },
  );

  const { data: devices } = await supabase
    .from("user_devices")
    .select("fcm_token, platform, cns_endpoint_arn")
    .eq("user_id", payload.recipient_id);
  if (!devices || devices.length === 0) {
    return json({ delivered: 0, reason: "no devices" });
  }

  const push = {
    title: payload.title,
    body: payload.body ?? "",
    route: payload.route ?? "",
    type: payload.type ?? "app_event",
    notification_id: payload.notification_id,
  };

  let delivered = 0;
  const staleTokens: string[] = [];
  await Promise.all(
    devices.map(async (device) => {
      try {
        let arn = device.cns_endpoint_arn as string | null;
        if (!arn) {
          const channel = channelArnFor((device.platform as string) ?? "");
          if (!channel) return;
          arn = await createPlatformEndpoint(
            cns,
            channel,
            device.fcm_token as string,
          );
          await supabase
            .from("user_devices")
            .update({ cns_endpoint_arn: arn })
            .eq("fcm_token", device.fcm_token as string);
        }
        await publishPush(cns, arn, push);
        delivered++;
      } catch (e) {
        if (isStaleEndpointError(e)) {
          staleTokens.push(device.fcm_token as string);
        }
      }
    }),
  );

  if (staleTokens.length > 0) {
    await supabase.from("user_devices").delete().in("fcm_token", staleTokens);
  }

  return json({ delivered, removedStale: staleTokens.length });
});

function json(payload: unknown, status = 200): Response {
  return new Response(JSON.stringify(payload), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}
