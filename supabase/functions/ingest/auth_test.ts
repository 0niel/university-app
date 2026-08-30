import { resolveIngestKey } from "./auth.ts";
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
