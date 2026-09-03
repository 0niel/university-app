import { assertEquals, assertThrows } from "./test_assertions.ts";
import { validatePayload } from "./payload.ts";

const observation = {
  id: "10000000-0000-4000-8000-000000000001",
  url: "https://t.me/example_news",
  status: "verified",
  checked_at: "2026-09-02T12:00:00Z",
  evidence: "114 subscribers",
  member_count: 114,
  http_status: 200,
};

Deno.test("community targets retain organization scope", () => {
  assertEquals(
    validatePayload({
      entity: "community_catalog_targets",
      organization_id: "mirea",
    }),
    {
      entity: "community_catalog_targets",
      organization_id: "mirea",
    },
  );
});

Deno.test("observed real counts pass ingest validation", () => {
  const result = validatePayload({
    entity: "community_observations",
    organization_id: "mirea",
    observations: [observation],
  });
  assertEquals(result.entity, "community_observations");
});

Deno.test("rate limits are not accepted as deletion evidence", () => {
  assertThrows(() =>
    validatePayload({
      entity: "community_observations",
      organization_id: "mirea",
      observations: [{ ...observation, status: "not_found", http_status: 429 }],
    })
  );
});

Deno.test("negative participant counts are rejected", () => {
  assertThrows(() =>
    validatePayload({
      entity: "community_observations",
      organization_id: "mirea",
      observations: [{ ...observation, member_count: -1 }],
    })
  );
});

for (
  const [name, invalid] of Object.entries({
    "missing HTTP deletion evidence": {
      status: "not_found",
      http_status: null,
    },
    "string HTTP status": { http_status: "200" },
    "out-of-range HTTP status": { http_status: 600 },
    "non-text title": { title: { name: "Invalid" } },
    "oversized title": { title: "a".repeat(161) },
    "invalid UUID": { id: "------------------------------------" },
    "future timestamp": { checked_at: "2999-01-01T00:00:00Z" },
  })
) {
  Deno.test(`community observations reject ${name}`, () => {
    assertThrows(() =>
      validatePayload({
        entity: "community_observations",
        organization_id: "mirea",
        observations: [{ ...observation, ...invalid }],
      })
    );
  });
}
