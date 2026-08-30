import { isDeepStrictEqual } from "node:util";

export function assertEquals(actual: unknown, expected: unknown) {
  if (!isDeepStrictEqual(actual, expected)) {
    throw new Error(
      `Expected ${JSON.stringify(expected)}, got ${JSON.stringify(actual)}`,
    );
  }
}

export function assertThrows(
  callback: () => void,
  errorType: typeof Error = Error,
  messageIncludes?: string,
) {
  try {
    callback();
  } catch (error) {
    if (!(error instanceof errorType)) {
      throw new Error(`Expected ${errorType.name}, got ${String(error)}`);
    }
    if (messageIncludes && !error.message.includes(messageIncludes)) {
      throw new Error(
        `Expected error message to include ${messageIncludes}, got ${error.message}`,
      );
    }
    return;
  }
  throw new Error("Expected callback to throw");
}
