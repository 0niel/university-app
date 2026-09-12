import assert from "node:assert/strict";
import { readBoundedJson, RequestBodyError } from "./request_body.ts";

const encoder = new TextEncoder();

function request(body: BodyInit, headers?: HeadersInit): Request {
  return new Request("https://miniapps.example.test", {
    method: "POST",
    body,
    headers,
  });
}

Deno.test("JSON limit measures UTF-8 bytes and accepts the exact boundary", async () => {
  const body = JSON.stringify({ name: "Экран 🧩" });
  const length = encoder.encode(body).byteLength;
  assert.deepEqual(await readBoundedJson(request(body), length), {
    name: "Экран 🧩",
  });
  await assert.rejects(
    () => readBoundedJson(request(body), length - 1),
    (error) => error instanceof RequestBodyError && error.status === 413,
  );
});

Deno.test("JSON limit reads chunked Unicode without splitting code points", async () => {
  const bytes = encoder.encode(JSON.stringify({ name: "🧩 Экран" }));
  const stream = new ReadableStream<Uint8Array>({
    start(controller) {
      for (const byte of bytes) controller.enqueue(Uint8Array.of(byte));
      controller.close();
    },
  });
  assert.deepEqual(await readBoundedJson(request(stream), bytes.length), {
    name: "🧩 Экран",
  });
});

Deno.test("JSON limit cancels an oversized stream even with a false content length", async () => {
  let cancelled = false;
  const stream = new ReadableStream<Uint8Array>({
    pull(controller) {
      controller.enqueue(encoder.encode("12345678"));
    },
    cancel() {
      cancelled = true;
    },
  });
  await assert.rejects(
    () => readBoundedJson(request(stream, { "content-length": "1" }), 16),
    (error) => error instanceof RequestBodyError && error.status === 413,
  );
  assert.equal(cancelled, true);
});

Deno.test("JSON limit rejects excessive declared length before reading", async () => {
  await assert.rejects(
    () => readBoundedJson(request("{}", { "content-length": "1024" }), 16),
    (error) => error instanceof RequestBodyError && error.status === 413,
  );
});

Deno.test("JSON limit rejects malformed and non-object request bodies", async () => {
  for (const value of ["", "{", "null", "[]", "true", "123", '"hello"']) {
    await assert.rejects(
      () => readBoundedJson(request(value), 1024),
      (error) => error instanceof RequestBodyError && error.status === 400,
    );
  }
});
