import { pathToFileURL } from "node:url";

const ACCENT = "accent";
const GREEN = "lecture";
const BLUE = "practice";
const ORANGE = "warn";
const PINK = "exam";
const VIOLET = "lab";

const sb = (height) => ({ type: "sizedBox", height });
const gap = (width) => ({ type: "sizedBox", width });
const col = (children, extra = {}) => ({
  type: "column",
  crossAxisAlignment: "stretch",
  ...extra,
  children,
});
const roww = (children, extra = {}) => ({
  type: "row",
  crossAxisAlignment: "center",
  ...extra,
  children,
});
const wrap = (children, spacing = 8, runSpacing = 8) => ({
  type: "wrap",
  spacing,
  runSpacing,
  crossAxisAlignment: "center",
  children,
});
const expanded = (child) => ({ type: "expanded", child });
const text = (data, extra = {}) => ({ type: "appText", data, ...extra });
const overline = (label) => ({
  type: "appOverline",
  label,
  topPadding: 18,
  bottomPadding: 8,
});
const card = (child, opts = {}) => ({ type: "appCard", child, ...opts });
const group = (children, opts = {}) => ({
  type: "appListGroup",
  children,
  ...opts,
});
const section = (title, subtitle, extra = {}) => ({
  type: "appSectionTitle",
  title,
  ...(subtitle ? { subtitle } : {}),
  ...extra,
});
const btn = (label, onPressed, opts = {}) => ({
  type: "appButton",
  label,
  ...(onPressed ? { onPressed } : {}),
  ...opts,
});
const iconBtn = (icon, onPressed, opts = {}) => ({
  type: "appIconButton",
  icon,
  ...(onPressed ? { onPressed } : {}),
  ...opts,
});
const chip = (label, opts = {}) => ({ type: "appChip", label, ...opts });
const tag = (label, tone, withDot = false) => ({
  type: "appTag",
  label,
  tone,
  withDot,
});
const badge = (label, tone, dot = false) => ({
  type: "appBadge",
  label,
  tone,
  dot,
});
const pill = (t, opts = {}) => ({ type: "appMetaPill", text: t, ...opts });
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
const ring = (value, label, sublabel, color) => ({
  type: "appProgressRing",
  value,
  size: 72,
  label,
  ...(sublabel ? { sublabel } : {}),
  ...(color ? { color } : {}),
});
const scope = (initial, child) => ({ type: "appStateScope", initial, child });
const scaffold = (children) => ({
  type: "scaffold",
  body: {
    type: "singleChildScrollView",
    padding: { left: 20, right: 20, top: 0, bottom: 28 },
    child: col(children),
  },
});

const toast = (message, type) => ({
  actionType: "showToast",
  message,
  ...(type ? { type } : {}),
});
const haptic = (style) => ({ actionType: "hapticFeedback", style });
const openPage = (path, title) => ({ actionType: "openPage", path, title });
const deeplink = (location) => ({ actionType: "openDeepLink", location });
const openMini = (slug, page) => ({
  actionType: "openMiniApp",
  slug,
  ...(page ? { page } : {}),
});
const setStateA = (key, patch) => ({ actionType: "setState", key, ...patch });
const setStateExpr = (key, expression) => ({
  actionType: "setState",
  key,
  expression,
});
const setStorageA = (key, value) => ({ actionType: "setStorage", key, value });
const multi = (actions) => ({ actionType: "multiAction", actions });
const reload = () => ({ actionType: "reload" });
const pop = () => ({ actionType: "pop" });
const share = (t) => ({ actionType: "share", text: t });
const copy = (t, m) => ({ actionType: "copyToClipboard", text: t, message: m });
const openUrl = (url) => ({ actionType: "openUrl", url });
const getLocation = (saveAs) => ({ actionType: "getLocation", saveAs });
const pickImage = (saveAs, source) => ({ actionType: "pickImage", saveAs, source });
const scanCode = (saveAs) => ({ actionType: "scanCode", saveAs });
const pickFile = (saveAs) => ({ actionType: "pickFile", saveAs });
const authenticate = (saveAs, reason) => ({ actionType: "authenticate", saveAs, reason });
const scheduleReminder = (o) => ({ actionType: "scheduleReminder", ...o });
const addCalendarEvent = (o) => ({ actionType: "addCalendarEvent", ...o });
const readClipboard = (saveAs) => ({ actionType: "readClipboard", saveAs });
const pickDateTime = (saveAs, mode) => ({ actionType: "pickDateTime", saveAs, mode });
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

const backButton = btn("Назад к разделам", pop(), {
  variant: "text",
  expanded: true,
  icon: "chevronL",
});

const groups = [
  { path: "/buttons", title: "Кнопки", subtitle: "Варианты, размеры, иконки, FAB", icon: "bolt", color: ACCENT, emoji: "🔘" },
  { path: "/inputs", title: "Ввод", subtitle: "Поля, поиск, валидация, состояния", icon: "pencil", color: BLUE, emoji: "✏️" },
  { path: "/selection", title: "Выбор", subtitle: "Селект, степпер, свитчи, чипы, вкладки", icon: "check", color: GREEN, emoji: "✅" },
  { path: "/feedback", title: "Обратная связь", subtitle: "Бейджи, баннеры, прогресс, скелетоны, тосты", icon: "bell", color: ORANGE, emoji: "🔔" },
  { path: "/surfaces", title: "Поверхности", subtitle: "Карточки, аватары, картинки, типографика", icon: "grid", color: VIOLET, emoji: "🧱" },
  { path: "/lists", title: "Списки", subtitle: "Строки, группы, свайпы, живой фильтр", icon: "clipboard", color: PINK, emoji: "📋" },
  { path: "/calendar", title: "Календарь", subtitle: "Неделя, пары, дедлайны, месяц", icon: "calendar", color: BLUE, emoji: "📅" },
  { path: "/logic", title: "Логика", subtitle: "Выражения, условия, списки, состояние", icon: "spark", color: GREEN, emoji: "🧠" },
  { path: "/actions", title: "Действия", subtitle: "Тосты, диалоги, шторки, шеринг", icon: "send", color: ACCENT, emoji: "✨" },
];
const platform = [
  { path: "/navigation", title: "Навигация", subtitle: "Диплинки в приложение и другие аппы", icon: "map", color: VIOLET, emoji: "🧭" },
  { path: "/device", title: "Устройство", subtitle: "Гео, фото, скан, файлы, календарь, биометрия", icon: "device", color: ORANGE, emoji: "📱" },
];

const indexRows = (items) =>
  group(
    items.map((g, i) =>
      listRow({
        title: g.title,
        subtitle: g.subtitle,
        icon: g.icon,
        iconColor: g.color,
        isFirst: i === 0,
        onTap: openPage(g.path, g.title),
      }),
    ),
  );

const home = scaffold([
  section("Витрина возможностей", "Каждый виджет — в стиле дизайн-системы", { topMargin: 0 }),
  card(
    col([
      roww([
        { type: "appIconTile", icon: "spark", color: ACCENT, size: 44, radius: 14 },
        gap(12),
        expanded(col([
          text("Мини-апп на Stac", { variant: "headlineStrong" }),
          sb(2),
          text("Экраны описаны в JSON, а рисуются нативными виджетами Mirea Ninja", { variant: "subtext", color: "muted" }),
        ])),
      ]),
      sb(14),
      wrap([
        tag("Stac BDUI", "accent"),
        tag("Live", "live", true),
        tag("Без сборки", "info"),
        badge("Kit", "ink"),
      ]),
      sb(14),
      roww([
        { type: "appAvatarStack", names: ["Иван", "Мария", "Олег", "Аня"], size: 30, extra: 12 },
        { type: "spacer" },
        smart("🧩", "виджетов", "50+", ACCENT),
      ]),
    ]),
  ),
  section("Разделы кита"),
  indexRows(groups),
  section("Платформа"),
  indexRows(platform),
  section("Сетка сервисов"),
  card(
    wrap(
      [
        tile("🔘", "Кнопки", ACCENT, openPage("/buttons", "Кнопки"), true),
        tile("✏️", "Ввод", BLUE, openPage("/inputs", "Ввод")),
        tile("✅", "Выбор", GREEN, openPage("/selection", "Выбор")),
        tile("🔔", "Фидбек", ORANGE, openPage("/feedback", "Обратная связь")),
        tile("🧱", "Слои", VIOLET, openPage("/surfaces", "Поверхности")),
        tile("📋", "Списки", PINK, openPage("/lists", "Списки")),
        tile("📅", "Календарь", BLUE, openPage("/calendar", "Календарь")),
        tile("🚪", "Аудитории", GREEN, openMini("free-rooms")),
      ],
      12,
      12,
    ),
  ),
  sb(20),
  btn("Открыть расписание", deeplink("/schedule"), { variant: "primary", expanded: true, icon: "calendar" }),
]);

const widgets = scaffold([
  section("Обзор", "Все разделы витрины", { topMargin: 0 }),
  indexRows([...groups, ...platform]),
  sb(20),
  backButton,
]);

const variantRow = (variant, label) =>
  roww([
    expanded(btn(label, toast(label), { variant, expanded: true, loading: "{{state.busy}}", enabled: "{{!state.off}}" })),
    gap(8),
    expanded(btn(label, toast(label), { variant, expanded: true, icon: "check", loading: "{{state.busy}}", enabled: "{{!state.off}}" })),
  ]);

const buttons = scaffold([
  section("Кнопки", "Переключи состояния и смотри, как меняются все кнопки", { topMargin: 0 }),
  scope(
    { busy: false, off: false },
    col([
      card(
        roww([
          expanded({ type: "appToggle", stateKey: "busy", label: "Загрузка" }),
          expanded({ type: "appToggle", stateKey: "off", label: "Выключено" }),
        ]),
      ),
      overline("Варианты"),
      card(
        col([
          variantRow("primary", "Primary"),
          sb(8),
          variantRow("secondary", "Secondary"),
          sb(8),
          variantRow("tonal", "Tonal"),
          sb(8),
          variantRow("text", "Text"),
          sb(8),
          variantRow("destructive", "Destructive"),
          sb(8),
          variantRow("destructiveOutline", "Outline"),
        ]),
      ),
    ]),
  ),
  overline("Размеры"),
  card(
    col([
      btn("Small · 44", toast("small"), { size: "small", expanded: true }),
      sb(8),
      btn("Medium · 48", toast("medium"), { size: "medium", expanded: true }),
      sb(8),
      btn("Large · 52", toast("large"), { size: "large", expanded: true }),
      sb(8),
      btn("Hero · 56", toast("hero"), { size: "hero", expanded: true, trailingIcon: "arrowRight" }),
    ]),
  ),
  overline("Иконки-кнопки"),
  card(
    col([
      wrap([
        iconBtn("heart", toast("Лайк"), { tone: "secondary", tooltip: "Лайк" }),
        iconBtn("share", share("Витрина мини-аппов Mirea Ninja"), { tone: "primary", tooltip: "Поделиться" }),
        iconBtn("bookmark", toast("В закладках"), { tone: "tonal", tooltip: "Закладка" }),
        iconBtn("qr", toast("QR"), { tone: "surface", tooltip: "QR" }),
        iconBtn("trash", toast("Удалено", "error"), { tone: "danger", tooltip: "Удалить" }),
        iconBtn("more", toast("Меню"), { tone: "plain", tooltip: "Ещё" }),
      ], 10, 10),
      sb(12),
      wrap([
        iconBtn("bell", toast("Уведомления"), { tone: "secondary", shape: "circle", dot: true, tooltip: "Уведомления" }),
        iconBtn("settings", toast("Компактная"), { tone: "secondary", size: "compact", tooltip: "Настройки" }),
        iconBtn("search", toast("Маленькая"), { tone: "secondary", size: "small", tooltip: "Поиск" }),
        iconBtn("lock", null, { tone: "secondary", enabled: false, tooltip: "Недоступно" }),
      ], 10, 10),
    ]),
  ),
  overline("FAB"),
  card(
    roww([
      { type: "appFab", icon: "plus", onPressed: toast("Создать"), tooltip: "Создать" },
      gap(12),
      { type: "appFab", icon: "pencil", label: "Написать", onPressed: toast("Написать") },
      { type: "spacer" },
      { type: "appFab", icon: "plus", enabled: false, tooltip: "Недоступно" },
    ]),
  ),
  overline("Встроенные кнопки Stac"),
  text("elevatedButton, outlinedButton, textButton и iconButton тоже рисуются китом", { variant: "subtext", color: "muted" }),
  sb(8),
  card(
    col([
      { type: "elevatedButton", child: { type: "text", data: "elevatedButton" }, onPressed: toast("elevated") },
      sb(8),
      { type: "outlinedButton", child: { type: "text", data: "outlinedButton" }, onPressed: toast("outlined") },
      sb(8),
      roww([
        { type: "textButton", child: { type: "text", data: "textButton" }, onPressed: toast("text") },
        { type: "spacer" },
        { type: "iconButton", icon: { type: "icon", icon: "share" }, tooltip: "share", onPressed: toast("iconButton") },
        { type: "floatingActionButton", buttonType: "extended", icon: { type: "icon", icon: "add" }, child: { type: "text", data: "FAB" }, onPressed: toast("fab") },
      ]),
    ]),
  ),
  sb(20),
  backButton,
]);

const inputs = scaffold([
  section("Ввод", "Поля во всех состояниях", { topMargin: 0 }),
  scope(
    { name: "", q: "" },
    col([
      card(
        col([
          { type: "appInputField", label: "Имя · default", placeholder: "Как к тебе обращаться", stateKey: "name" },
          sb(12),
          { type: "appInputField", label: "Почта · с иконкой", placeholder: "you@mirea.ru", leadingIcon: "mail", keyboardType: "email", helperText: "Университетская почта" },
          sb(12),
          { type: "appInputField", label: "Группа · success", initialValue: "ИКБО-01-24", success: true },
          sb(12),
          { type: "appInputField", label: "Телефон · error", initialValue: "+7 999", errorText: "Слишком короткий номер", keyboardType: "phone" },
          sb(12),
          { type: "appInputField", label: "Заблокировано · disabled", initialValue: "Нельзя менять", enabled: false },
          sb(12),
          { type: "appInputField", label: "Пароль", placeholder: "Минимум 8 символов", obscureText: true },
          sb(12),
          { type: "appInputField", label: "Заметка · multiline", placeholder: "Что запомнить", multiline: true, maxLength: 140 },
        ]),
      ),
      sb(8),
      appIf("len(state.name) > 0", card(roww([lineIcon("user", 20, ACCENT), gap(10), text("Привет, {{state.name}}!")]), { tinted: true })),
      overline("Поиск"),
      { type: "appSearchField", placeholder: "Поиск по всему приложению", stateKey: "q" },
      sb(8),
      appIf("len(state.q) > 0", text("Ищем: «{{state.q}}»", { variant: "subtext", color: "muted" })),
    ]),
  ),
  overline("Форма с валидацией"),
  card({
    type: "form",
    child: col([
      { type: "appInputField", id: "name", label: "Имя", placeholder: "Минимум 2 символа", minLength: 2, validationMessage: "Минимум 2 символа" },
      sb(12),
      { type: "appInputField", id: "email", label: "Почта", placeholder: "you@mirea.ru", email: true, validationMessage: "Неверный e-mail" },
      sb(12),
      { type: "appCheckbox", id: "agree", label: "Согласен с правилами" },
      sb(16),
      btn("Проверить", { actionType: "validateForm", isValid: multi([haptic("medium"), toast("Форма валидна", "success")]) }, { expanded: true }),
    ]),
  }),
  overline("Встроенные поля Stac"),
  card({
    type: "textFormField",
    id: "comment",
    decoration: { hintText: "Комментарий", labelText: "textFormField" },
    validatorRules: [{ rule: "isLength", options: { min: 3 }, message: "Минимум 3 символа" }],
  }),
  sb(20),
  backButton,
]);

const selection = scaffold([
  section("Выбор", "Каждый контрол пишет в состояние экрана", { topMargin: 0 }),
  scope(
    { period: "week", qty: 2, push: true, sound: false, agree: false, plan: "free", day: "mon", tab: 0, seg: 0 },
    col([
      overline("Селект и степпер"),
      card(
        col([
          { type: "appSelectField", label: "Период", stateKey: "period", options: [{ value: "day", label: "Сегодня" }, { value: "week", label: "Неделя" }, { value: "month", label: "Месяц" }] },
          sb(12),
          { type: "appSelectField", label: "Недоступно", placeholder: "Нельзя выбрать", enabled: false },
          sb(12),
          roww([
            expanded(text("Количество")),
            { type: "appStepper", stateKey: "qty", min: 1, max: 9 },
          ]),
          sb(6),
          text("Выбрано: {{state.period}} · {{str(state.qty)}} шт", { variant: "subtext", color: "muted" }),
        ]),
      ),
      overline("Переключатели"),
      group([
        listRow({ title: "Пуш-уведомления", subtitle: "Включены: {{state.push}}", icon: "bell", isFirst: true, showChevron: false, trailing: { type: "appToggle", stateKey: "push" } }),
        listRow({ title: "Звук", icon: "mic", showChevron: false, trailing: { type: "appSwitch", stateKey: "sound" } }),
        listRow({ title: "Недоступно", icon: "lock", showChevron: false, trailing: { type: "appToggle", value: true, enabled: false } }),
      ]),
      overline("Чекбоксы"),
      card(
        col([
          { type: "appCheckbox", stateKey: "agree", label: "Согласие · {{state.agree}}" },
          { type: "appCheckbox", value: true, label: "Отмечено" },
          { type: "appCheckbox", value: true, indeterminate: true, label: "Частично" },
          { type: "appCheckbox", value: false, enabled: false, label: "Недоступно" },
        ]),
      ),
      overline("Радио"),
      card(
        col([
          { type: "appRadio", stateKey: "plan", value: "free", label: "Бесплатный" },
          { type: "appRadio", stateKey: "plan", value: "pro", label: "Про" },
          { type: "appRadio", stateKey: "plan", value: "team", label: "Команда", enabled: false },
          sb(6),
          text("Тариф: {{state.plan}}", { variant: "subtext", color: "muted" }),
        ]),
      ),
      overline("Чипы"),
      card(
        col([
          wrap([
            chip("Все", { stateKey: "day", value: "all" }),
            chip("Сегодня", { stateKey: "day", value: "mon", count: 3 }),
            chip("Неделя", { stateKey: "day", value: "week", dot: true }),
            chip("Недоступно", { enabled: false }),
          ]),
          sb(10),
          wrap([
            chip("Матан", { style: "tinted", selected: true, color: BLUE, leadingIcon: "book" }),
            chip("Физика", { style: "tinted", color: GREEN, count: 2 }),
            chip("История", { style: "tinted", onRemove: toast("Удалено") }),
            chip("Недоступно", { style: "tinted", enabled: false }),
          ]),
        ]),
      ),
      sb(12),
      { type: "appChipRow", stateKey: "day", items: [{ value: "mon", label: "Пн", icon: "calendar" }, { value: "tue", label: "Вт" }, { value: "wed", label: "Ср", count: 4 }, { value: "thu", label: "Чт" }, { value: "fri", label: "Пт" }, { value: "sat", label: "Сб" }] },
      overline("Сегменты"),
      { type: "appSegmentedControl", stateKey: "seg", options: [
        { label: "Сегодня", child: card(roww([lineIcon("clock", 20, ACCENT), gap(10), text("3 пары, первая в 10:40")])) },
        { label: "Неделя", child: card(roww([lineIcon("calendar", 20, BLUE), gap(10), text("14 пар, 2 окна")])) },
        { label: "Сессия", child: card(roww([lineIcon("alert", 20, PINK), gap(10), text("4 экзамена")])) },
      ] },
      sb(10),
      { type: "appSegmentedControl", enabled: false, options: [{ label: "Недоступно" }, { label: "Пока" }] },
      overline("Вкладки"),
      card(
        { type: "appTabs", stateKey: "tab", tabs: [
          { label: "Все", count: 12, child: text("Все материалы курса") },
          { label: "Мои", count: 3, child: text("Только твои файлы") },
          { label: "Избранное", child: text("Пока ничего не отмечено") },
        ] },
        { padding: { left: 0, right: 0, top: 4, bottom: 16 } },
      ),
      overline("Встроенные контролы Stac"),
      card(
        col([
          roww([
            { type: "checkBox", value: true, onChanged: toast("checkBox") },
            gap(12),
            { type: "switch", value: true, onChanged: toast("switch") },
            gap(12),
            { type: "radioGroup", groupValue: "a", child: roww([{ type: "radio", value: "a", label: "A" }, gap(8), { type: "radio", value: "b", label: "B" }]) },
          ]),
        ]),
      ),
    ]),
  ),
  sb(20),
  backButton,
]);

const feedback = scaffold([
  section("Обратная связь", "Статусы, прогресс и сообщения", { topMargin: 0 }),
  overline("Бейджи и теги"),
  card(
    col([
      wrap([
        badge("Accent", "accent"),
        badge("Ink", "ink"),
        badge("Отменена", "exam", true),
        badge("Перенос", "warn", true),
        badge("Отмечен", "lecture", true),
        badge("Лаба", "lab"),
        badge("Практика", "practice"),
        badge("Neutral", "neutral"),
        { type: "appBadge", label: "С иконкой", tone: "accent", icon: "star" },
      ]),
      sb(12),
      wrap([
        { type: "appTypeTag", label: "ЛЕК", color: GREEN },
        { type: "appTypeTag", label: "ПРАК", color: BLUE },
        { type: "appTypeTag", label: "ЛАБ", color: VIOLET },
        { type: "appTypeTag", label: "ЭКЗ", color: PINK },
        { type: "appCountBadge", count: 3 },
        { type: "appCountBadge", count: 120 },
        { type: "appLiveBadge", label: "Сейчас" },
      ]),
      sb(12),
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
      wrap([
        { type: "appHashTag", label: "#матан", onTap: toast("#матан") },
        { type: "appHashTag", label: "#сессия", color: PINK },
        pill("А-401", { icon: "pin" }),
        pill("10:40", { strong: true, icon: "clock" }),
        pill("скоро"),
      ]),
    ]),
  ),
  overline("Баннеры"),
  { type: "appBanner", message: "Расписание обновлено", tone: "accent" },
  sb(8),
  { type: "appBanner", message: "Офлайн · показаны сохранённые данные", tone: "warn", actionLabel: "Обновить", onAction: reload() },
  sb(8),
  { type: "appBanner", message: "Пара отменена", tone: "danger" },
  sb(8),
  { type: "appBanner", message: "Отметка сохранена", tone: "success" },
  sb(8),
  { type: "appBanner", title: "Дедлайн завтра", message: "Лаба по физике до 23:59", tone: "danger", icon: "alert", actionLabel: "Открыть", onAction: toast("Дедлайн") },
  overline("Прогресс"),
  scope(
    { p: 0.4 },
    card(
      col([
        { type: "appProgressBar", value: "{{state.p}}" },
        sb(8),
        { type: "appProgressBar", value: 0.7, color: GREEN, height: 8 },
        sb(8),
        { type: "appProgressBar", indeterminate: true },
        sb(14),
        roww([
          expanded(btn("−10%", setStateExpr("p", "max(0, state.p - 0.1)"), { variant: "secondary", expanded: true })),
          gap(8),
          expanded(btn("+10%", setStateExpr("p", "min(1, state.p + 0.1)"), { variant: "primary", expanded: true })),
        ]),
        sb(16),
        roww([
          ring("{{state.p}}", "{{str(round(state.p * 100))}}%", "план", ACCENT),
          { type: "spacer" },
          ring(0.9, "9/10", "квесты", GREEN),
          { type: "spacer" },
          ring(0.35, "35%", "сон", ORANGE),
        ], { mainAxisAlignment: "spaceBetween" }),
        sb(16),
        roww([
          { type: "appSpinner" },
          gap(12),
          { type: "appSpinner", size: 20, color: GREEN },
          gap(12),
          text("appSpinner · только для коротких ожиданий", { variant: "subtext", color: "muted" }),
        ]),
      ]),
    ),
  ),
  overline("Загрузка · скелетоны"),
  scope(
    { loading: true },
    col([
      card(
        roww([
          expanded({ type: "appToggle", stateKey: "loading", label: "Показать скелетон" }),
        ]),
      ),
      sb(12),
      appIf(
        "state.loading",
        card(
          col([
            { type: "appSkeleton", variant: "bar", height: 18, widthFactor: 0.5 },
            sb(10),
            { type: "appSkeleton", variant: "bar", height: 12 },
            sb(6),
            { type: "appSkeleton", variant: "bar", height: 12, widthFactor: 0.7 },
            sb(14),
            roww([
              { type: "appSkeleton", variant: "avatar", size: 44 },
              gap(12),
              expanded({ type: "appSkeleton", variant: "tile", height: 44 }),
            ]),
            sb(14),
            { type: "appSkeleton", variant: "media", height: 120 },
            sb(10),
            { type: "appSkeleton", variant: "row" },
          ]),
        ),
        card(
          col([
            text("Матанализ", { variant: "headlineStrong" }),
            sb(4),
            text("Лекция · А-401 · 10:40 – 12:10", { variant: "subtext", color: "muted" }),
            sb(14),
            roww([
              { type: "appAvatar", name: "Иванов Иван", size: 44 },
              gap(12),
              expanded(text("Иванов И. И.")),
            ]),
            sb(14),
            { type: "appImage", src: "https://picsum.photos/seed/mirea-ninja/800/400", height: 120, radius: 16 },
          ]),
        ),
      ),
    ]),
  ),
  overline("Пусто и ошибки"),
  { type: "appEmptyState", emoji: "🍃", title: "Пока пусто", subtitle: "Здесь появится контент, когда ты что-нибудь добавишь", actionLabel: "Добавить", onAction: toast("Добавлено", "success") },
  sb(12),
  { type: "appEmptyState", icon: "inbox", title: "Нет входящих", subtitle: "Иконка вместо эмодзи" },
  sb(12),
  { type: "appErrorState", title: "Не загрузилось", message: "Проверь соединение и попробуй снова", primaryLabel: "Повторить", onPrimary: toast("Повтор"), secondaryLabel: "Открыть офлайн", onSecondary: toast("Офлайн") },
  sb(12),
  card(col([
    { type: "appEmptyState", compact: true, title: "Компактная заглушка", subtitle: "для секций внутри карточек" },
    { type: "appErrorState", compact: true, title: "Компактная ошибка", message: "без кнопок" },
  ])),
  overline("Подсказки"),
  card(
    roww([
      { type: "appTooltip", label: "Подсказка сверху", arrow: "down" },
      { type: "spacer" },
      { type: "appTooltip", message: "Долгое нажатие", child: iconBtn("info", null, { tone: "secondary", tooltip: "Инфо" }) },
    ]),
  ),
  overline("Тосты"),
  card(
    col([
      roww([
        expanded(btn("Инфо", toast("Просто сообщение"), { variant: "secondary", expanded: true })),
        gap(8),
        expanded(btn("Успех", toast("Сохранено", "success"), { variant: "primary", expanded: true })),
      ]),
      sb(8),
      roww([
        expanded(btn("Предупреждение", toast("Проверь данные", "warning"), { variant: "tonal", expanded: true })),
        gap(8),
        expanded(btn("Ошибка", toast("Не получилось", "error"), { variant: "destructive", expanded: true })),
      ]),
      sb(8),
      btn("С действием", { actionType: "showToast", message: "Запись удалена", actionLabel: "Вернуть", onAction: toast("Возвращено", "success") }, { variant: "secondary", expanded: true }),
    ]),
  ),
  overline("Встроенные индикаторы Stac"),
  card(
    roww([
      { type: "circularProgressIndicator" },
      gap(16),
      expanded({ type: "linearProgressIndicator", value: 0.6 }),
      gap(16),
      { type: "badge", count: 5, child: lineIcon("bell", 24) },
    ]),
  ),
  sb(20),
  backButton,
]);

const surfaces = scaffold([
  section("Поверхности", "Карточки, аватары, картинки и текст", { topMargin: 0 }),
  overline("Карточки"),
  card(text("Обычная карточка · surface, r24, padding 16")),
  sb(8),
  card(text("Тонированная · tinted"), { tinted: true }),
  sb(8),
  card(roww([lineIcon("arrowRight", 20, ACCENT), gap(10), expanded(text("Нажимаемая карточка"))]), { onTap: toast("Карточка"), radius: 18 }),
  sb(8),
  card(text("Плотная · padding 10"), { padding: 10, color: "surface2" }),
  overline("Иконки-плитки"),
  card(
    wrap([
      { type: "appIconTile", icon: "book", color: BLUE },
      { type: "appIconTile", icon: "flask", color: VIOLET, size: 44, radius: 14 },
      { type: "appIconTile", emoji: "🎓", color: GREEN, size: 48, radius: 16 },
      { type: "appIconTile", icon: "bolt" },
      lineIcon("star", 24, ORANGE),
      lineIcon("heart", 24, PINK),
      lineIcon("shield", 24, GREEN),
    ], 12, 12),
  ),
  overline("Аватары"),
  card(
    col([
      roww([
        { type: "appAvatar", name: "Иван Петров", size: 32 },
        gap(10),
        { type: "appAvatar", name: "Мария Кузнецова", size: 40, color: PINK },
        gap(10),
        { type: "appAvatar", name: "Олег Смирнов", size: 56, levelBadge: 12 },
        gap(10),
        { type: "appAvatar", name: "Аня Волкова", size: 56, online: true, color: GREEN },
        { type: "spacer" },
        { type: "appAvatar", name: "Фото", size: 56, imageUrl: "https://i.pravatar.cc/120?img=12" },
      ]),
      sb(14),
      { type: "appAvatarStack", names: ["Олег", "Аня", "Лев", "Ким", "Ро", "Ира"], size: 36, maxVisible: 4, extra: 8 },
    ]),
  ),
  overline("Картинки с заглушкой"),
  card(
    col([
      { type: "appImage", src: "https://picsum.photos/seed/rtu-mirea/800/400", aspectRatio: 2, radius: 18 },
      sb(10),
      roww([
        expanded({ type: "appImage", src: "broken-link", height: 90, radius: 14 }),
        gap(10),
        expanded({ type: "appImage", src: "https://picsum.photos/seed/lab/400/200", height: 90, radius: 14, fit: "cover" }),
      ]),
      sb(6),
      text("Пока картинка грузится или сломана — полосатая заглушка кита", { variant: "subtext", color: "muted" }),
    ]),
  ),
  overline("Сервис-плитки и смарт-чипы"),
  card(
    col([
      wrap([
        tile("🧮", "GPA", GREEN, toast("GPA"), true),
        tile("🍲", "Столовая", ORANGE, toast("Столовая")),
        { type: "appServiceTile", icon: "map", label: "Карта", color: BLUE, onTap: deeplink("/services/map") },
        { type: "appServiceTile", icon: "door", label: "Аудитории", color: PINK, solid: true, onTap: openMini("free-rooms") },
      ], 12, 12),
      sb(12),
      wrap([
        smart("🍲", "Столовая", "~8 мин", ORANGE),
        smart("📚", "Библиотека", "до 20:00", BLUE),
        { type: "appSmartChip", icon: "door", label: "Свободно", value: "144", tone: GREEN },
      ], 10, 10),
    ]),
  ),
  overline("Типографика"),
  card(
    col([
      text("Display 34", { variant: "display" }),
      text("Section 22", { variant: "section" }),
      text("Title 19", { variant: "pageTitle" }),
      text("Heading 16", { variant: "heading" }),
      text("Headline 15", { variant: "headline" }),
      text("Body 14 — основной текст интерфейса", { variant: "body" }),
      text("Body strong 14", { variant: "bodyStrong" }),
      text("Label 13", { variant: "label" }),
      text("Subtext 12.5 — второстепенное", { variant: "subtext", color: "muted" }),
      text("Caption 12", { variant: "caption" }),
      text("overline 11.5", { variant: "overline" }),
      text("Metric 19", { variant: "metric", color: ACCENT }),
      text("Code 22", { variant: "code" }),
      text("Выравнивание по центру и обрезка длинного текста в одну строку", { align: "center", maxLines: 1 }),
    ], { crossAxisAlignment: "start" }),
  ),
  sb(12),
  card(
    col([
      { type: "appExpandableText", text: "Мини-аппы — это экраны в JSON, которые рисуются нативными виджетами дизайн-системы Mirea Ninja. Тёмная и светлая темы, акцентный цвет и типографика подхватываются автоматически, а логика описывается выражениями прямо в JSON, без своего сервера. Этот текст свёрнут до трёх строк.", maxLines: 3, expandLabel: "Показать ещё", collapseLabel: "Свернуть" },
    ]),
  ),
  section("Заголовок секции", "с подзаголовком", { action: "Все", onActionTap: toast("Все") }),
  section("С метой", null, { meta: "12 шт", topMargin: 0 }),
  overline("Встроенные поверхности Stac"),
  { type: "card", child: { type: "listTile", title: { type: "text", data: "listTile" }, subtitle: { type: "text", data: "внутри card" }, leading: { type: "circleAvatar", child: { type: "text", data: "ЛТ" }, radius: 18 }, onTap: toast("listTile") } },
  sb(8),
  roww([
    { type: "chip", label: { type: "text", data: "chip" }, onDeleted: toast("Удалён") },
    gap(8),
    expanded({ type: "divider" }),
    gap(8),
    { type: "tooltip", message: "tooltip", child: lineIcon("info", 22, "muted") },
  ]),
  sb(20),
  backButton,
]);

const lists = scaffold([
  section("Списки", "Строки списка во всех вариантах", { topMargin: 0 }),
  group([
    listRow({ title: "Простая строка", isFirst: true, onTap: toast("Строка") }),
    listRow({ title: "С подзаголовком", subtitle: "и мета-текстом справа", meta: "10:40", onTap: toast("Мета") }),
    listRow({ title: "С эмодзи", subtitle: "ауд. А-401 · 10:40", emoji: "📐", emojiColor: BLUE, onTap: toast("Эмодзи") }),
    listRow({ title: "С иконкой кита", subtitle: "цвет из токенов", icon: "flask", iconColor: VIOLET, onTap: toast("Иконка") }),
    listRow({ title: "Жирная", strong: true, trailing: badge("Новое", "accent"), showChevron: false }),
    listRow({ title: "С тегом", trailing: tag("Live", "live", true), showChevron: false }),
    listRow({ title: "С переключателем", icon: "bell", showChevron: false, trailing: { type: "appToggle", value: true, onChange: toast("Переключено") } }),
    listRow({ title: "Плотная · dense", dense: true, onTap: toast("Dense") }),
    listRow({ title: "Свайпни влево, чтобы удалить", icon: "trash", iconColor: PINK, showChevron: false, onDelete: toast("Удалено", "error") }),
    listRow({ title: "Удалить аккаунт", destructive: true, icon: "logout", iconColor: PINK, showChevron: false, onTap: toast("Опасное действие", "warning") }),
  ]),
  overline("Разделители"),
  card(
    col([
      text("Полный"),
      sb(8),
      { type: "appDivider" },
      sb(8),
      text("С отступом 16"),
      sb(8),
      { type: "appDivider", inset: true },
      sb(8),
      roww([expanded(text("Вертикальный")), { type: "appDivider", vertical: true, height: 24 }, expanded(text("справа", { align: "end" }))]),
    ]),
  ),
  overline("Живой фильтр"),
  scope(
    {
      q: "",
      items: [
        { name: "Матанализ", room: "А-300", kind: "лекция", tone: GREEN },
        { name: "Программирование", room: "Б-105", kind: "практика", tone: BLUE },
        { name: "Физика", room: "В-220", kind: "лаба", tone: VIOLET },
        { name: "История", room: "А-118", kind: "лекция", tone: GREEN },
        { name: "Английский", room: "Б-410", kind: "практика", tone: BLUE },
      ],
    },
    col([
      { type: "appSearchField", placeholder: "Предмет или аудитория", stateKey: "q" },
      sb(12),
      group([
        appForEach(
          "state.items",
          appIf(
            "len(state.q) == 0 || contains(lower(item.name), lower(state.q)) || contains(lower(item.room), lower(state.q))",
            listRow({
              title: "{{item.name}}",
              subtitle: "{{index + 1}} пара · {{item.room}}",
              emoji: "📘",
              emojiColor: "{{item.tone}}",
              trailing: tag("{{item.kind}}", "mute"),
              onTap: toast("{{item.name}}"),
            }),
          ),
        ),
      ]),
      sb(8),
      appIf(
        "len(state.q) > 0",
        text("Совпадений по «{{state.q}}» — считает движок выражений", { variant: "subtext", color: "muted" }),
      ),
    ]),
  ),
  overline("Пустой список"),
  group([{ type: "appEmptyState", compact: true, title: "Пока ничего нет", subtitle: "добавь первую запись" }]),
  overline("Встроенный listTile Stac"),
  group([
    { type: "listTile", title: { type: "text", data: "Физика" }, subtitle: { type: "text", data: "Б-215 · 12:20" }, trailing: { type: "icon", icon: "chevron_right" }, onTap: toast("listTile") },
  ]),
  sb(20),
  backButton,
]);

const calendar = scaffold([
  section("Календарь", "Неделя, пары, дедлайны и месяц", { topMargin: 0 }),
  scope(
    { day: 2, date: "", done1: false, done2: true },
    col([
      { type: "appWeekStrip", stateKey: "day", days: [
        { label: "31", short: "пн", past: true, dots: [GREEN] },
        { label: "1", short: "вт", past: true, dots: [BLUE, VIOLET] },
        { label: "2", short: "ср", today: true, dots: [GREEN, BLUE] },
        { label: "3", short: "чт", dots: [PINK] },
        { label: "4", short: "пт" },
        { label: "5", short: "сб", weekend: true },
        { label: "6", short: "вс", weekend: true },
      ] },
      sb(12),
      appSwitch(
        "state.day",
        [
          { when: 2, child: col([
            { type: "appLessonRow", title: "Матанализ", time: "9:00", endTime: "10:30", meta: "А-300 · Иванов И. И.", color: GREEN, typeLabel: "ЛЕК", state: "past" },
            sb(8),
            { type: "appLessonRow", title: "Программирование", time: "10:40", endTime: "12:10", meta: "Б-105 · Петров П. П.", color: BLUE, typeLabel: "ПРАК", state: "current", progress: 0.45, stateLabel: "идёт", onTap: toast("Сейчас") },
            sb(8),
            { type: "appLessonRow", title: "Физика", time: "12:40", endTime: "14:10", meta: "В-220", color: VIOLET, typeLabel: "ЛАБ", state: "next", chipLabel: "через 30 мин" },
            sb(8),
            { type: "appLessonRow", title: "История", time: "14:20", endTime: "15:50", meta: "А-118 → Б-201", color: GREEN, typeLabel: "ЛЕК", state: "moved", chipLabel: "перенос" },
          ]) },
          { when: 3, child: col([
            { type: "appLessonRow", title: "Английский", time: "10:40", endTime: "12:10", meta: "Б-410", color: BLUE, typeLabel: "ПРАК", state: "cancelled" },
            sb(8),
            { type: "appLessonRow", title: "Матанализ · экзамен", time: "13:00", endTime: "16:00", meta: "А-300", color: PINK, typeLabel: "ЭКЗ", state: "exam", actions: [{ label: "В календарь", onPressed: toast("Добавлено", "success") }, { label: "Подробнее", primary: false, onPressed: toast("Экзамен") }] },
          ]) },
          { when: 4, child: col([
            { type: "appLessonRow", title: "Своя запись", time: "18:00", endTime: "19:30", meta: "Спортзал", color: "ink", state: "own", onMore: toast("Меню записи") },
          ]) },
        ],
        { type: "appEmptyState", emoji: "🎉", title: "Пар нет", subtitle: "Выходной или прошедший день" },
      ),
      overline("Дедлайны"),
      group([
        { type: "appDeadlineRow", title: "Лаба 3 по физике", meta: "Физика · до 23:59", left: "сегодня", urgent: true, stateKey: "done1", onTap: toast("Дедлайн") },
        { type: "appDeadlineRow", title: "Эссе по истории", meta: "История · 12 сентября", left: "3 дня", stateKey: "done2" },
        { type: "appDeadlineRow", title: "Курсовая · план", meta: "Программирование", left: "2 нед", enabled: false },
      ]),
      overline("Месяц"),
      { type: "appCalendarMonth", month: "2026-09", stateKey: "date", marks: { "2026-09-03": [GREEN, BLUE], "2026-09-08": [PINK], "2026-09-15": [VIOLET], "2026-09-24": [ORANGE] } },
      sb(8),
      appIf("len(state.date) > 0", text("Выбрано: {{state.date}}", { variant: "subtext", color: "muted" }), text("Выбери день", { variant: "subtext", color: "muted" })),
    ]),
  ),
  sb(20),
  backButton,
]);

const logic = scaffold([
  section("Логика", "Выражения, условия, списки и состояние", { topMargin: 0 }),
  overline("Выражения"),
  scope(
    { score: 72 },
    col([
      card(
        col([
          roww([
            smart("🎯", "Баллы", "{{str(state.score)}}", ACCENT),
            { type: "spacer" },
            badge("{{state.score >= 80 ? 'допуск' : 'добрать'}}", "{{state.score >= 80 ? 'lecture' : 'warn'}}", true),
          ]),
          sb(12),
          { type: "appProgressBar", value: "{{state.score / 100}}", color: "{{state.score >= 80 ? 'lecture' : 'warn'}}" },
          sb(12),
          text("Статус: {{state.score >= 80 ? 'отлично' : (state.score >= 60 ? 'хорошо' : 'подтянись')}}"),
          sb(12),
          roww([
            expanded(btn("−10", setStateA("score", { add: -10 }), { variant: "secondary", expanded: true })),
            gap(10),
            expanded(btn("+10", setStateA("score", { add: 10 }), { variant: "primary", expanded: true })),
          ]),
        ]),
      ),
      sb(12),
      appIf(
        "state.score >= 80",
        { type: "appBanner", message: "Допуск к экзамену открыт", tone: "success" },
        { type: "appBanner", message: "Не хватает {{80 - state.score}} баллов", tone: "warn" },
      ),
    ]),
  ),
  overline("Список · appForEach"),
  scope(
    { lessons: [{ name: "Матанализ", room: "А-300", kind: "лекция" }, { name: "Программирование", room: "Б-105", kind: "практика" }, { name: "Физика", room: "В-220", kind: "лаба" }] },
    group([
      appForEach("state.lessons", listRow({ title: "{{item.name}}", subtitle: "{{index + 1}} пара · {{item.room}}", emoji: "📘", emojiColor: ACCENT, isFirst: "{{index == 0}}", trailing: tag("{{item.kind}}", "mute") })),
    ]),
  ),
  overline("Ветвление · appSwitch"),
  scope(
    { tab: "today" },
    col([
      { type: "appChipRow", stateKey: "tab", items: [{ value: "today", label: "Сегодня" }, { value: "week", label: "Неделя" }, { value: "exam", label: "Сессия" }] },
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
  ),
  overline("Вычисление · setState с выражением"),
  scope(
    { price: 150, qty: 1 },
    card(
      col([
        roww([
          smart("🪙", "Цена", "{{str(state.price)}} ₽", GREEN),
          { type: "spacer" },
          smart("🧮", "Итого", "{{str(state.price * state.qty)}} ₽", ACCENT),
        ]),
        sb(12),
        roww([
          expanded(text("Количество")),
          { type: "appStepper", stateKey: "qty", min: 1, max: 20 },
        ]),
        sb(12),
        btn("Сбросить", setStateExpr("qty", "1"), { variant: "text", expanded: true }),
      ]),
    ),
  ),
  overline("Хранилище · setStorage"),
  scope(
    { r: 0 },
    {
      type: "conditional",
      condition: "{{storage.demoFav}} == true",
      ifTrue: card(
        col([
          roww([lineIcon("star", 24, ORANGE), gap(12), expanded(text("В базе: в избранном"))]),
          sb(14),
          btn("Убрать из избранного", multi([setStorageA("demoFav", false), setStateA("r", { add: 1 }), toast("Обновлено в БД", "success")]), { variant: "secondary", expanded: true }),
        ]),
        { tinted: true },
      ),
      ifFalse: card(
        col([
          roww([lineIcon("star", 24, "muted2"), gap(12), expanded(text("В базе: пусто"))]),
          sb(14),
          btn("Добавить в избранное", multi([setStorageA("demoFav", true), setStateA("r", { add: 1 }), toast("Записано в БД", "success")]), { variant: "primary", expanded: true }),
        ]),
      ),
    },
  ),
  sb(8),
  text("setState живёт в памяти экрана, setStorage переживает перезапуск — закрой апп и открой снова.", { variant: "subtext", color: "muted" }),
  overline("Без обёртки"),
  card(
    roww([
      smart("🔢", "Тапов", "{{str(state.taps ?? 0)}}", PINK),
      { type: "spacer" },
      iconBtn("plus", setStateA("taps", { add: 1 }), { tone: "primary", tooltip: "+1" }),
    ]),
  ),
  sb(20),
  backButton,
]);

const actions = scaffold([
  section("Действия", "Всё, что можно повесить на кнопку", { topMargin: 0 }),
  overline("Обратная связь"),
  card(
    col([
      btn("Тост", toast("Готово! 🥷", "success"), { variant: "primary", expanded: true }),
      sb(8),
      btn("Вибро", multi([haptic("heavy"), toast("бзз")]), { variant: "secondary", expanded: true }),
      sb(8),
      btn("Скопировать промокод", copy("NINJA-2026", "Промокод скопирован"), { variant: "tonal", expanded: true, icon: "copy" }),
    ]),
  ),
  overline("Диалоги и шторки"),
  card(
    col([
      btn("Подтверждение", { actionType: "confirm", title: "Удалить запись?", message: "Это действие нельзя отменить", isDanger: true, confirmLabel: "Удалить", cancelLabel: "Отмена", onConfirm: toast("Удалено", "error"), onCancel: toast("Отменено") }, { variant: "destructive", expanded: true }),
      sb(8),
      btn("Шторка", { actionType: "openSheet", title: "Детали пары", subtitle: "Высшая математика", child: col([
        group([
          listRow({ title: "Преподаватель", subtitle: "Иванов И. И.", icon: "user", isFirst: true, showChevron: false }),
          listRow({ title: "Аудитория", subtitle: "А-401", icon: "door", showChevron: false }),
          listRow({ title: "Время", subtitle: "10:40 – 12:10", icon: "clock", showChevron: false }),
        ]),
        sb(16),
        btn("Закрыть", pop(), { variant: "primary", expanded: true }),
      ]) }, { variant: "secondary", expanded: true }),
      sb(8),
      btn("showDialog · alertDialog", { actionType: "showDialog", widget: { type: "alertDialog", title: { type: "text", data: "Встроенный диалог" }, content: { type: "text", data: "Stac alertDialog рисуется китом" }, actions: [
        { type: "textButton", child: { type: "text", data: "Отмена" }, onPressed: pop() },
        { type: "textButton", child: { type: "text", data: "Ок" }, onPressed: multi([pop(), toast("Ок")]) },
      ] } }, { variant: "secondary", expanded: true }),
      sb(8),
      btn("showModalBottomSheet", { actionType: "showModalBottomSheet", widget: col([text("Встроенная шторка Stac", { variant: "headlineStrong" }), sb(8), text("Открыта через showModalBottomSheet, но выглядит как AppSheet"), sb(16), btn("Закрыть", pop(), { expanded: true })]) }, { variant: "secondary", expanded: true }),
      sb(8),
      btn("showSnackBar", { actionType: "showSnackBar", content: { type: "text", data: "Снэкбар стал тостом" }, action: { label: "Ок", onPressed: toast("Ок") } }, { variant: "text", expanded: true }),
    ]),
  ),
  overline("Поделиться и ссылки"),
  card(
    col([
      btn("Поделиться аппом", share("Лови витрину мини-аппов Mirea Ninja"), { variant: "primary", expanded: true, icon: "share" }),
      sb(8),
      btn("Открыть mirea.ru", openUrl("https://www.mirea.ru"), { variant: "secondary", expanded: true, icon: "external" }),
      sb(8),
      btn("Перезагрузить апп", reload(), { variant: "text", expanded: true, icon: "refresh" }),
    ]),
  ),
  sb(20),
  backButton,
]);

const navigation = scaffold([
  section("Навигация", "openDeepLink — экраны Mirea Ninja", { topMargin: 0 }),
  group([
    listRow({ title: "Расписание", icon: "calendar", iconColor: BLUE, isFirst: true, onTap: deeplink("/schedule") }),
    listRow({ title: "Карта кампуса", icon: "map", iconColor: GREEN, onTap: deeplink("/services/map") }),
    listRow({ title: "Свободные аудитории", icon: "door", iconColor: ORANGE, onTap: deeplink("/services/free-rooms") }),
    listRow({ title: "События", icon: "star", iconColor: PINK, onTap: deeplink("/services/events") }),
  ]),
  overline("Другие мини-аппы"),
  group([
    listRow({ title: "Свободные аудитории", subtitle: "openMiniApp — открыть другой апп", emoji: "🚪", emojiColor: GREEN, isFirst: true, onTap: openMini("free-rooms") }),
  ]),
  overline("Внутри аппа"),
  card(
    col([
      btn("Открыть под-экран", openPage("/buttons", "Кнопки"), { variant: "primary", expanded: true }),
      sb(8),
      btn("Перезагрузить апп", reload(), { variant: "secondary", expanded: true }),
    ]),
  ),
  sb(20),
  backButton,
]);

const capCard = (icon, color, title, children) =>
  card(col([roww([{ type: "appIconTile", icon, color }, gap(10), expanded(text(title, { variant: "headline" }))]), sb(12), ...children]));

const device = scaffold([
  section("Устройство", "Результат каждой возможности попадает в state", { topMargin: 0 }),
  scope(
    {},
    col([
      capCard("pin", BLUE, "Геолокация", [
        btn("Узнать координаты", getLocation("loc"), { expanded: true }),
        sb(8),
        pill("{{state.locLat}}, {{state.locLng}}", { icon: "pin" }),
      ]),
      sb(12),
      capCard("camera", ACCENT, "Фото с камеры или галереи", [
        roww([
          expanded(btn("Камера", pickImage("photo", "camera"), { expanded: true })),
          gap(10),
          expanded(btn("Галерея", pickImage("photo", "gallery"), { variant: "secondary", expanded: true })),
        ]),
        sb(10),
        { type: "appImage", src: "{{state.photo}}", height: 160, radius: 16 },
      ]),
      sb(12),
      capCard("qr", PINK, "Сканер QR/штрихкода", [
        btn("Сканировать", scanCode("code"), { expanded: true }),
        sb(8),
        pill("{{state.code}}", { icon: "qr" }),
      ]),
      sb(12),
      capCard("folder", ORANGE, "Файл", [
        btn("Прикрепить файл", pickFile("doc"), { expanded: true }),
        sb(8),
        pill("{{state.docName}}", { icon: "clipboard" }),
      ]),
      sb(12),
      capCard("calendar", GREEN, "Событие в календарь", [
        btn("Добавить экзамен", addCalendarEvent({ title: "Экзамен по матанализу", start: "2026-12-22T10:00:00", end: "2026-12-22T12:00:00", location: "А-401", notes: "Добавлено из мини-аппа Mirea Ninja" }), { expanded: true }),
      ]),
      sb(12),
      capCard("fingerprint", BLUE, "Биометрия", [
        btn("Подтвердить личность", authenticate("authOk", "Демо-проверка"), { expanded: true }),
        sb(8),
        pill("Подтверждено: {{state.authOk}}", { icon: "shield" }),
      ]),
      sb(12),
      capCard("clock", VIOLET, "Дата/время и напоминание", [
        btn("Выбрать момент", pickDateTime("when", "datetime"), { variant: "secondary", expanded: true }),
        sb(8),
        pill("{{state.when}}", { icon: "clock" }),
        sb(8),
        btn("Запланировать напоминание", scheduleReminder({ title: "Напоминание из мини-аппа", body: "Сработало! 🥷", when: "{{state.when}}", saveAs: "rid" }), { expanded: true }),
      ]),
      sb(12),
      capCard("clipboard", ACCENT, "Буфер обмена", [
        roww([
          expanded(btn("Скопировать", copy("NINJA-2026", "Скопировано"), { variant: "secondary", expanded: true })),
          gap(10),
          expanded(btn("Прочитать", readClipboard("clip"), { variant: "tonal", expanded: true })),
        ]),
        sb(8),
        pill("{{state.clip}}", { icon: "clipboard" }),
      ]),
    ]),
  ),
  sb(20),
  backButton,
]);

const screens = [
  { path: "/", title: "Витрина возможностей", json: home },
  { path: "/widgets", title: "Обзор", json: widgets },
  { path: "/buttons", title: "Кнопки", json: buttons },
  { path: "/inputs", title: "Ввод", json: inputs },
  { path: "/selection", title: "Выбор", json: selection },
  { path: "/feedback", title: "Обратная связь", json: feedback },
  { path: "/surfaces", title: "Поверхности", json: surfaces },
  { path: "/lists", title: "Списки", json: lists },
  { path: "/calendar", title: "Календарь", json: calendar },
  { path: "/logic", title: "Логика", json: logic },
  { path: "/actions", title: "Действия", json: actions },
  { path: "/navigation", title: "Навигация", json: navigation },
  { path: "/device", title: "Устройство", json: device },
];

export const showcaseScreens = screens;

export const kitWidgetTypes = [
  "appAvatar", "appAvatarStack", "appBadge", "appBanner", "appButton",
  "appCalendarMonth", "appCard", "appCheckbox", "appChip", "appChipRow",
  "appCountBadge", "appDeadlineRow", "appDivider", "appEmptyState",
  "appErrorState", "appExpandableText", "appFab", "appHashTag",
  "appIconButton", "appIconTile", "appImage", "appInputField", "appLessonRow",
  "appLineIcon", "appListGroup", "appListRow", "appLiveBadge", "appMetaPill",
  "appOverline", "appProgressBar", "appProgressRing", "appRadio",
  "appSearchField", "appSectionTitle", "appSegmentedControl", "appSelectField",
  "appServiceTile", "appSkeleton", "appSmartChip", "appSpinner", "appStateScope",
  "appStepper", "appSwitch", "appTabs", "appTag", "appText", "appToggle",
  "appTooltip", "appTypeTag", "appWeekStrip", "appIf", "appForEach", "appSwitch",
];

const q = (s) => s.replaceAll("'", "''");
const name = "Витрина возможностей";
const description =
  "Демо мини-апп в стиле дизайн-системы: кнопки, ввод, выбор, обратная связь, " +
  "поверхности, списки, календарь, логика и действия платформы.";
const tags = "array['демо','виджеты','showcase','примеры','ui kit']";
const perms = "array['location','camera','files','calendar']";

const values = screens
  .map((s) => `    (v_app, '${q(s.path)}', '${q(s.title)}', '${q(JSON.stringify(s.json))}'::jsonb)`)
  .join(",\n");

const knownTypes = kitWidgetTypes
  .filter((type, index, list) => list.indexOf(type) === index)
  .map((type) => `  ('widget', '${type}')`)
  .join(",\n");

const runDirectly = import.meta.url === pathToFileURL(process.argv[1]).href;
if (runDirectly)
  process.stdout.write(`insert into core.mini_app_known_types (kind, name) values
${knownTypes}
on conflict do nothing;

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
    '🎛️', '#8064FF', 'tools', ${tags}, ${perms},
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
