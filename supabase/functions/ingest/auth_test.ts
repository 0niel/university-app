import { requireIngestKey, resolveIngestKey } from "./auth.ts";
import { assertEquals } from "./test_assertions.ts";

Deno.test("resolves a key only for its mapped tenant", () => {
  const values = new Map([
    ["INGEST_TENANT_KEYS", '{"mirea":"first","other":"second"}'],
  ]);
  const read = (name: string) => values.get(name);

  assertEquals(resolveIngestKey("mirea", read), "first");
  assertEquals(resolveIngestKey("other", read), "second");
  assertEquals(resolveIngestKey("unknown", read), null);
});

Deno.test("binds the legacy key when an organization is configured", () => {
  const values = new Map([
    ["INGEST_API_KEY", "legacy"],
    ["INGEST_ORGANIZATION_ID", "mirea"],
  ]);
  const read = (name: string) => values.get(name);

  assertEquals(resolveIngestKey("mirea", read), "legacy");
  assertEquals(resolveIngestKey("other", read), null);
});

Deno.test("rejects an unbound legacy key", () => {
  const values = new Map([["INGEST_API_KEY", "legacy"]]);
  const read = (name: string) => values.get(name);

  assertEquals(resolveIngestKey("mirea", read), null);
});

Deno.test("uses an isolated schedule key for schedule ingestion", () => {
  const values = new Map([
    ["INGEST_API_KEY", "legacy"],
    ["INGEST_ORGANIZATION_ID", "mirea"],
    ["SCHEDULE_INGEST_KEY", "schedule"],
    ["SCHEDULE_INGEST_ORGANIZATION_ID", "mirea"],
  ]);
  const read = (name: string) => values.get(name);

  assertEquals(resolveIngestKey("mirea", read, "schedule"), "schedule");
  assertEquals(resolveIngestKey("other", read, "schedule"), null);
  assertEquals(resolveIngestKey("mirea", read, "news_items"), "legacy");

  const request = new Request("https://example.test", {
    headers: { "x-ingest-key": "schedule" },
  });
  assertEquals(requireIngestKey(request, "mirea", "sync_start", read), null);
});
