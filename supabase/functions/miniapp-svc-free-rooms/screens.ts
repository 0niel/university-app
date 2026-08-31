// Pure screen builder for the free-rooms service mini app. No IO here so it
// can be unit-tested (see screens_test.ts); index.ts fetches the data and
// hands it to buildFreeRoomsScreen.
//
// There can be hundreds of free rooms at once, so the entry screen `/` is a
// compact per-building overview; tapping a building opens `/b/<building>`
// with just that building's rooms.

export interface FreeRoom {
  room: string;
  campus?: string | null;
  freeUntil?: string | null; // ISO timestamp, null = free until end of day
}

const ACCENT = "#1FB872";

/// Leading building code of a room name (`А-401` → `А`); falls back to campus.
/// Mirrors FreeRoom.building in campus_repository.
export function buildingOf(room: FreeRoom): string {
  const match = /^([А-ЯЁA-Z]+)[\s-]/.exec(room.room);
  return match?.[1] ?? room.campus ?? "—";
}

/// Formats an ISO timestamp as HH:MM in Moscow time (the campus timezone).
export function formatMoscowTime(iso: string | null | undefined): string | null {
  if (!iso) return null;
  const date = new Date(iso);
  if (Number.isNaN(date.getTime())) return null;
  return new Intl.DateTimeFormat("ru-RU", {
    hour: "2-digit",
    minute: "2-digit",
    hour12: false,
    timeZone: "Europe/Moscow",
  }).format(date);
}

/// Builds the Stac screen for the given path:
///   `/`             — buildings overview (counts);
///   `/b/<building>` — every free room of one building.
export function buildFreeRoomsScreen(
  rooms: FreeRoom[],
  path: string,
): Record<string, unknown> {
  if (path.startsWith("/b/")) {
    return buildingScreen(rooms, safeDecode(path.slice("/b/".length)));
  }
  return overviewScreen(rooms);
}

// --- entry: buildings overview ---------------------------------------------

function overviewScreen(rooms: FreeRoom[]): Record<string, unknown> {
  const children: unknown[] = [
    sectionTitle("Свободно сейчас", pluralRooms(rooms.length)),
    sizedBox(12),
  ];

  if (rooms.length === 0) {
    children.push(emptyState());
  } else {
    const groups = byBuilding(rooms);
    children.push({
      type: "appCard",
      padding: 4,
      child: {
        type: "column",
        children: groups.map((g, i) => buildingRow(g.code, g.count, i === 0)),
      },
    });
    children.push(sizedBox(16), refreshButton());
  }

  return scaffold(children, { refreshable: true });
}

function buildingRow(code: string, count: number, isFirst: boolean): unknown {
  return {
    type: "appListRow",
    title: code,
    subtitle: `${pluralRooms(count)} свободно`,
    emoji: "🚪",
    emojiColor: ACCENT,
    isFirst,
    trailing: { type: "appMetaPill", text: String(count), strong: true },
    onTap: { actionType: "openPage", path: `/b/${code}`, title: code },
  };
}

// --- one building -----------------------------------------------------------

function buildingScreen(
  rooms: FreeRoom[],
  code: string,
): Record<string, unknown> {
  const visible = rooms
    .filter((r) => buildingOf(r) === code)
    .sort((a, b) => a.room.localeCompare(b.room, "ru"));

  const children: unknown[] = [
    sectionTitle(code, `${pluralRooms(visible.length)} свободно`),
    sizedBox(12),
  ];

  if (visible.length === 0) {
    children.push(emptyState());
  } else {
    children.push({
      type: "appCard",
      padding: 4,
      child: {
        type: "column",
        children: visible.map((room, i) => roomRow(room, i === 0)),
      },
    });
  }

  return scaffold(children);
}

function roomRow(room: FreeRoom, isFirst: boolean): unknown {
  const until = formatMoscowTime(room.freeUntil);
  return {
    type: "appListRow",
    title: room.room,
    subtitle: until == null ? "свободна до конца дня" : `свободна до ${until}`,
    emoji: "🚪",
    emojiColor: ACCENT,
    isFirst,
    trailing: {
      type: "appMetaPill",
      text: until ?? "весь день",
      strong: until != null,
    },
  };
}

// --- shared pieces ----------------------------------------------------------

function scaffold(
  children: unknown[],
  opts: { refreshable?: boolean } = {},
): Record<string, unknown> {
  const scroll = {
    type: "singleChildScrollView",
    padding: { left: 16, right: 16, top: 16, bottom: 24 },
    child: { type: "column", crossAxisAlignment: "stretch", children },
  };
  return {
    type: "scaffold",
    body: opts.refreshable
      ? { type: "refreshIndicator", onRefresh: { actionType: "reload" }, child: scroll }
      : scroll,
  };
}

function emptyState(): unknown {
  return {
    type: "appEmptyState",
    emoji: "🔒",
    title: "Сейчас всё занято",
    subtitle: "Свободных аудиторий не нашлось. Загляни позже.",
    child: refreshButton(),
  };
}

function refreshButton(): unknown {
  return {
    type: "appButton",
    label: "Обновить",
    variant: "ghost",
    expanded: true,
    onPressed: { actionType: "reload" },
  };
}

function sectionTitle(title: string, subtitle: string): unknown {
  return { type: "appSectionTitle", title, subtitle };
}

function sizedBox(height: number): unknown {
  return { type: "sizedBox", height };
}

// --- helpers ----------------------------------------------------------------

/// Groups rooms by building, ordered by count desc then code.
function byBuilding(rooms: FreeRoom[]): Array<{ code: string; count: number }> {
  const counts = new Map<string, number>();
  for (const room of rooms) {
    const code = buildingOf(room);
    counts.set(code, (counts.get(code) ?? 0) + 1);
  }
  return [...counts.entries()]
    .map(([code, count]) => ({ code, count }))
    .sort((a, b) => b.count - a.count || a.code.localeCompare(b.code, "ru"));
}

function pluralRooms(n: number): string {
  const mod10 = n % 10;
  const mod100 = n % 100;
  let word = "аудиторий";
  if (mod10 === 1 && mod100 !== 11) word = "аудитория";
  else if (mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20)) {
    word = "аудитории";
  }
  return `${n} ${word}`;
}

function safeDecode(value: string): string {
  try {
    return decodeURIComponent(value);
  } catch {
    return value;
  }
}
