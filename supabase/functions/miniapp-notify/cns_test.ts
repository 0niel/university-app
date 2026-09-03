import assert from "node:assert/strict";
import { Buffer } from "node:buffer";
import { createHash, createHmac } from "node:crypto";
import {
  createPlatformEndpoint,
  isMissingEndpointError,
  isStaleEndpointError,
  publishPush,
} from "./cns.ts";

const config = { accessKeyId: "test-access", secretKey: "test-secret" };

function assertSignedRequest(input: RequestInfo | URL, init?: RequestInit) {
  assert.equal(input, "https://notifications.yandexcloud.net/");
  assert.equal(init?.method, "POST");
  assert.equal(typeof init?.body, "string");
  const body = init!.body as string;
  const headers = new Headers(init?.headers);
  const date = headers.get("X-Amz-Date")!;
  assert.match(date, /^\d{8}T\d{6}Z$/);
  const contentType = "application/x-www-form-urlencoded; charset=utf-8";
  assert.equal(headers.get("Content-Type"), contentType);
  const signedHeaders = "content-type;host;x-amz-date";
  const canonicalRequest = [
    "POST",
    "/",
    "",
    `content-type:${contentType}\nhost:notifications.yandexcloud.net\nx-amz-date:${date}\n`,
    signedHeaders,
    createHash("sha256").update(body).digest("hex"),
  ].join("\n");
  const scope = `${date.slice(0, 8)}/ru-central1/sns/aws4_request`;
  const signingKey = [date.slice(0, 8), "ru-central1", "sns", "aws4_request"]
    .reduce<Uint8Array>(
      (key, value) => createHmac("sha256", key).update(value).digest(),
      Buffer.from(`AWS4${config.secretKey}`),
    );
  const signature = createHmac("sha256", signingKey).update([
    "AWS4-HMAC-SHA256",
    date,
    scope,
    createHash("sha256").update(canonicalRequest).digest("hex"),
  ].join("\n")).digest("hex");
  assert.equal(
    headers.get("Authorization"),
    `AWS4-HMAC-SHA256 Credential=${config.accessKeyId}/${scope}, SignedHeaders=${signedHeaders}, Signature=${signature}`,
  );
  return new URLSearchParams(body);
}

Deno.test("endpoint registration signs encoded payload and parses JSON and XML", async () => {
  const originalFetch = globalThis.fetch;
  try {
    for (
      const response of [
        '{"EndpointArn":"test-endpoint"}',
        "<EndpointArn>test-endpoint</EndpointArn>",
      ]
    ) {
      let calls = 0;
      globalThis.fetch = (input, init) => {
        calls++;
        const params = assertSignedRequest(input, init);
        assert.equal(params.get("Action"), "CreatePlatformEndpoint");
        assert.equal(params.get("PlatformApplicationArn"), "test-channel");
        assert.equal(params.get("Token"), "токен +/&=");
        assert.equal(params.get("ResponseFormat"), "json");
        return Promise.resolve(new Response(response));
      };
      assert.equal(
        await createPlatformEndpoint(config, "test-channel", "токен +/&="),
        "test-endpoint",
      );
      assert.equal(calls, 1);
    }
  } finally {
    globalThis.fetch = originalFetch;
  }
});

Deno.test("publish signs all platform payloads without sending a notification", async () => {
  const originalFetch = globalThis.fetch;
  let calls = 0;
  try {
    globalThis.fetch = (input, init) => {
      calls++;
      const params = assertSignedRequest(input, init);
      assert.equal(params.get("Action"), "Publish");
      assert.equal(params.get("TargetArn"), "test-endpoint");
      assert.equal(params.get("MessageStructure"), "json");
      const message = JSON.parse(params.get("Message")!);
      assert.equal(message.default, "Новая пара");
      const expected = {
        notification: { title: "Расписание", body: "Новая пара" },
        data: { type: "schedule", route: "/schedule?day=4" },
      };
      for (const platform of ["GCM", "HMS", "RUSTORE"]) {
        assert.deepEqual(JSON.parse(message[platform]), expected);
      }
      assert.deepEqual(JSON.parse(message.APNS), {
        aps: { alert: expected.notification },
        ...expected.data,
      });
      return Promise.resolve(new Response("{}"));
    };
    await publishPush(config, "test-endpoint", {
      title: "Расписание",
      body: "Новая пара",
      route: "/schedule?day=4",
      type: "schedule",
    });
    assert.equal(calls, 1);
  } finally {
    globalThis.fetch = originalFetch;
  }
});

Deno.test("registration rejects unsuccessful and malformed responses", async () => {
  const originalFetch = globalThis.fetch;
  try {
    globalThis.fetch = () =>
      Promise.resolve(new Response("denied", { status: 403 }));
    await assert.rejects(
      createPlatformEndpoint(config, "test-channel", "test-token"),
      /CNS CreatePlatformEndpoint failed \(403\)/,
    );
    globalThis.fetch = () => Promise.resolve(new Response("{}"));
    await assert.rejects(
      createPlatformEndpoint(config, "test-channel", "test-token"),
      /CreatePlatformEndpoint: no ARN/,
    );
  } finally {
    globalThis.fetch = originalFetch;
  }
});

Deno.test("only explicit publish endpoint failures affect device state", async () => {
  const originalFetch = globalThis.fetch;
  try {
    for (
      const [code, subCode, stale, missing] of [
        ["NotFound", "AppNotFound", false, false],
        ["NotFound", "FolderNotFound", false, false],
        ["NotFound", "AccountNotFound", false, false],
        ["NotFound", "", false, false],
        ["InvalidParameter", "InvalidParameter", false, false],
        ["InvalidParameter", "InvalidAttribute", false, false],
        ["AuthorizationError", "Unauthorized", false, false],
        ["ThrottlingException", "TooManyRequests", false, false],
        ["EndpointDisabled", "", true, false],
        ["NotFound", "EndpointNotFound", false, true],
      ] as const
    ) {
      for (const format of ["json", "xml"]) {
        const body = format === "json"
          ? JSON.stringify({
            ErrorResponse: {
              Error: {
                Code: code,
                SubCode: subCode,
                Message: "EndpointDisabled private diagnostic",
              },
            },
          })
          : `<ErrorResponseXML><Error><Code>${code}</Code><SubCode>${subCode}</SubCode><Message>EndpointDisabled private diagnostic</Message></Error></ErrorResponseXML>`;
        globalThis.fetch = () =>
          Promise.resolve(new Response(body, { status: 400 }));
        for (const operation of ["Publish", "CreatePlatformEndpoint"]) {
          await assert.rejects(
            operation === "Publish"
              ? publishPush(config, "endpoint", {
                title: "Title",
                body: "Body",
                route: "/",
                type: "mini_app",
              })
              : createPlatformEndpoint(config, "channel", "token"),
            (error: unknown) => {
              assert.equal(
                isStaleEndpointError(error),
                operation === "Publish" && stale,
              );
              assert.equal(
                isMissingEndpointError(error),
                operation === "Publish" && missing,
              );
              assert.equal(String(error).includes("private diagnostic"), false);
              return true;
            },
          );
        }
      }
    }
    assert.equal(isStaleEndpointError(new Error("EndpointDisabled")), false);
    assert.equal(isMissingEndpointError(new Error("EndpointNotFound")), false);
  } finally {
    globalThis.fetch = originalFetch;
  }
});
