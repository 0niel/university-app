import assert from "node:assert/strict";
import {
  channelArnFor,
  enablePlatformEndpoint,
  endpointMatchesChannel,
} from "./cns.ts";
import {
  deliverToDevice,
  type DeliveryDependencies,
  type PushDevice,
} from "./push_delivery.ts";
import {
  createPushWebhook,
  type PushWebhookDependencies,
} from "./push_webhook.ts";

const recipient = "11111111-1111-4111-8111-111111111111";
const sender = "22222222-2222-4222-8222-222222222222";
const friendship = "33333333-3333-4333-8333-333333333333";
const channel = "arn:aws:sns:ru-central1:folder:app/GCM/app";
const endpoint = "arn:aws:sns:ru-central1:folder:endpoint/GCM/app/device";
const config = { accessKeyId: "fixture", secretKey: "fixture" };
const content = {
  title: "Title",
  body: "Body",
  type: "app_event",
  route: "/feed",
};
const device: PushDevice = {
  user_id: recipient,
  fcm_token: "fixture-device",
  platform: "ios",
  cns_endpoint_arn: endpoint,
};

function transport(
  errors: string[] = [],
  options: {
    channel?: string | null;
    cacheFail?: boolean;
    enableFail?: boolean;
  } = {},
) {
  const published: string[] = [];
  const cached: string[] = [];
  const enabled: string[] = [];
  const created: string[] = [];
  const dependencies: DeliveryDependencies = {
    channel: () => options.channel === undefined ? channel : options.channel,
    endpoint: (_config, _channel, token) => {
      created.push(token);
      return Promise.resolve(endpoint + "-replacement");
    },
    publish: (_config, arn) => {
      published.push(arn);
      const error = errors.shift();
      return error ? Promise.reject(new Error(error)) : Promise.resolve();
    },
    enable: (_config, arn) => {
      enabled.push(arn);
      return options.enableFail
        ? Promise.reject(new Error("config error"))
        : Promise.resolve();
    },
    missing: (error) => error instanceof Error && error.message === "missing",
    disabled: (error) => error instanceof Error && error.message === "disabled",
    matches: endpointMatchesChannel,
  };
  const cache = (arn: string) => {
    cached.push(arn);
    return options.cacheFail
      ? Promise.reject(new Error("database failure"))
      : Promise.resolve();
  };
  return { dependencies, cache, published, cached, enabled, created };
}

Deno.test("iOS Firebase registrations use FCM and explicit APNs stays distinct", () => {
  const env = (
    name: string,
  ) => ({
    CNS_CHANNEL_ARN_FCM: "fcm",
    CNS_CHANNEL_ARN_APNS: "apns",
    CNS_CHANNEL_ARN_HMS: "hms",
    CNS_CHANNEL_ARN_RUSTORE: "rustore",
  }[name]);
  for (const platform of ["ios", "android", "web", "fcm"]) {
    assert.equal(channelArnFor(platform, env), "fcm");
  }
  assert.equal(channelArnFor("apns", env), "apns");
  assert.equal(channelArnFor("unknown", env), null);
});

Deno.test("endpoint from old or incorrect iOS channel is replaced before publishing", async () => {
  const test = transport();
  const result = await deliverToDevice(
    config,
    { ...device, cns_endpoint_arn: endpoint.replace("GCM", "APNS") },
    content,
    test.cache,
    test.dependencies,
  );
  assert.equal(result, "delivered");
  assert.deepEqual(test.created, [device.fcm_token]);
  assert.deepEqual(test.published, [endpoint + "-replacement"]);
});

for (const error of ["missing", "disabled"]) {
  Deno.test(`${error} endpoint is recovered once and keeps registration`, async () => {
    const test = transport([error]);
    assert.equal(
      await deliverToDevice(
        config,
        device,
        content,
        test.cache,
        test.dependencies,
      ),
      "delivered",
    );
    assert.equal(test.published.length, 2);
    assert.equal(test.created.length, error === "missing" ? 1 : 0);
    assert.equal(test.enabled.length, error === "disabled" ? 1 : 0);
  });
  Deno.test(`repeated ${error} endpoint failure stops after one retry`, async () => {
    const test = transport([error, error]);
    assert.equal(
      await deliverToDevice(
        config,
        device,
        content,
        test.cache,
        test.dependencies,
      ),
      "failed",
    );
    assert.equal(test.published.length, 2);
  });
}

for (
  const error of [
    "InvalidParameter",
    "NotFound",
    "AppNotFound",
    "AuthorizationError",
    "network failure",
  ]
) {
  Deno.test(`${error} cannot trigger endpoint mutation`, async () => {
    const test = transport([error]);
    assert.equal(
      await deliverToDevice(
        config,
        device,
        content,
        test.cache,
        test.dependencies,
      ),
      "failed",
    );
    assert.deepEqual(test.created, []);
    assert.deepEqual(test.enabled, []);
    assert.deepEqual(test.cached, []);
  });
}

Deno.test("cache failure prevents publishing and is distinguishable from delivery failure", async () => {
  const test = transport([], { cacheFail: true });
  assert.equal(
    await deliverToDevice(
      config,
      { ...device, cns_endpoint_arn: null },
      content,
      test.cache,
      test.dependencies,
    ),
    "storage_failure",
  );
  assert.deepEqual(test.published, []);
});

Deno.test("missing configured channel does not reuse an old cached endpoint", async () => {
  const test = transport([], { channel: null });
  assert.equal(
    await deliverToDevice(
      config,
      device,
      content,
      test.cache,
      test.dependencies,
    ),
    "unavailable",
  );
  assert.deepEqual(test.published, []);
});

Deno.test("disabled endpoint recovery signs token and Enabled attributes without exposing them", async () => {
  const original = globalThis.fetch;
  try {
    globalThis.fetch = (_input, init) => {
      const params = new URLSearchParams((init as { body: string }).body);
      assert.equal(params.get("Action"), "SetEndpointAttributes");
      assert.equal(params.get("EndpointArn"), endpoint);
      assert.equal(params.get("Attributes.entry.1.key"), "Enabled");
      assert.equal(params.get("Attributes.entry.1.value"), "true");
      assert.equal(params.get("Attributes.entry.2.key"), "Token");
      assert.equal(params.get("Attributes.entry.2.value"), "fixture-token");
      return Promise.resolve(new Response("{}"));
    };
    await enablePlatformEndpoint(config, endpoint, "fixture-token");
  } finally {
    globalThis.fetch = original;
  }
});

function webhook(
  options: {
    kind?: "app" | "friends";
    now?: () => number;
    onPublish?: () => void;
    devices?: PushDevice[];
    lookupFail?: boolean;
    cacheFail?: boolean;
    eventStatus?: string;
    errors?: string[];
  } = {},
) {
  const test = transport(options.errors ?? []);
  const lookups: string[] = [];
  const pushes: unknown[] = [];
  const originalPublish = test.dependencies.publish;
  test.dependencies.publish = (config, arn, push) => {
    options.onPublish?.();
    pushes.push(push);
    return originalPublish(config, arn, push);
  };
  const dependencies: PushWebhookDependencies = {
    now: options.now,
    secret: () => "fixture-secret",
    config: () => config,
    delivery: test.dependencies,
    store: () => ({
      devices: (user) => {
        lookups.push(user);
        return options.lookupFail
          ? Promise.reject(new Error("private database diagnostic"))
          : Promise.resolve(options.devices ?? [{ ...device, user_id: user }]);
      },
      cache: (_user, _token, arn) =>
        options.cacheFail
          ? Promise.reject(new Error("private storage diagnostic"))
          : test.cache(arn),
      friend: () =>
        Promise.resolve({
          requester_id: sender,
          addressee_id: recipient,
          status: options.eventStatus ?? "pending",
        }),
      actorName: () => Promise.resolve("Друг"),
    }),
  };
  return {
    ...test,
    lookups,
    pushes,
    handler: createPushWebhook(options.kind ?? "app", dependencies),
  };
}

const appBody = { recipient_id: recipient, ...content };

Deno.test("webhook stops new device batches at budget and reports partial delivery", async () => {
  let time = 0;
  const test = webhook({
    now: () => time,
    onPublish: () => {
      time = 60_000;
    },
    devices: Array.from(
      { length: 100 },
      (_, index) => ({ ...device, fcm_token: `fixture-${index}` }),
    ),
  });
  const response = await test.handler(request(appBody));
  assert.equal(response.status, 503);
  assert.deepEqual(await response.json(), {
    error: "Notification delivery time budget exceeded",
    delivered: 8,
    failed: 0,
    deferred: 92,
  });
  assert.equal(test.published.length, 8);
});
const friendBody = {
  event: "friend_request",
  friendship_id: friendship,
  requester_id: sender,
  addressee_id: recipient,
};
function request(body: unknown, secret = "fixture-secret") {
  return new Request("https://example.test/push", {
    method: "POST",
    headers: { "x-push-secret": secret },
    body: JSON.stringify(body),
  });
}

Deno.test("webhook authorization and malformed payload never query or send", async () => {
  const test = webhook();
  assert.equal((await test.handler(request(appBody, "wrong"))).status, 401);
  for (
    const value of [null, [], {}, { ...appBody, recipient_id: undefined }, {
      ...appBody,
      title: [],
    }, { ...appBody, body: {} }]
  ) {
    assert.equal((await test.handler(request(value))).status, 400);
  }
  assert.deepEqual(test.lookups, []);
  assert.deepEqual(test.pushes, []);
});

Deno.test("generic push scopes recipient and deduplicates registrations", async () => {
  const test = webhook({ devices: [device, device] });
  const response = await test.handler(
    request({ ...appBody, notification_id: friendship }),
  );
  assert.equal(response.status, 200);
  assert.deepEqual(test.lookups, [recipient]);
  assert.equal(test.pushes.length, 1);
  assert.equal(
    (test.pushes[0] as Record<string, string>).notification_id,
    friendship,
  );
});

for (const event of ["friend_request", "friend_accepted"]) {
  Deno.test(`${event} uses CNS for the exact intended recipient`, async () => {
    const test = webhook({
      kind: "friends",
      eventStatus: event === "friend_request" ? "pending" : "accepted",
    });
    assert.equal(
      (await test.handler(request({ ...friendBody, event }))).status,
      200,
    );
    assert.deepEqual(test.lookups, [
      event === "friend_request" ? recipient : sender,
    ]);
    assert.equal(
      (test.pushes[0] as Record<string, string>).route,
      "/services/people?tab=friends",
    );
    assert.equal(
      (test.pushes[0] as Record<string, string>).friendship_id,
      friendship,
    );
  });
}

Deno.test("invalid or no-longer-matching friendship events cannot publish", async () => {
  const test = webhook({ kind: "friends" });
  assert.equal(
    (await test.handler(request({ ...friendBody, event: "unknown" }))).status,
    400,
  );
  assert.equal(
    (await test.handler(request({ ...friendBody, event: "friend_accepted" })))
      .status,
    409,
  );
  assert.equal(
    (await test.handler(request({ ...friendBody, addressee_id: friendship })))
      .status,
    409,
  );
  assert.deepEqual(test.lookups, []);
  assert.deepEqual(test.pushes, []);
});

Deno.test("foreign recipient device or DB failure never reports no devices success", async () => {
  for (
    const test of [
      webhook({ devices: [{ ...device, user_id: sender }] }),
      webhook({ lookupFail: true }),
    ]
  ) {
    const response = await test.handler(request(appBody));
    assert.equal(response.status, 500);
    assert.deepEqual(await response.json(), {
      error: "Notification lookup failed",
    });
    assert.deepEqual(test.pushes, []);
  }
});

Deno.test("provider failure is visible without leaking token or removing registration", async () => {
  const test = webhook({ errors: ["InvalidParameter"] });
  const response = await test.handler(request(appBody));
  assert.equal(response.status, 502);
  assert.deepEqual(await response.json(), {
    error: "Notification delivery failed",
    delivered: 0,
    failed: 1,
  });
  assert.deepEqual(test.cached, []);
});
