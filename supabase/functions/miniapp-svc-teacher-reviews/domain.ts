export type Json = Record<string, unknown>;
export const slug = "teacher-reviews";
export const dimensions: Record<string, { label: string; short: string }> = {
  clarity: { label: "Понятность", short: "Понятно" },
  loyalty: { label: "Лояльность", short: "Лояльно" },
  usefulness: { label: "Польза", short: "Полезно" },
};
export const boards: Record<string, { label: string; hint: string }> = {
  overall: { label: "Общий", hint: "Сглаженная средняя оценка" },
  clarity: { label: "Понятность", hint: "Кто объясняет понятнее всех" },
  loyalty: { label: "Лояльность", hint: "К кому проще на зачёте" },
  usefulness: { label: "Польза", hint: "Чьи пары дают больше всего" },
  discussed: { label: "Обсуждаемые", hint: "Больше всего отзывов" },
  rising: { label: "Растущие", hint: "Новые отзывы за 30 дней" },
};
export const sorts: Record<string, string> = {
  rating: "По рейтингу",
  reviews: "По отзывам",
  new: "Новые отзывы",
  name: "По алфавиту",
};
export const scopes: Record<string, string> = {
  all: "Все",
  group: "Моя группа",
  followed: "Слежу",
  reviewed: "Мои отзывы",
};
export const ratingHints: Record<string, string[]> = {
  clarity: [
    "Ничего не понятно",
    "Сложно уловить",
    "Местами понятно",
    "Понятно",
    "Кристально ясно",
  ],
  loyalty: [
    "Очень строго",
    "Строго",
    "Справедливо",
    "Лояльно",
    "Максимально лояльно",
  ],
  usefulness: [
    "Бесполезно",
    "Мало пользы",
    "Кое-что пригодится",
    "Полезно",
    "Очень полезно",
  ],
};
export class InputError extends Error {
  constructor(message = "Проверьте заполненные поля", public status = 422) {
    super(message);
  }
}
export const object = (v: unknown): Json =>
  v && typeof v === "object" && !Array.isArray(v) ? v as Json : {};
export const list = (v: unknown): Json[] =>
  Array.isArray(v) ? v.map(object) : [];
export const string = (v: unknown): string => typeof v === "string" ? v : "";
export const number = (v: unknown, fallback = 0): number =>
  typeof v === "number" && Number.isFinite(v)
    ? v
    : typeof v === "string" && v.trim() !== "" && Number.isFinite(Number(v))
    ? Number(v)
    : fallback;
export const safeText = (v: unknown): string =>
  string(v).replace(/\{\{/g, "｛｛").replace(/\}\}/g, "｝｝");
export const uuid = (v: unknown): boolean =>
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(
    string(v),
  );
export function textInput(v: unknown, min: number, max: number): string {
  const s = string(v).trim();
  if (
    s.length < min || s.length > max || /\{\{|\}\}/.test(s) ||
    [...s].some((c) =>
      c.charCodeAt(0) < 32 && ![9, 10, 13].includes(c.charCodeAt(0))
    )
  ) throw new InputError();
  return s;
}
export function ratingInput(v: unknown): number {
  const n = typeof v === "string" ? Number(v) : v;
  if (!Number.isInteger(n) || (n as number) < 1 || (n as number) > 5) {
    throw new InputError("Поставьте оценку от 1 до 5");
  }
  return n as number;
}
export function parseRoute(
  raw: unknown,
): { path: string; id: string; page: number } {
  const s = string(raw) || "/";
  if (
    !s.startsWith("/") || s.startsWith("//") || /[\\\r\n{}]/.test(s) ||
    s.length > 1000 || /(?:^|\/)\.{1,2}(?:\/|\?|$)/.test(s)
  ) throw new InputError("Страница не найдена", 404);
  const url = new URL(s, "https://miniapp.invalid");
  const id = url.searchParams.get("id") ?? "";
  const page = Number(url.searchParams.get("page") ?? 0);
  return {
    path: url.pathname,
    id: uuid(id) ? id.toLowerCase() : "",
    page: Number.isSafeInteger(page) && page >= 0 ? page : 0,
  };
}
export function plural(n: number, forms: [string, string, string]): string {
  const abs = Math.abs(Math.trunc(n)) % 100;
  const last = abs % 10;
  if (abs > 10 && abs < 20) return forms[2];
  if (last === 1) return forms[0];
  if (last >= 2 && last <= 4) return forms[1];
  return forms[2];
}
export const count = (n: number, forms: [string, string, string]): string =>
  `${n} ${plural(n, forms)}`;
export function shortName(full: string): string {
  const parts = full.trim().split(/\s+/).filter(Boolean);
  if (parts.length < 2) return full.trim();
  return `${parts[0]} ${parts.slice(1, 3).map((p) => p[0] + ".").join(" ")}`;
}
export function ratingTone(rating: number | null): string {
  if (rating == null) return "mute";
  if (rating >= 4.5) return "live";
  if (rating >= 3.5) return "accent";
  if (rating >= 2.5) return "warn";
  return "danger";
}
export function ratingColor(rating: number | null): string {
  if (rating == null) return "muted";
  if (rating >= 4.5) return "success";
  if (rating >= 3.5) return "accent";
  if (rating >= 2.5) return "warn";
  return "danger";
}
export const formatRating = (v: unknown): string => {
  const n = number(v, NaN);
  return Number.isFinite(n) ? n.toFixed(1).replace(".", ",") : "—";
};
export const stars = (v: unknown): string => {
  const n = Math.max(0, Math.min(5, Math.round(number(v, 0))));
  return "★".repeat(n) + "☆".repeat(5 - n);
};
export function formatDate(v: unknown): string {
  const time = Date.parse(string(v));
  if (!Number.isFinite(time)) return "";
  return new Date(time).toLocaleDateString("ru-RU", {
    day: "numeric",
    month: "short",
    timeZone: "Europe/Moscow",
  }).replace(".", "");
}
export function formatTime(v: unknown): string {
  const s = string(v);
  return /^\d{2}:\d{2}/.test(s) ? s.slice(0, 5) : "";
}
export function nextMilestone(days: number): number {
  for (const m of [7, 14, 30, 60, 100, 365]) if (days < m) return m;
  return days + 100;
}
export function constantTimeEqual(a: string, b: string): boolean {
  const x = new TextEncoder().encode(a), y = new TextEncoder().encode(b);
  let difference = x.length ^ y.length;
  for (let i = 0; i < Math.max(x.length, y.length); i++) {
    difference |= (x[i] ?? 0) ^ (y[i] ?? 0);
  }
  return b.length >= 20 && difference === 0;
}
export function presentTeacher(raw: Json): Json {
  const rating = raw.rating == null ? null : number(raw.rating, 0);
  const reviews = number(raw.reviews, 0);
  const rank = raw.rank == null ? null : number(raw.rank, 0);
  const topDays = number(raw.top_days, 0);
  const disciplines = Array.isArray(raw.disciplines)
    ? raw.disciplines.map((d) => safeText(d)).filter(Boolean)
    : [];
  const name = safeText(raw.name);
  const position = raw.position == null ? rank : number(raw.position, 0);
  return {
    ...raw,
    name,
    short: shortName(name),
    disciplines,
    disciplines_label: disciplines.length
      ? disciplines.join(" · ")
      : "Дисциплины уточняются",
    rating_label: reviews ? formatRating(rating) : "—",
    rating_tone: reviews ? ratingTone(rating) : "mute",
    rating_color: reviews ? ratingColor(rating) : "muted",
    reviews_label: reviews
      ? count(reviews, ["отзыв", "отзыва", "отзывов"])
      : "Нет отзывов",
    rank_label: rank ? `#${rank}` : "",
    position_label: position ? `${position}` : "",
    medal: position === 1
      ? "🥇"
      : position === 2
      ? "🥈"
      : position === 3
      ? "🥉"
      : "",
    streak_label: topDays > 0
      ? `🔥 ${count(topDays, ["день", "дня", "дней"])} в топ-10`
      : "",
    recent_label: `+${number(raw.recent, 0)} за 30 дней`,
    reason_label: raw.today === true
      ? `Сегодня ${
        formatTime(raw.time) ? "в " + formatTime(raw.time) : "есть пара"
      }`
      : reviews === 0
      ? "Отзывов ещё нет — станьте первым"
      : raw.occurrences != null
      ? `${
        count(number(raw.occurrences, 0), ["пара", "пары", "пар"])
      } у вас в семестре`
      : "",
    mine: raw.mine === true,
    followed: raw.followed === true,
    my_group: raw.my_group === true,
  };
}
export const levelNames = [
  "Новичок",
  "Наблюдатель",
  "Критик",
  "Эксперт",
  "Легенда",
];
export function boardValue(board: string, card: Json): string {
  const reviews = number(card.reviews, 0);
  if (board === "discussed") {
    return count(reviews, ["отзыв", "отзыва", "отзывов"]);
  }
  if (board === "rising") return `+${number(card.recent, 0)}`;
  if (board in dimensions) return reviews ? formatRating(card[board]) : "—";
  return reviews ? formatRating(card.rating) : "—";
}
export function presentBoardItem(board: string, raw: Json): Json {
  const card = presentTeacher(raw);
  return { ...card, value_label: boardValue(board, card) };
}
export function presentReview(raw: Json): Json {
  const body = safeText(raw.body).trim();
  const helpful = number(raw.helpful, 0);
  const teacher = safeText(raw.teacher);
  return {
    ...raw,
    teacher,
    teacher_short: shortName(teacher),
    author: safeText(raw.author),
    body,
    excerpt: body.length > 180 ? body.slice(0, 177).trimEnd() + "…" : body,
    date_label: formatDate(raw.created_at),
    rating_label: formatRating(raw.rating),
    rating_color: ratingColor(number(raw.rating, 0)),
    stars_clarity: stars(raw.clarity),
    stars_loyalty: stars(raw.loyalty),
    stars_usefulness: stars(raw.usefulness),
    helpful,
    helpful_label: helpful ? `Полезно · ${helpful}` : "Полезно",
    mine: raw.mine === true,
    voted: raw.voted === true,
  };
}
