// Yandex Cloud Notification Service (CNS) client — SNS-compatible Query
// API at https://notifications.yandexcloud.net/ signed with AWS SigV4
// (region ru-central1, service sns, static access key of a service
// account).
//
// Secrets:
//   CNS_ACCESS_KEY_ID / CNS_SECRET_KEY — статический ключ сервисного
//     аккаунта с ролью editor на каталог с каналами уведомлений;
//   CNS_CHANNEL_ARN_FCM / _APNS / _HMS / _RUSTORE — ARN каналов
//     (создаются в консоли: Cloud Notification Service → создать канал).

const CNS_HOST = "notifications.yandexcloud.net";
const CNS_REGION = "ru-central1";
const CNS_SERVICE = "sns";

export interface CnsConfig {
  accessKeyId: string;
  secretKey: string;
}

/// Reads the CNS credentials, null when not configured.
export function cnsConfigFromEnv(): CnsConfig | null {
  const accessKeyId = Deno.env.get("CNS_ACCESS_KEY_ID");
  const secretKey = Deno.env.get("CNS_SECRET_KEY");
  if (!accessKeyId || !secretKey) return null;
  return { accessKeyId, secretKey };
}

/// Notification channel ARN for a device platform, null when the platform
/// has no configured channel.
export function channelArnFor(platform: string): string | null {
  const key = switchPlatform(platform, {
    fcm: "CNS_CHANNEL_ARN_FCM",
    apns: "CNS_CHANNEL_ARN_APNS",
    hms: "CNS_CHANNEL_ARN_HMS",
    rustore: "CNS_CHANNEL_ARN_RUSTORE",
  });
  return key ? Deno.env.get(key) ?? null : null;
}

/// Registers a device push token as a CNS endpoint; returns its ARN.
export async function createPlatformEndpoint(
  config: CnsConfig,
  channelArn: string,
  token: string,
): Promise<string> {
  const body = await cnsCall(config, {
    Action: "CreatePlatformEndpoint",
    PlatformApplicationArn: channelArn,
    Token: token,
  });
  const arn = /"EndpointArn"\s*:\s*"([^"]+)"/.exec(body)?.[1] ??
    /<EndpointArn>([^<]+)<\/EndpointArn>/.exec(body)?.[1];
  if (!arn) throw new Error(`CreatePlatformEndpoint: no ARN in ${body}`);
  return arn;
}

export interface PushContent {
  title: string;
  body: string;
  route: string;
  type: string;
}

/// Sends one push to a CNS endpoint. The message carries payloads for all
/// mobile platforms — CNS picks the one matching the endpoint's channel.
export async function publishPush(
  config: CnsConfig,
  endpointArn: string,
  push: PushContent,
): Promise<void> {
  const data = { type: push.type, route: push.route };
  const gcm = JSON.stringify({
    notification: { title: push.title, body: push.body },
    data,
  });
  const message = JSON.stringify({
    default: push.body || push.title,
    GCM: gcm,
    APNS: JSON.stringify({
      aps: { alert: { title: push.title, body: push.body } },
      ...data,
    }),
    // HMS / RuStore channels accept the FCM-like shape.
    HMS: gcm,
    RUSTORE: gcm,
  });
  await cnsCall(config, {
    Action: "Publish",
    TargetArn: endpointArn,
    Message: message,
    MessageStructure: "json",
  });
}

/// True when the error text means the token/endpoint is dead and the
/// device row should be dropped.
export function isStaleEndpointError(error: unknown): boolean {
  const text = `${error}`;
  return text.includes("EndpointDisabled") ||
    text.includes("InvalidParameter") ||
    text.includes("NotFound");
}

/// Signed SNS Query call; throws with the response body on non-2xx.
async function cnsCall(
  config: CnsConfig,
  params: Record<string, string>,
): Promise<string> {
  const body = new URLSearchParams({
    ...params,
    ResponseFormat: "json",
  }).toString();

  const now = new Date();
  const amzDate = now.toISOString().replace(/[-:]/g, "").replace(/\.\d+/, "");
  const dateStamp = amzDate.slice(0, 8);
  const contentType = "application/x-www-form-urlencoded; charset=utf-8";

  const canonicalHeaders = `content-type:${contentType}\n` +
    `host:${CNS_HOST}\n` +
    `x-amz-date:${amzDate}\n`;
  const signedHeaders = "content-type;host;x-amz-date";
  const canonicalRequest = [
    "POST",
    "/",
    "",
    canonicalHeaders,
    signedHeaders,
    await sha256Hex(body),
  ].join("\n");

  const scope = `${dateStamp}/${CNS_REGION}/${CNS_SERVICE}/aws4_request`;
  const stringToSign = [
    "AWS4-HMAC-SHA256",
    amzDate,
    scope,
    await sha256Hex(canonicalRequest),
  ].join("\n");

  let key = await hmac(
    new TextEncoder().encode(`AWS4${config.secretKey}`),
    dateStamp,
  );
  key = await hmac(key, CNS_REGION);
  key = await hmac(key, CNS_SERVICE);
  key = await hmac(key, "aws4_request");
  const signature = toHex(await hmac(key, stringToSign));

  const response = await fetch(`https://${CNS_HOST}/`, {
    method: "POST",
    headers: {
      "Content-Type": contentType,
      "X-Amz-Date": amzDate,
      Authorization: `AWS4-HMAC-SHA256 Credential=${config.accessKeyId}/` +
        `${scope}, SignedHeaders=${signedHeaders}, Signature=${signature}`,
    },
    body,
  });
  const text = await response.text();
  if (!response.ok) {
    throw new Error(`CNS ${params.Action} failed (${response.status}): ${text}`);
  }
  return text;
}

function switchPlatform(
  platform: string,
  map: Record<string, string>,
): string | null {
  const normalized = platform.toLowerCase();
  if (normalized.includes("ios") || normalized.includes("apns")) {
    return map.apns;
  }
  if (normalized.includes("huawei") || normalized.includes("hms")) {
    return map.hms;
  }
  if (normalized.includes("rustore")) return map.rustore;
  return map.fcm; // android and everything else default to FCM
}

async function hmac(
  key: Uint8Array,
  payload: string,
): Promise<Uint8Array> {
  const cryptoKey = await crypto.subtle.importKey(
    "raw",
    key,
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const signature = await crypto.subtle.sign(
    "HMAC",
    cryptoKey,
    new TextEncoder().encode(payload),
  );
  return new Uint8Array(signature);
}

async function sha256Hex(value: string): Promise<string> {
  const digest = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(value),
  );
  return toHex(new Uint8Array(digest));
}

function toHex(bytes: Uint8Array): string {
  return [...bytes].map((b) => b.toString(16).padStart(2, "0")).join("");
}
