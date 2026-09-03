import { assertEquals } from "../ingest/test_assertions.ts";
import { buildNewsBlocks } from "./blocks.ts";
import type { TelegramPost } from "./telegram.ts";

const post: TelegramPost = {
  id: 42,
  channel: "example_news",
  url: "https://t.me/example_news/42",
  publishedAt: "2026-09-02T12:00:00Z",
  text: "Actual publication",
  htmlText: "Actual publication",
  media: [],
};
const channel = { username: "example_news", title: "News" };

Deno.test("video posts retain article identity and use only thumbnail as cover", () => {
  const blocks = buildNewsBlocks({
    ...post,
    media: [{
      kind: "video",
      url: "https://cdn.example/video.mp4",
      thumbUrl: "https://cdn.example/cover.jpg",
    }],
  }, channel);
  assertEquals(blocks[0].type, "__article_introduction__");
  assertEquals(blocks[0].image_url, "https://cdn.example/cover.jpg");
  assertEquals(blocks[1], {
    type: "__video__",
    video_url: "https://cdn.example/video.mp4",
  });
});

Deno.test("mixed albums keep video URLs outside image slides", () => {
  const blocks = buildNewsBlocks({
    ...post,
    media: [
      { kind: "photo", url: "https://cdn.example/one.jpg" },
      { kind: "photo", url: "https://cdn.example/two.jpg" },
      { kind: "video", url: "https://cdn.example/video.mp4" },
    ],
  }, channel);
  const slideshow = blocks.find((block) =>
    block.type === "__slideshow_introduction__"
  );
  const action = slideshow?.action as {
    slideshow: { slides: { image_url: string }[] };
  };
  assertEquals(action.slideshow.slides.map((slide) => slide.image_url), [
    "https://cdn.example/one.jpg",
    "https://cdn.example/two.jpg",
  ]);
  assertEquals(blocks.at(-1), {
    type: "__video__",
    video_url: "https://cdn.example/video.mp4",
  });
});
