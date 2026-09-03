import type { NotificationDependencies, NotificationRpc } from "./index.ts";
import type { PushContent } from "./cns.ts";

const originalServe = Deno.serve;
let bootstraps = 0;
Deno.serve = (() => {
  bootstraps++;
  return {};
}) as unknown as typeof Deno.serve;
let createHandler: typeof import("./index.ts").createNotificationHandler;
try {
  createHandler = (await import("./index.ts")).createNotificationHandler;
} finally {
  Deno.serve = originalServe;
}

function equal(actual: unknown, expected: unknown) {
  if (JSON.stringify(actual) !== JSON.stringify(expected)) {
    throw new Error(
      `Expected ${JSON.stringify(expected)}, got ${JSON.stringify(actual)}`,
    );
  }
}

const token = "man_" + "a".repeat(48);
const scope = { p_app_id: "app", p_reservation_id: "reservation" };
const validBody = { organizationId: "org", slug: "study", title: "Update" };
const validContext = {
  ok: true,
  appId: "app",
  appName: "Study",
  slug: "study",
  reservationId: "reservation",
  recipients: ["first", "second"],
};

function device(user = "first", endpoint: string | null = "endpoint") {
  return {
    user_id: user,
    fcm_token: `token-${user}`,
    platform: "android",
    cns_endpoint_arn: endpoint,
  };
}

type RpcResult = { data: unknown; error: unknown };
type Options = {
  context?: unknown;
  devices?: unknown;
  responses?: Record<string, RpcResult | Error>;
  publishErrors?: Record<string, Error>;
  configured?: boolean;
  channel?: string | null;
};

function setup(options: Options = {}) {
  const calls: { name: string; parameters: Record<string, unknown> }[] = [];
  const pushes: { arn: string; push: PushContent }[] = [];
  const endpoints: string[] = [];
  const client: NotificationRpc = {
    rpc(name, parameters) {
      calls.push({ name, parameters });
      const response = options.responses?.[name];
      if (response instanceof Error) return Promise.reject(response);
      if (response) return Promise.resolve(response);
      const data = name === "mini_app_notify_context"
        ? options.context ?? validContext
        : name === "mini_app_push_devices"
        ? options.devices ?? [device()]
        : null;
      return Promise.resolve({ data, error: null });
    },
  };
  const dependencies: NotificationDependencies = {
    config: () =>
      options.configured === false
        ? null
        : { accessKeyId: "fixture", secretKey: "fixture" },
    client: () => client,
    channel: () => options.channel === undefined ? "channel" : options.channel,
    endpoint: (_config, _channel, pushToken) => {
      endpoints.push(pushToken);
      return Promise.resolve("created-endpoint");
    },
    publish: (_config, arn, push) => {
      pushes.push({ arn, push });
      const error = options.publishErrors?.[arn];
      return error ? Promise.reject(error) : Promise.resolve();
    },
    stale: (error) => error instanceof Error && error.message === "stale",
    missing: (error) => error instanceof Error && error.message === "missing",
  };
  return { handler: createHandler(dependencies), calls, pushes, endpoints };
}

function request(body: unknown = validBody, authorization = `Bearer ${token}`) {
  return new Request("https://example.test/notify", {
    method: "POST",
    headers: {
      Authorization: authorization,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
  });
}

function finalized(calls: ReturnType<typeof setup>["calls"]) {
  return calls.filter((call) => call.name === "finalize_mini_app_push")
    .map((call) => call.parameters);
}

Deno.test("notification bootstrap registers without serving in tests", () => {
  equal(bootstraps, 1);
});

Deno.test("rejects method and malformed token before RPC or delivery", async () => {
  const test = setup();
  equal(
    (await test.handler(new Request("https://example.test/notify"))).status,
    405,
  );
  equal((await test.handler(request(validBody, "Bearer invalid"))).status, 401);
  equal(test.calls, []);
  equal(test.pushes, []);
});

for (
  const body of [
    null,
    [],
    "text",
    42,
    {},
    { ...validBody, title: 42 },
    { ...validBody, body: {} },
    { ...validBody, page: false },
    { ...validBody, organizationId: " " },
    { ...validBody, title: " " },
    { ...validBody, title: "x".repeat(81) },
    { ...validBody, body: "x".repeat(201) },
  ]
) {
  Deno.test(`rejects invalid notification body ${JSON.stringify(body)}`, async () => {
    const test = setup();
    equal((await test.handler(request(body))).status, 400);
    equal(test.calls, []);
  });
}

Deno.test("unconfigured service fails without creating reservations", async () => {
  const test = setup({ configured: false });
  equal((await test.handler(request())).status, 503);
  equal(test.calls, []);
});

Deno.test("publishes through scoped RPCs and finalizes reached users once", async () => {
  const test = setup({
    devices: [device("first", null), device("first", "other-endpoint")],
  });
  const response = await test.handler(
    request({ ...validBody, page: "/lesson?day=1" }),
  );
  equal(await response.json(), { ok: true, delivered: 2, users: 1 });
  equal(test.calls[0].name, "mini_app_notify_context");
  const hash = test.calls[0].parameters.p_token_hash as string;
  equal(/^[0-9a-f]{64}$/.test(hash), true);
  equal(hash === token, false);
  equal(test.calls[1], { name: "mini_app_push_devices", parameters: scope });
  equal(test.calls[2], {
    name: "set_mini_app_push_endpoint",
    parameters: {
      ...scope,
      p_fcm_token: "token-first",
      p_endpoint_arn: "created-endpoint",
    },
  });
  equal(finalized(test.calls), [{ ...scope, p_user_ids: ["first"] }]);
  equal(test.pushes[0].push, {
    title: "Study: Update",
    body: "",
    route: "/services/apps/study/run?page=%2Flesson%3Fday%3D1",
    type: "mini_app",
  });
});

Deno.test("empty recipients and missing reservation never publish", async () => {
  const empty = setup({ context: { ...validContext, recipients: [] } });
  equal(await (await empty.handler(request())).json(), {
    ok: true,
    delivered: 0,
    reason: "no_recipients",
  });
  equal(empty.calls.length, 1);
  const invalid = setup({ context: { ...validContext, reservationId: null } });
  equal((await invalid.handler(request())).status, 500);
  equal(invalid.pushes, []);
});

for (const devices of [[], [{ user_id: "invalid" }], [device("unreserved")]]) {
  Deno.test(`releases reservation for unusable devices ${JSON.stringify(devices)}`, async () => {
    const test = setup({ devices });
    equal((await test.handler(request())).status, devices.length ? 500 : 200);
    equal(finalized(test.calls), [{ ...scope, p_user_ids: [] }]);
    equal(test.pushes, []);
  });
}

for (
  const failure of [new Error("private-diagnostic"), {
    data: null,
    error: { message: "private-diagnostic" },
  }]
) {
  Deno.test(`device lookup ${failure instanceof Error ? "throw" : "error"} finalizes safely`, async () => {
    const test = setup({ responses: { mini_app_push_devices: failure } });
    const response = await test.handler(request());
    equal(response.status, 500);
    equal(await response.json(), {
      error: "Notification device lookup failed",
    });
    equal(finalized(test.calls), [{ ...scope, p_user_ids: [] }]);
  });
}

Deno.test("stale cleanup occurs before finalizing only successful recipients", async () => {
  const test = setup({
    devices: [device("first", "good"), device("second", "bad")],
    publishErrors: { bad: new Error("stale") },
  });
  equal(await (await test.handler(request())).json(), {
    ok: true,
    delivered: 1,
    users: 1,
  });
  equal(test.calls.at(-2), {
    name: "delete_mini_app_push_devices",
    parameters: {
      ...scope,
      p_fcm_tokens: ["token-second"],
    },
  });
  equal(finalized(test.calls), [{ ...scope, p_user_ids: ["first"] }]);
});

for (
  const name of ["set_mini_app_push_endpoint", "delete_mini_app_push_devices"]
) {
  Deno.test(`${name} failure still finalizes and hides diagnostics`, async () => {
    const test = setup({
      devices: [
        device("first", name === "set_mini_app_push_endpoint" ? null : "bad"),
      ],
      responses: {
        [name]: { data: null, error: { message: "private-diagnostic" } },
      },
      publishErrors: { bad: new Error("stale") },
    });
    const response = await test.handler(request());
    equal(response.status, 500);
    equal(await response.json(), {
      error: "Notification device update failed",
    });
    equal(finalized(test.calls), [{ ...scope, p_user_ids: [] }]);
  });
}

Deno.test("finalization failures are not reported as successful delivery", async () => {
  const test = setup({
    responses: {
      finalize_mini_app_push: new Error("private-diagnostic"),
    },
  });
  const response = await test.handler(request());
  equal(response.status, 500);
  equal(await response.json(), { error: "Notification finalization failed" });
  equal(finalized(test.calls), [{ ...scope, p_user_ids: ["first"] }]);
});

Deno.test("unsupported channel releases quota without creating endpoint", async () => {
  const test = setup({ channel: null, devices: [device("first", null)] });
  equal(await (await test.handler(request())).json(), {
    ok: true,
    delivered: 0,
    users: 0,
  });
  equal(test.endpoints, []);
  equal(test.pushes, []);
  equal(finalized(test.calls), [{ ...scope, p_user_ids: [] }]);
});

Deno.test("missing cached endpoint is replaced once without deleting registration", async () => {
  const test = setup({
    devices: [device("first", "missing-cache")],
    publishErrors: { "missing-cache": new Error("missing") },
  });
  equal(await (await test.handler(request())).json(), {
    ok: true,
    delivered: 1,
    users: 1,
  });
  equal(test.endpoints, ["token-first"]);
  equal(test.pushes.map((push) => push.arn), [
    "missing-cache",
    "created-endpoint",
  ]);
  equal(
    test.calls.some((call) => call.name === "delete_mini_app_push_devices"),
    false,
  );
  equal(test.calls.at(-2), {
    name: "set_mini_app_push_endpoint",
    parameters: {
      ...scope,
      p_fcm_token: "token-first",
      p_endpoint_arn: "created-endpoint",
    },
  });
  equal(finalized(test.calls), [{ ...scope, p_user_ids: ["first"] }]);
});

Deno.test("replacement endpoint failure stops after one retry and preserves token", async () => {
  const test = setup({
    devices: [device("first", "missing-cache")],
    publishErrors: {
      "missing-cache": new Error("missing"),
      "created-endpoint": new Error("missing"),
    },
  });
  equal(await (await test.handler(request())).json(), {
    ok: true,
    delivered: 0,
    users: 0,
  });
  equal(test.endpoints, ["token-first"]);
  equal(test.pushes.length, 2);
  equal(
    test.calls.some((call) => call.name === "delete_mini_app_push_devices"),
    false,
  );
  equal(finalized(test.calls), [{ ...scope, p_user_ids: [] }]);
});

Deno.test("missing endpoint without configured channel preserves registration", async () => {
  const test = setup({
    channel: null,
    devices: [device("first", "missing-cache")],
    publishErrors: { "missing-cache": new Error("missing") },
  });
  equal(await (await test.handler(request())).json(), {
    ok: true,
    delivered: 0,
    users: 0,
  });
  equal(test.endpoints, []);
  equal(
    test.calls.some((call) => call.name === "delete_mini_app_push_devices"),
    false,
  );
  equal(finalized(test.calls), [{ ...scope, p_user_ids: [] }]);
});

for (
  const failure of ["AppNotFound", "InvalidParameter", "AuthorizationError"]
) {
  Deno.test(`${failure} preserves device registration and releases reservation`, async () => {
    const test = setup({ publishErrors: { endpoint: new Error(failure) } });
    equal(await (await test.handler(request())).json(), {
      ok: true,
      delivered: 0,
      users: 0,
    });
    equal(
      test.calls.some((call) => call.name === "delete_mini_app_push_devices"),
      false,
    );
    equal(finalized(test.calls), [{ ...scope, p_user_ids: [] }]);
  });
}
