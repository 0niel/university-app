export function sessionIdFromVerifiedToken(
  authorization: string,
  userId: string,
): string | null {
  try {
    const token = authorization.replace(/^Bearer\s+/i, "");
    const parts = token.split(".");
    if (parts.length !== 3) return null;
    const encoded = parts[1].replace(/-/g, "+").replace(/_/g, "/");
    const claims = JSON.parse(
      atob(encoded.padEnd(Math.ceil(encoded.length / 4) * 4, "=")),
    );
    if (claims.sub !== userId || typeof claims.session_id !== "string") {
      return null;
    }
    return /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i
        .test(claims.session_id)
      ? claims.session_id.toLowerCase()
      : null;
  } catch {
    return null;
  }
}
