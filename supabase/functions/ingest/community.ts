import { validateOrganizationId } from "./story_media.ts";

export type CommunityPayload = {
  entity: "community_catalog_targets";
  organization_id: string;
} | {
  entity: "community_observations";
  organization_id: string;
  observations: Record<string, unknown>[];
};

export function validateCommunityPayload(
  value: Record<string, unknown>,
): CommunityPayload {
  const organizationId = validateOrganizationId(value.organization_id);
  if (value.entity === "community_catalog_targets") {
    return { entity: value.entity, organization_id: organizationId };
  }
  if (!Array.isArray(value.observations) || value.observations.length > 500) {
    throw new Error("At most 500 community observations are required");
  }
  const observations = value.observations.map((item) => {
    if (!item || typeof item !== "object" || Array.isArray(item)) {
      throw new Error("Invalid community observation");
    }
    const record = item as Record<string, unknown>;
    if (
      typeof record.id !== "string" ||
      !/^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i
        .test(record.id)
    ) {
      throw new Error("Community ID must be a UUID");
    }
    if (
      !["verified", "not_found", "unavailable"].includes(String(record.status))
    ) throw new Error("Invalid observation status");
    if (
      typeof record.checked_at !== "string" ||
      !Number.isFinite(Date.parse(record.checked_at)) ||
      Date.parse(record.checked_at) > Date.now() + 300000
    ) throw new Error("Invalid observation timestamp");
    if (
      record.http_status != null &&
      (!Number.isInteger(record.http_status) ||
        Number(record.http_status) < 100 || Number(record.http_status) > 599)
    ) throw new Error("Invalid HTTP status");
    for (
      const [field, limit] of [["title", 160], ["description", 1000]] as const
    ) {
      if (
        record[field] != null &&
        (typeof record[field] !== "string" || record[field].length > limit)
      ) throw new Error(`Invalid ${field}`);
    }
    for (const field of ["url", "logo_url"]) {
      if (field === "logo_url" && record[field] == null) continue;
      const url = record[field];
      if (typeof url !== "string" || url.length > 2048) {
        throw new Error(`Invalid ${field}`);
      }
      const uri = new URL(url);
      if (
        uri.protocol !== "https:" || !uri.hostname || uri.username ||
        uri.password
      ) throw new Error(`Invalid ${field}`);
    }
    if (
      record.member_count != null &&
      (!Number.isInteger(record.member_count) ||
        Number(record.member_count) < 0 ||
        Number(record.member_count) > 2147483647)
    ) throw new Error("Invalid member count");
    if (
      typeof record.evidence !== "string" || record.evidence.length < 1 ||
      record.evidence.length > 500
    ) throw new Error("Observation evidence is required");
    if (
      record.status === "not_found" &&
      ![404, 410].includes(Number(record.http_status)) &&
      !(record.http_status === 200 &&
        ["Сообщество удалено", "Страница удалена"].includes(record.evidence))
    ) throw new Error("Deletion requires explicit missing evidence");
    return record;
  });
  return {
    entity: "community_observations",
    organization_id: organizationId,
    observations,
  };
}
