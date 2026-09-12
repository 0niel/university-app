export class RequestBodyError extends Error {
  constructor(message: string, readonly status: number) {
    super(message);
  }
}

export async function readBoundedJson(
  request: Request,
  maxBytes: number,
): Promise<Record<string, unknown>> {
  if (Number(request.headers.get("content-length")) > maxBytes) {
    throw new RequestBodyError("Body too large", 413);
  }
  const reader = request.body?.getReader();
  if (!reader) throw new RequestBodyError("Invalid JSON body", 400);

  const bytes = new Uint8Array(maxBytes);
  let received = 0;
  try {
    while (true) {
      const { value, done } = await reader.read();
      if (done) break;
      if (received + value.byteLength > maxBytes) {
        await reader.cancel().catch(() => {});
        throw new RequestBodyError("Body too large", 413);
      }
      bytes.set(value, received);
      received += value.byteLength;
    }
  } finally {
    reader.releaseLock();
  }

  let parsed: unknown;
  try {
    parsed = JSON.parse(new TextDecoder().decode(bytes.subarray(0, received)));
  } catch {
    throw new RequestBodyError("Invalid JSON body", 400);
  }
  if (!parsed || typeof parsed !== "object" || Array.isArray(parsed)) {
    throw new RequestBodyError("JSON body must be an object", 400);
  }
  return parsed as Record<string, unknown>;
}
