// friends-push — delivers FCM pushes for friendship events.
//
// Called by the core.friendships triggers via pg_net (see migration
// 20260611150000). Auth: shared secret header, NOT a user JWT — deploy with
// verify_jwt=false and set the same secret on both sides:
//
//   supabase secrets set PUSH_WEBHOOK_SECRET=<random> \
//     FCM_SERVICE_ACCOUNT='<firebase service-account json>'
//   insert into internal.app_config(key, value) values
//     ('friends_push_url',
//      'https://<ref>.supabase.co/functions/v1/friends-push'),
//     ('friends_push_secret', '<the same random>');
import { createClient } from "@supabase/supabase-js";

interface PushPayload {
  event: "friend_request" | "friend_accepted";
  friendship_id: string;
  requester_id: string;
  addressee_id: string;
}

Deno.serve(async (req: Request) => {
  if (req.method !== "POST") {
    return json({ error: "Method not allowed" }, 405);
  }

  const secret = Deno.env.get("PUSH_WEBHOOK_SECRET");
  if (!secret || req.headers.get("x-push-secret") !== secret) {
    return json({ error: "Unauthorized" }, 401);
  }

  const serviceAccountRaw = Deno.env.get("FCM_SERVICE_ACCOUNT");
  if (!serviceAccountRaw) {
    return json({ error: "FCM_SERVICE_ACCOUNT secret is not set" }, 503);
  }

  let payload: PushPayload;
  try {
    payload = await req.json();
  } catch {
    return json({ error: "Invalid JSON" }, 400);
  }

  // Who gets the push and whose name is in it.
  const recipientId =
    payload.event === "friend_request"
      ? payload.addressee_id
      : payload.requester_id;
  const actorId =
    payload.event === "friend_request"
      ? payload.requester_id
      : payload.addressee_id;

  // Service-role client: read device tokens + the actor's display name.
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    { db: { schema: "core" } },
  );

  const [{ data: devices }, { data: profile }] = await Promise.all([
    supabase
      .from("user_devices")
      .select("fcm_token")
      .eq("user_id", recipientId),
    supabase
      .from("user_academic_profiles")
      .select("full_name")
      .eq("user_id", actorId)
      .maybeSingle(),
  ]);
  if (!devices || devices.length === 0) {
    return json({ delivered: 0, reason: "no devices" });
  }

  const actorName = profile?.full_name ?? "Кто-то";
  const [title, body] =
    payload.event === "friend_request"
      ? ["Новая заявка в друзья 🥷", `${actorName} хочет добавить тебя`]
      : ["Заявка принята 🎉", `${actorName} теперь у тебя в друзьях`];

  const serviceAccount = JSON.parse(serviceAccountRaw) as {
    project_id: string;
    client_email: string;
    private_key: string;
  };
  const accessToken = await mintFcmAccessToken(serviceAccount);

  let delivered = 0;
  const stale: string[] = [];
  await Promise.all(
    devices.map(async ({ fcm_token }) => {
      const res = await fetch(
        `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`,
        {
          method: "POST",
          headers: {
            Authorization: `Bearer ${accessToken}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            message: {
              token: fcm_token,
              notification: { title, body },
              data: {
                type: payload.event,
                friendship_id: payload.friendship_id,
              },
              android: { priority: "high" },
            },
          }),
        },
      );
      if (res.ok) {
        delivered++;
      } else if (res.status === 404 || res.status === 400) {
        stale.push(fcm_token); // token no longer valid — clean up
      }
    }),
  );

  if (stale.length > 0) {
    await supabase.from("user_devices").delete().in("fcm_token", stale);
  }

  return json({ delivered, removedStale: stale.length });
});

/// OAuth2 access token for FCM via service-account JWT (RS256).
async function mintFcmAccessToken(account: {
  client_email: string;
  private_key: string;
}): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const header = b64url(JSON.stringify({ alg: "RS256", typ: "JWT" }));
  const claims = b64url(
    JSON.stringify({
      iss: account.client_email,
      scope: "https://www.googleapis.com/auth/firebase.messaging",
      aud: "https://oauth2.googleapis.com/token",
      iat: now,
      exp: now + 3600,
    }),
  );

  const pem = account.private_key
    .replace("-----BEGIN PRIVATE KEY-----", "")
    .replace("-----END PRIVATE KEY-----", "")
    .replaceAll("\\n", "")
    .replaceAll("\n", "");
  const key = await crypto.subtle.importKey(
    "pkcs8",
    Uint8Array.from(atob(pem), (c) => c.charCodeAt(0)),
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const signature = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    key,
    new TextEncoder().encode(`${header}.${claims}`),
  );
  const jwt = `${header}.${claims}.${b64urlBytes(new Uint8Array(signature))}`;

  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });
  if (!res.ok) {
    throw new Error(`FCM token mint failed: ${res.status}`);
  }
  const data = (await res.json()) as { access_token: string };
  return data.access_token;
}

function b64url(value: string): string {
  return btoa(value)
    .replaceAll("+", "-")
    .replaceAll("/", "_")
    .replace(/=+$/, "");
}

function b64urlBytes(bytes: Uint8Array): string {
  let binary = "";
  for (const byte of bytes) binary += String.fromCharCode(byte);
  return b64url(binary).replace(/=+$/, "");
}

function json(payload: unknown, status = 200): Response {
  return new Response(JSON.stringify(payload), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}
