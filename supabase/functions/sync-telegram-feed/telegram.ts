/// Fetching and parsing of public Telegram channel web previews (t.me/s).

/// One media attachment parsed from a message.
export interface TelegramMedia {
  kind: "photo" | "video";
  url: string;
  thumbUrl?: string;
}

/// One parsed channel post.
export interface TelegramPost {
  id: number;
  channel: string;
  url: string;
  publishedAt: string;
  text: string;
  htmlText: string;
  media: TelegramMedia[];
  linkPreview?: {
    url: string;
    title?: string;
    description?: string;
    imageUrl?: string;
  };
  views?: string;
}

/// Channel-level metadata from the preview page.
export interface TelegramChannelInfo {
  username: string;
  title: string;
  imageUrl?: string;
  subscribers?: string;
}

export interface TelegramPreviewPage {
  channel: TelegramChannelInfo;
  posts: TelegramPost[];
}

const USER_AGENT =
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 " +
  "(KHTML, like Gecko) Chrome/126.0 Safari/537.36";

/// Fetches one page of the channel preview. `before` paginates backwards.
export async function fetchPreviewPage(
  username: string,
  before?: number,
): Promise<TelegramPreviewPage> {
  const query = before ? `?before=${before}` : "";
  const response = await fetch(`https://t.me/s/${username}${query}`, {
    headers: { "User-Agent": USER_AGENT, "Accept-Language": "ru,en" },
  });
  if (!response.ok) {
    throw new Error(`t.me/s/${username} responded ${response.status}`);
  }
  const html = await response.text();
  return {
    channel: parseChannelInfo(html, username),
    posts: parsePosts(html, username),
  };
}

function parseChannelInfo(
  html: string,
  username: string,
): TelegramChannelInfo {
  const title = decodeEntities(
    matchFirst(
      html,
      /<meta property="og:title" content="([^"]*)"/,
    ) ?? username,
  );
  const imageUrl = matchFirst(
    html,
    /<meta property="og:image" content="([^"]*)"/,
  );
  const subscribers = matchFirst(
    html,
    /<span class="counter_value">([^<]*)<\/span>\s*<span class="counter_type">subscriber/,
  );
  return {
    username,
    title: title.trim() || username,
    imageUrl: imageUrl && imageUrl.startsWith("https://")
      ? imageUrl
      : undefined,
    subscribers: subscribers?.trim(),
  };
}

function parsePosts(html: string, username: string): TelegramPost[] {
  const posts: TelegramPost[] = [];
  const chunks = html.split('<div class="tgme_widget_message_wrap').slice(1);
  for (const chunk of chunks) {
    const post = parsePost(chunk, username);
    if (post) posts.push(post);
  }
  posts.sort((a, b) => a.id - b.id);
  return posts;
}

function parsePost(chunk: string, username: string): TelegramPost | null {
  const postRef = matchFirst(
    chunk,
    new RegExp(`data-post="${escapeRegExp(username)}/(\\d+)"`, "i"),
  );
  if (!postRef) return null;
  const id = Number.parseInt(postRef, 10);
  if (!Number.isFinite(id) || id <= 0) return null;

  // Service notices (channel created / renamed / pinned) carry no content.
  if (chunk.includes("tgme_widget_message_service")) return null;

  const htmlText = matchFirst(
    chunk,
    /<div class="tgme_widget_message_text[^"]*"[^>]*>([\s\S]*?)<\/div>/,
  ) ?? "";
  const text = htmlToPlainText(htmlText);

  const media = parseMedia(chunk);
  const linkPreview = parseLinkPreview(chunk);
  if (!text && media.length === 0 && !linkPreview) return null;

  const publishedAt =
    matchFirst(chunk, /<time datetime="([^"]+)"/) ??
      new Date().toISOString();
  const views = matchFirst(
    chunk,
    /<span class="tgme_widget_message_views">([^<]*)<\/span>/,
  );

  return {
    id,
    channel: username,
    url: `https://t.me/${username}/${id}`,
    publishedAt,
    text,
    htmlText,
    media,
    linkPreview,
    views: views?.trim(),
  };
}

function parseMedia(chunk: string): TelegramMedia[] {
  const media: TelegramMedia[] = [];

  const photoPattern =
    /class="tgme_widget_message_photo_wrap[^"]*"[^>]*style="[^"]*background-image:url\('([^']+)'\)/g;
  for (const match of chunk.matchAll(photoPattern)) {
    if (match[1].startsWith("https://")) {
      media.push({ kind: "photo", url: match[1] });
    }
  }

  const videoPlayerPattern =
    /class="tgme_widget_message_(?:video_player|roundvideo_player)[^"]*"[\s\S]*?(?:style="[^"]*background-image:url\('([^']+)'\)[\s\S]*?)?<video[^>]*src="([^"]+)"/g;
  for (const match of chunk.matchAll(videoPlayerPattern)) {
    if (match[2]?.startsWith("https://")) {
      media.push({
        kind: "video",
        url: match[2],
        thumbUrl: match[1]?.startsWith("https://") ? match[1] : undefined,
      });
    }
  }

  // Large videos have a thumb but no inline <video>; surface the thumb as a
  // photo so the post still gets a cover instead of rendering as text-only.
  if (!media.some((item) => item.kind === "video")) {
    const thumbPattern =
      /class="tgme_widget_message_video_thumb[^"]*"[^>]*style="[^"]*background-image:url\('([^']+)'\)/g;
    for (const match of chunk.matchAll(thumbPattern)) {
      if (match[1].startsWith("https://")) {
        media.push({ kind: "photo", url: match[1] });
      }
    }
  }

  return media;
}

function parseLinkPreview(chunk: string): TelegramPost["linkPreview"] {
  const url = matchFirst(
    chunk,
    /class="tgme_widget_message_link_preview"[^>]*href="([^"]+)"/,
  );
  if (!url) return undefined;
  const title = matchFirst(
    chunk,
    /class="link_preview_title"[^>]*>([\s\S]*?)<\/div>/,
  );
  const description = matchFirst(
    chunk,
    /class="link_preview_description"[^>]*>([\s\S]*?)<\/div>/,
  );
  const imageUrl = matchFirst(
    chunk,
    /class="link_preview_(?:image|right_image)"[^>]*style="[^"]*background-image:url\('([^']+)'\)/,
  );
  return {
    url: decodeEntities(url),
    title: title ? htmlToPlainText(title) : undefined,
    description: description ? htmlToPlainText(description) : undefined,
    imageUrl: imageUrl?.startsWith("https://") ? imageUrl : undefined,
  };
}

/// Converts message HTML to readable plain text with preserved line breaks.
export function htmlToPlainText(html: string): string {
  return decodeEntities(
    html
      .replace(/<br\s*\/?>/gi, "\n")
      .replace(/<\/(?:p|div)>/gi, "\n")
      .replace(/<[^>]+>/g, ""),
  )
    .replace(/ /g, " ")
    .replace(/[ \t]+\n/g, "\n")
    .replace(/\n{3,}/g, "\n\n")
    .trim();
}

function decodeEntities(value: string): string {
  const named: Record<string, string> = {
    "&amp;": "&",
    "&lt;": "<",
    "&gt;": ">",
    "&quot;": '"',
    "&#39;": "'",
    "&#33;": "!",
    "&nbsp;": " ",
  };
  return value
    .replace(/&#(\d+);/g, (_, code) => String.fromCodePoint(Number(code)))
    .replace(
      /&#x([0-9a-f]+);/gi,
      (_, code) => String.fromCodePoint(Number.parseInt(code, 16)),
    )
    .replace(/&[a-z]+;|&#\d+;/gi, (entity) => named[entity] ?? entity);
}

function matchFirst(value: string, pattern: RegExp): string | undefined {
  return pattern.exec(value)?.[1];
}

function escapeRegExp(value: string): string {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}
