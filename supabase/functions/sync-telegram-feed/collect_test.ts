import { assertEquals } from "../ingest/test_assertions.ts";
import { collectPosts } from "./collect.ts";
import type { TelegramPost } from "./telegram.ts";

const channel = { username: "example_news", title: "News" };
function post(id: number): TelegramPost {
  return {
    id,
    channel: channel.username,
    url: `https://t.me/example_news/${id}`,
    publishedAt: "2026-10-07T10:00:00Z",
    text: "Actual publication",
    htmlText: "Actual publication",
    media: [],
  };
}

Deno.test("refreshes the latest preview even when no new posts exist", async () => {
  let requests = 0;
  const result = await collectPosts(channel.username, 42, 3, () => {
    requests++;
    return Promise.resolve({ channel, posts: [post(40), post(41), post(42)] });
  });
  assertEquals(requests, 1);
  assertEquals(result.posts.map((item) => item.id), [40, 41, 42]);
});

Deno.test("paginates new posts while refreshing only the latest older posts", async () => {
  const cursors: (number | undefined)[] = [];
  const result = await collectPosts(channel.username, 42, 3, (_, before) => {
    cursors.push(before);
    return Promise.resolve({
      channel,
      posts: before == null
        ? [post(44), post(45)]
        : [post(41), post(42), post(43)],
    });
  });
  assertEquals(cursors, [undefined, 44]);
  assertEquals(result.posts.map((item) => item.id), [43, 44, 45]);
});
