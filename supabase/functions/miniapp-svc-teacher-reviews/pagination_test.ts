import { parseRoute } from "./domain.ts";
import { createHandler } from "./handler.ts";
import { buildScreen, reviewPage } from "./screens.ts";
const teacherId = "f16a58a9-69cc-4328-beee-318855cbe101";
const userId = "00000000-0000-4000-8000-000000000001";
const assert = (condition: unknown, message: string) => {
  if (!condition) throw new Error(message);
};
function nodes(value: unknown): Record<string, unknown>[] {
  if (Array.isArray(value)) return value.flatMap(nodes);
  if (value === null || typeof value !== "object") return [];
  return [
    value as Record<string, unknown>,
    ...Object.values(value).flatMap(nodes),
  ];
}
function fixture(count: number, body = "") {
  return {
    teacher: {
      id: teacherId,
      name: "Ильиченкова Зоя Викторовна",
      reviews: count,
      reviews_list: Array.from(
        { length: count },
        (_, i) => ({
          id: `review-${i}`,
          created_at: new Date(1700000000000 - i * 1000).toISOString(),
          teacher_id: teacherId,
          author: `Author ${i}`,
          body,
          rating: 3,
          clarity: 3,
          loyalty: 3,
          usefulness: 3,
          helpful: i,
          voted: i % 2 === 0,
          mine: i === 25,
          anonymous: false,
        }),
      ),
    },
  };
}
Deno.test("all 51 reviews remain accessible on disjoint bounded pages", () => {
  const state = fixture(51, "界".repeat(2000)), authors: string[] = [];
  for (let page = 0; page < 3; page++) {
    const data = reviewPage(state, page),
      items = data.items as Record<string, unknown>[];
    authors.push(...items.map((item) => String(item.author)));
    const screen = buildScreen("/teacher", state, { id: teacherId, page });
    const bytes = new TextEncoder().encode(JSON.stringify(screen)).length;
    assert(
      bytes < 512 * 1024,
      `Page ${page} exceeds the gateway limit: ${bytes}`,
    );
    assert(
      data.page === page && data.last === 2 && data.count === 51,
      "Incorrect page metadata",
    );
    assert(items.length === (page < 2 ? 20 : 11), "Incorrect page length");
    assert(
      !nodes(screen).some((n) =>
        n.actionType === "openPage" && String(n.path).includes("&page=")
      ),
      "Pager grows the navigation stack",
    );
  }
  assert(
    authors.length === 51 && new Set(authors).size === 51,
    "Reviews were lost or repeated",
  );
});
Deno.test("invalid pages and removed reviews keep navigation in range", () => {
  for (const value of ["-1", "1.2", "oops", "Infinity", "9007199254740992"]) {
    assert(
      parseRoute(`/teacher?id=${teacherId}&page=${value}`).page === 0,
      "Unsafe page accepted",
    );
  }
  assert(
    parseRoute(`/teacher?id=${teacherId}&page=2`).page === 2,
    "Page not parsed",
  );
  const page = reviewPage(fixture(21), 100);
  assert(page.page === 1 && page.end === 21, "Stale page did not clamp");
  for (const count of [0, 1, 20]) {
    assert(reviewPage(fixture(count)).last === 0, "Unneeded pagination");
  }
});
Deno.test("later pages retain per-review votes and edit ownership", () => {
  const items = reviewPage(fixture(51), 1).items as Record<string, unknown>[];
  assert(
    items[0].id === "review-20" && items[0].helpful === 20 &&
      items[0].voted === true,
    "Votes came from another page",
  );
  assert(
    items[5].mine === true && items[5].teacher_id === teacherId,
    "Own-review edit target lost",
  );
  const tree = nodes(buildScreen("/teacher", fixture(51), { id: teacherId }));
  assert(
    tree.some((n) => n.key === "v_{{item.id}}"),
    "Vote state is not keyed by review ID",
  );
  assert(
    tree.some((n) => n.path === "/review?id={{item.teacher_id}}"),
    "Own-review editing lost",
  );
});
Deno.test("handler serves inline pagination and rejects invalid requests", async () => {
  const handler = createHandler(
    "test-key-for-pagination-only",
    (_user, action, payload) => {
      assert(
        action === "state" && payload?.id === teacherId,
        "Dispatch changed",
      );
      return Promise.resolve(fixture(51));
    },
  );
  const request = (
    path: string,
    body: unknown = {},
    kind = "api",
    method = "POST",
  ) =>
    handler(
      new Request("https://miniapp.test", {
        method: "POST",
        headers: { Authorization: "Bearer test-key-for-pagination-only" },
        body: JSON.stringify({
          organizationId: "mirea",
          slug: "teacher-reviews",
          userId,
          path,
          kind,
          method,
          body,
        }),
      }),
    );
  const response = await request("/api/reviews", { id: teacherId, page: 2 });
  assert(response.status === 200, "Page request failed");
  const data = await response.json();
  assert(
    data.page === 2 && data.items[0].id === "review-40" &&
      data.items.length === 11,
    "Wrong page returned",
  );
  assert(
    (await request("/api/reviews", { id: teacherId, page: -1 })).status === 422,
    "Invalid page accepted",
  );
  assert(
    (await request("/api/reviews", { id: "invalid", page: 0 })).status === 404,
    "Invalid teacher accepted",
  );
  assert(
    (await request("/api/reviews", {}, "api", "GET")).status === 405,
    "Invalid method accepted",
  );
  const tree = nodes(
    await (await request(`/teacher?id=${teacherId}&page=2`, {}, "screen"))
      .json(),
  );
  const initial = tree.find((n) => n.type === "appStateScope")!
    .initial as Record<string, unknown>;
  assert(
    (initial.reviewPage as Record<string, unknown>).page === 2,
    "Deep-link page was lost",
  );
});
