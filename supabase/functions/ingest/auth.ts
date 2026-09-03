import { jsonResponse } from "./http.ts";

type EnvironmentReader = (name: string) => string | undefined;

const contentEntities = new Set([
  "news_items",
  "community_catalog_targets",
  "community_observations",
  "story_media_upload",
  "story_media_cleanup",
  "story_media_delete",
  "sync_start",
  "sync_finish",
]);
const contentSourceTypes = new Set([
  "telegram",
  "telegram_stories",
  "website",
  "rss",
  "vk",
]);

export function ingestAuthScope(
  entity: string,
  sourceType?: unknown,
  source?: unknown,
): string {
  if (entity === "sync_start" || entity === "sync_finish") {
    if (sourceType === "schedule") return "schedule";
    return typeof sourceType === "string" &&
        contentSourceTypes.has(sourceType) &&
        typeof source === "string" && source.startsWith(`${sourceType}:`)
      ? entity
      : "unsupported_sync";
  }
  if (entity === "news_items") {
    return typeof sourceType === "string" && contentSourceTypes.has(sourceType)
      ? entity
      : "unsupported_news";
  }
  return entity;
}

export function resolveIngestKey(
  organizationId: string,
  readEnvironment: EnvironmentReader = (name) => Deno.env.get(name),
  entity?: string,
): string | null {
  if (entity === "schedule") {
    const scheduleKey = readEnvironment("SCHEDULE_INGEST_KEY");
    const scheduleOrganization = readEnvironment(
      "SCHEDULE_INGEST_ORGANIZATION_ID",
    );
    if (scheduleKey || scheduleOrganization) {
      return scheduleKey && scheduleOrganization === organizationId
        ? scheduleKey
        : null;
    }
  }

  const tenantKeys = readEnvironment("INGEST_TENANT_KEYS");
  if (tenantKeys) {
    const parsed = JSON.parse(tenantKeys) as unknown;
    if (!parsed || typeof parsed !== "object" || Array.isArray(parsed)) {
      throw new Error("INGEST_TENANT_KEYS must be a JSON object");
    }
    const value = (parsed as Record<string, unknown>)[organizationId];
    return typeof value === "string" && value.length > 0 ? value : null;
  }

  const expectedOrganization = readEnvironment("INGEST_ORGANIZATION_ID");
  const legacyKey = readEnvironment("INGEST_API_KEY");
  if (!expectedOrganization || !legacyKey) {
    return null;
  }
  return expectedOrganization === organizationId ? legacyKey : null;
}

export async function requireIngestKey(
  req: Request,
  organizationId: string,
  entity?: string,
  readEnvironment: EnvironmentReader = (name) => Deno.env.get(name),
): Promise<Response | null> {
  if (entity === "unsupported_sync" || entity === "unsupported_news") {
    return jsonResponse({ error: "Unauthorized" }, 401);
  }
  let expected: string | null;
  try {
    expected = resolveIngestKey(
      organizationId,
      readEnvironment,
      entity,
    );
  } catch {
    return jsonResponse(
      { error: "Ingest authentication is misconfigured" },
      500,
    );
  }
  const headerKey = req.headers.get("x-ingest-key");
  const authorization = req.headers.get("authorization") ?? "";
  const bearer = authorization.toLowerCase().startsWith("bearer ")
    ? authorization.slice("bearer ".length)
    : null;
  if (
    expected != null && (headerKey === expected || bearer === expected)
  ) return null;

  const contentHash = readEnvironment("CONTENT_INGEST_KEY_SHA256");
  const contentOrganization = readEnvironment("CONTENT_INGEST_ORGANIZATION_ID");
  const contentConfigured = Boolean(contentHash || contentOrganization);
  if (
    contentConfigured &&
    (!contentHash || !/^[a-f0-9]{64}$/i.test(contentHash) ||
      !contentOrganization)
  ) {
    return jsonResponse({
      error: "Content ingest authentication is misconfigured",
    }, 500);
  }
  if (
    contentHash && contentOrganization === organizationId &&
    contentEntities.has(entity ?? "")
  ) {
    for (const candidate of new Set([headerKey, bearer])) {
      if (!candidate) continue;
      const digest = new Uint8Array(
        await crypto.subtle.digest(
          "SHA-256",
          new TextEncoder().encode(candidate),
        ),
      );
      const actual = Array.from(
        digest,
        (byte) => byte.toString(16).padStart(2, "0"),
      )
        .join("");
      const expectedHash = contentHash.toLowerCase();
      let difference = 0;
      for (let index = 0; index < actual.length; index++) {
        difference |= actual.charCodeAt(index) ^ expectedHash.charCodeAt(index);
      }
      if (difference === 0) return null;
    }
  }
  if (expected == null && !contentConfigured) {
    return jsonResponse(
      { error: "Ingest key is not configured for tenant" },
      500,
    );
  }
  return jsonResponse({ error: "Unauthorized" }, 401);
}
