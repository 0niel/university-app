const CNS_HOST = "notifications.yandexcloud.net";
const CNS_REGION = "ru-central1";
const CNS_SERVICE = "sns";

export interface CnsConfig {
  accessKeyId: string;
  secretKey: string;
}

export function cnsConfigFromEnv(): CnsConfig | null {
  const accessKeyId = Deno.env.get("CNS_ACCESS_KEY_ID");
  const secretKey = Deno.env.get("CNS_SECRET_KEY");
  if (!accessKeyId || !secretKey) return null;
  return { accessKeyId, secretKey };
}

export function channelArnFor(
  platform: string,
  env: (name: string) => string | undefined = (name) => Deno.env.get(name),
): string | null {
  const key = switchPlatform(platform, {
    fcm: "CNS_CHANNEL_ARN_FCM",
    apns: "CNS_CHANNEL_ARN_APNS",
    hms: "CNS_CHANNEL_ARN_HMS",
    rustore: "CNS_CHANNEL_ARN_RUSTORE",
  });
  return key ? env(key) ?? null : null;
}

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
  let arn: unknown;
  try {
    const value = JSON.parse(body);
    arn = value?.CreatePlatformEndpointResponse?.CreatePlatformEndpointResult
      ?.EndpointArn ??
      value?.CreatePlatformEndpointResult?.EndpointArn ?? value?.EndpointArn;
  } catch {
    arn = /<EndpointArn>([^<]+)<\/EndpointArn>/.exec(body)?.[1]
      ?.replace(
        /&(amp|lt|gt|quot|apos);/g,
        (
          _,
          entity: string,
        ) => ({ amp: "&", lt: "<", gt: ">", quot: '"', apos: "'" }[entity]!),
      );
  }
  if (typeof arn !== "string" || !arn || arn.includes("\\")) {
    throw new Error("CreatePlatformEndpoint: no ARN");
  }
  return arn;
}

export interface PushContent {
  title: string;
  body: string;
  route: string;
  type: string;
  notification_id?: string;
  friendship_id?: string;
}

export async function publishPush(
  config: CnsConfig,
  endpointArn: string,
  push: PushContent,
): Promise<void> {
  const data = {
    type: push.type,
    route: push.route,
    ...(push.notification_id ? { notification_id: push.notification_id } : {}),
    ...(push.friendship_id ? { friendship_id: push.friendship_id } : {}),
  };
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

export function isStaleEndpointError(error: unknown): boolean {
  return error instanceof CnsRequestError && error.action === "Publish" &&
    (error.code === "EndpointDisabled" || error.subCode === "EndpointDisabled");
}

export function isMissingEndpointError(error: unknown): boolean {
  return error instanceof CnsRequestError && error.action === "Publish" &&
    (error.code === "EndpointNotFound" ||
      (error.code === "NotFound" && error.subCode === "EndpointNotFound"));
}

export function endpointMatchesChannel(
  endpointArn: string,
  channelArn: string,
): boolean {
  if (!channelArn.includes(":app/")) return false;
  return endpointArn.startsWith(
    channelArn.replace(":app/", ":endpoint/") + "/",
  );
}

export async function enablePlatformEndpoint(
  config: CnsConfig,
  endpointArn: string,
  token: string,
): Promise<void> {
  await cnsCall(config, {
    Action: "SetEndpointAttributes",
    EndpointArn: endpointArn,
    "Attributes.entry.1.key": "Enabled",
    "Attributes.entry.1.value": "true",
    "Attributes.entry.2.key": "Token",
    "Attributes.entry.2.value": token,
  });
}

class CnsRequestError extends Error {
  readonly code: string;
  readonly subCode: string;

  constructor(readonly action: string, status: number, body: string) {
    super(`CNS ${action} failed (${status})`);
    let fields: Record<string, unknown> = {};
    try {
      const parsed = JSON.parse(body);
      const detail = parsed?.ErrorResponse?.Error ?? parsed?.Error;
      if (detail && typeof detail === "object" && !Array.isArray(detail)) {
        fields = detail;
      }
    } catch {
      fields = {
        Code: /<Code>\s*([A-Za-z0-9]+)\s*<\/Code>/.exec(body)?.[1],
        SubCode: /<Sub[Cc]ode>\s*([A-Za-z0-9]+)\s*<\/Sub[Cc]ode>/.exec(body)
          ?.[1],
      };
    }
    this.code = typeof fields.Code === "string" ? fields.Code : "";
    const subCode = fields.Subcode ?? fields.SubCode;
    this.subCode = typeof subCode === "string" ? subCode : "";
  }
}

async function cnsCall(
  config: CnsConfig,
  params: Record<string, string>,
): Promise<string> {
  const body = new URLSearchParams({
    ...params,
    ResponseFormat: "JSON",
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
    signal: AbortSignal.timeout(15000),
  });
  const text = await response.text();
  if (!response.ok) {
    throw new CnsRequestError(params.Action, response.status, text);
  }
  return text;
}

function switchPlatform(
  platform: string,
  map: Record<string, string>,
): string | null {
  const normalized = platform.trim().toLowerCase();
  if (normalized === "apns" || normalized === "apns_sandbox") {
    return map.apns;
  }
  if (normalized.includes("huawei") || normalized.includes("hms")) {
    return map.hms;
  }
  if (normalized.includes("rustore")) return map.rustore;
  return ["android", "ios", "web", "fcm", ""].includes(normalized)
    ? map.fcm
    : null;
}

async function hmac(
  key: Uint8Array,
  payload: string,
): Promise<Uint8Array> {
  const cryptoKey = await crypto.subtle.importKey(
    "raw",
    new Uint8Array(key),
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
