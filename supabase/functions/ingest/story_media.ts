const bucket = "story-media";
const maxByteSize = 50 * 1024 * 1024;
const componentPattern = /^[a-zA-Z0-9][a-zA-Z0-9._-]{0,127}$/;
const sha256Pattern = /^[a-f0-9]{64}$/;

const extensions = new Map([
  ["image/jpeg", "jpg"],
  ["video/mp4", "mp4"],
]);

export type StoryMediaUploadPayload = {
  entity: "story_media_upload";
  organization_id: string;
  channel: string;
  story_id: number;
  content_type: "image/jpeg" | "video/mp4";
  byte_size: number;
  sha256: string;
};

export type StoryMediaCleanupPayload = {
  entity: "story_media_cleanup";
  organization_id: string;
};

export type StoryMediaDeletePayload = {
  entity: "story_media_delete";
  organization_id: string;
  paths: string[];
};

export type StoryMediaObject = {
  bucket: string;
  path: string;
};

export function validateStoryMediaUpload(
  payload: Record<string, unknown>,
): StoryMediaUploadPayload {
  const organizationId = validateOrganizationId(payload.organization_id);
  const channel = component(payload.channel, "channel");
  const storyId = positiveInteger(payload.story_id, "story_id");
  const contentType = contentTypeValue(payload.content_type);
  const byteSize = positiveInteger(payload.byte_size, "byte_size");
  if (byteSize > maxByteSize) {
    throw new Error(`byte_size must not exceed ${maxByteSize}`);
  }
  const sha256 = String(payload.sha256 ?? "").toLowerCase();
  if (!sha256Pattern.test(sha256)) {
    throw new Error("sha256 must be a lowercase hexadecimal SHA-256 digest");
  }
  return {
    entity: "story_media_upload",
    organization_id: organizationId,
    channel,
    story_id: storyId,
    content_type: contentType,
    byte_size: byteSize,
    sha256,
  };
}

export function validateStoryMediaCleanup(
  payload: Record<string, unknown>,
): StoryMediaCleanupPayload {
  return {
    entity: "story_media_cleanup",
    organization_id: validateOrganizationId(payload.organization_id),
  };
}

export function validateStoryMediaDelete(
  payload: Record<string, unknown>,
): StoryMediaDeletePayload {
  const organizationId = validateOrganizationId(payload.organization_id);
  if (!Array.isArray(payload.paths) || payload.paths.length > 100) {
    throw new Error("paths must be an array with at most 100 entries");
  }
  const prefix = `organizations/${organizationId}/telegram-stories/`;
  const paths = payload.paths.map((value) => {
    if (
      typeof value !== "string" || !value.startsWith(prefix) ||
      !value.endsWith("/media") || value.split("/").length !== 6
    ) {
      throw new Error("paths contains a non-canonical story media path");
    }
    return value;
  });
  return {
    entity: "story_media_delete",
    organization_id: organizationId,
    paths,
  };
}

export function validateOrganizationId(value: unknown): string {
  return component(value, "organization_id");
}

export function storyMediaObject(
  payload: StoryMediaUploadPayload,
): StoryMediaObject {
  if (!extensions.has(payload.content_type)) {
    throw new Error("Unsupported content_type");
  }
  return {
    bucket,
    path: [
      "organizations",
      payload.organization_id,
      "telegram-stories",
      payload.channel,
      String(payload.story_id),
      "media",
    ].join("/"),
  };
}

function component(value: unknown, field: string): string {
  if (typeof value !== "string" || !componentPattern.test(value)) {
    throw new Error(`${field} contains unsupported characters`);
  }
  return value;
}

function positiveInteger(value: unknown, field: string): number {
  if (!Number.isSafeInteger(value) || Number(value) <= 0) {
    throw new Error(`${field} must be a positive integer`);
  }
  return Number(value);
}

function contentTypeValue(
  value: unknown,
): StoryMediaUploadPayload["content_type"] {
  if (value !== "image/jpeg" && value !== "video/mp4") {
    throw new Error("content_type must be image/jpeg or video/mp4");
  }
  return value;
}
