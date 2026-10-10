import assert from "node:assert/strict";
import { sessionIdFromVerifiedToken } from "./session_context.ts";

const user = "00000000-0000-0000-0000-000000000001";
const session = "00000000-0000-0000-0000-000000000002";
function token(claims: unknown): string {
  return `Bearer e30.${
    btoa(JSON.stringify(claims)).replace(/\+/g, "-").replace(/\//g, "_")
      .replace(/=+$/, "")
  }.verified`;
}

Deno.test("verified token context binds the session to the authenticated subject", () => {
  assert.equal(
    sessionIdFromVerifiedToken(token({ sub: user, session_id: session }), user),
    session,
  );
  assert.equal(
    sessionIdFromVerifiedToken(
      token({ sub: session, session_id: session }),
      user,
    ),
    null,
  );
});

Deno.test("missing or malformed session context fails closed", () => {
  for (
    const authorization of [
      "Bearer broken",
      "Bearer e30.broken.verified",
      token({ sub: user }),
      token({ sub: user, session_id: "invalid" }),
      token(null),
    ]
  ) {
    assert.equal(sessionIdFromVerifiedToken(authorization, user), null);
  }
});
