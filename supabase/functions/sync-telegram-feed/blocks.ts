/// Builds news-block JSON matching the app's `news_blocks` package from a
/// parsed Telegram post. Mirrors the Python TelegramToNewsBlocksAdapter.

import type { TelegramChannelInfo, TelegramPost } from "./telegram.ts";

type Json = Record<string, unknown>;

const CATEGORY_ID = "telegram";

export function buildNewsBlocks(
  post: TelegramPost,
  channel: TelegramChannelInfo,
): Json[] {
  const photos = post.media
    .filter((item) => item.kind === "photo")
    .map((item) => item.url);
  const videos = post.media.filter((item) => item.kind === "video");
  const title = extractTitle(post, channel);
  const author = channel.title || `@${channel.username}`;
  const cover = photos[0] ?? videos[0]?.thumbUrl ??
    post.linkPreview?.imageUrl;

  const blocks: Json[] = [];

  if (photos.length > 1) {
    blocks.push(
      articleIntroduction({
        title,
        author,
        publishedAt: post.publishedAt,
        imageUrl: cover,
      }),
    );
    pushBody(blocks, post, title);
    blocks.push(slideshowIntroduction(post, title, channel, photos));
    for (const video of videos) {
      blocks.push({ type: "__video__", video_url: video.url });
    }
    return blocks;
  }

  blocks.push(
    articleIntroduction({
      title,
      author,
      publishedAt: post.publishedAt,
      imageUrl: cover,
    }),
  );
  pushBody(blocks, post, title);
  for (const url of photos.slice(1)) {
    blocks.push({ type: "__image__", image_url: url });
  }
  for (const video of videos) {
    blocks.push({ type: "__video__", video_url: video.url });
  }
  pushLinkPreview(blocks, post);
  return blocks;
}

function articleIntroduction(options: {
  title: string;
  author: string;
  publishedAt: string;
  imageUrl?: string;
}): Json {
  const block: Json = {
    type: "__article_introduction__",
    category_id: CATEGORY_ID,
    author: options.author,
    published_at: options.publishedAt,
    title: options.title,
  };
  if (options.imageUrl) block.image_url = options.imageUrl;
  return block;
}

function pushBody(blocks: Json[], post: TelegramPost, title: string): void {
  let body = post.text;
  if (body && title && body.startsWith(title.replace(/\.{3}$/, ""))) {
    body = body.slice(title.replace(/\.{3}$/, "").length)
      .replace(/^[\n :]+/, "");
  }
  if (body) {
    blocks.push({ type: "__text_lead_paragraph__", text: body });
  }
}

function pushLinkPreview(blocks: Json[], post: TelegramPost): void {
  const preview = post.linkPreview;
  if (!preview || !preview.title) return;
  blocks.push({
    type: "__text_caption__",
    color: "normal",
    text: `${preview.title}\n${preview.url}`,
  });
}

function slideshowIntroduction(
  post: TelegramPost,
  title: string,
  channel: TelegramChannelInfo,
  photos: string[],
): Json {
  const slides: Json[] = [];
  let index = 0;
  for (const url of photos) {
    slides.push({
      type: "__slide_block__",
      caption: `Фото ${++index}`,
      description: "",
      photo_credit: channel.title,
      image_url: url,
    });
  }
  const slideshow: Json = {
    type: "__slideshow__",
    title,
    slides,
  };
  return {
    type: "__slideshow_introduction__",
    title,
    cover_image_url: photos[0],
    action: {
      type: "__navigate_to_slideshow__",
      article_id: String(post.id),
      slideshow,
    },
  };
}

/// First non-empty line, merged with the second when very short.
export function extractTitle(
  post: TelegramPost,
  channel: TelegramChannelInfo,
): string {
  const text = post.text.trim() ||
    post.linkPreview?.title?.trim() ||
    "";
  if (!text) return channel.title || `@${channel.username}`;
  const lines = text.split("\n").map((line) => line.trim()).filter(Boolean);
  if (lines.length === 0) return channel.title || `@${channel.username}`;
  const first = lines[0];
  if (first.length < 20 && lines.length > 1) {
    const combined = `${first} ${lines[1]}`;
    if (combined.length <= 100) return combined;
  }
  return first.length > 100 ? `${first.slice(0, 100)}...` : first;
}
