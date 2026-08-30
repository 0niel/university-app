// Run: deno test supabase/functions/miniapp-svc-free-rooms/screens_test.ts
import {
  buildFreeRoomsScreen,
  buildingOf,
  type FreeRoom,
  formatMoscowTime,
} from "./screens.ts";

function assert(cond: unknown, msg: string): void {
  if (!cond) throw new Error(`Assertion failed: ${msg}`);
}

function assertEquals<T>(actual: T, expected: T, msg: string): void {
  if (actual !== expected) {
    throw new Error(`${msg}: expected ${expected}, got ${actual}`);
  }
}

const sample: FreeRoom[] = [
  { room: "А-401", campus: "В-78", freeUntil: "2026-06-14T11:40:00Z" },
  { room: "А-105", campus: "В-78", freeUntil: null },
  { room: "Б-215", campus: "В-78", freeUntil: "2026-06-14T09:00:00Z" },
];

Deno.test("buildingOf reads the leading code, falls back to campus", () => {
  assertEquals(buildingOf(sample[0]), "А", "А-401 → А");
  assertEquals(buildingOf({ room: "Б 215" }), "Б", "space separator");
  assertEquals(buildingOf({ room: "", campus: "В-78" }), "В-78", "fallback");
});

Deno.test("formatMoscowTime renders HH:MM in MSK (UTC+3)", () => {
  assertEquals(formatMoscowTime("2026-06-14T11:40:00Z"), "14:40", "11:40Z");
  assertEquals(formatMoscowTime(null), null, "null stays null");
  assertEquals(formatMoscowTime("not-a-date"), null, "garbage stays null");
});

Deno.test("entry screen is a buildings overview, not a room dump", () => {
  const screen = buildFreeRoomsScreen(sample, "/");
  assertEquals(screen.type, "scaffold", "root is scaffold");
  const blob = JSON.stringify(screen);
  assert(blob.includes("Свободно сейчас"), "header");
  assert(blob.includes("3 аудитории"), "ru plural for the total");
  // buildings are listed and link to their sub-screens...
  assert(blob.includes("/b/А"), "links to building А");
  assert(blob.includes("/b/Б"), "links to building Б");
  // ...but individual room numbers are not on the overview.
  assert(!blob.includes("А-401"), "rooms are not on the overview");
});

Deno.test("building screen lists only that building's rooms", () => {
  const screen = buildFreeRoomsScreen(sample, "/b/А");
  const blob = JSON.stringify(screen);
  assert(blob.includes("А-105"), "А-105 present");
  assert(blob.includes("А-401"), "А-401 present");
  assert(!blob.includes("Б-215"), "Б-215 filtered out");
  assert(blob.includes("свободна до 14:40"), "formats freeUntil");
  assert(blob.includes("свободна до конца дня"), "handles null freeUntil");
});

Deno.test("empty data shows the empty state", () => {
  const blob = JSON.stringify(buildFreeRoomsScreen([], "/"));
  assert(blob.includes("appEmptyState"), "empty state widget");
  assert(blob.includes("Сейчас всё занято"), "empty copy");
});
