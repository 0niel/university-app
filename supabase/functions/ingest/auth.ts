import { jsonResponse } from "./http.ts";

type EnvironmentReader = (name: string) => string | undefined;

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

export function requireIngestKey(
  req: Request,
  organizationId: string,
  entity?: string,
  readEnvironment: EnvironmentReader = (name) => Deno.env.get(name),
): Response | null {
  let expected: string | null;
  try {
    expected = resolveIngestKey(
      organizationId,
      readEnvironment,
      entity,
    );
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    return jsonResponse({ error: message }, 500);
  }
  if (expected == null) {
    return jsonResponse(
      { error: "Ingest key is not configured for tenant" },
      500,
    );
  }

  const headerKey = req.headers.get("x-ingest-key");
  const authorization = req.headers.get("authorization") ?? "";
  const bearer = authorization.toLowerCase().startsWith("bearer ")
    ? authorization.slice("bearer ".length)
    : null;
  if (
    headerKey === expected || bearer === expected
  ) return null;
  return jsonResponse({ error: "Unauthorized" }, 401);
}
