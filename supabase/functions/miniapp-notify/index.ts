import { createClient } from "@supabase/supabase-js";
import {
  channelArnFor,
  type CnsConfig,
  cnsConfigFromEnv,
  createPlatformEndpoint,
  isMissingEndpointError,
  isStaleEndpointError,
  publishPush,
  type PushContent,
} from "./cns.ts";

export interface NotificationRpc {
  rpc(
    name: string,
    parameters: Record<string, unknown>,
  ): PromiseLike<{ data: unknown; error: unknown }>;
}

export interface NotificationDependencies {
  config(): CnsConfig | null;
  client(): NotificationRpc;
  channel(platform: string): string | null;
  endpoint(config: CnsConfig, channel: string, token: string): Promise<string>;
  publish(config: CnsConfig, arn: string, push: PushContent): Promise<void>;
  stale(error: unknown): boolean;
  missing(error: unknown): boolean;
}

type Device = {
  user_id: string;
  fcm_token: string;
  platform: string | null;
  cns_endpoint_arn: string | null;
};

function isRecord(value: unknown): value is Record<string, unknown> {
  return value !== null && typeof value === "object" && !Array.isArray(value);
}

function isDevice(value: unknown): value is Device {
  return isRecord(value) && typeof value.user_id === "string" &&
    typeof value.fcm_token === "string" && value.fcm_token.length > 0 &&
    (value.platform == null || typeof value.platform === "string") &&
    (value.cns_endpoint_arn == null ||
      typeof value.cns_endpoint_arn === "string");
}

export function createNotificationHandler(
  dependencies: NotificationDependencies,
) {
  return async (req: Request): Promise<Response> => {
    if (req.method !== "POST") {
      return json({ error: "Method not allowed" }, 405);
    }
    const token = (req.headers.get("Authorization") ?? "")
      .replace(/^Bearer\s+/i, "").trim();
    if (!/^man_[0-9a-f]{48}$/.test(token)) {
      return json({ error: "Invalid deploy token" }, 401);
    }
    let body: unknown;
    try {
      body = await req.json();
    } catch {
      return json({ error: "Invalid JSON" }, 400);
    }
    if (
      !isRecord(body) || typeof body.organizationId !== "string" ||
      !body.organizationId.trim() || typeof body.slug !== "string" ||
      !body.slug.trim() || typeof body.title !== "string" ||
      !body.title.trim() ||
      (body.body !== undefined && typeof body.body !== "string") ||
      (body.page !== undefined && typeof body.page !== "string")
    ) {
      return json(
        { error: "organizationId, slug and title are required" },
        400,
      );
    }
    const title = body.title.trim();
    const message = typeof body.body === "string" ? body.body : "";
    if (title.length > 80 || message.length > 200) {
      return json({ error: "title ≤ 80 chars, body ≤ 200 chars" }, 400);
    }
    const config = dependencies.config();
    if (!config) {
      return json({ error: "Notification service is unavailable" }, 503);
    }
    let client: NotificationRpc;
    let context: Record<string, unknown>;
    try {
      client = dependencies.client();
      const lookup = await client.rpc("mini_app_notify_context", {
        p_token_hash: await sha256Hex(token),
        p_organization_id: body.organizationId,
        p_slug: body.slug,
      });
      if (lookup.error || !isRecord(lookup.data)) {
        return json({ error: "Notification lookup failed" }, 500);
      }
      context = lookup.data;
    } catch {
      return json({ error: "Notification lookup failed" }, 500);
    }
    if (context.ok !== true) {
      const reason = [
          "invalid_token",
          "app_not_found",
          "not_published",
          "scope_not_requested",
        ]
          .includes(String(context.reason))
        ? String(context.reason)
        : "unavailable";
      return json(
        { ok: false, reason },
        reason === "invalid_token" ? 401 : 422,
      );
    }
    if (
      !Array.isArray(context.recipients) ||
      !context.recipients.every((user) => typeof user === "string")
    ) {
      return json({ error: "Invalid notification reservation" }, 500);
    }
    if (context.recipients.length === 0) {
      return json({ ok: true, delivered: 0, reason: "no_recipients" });
    }
    if (
      typeof context.reservationId !== "string" || !context.reservationId ||
      typeof context.appId !== "string" || !context.appId ||
      typeof context.appName !== "string" || typeof context.slug !== "string"
    ) {
      return json({ error: "Invalid notification reservation" }, 500);
    }
    const scope = {
      p_app_id: context.appId,
      p_reservation_id: context.reservationId,
    };
    const finalize = async (users: string[]): Promise<boolean> => {
      try {
        const result = await client.rpc("finalize_mini_app_push", {
          ...scope,
          p_user_ids: users,
        });
        return !result.error;
      } catch {
        return false;
      }
    };
    let devices: Device[];
    try {
      const result = await client.rpc("mini_app_push_devices", scope);
      if (
        result.error || !Array.isArray(result.data) ||
        !result.data.every(isDevice)
      ) {
        await finalize([]);
        return json({ error: "Notification device lookup failed" }, 500);
      }
      const recipients = new Set(context.recipients);
      if (result.data.some((device) => !recipients.has(device.user_id))) {
        await finalize([]);
        return json({ error: "Invalid notification devices" }, 500);
      }
      devices = result.data;
    } catch {
      await finalize([]);
      return json({ error: "Notification device lookup failed" }, 500);
    }
    if (devices.length === 0) {
      if (!await finalize([])) {
        return json({ error: "Notification finalization failed" }, 500);
      }
      return json({ ok: true, delivered: 0, reason: "no_devices" });
    }
    const page = typeof body.page === "string" && body.page.startsWith("/")
      ? "?page=" + encodeURIComponent(body.page)
      : "";
    const push: PushContent = {
      title: context.appName + ": " + title,
      body: message,
      route: "/services/apps/" + context.slug + "/run" + page,
      type: "mini_app",
    };
    let delivered = 0;
    let storageFailed = false;
    const staleTokens: string[] = [];
    const reached = new Set<string>();
    await Promise.all(devices.map(async (device) => {
      try {
        const createEndpoint = async (): Promise<string | null> => {
          const channel = dependencies.channel(device.platform ?? "");
          if (!channel) return null;
          const arn = await dependencies.endpoint(
            config,
            channel,
            device.fcm_token,
          );
          try {
            const cached = await client.rpc("set_mini_app_push_endpoint", {
              ...scope,
              p_fcm_token: device.fcm_token,
              p_endpoint_arn: arn,
            });
            if (cached.error) {
              storageFailed = true;
              return null;
            }
          } catch {
            storageFailed = true;
            return null;
          }
          return arn;
        };
        const arn = device.cns_endpoint_arn || await createEndpoint();
        if (!arn) return;
        try {
          await dependencies.publish(config, arn, push);
        } catch (error) {
          if (!device.cns_endpoint_arn || !dependencies.missing(error)) {
            throw error;
          }
          const replacement = await createEndpoint();
          if (!replacement) return;
          await dependencies.publish(config, replacement, push);
        }
        delivered++;
        reached.add(device.user_id);
      } catch (error) {
        if (dependencies.stale(error)) staleTokens.push(device.fcm_token);
      }
    }));
    if (staleTokens.length > 0) {
      try {
        const removed = await client.rpc("delete_mini_app_push_devices", {
          ...scope,
          p_fcm_tokens: staleTokens,
        });
        if (removed.error) storageFailed = true;
      } catch {
        storageFailed = true;
      }
    }
    if (!await finalize([...reached])) {
      return json({ error: "Notification finalization failed" }, 500);
    }
    if (storageFailed) {
      return json({ error: "Notification device update failed" }, 500);
    }
    return json({ ok: true, delivered, users: reached.size });
  };
}

Deno.serve(createNotificationHandler({
  config: cnsConfigFromEnv,
  client: () =>
    createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    ),
  channel: channelArnFor,
  endpoint: createPlatformEndpoint,
  publish: publishPush,
  stale: isStaleEndpointError,
  missing: isMissingEndpointError,
}));

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
