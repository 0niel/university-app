import {
  channelArnFor,
  type CnsConfig,
  createPlatformEndpoint,
  enablePlatformEndpoint,
  endpointMatchesChannel,
  isMissingEndpointError,
  isStaleEndpointError,
  publishPush,
  type PushContent,
} from "./cns.ts";

export interface PushDevice {
  user_id: string;
  fcm_token: string;
  platform: string | null;
  cns_endpoint_arn: string | null;
}

export interface DeliveryDependencies {
  channel(platform: string): string | null;
  endpoint(config: CnsConfig, channel: string, token: string): Promise<string>;
  publish(config: CnsConfig, arn: string, push: PushContent): Promise<void>;
  enable(config: CnsConfig, arn: string, token: string): Promise<void>;
  missing(error: unknown): boolean;
  disabled(error: unknown): boolean;
  matches(arn: string, channel: string): boolean;
}

export const cnsDelivery: DeliveryDependencies = {
  channel: channelArnFor,
  endpoint: createPlatformEndpoint,
  publish: publishPush,
  enable: enablePlatformEndpoint,
  missing: isMissingEndpointError,
  disabled: isStaleEndpointError,
  matches: endpointMatchesChannel,
};

export async function deliverToDevice(
  config: CnsConfig,
  device: PushDevice,
  push: PushContent,
  cache: (arn: string) => Promise<void>,
  dependencies = cnsDelivery,
): Promise<"delivered" | "unavailable" | "storage_failure" | "failed"> {
  const channel = dependencies.channel(device.platform ?? "");
  if (!channel) return "unavailable";
  let storageFailed = false;
  const create = async () => {
    const arn = await dependencies.endpoint(config, channel, device.fcm_token);
    try {
      await cache(arn);
    } catch {
      storageFailed = true;
      throw new Error("Endpoint cache failed");
    }
    return arn;
  };
  try {
    const cached = device.cns_endpoint_arn;
    const arn = cached && dependencies.matches(cached, channel)
      ? cached
      : await create();
    try {
      await dependencies.publish(config, arn, push);
    } catch (error) {
      if (dependencies.missing(error)) {
        const replacement = await create();
        await dependencies.publish(config, replacement, push);
      } else if (dependencies.disabled(error)) {
        await dependencies.enable(config, arn, device.fcm_token);
        await dependencies.publish(config, arn, push);
      } else {
        throw error;
      }
    }
    return "delivered";
  } catch {
    return storageFailed ? "storage_failure" : "failed";
  }
}

export function isRecord(value: unknown): value is Record<string, unknown> {
  return value !== null && typeof value === "object" && !Array.isArray(value);
}

export function isPushDevice(value: unknown): value is PushDevice {
  return isRecord(value) && typeof value.user_id === "string" &&
    typeof value.fcm_token === "string" && value.fcm_token.length > 0 &&
    (value.platform === null || typeof value.platform === "string") &&
    (value.cns_endpoint_arn === null ||
      typeof value.cns_endpoint_arn === "string");
}
