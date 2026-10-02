import {
  boards,
  count,
  dimensions,
  formatRating,
  formatTime,
  type Json,
  levelNames,
  list,
  nextMilestone,
  number,
  object,
  presentBoardItem,
  presentReview,
  presentTeacher,
  ratingColor,
  ratingHints,
  safeText,
  scopes,
  sorts,
  string,
} from "./domain.ts";

type Node = Json;
const appTitle = "Отзывы о преподах";
const t = (
  data: unknown,
  variant = "body",
  color?: string,
  extra: Json = {},
): Node => ({
  type: "appText",
  data: safeText(data),
  variant,
  ...(color ? { color } : {}),
  ...extra,
});
const dyn = (
  data: string,
  variant = "body",
  color?: string,
  extra: Json = {},
): Node => ({
  type: "appText",
  data,
  variant,
  ...(color ? { color } : {}),
  ...extra,
});
const gap = (height = 12): Node => ({ type: "sizedBox", height });
const hgap = (width = 8): Node => ({ type: "sizedBox", width });
const col = (children: Node[], extra: Json = {}): Node => ({
  type: "column",
  crossAxisAlignment: "stretch",
  children,
  ...extra,
});
const row = (children: Node[], extra: Json = {}): Node => ({
  type: "row",
  crossAxisAlignment: "center",
  children,
  ...extra,
});
const expanded = (child: Node): Node => ({ type: "expanded", child });
const card = (children: Node[], extra: Json = {}): Node => ({
  type: "appCard",
  padding: 16,
  radius: 18,
  child: col(children),
  ...extra,
});
const wrap = (children: Node[]): Node => ({
  type: "wrap",
  spacing: 8,
  runSpacing: 8,
  children,
});
const open = (path: string, title = appTitle): Node => ({
  actionType: "openPage",
  path,
  title,
});
const toast = (message: string, type = "success"): Node => ({
  actionType: "showToast",
  message,
  type,
});
const multi = (...actions: Node[]): Node => ({
  actionType: "multiAction",
  sync: true,
  actions,
});
const set = (key: string, value: unknown): Node => ({
  actionType: "setState",
  key,
  value,
});
const setValues = (values: Json): Node => ({ actionType: "setState", values });
const btn = (
  label: string,
  onPressed: Node,
  variant = "primary",
  extra: Json = {},
): Node => ({
  type: "appButton",
  label,
  onPressed,
  variant,
  expanded: true,
  loadingLabel: "Подождите…",
  ...extra,
});
const compact = (label: string, onPressed: Node, icon?: string): Node =>
  btn(label, onPressed, "ghost", {
    expanded: false,
    size: "small",
    ...(icon ? { icon } : {}),
  });
const iconButton = (
  icon: string,
  tooltip: string,
  onPressed: Node,
  tone = "tonal",
): Node => ({ type: "appIconButton", icon, tooltip, onPressed, tone });
const tag = (label: string, tone = "mute"): Node => ({
  type: "appTag",
  label,
  tone,
});
const badge = (label: string, tone = "neutral", dot = false): Node => ({
  type: "appBadge",
  label,
  tone,
  dot,
});
const avatar = (name: string, size = 44): Node => ({
  type: "appAvatar",
  name: safeText(name),
  size,
});
const empty = (
  title: string,
  subtitle: string,
  child?: Node,
  emoji = "🎓",
): Node => ({
  type: "appEmptyState",
  emoji,
  title,
  subtitle,
  ...(child ? { child } : {}),
});
const section = (title: string, subtitle?: string, extra: Json = {}): Node => ({
  type: "appSectionTitle",
  title,
  topMargin: 18,
  bottomPadding: 10,
  ...(subtitle ? { subtitle } : {}),
  ...extra,
});
const goHome: Node = { actionType: "reload", target: "root" };
const reload: Node = { actionType: "reload" };
const teacherPath = (id: unknown) => `/teacher?id=${string(id)}`;
const reviewPath = (id: unknown) => `/review?id=${string(id)}`;
const appLink = (page: string) =>
  `https://mirea.ninja/app/services/apps/teacher-reviews/run?page=${
    encodeURIComponent(page)
  }`;

function request(path: string, body: Json, success: Node = reload): Node {
  return {
    actionType: "networkRequest",
    url: path,
    method: "post",
    contentType: "application/json",
    body,
    loadingKey: "saving",
    errorKey: "saveError",
    onError: toast("Не удалось подключиться. Попробуйте ещё раз.", "error"),
    results: [
      {
        statusCode: 200,
        action: multi(
          success,
          { actionType: "hapticFeedback", style: "light" },
        ),
      },
      ...[400, 422].map((statusCode) => ({
        statusCode,
        action: toast("Проверьте оценки и текст отзыва.", "error"),
      })),
      { statusCode: 403, action: toast("Действие недоступно", "error") },
      {
        statusCode: 404,
        action: toast("Запись уже изменена или недоступна", "warning"),
      },
      {
        statusCode: 429,
        action: toast("Дневной лимит исчерпан. Попробуйте завтра.", "warning"),
      },
      ...[500, 502, 503, 504].map((statusCode) => ({
        statusCode,
        action: toast(
          "Сервис временно недоступен. Попробуйте ещё раз.",
          "error",
        ),
      })),
    ],
  };
}
function mutation(path: string, body: Json, revert: Node): Node {
  const failed = (message: string, type = "error") =>
    multi(revert, toast(message, type));
  return {
    actionType: "networkRequest",
    url: path,
    method: "post",
    contentType: "application/json",
    body,
    errorKey: "saveError",
    onError: failed("Не удалось подключиться. Попробуйте ещё раз."),
    results: [
      ...[400, 422].map((statusCode) => ({
        statusCode,
        action: failed("Действие недоступно"),
      })),
      { statusCode: 403, action: failed("Действие недоступно") },
      { statusCode: 404, action: failed("Запись уже недоступна", "warning") },
      {
        statusCode: 429,
        action: failed("Дневной лимит исчерпан. Попробуйте завтра.", "warning"),
      },
      ...[500, 502, 503, 504].map((statusCode) => ({
        statusCode,
        action: failed("Сервис временно недоступен. Попробуйте ещё раз."),
      })),
    ],
  };
}
function voteButton(r: Json, slot: string): Node {
  const voted = `${slot}v`, helpful = `${slot}h`;
  const flip = multi(
    {
      actionType: "setState",
      key: helpful,
      expression:
        `state.${voted} ? state.${helpful} - 1 : state.${helpful} + 1`,
    },
    { actionType: "setState", key: voted, toggle: true },
  );
  const label =
    `{{state.${helpful} > 0 ? 'Полезно · ' + str(state.${helpful}) : 'Полезно'}}`;
  const press = multi(
    flip,
    mutation(
      "/api/vote",
      { id: string(r.id), helpful: `{{state.${voted}}}` },
      flip,
    ),
  );
  return {
    type: "appIf",
    condition: `state.${voted}`,
    child: btn(label, press, "ghost", {
      expanded: false,
      size: "small",
      icon: "check",
      loadingLabel: label,
    }),
    else: btn(label, press, "ghost", {
      expanded: false,
      size: "small",
      icon: "bolt",
      loadingLabel: label,
    }),
  };
}
function voteState(reviews: Json[], prefix: string): Json {
  const initial: Json = {};
  reviews.forEach((r, i) => {
    initial[`${prefix}${i}v`] = r.voted === true;
    initial[`${prefix}${i}h`] = number(r.helpful, 0);
  });
  return initial;
}
function shell(children: Node[], initial: Json = {}, paginate = false): Node {
  const scroll: Node = {
    type: "singleChildScrollView",
    ...(paginate ? { key: "reviews-page-{{state.reviewPage.page}}" } : {}),
    padding: { left: 16, right: 16, top: 12, bottom: 24 },
    child: col(children),
  };
  return {
    type: "scaffold",
    body: {
      type: "appStateScope",
      initial: { saving: false, saveError: null, ...initial },
      child: paginate ? { type: "container", child: scroll } : scroll,
    },
  };
}
function progressBar(value: number, color = "accent", height = 6): Node {
  return {
    type: "appProgressBar",
    value: Math.max(0, Math.min(1, value)),
    height,
    color,
  };
}
function ratingTag(card: Json): Node {
  return tag(`★ ${string(card.rating_label)}`, string(card.rating_tone));
}
function teacherBadges(card: Json): Node[] {
  return [
    ...(number(card.reviews, 0) > 0 ? [badge(string(card.reviews_label))] : []),
    ...(card.streak_label ? [badge(string(card.streak_label), "warn")] : []),
    ...(card.mine ? [badge("Мой отзыв", "accent")] : []),
    ...(card.my_group ? [badge("Моя группа", "info")] : []),
  ];
}
function teacherCardNode(card: Json, extra: Node[] = []): Node {
  return card_(card, extra);
}
function card_(card: Json, extra: Node[]): Node {
  return {
    type: "appCard",
    padding: 14,
    radius: 18,
    onTap: open(teacherPath(card.id), string(card.short)),
    semanticsLabel: `${string(card.name)}. ${string(card.rating_label)}`,
    child: col([
      row([
        avatar(string(card.name), 46),
        hgap(12),
        expanded(col([
          t(card.name, "headlineStrong", undefined, { maxLines: 2 }),
          gap(3),
          t(card.disciplines_label, "caption", "muted", { maxLines: 2 }),
        ])),
        hgap(8),
        ratingTag(card),
      ], { crossAxisAlignment: "start" }),
      ...(teacherBadges(card).length
        ? [gap(10), wrap(teacherBadges(card))]
        : []),
      ...extra,
    ]),
  };
}
function teacherTemplate(): Node {
  return col([
    {
      type: "appCard",
      padding: 14,
      radius: 18,
      onTap: open("/teacher?id={{item.id}}", "{{item.short}}"),
      semanticsLabel: "{{item.name}}. {{item.rating_label}}",
      child: col([
        row([
          { type: "appAvatar", name: "{{item.name}}", size: 46 },
          hgap(12),
          expanded(col([
            dyn("{{item.name}}", "headlineStrong", undefined, { maxLines: 2 }),
            gap(3),
            dyn("{{item.disciplines_label}}", "caption", "muted", {
              maxLines: 2,
            }),
          ])),
          hgap(8),
          tag("★ {{item.rating_label}}", "{{item.rating_tone}}"),
        ], { crossAxisAlignment: "start" }),
        gap(10),
        wrap([
          {
            type: "appIf",
            condition: "item.reviews > 0",
            child: badge("{{item.reviews_label}}"),
            else: badge("Нет отзывов"),
          },
          {
            type: "appIf",
            condition: "item.streak_label != ''",
            child: badge("{{item.streak_label}}", "warn"),
          },
          {
            type: "appIf",
            condition: "item.mine",
            child: badge("Мой отзыв", "accent"),
          },
          {
            type: "appIf",
            condition: "item.my_group",
            child: badge("Моя группа", "info"),
          },
        ]),
      ]),
    },
    gap(10),
  ]);
}
function rankTile(position: unknown, medal: unknown): Node {
  return {
    type: "appIconTile",
    size: 40,
    radius: 12,
    color: "accent",
    ...(string(medal)
      ? { emoji: string(medal) }
      : { child: t(`#${number(position, 0)}`, "labelStrong", "accent") }),
  };
}
function teacherRow(card: Json, position?: number): Node {
  return {
    type: "appListRow",
    title: string(card.name),
    subtitle: string(card.disciplines_label),
    isFirst: true,
    showChevron: false,
    leading: position
      ? rankTile(position, card.medal)
      : avatar(string(card.name), 40),
    trailing: col([
      ratingTag(card),
      gap(4),
      t(card.reviews_label, "micro", "muted"),
    ], { crossAxisAlignment: "end", mainAxisSize: "min" }),
    onTap: open(teacherPath(card.id), string(card.short)),
  };
}
function levelCard(me: Json, expandedView = false): Node {
  const level = object(me.level);
  const points = number(me.points, 0);
  const index = number(level.index, 1);
  const next = level.next == null ? null : number(level.next, 0);
  const nextName = levelNames[index] ?? "";
  const week = number(me.week_reviews, 0), goal = number(me.week_goal, 2);
  const streak = number(me.streak_days, 0);
  return {
    type: "appCard",
    padding: 16,
    radius: 20,
    tinted: true,
    onTap: expandedView ? undefined : open("/me", "Мой прогресс"),
    semanticsLabel: `${string(level.name)}, ${points} XP`,
    child: col([
      row([
        {
          type: "appProgressRing",
          value: number(level.progress, 0),
          size: 64,
          strokeWidth: 6,
          label: string(level.emoji),
          color: "accent",
        },
        hgap(14),
        expanded(col([
          t(`${string(level.name)} · ${points} XP`, "headlineStrong"),
          gap(4),
          t(
            next == null
              ? "Максимальный уровень достигнут"
              : `До уровня «${nextName}» ещё ${next - points} XP`,
            "caption",
            "muted",
          ),
          gap(8),
          progressBar(goal ? week / goal : 0, "accent"),
          gap(4),
          t(
            week >= goal
              ? `Недельное задание выполнено: ${week} из ${goal} отзывов`
              : `Неделя: ${week} из ${goal} отзывов`,
            "caption",
            "muted",
          ),
        ])),
        ...(expandedView ? [] : [
          hgap(6),
          { type: "appLineIcon", icon: "chevronR", size: 18, color: "muted" },
        ]),
      ]),
      ...(streak > 0 || number(me.rank, 0) > 0
        ? [
          gap(12),
          wrap([
            ...(number(me.rank, 0) > 0
              ? [badge(`#${number(me.rank, 0)} среди рецензентов`, "accent")]
              : []),
            ...(streak > 0
              ? [
                badge(
                  `🔥 ${count(streak, ["день", "дня", "дней"])} в топ-10`,
                  "warn",
                ),
              ]
              : []),
          ]),
        ]
        : []),
    ]),
  };
}
function groupBanner(): Node {
  return card([
    row([
      {
        type: "appIconTile",
        emoji: "🗓️",
        size: 44,
        radius: 14,
        color: "accent",
      },
      hgap(12),
      expanded(col([
        t("Укажите свою группу", "headlineStrong"),
        gap(4),
        t(
          "Выберите расписание группы — покажем ваших преподавателей и кого стоит оценить первым.",
          "caption",
          "muted",
        ),
      ])),
    ], { crossAxisAlignment: "start" }),
    gap(12),
    btn(
      "Открыть расписание",
      {
        actionType: "openDeepLink",
        location: "/schedule",
      },
      "secondary",
      { icon: "calendar" },
    ),
  ]);
}
function reviewCard(
  r: Json,
  options: { showTeacher?: boolean; slot?: string } = {},
): Node {
  const dims = [
    ["Понятность", string(r.stars_clarity)],
    ["Лояльность", string(r.stars_loyalty)],
    ["Польза", string(r.stars_usefulness)],
  ];
  const teacherId = string(r.teacher_id);
  return card(
    [
      row([
        avatar(string(options.showTeacher ? r.teacher : r.author), 36),
        hgap(10),
        expanded(col([
          t(
            options.showTeacher ? r.teacher_short : r.author,
            "labelStrong",
            undefined,
            { maxLines: 1 },
          ),
          gap(2),
          t(
            options.showTeacher
              ? `${string(r.author)} · ${string(r.date_label)}`
              : string(r.date_label),
            "caption",
            "muted",
          ),
        ])),
        hgap(8),
        tag(
          `★ ${string(r.rating_label)}`,
          ratingColor(number(r.rating, 0)) === "success"
            ? "live"
            : ratingColor(number(r.rating, 0)) === "accent"
            ? "accent"
            : ratingColor(number(r.rating, 0)) === "warn"
            ? "warn"
            : "danger",
        ),
      ]),
      gap(10),
      ...dims.map(([label, value]) =>
        row([
          expanded(t(label, "caption", "muted")),
          t(value, "caption", "warn"),
        ])
      ),
      ...(string(r.body)
        ? [
          gap(10),
          {
            type: "appExpandableText",
            text: string(r.body),
            maxLines: 4,
            variant: "body",
            expandLabel: "Читать полностью",
            collapseLabel: "Свернуть",
          },
        ]
        : []),
      gap(10),
      row([
        expanded(wrap([
          ...(r.mine ? [badge("Ваш отзыв", "accent")] : []),
          ...(r.anonymous && r.mine ? [badge("Анонимно")] : []),
        ])),
        ...(r.mine
          ? [
            compact("Изменить", open(reviewPath(teacherId), "Отзыв"), "pencil"),
          ]
          : options.slot
          ? [voteButton(r, options.slot)]
          : [compact(
            string(r.helpful_label),
            request("/api/vote", {
              id: string(r.id),
              helpful: r.voted !== true,
            }),
            r.voted ? "check" : "bolt",
          )]),
      ]),
    ],
    options.showTeacher
      ? { onTap: open(teacherPath(teacherId), string(r.teacher_short)) }
      : {},
  );
}
export function reviewPage(state: Json, requestedPage = 0): Json {
  const reviews = list(object(state.teacher).reviews_list).sort((a, b) =>
    string(b.created_at).localeCompare(string(a.created_at)) ||
    string(a.id).localeCompare(string(b.id))
  );
  const last = Math.max(0, Math.ceil(reviews.length / 20) - 1);
  const page = Number.isSafeInteger(requestedPage) && requestedPage >= 0
    ? Math.min(requestedPage, last)
    : 0;
  return {
    page,
    last,
    count: reviews.length,
    start: page * 20 + 1,
    end: Math.min((page + 1) * 20, reviews.length),
    items: reviews.slice(page * 20, (page + 1) * 20).map((raw) => {
      const r = presentReview(raw);
      return { ...r, rating_tone: ratingTone(r.rating) };
    }),
  };
}
function ratingTone(value: unknown): string {
  const color = ratingColor(number(value, 0));
  return color === "success"
    ? "live"
    : color === "accent"
    ? "accent"
    : color === "warn"
    ? "warn"
    : "danger";
}
function reviewTemplate(): Node {
  const voted =
    "(state['v_' + item.id] == null ? item.voted : state['v_' + item.id])";
  const helpful =
    "(state['h_' + item.id] == null ? item.helpful : state['h_' + item.id])";
  const flip = multi(
    {
      actionType: "setState",
      key: "h_{{item.id}}",
      expression: `${voted} ? ${helpful} - 1 : ${helpful} + 1`,
    },
    { actionType: "setState", key: "v_{{item.id}}", value: `{{!${voted}}}` },
  );
  const vote = multi(
    flip,
    mutation("/api/vote", {
      id: "{{item.id}}",
      helpful: `{{${voted}}}`,
    }, flip),
  );
  const label =
    `{{${helpful} > 0 ? 'Полезно · ' + str(${helpful}) : 'Полезно'}}`;
  return col([
    card([
      row([
        { type: "appAvatar", name: "{{item.author}}", size: 36 },
        hgap(10),
        expanded(col([
          dyn("{{item.author}}", "labelStrong", undefined, { maxLines: 1 }),
          gap(2),
          dyn("{{item.date_label}}", "caption", "muted"),
        ])),
        hgap(8),
        tag("★ {{item.rating_label}}", "{{item.rating_tone}}"),
      ]),
      gap(10),
      ...Object.entries(dimensions).map(([key, dim]) =>
        row([
          expanded(t(dim.label, "caption", "muted")),
          dyn(`{{item.stars_${key}}}`, "caption", "warn"),
        ])
      ),
      {
        type: "appIf",
        condition: "item.body != ''",
        child: col([
          gap(10),
          {
            type: "appExpandableText",
            key: "review-{{item.id}}",
            text: "{{item.body}}",
            maxLines: 4,
            variant: "body",
            expandLabel: "Читать полностью",
            collapseLabel: "Свернуть",
          },
        ]),
      },
      gap(10),
      row([
        expanded(wrap([
          {
            type: "appIf",
            condition: "item.mine",
            child: badge("Ваш отзыв", "accent"),
          },
          {
            type: "appIf",
            condition: "item.mine && item.anonymous",
            child: badge("Анонимно"),
          },
        ])),
        {
          type: "appIf",
          condition: "item.mine",
          child: compact(
            "Изменить",
            open("/review?id={{item.teacher_id}}", "Отзыв"),
            "pencil",
          ),
          else: {
            type: "appIf",
            condition: voted,
            child: compact(label, vote, "check"),
            else: compact(label, vote, "bolt"),
          },
        },
      ]),
    ], { key: "review-card-{{item.id}}" }),
    gap(10),
  ]);
}
function smartChips(stats: Json): Node {
  return wrap([
    {
      type: "appSmartChip",
      emoji: "🎓",
      label: "Преподов",
      value: `${number(stats.teachers, 0)}`,
    },
    {
      type: "appSmartChip",
      emoji: "💬",
      label: "Отзывов",
      value: `${number(stats.reviews, 0)}`,
    },
    {
      type: "appSmartChip",
      emoji: "📈",
      label: "За неделю",
      value: `+${number(stats.week, 0)}`,
      tone: "success",
    },
    {
      type: "appSmartChip",
      emoji: "🧑‍🎓",
      label: "Авторов",
      value: `${number(stats.reviewers, 0)}`,
    },
  ]);
}
function recommendCard(card: Json): Node {
  return teacherCardNode(card, [
    gap(12),
    row([
      expanded(t(card.reason_label, "caption", "accent", { maxLines: 2 })),
      hgap(8),
      btn("Оценить", open(reviewPath(card.id), "Отзыв"), "primary", {
        expanded: false,
        size: "small",
        icon: "star",
      }),
    ]),
  ]);
}
function home(state: Json): Node {
  const me = object(state.me);
  const today = list(state.today).map(presentTeacher);
  const recommend = list(state.recommend).map(presentTeacher);
  const top = list(state.top).map(presentTeacher);
  const recent = list(state.recent).map(presentReview);
  const stats = object(state.stats);
  const hasGroup = me.has_group === true;
  const initial: Json = {
    q: "",
    searching: false,
    sort: "rating",
    scope: "all",
    with_reviews: false,
    offset: 0,
    busy: false,
    loadError: null,
    filtersOpen: false,
    listing: { items: [], count: 0, offset: 0 },
    ...voteState(recent, "f"),
  };
  const fetch: Node = {
    actionType: "fetch",
    path: "/api/search",
    method: "POST",
    body: {
      q: "{{state.q}}",
      sort: "{{state.sort}}",
      scope: "{{state.scope}}",
      with_reviews: "{{state.with_reviews}}",
      offset: "{{state.offset}}",
    },
    saveAs: "listing",
    loadingKey: "busy",
    errorKey: "loadError",
    onError: toast("Не удалось загрузить список. Попробуйте ещё раз.", "error"),
  };
  const search = multi(setValues({ searching: true, offset: 0 }), fetch);
  const chip = (label: string, key: string, value: string): Node => ({
    type: "appChip",
    label,
    selected: `{{state.${key} == '${value}'}}`,
    onTap: multi(set(key, value), search),
  });
  const scroller = (children: Node[]): Node => ({
    type: "singleChildScrollView",
    scrollDirection: "horizontal",
    child: {
      type: "row",
      mainAxisSize: "min",
      children: children.flatMap((c) => [c, hgap(8)]),
    },
  });
  return shell([
    row([
      expanded({
        type: "appSearchField",
        stateKey: "q",
        placeholder: "Преподаватель или предмет",
        onCanvas: true,
        onSubmitted: search,
        onChanged: {
          actionType: "runIf",
          condition: "state.q == ''",
          then: set("searching", false),
        },
      }),
      hgap(8),
      iconButton("search", "Найти преподавателя", search),
    ]),
    gap(10),
    scroller([
      {
        type: "appChip",
        label: "Фильтры",
        selected: "{{state.searching && state.filtersOpen}}",
        leadingIcon: "filter",
        onTap: {
          actionType: "runIf",
          condition: "state.searching",
          then: {
            actionType: "setState",
            key: "filtersOpen",
            toggle: true,
          },
          else: multi(setValues({ filtersOpen: true }), search),
        },
      },
      {
        type: "appChip",
        label: "Топ преподов",
        leadingIcon: "star",
        onTap: open("/top", "Топ"),
      },
      {
        type: "appChip",
        label: "Кого оценить",
        leadingIcon: "bolt",
        onTap: open("/recommend", "Кого оценить"),
      },
      {
        type: "appChip",
        label: "Мой прогресс",
        leadingIcon: "user",
        onTap: open("/me", "Мой прогресс"),
      },
    ]),
    {
      type: "appIf",
      condition: "state.searching",
      child: col([
        {
          type: "appIf",
          condition: "state.filtersOpen",
          child: col([
            gap(12),
            card([
              t("Сортировка", "captionStrong", "muted"),
              gap(8),
              wrap(
                Object.entries(sorts).map(([value, label]) =>
                  chip(label, "sort", value)
                ),
              ),
              gap(12),
              t("Показывать", "captionStrong", "muted"),
              gap(8),
              wrap(
                Object.entries(scopes)
                  .filter(([value]) => value !== "group" || hasGroup)
                  .map(([value, label]) => chip(label, "scope", value)),
              ),
              gap(12),
              {
                type: "appToggle",
                stateKey: "with_reviews",
                value: "{{state.with_reviews}}",
                label: "Только с отзывами",
                onChange: search,
              },
              gap(12),
              btn("Показать", multi(set("filtersOpen", false), search)),
            ]),
          ]),
        },
        gap(14),
        row([
          expanded(dyn("Найдено · {{state.listing.count}}", "headlineStrong")),
          compact("Закрыть", setValues({ searching: false, q: "" }), "close"),
        ]),
        gap(8),
        {
          type: "appIf",
          condition: "state.busy",
          child: col([t("Ищем преподавателей…", "caption", "muted"), gap(10)]),
        },
        {
          type: "appIf",
          condition: "state.loadError != null",
          child: col([
            card([
              {
                type: "appErrorState",
                compact: true,
                title: "Не удалось загрузить",
                message: "Проверьте соединение и повторите.",
              },
              gap(8),
              compact("Повторить", fetch, "refresh"),
            ]),
            gap(12),
          ]),
        },
        {
          type: "appIf",
          condition:
            "state.listing.items.length == 0 && !state.busy && state.loadError == null",
          child: empty(
            "Никого не нашли",
            "Попробуйте фамилию без инициалов или название предмета.",
            btn(
              "Сбросить фильтры",
              multi(
                setValues({
                  q: "",
                  sort: "rating",
                  scope: "all",
                  with_reviews: false,
                  offset: 0,
                }),
                fetch,
              ),
              "secondary",
            ),
            "🔍",
          ),
        },
        {
          type: "appForEach",
          items: "state.listing.items",
          as: "column",
          template: teacherTemplate(),
        },
        {
          type: "appIf",
          condition: "state.offset > 0",
          child: btn(
            "Предыдущие 20",
            multi({
              actionType: "setState",
              key: "offset",
              expression: "max(0, state.offset - 20)",
            }, fetch),
            "outline",
          ),
        },
        {
          type: "appIf",
          condition: "state.offset + 20 < state.listing.count",
          child: col([
            gap(8),
            btn(
              "Показать ещё",
              multi({ actionType: "setState", key: "offset", add: 20 }, fetch),
              "outline",
            ),
          ]),
        },
      ]),
      else: col([
        gap(14),
        levelCard(me),
        ...(!hasGroup ? [gap(12), groupBanner()] : []),
        ...(today.length
          ? [
            section(
              "Сегодня у вас",
              "Оцените сразу после пары — впечатления свежие",
            ),
            scroller(today.map((c) => ({
              type: "appCard",
              padding: 12,
              radius: 16,
              width: 190,
              onTap: open(
                c.mine ? teacherPath(c.id) : reviewPath(c.id),
                string(c.short),
              ),
              child: col([
                row([
                  avatar(string(c.name), 32),
                  hgap(8),
                  expanded(
                    t(c.short, "labelStrong", undefined, { maxLines: 1 }),
                  ),
                ]),
                gap(8),
                t(
                  `${formatTime(c.time) || "Сегодня"} · ${
                    safeText(c.subject) || string(c.disciplines_label)
                  }`,
                  "caption",
                  "muted",
                  { maxLines: 2 },
                ),
                gap(8),
                row([
                  ratingTag(c),
                  hgap(6),
                  expanded(
                    t(
                      c.mine ? "Вы оценили" : "Оценить →",
                      "caption",
                      c.mine ? "muted" : "accent",
                      { align: "end" },
                    ),
                  ),
                ]),
              ]),
            }))),
          ]
          : []),
        ...(recommend.length
          ? [
            section(
              "Кого оценить",
              "Преподаватели вашей группы без вашего отзыва",
              {
                action: "Все",
                onActionTap: open("/recommend", "Кого оценить"),
              },
            ),
            ...recommend.slice(0, 3).flatMap((
              c,
            ) => [recommendCard(c), gap(10)]),
          ]
          : hasGroup && me.group_total &&
              number(me.group_done, 0) >= number(me.group_total, 0)
          ? [
            section("Кого оценить"),
            card([
              t("Вы оценили всех преподавателей группы 🎉", "headlineStrong"),
              gap(4),
              t(
                "Загляните в топ — там наверняка есть кого поддержать отметкой «полезно».",
                "caption",
                "muted",
              ),
            ]),
          ]
          : []),
        section("Топ преподов", "Сглаженный рейтинг по трём критериям", {
          action: "Весь топ",
          onActionTap: open("/top", "Топ"),
        }),
        ...(top.length
          ? [{
            type: "appListGroup",
            showDividers: true,
            children: top.map((c, i) => teacherRow(c, i + 1)),
          }]
          : [
            empty(
              "Топ пока пуст",
              "Нужно хотя бы два отзыва о преподавателе, чтобы он попал в рейтинг.",
              undefined,
              "🏆",
            ),
          ]),
        section("Свежие отзывы", "Что пишут студенты прямо сейчас"),
        ...(recent.length
          ? recent.flatMap((r, i) => [
            reviewCard(r, { showTeacher: true, slot: `f${i}` }),
            gap(10),
          ])
          : [
            empty(
              "Отзывов пока нет",
              "Станьте первым — это займёт минуту.",
              btn(
                "Кого оценить",
                open("/recommend", "Кого оценить"),
                "secondary",
              ),
              "✍️",
            ),
          ]),
        gap(6),
        smartChips(stats),
        gap(16),
        t(
          "Оценки анонимны для преподавателей и видны студентам. Пишите честно и по делу.",
          "caption",
          "muted",
          { align: "center" },
        ),
      ]),
    },
  ], initial);
}
function dimRow(label: string, value: unknown, rank?: unknown): Node {
  const n = number(value, 0);
  return col([
    row([
      expanded(t(label, "caption", "muted")),
      ...(rank ? [t(`#${number(rank, 0)}`, "micro", "muted"), hgap(6)] : []),
      t(formatRating(value), "captionStrong"),
    ]),
    gap(4),
    progressBar(n / 5, ratingColor(n), 6),
  ]);
}
function challengeCard(p: Json): Node {
  const rank = p.rank == null ? null : number(p.rank, 0);
  const reviews = number(p.reviews, 0);
  const days = number(p.top_days, 0);
  const best = number(p.best_days, 0);
  const eligible = number(p.eligible, 0);
  if (rank == null) {
    const missing = Math.max(0, 2 - reviews);
    return card([
      row([
        {
          type: "appIconTile",
          emoji: "🎯",
          size: 44,
          radius: 14,
          color: "accent",
        },
        hgap(12),
        expanded(col([
          t(
            missing
              ? `Ещё ${
                count(missing, ["отзыв", "отзыва", "отзывов"])
              } до рейтинга`
              : "Скоро в рейтинге",
            "headlineStrong",
          ),
          gap(4),
          t(
            "В общий топ попадают преподаватели с двумя и более отзывами.",
            "caption",
            "muted",
          ),
        ])),
      ], { crossAxisAlignment: "start" }),
    ]);
  }
  if (rank > 10) {
    return card([
      row([
        {
          type: "appIconTile",
          emoji: "📈",
          size: 44,
          radius: 14,
          color: "accent",
        },
        hgap(12),
        expanded(col([
          t(`#${rank} из ${eligible} в общем топе`, "headlineStrong"),
          gap(4),
          t(
            `До топ-10 не хватает высоких оценок. Ваш отзыв может изменить позицию.`,
            "caption",
            "muted",
          ),
        ])),
      ], { crossAxisAlignment: "start" }),
    ]);
  }
  const milestone = nextMilestone(days);
  return {
    type: "appCard",
    padding: 16,
    radius: 20,
    tinted: true,
    child: col([
      row([
        {
          type: "appProgressRing",
          value: milestone ? days / milestone : 0,
          size: 64,
          strokeWidth: 6,
          label: `${days}`,
          sublabel: `из ${milestone}`,
          color: "warn",
        },
        hgap(14),
        expanded(col([
          t(
            days > 0
              ? `🔥 В топ-10 уже ${count(days, ["день", "дня", "дней"])}`
              : `🏅 #${rank} в топ-10`,
            "headlineStrong",
          ),
          gap(4),
          t(
            days > 0
              ? `Продержится ли до ${milestone}? Серия обновляется каждый день в полночь.`
              : "Серия начнётся с сегодняшнего дня — заходите завтра.",
            "caption",
            "muted",
          ),
          ...(best > days
            ? [
              gap(4),
              t(
                `Рекорд — ${count(best, ["день", "дня", "дней"])}`,
                "micro",
                "muted",
              ),
            ]
            : []),
        ])),
      ]),
    ]),
  };
}
function teacher(state: Json, id: string, requestedPage = 0): Node {
  const raw = object(state.teacher);
  if (!string(raw.id)) {
    return shell([
      empty(
        "Преподаватель не найден",
        "Проверьте ссылку или найдите его через поиск.",
        btn("К поиску", goHome),
        "🤷",
      ),
    ]);
  }
  const p = presentTeacher(raw);
  const reviews = reviewPage(state, requestedPage);
  const loadReviews = (page: string): Node =>
    multi(set("requestedReviewPage", page), {
      actionType: "fetch",
      path: "/api/reviews",
      method: "POST",
      body: { id, page },
      saveAs: "reviewPage",
      errorKey: "reviewsError",
      onResult: { actionType: "hapticFeedback", style: "selection" },
      onError: toast(
        "Не удалось загрузить отзывы. Попробуйте ещё раз.",
        "error",
      ),
    });
  const similar = list(raw.similar).map(presentTeacher);
  const my = raw.my_review ? presentReview(object(raw.my_review)) : null;
  const groups = number(raw.groups, 0);
  const total = number(raw.reviews, 0);
  const distribution = Array.isArray(raw.distribution)
    ? raw.distribution.map((v) => number(v, 0))
    : [];
  const share = `${string(p.name)} — ★ ${string(p.rating_label)} (${
    string(p.reviews_label)
  })\nОтзывы студентов в Mirea Ninja: ${appLink(teacherPath(id))}`;
  const flipFollow: Node = {
    actionType: "setState",
    key: "followed",
    toggle: true,
  };
  const toggleFollow = multi(
    flipFollow,
    mutation("/api/follow", { id, follow: "{{state.followed}}" }, flipFollow),
  );
  return shell([
    card([
      row([
        avatar(string(p.name), 64),
        hgap(14),
        expanded(col([
          t(p.name, "heading"),
          gap(4),
          t(p.disciplines_label, "caption", "muted"),
        ])),
      ], { crossAxisAlignment: "start" }),
      gap(12),
      wrap([
        ...(p.rank
          ? [badge(`#${number(p.rank, 0)} в общем топе`, "accent")]
          : []),
        ...(groups
          ? [badge(count(groups, ["группа", "группы", "групп"]))]
          : []),
        ...(p.my_group ? [badge("Ведёт у вашей группы", "info")] : []),
        {
          type: "appIf",
          condition: "state.followed",
          child: badge("Вы следите", "success"),
        },
      ]),
    ]),
    gap(12),
    card([
      row([
        col([
          t(p.rating_label, "metric", string(p.rating_color)),
          t(p.reviews_label, "caption", "muted"),
        ], { crossAxisAlignment: "start", mainAxisSize: "min" }),
        hgap(18),
        expanded(col([
          dimRow("Понятность", raw.clarity, raw.rank_clarity),
          gap(8),
          dimRow("Лояльность", raw.loyalty, raw.rank_loyalty),
          gap(8),
          dimRow("Польза", raw.usefulness, raw.rank_usefulness),
        ])),
      ], { crossAxisAlignment: "start" }),
      ...(total >= 3
        ? [
          gap(14),
          ...[5, 4, 3, 2, 1].map((star, i) =>
            row([
              t(`${star}★`, "micro", "muted"),
              hgap(8),
              expanded(
                progressBar(
                  total ? (distribution[i] ?? 0) / total : 0,
                  "warn",
                  5,
                ),
              ),
              hgap(8),
              t(`${distribution[i] ?? 0}`, "micro", "muted"),
            ])
          ),
        ]
        : []),
    ]),
    gap(12),
    challengeCard({ ...raw, ...p }),
    gap(14),
    btn(
      my ? "Изменить мой отзыв" : "Оставить отзыв",
      open(reviewPath(id), "Отзыв"),
      "primary",
      { icon: my ? "pencil" : "star" },
    ),
    gap(8),
    row([
      expanded({
        type: "appIf",
        condition: "state.followed",
        child: btn("Слежу", toggleFollow, "secondary", {
          icon: "heart",
          loadingLabel: "Слежу",
        }),
        else: btn("Следить", toggleFollow, "outline", {
          icon: "heart",
          loadingLabel: "Следить",
        }),
      }),
      hgap(8),
      expanded(
        btn("Поделиться", { actionType: "share", text: share }, "outline", {
          icon: "share",
        }),
      ),
    ]),
    section("Отзывы"),
    dyn(
      "{{state.reviewPage.count > 0 ? str(state.reviewPage.start) + '–' + str(state.reviewPage.end) + ' из ' + str(state.reviewPage.count) : '0 отзывов'}}",
      "caption",
      "muted",
    ),
    gap(10),
    ...(number(reviews.count, 0) > 0
      ? [{
        type: "appForEach",
        items: "state.reviewPage.items",
        template: reviewTemplate(),
      }]
      : [
        empty(
          "Отзывов пока нет",
          "Оставьте первый — поможете другим студентам и продвинетесь к достижению «Критик».",
          btn("Оставить отзыв", open(reviewPath(id), "Отзыв"), "secondary"),
          "✍️",
        ),
      ]),
    {
      type: "appIf",
      condition: "state.reviewPage.last > 0",
      child: card([
        row([
          expanded(t("Отзывы студентов", "labelStrong")),
          badge(
            "{{state.reviewPage.page + 1}} / {{state.reviewPage.last + 1}}",
            "accent",
          ),
        ]),
        gap(8),
        {
          type: "appProgressBar",
          value:
            "{{(state.reviewPage.page + 1) / (state.reviewPage.last + 1)}}",
          color: "accent",
          height: 4,
        },
        gap(12),
        row([
          expanded({
            type: "appIf",
            condition: "state.reviewPage.page > 0",
            child: btn(
              "Назад",
              loadReviews("{{state.reviewPage.page - 1}}"),
              "outline",
            ),
          }),
          hgap(8),
          expanded({
            type: "appIf",
            condition: "state.reviewPage.page < state.reviewPage.last",
            child: btn(
              "Дальше",
              loadReviews("{{state.reviewPage.page + 1}}"),
              "secondary",
            ),
          }),
        ]),
      ]),
    },
    {
      type: "appIf",
      condition: "state.reviewsError != null",
      child: col([
        gap(8),
        t("Не удалось обновить отзывы", "caption", "muted"),
        compact(
          "Повторить",
          loadReviews("{{state.requestedReviewPage}}"),
          "refresh",
        ),
      ]),
    },
    gap(8),
    ...(similar.length
      ? [
        section("Похожие преподаватели", "Ведут те же дисциплины"),
        {
          type: "appListGroup",
          showDividers: true,
          children: similar.map((c) => teacherRow(c)),
        },
      ]
      : []),
  ], {
    followed: p.followed === true,
    reviewPage: reviews,
    requestedReviewPage: reviews.page,
    reviewsError: null,
  }, true);
}
function starRow(key: string, label: string): Node {
  const hints = ratingHints[key] ?? [];
  const hint = `{{state.${key} == 0 ? 'Нажмите на звезду' : ${
    hints.map((h, i) => `state.${key} == ${i + 1} ? '${h}' : `).join("")
  }''}}`;
  return col([
    row([
      expanded(t(label, "labelStrong")),
      dyn(hint, "caption", "muted"),
    ]),
    gap(8),
    row(
      [1, 2, 3, 4, 5].flatMap((n) => [
        {
          type: "appCard",
          padding: 7,
          radius: 12,
          color: `{{state.${key} >= ${n} ? 'warnTint' : 'surface2'}}`,
          semanticsLabel: `${label}: ${n} из 5`,
          onTap: multi(
            set(key, n),
            { actionType: "hapticFeedback", style: "selection" },
          ),
          child: {
            type: "appLineIcon",
            icon: "star",
            size: 26,
            color: `{{state.${key} >= ${n} ? 'warn' : 'muted2'}}`,
          },
        },
        hgap(6),
      ]),
    ),
  ]);
}
function review(state: Json, id: string): Node {
  const raw = object(state.teacher);
  if (!string(raw.id)) return teacher(state, id);
  const p = presentTeacher(raw);
  const my = raw.my_review ? object(raw.my_review) : null;
  const initial: Json = {
    clarity: my ? number(my.clarity, 0) : 0,
    loyalty: my ? number(my.loyalty, 0) : 0,
    usefulness: my ? number(my.usefulness, 0) : 0,
    body: my ? safeText(my.body) : "",
    anonymous: my ? my.anonymous === true : false,
    tipsOpen: false,
  };
  const submit = request(
    "/api/review",
    {
      id,
      clarity: "{{state.clarity}}",
      loyalty: "{{state.loyalty}}",
      usefulness: "{{state.usefulness}}",
      body: "{{state.body}}",
      anonymous: "{{state.anonymous}}",
    },
    multi(
      toast(my ? "Отзыв обновлён" : "Отзыв опубликован · +10 XP"),
      open(teacherPath(id), string(p.short)),
    ),
  );
  return shell([
    card([
      row([
        avatar(string(p.name), 48),
        hgap(12),
        expanded(col([
          t(p.name, "headlineStrong"),
          gap(3),
          t(p.disciplines_label, "caption", "muted", { maxLines: 2 }),
        ])),
      ]),
    ]),
    gap(12),
    card([
      t("Оценки", "captionStrong", "muted"),
      gap(12),
      starRow("clarity", dimensions.clarity.label),
      gap(16),
      starRow("loyalty", dimensions.loyalty.label),
      gap(16),
      starRow("usefulness", dimensions.usefulness.label),
    ]),
    gap(12),
    card([
      {
        type: "appInputField",
        id: "body",
        stateKey: "body",
        label: "Комментарий",
        initialValue: string(initial.body),
        placeholder:
          "Как проходят пары, как принимает зачёт, что помогает готовиться…",
        multiline: true,
        minLines: 3,
        maxLines: 8,
        maxLength: 2000,
        showCounter: true,
      },
      gap(12),
      {
        type: "appToggle",
        stateKey: "anonymous",
        value: "{{state.anonymous}}",
        label: "Опубликовать анонимно",
      },
      gap(8),
      t(
        "Иначе имя показывается как «Фамилия И.». Отзыв видят все студенты.",
        "caption",
        "muted",
      ),
    ]),
    gap(12),
    {
      type: "appChip",
      label: "Что полезно написать",
      selected: "{{state.tipsOpen}}",
      leadingIcon: "book",
      onTap: { actionType: "setState", key: "tipsOpen", toggle: true },
    },
    {
      type: "appIf",
      condition: "state.tipsOpen",
      child: col([
        gap(10),
        card([
          ...[
            "Как проходят лекции и практики: темп, примеры, ответы на вопросы.",
            "Как принимает зачёт или экзамен и что реально спрашивает.",
            "Что помогло подготовиться и чего лучше не делать.",
            "Без оскорблений, оценок внешности и личных данных.",
          ].flatMap((
            line,
            i,
            arr,
          ) => [
            t(`• ${line}`, "subtext"),
            ...(i < arr.length - 1 ? [gap(6)] : []),
          ]),
        ]),
      ]),
    },
    gap(16),
    btn(
      my ? "Сохранить изменения" : "Опубликовать отзыв",
      {
        actionType: "runIf",
        condition:
          "state.clarity > 0 && state.loyalty > 0 && state.usefulness > 0",
        then: submit,
        else: toast("Поставьте все три оценки", "warning"),
      },
      "primary",
      { icon: "send" },
    ),
    ...(my
      ? [
        gap(8),
        btn(
          "Удалить отзыв",
          {
            actionType: "confirm",
            title: "Удалить отзыв?",
            message:
              "Отзыв исчезнет из профиля преподавателя, а начисленные за него очки спишутся.",
            isDanger: true,
            confirmLabel: "Удалить",
            onConfirm: request(
              "/api/review/delete",
              { id },
              multi(toast("Отзыв удалён"), goHome),
            ),
          },
          "ghost",
          { icon: "close" },
        ),
      ]
      : []),
    gap(8),
    t(
      "До 20 отзывов в день. Отзыв можно изменить или удалить в любой момент.",
      "caption",
      "muted",
      { align: "center" },
    ),
  ], initial);
}
function top(state: Json): Node {
  const me = object(state.me);
  const board = object(state.board);
  const students = list(state.students);
  const hasGroup = me.has_group === true;
  const initial: Json = {
    tab: 0,
    board: string(board.board || "overall"),
    scope: string(board.scope || "all"),
    busy: false,
    loadError: null,
    board_data: {
      board: string(board.board || "overall"),
      scope: string(board.scope || "all"),
      count: number(board.count, 0),
      items: list(board.items).map((item) =>
        presentBoardItem(string(board.board || "overall"), item)
      ),
    },
  };
  const fetch: Node = {
    actionType: "fetch",
    path: "/api/top",
    method: "POST",
    body: { board: "{{state.board}}", scope: "{{state.scope}}" },
    saveAs: "board_data",
    loadingKey: "busy",
    errorKey: "loadError",
    onError: toast("Не удалось обновить топ. Попробуйте ещё раз.", "error"),
  };
  const boardChip = (value: string, label: string): Node => ({
    type: "appChip",
    label,
    selected: `{{state.board == '${value}'}}`,
    onTap: multi(set("board", value), fetch),
  });
  const myRank = number(me.rank, 0);
  const myStreak = number(me.streak_days, 0);
  return shell([
    {
      type: "appSegmentedControl",
      stateKey: "tab",
      selectedIndex: 0,
      options: [{ label: "Преподаватели" }, { label: "Студенты" }],
    },
    gap(14),
    {
      type: "appIf",
      condition: "state.tab == 0",
      child: col([
        {
          type: "singleChildScrollView",
          scrollDirection: "horizontal",
          child: {
            type: "row",
            mainAxisSize: "min",
            children: Object.entries(boards).flatMap((
              [value, entry],
            ) => [boardChip(value, entry.label), hgap(8)]),
          },
        },
        ...(hasGroup
          ? [
            gap(8),
            wrap([
              {
                type: "appChip",
                label: "Все",
                selected: "{{state.scope == 'all'}}",
                onTap: multi(set("scope", "all"), fetch),
              },
              {
                type: "appChip",
                label: `Моя группа · ${safeText(me.group_name)}`,
                selected: "{{state.scope == 'group'}}",
                onTap: multi(set("scope", "group"), fetch),
              },
            ]),
          ]
          : []),
        gap(12),
        {
          type: "appSwitch",
          value: "state.board",
          cases: Object.entries(boards).map(([value, entry]) => ({
            when: value,
            child: t(entry.hint, "caption", "muted"),
          })),
        },
        gap(10),
        {
          type: "appIf",
          condition: "state.busy",
          child: col([t("Обновляем топ…", "caption", "muted"), gap(8)]),
        },
        {
          type: "appIf",
          condition: "state.loadError != null",
          child: col([
            card([
              {
                type: "appErrorState",
                compact: true,
                title: "Не удалось обновить",
                message: "Показан последний загруженный топ.",
              },
              gap(8),
              compact("Повторить", fetch, "refresh"),
            ]),
            gap(12),
          ]),
        },
        {
          type: "appIf",
          condition: "state.board_data.items.length == 0 && !state.busy",
          child: empty(
            "Пока пусто",
            "Нужны отзывы: в рейтинг попадают преподаватели с двумя и более оценками.",
            btn(
              "Кого оценить",
              open("/recommend", "Кого оценить"),
              "secondary",
            ),
            "🏆",
          ),
        },
        {
          type: "appForEach",
          items: "state.board_data.items",
          as: "column",
          template: col([
            {
              type: "appCard",
              padding: 12,
              radius: 18,
              onTap: open("/teacher?id={{item.id}}", "{{item.short}}"),
              semanticsLabel:
                "{{item.position_label}}. {{item.name}}. {{item.value_label}}",
              child: row([
                {
                  type: "appIf",
                  condition: "item.medal != ''",
                  child: {
                    type: "appIconTile",
                    emoji: "{{item.medal}}",
                    size: 40,
                    radius: 12,
                    color: "warn",
                  },
                  else: {
                    type: "appIconTile",
                    size: 40,
                    radius: 12,
                    color: "accent",
                    child: dyn(
                      "#{{item.position_label}}",
                      "labelStrong",
                      "accent",
                    ),
                  },
                },
                hgap(10),
                { type: "appAvatar", name: "{{item.name}}", size: 40 },
                hgap(10),
                expanded(col([
                  dyn("{{item.name}}", "headlineStrong", undefined, {
                    maxLines: 2,
                  }),
                  gap(2),
                  dyn("{{item.disciplines_label}}", "caption", "muted", {
                    maxLines: 1,
                  }),
                  {
                    type: "appIf",
                    condition: "item.streak_label != ''",
                    child: col([
                      gap(6),
                      badge("{{item.streak_label}}", "warn"),
                    ]),
                  },
                ])),
                hgap(8),
                col([
                  dyn(
                    "{{item.value_label}}",
                    "headlineStrong",
                    "{{item.rating_color}}",
                  ),
                  gap(2),
                  dyn("{{item.reviews_label}}", "micro", "muted"),
                ], { crossAxisAlignment: "end", mainAxisSize: "min" }),
              ]),
            },
            gap(8),
          ]),
        },
        gap(8),
        card([
          t("Как считается рейтинг", "captionStrong", "muted"),
          gap(6),
          t(
            "Средняя из трёх оценок сглаживается по числу отзывов, чтобы один восторженный отзыв не выводил на первое место. Серия дней в топ-10 обновляется раз в сутки.",
            "caption",
            "muted",
          ),
        ]),
      ]),
      else: col([
        {
          type: "appCard",
          padding: 16,
          radius: 20,
          tinted: true,
          child: row([
            {
              type: "appProgressRing",
              value: Math.min(1, myStreak / 7),
              size: 60,
              strokeWidth: 6,
              label: `${myStreak}`,
              sublabel: "из 7",
              color: "warn",
            },
            hgap(14),
            expanded(col([
              t(
                myRank
                  ? `Вы #${myRank} · ${number(me.points, 0)} XP`
                  : "Вы ещё не в рейтинге",
                "headlineStrong",
              ),
              gap(4),
              t(
                myRank
                  ? myStreak > 0
                    ? `В топ-10 ${
                      count(myStreak, ["день", "дня", "дней"])
                    } подряд. Продержитесь неделю и закрепитесь среди лучших.`
                    : "Попадите в топ-10 и продержитесь 7 дней подряд."
                  : "Оставьте первый отзыв — 10 XP сразу, ещё +5 за развёрнутый текст.",
                "caption",
                "muted",
              ),
            ])),
          ]),
        },
        gap(12),
        ...(students.length
          ? students.flatMap((s) => [{
            type: "appCard",
            padding: 12,
            radius: 16,
            ...(s.mine ? { tinted: true } : {}),
            child: row([
              rankTile(
                number(s.rank, 0),
                number(s.rank, 0) === 1
                  ? "🥇"
                  : number(s.rank, 0) === 2
                  ? "🥈"
                  : number(s.rank, 0) === 3
                  ? "🥉"
                  : "",
              ),
              hgap(10),
              expanded(col([
                t(
                  s.mine ? `${safeText(s.name)} · это вы` : s.name,
                  "labelStrong",
                  undefined,
                  { maxLines: 1 },
                ),
                gap(2),
                t(
                  `${
                    count(number(s.reviews, 0), ["отзыв", "отзыва", "отзывов"])
                  } · ${
                    count(number(s.helpful, 0), [
                      "отметка",
                      "отметки",
                      "отметок",
                    ])
                  } «полезно»`,
                  "caption",
                  "muted",
                ),
                ...(number(s.streak, 0) > 0
                  ? [
                    gap(4),
                    badge(
                      `🔥 ${
                        count(number(s.streak, 0), ["день", "дня", "дней"])
                      } в топ-10`,
                      "warn",
                    ),
                  ]
                  : []),
              ])),
              hgap(8),
              t(`${number(s.points, 0)} XP`, "headlineStrong", "accent"),
            ]),
          }, gap(8)])
          : [
            empty(
              "Рейтинг ещё не начался",
              "Первый отзыв откроет таблицу рецензентов.",
              btn(
                "Кого оценить",
                open("/recommend", "Кого оценить"),
                "secondary",
              ),
              "🏅",
            ),
          ]),
        gap(6),
        card([
          {
            type: "appToggle",
            value: me.show_in_leaderboard === true,
            label: "Показывать моё имя в рейтинге",
            onChange: request("/api/settings", {
              show_in_leaderboard: me.show_in_leaderboard !== true,
            }),
          },
          gap(8),
          t(
            `Сейчас вы отображаетесь как «${safeText(me.display_name)}».`,
            "caption",
            "muted",
          ),
          gap(8),
          t(
            "Очки: 10 за отзыв, +5 за текст от 60 символов, +5 за каждую отметку «полезно» от других студентов.",
            "caption",
            "muted",
          ),
        ]),
      ]),
    },
  ], initial);
}
const achievementSteps: [number, string, string][] = [
  [1, "Первый отзыв", "📝"],
  [3, "Критик", "⭐"],
  [10, "Рецензент", "🎓"],
  [25, "Голос курса", "🏅"],
];
function achievementsCard(reviews: number): Node {
  const next = achievementSteps.find(([goal]) => reviews < goal);
  return card([
    ...achievementSteps.flatMap(([goal, title, emoji], i) => [
      row([
        {
          type: "appIconTile",
          emoji,
          size: 36,
          radius: 12,
          color: reviews >= goal ? "success" : "accent",
        },
        hgap(10),
        expanded(col([
          t(title, "labelStrong", reviews >= goal ? "ink" : "muted"),
          gap(2),
          t(
            reviews >= goal
              ? "Получено"
              : `${count(goal, ["отзыв", "отзыва", "отзывов"])} · ${
                Math.min(reviews, goal)
              }/${goal}`,
            "caption",
            reviews >= goal ? "success" : "muted",
          ),
        ])),
        ...(reviews >= goal
          ? [{ type: "appLineIcon", icon: "check", size: 18, color: "success" }]
          : []),
      ]),
      ...(i < achievementSteps.length - 1 ? [gap(10)] : []),
    ]),
    gap(12),
    progressBar(next ? reviews / next[0] : 1, next ? "accent" : "success"),
    gap(10),
    btn(
      "Открыть достижения",
      { actionType: "openDeepLink", location: "/profile" },
      "secondary",
      {
        icon: "arrowRight",
      },
    ),
  ]);
}
function questRow(
  title: string,
  subtitle: string,
  value: number,
  extra?: Node,
): Node {
  return col([
    row([
      expanded(col([
        t(title, "labelStrong"),
        gap(2),
        t(subtitle, "caption", "muted"),
      ])),
      ...(extra ? [hgap(8), extra] : []),
    ]),
    gap(8),
    progressBar(value, value >= 1 ? "success" : "accent"),
  ]);
}
function me(state: Json): Node {
  const me = object(state.me);
  const myReviews = list(state.my_reviews).map((r): Json => ({
    ...presentReview(r),
    card: presentTeacher(object(r.card)),
  }));
  const followed = list(state.followed).map(presentTeacher);
  const week = number(me.week_reviews, 0), goal = number(me.week_goal, 2);
  const groupTotal = number(me.group_total, 0),
    groupDone = number(me.group_done, 0);
  const streak = number(me.streak_days, 0);
  return shell([
    levelCard(me, true),
    section("Задания", "Прогресс обновляется сразу после отзыва"),
    card([
      questRow(
        "Неделя отзывов",
        week >= goal
          ? "Выполнено — так держать!"
          : `Оцените ${
            count(goal, ["преподавателя", "преподавателей", "преподавателей"])
          } до воскресенья · ${week}/${goal}`,
        goal ? week / goal : 0,
      ),
      ...(me.has_group === true && groupTotal
        ? [
          gap(14),
          questRow(
            "Голос группы",
            `Оценено ${groupDone} из ${groupTotal} преподавателей ${
              safeText(me.group_name)
            }`,
            groupDone / groupTotal,
            compact(
              "Кто ещё",
              open("/recommend", "Кого оценить"),
              "arrowRight",
            ),
          ),
        ]
        : []),
      gap(14),
      questRow(
        "Неделя в топ-10",
        streak > 0
          ? `${
            count(streak, ["день", "дня", "дней"])
          } подряд среди лучших рецензентов`
          : "Попадите в топ-10 рецензентов и продержитесь 7 дней",
        streak / 7,
        compact("Рейтинг", open("/top", "Топ"), "arrowRight"),
      ),
    ]),
    section("Достижения", "Отзывы засчитываются в профиле приложения"),
    achievementsCard(number(me.reviews, 0)),
    section("Мои отзывы", undefined, { meta: `${myReviews.length}` }),
    ...(myReviews.length
      ? myReviews.flatMap((r) => {
        const card = object(r.card);
        return [{
          type: "appCard",
          padding: 14,
          radius: 18,
          onTap: open(teacherPath(card.id), string(card.short)),
          child: col([
            row([
              avatar(string(r.teacher), 40),
              hgap(10),
              expanded(col([
                t(r.teacher_short, "headlineStrong", undefined, {
                  maxLines: 1,
                }),
                gap(2),
                t(
                  `${string(r.date_label)} · ★ ${string(r.rating_label)}${
                    r.anonymous ? " · анонимно" : ""
                  }`,
                  "caption",
                  "muted",
                ),
              ])),
              hgap(8),
              compact("Изменить", open(reviewPath(card.id), "Отзыв"), "pencil"),
            ]),
            ...(string(r.excerpt)
              ? [gap(8), t(r.excerpt, "subtext", "muted", { maxLines: 3 })]
              : []),
          ]),
        }, gap(10)];
      })
      : [
        empty(
          "Отзывов ещё нет",
          "Первый отзыв даст 10 XP и откроет достижение «Первый отзыв».",
          btn("Кого оценить", open("/recommend", "Кого оценить"), "secondary"),
          "✍️",
        ),
      ]),
    section("Слежу", "Быстрый доступ к профилям", {
      meta: `${followed.length}`,
    }),
    ...(followed.length
      ? [{
        type: "appListGroup",
        showDividers: true,
        children: followed.map((c) => teacherRow(c)),
      }]
      : [
        card([
          t(
            "Нажмите «Следить» в профиле преподавателя — он появится здесь.",
            "caption",
            "muted",
          ),
        ]),
      ]),
    gap(16),
    card([
      {
        type: "appToggle",
        value: me.show_in_leaderboard === true,
        label: "Показывать моё имя в рейтинге",
        onChange: request("/api/settings", {
          show_in_leaderboard: me.show_in_leaderboard !== true,
        }),
      },
      gap(8),
      t(
        `В рейтинге рецензентов вы отображаетесь как «${
          safeText(me.display_name)
        }».`,
        "caption",
        "muted",
      ),
    ]),
  ]);
}
function recommend(state: Json): Node {
  const me = object(state.me);
  const items = list(state.recommend).map(presentTeacher);
  const reviewed = list(state.reviewed).map(presentTeacher);
  if (me.has_group !== true) {
    return shell([
      empty(
        "Нужна ваша группа",
        "Выберите расписание группы в приложении — тогда покажем ваших преподавателей и кого оценить первым.",
        btn(
          "Открыть расписание",
          { actionType: "openDeepLink", location: "/schedule" },
          "primary",
          { icon: "calendar" },
        ),
        "🗓️",
      ),
      gap(12),
      btn("Искать преподавателя", goHome, "outline", { icon: "search" }),
    ]);
  }
  const total = number(me.group_total, 0), done = number(me.group_done, 0);
  const today = items.filter((c) => c.today === true);
  const rest = items.filter((c) => c.today !== true);
  return shell([
    {
      type: "appCard",
      padding: 16,
      radius: 20,
      tinted: true,
      child: row([
        {
          type: "appProgressRing",
          value: total ? done / total : 0,
          size: 64,
          strokeWidth: 6,
          label: `${done}`,
          sublabel: `из ${total}`,
          color: "accent",
        },
        hgap(14),
        expanded(col([
          t(`Группа ${safeText(me.group_name)}`, "headlineStrong"),
          gap(4),
          t(
            total === 0
              ? "В этом семестре у группы пока нет пар в расписании."
              : done >= total
              ? "Вы оценили всех преподавателей группы 🎉"
              : `Оценено ${done} из ${total} преподавателей семестра.`,
            "caption",
            "muted",
          ),
        ])),
      ]),
    },
    ...(today.length
      ? [
        section("Сегодня", "Пары, после которых легко оставить отзыв"),
        ...today.flatMap((c) => [recommendCard(c), gap(10)]),
      ]
      : []),
    ...(rest.length
      ? [
        section("Ещё не оценили", "Сначала те, у кого отзывов меньше всего"),
        ...rest.flatMap((c) => [recommendCard(c), gap(10)]),
      ]
      : []),
    ...(items.length === 0 && total > 0
      ? [
        gap(12),
        empty(
          "Все оценены",
          "Спасибо! Возвращайтесь, когда появятся новые преподаватели.",
          btn("В топ преподов", open("/top", "Топ"), "secondary"),
          "🎉",
        ),
      ]
      : []),
    ...(reviewed.length
      ? [
        section("Уже оценили", undefined, { meta: `${reviewed.length}` }),
        {
          type: "appListGroup",
          showDividers: true,
          children: reviewed.map((c) => teacherRow(c)),
        },
      ]
      : []),
  ]);
}
export function buildScreen(
  path: string,
  stateInput: unknown,
  extra: Json = {},
): Node {
  const state = object(stateInput), id = string(extra.id);
  if (path === "/") return home(state);
  if (path === "/teacher") return teacher(state, id, number(extra.page, 0));
  if (path === "/review") return review(state, id);
  if (path === "/top") return top(state);
  if (path === "/me") return me(state);
  if (path === "/recommend") return recommend(state);
  return shell([
    empty(
      "Страница не найдена",
      "Откройте поиск преподавателей.",
      btn("К поиску", goHome),
      "🧭",
    ),
  ]);
}
