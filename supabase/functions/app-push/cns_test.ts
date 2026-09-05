import assert from "node:assert/strict";
import { publishPush } from "./cns.ts";

Deno.test("inbox identity is included on every push platform", async () => {
  const originalFetch = globalThis.fetch;
  let calls = 0;
  try {
    globalThis.fetch = (_input, init) => {
      calls++;
      const params = new URLSearchParams(init!.body as string);
      const message = JSON.parse(params.get("Message")!);
      for (const platform of ["GCM", "HMS", "RUSTORE"]) {
        assert.deepEqual(JSON.parse(message[platform]).data, {
          type: "team_application",
          route: "/services/teams/example",
          notification_id: "ca8e65c8-8545-4a49-a047-3797c733bd63",
        });
      }
      assert.equal(
        JSON.parse(message.APNS).notification_id,
        "ca8e65c8-8545-4a49-a047-3797c733bd63",
      );
      return Promise.resolve(new Response("{}"));
    };
    await publishPush(
      { accessKeyId: "test", secretKey: "test" },
      "test-endpoint",
      {
        title: "Новый отклик",
        body: "Команда",
        type: "team_application",
        route: "/services/teams/example",
        notification_id: "ca8e65c8-8545-4a49-a047-3797c733bd63",
      },
    );
    assert.equal(calls, 1);
  } finally {
    globalThis.fetch = originalFetch;
  }
});
