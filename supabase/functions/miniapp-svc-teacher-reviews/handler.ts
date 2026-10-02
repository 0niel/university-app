import {
  boards,
  constantTimeEqual,
  InputError,
  type Json,
  list,
  object,
  parseRoute,
  presentBoardItem,
  presentTeacher,
  ratingInput,
  scopes,
  slug,
  sorts,
  string,
  textInput,
  uuid,
} from "./domain.ts";
import { buildScreen, reviewPage } from "./screens.ts";

export type Dispatch = (
  userId: string,
  action: string,
  payload?: Json,
) => Promise<Json>;
const headers = {
  "Content-Type": "application/json; charset=utf-8",
  "Cache-Control": "no-store",
  "X-Content-Type-Options": "nosniff",
};
const json = (value: unknown, status = 200) =>
  new Response(JSON.stringify(value), { status, headers });
const views: Record<string, string> = {
  "/": "home",
  "/teacher": "teacher",
  "/review": "review",
  "/top": "top",
  "/me": "me",
  "/recommend": "recommend",
};

async function readBody(request: Request): Promise<Json> {
  const reader = request.body?.getReader();
  if (!reader) throw new InputError("Пустой запрос", 400);
  let size = 0;
  const chunks: Uint8Array[] = [];
  for (;;) {
    const { value, done } = await reader.read();
    if (done) break;
    size += value.length;
    if (size > 24000) {
      await reader.cancel();
      throw new InputError("Запрос слишком большой", 413);
    }
    chunks.push(value);
  }
  const bytes = new Uint8Array(size);
  let offset = 0;
  for (const chunk of chunks) {
    bytes.set(chunk, offset);
    offset += chunk.length;
  }
  try {
    return object(JSON.parse(new TextDecoder().decode(bytes)));
  } catch {
    throw new InputError("Некорректный запрос", 400);
  }
}

function idInput(v: unknown): string {
  if (!uuid(v)) throw new InputError("Преподаватель не найден", 404);
  return string(v).toLowerCase();
}

function boolInput(v: unknown): boolean {
  if (typeof v !== "boolean") throw new InputError();
  return v;
}

export function createHandler(serviceKey: string, dispatch: Dispatch) {
  return async (request: Request): Promise<Response> => {
    if (request.method !== "POST") {
      return json({ error: "Method not allowed" }, 405);
    }
    const token = (request.headers.get("Authorization") ?? "").replace(
      /^Bearer\s+/i,
      "",
    );
    if (!constantTimeEqual(token, serviceKey)) {
      return json({ error: "Forbidden" }, 403);
    }
    try {
      const input = await readBody(request);
      if (
        input.organizationId !== "mirea" || input.slug !== slug ||
        !uuid(input.userId)
      ) return json({ error: "Invalid proxy context" }, 403);
      const userId = string(input.userId),
        route = parseRoute(input.path),
        body = object(input.body);
      if ((input.kind ?? "screen") === "screen") {
        const view = views[route.path];
        const state = view
          ? await dispatch(userId, "state", { view, id: route.id })
          : {};
        return json(
          buildScreen(route.path, state, { id: route.id, page: route.page }),
        );
      }
      if (input.kind !== "api") {
        throw new InputError("Invalid request kind", 400);
      }
      if (string(input.method).toUpperCase() !== "POST") {
        return json({ error: "Method not allowed" }, 405);
      }
      if (route.path === "/api/reviews") {
        const page = Number(body.page ?? 0);
        if (!Number.isSafeInteger(page) || page < 0) throw new InputError();
        const state = await dispatch(userId, "state", {
          view: "teacher",
          id: idInput(body.id),
        });
        return json(reviewPage(state, page));
      }
      if (route.path === "/api/search") {
        const offset = Number(body.offset ?? 0);
        if (!Number.isInteger(offset) || offset < 0 || offset > 100000) {
          throw new InputError();
        }
        const sort = string(body.sort || "rating");
        const scope = string(body.scope || "all");
        if (
          !Object.hasOwn(
            { ...sorts, clarity: 1, loyalty: 1, usefulness: 1 },
            sort,
          ) ||
          !Object.hasOwn(scopes, scope)
        ) throw new InputError();
        const result = await dispatch(userId, "search", {
          q: textInput(body.q, 0, 100),
          sort,
          scope,
          with_reviews: body.with_reviews === true,
          offset,
        });
        return json({
          items: list(result.items).map(presentTeacher),
          count: Number(result.count ?? 0),
          offset,
        });
      }
      if (route.path === "/api/top") {
        const board = string(body.board || "overall");
        const scope = string(body.scope || "all");
        if (
          !Object.hasOwn(boards, board) || !["all", "group"].includes(scope)
        ) {
          throw new InputError();
        }
        const result = await dispatch(userId, "top", { board, scope });
        return json({
          board,
          scope,
          count: Number(result.count ?? 0),
          items: list(result.items).map((item) =>
            presentBoardItem(board, item)
          ),
        });
      }
      if (route.path === "/api/review") {
        const result = await dispatch(userId, "review", {
          id: idInput(body.id),
          clarity: ratingInput(body.clarity),
          loyalty: ratingInput(body.loyalty),
          usefulness: ratingInput(body.usefulness),
          body: textInput(body.body ?? "", 0, 2000),
          anonymous: body.anonymous === true,
        });
        return json({
          ok: true,
          first: result.first === true,
          pioneer: result.pioneer === true,
          points: Number(result.points ?? 0),
        });
      }
      if (route.path === "/api/review/delete") {
        await dispatch(userId, "delete_review", { id: idInput(body.id) });
      } else if (route.path === "/api/vote") {
        if (!uuid(body.id)) throw new InputError("Отзыв не найден", 404);
        const result = await dispatch(userId, "vote", {
          id: string(body.id).toLowerCase(),
          helpful: boolInput(body.helpful),
        });
        return json({ ok: true, helpful: Number(result.helpful ?? 0) });
      } else if (route.path === "/api/follow") {
        await dispatch(userId, "follow", {
          id: idInput(body.id),
          follow: boolInput(body.follow),
        });
      } else if (route.path === "/api/settings") {
        await dispatch(userId, "settings", {
          show_in_leaderboard: boolInput(body.show_in_leaderboard),
        });
      } else throw new InputError("Страница не найдена", 404);
      return json({ ok: true });
    } catch (error) {
      if (error instanceof InputError) {
        return json({ error: error.message }, error.status);
      }
      const code = string(object(error).code);
      if (code === "42501") return json({ error: "Действие недоступно" }, 403);
      if (code === "P0002") {
        return json({ error: "Запись уже недоступна" }, 404);
      }
      if (code === "P0001") {
        return json({ error: "Лимит на сегодня исчерпан" }, 429);
      }
      if (["22023", "23514", "22007", "22P02", "22001"].includes(code)) {
        return json({ error: "Проверьте заполненные поля" }, 422);
      }
      return json(
        { error: "Сервис временно недоступен. Попробуйте ещё раз." },
        500,
      );
    }
  };
}
