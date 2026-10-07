import { assertEquals } from "../ingest/test_assertions.ts";
import { buildNewsBlocks } from "./blocks.ts";
import { TelegramImageMirror, telegramImageUploader } from "./media.ts";
import type { TelegramPost } from "./telegram.ts";

const jpeg = new Uint8Array([0xff, 0xd8, 0xff, 0xe0, 1, 2, 3]);
const image = "https://cdn4.telesco.pe/file/cover.jpg?signature=first";
const channel = { username: "example_news", title: "News", imageUrl: image };
const post: TelegramPost = {
  id: 42,
  channel: channel.username,
  url: "https://t.me/example_news/42",
  publishedAt: "2026-10-07T10:00:00Z",
  text: "Actual publication",
  htmlText: "Actual publication",
  media: [{ kind: "photo", url: image }],
};

function imageResponse() {
  return new Response(jpeg, { headers: { "Content-Type": "image/jpeg" } });
}

Deno.test("mirrors avatars, albums, and video covers without rewriting video URLs", async () => {
  const uploads: string[] = [];
  let requests = 0;
  const mirror = new TelegramImageMirror("mirea", (path) => {
    uploads.push(path);
    return Promise.resolve(`https://app.example/storage/${path}`);
  }, () => {
    requests++;
    return Promise.resolve(imageResponse());
  });
  const source = {
    ...post,
    media: [
      ...post.media,
      { kind: "photo" as const, url: `${image}2` },
      {
        kind: "video" as const,
        url: "https://cdn4.telesco.pe/video.mp4",
        thumbUrl: image,
      },
    ],
  };
  const result = await mirror.mirror(channel, [source]);
  const publicUrl = `https://app.example/storage/${uploads[0]}`;
  assertEquals(result.channel.imageUrl, publicUrl);
  assertEquals(result.posts[0].media.map((item) => item.url), [
    publicUrl,
    publicUrl,
    "https://cdn4.telesco.pe/video.mp4",
  ]);
  assertEquals(result.posts[0].media[2].thumbUrl, publicUrl);
  assertEquals(requests, 2);
  assertEquals(uploads.length, 1);
  assertEquals(
    /^organizations\/mirea\/telegram-feed\/[a-f0-9]{64}\.jpg$/.test(uploads[0]),
    true,
  );
  assertEquals(
    buildNewsBlocks(result.posts[0], result.channel)[0].image_url,
    publicUrl,
  );
  assertEquals(source.media[0].url, image);
});

Deno.test("repeated signed image URLs use the same Storage object and permit upsert", async () => {
  const paths: string[] = [];
  const upload = telegramImageUploader(
    "https://app.example",
    "test-key",
    (input, init) => {
      paths.push(String(input));
      assertEquals(new Headers(init?.headers).get("x-upsert"), "true");
      assertEquals(init?.signal instanceof AbortSignal, true);
      return Promise.resolve(
        Response.json({ Key: "story-media/image.jpg", Id: "image-id" }),
      );
    },
  );
  const first = await new TelegramImageMirror(
    "mirea",
    upload,
    () => Promise.resolve(imageResponse()),
  )
    .mirror(channel, [post]);
  const second = await new TelegramImageMirror(
    "mirea",
    upload,
    () => Promise.resolve(imageResponse()),
  )
    .mirror({ ...channel, imageUrl: `${image}2` }, [{
      ...post,
      media: [{ kind: "photo", url: `${image}2` }],
    }], 42);
  assertEquals(paths.length, 2);
  assertEquals(paths[0], paths[1]);
  assertEquals(first.posts[0].media[0].url, second.posts[0].media[0].url);
});

Deno.test("failed refreshes preserve existing posts and avatar while importing new text", async () => {
  const mirror = new TelegramImageMirror("mirea", () => {
    throw new Error("Storage unavailable");
  }, () => Promise.resolve(imageResponse()));
  const result = await mirror.mirror(channel, [post, { ...post, id: 43 }], 42);
  assertEquals(result.channel.imageUrl, undefined);
  assertEquals(result.posts.map((item) => item.id), [43]);
  assertEquals(result.posts[0].text, post.text);
  assertEquals(result.posts[0].media[0].url, image);
});

Deno.test("a later fetch outage cannot replace previously mirrored media", async () => {
  const first = await new TelegramImageMirror(
    "mirea",
    (path) => Promise.resolve(`https://app.example/${path}`),
    () => Promise.resolve(imageResponse()),
  )
    .mirror(channel, [post]);
  const second = await new TelegramImageMirror("mirea", () => {
    throw new Error("Unexpected upload");
  }, () => {
    throw new Error("Origin unavailable");
  }).mirror(channel, [post], 42);
  assertEquals(first.posts.length, 1);
  assertEquals(second.posts, []);
  assertEquals(second.channel.imageUrl, undefined);
});

Deno.test("does not fetch arbitrary URLs or follow CDN redirects", async () => {
  const requests: string[] = [];
  const mirror = new TelegramImageMirror("mirea", () => {
    throw new Error("Unexpected upload");
  }, (input, init) => {
    requests.push(String(input));
    assertEquals(init?.redirect, "error");
    throw new TypeError("Redirect blocked");
  });
  const urls = [
    "https://127.0.0.1/private.jpg",
    "http://cdn4.telesco.pe/photo.jpg",
    "https://cdn4.telesco.pe.evil.example/photo.jpg",
    "https://user:password@cdn4.telesco.pe/photo.jpg",
    "https://cdn4.telesco.pe:8443/photo.jpg",
    "https://example.com/photo.jpg",
    image,
  ];
  const result = await mirror.mirror({ ...channel, imageUrl: undefined }, [{
    ...post,
    media: urls.map((url) => ({ kind: "photo", url })),
  }]);
  assertEquals(requests, [image]);
  assertEquals(result.posts[0].media.map((item) => item.url), urls);
});

Deno.test("rejects oversized and non-JPEG bodies without losing new posts", async () => {
  const responses = [
    new Response(jpeg, {
      headers: {
        "Content-Type": "image/jpeg",
        "Content-Length": String(10 * 1024 * 1024 + 1),
      },
    }),
    new Response(new Uint8Array(10 * 1024 * 1024 + 1), {
      headers: { "Content-Type": "image/jpeg" },
    }),
    new Response("<html>Not an image</html>", {
      headers: { "Content-Type": "image/jpeg" },
    }),
    new Response(jpeg, { headers: { "Content-Type": "text/html" } }),
    new Response("Unavailable", { status: 500 }),
  ];
  for (const response of responses) {
    const result = await new TelegramImageMirror("mirea", () => {
      throw new Error("Unexpected upload");
    }, () => Promise.resolve(response)).mirror(channel, [post]);
    assertEquals(result.posts[0].media[0].url, image);
    assertEquals(result.posts[0].text, post.text);
  }
});

Deno.test("exhausted media budget skips remaining downloads and preserves existing posts", async () => {
  let now = 0;
  let requests = 0;
  const mirror = new TelegramImageMirror(
    "mirea",
    (path) => Promise.resolve(`https://app.example/${path}`),
    () => {
      requests++;
      now += 15000;
      return Promise.resolve(imageResponse());
    },
    () => now,
  );
  const result = await mirror.mirror({ ...channel, imageUrl: undefined }, [
    post,
    { ...post, id: 43, media: [{ kind: "photo", url: `${image}2` }] },
    { ...post, id: 44, media: [{ kind: "photo", url: `${image}3` }] },
  ], 44);
  assertEquals(requests, 2);
  assertEquals(result.posts.map((item) => item.id), [43, 44]);
});

Deno.test("the same deadline aborts a stalled Storage upload", async () => {
  let calls = 0;
  let downloadSignal: AbortSignal | undefined;
  const mirror = new TelegramImageMirror("mirea", (_path, _data, signal) => {
    assertEquals(signal, downloadSignal);
    return new Promise((_, reject) => {
      signal.addEventListener("abort", () => reject(signal.reason), {
        once: true,
      });
    });
  }, (_, init) => {
    downloadSignal = init?.signal ?? undefined;
    return Promise.resolve(imageResponse());
  }, () => ++calls <= 2 ? 0 : 29999);
  const result = await mirror.mirror({ ...channel, imageUrl: undefined }, [
    post,
  ]);
  assertEquals(result.posts[0].media[0].url, image);
  assertEquals(result.posts[0].text, post.text);
});
