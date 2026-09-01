import {
  StoryMediaCleanupPayload,
  StoryMediaDeletePayload,
  StoryMediaUploadPayload,
  validateOrganizationId,
  validateStoryMediaCleanup,
  validateStoryMediaDelete,
  validateStoryMediaUpload,
} from "./story_media.ts";
import {
  SyncFinishPayload,
  SyncStartPayload,
  validateSyncFinish,
  validateSyncStart,
} from "./sync.ts";

export type DatabaseIngestPayload = {
  entity: "news_items" | "schedule";
  organization_id: string;
  source: Record<string, unknown>;
  items?: unknown[];
  targets?: unknown[];
  sync_run_id?: string | null;
};

export type IngestPayload =
  | DatabaseIngestPayload
  | StoryMediaUploadPayload
  | StoryMediaCleanupPayload
  | StoryMediaDeletePayload
  | SyncStartPayload
  | SyncFinishPayload;

export function validatePayload(payload: unknown): IngestPayload {
  if (!payload || typeof payload !== "object") {
    throw new Error("JSON object payload is required");
  }

  const value = payload as Record<string, unknown>;
  if (value.entity === "story_media_upload") {
    return validateStoryMediaUpload(value);
  }
  if (value.entity === "story_media_cleanup") {
    return validateStoryMediaCleanup(value);
  }
  if (value.entity === "story_media_delete") {
    return validateStoryMediaDelete(value);
  }
  if (value.entity === "sync_start") {
    return validateSyncStart(value);
  }
  if (value.entity === "sync_finish") {
    return validateSyncFinish(value);
  }
  if (value.entity !== "news_items" && value.entity !== "schedule") {
    throw new Error(
      "unsupported ingest entity",
    );
  }
  const organizationId = validateOrganizationId(value.organization_id);
  if (
    !value.source ||
    typeof value.source !== "object" ||
    Array.isArray(value.source)
  ) {
    throw new Error("source object is required");
  }
  if (value.entity === "news_items" && !Array.isArray(value.items)) {
    throw new Error("items array is required");
  }
  if (value.entity === "schedule" && !Array.isArray(value.targets)) {
    throw new Error("targets array is required");
  }
  const syncRunId = validateOptionalUuid(value.sync_run_id);
  if (value.entity === "schedule" && syncRunId == null) {
    throw new Error("sync_run_id is required for schedule ingest");
  }

  return {
    entity: value.entity,
    organization_id: organizationId,
    source: value.source as Record<string, unknown>,
    items: value.items as unknown[] | undefined,
    targets: value.targets as unknown[] | undefined,
    sync_run_id: syncRunId,
  };
}

function validateOptionalUuid(value: unknown): string | null {
  if (value == null) return null;
  if (
    typeof value !== "string" ||
    !/^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i
      .test(value)
  ) {
    throw new Error("sync_run_id must be a UUID");
  }
  return value;
}
