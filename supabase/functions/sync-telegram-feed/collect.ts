import {
  fetchPreviewPage,
  type TelegramChannelInfo,
  type TelegramPost,
} from "./telegram.ts";

export async function collectPosts(
  username: string,
  afterId: number | null,
  backfillPages: number,
  fetchPage: typeof fetchPreviewPage = fetchPreviewPage,
): Promise<{ channel: TelegramChannelInfo; posts: TelegramPost[] }> {
  const collected = new Map<number, TelegramPost>();
  let page = await fetchPage(username);
  const channel = page.channel;
  let pages = 1;
  const maxPages = afterId == null ? Math.min(backfillPages, 6) : 6;

  while (true) {
    for (const post of page.posts) {
      if (pages === 1 || afterId == null || post.id > afterId) {
        collected.set(post.id, post);
      }
    }
    const oldest = page.posts[0]?.id;
    const reachedCheckpoint = afterId != null &&
      oldest != null && oldest <= afterId;
    if (
      reachedCheckpoint || page.posts.length === 0 || pages >= maxPages ||
      oldest == null || oldest <= 1
    ) {
      break;
    }
    page = await fetchPage(username, oldest);
    pages += 1;
  }

  const posts = [...collected.values()].sort((a, b) => a.id - b.id);
  return { channel, posts };
}
