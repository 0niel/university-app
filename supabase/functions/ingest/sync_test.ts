import { assertEquals, assertThrows } from "./test_assertions.ts";
import { validatePayload } from "./payload.ts";

Deno.test("sync start validates its source contract", () => {
  const payload = validatePayload({
    entity: "sync_start",
    organization_id: "university",
    source: "telegram:news",
    source_type: "telegram",
    metadata: { channel: "news" },
  });

  assertEquals(payload, {
    entity: "sync_start",
    organization_id: "university",
    source: "telegram:news",
    source_type: "telegram",
    metadata: { channel: "news" },
  });
});

Deno.test("successful sync requires a UUID and checkpoint", () => {
  assertThrows(
    () =>
      validatePayload({
        entity: "sync_finish",
        organization_id: "university",
        sync_run_id: "not-a-uuid",
        status: "succeeded",
        checkpoint: {},
      }),
    Error,
    "UUID",
  );
  assertThrows(
    () =>
      validatePayload({
        entity: "sync_finish",
        organization_id: "university",
        sync_run_id: "10000000-0000-4000-8000-000000000001",
        status: "succeeded",
      }),
    Error,
    "checkpoint",
  );
});

Deno.test("database ingest rejects malformed sync run ids", () => {
  assertThrows(
    () =>
      validatePayload({
        entity: "news_items",
        organization_id: "university",
        source: {},
        items: [],
        sync_run_id: "wrong",
      }),
    Error,
    "UUID",
  );
  assertThrows(
    () =>
      validatePayload({
        entity: "news_items",
        organization_id: "university",
        source: [],
        items: [],
      }),
    Error,
    "source",
  );
});
