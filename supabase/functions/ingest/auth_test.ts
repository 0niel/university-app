import { ingestAuthScope, requireIngestKey, resolveIngestKey } from "./auth.ts";
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

Deno.test("uses an isolated schedule key for schedule ingestion", async () => {
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
  assertEquals(
    await requireIngestKey(request, "mirea", "schedule", read),
    null,
  );

  const legacyRequest = new Request("https://example.test", {
    headers: { "x-ingest-key": "legacy" },
  });
  assertEquals(
    (await requireIngestKey(legacyRequest, "mirea", "schedule", read))?.status,
    401,
  );
});

const contentKey = "test-only-content-ingest-key";
const contentDigest = new Uint8Array(
  await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(contentKey),
  ),
);
const contentHash = Array.from(
  contentDigest,
  (byte) => byte.toString(16).padStart(2, "0"),
).join("");
const contentEnvironment = new Map([
  ["CONTENT_INGEST_KEY_SHA256", contentHash],
  ["CONTENT_INGEST_ORGANIZATION_ID", "mirea"],
]);
const readContentEnvironment = (name: string) => contentEnvironment.get(name);

for (
  const entity of [
    "news_items",
    "community_catalog_targets",
    "community_observations",
    "story_media_upload",
    "story_media_cleanup",
    "story_media_delete",
    "sync_start",
    "sync_finish",
  ]
) {
  Deno.test(`hashed content key authorizes ${entity} for its tenant`, async () => {
    assertEquals(
      await requireIngestKey(
        new Request("https://example.test", {
          headers: { "x-ingest-key": contentKey },
        }),
        "mirea",
        entity,
        readContentEnvironment,
      ),
      null,
    );
  });
}

for (
  const [name, key, tenant, entity] of [
    ["wrong hash", "incorrect", "mirea", "news_items"],
    ["another tenant", contentKey, "another", "community_observations"],
    ["schedule", contentKey, "mirea", "schedule"],
    ["unknown entity", contentKey, "mirea", "unknown"],
    ["unbound sync", contentKey, "mirea", "unsupported_sync"],
    ["unbound news", contentKey, "mirea", "unsupported_news"],
  ]
) {
  Deno.test(`hashed content key rejects ${name}`, async () => {
    assertEquals(
      (await requireIngestKey(
        new Request("https://example.test", {
          headers: { "x-ingest-key": key },
        }),
        tenant,
        entity,
        readContentEnvironment,
      ))?.status,
      401,
    );
  });
}

Deno.test("scoped sync cannot disguise schedule or omit its source", () => {
  assertEquals(
    ingestAuthScope("sync_start", "schedule", "schedule:news"),
    "schedule",
  );
  assertEquals(ingestAuthScope("sync_finish", null, null), "unsupported_sync");
  assertEquals(
    ingestAuthScope("sync_start", "telegram", "schedule:news"),
    "unsupported_sync",
  );
  assertEquals(
    ingestAuthScope("sync_start", "telegram", "telegram:news"),
    "sync_start",
  );
  assertEquals(
    ingestAuthScope("sync_finish", "website", "website:news"),
    "sync_finish",
  );
  assertEquals(ingestAuthScope("news_items", "schedule"), "unsupported_news");
  assertEquals(ingestAuthScope("news_items", "telegram"), "news_items");
});

Deno.test("adding content auth preserves an existing legacy tenant key", async () => {
  const values = new Map([
    ...contentEnvironment,
    ["INGEST_API_KEY", "legacy"],
    ["INGEST_ORGANIZATION_ID", "mirea"],
  ]);
  assertEquals(
    await requireIngestKey(
      new Request("https://example.test", {
        headers: { "x-ingest-key": "legacy" },
      }),
      "mirea",
      "news_items",
      (name) => values.get(name),
    ),
    null,
  );
});

for (const entity of ["unsupported_sync", "unsupported_news"]) {
  Deno.test(`legacy tenant key cannot authorize ${entity}`, async () => {
    const values = new Map([
      ["INGEST_API_KEY", "legacy"],
      ["INGEST_ORGANIZATION_ID", "mirea"],
    ]);
    assertEquals(
      (await requireIngestKey(
        new Request("https://example.test", {
          headers: { "x-ingest-key": "legacy" },
        }),
        "mirea",
        entity,
        (name) => values.get(name),
      ))?.status,
      401,
    );
  });

  Deno.test(`tenant key map cannot authorize ${entity}`, async () => {
    const values = new Map([
      ["INGEST_TENANT_KEYS", '{"mirea":"tenant-key"}'],
    ]);
    assertEquals(
      (await requireIngestKey(
        new Request("https://example.test", {
          headers: { authorization: "Bearer tenant-key" },
        }),
        "mirea",
        entity,
        (name) => values.get(name),
      ))?.status,
      401,
    );
  });

  Deno.test(`${entity} is rejected before reading credentials`, async () => {
    assertEquals(
      (await requireIngestKey(
        new Request("https://example.test"),
        "mirea",
        entity,
        () => {
          throw new Error("Credentials must not be read");
        },
      ))?.status,
      401,
    );
  });
}

for (
  const sourceType of ["telegram", "telegram_stories", "website", "rss", "vk"]
) {
  Deno.test(`current ${sourceType} workers retain legacy and scoped access`, async () => {
    const values = new Map([
      ...contentEnvironment,
      ["INGEST_API_KEY", "legacy"],
      ["INGEST_ORGANIZATION_ID", "mirea"],
    ]);
    for (const key of ["legacy", contentKey]) {
      for (const entity of ["sync_start", "sync_finish", "news_items"]) {
        assertEquals(
          await requireIngestKey(
            new Request("https://example.test", {
              headers: { "x-ingest-key": key },
            }),
            "mirea",
            ingestAuthScope(entity, sourceType, `${sourceType}:channel`),
            (name) => values.get(name),
          ),
          null,
        );
      }
    }
  });
}

Deno.test("malformed tenant config fails without exposing its contents", async () => {
  const response = await requireIngestKey(
    new Request("https://example.test", {
      headers: { "x-ingest-key": "legacy" },
    }),
    "mirea",
    "news_items",
    (name) =>
      name === "INGEST_TENANT_KEYS" ? "test-only-private-config" : undefined,
  );
  assertEquals(response?.status, 500);
  assertEquals(await response?.json(), {
    error: "Ingest authentication is misconfigured",
  });
});

Deno.test("malformed content hash fails closed without exposing its value", async () => {
  const values = new Map(contentEnvironment);
  values.set("CONTENT_INGEST_KEY_SHA256", "invalid-config");
  const response = await requireIngestKey(
    new Request("https://example.test", {
      headers: { "x-ingest-key": contentKey },
    }),
    "mirea",
    "news_items",
    (name) => values.get(name),
  );
  assertEquals(response?.status, 500);
  assertEquals(await response?.json(), {
    error: "Content ingest authentication is misconfigured",
  });
});
