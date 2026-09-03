// Builds the "Витрина возможностей" demo mini app (hosted, multi-screen) and
// emits a Supabase seed migration. Authoring the screens as JS objects keeps
// the giant BDUI JSON readable and lets us reuse small builders.
//
//   node scripts/build_showcase_seed.mjs > supabase/migrations/<ts>_seed_showcase_mini_app.sql
//
// Every widget/action/icon used here is registered in stac_bridge, so it
// renders natively in the Mirea Ninja runner.

import { pathToFileURL } from "node:url";

const ACCENT = "accent";
const GREEN = "lecture";
const BLUE = "practice";
const ORANGE = "warn";
const PINK = "exam";
const CYAN = "lab";

// --- tiny builders ----------------------------------------------------------
const sb = (height) => ({ type: "sizedBox", height });
const col = (children, extra = {}) => ({
  type: "column",
  crossAxisAlignment: "stretch",
  ...extra,
  children,
});
const roww = (children, extra = {}) => ({ type: "row", ...extra, children });
const wrap = (children, spacing = 8, runSpacing = 8) => ({
  type: "wrap",
  spacing,
  runSpacing,
  children,
});
const text = (data) => ({ type: "appText", data });
const card = (child, opts = {}) => ({ type: "appCard", child, ...opts });
const section = (title, subtitle, action, onActionTap) => ({
  type: "appSectionTitle",
  title,
  ...(subtitle ? { subtitle } : {}),
  ...(action ? { action } : {}),
  ...(onActionTap ? { onActionTap } : {}),
});
const btn = (label, onPressed, variant = "primary", expanded = false) => ({
  type: "appButton",
  label,
  variant,
  expanded,
  ...(onPressed ? { onPressed } : {}),
});
const chip = (label, onTap, opts = {}) => ({
  type: "appChip",
  label,
  ...opts,
  ...(onTap ? { onTap } : {}),
});
const tag = (label, tone, withDot = false) => ({ type: "appTag", label, tone, withDot });
const pill = (t, strong = false) => ({ type: "appMetaPill", text: t, strong });
const smart = (emoji, label, value, tone) => ({
  type: "appSmartChip",
  emoji,
  label,
  value,
  ...(tone ? { tone } : {}),
});
const tile = (emoji, label, color, onTap, solid = false) => ({
  type: "appServiceTile",
  emoji,
  label,
  color,
  solid,
  ...(onTap ? { onTap } : {}),
});
const listRow = (o) => ({ type: "appListRow", ...o });
const lineIcon = (icon, size = 22, color) => ({
  type: "appLineIcon",
  icon,
  size,
  ...(color ? { color } : {}),
});
const iconBtn = (icon, onPressed, variant = "secondary", tooltip) => ({
  type: "appIconButton",
  icon,
  variant,
  ...(tooltip ? { tooltip } : {}),
  ...(onPressed ? { onPressed } : {}),
});
const ring = (value, label, sublabel, color) => ({
  type: "appProgressRing",
  value,
  size: 76,
  label,
  ...(sublabel ? { sublabel } : {}),
  ...(color ? { color } : {}),
});
const scaffold = (children) => ({
  type: "scaffold",
  body: {
    type: "singleChildScrollView",
    padding: { left: 16, right: 16, top: 16, bottom: 28 },
    child: col(children),
  },
});

// --- actions ----------------------------------------------------------------
const toast = (message) => ({ actionType: "showToast", message });
const haptic = (style) => ({ actionType: "hapticFeedback", style });
const openPage = (path, title) => ({ actionType: "openPage", path, title });
const deeplink = (location) => ({ actionType: "openDeepLink", location });
const openMini = (slug, page) => ({ actionType: "openMiniApp", slug, ...(page ? { page } : {}) });
const setStateA = (key, patch) => ({ actionType: "setState", key, ...patch });
const setStorageA = (key, value) => ({ actionType: "setStorage", key, value });
const multi = (actions) => ({ actionType: "multiAction", actions });
const reload = () => ({ actionType: "reload" });
const pop = () => ({ actionType: "pop" });
const share = (t) => ({ actionType: "share", text: t });
const copy = (t, m) => ({ actionType: "copyToClipboard", text: t, message: m });
const openUrl = (url) => ({ actionType: "openUrl", url });

// device capabilities
const getLocation = (saveAs) => ({ actionType: "getLocation", saveAs });
const pickImage = (saveAs, source) => ({ actionType: "pickImage", saveAs, source });
const scanCode = (saveAs) => ({ actionType: "scanCode", saveAs });
const pickFile = (saveAs) => ({ actionType: "pickFile", saveAs });
const authenticate = (saveAs, reason) => ({ actionType: "authenticate", saveAs, reason });
const scheduleReminder = (o) => ({ actionType: "scheduleReminder", ...o });
const addCalendarEvent = (o) => ({ actionType: "addCalendarEvent", ...o });
const readClipboard = (saveAs) => ({ actionType: "readClipboard", saveAs });
const pickDateTime = (saveAs, mode) => ({ actionType: "pickDateTime", saveAs, mode });

// logic layer
const appIf = (condition, child, elseChild) => ({
  type: "appIf",
  condition,
  child,
  ...(elseChild ? { else: elseChild } : {}),
});
const appForEach = (items, template, opts = {}) => ({
  type: "appForEach",
  items,
  template,
  ...opts,
});
const appSwitch = (value, cases, def) => ({
  type: "appSwitch",
  value,
  cases,
  ...(def ? { default: def } : {}),
});
const setStateExpr = (key, expression) => ({ actionType: "setState", key, expression });

const backButton = btn("← Назад", pop(), "ghost", true);

// ============================================================================
// SCREEN: / (overview + navigation)
// ============================================================================
const home = scaffold([
  section("Витрина возможностей", "Из чего собираются мини-аппы"),
  sb(10),
  card(
    col([
      roww([
        lineIcon("spark", 26, ACCENT),
        sb(0),
        { type: "sizedBox", width: 10 },
        text("Это мини-апп на Stac"),
      ], { crossAxisAlignment: "center" }),
      sb(10),
      text(
        "Каждый экран описан в JSON. Здесь собраны нативные виджеты и действия " +
          "платформы Mirea Ninja — потыкай разделы ниже.",
      ),
      sb(14),
      wrap([
        tag("Stac BDUI", "accent"),
        tag("Live", "live", true),
        tag("Open source", "info"),
        tag("Без сборки", "pink"),
      ]),
      sb(14),
      roww([
        { type: "appAvatarStack", names: ["Иван", "Мария", "Олег", "Аня"], size: 30 },
        { type: "spacer" },
        smart("🧩", "виджетов", "20+", ACCENT),
      ], { crossAxisAlignment: "center" }),
    ]),
  ),
  sb(20),
  section("Разделы"),
  sb(10),
  card(
    col([
      listRow({
        title: "Виджеты",
        subtitle: "Кнопки, чипы, бейджи, аватары, прогресс",
        emoji: "🧱",
        emojiColor: ACCENT,
        isFirst: true,
        trailing: lineIcon("chevronR", 20),
        onTap: openPage("/widgets", "Виджеты"),
      }),
      listRow({
        title: "Ввод и формы",
        subtitle: "Сегменты, переключатели, валидация",
        emoji: "🎛️",
        emojiColor: BLUE,
        trailing: lineIcon("chevronR", 20),
        onTap: openPage("/inputs", "Ввод и формы"),
      }),
      listRow({
        title: "Состояние и хранилище",
        subtitle: "setState и setStorage без сервера",
        emoji: "⚡",
        emojiColor: ORANGE,
        trailing: lineIcon("chevronR", 20),
        onTap: openPage("/interactive", "Состояние"),
      }),
      listRow({
        title: "Логика и выражения",
        subtitle: "Выражения, условия, списки, ветвление",
        emoji: "🧠",
        emojiColor: GREEN,
        trailing: lineIcon("chevronR", 20),
        onTap: openPage("/logic", "Логика"),
      }),
      listRow({
        title: "Действия",
        subtitle: "Тосты, шторки, подтверждения, шеринг",
        emoji: "✨",
        emojiColor: PINK,
        trailing: lineIcon("chevronR", 20),
        onTap: openPage("/actions", "Действия"),
      }),
      listRow({
        title: "Навигация",
        subtitle: "Диплинки в приложение и другие аппы",
        emoji: "🧭",
        emojiColor: CYAN,
        trailing: lineIcon("chevronR", 20),
        onTap: openPage("/navigation", "Навигация"),
      }),
      listRow({
        title: "Возможности устройства",
        subtitle: "Гео, фото, скан, файлы, календарь, биометрия",
        emoji: "📱",
        emojiColor: GREEN,
        trailing: lineIcon("chevronR", 20),
        onTap: openPage("/device", "Устройство"),
      }),
    ]),
    { padding: 6 },
  ),
  sb(20),
  section("Сетка сервис-плиток"),
  sb(10),
  card(
    wrap([
      tile("🧱", "Виджеты", ACCENT, openPage("/widgets", "Виджеты"), true),
      tile("🎛️", "Ввод", BLUE, openPage("/inputs", "Ввод и формы")),
      tile("⚡", "State", ORANGE, openPage("/interactive", "Состояние")),
      tile("🧠", "Логика", GREEN, openPage("/logic", "Логика")),
      tile("✨", "Actions", PINK, openPage("/actions", "Действия")),
      tile("🧭", "Навигация", CYAN, openPage("/navigation", "Навигация")),
      tile("📱", "Устройство", GREEN, openPage("/device", "Устройство")),
      tile("🚪", "Аудитории", PINK, openMini("free-rooms")),
    ], 12, 12),
  ),
  sb(20),
  btn("Открыть расписание", deeplink("/schedule"), "primary", true),
]);

// ============================================================================
// SCREEN: /widgets (display gallery)
// ============================================================================
const widgets = scaffold([
  section("Кнопки", "variant × size"),
  sb(10),
  card(
    col([
      btn("Primary", toast("primary"), "primary", true),
      sb(8),
      btn("Secondary", toast("secondary"), "secondary", true),
      sb(8),
      btn("Outline", toast("outline"), "outline", true),
      sb(8),
      btn("Ghost", toast("ghost"), "ghost", true),
      sb(8),
      btn("Danger", toast("danger"), "danger", true),
    ]),
  ),
  sb(20),
  section("Иконки-кнопки"),
  sb(10),
  card(
    roww([
      iconBtn("heart", toast("♥"), "secondary", "Лайк"),
      { type: "sizedBox", width: 10 },
      iconBtn("share", share("Смотри витрину мини-аппов"), "secondary", "Поделиться"),
      { type: "sizedBox", width: 10 },
      iconBtn("bookmark", toast("сохранено"), "secondary", "В закладки"),
      { type: "sizedBox", width: 10 },
      iconBtn("qr", toast("QR"), "secondary", "QR"),
      { type: "spacer" },
      iconBtn("more", toast("меню"), "ghost", "Ещё"),
    ], { crossAxisAlignment: "center" }),
  ),
  sb(20),
  section("Чипы-фильтры"),
  sb(10),
  card(
    wrap([
      chip("Все", toast("Все"), { selected: true, color: ACCENT }),
      chip("Сегодня", toast("Сегодня")),
      chip("Неделя", toast("Неделя")),
      chip("Избранное", toast("Избранное"), { color: PINK }),
      chip("small", toast("small"), { small: true }),
    ]),
  ),
  sb(20),
  section("Теги и бейджи"),
  sb(10),
  card(
    col([
      wrap([
        tag("accent", "accent"),
        tag("live", "live", true),
        tag("warn", "warn"),
        tag("danger", "danger"),
        tag("info", "info"),
        tag("pink", "pink"),
        tag("mute", "mute"),
        tag("solid", "solid"),
      ]),
      sb(12),
      roww([{ type: "appLiveBadge", label: "Сейчас в эфире" }]),
    ]),
  ),
  sb(20),
  section("Смарт-чипы"),
  sb(10),
  card(
    wrap([
      smart("🍲", "Столовая", "~8 мин", ORANGE),
      smart("📚", "Библиотека", "до 20:00", BLUE),
      smart("🚪", "Свободно", "144", GREEN),
    ], 10, 10),
  ),
  sb(20),
  section("Аватары"),
  sb(10),
  card(
    roww([
      { type: "appAvatar", name: "Иван Петров", size: 44 },
      { type: "sizedBox", width: 12 },
      { type: "appAvatar", name: "Мария Кузнецова", size: 44, color: PINK },
      { type: "spacer" },
      { type: "appAvatarStack", names: ["Олег", "Аня", "Лев", "Ким", "Ро"], size: 38 },
    ], { crossAxisAlignment: "center" }),
  ),
  sb(20),
  section("Кольца прогресса"),
  sb(10),
  card(
    roww([
      ring(0.72, "72%", "готово", GREEN),
      { type: "spacer" },
      ring(0.4, "40%", "сон", BLUE),
      { type: "spacer" },
      ring(0.9, "9/10", "квест", ORANGE),
    ], { mainAxisAlignment: "spaceBetween" }),
  ),
  sb(20),
  section("Строки списка"),
  sb(10),
  card(
    col([
      listRow({
        title: "Высшая математика",
        subtitle: "ауд. А-401 · 10:40",
        emoji: "📐",
        emojiColor: BLUE,
        isFirst: true,
        trailing: pill("скоро", true),
      }),
      listRow({
        title: "Физика",
        subtitle: "ауд. Б-215 · 12:20",
        emoji: "🧲",
        emojiColor: ACCENT,
        trailing: tag("Live", "live", true),
      }),
      listRow({
        title: "История",
        subtitle: "ауд. В-100 · 14:00",
        emoji: "📜",
        emojiColor: ORANGE,
        trailing: lineIcon("chevronR", 20),
      }),
    ]),
    { padding: 6 },
  ),
  sb(20),
  section("Набор линейных иконок"),
  sb(10),
  card(
    wrap(
      [
        "home", "calendar", "map", "search", "bell", "settings", "book",
        "heart", "star", "bookmark", "share", "qr", "shield", "people",
        "bolt", "trophy", "pin", "clock",
      ].map((i) => lineIcon(i, 26, ACCENT)),
      14,
      14,
    ),
  ),
  sb(20),
  section("Пустые состояния и ошибки"),
  sb(10),
  card({
    type: "appEmptyState",
    emoji: "🍃",
    title: "Пока пусто",
    subtitle: "Здесь появится контент",
    child: btn("Добавить", toast("Добавлено")),
  }),
  sb(12),
  card({
    type: "appErrorState",
    title: "Не загрузилось",
    message: "Проверь соединение и попробуй снова",
    primaryLabel: "Повторить",
    onPrimary: toast("Повтор"),
  }),
  sb(20),
  backButton,
]);

// ============================================================================
// SCREEN: /inputs (segmented, toggle, form)
// ============================================================================
const inputs = scaffold([
  section("Сегменты", "Переключают контент локально, без сервера"),
  sb(10),
  card({
    type: "appSegmentedControl",
    selectedIndex: 0,
    options: [
      { label: "Сегодня", onSelected: haptic("selection"), child: col([
        listRow({ title: "9:00 Матанализ", subtitle: "А-401", emoji: "📐", isFirst: true }),
        listRow({ title: "10:40 Физика", subtitle: "Б-215", emoji: "🧲" }),
      ]) },
      { label: "Неделя", onSelected: haptic("selection"), child: col([
        smart("📅", "Пар на неделе", "18", BLUE),
      ]) },
      { label: "Месяц", onSelected: haptic("selection"), child: col([
        smart("🗓️", "Зачётов", "4", ORANGE),
      ]) },
    ],
  }),
  sb(20),
  section("Переключатель"),
  sb(10),
  card(
    roww([
      lineIcon("bell", 22, ACCENT),
      { type: "sizedBox", width: 12 },
      text("Push-уведомления"),
      { type: "spacer" },
      { type: "appToggle", value: true, onChange: toast("Переключено") },
    ], { crossAxisAlignment: "center" }),
  ),
  sb(20),
  section("Форма с валидацией", "validateForm + правила полей"),
  sb(10),
  card({
    type: "form",
    child: col([
      {
        type: "appInputField",
        id: "name",
        label: "Имя",
        placeholder: "Минимум 2 символа",
        minLength: 2,
        validationMessage: "Минимум 2 символа",
      },
      sb(12),
      {
        type: "appInputField",
        id: "email",
        label: "Почта",
        placeholder: "you@mirea.ru",
        email: true,
        validationMessage: "Неверный e-mail",
      },
      sb(16),
      btn("Проверить", {
        actionType: "validateForm",
        isValid: multi([haptic("medium"), toast("Форма валидна ✓")]),
      }, "primary", true),
    ]),
  }),
  sb(20),
  backButton,
]);

// ============================================================================
// SCREEN: /interactive (state + storage)
// ============================================================================
const interactive = scaffold([
  section("Локальное состояние", "setState — в памяти, без перезагрузки"),
  sb(10),
  {
    type: "appStateScope",
    initial: { count: 0, likes: 0 },
    child: col([
      card(
        col([
          roww([
            smart("🔢", "Счётчик", "{{state.count}}", ACCENT),
            { type: "spacer" },
          ]),
          sb(12),
          roww([
            { type: "expanded", child: btn("−1", setStateA("count", { add: -1 }), "outline", true) },
            { type: "sizedBox", width: 10 },
            { type: "expanded", child: btn("+1", multi([haptic("light"), setStateA("count", { add: 1 })]), "primary", true) },
            { type: "sizedBox", width: 10 },
            { type: "expanded", child: btn("+10", setStateA("count", { add: 10 }), "secondary", true) },
          ]),
        ]),
      ),
      sb(12),
      card(
        roww([
          lineIcon("heart", 24, PINK),
          { type: "sizedBox", width: 12 },
          smart("❤️", "Лайков", "{{state.likes}}", PINK),
          { type: "spacer" },
          iconBtn("plus", setStateA("likes", { add: 1 }), "secondary", "Лайк"),
        ], { crossAxisAlignment: "center" }),
      ),
    ]),
  },
  sb(8),
  text("setState — временно: живёт в памяти экрана и сбрасывается при выходе. Для записи в БД — setStorage ниже."),
  sb(22),
  section("Персональное хранилище", "setStorage пишет в БД — переживает перезапуск"),
  sb(10),
  {
    // setStorage writes to Postgres; on next launch the runner primes
    // {{storage.*}} from the DB, so the conditional shows the saved state.
    // The setState bump just forces this scope to re-render right after the
    // write (no reload needed on an inner page).
    type: "appStateScope",
    initial: { r: 0 },
    child: {
      type: "conditional",
      condition: "{{storage.demoFav}} == true",
      ifTrue: card(
        col([
          roww([
            lineIcon("star", 26, ORANGE),
            { type: "sizedBox", width: 12 },
            text("В БД сохранено: в избранном ⭐"),
            { type: "spacer" },
          ], { crossAxisAlignment: "center" }),
          sb(14),
          btn("Убрать из избранного", multi([
            setStorageA("demoFav", false),
            setStateA("r", { add: 1 }),
            toast("Обновлено в БД"),
          ]), "outline", true),
        ]),
      ),
      ifFalse: card(
        col([
          roww([
            lineIcon("star", 26, "muted"),
            { type: "sizedBox", width: 12 },
            text("В БД сохранено: пусто"),
            { type: "spacer" },
          ], { crossAxisAlignment: "center" }),
          sb(14),
          btn("Добавить в избранное", multi([
            setStorageA("demoFav", true),
            setStateA("r", { add: 1 }),
            toast("Записано в БД"),
          ]), "primary", true),
        ]),
      ),
    },
  },
  sb(8),
  text("Закрой и снова открой апп — флаг подтянется из БД. В этом и разница: setState сбрасывается, setStorage остаётся."),
  sb(22),
  backButton,
]);

// ============================================================================
// SCREEN: /actions
// ============================================================================
const actions = scaffold([
  section("Обратная связь"),
  sb(10),
  card(
    col([
      btn("Показать тост", toast("Готово! 🥷"), "primary", true),
      sb(8),
      btn("Вибро (haptic)", multi([haptic("heavy"), toast("бзз")]), "secondary", true),
      sb(8),
      btn("Скопировать промокод", copy("NINJA-2026", "Промокод скопирован"), "outline", true),
    ]),
  ),
  sb(20),
  section("Диалоги и шторки"),
  sb(10),
  card(
    col([
      btn("Подтверждение", {
        actionType: "confirm",
        title: "Удалить запись?",
        message: "Это действие нельзя отменить",
        isDanger: true,
        confirmLabel: "Удалить",
        cancelLabel: "Отмена",
        onConfirm: toast("Удалено"),
        onCancel: toast("Отменено"),
      }, "danger", true),
      sb(8),
      btn("Открыть шторку", {
        actionType: "openSheet",
        title: "Детали пары",
        subtitle: "Высшая математика",
        child: col([
          listRow({ title: "Преподаватель", subtitle: "Иванов И. И.", emoji: "👤", isFirst: true }),
          listRow({ title: "Аудитория", subtitle: "А-401", emoji: "🚪" }),
          listRow({ title: "Время", subtitle: "10:40 – 12:10", emoji: "⏰" }),
          sb(12),
          btn("Закрыть", pop(), "primary", true),
        ]),
      }, "secondary", true),
    ]),
  ),
  sb(20),
  section("Поделиться и ссылки"),
  sb(10),
  card(
    col([
      btn("Поделиться аппом", share("Лови витрину мини-аппов Mirea Ninja"), "primary", true),
      sb(8),
      btn("Открыть mirea.ru", openUrl("https://www.mirea.ru"), "outline", true),
    ]),
  ),
  sb(20),
  backButton,
]);

// ============================================================================
// SCREEN: /navigation
// ============================================================================
const navigation = scaffold([
  section("Диплинки в приложение", "openDeepLink — экраны Mirea Ninja"),
  sb(10),
  card(
    col([
      listRow({ title: "Расписание", emoji: "📅", emojiColor: BLUE, isFirst: true, trailing: lineIcon("arrowRight", 20), onTap: deeplink("/schedule") }),
      listRow({ title: "Карта кампуса", emoji: "🗺️", emojiColor: GREEN, trailing: lineIcon("arrowRight", 20), onTap: deeplink("/services/map") }),
      listRow({ title: "Свободные аудитории", emoji: "🚪", emojiColor: ORANGE, trailing: lineIcon("arrowRight", 20), onTap: deeplink("/services/free-rooms") }),
      listRow({ title: "События", emoji: "🎉", emojiColor: PINK, trailing: lineIcon("arrowRight", 20), onTap: deeplink("/services/events") }),
    ]),
    { padding: 6 },
  ),
  sb(20),
  section("Другие мини-аппы", "openMiniApp — экосистема"),
  sb(10),
  card(
    col([
      listRow({ title: "Свободные аудитории", subtitle: "Открыть мини-апп", emoji: "🚪", emojiColor: GREEN, isFirst: true, trailing: lineIcon("chevronR", 20), onTap: openMini("free-rooms") }),
    ]),
    { padding: 6 },
  ),
  sb(20),
  section("Внутри аппа"),
  sb(10),
  card(
    col([
      btn("Открыть под-экран", openPage("/widgets", "Виджеты"), "primary", true),
      sb(8),
      btn("Перезагрузить апп", reload(), "outline", true),
    ]),
  ),
  sb(20),
  backButton,
]);

// ============================================================================
// SCREEN: /device (native device capabilities)
// ============================================================================
const capCard = (icon, color, title, children) =>
  card(
    col([
      roww([lineIcon(icon, 22, color), { type: "sizedBox", width: 10 }, text(title)], {
        crossAxisAlignment: "center",
      }),
      sb(10),
      ...children,
    ]),
  );
const expanded = (child) => ({ type: "expanded", child });

const device = scaffold([
  section("Возможности устройства", "Результат каждой попадает в state и виден сразу"),
  sb(10),
  {
    type: "appStateScope",
    initial: {},
    child: col([
      capCard("pin", BLUE, "Геолокация", [
        btn("Узнать координаты", getLocation("loc"), "primary", true),
        sb(8),
        pill("📍 {{state.locLat}}, {{state.locLng}}"),
      ]),
      sb(12),
      capCard("qr", ACCENT, "Фото с камеры или галереи", [
        roww([
          expanded(btn("Камера", pickImage("photo", "camera"), "primary", true)),
          { type: "sizedBox", width: 10 },
          expanded(btn("Галерея", pickImage("photo", "gallery"), "secondary", true)),
        ]),
        sb(10),
        { type: "image", src: "{{state.photo}}", height: 160 },
      ]),
      sb(12),
      capCard("qr", PINK, "Сканер QR/штрихкода", [
        btn("Сканировать", scanCode("code"), "primary", true),
        sb(8),
        pill("🔖 {{state.code}}"),
      ]),
      sb(12),
      capCard("bookmark", ORANGE, "Файл", [
        btn("Прикрепить файл", pickFile("doc"), "primary", true),
        sb(8),
        pill("📎 {{state.docName}}"),
      ]),
      sb(12),
      capCard("calendar", GREEN, "Событие в календарь", [
        btn(
          "Добавить экзамен",
          addCalendarEvent({
            title: "Экзамен по матанализу",
            start: "2026-06-22T10:00:00",
            end: "2026-06-22T12:00:00",
            location: "А-401",
            notes: "Добавлено из мини-аппа Mirea Ninja",
          }),
          "primary",
          true,
        ),
      ]),
      sb(12),
      capCard("shield", BLUE, "Биометрия", [
        btn("Подтвердить личность", authenticate("authOk", "Демо-проверка"), "primary", true),
        sb(8),
        pill("🔐 Подтверждено: {{state.authOk}}"),
      ]),
      sb(12),
      capCard("clock", CYAN, "Дата/время и напоминание", [
        btn("Выбрать момент", pickDateTime("when", "datetime"), "secondary", true),
        sb(8),
        pill("🕑 {{state.when}}"),
        sb(8),
        btn(
          "Запланировать напоминание",
          scheduleReminder({
            title: "Напоминание из мини-аппа",
            body: "Сработало! 🥷",
            when: "{{state.when}}",
            saveAs: "rid",
          }),
          "primary",
          true,
        ),
      ]),
      sb(12),
      capCard("bolt", ACCENT, "Буфер обмена", [
        roww([
          expanded(btn("Скопировать demo", copy("NINJA-2026", "Скопировано"), "outline", true)),
          { type: "sizedBox", width: 10 },
          expanded(btn("Прочитать", readClipboard("clip"), "secondary", true)),
        ]),
        sb(8),
        pill("📋 {{state.clip}}"),
      ]),
      sb(12),
      capCard("share", PINK, "Поделиться и вибро", [
        roww([
          expanded(btn("Поделиться", share("Витрина мини-аппов Mirea Ninja"), "outline", true)),
          { type: "sizedBox", width: 10 },
          expanded(btn("Вибро", haptic("heavy"), "secondary", true)),
        ]),
      ]),
    ]),
  },
  sb(20),
  backButton,
]);

// ============================================================================
// ============================================================================
// SCREEN: /logic (expressions + control flow)
// ============================================================================
const logic = scaffold([
  section("Выражения", "{{ }} умеет вычислять"),
  sb(10),
  {
    type: "appStateScope",
    initial: { score: 72 },
    child: col([
      card(
        col([
          roww([
            smart("🎯", "Баллы", "{{str(state.score)}}", ACCENT),
            { type: "spacer" },
            tag("{{state.score >= 80 ? 'допуск' : 'добрать'}}", "mute"),
          ], { crossAxisAlignment: "center" }),
          sb(12),
          text(
            "Статус: {{state.score >= 80 ? 'отлично' : (state.score >= 60 ? 'хорошо' : 'подтянись')}}",
          ),
          sb(12),
          roww([
            { type: "expanded", child: btn("−10", setStateA("score", { add: -10 }), "outline", true) },
            { type: "sizedBox", width: 10 },
            { type: "expanded", child: btn("+10", setStateA("score", { add: 10 }), "primary", true) },
          ]),
        ]),
      ),
      sb(12),
      appIf(
        "state.score >= 80",
        card(roww([lineIcon("check", 24, GREEN), { type: "sizedBox", width: 12 }, text("Допуск к экзамену открыт")], { crossAxisAlignment: "center" })),
        card(roww([lineIcon("info", 24, ORANGE), { type: "sizedBox", width: 12 }, text("Не хватает {{80 - state.score}} баллов")], { crossAxisAlignment: "center" })),
      ),
    ]),
  },
  sb(22),
  section("Списки", "appForEach по данным"),
  sb(10),
  {
    type: "appStateScope",
    initial: {
      lessons: [
        { name: "Матанализ", room: "А-300", kind: "лекция" },
        { name: "Программирование", room: "Б-105", kind: "практика" },
        { name: "Физика", room: "В-220", kind: "лаба" },
      ],
    },
    child: card(
      appForEach(
        "state.lessons",
        listRow({
          title: "{{item.name}}",
          subtitle: "{{index + 1}} пара · {{item.room}}",
          emoji: "📘",
          emojiColor: ACCENT,
          trailing: tag("{{item.kind}}", "mute"),
        }),
      ),
      { padding: 6 },
    ),
  },
  sb(22),
  section("Вкладки", "appSwitch по состоянию"),
  sb(10),
  {
    type: "appStateScope",
    initial: { tab: "today" },
    child: col([
      wrap([
        chip("Сегодня", setStateA("tab", { value: "today" }), { selected: "{{state.tab == 'today'}}", color: ACCENT }),
        chip("Неделя", setStateA("tab", { value: "week" }), { selected: "{{state.tab == 'week'}}", color: ACCENT }),
        chip("Сессия", setStateA("tab", { value: "exam" }), { selected: "{{state.tab == 'exam'}}", color: ACCENT }),
      ]),
      sb(12),
      appSwitch(
        "state.tab",
        [
          { when: "today", child: card(text("Сегодня: 3 пары, первая в 10:40")) },
          { when: "week", child: card(text("На неделе: 14 пар, 2 окна")) },
          { when: "exam", child: card(text("Сессия: 4 экзамена, ближайший — 24 июня")) },
        ],
        card(text("Выбери вкладку")),
      ),
    ]),
  },
  sb(22),
  section("Вычисление", "setState с выражением"),
  sb(10),
  {
    type: "appStateScope",
    initial: { price: 150, qty: 1, total: 150 },
    child: card(
      col([
        roww([
          smart("🪙", "Цена", "{{str(state.price)}} ₽", GREEN),
          { type: "spacer" },
          smart("🧮", "Итого", "{{str(state.total)}} ₽", ACCENT),
        ], { crossAxisAlignment: "center" }),
        sb(12),
        roww([
          { type: "expanded", child: btn("−", multi([setStateExpr("qty", "max(1, state.qty - 1)"), setStateExpr("total", "state.price * state.qty")]), "outline", true) },
          { type: "sizedBox", width: 12 },
          { type: "expanded", child: text("{{str(state.qty)}} шт") },
          { type: "sizedBox", width: 12 },
          { type: "expanded", child: btn("+", multi([setStateExpr("qty", "state.qty + 1"), setStateExpr("total", "state.price * state.qty")]), "primary", true) },
        ], { crossAxisAlignment: "center" }),
      ]),
    ),
  },
  sb(22),
  section("Без обёртки", "логика работает и в корне экрана"),
  sb(10),
  card(
    col([
      text("Этот счётчик не обёрнут в appStateScope — рантайм добавляет его сам."),
      sb(12),
      roww([
        smart("🔢", "Тапов", "{{str(state.taps ?? 0)}}", PINK),
        { type: "spacer" },
        iconBtn("plus", setStateA("taps", { add: 1 }), "secondary", "+1"),
      ], { crossAxisAlignment: "center" }),
    ]),
  ),
  sb(22),
  backButton,
]);

const screens = [
  { path: "/", title: "Витрина возможностей", json: home },
  { path: "/logic", title: "Логика и выражения", json: logic },
  { path: "/widgets", title: "Виджеты", json: widgets },
  { path: "/inputs", title: "Ввод и формы", json: inputs },
  { path: "/interactive", title: "Состояние", json: interactive },
  { path: "/actions", title: "Действия", json: actions },
  { path: "/navigation", title: "Навигация", json: navigation },
  { path: "/device", title: "Возможности устройства", json: device },
];

// Exported so tooling can read the authored screens (e.g. to emit a targeted
// live patch) without re-deriving the JSON.
export const showcaseScreens = screens;

const q = (s) => s.replaceAll("'", "''");
const name = "Витрина возможностей";
const description =
  "Демо мини-апп: все нативные виджеты и действия платформы — кнопки, " +
  "карточки, чипы, формы, состояние, хранилище, диплинки.";
const tags = "array['демо','виджеты','showcase','примеры']";
// The /device screen exercises scoped capabilities; declaring them lets the
// runner's in-app prompt grant them on first use (hosted apps skip the launch
// consent sheet, so without this the capability gates would refuse).
const perms = "array['location','camera','files','calendar']";

const values = screens
  .map((s) => `    (v_app, '${q(s.path)}', '${q(s.title)}', '${q(JSON.stringify(s.json))}'::jsonb)`)
  .join(",\n");

// Emit the seed SQL only when run directly; importing the module (to read
// `showcaseScreens`) must stay side-effect free.
const runDirectly = import.meta.url === pathToFileURL(process.argv[1]).href;
if (runDirectly)
  process.stdout.write(`-- Seed the "${name}" demo mini app (hosted, multi-screen).
-- Generated by scripts/build_showcase_seed.mjs — showcases every native
-- widget and platform action. Idempotent: re-running refreshes the screens.

do $$
declare
  v_app uuid;
begin
  if not exists (select 1 from core.organizations where id = 'mirea') then
    return;
  end if;

  insert into core.mini_apps (
    organization_id, owner_id, slug, name, description,
    icon_emoji, accent_color, category, tags, requested_permissions,
    source_kind, status, published_at
  )
  values (
    'mirea', null, 'showcase', '${q(name)}', '${q(description)}',
    '🎛️', '#1E4DFF', 'tools', ${tags}, ${perms},
    'hosted', 'published', now()
  )
  on conflict (organization_id, slug) do update set
    name = excluded.name,
    description = excluded.description,
    icon_emoji = excluded.icon_emoji,
    accent_color = excluded.accent_color,
    category = excluded.category,
    tags = excluded.tags,
    requested_permissions = excluded.requested_permissions,
    status = 'published',
    updated_at = now()
  returning id into v_app;

  delete from core.mini_app_screens where app_id = v_app;
  insert into core.mini_app_screens (app_id, path, title, json) values
${values};
end $$;
`);
