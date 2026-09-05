import { createClient } from "npm:@supabase/supabase-js@2.110.2";
import { type CnsConfig, cnsConfigFromEnv, type PushContent } from "./cns.ts";
import { pushBatchBudget, pushRpcFetch } from "./push_budget.ts";
import {
  cnsDelivery,
  deliverToDevice,
  type DeliveryDependencies,
  isPushDevice,
  isRecord,
  type PushDevice,
} from "./push_delivery.ts";

export interface PushStore {
  devices(userId: string): Promise<PushDevice[]>;
  cache(userId: string, token: string, arn: string): Promise<void>;
  friend(
    id: string,
  ): Promise<
    { requester_id: string; addressee_id: string; status: string } | null
  >;
  actorName(userId: string): Promise<string>;
}

export interface PushWebhookDependencies {
  now?(): number;
  secret(): string | undefined;
  config(): CnsConfig | null;
  store(): PushStore;
  delivery: DeliveryDependencies;
}

const uuid = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
const validId = (value: unknown): value is string =>
  typeof value === "string" && uuid.test(value);
const optionalText = (value: unknown, limit: number) =>
  value === undefined || typeof value === "string" && value.length <= limit;

export function createPushWebhook(
  kind: "app" | "friends",
  dependencies: PushWebhookDependencies,
) {
  return async (request: Request): Promise<Response> => {
    const canStartBatch = pushBatchBudget(dependencies.now);
    if (request.method !== "POST") {
      return json({ error: "Method not allowed" }, 405);
    }
    const secret = dependencies.secret();
    if (!secret || request.headers.get("x-push-secret") !== secret) {
      return json({ error: "Unauthorized" }, 401);
    }
    let value: unknown;
    try {
      value = await request.json();
    } catch {
      return json({ error: "Invalid JSON" }, 400);
    }
    if (
      !isRecord(value) || !optionalText(value.notification_id, 36) ||
      (value.notification_id !== undefined && !validId(value.notification_id))
    ) {
      return json({ error: "Invalid notification payload" }, 400);
    }
    let recipient: string;
    if (kind === "app") {
      if (
        !validId(value.recipient_id) || typeof value.title !== "string" ||
        !value.title.trim() || value.title.length > 200 ||
        !optionalText(value.body, 2000) ||
        !optionalText(value.route, 2048) || !optionalText(value.type, 80)
      ) {
        return json({ error: "Invalid notification payload" }, 400);
      }
      recipient = value.recipient_id;
    } else {
      if (
        !["friend_request", "friend_accepted"].includes(String(value.event)) ||
        !validId(value.friendship_id) || !validId(value.requester_id) ||
        !validId(value.addressee_id) ||
        value.requester_id === value.addressee_id
      ) {
        return json({ error: "Invalid friendship payload" }, 400);
      }
      recipient = value.event === "friend_request"
        ? value.addressee_id
        : value.requester_id;
    }
    const config = dependencies.config();
    if (!config) {
      return json({ error: "Notification service is unavailable" }, 503);
    }
    let store: PushStore;
    let devices: PushDevice[];
    let push: PushContent;
    try {
      store = dependencies.store();
      if (kind === "friends") {
        const friend = await store.friend(value.friendship_id as string);
        if (
          !friend || friend.requester_id !== value.requester_id ||
          friend.addressee_id !== value.addressee_id ||
          friend.status !==
            (value.event === "friend_request" ? "pending" : "accepted")
        ) {
          return json({ error: "Friendship event no longer matches" }, 409);
        }
        const actor = value.event === "friend_request"
          ? friend.requester_id
          : friend.addressee_id;
        const name = (await store.actorName(actor)).slice(0, 200);
        push = {
          title: value.event === "friend_request"
            ? "Новая заявка в друзья 🥷"
            : "Заявка принята 🎉",
          body: value.event === "friend_request"
            ? `${name} хочет добавить тебя`
            : `${name} теперь у тебя в друзьях`,
          route: "/services/people?tab=friends",
          type: value.event as string,
          friendship_id: value.friendship_id as string,
        };
      } else {
        push = {
          title: value.title as string,
          body: value.body as string ?? "",
          route: value.route as string ?? "",
          type: value.type as string ?? "app_event",
        };
      }
      if (value.notification_id) {
        push.notification_id = value.notification_id as string;
      }
      devices = await store.devices(recipient);
      if (
        !Array.isArray(devices) || !devices.every(isPushDevice) ||
        devices.some((device) => device.user_id !== recipient)
      ) {
        throw new Error("Invalid devices");
      }
    } catch {
      return json({ error: "Notification lookup failed" }, 500);
    }
    const unique = [
      ...new Map(devices.map((device) => [device.fcm_token, device])).values(),
    ];
    const results = [];
    let deferred = 0;
    for (let index = 0; index < unique.length; index += 8) {
      if (!canStartBatch()) {
        deferred = unique.length - index;
        break;
      }
      results.push(
        ...await Promise.all(
          unique.slice(index, index + 8).map((device) =>
            deliverToDevice(
              config,
              device,
              push,
              (arn) => store.cache(recipient, device.fcm_token, arn),
              dependencies.delivery,
            )
          ),
        ),
      );
    }
    const delivered = results.filter((result) => result === "delivered").length;
    if (results.includes("storage_failure")) {
      return json(
        { error: "Notification device update failed", delivered, deferred },
        500,
      );
    }
    const failed = results.length - delivered;
    if (deferred > 0) {
      return json({
        error: "Notification delivery time budget exceeded",
        delivered,
        failed,
        deferred,
      }, 503);
    }
    if (failed > 0) {
      return json(
        { error: "Notification delivery failed", delivered, failed },
        502,
      );
    }
    return json({
      delivered,
      removedStale: 0,
      ...(devices.length === 0 ? { reason: "no devices" } : {}),
    });
  };
}

export const pushWebhookDependencies: PushWebhookDependencies = {
  secret: () => Deno.env.get("PUSH_WEBHOOK_SECRET"),
  config: cnsConfigFromEnv,
  delivery: cnsDelivery,
  store: () => {
    const client = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
      { global: { fetch: pushRpcFetch } },
    );
    const names = new Map<string, string>();
    return {
      async devices(userId) {
        const result = await client.rpc("get_app_push_devices", {
          p_user_id: userId,
        });
        if (result.error) throw new Error("Device lookup failed");
        return result.data as PushDevice[];
      },
      async cache(userId, token, arn) {
        const result = await client.rpc("set_app_push_endpoint", {
          p_user_id: userId,
          p_fcm_token: token,
          p_endpoint_arn: arn,
        });
        if (result.error || result.data !== true) {
          throw new Error("Device update failed");
        }
      },
      async friend(id) {
        const result = await client.rpc("get_friend_push_context", {
          p_friendship_id: id,
        });
        if (result.error) throw new Error("Friendship lookup failed");
        if (result.data) {
          for (const side of ["requester", "addressee"]) {
            const name = result.data[`${side}_name`];
            names.set(
              result.data[`${side}_id`],
              typeof name === "string" && name.trim() ? name.trim() : "Кто-то",
            );
          }
        }
        return result.data;
      },
      actorName(userId) {
        return Promise.resolve(names.get(userId) || "Кто-то");
      },
    };
  },
};

function json(value: unknown, status = 200): Response {
  return new Response(JSON.stringify(value), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}
