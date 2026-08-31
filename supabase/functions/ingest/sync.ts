import { validateOrganizationId } from "./story_media.ts";

const uuidPattern =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

export type SyncStartPayload = {
  entity: "sync_start";
  organization_id: string;
  source: string;
  source_type: string;
  metadata: Record<string, unknown>;
};

export type SyncFinishPayload = {
  entity: "sync_finish";
  organization_id: string;
  sync_run_id: string;
  status: "succeeded" | "failed" | "partial";
  checkpoint: Record<string, unknown> | null;
  error_message: string | null;
  metadata: Record<string, unknown>;
};

export function validateSyncStart(
  value: Record<string, unknown>,
): SyncStartPayload {
  return {
    entity: "sync_start",
    organization_id: validateOrganizationId(value.organization_id),
    source: requiredText(value.source, "source", 300),
    source_type: requiredText(value.source_type, "source_type", 100),
    metadata: optionalObject(value.metadata, "metadata"),
  };
}

export function validateSyncFinish(
  value: Record<string, unknown>,
): SyncFinishPayload {
  const syncRunId = requiredText(value.sync_run_id, "sync_run_id", 36);
  if (!uuidPattern.test(syncRunId)) {
    throw new Error("sync_run_id must be a UUID");
  }
  const status = value.status;
  if (status !== "succeeded" && status !== "failed" && status !== "partial") {
    throw new Error("status must be succeeded, failed or partial");
  }
  const checkpoint = value.checkpoint == null
    ? null
    : optionalObject(value.checkpoint, "checkpoint");
  if (status === "succeeded" && checkpoint === null) {
    throw new Error("checkpoint object is required for a successful sync");
  }
  return {
    entity: "sync_finish",
    organization_id: validateOrganizationId(value.organization_id),
    sync_run_id: syncRunId,
    status,
    checkpoint,
    error_message: optionalText(value.error_message, "error_message", 2000),
    metadata: optionalObject(value.metadata, "metadata"),
  };
}

function requiredText(
  value: unknown,
  field: string,
  maxLength: number,
): string {
  if (typeof value !== "string" || value.trim().length === 0) {
    throw new Error(`${field} is required`);
  }
  const normalized = value.trim();
  if (normalized.length > maxLength) {
    throw new Error(`${field} is too long`);
  }
  return normalized;
}

function optionalText(
  value: unknown,
  field: string,
  maxLength: number,
): string | null {
  if (value == null) return null;
  return requiredText(value, field, maxLength);
}

function optionalObject(
  value: unknown,
  field: string,
): Record<string, unknown> {
  if (value == null) return {};
  if (typeof value !== "object" || Array.isArray(value)) {
    throw new Error(`${field} must be an object`);
  }
  return value as Record<string, unknown>;
}
