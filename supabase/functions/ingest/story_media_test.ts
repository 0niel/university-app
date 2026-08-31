import {
  storyMediaObject,
  validateStoryMediaCleanup,
  validateStoryMediaDelete,
  validateStoryMediaUpload,
} from "./story_media.ts";
import { assertEquals, assertThrows } from "./test_assertions.ts";

const validPayload = {
  entity: "story_media_upload",
  organization_id: "mirea",
  channel: "university_news",
  story_id: 42,
  content_type: "image/jpeg",
  byte_size: 1024,
  sha256: "a".repeat(64),
};

Deno.test("validates and builds a canonical story media path", () => {
  const payload = validateStoryMediaUpload(validPayload);

  assertEquals(storyMediaObject(payload), {
    bucket: "story-media",
    path: "organizations/mirea/telegram-stories/university_news/42/media",
  });
});

Deno.test("delete accepts only tenant-owned canonical paths", () => {
  const path = "organizations/mirea/telegram-stories/university_news/42/media";
  assertEquals(
    validateStoryMediaDelete({ organization_id: "mirea", paths: [path] }),
    { entity: "story_media_delete", organization_id: "mirea", paths: [path] },
  );
  assertThrows(() =>
    validateStoryMediaDelete({
      organization_id: "mirea",
      paths: [
        "organizations/other/telegram-stories/news/42/media",
      ],
    })
  );
});

Deno.test("rejects path traversal and arbitrary media types", () => {
  assertThrows(() =>
    validateStoryMediaUpload({ ...validPayload, channel: "../private" })
  );
  assertThrows(() =>
    validateStoryMediaUpload({ ...validPayload, content_type: "text/html" })
  );
});

Deno.test("rejects zero, oversize and malformed digest values", () => {
  assertThrows(() =>
    validateStoryMediaUpload({ ...validPayload, byte_size: 0 })
  );
  assertThrows(() =>
    validateStoryMediaUpload({ ...validPayload, byte_size: 52_428_801 })
  );
  assertThrows(() =>
    validateStoryMediaUpload({ ...validPayload, sha256: "not-a-digest" })
  );
});

Deno.test("cleanup accepts only a safe organization identifier", () => {
  assertEquals(
    validateStoryMediaCleanup({ organization_id: "university-1" }),
    { entity: "story_media_cleanup", organization_id: "university-1" },
  );
  assertThrows(() =>
    validateStoryMediaCleanup({ organization_id: "../other" })
  );
});
