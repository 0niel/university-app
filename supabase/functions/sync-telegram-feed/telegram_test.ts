import { assertEquals } from "../ingest/test_assertions.ts";
import { htmlToPlainText, parseChannelInfo, parsePosts } from "./telegram.ts";

Deno.test("channel avatars tolerate meta order and HTML entities", () => {
  const channel = parseChannelInfo(
    '<meta content="News &amp; events" property="og:title"><meta content="https://cdn.example/a.jpg?a=1&amp;b=2" property="og:image">',
    "example_news",
  );
  assertEquals(channel.title, "News & events");
  assertEquals(channel.imageUrl, "https://cdn.example/a.jpg?a=1&b=2");
});

Deno.test("invalid entities do not abort an entire feed page", () => {
  assertEquals(htmlToPlainText("A &#99999999; B"), "A \ufffd B");
});

Deno.test("posts without a valid published time are not dated as new", () => {
  assertEquals(
    parsePosts(
      '<div class="tgme_widget_message_wrap"><div data-post="example_news/42"><div class="tgme_widget_message_text">Actual text</div></div>',
      "example_news",
    ),
    [],
  );
});
