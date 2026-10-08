import { createClient } from "@supabase/supabase-js";
import { validateOrganizationId } from "../ingest/story_media.ts";
import type { TelegramChannelInfo, TelegramPost } from "./telegram.ts";

const maxImageBytes = 10 * 1024 * 1024;
const maxImages = 100;
const cdnHost =
  /^(?:cdn\d+\.)?(?:telesco\.pe|telegram-cdn\.org|cdn-telegram\.org)$/;

export type UploadImage = (
  path: string,
  data: Uint8Array,
  signal: AbortSignal,
) => Promise<string>;

export function telegramImageUploader(
  supabaseUrl: string,
  serviceRoleKey: string,
  request: typeof fetch = fetch,
): UploadImage {
  return async (path, data, signal) => {
    const storage = createClient(supabaseUrl, serviceRoleKey, {
      auth: { persistSession: false, autoRefreshToken: false },
      global: {
        fetch: (input, init) => request(input, { ...init, signal }),
      },
    }).storage.from("story-media");
    const { error } = await storage.upload(path, data, {
      contentType: "image/jpeg",
      cacheControl: "31536000",
      upsert: true,
    });
    if (error) throw error;
    return storage.getPublicUrl(path).data.publicUrl;
  };
}

export class TelegramImageMirror {
  private readonly images = new Map<string, Promise<string>>();
  private readonly uploads = new Map<string, Promise<string>>();
  private readonly organizationId: string;
  private readonly deadline: number;

  constructor(
    organizationId: string,
    private readonly upload: UploadImage,
    private readonly request: typeof fetch = fetch,
    private readonly now: () => number = Date.now,
  ) {
    this.organizationId = validateOrganizationId(organizationId);
    this.deadline = this.now() + 30000;
  }

  async mirror(
    channel: TelegramChannelInfo,
    posts: TelegramPost[],
    lastMessageId: number | null = null,
  ): Promise<{ channel: TelegramChannelInfo; posts: TelegramPost[] }> {
    const avatar = channel.imageUrl
      ? await this.image(channel.imageUrl)
      : undefined;
    const mirroredChannel = {
      ...channel,
      imageUrl: avatar && channel.imageUrl && telegramImageUrl(avatar)
        ? undefined
        : avatar,
    };
    const mirroredPosts: TelegramPost[] = [];
    for (const post of [...posts].sort((a, b) => b.id - a.id)) {
      const media = [];
      let failed = false;
      for (const item of post.media) {
        const url = item.kind === "photo"
          ? await this.image(item.url)
          : item.url;
        const thumbUrl = item.thumbUrl
          ? await this.image(item.thumbUrl)
          : undefined;
        failed ||= (item.kind === "photo" && telegramImageUrl(url)) ||
          (thumbUrl != null && telegramImageUrl(thumbUrl));
        media.push({
          ...item,
          url,
          thumbUrl,
        });
      }
      const previewImage = post.linkPreview?.imageUrl
        ? await this.image(post.linkPreview.imageUrl)
        : undefined;
      failed ||= previewImage != null && telegramImageUrl(previewImage);
      if (failed && lastMessageId != null && post.id <= lastMessageId) continue;
      mirroredPosts.push({
        ...post,
        media,
        linkPreview: post.linkPreview
          ? {
            ...post.linkPreview,
            imageUrl: previewImage,
          }
          : undefined,
      });
    }
    return {
      channel: mirroredChannel,
      posts: mirroredPosts.sort((a, b) => a.id - b.id),
    };
  }

  private image(url: string): Promise<string> {
    if (!telegramImageUrl(url)) return Promise.resolve(url);
    const pending = this.images.get(url);
    if (pending) return pending;
    if (this.images.size >= maxImages || this.now() >= this.deadline) {
      return Promise.resolve(url);
    }
    const result = this.download(url).catch(() => url);
    this.images.set(url, result);
    return result;
  }

  private async download(url: string): Promise<string> {
    const signal = AbortSignal.timeout(
      Math.min(10000, Math.max(1, this.deadline - this.now())),
    );
    const response = await this.request(url, {
      redirect: "error",
      signal,
    });
    if (
      !response.ok ||
      response.headers.get("content-type")?.split(";")[0].trim()
          .toLowerCase() !==
        "image/jpeg" ||
      Number(response.headers.get("content-length")) > maxImageBytes
    ) {
      await response.body?.cancel();
      throw new Error("Telegram image response is invalid");
    }
    const reader = response.body?.getReader();
    if (!reader) throw new Error("Telegram image body is missing");
    const chunks: Uint8Array[] = [];
    let length = 0;
    try {
      while (true) {
        const { done, value } = await reader.read();
        if (done) break;
        length += value.byteLength;
        if (length > maxImageBytes) {
          throw new Error("Telegram image is too large");
        }
        chunks.push(value);
      }
    } finally {
      await reader.cancel();
      reader.releaseLock();
    }
    const data = new Uint8Array(length);
    let offset = 0;
    for (const chunk of chunks) {
      data.set(chunk, offset);
      offset += chunk.byteLength;
    }
    if (
      length < 3 || data[0] !== 0xff || data[1] !== 0xd8 || data[2] !== 0xff
    ) {
      throw new Error("Telegram image is not a JPEG");
    }
    const digest = await crypto.subtle.digest("SHA-256", data);
    const hash = [...new Uint8Array(digest)]
      .map((byte) => byte.toString(16).padStart(2, "0")).join("");
    const path =
      `organizations/${this.organizationId}/telegram-feed/${hash}.jpg`;
    let upload = this.uploads.get(path);
    if (!upload) {
      upload = this.upload(path, data, signal);
      this.uploads.set(path, upload);
    }
    return await upload;
  }
}

function telegramImageUrl(value: string): boolean {
  try {
    const url = new URL(value);
    return url.protocol === "https:" && !url.username && !url.password &&
      (!url.port || url.port === "443") && cdnHost.test(url.hostname);
  } catch {
    return false;
  }
}
