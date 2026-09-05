# Виджеты

Экран — это дерево виджетов в JSON. Поле `type` выбирает виджет, остальные
поля — его параметры. Доступны все стандартные виджеты Stac и нативные
виджеты дизайн-системы Mirea Ninja (`app*`).

Неизвестный `type` не роняет экран — он просто не рисуется. Перед отправкой
жми «Предпросмотр» в форме публикации: дерево отрисуется тут же. При деплое
через [HTTP API](/reference/http-api) сервер дополнительно вернёт список
незнакомых `type`/`actionType` — опечатки видно сразу.

## Виджеты дизайн-системы

Эти виджеты наследуют тему, типографику и токены приложения: тёмная и
светлая темы подхватываются сами, апп выглядит как остальной интерфейс
Mirea Ninja.

### appButton

```json
{
  "type": "appButton",
  "label": "Записаться",
  "variant": "primary",
  "size": "medium",
  "expanded": true,
  "onPressed": { "actionType": "showToast", "message": "Готово!" }
}
```

- `variant`: `primary` | `secondary` | `outline` | `ghost` | `danger`
- `size`: `small` | `medium` | `large`
- `expanded`: растянуть на всю ширину

### appCard

Плоская карточка-поверхность со скруглением, опционально кликабельная.

```json
{
  "type": "appCard",
  "padding": 16,
  "onTap": { "actionType": "openPage", "path": "/details" },
  "child": { "type": "text", "data": "Содержимое карточки" }
}
```

### appChip

Чип-фильтр в форме пилюли.

```json
{ "type": "appChip", "label": "Все", "selected": true,
  "small": false, "color": "#7C5CFF", "onTap": { "actionType": "..." } }
```

### appListRow

Строка списка: эмодзи-аватар, заголовок, сабтайтл и trailing-виджет.
Складывай в `appCard` или `column`; у первой строки ставь `isFirst: true`,
чтобы убрать верхний разделитель.

```json
{
  "type": "appListRow",
  "title": "Физика",
  "subtitle": "ауд. А-401 · 10:40",
  "emoji": "📚",
  "emojiColor": "#2F7AFF",
  "isFirst": true,
  "trailing": { "type": "appMetaPill", "text": "скоро" },
  "onTap": { "actionType": "..." }
}
```

### appServiceTile

Квадратная плитка-лаунчер 56×56 с эмодзи. `solid: true` — заливка цветом,
`false` — тонировка. Раскладывай в `wrap` или `row` как сетку сервисов.

```json
{ "type": "appServiceTile", "emoji": "🧮", "label": "GPA",
  "color": "#1FB872", "solid": true,
  "onTap": { "actionType": "openPage", "path": "/calc" } }
```

### appMetaPill

Мета-пилюля для аудитории, времени, статуса.

```json
{ "type": "appMetaPill", "text": "А-401", "strong": true }
```

### appSmartChip

Чип «эмодзи + подпись + цветное значение» — компактная сводка (время в
пути, остаток, счёт).

```json
{ "type": "appSmartChip", "emoji": "🍲", "label": "Столовая",
  "value": "~8 мин", "tone": "#FFB020" }
```

- `tone` (`#RRGGBB`) красит значение; по умолчанию — акцент.

### appSectionTitle

Заголовок секции с опциональной ссылкой-действием справа.

```json
{
  "type": "appSectionTitle",
  "title": "Топ недели",
  "subtitle": "по числу запусков",
  "action": "Все",
  "onActionTap": { "actionType": "openPage", "path": "/top" }
}
```

### appEmptyState

Заглушка «пусто»: крупное эмодзи, заголовок, описание и вложенный виджет
(например, кнопка).

```json
{
  "type": "appEmptyState",
  "emoji": "🌴",
  "title": "Пока пусто",
  "subtitle": "Добавь первую запись",
  "child": { "type": "appButton", "label": "Добавить" }
}
```

### appErrorState

```json
{ "type": "appErrorState", "title": "Не загрузилось",
  "message": "Попробуй ещё раз", "primaryLabel": "Повторить",
  "onPrimary": { "actionType": "reload" } }
```

### appLineIcon и appIconButton

Фирменный набор линейных иконок по имени из дизайн-системы:
`user, lock, search, home, calendar, map, grid, bell, settings,
chevronR/L/D, plus, minus, filter, more, book, pin, heart, star, message,
share, clock, check, shield, people, bolt, qr, mic, pencil, view, hide,
close, mail, arrowRight` и другие.

```json
{ "type": "appLineIcon", "icon": "star", "size": 22, "color": "#FBBF24" }
```

```json
{ "type": "appIconButton", "icon": "share",
  "variant": "secondary", "tooltip": "Поделиться",
  "onPressed": { "actionType": "share", "text": "..." } }
```

### appTag и appLiveBadge

```json
{ "type": "appTag", "label": "Live", "tone": "live", "withDot": true }
```

Тоны: `accent` | `live` | `warn` | `danger` | `info` | `pink` | `mute` | `solid`.

```json
{ "type": "appLiveBadge", "label": "Сейчас" }
```

### appAvatar и appAvatarStack

```json
{ "type": "appAvatar", "name": "Иван Петров", "size": 36 }
```

```json
{ "type": "appAvatarStack", "names": ["Иван", "Мария", "Олег"], "size": 32 }
```

### appProgressRing

```json
{ "type": "appProgressRing", "value": 0.72, "size": 64,
  "label": "72%", "sublabel": "готово", "color": "#34D399" }
```

### appToggle

Плоский переключатель-пилюля. По сути серверный: на `onChange` пошли
экшен, который вернёт дерево с уже перевёрнутым `value` (через `reload`,
`openPage` или `networkRequest`). Для мгновенного локального переключения
без перезагрузки используй [`setState`](/reference/state-storage#setstate).

```json
{ "type": "appToggle", "value": true,
  "onChange": { "actionType": "setState", "key": "push", "value": false } }
```

### appSegmentedControl

Сегменты в стиле iOS. Каждая опция несёт свой экшен — экран серверный,
поэтому переключение обычно перерисовывает контент через `openPage`,
`networkRequest` или `setState`.

```json
{ "type": "appSegmentedControl", "selectedIndex": 0, "options": [
  { "label": "Сегодня", "onSelected": { "actionType": "openPage", "path": "/today" } },
  { "label": "Неделя", "onSelected": { "actionType": "openPage", "path": "/week" } }
]}
```

### appStateScope

Граница локального реактивного состояния. Внутри читаются плейсхолдеры
<span v-pre>`{{state.<key>}}`</span>, а экшен `setState` меняет их на лету —
без перезагрузки экрана. Полное описание — на странице
[Состояние и хранилище](/reference/state-storage).

```json
{ "type": "appStateScope", "initial": { "count": 0 },
  "child": { "type": "text", "data": "Счёт: {{state.count}}" } }
```

### appImagePicker

Выбор фото из галереи или камеры с превью, повторным выбором, удалением
и состояниями загрузки, отмены и ошибки. Отмена сохраняет предыдущий выбор.

```json
{ "type": "appImagePicker", "stateKey": "photo", "label": "Фото профиля",
  "initialUrl": "https://example.org/current.jpg",
  "allowCamera": true, "allowGallery": true, "allowRemove": true,
  "onChanged": { "actionType": "setState", "key": "changed", "value": true } }
```

`stateKey` содержит URL нового файла. `initialUrl` показывает сохранённое фото
и не считается новым выбором. Дополнительные ключи по умолчанию:
`photoStatus` (`idle`, `picking`, `ready`, `error`, `removed`), `photoError`,
`photoRemoved`. Их можно переименовать через `statusKey`, `errorKey`,
`removedKey`. `enabled`, `loading`, `height`, `helperText` управляют видом;
`onCancel`, `onError`, `onRemoved` обрабатывают соответствующие события.
Удаление очищает только локальный выбор; сохранение на сервере задаётся действием.

### Анимации

`appAnimatedSwitcher` меняет содержимое при изменении `value`.
`transition`: `fade`, `fadeScale`, `slideUp`, `slideDown`.

```json
{ "type": "appAnimatedSwitcher", "value": "{{state.tab}}", "duration": 220,
  "transition": "fadeScale", "child": {
    "type": "appText", "data": "Раздел {{state.tab}}" } }
```

`appAnimatedContainer` анимирует `width`, `height`, `padding`, `margin`,
`color`, `radius`, `borderColor`, `borderWidth`, `alignment`.
`appAnimatedOpacity` анимирует `opacity`; при нулевой прозрачности содержимое
не принимает нажатия и скрывается из дерева доступности.

Все три виджета принимают `duration` в миллисекундах (0–2000) и `curve`:
`linear`, `easeIn`, `easeOut`, `easeInOut`, `easeInCubic`, `easeOutCubic`,
`easeInOutCubic`, `fastOutSlowIn`. Системное уменьшение движения учитывается
автоматически; `reduceMotion: true` отключает анимацию локально.

## Виджеты Stac

Полный каталог стандартных виджетов с параметрами — в
[документации Stac](https://docs.stac.dev). Самые популярные:

| Группа | Типы |
| --- | --- |
| Каркас | `scaffold`, `appBar`, `safeArea`, `tabBar`, `tabBarView` |
| Раскладка | `column`, `row`, `stack`, `padding`, `center`, `expanded`, `sizedBox`, `wrap`, `spacer` |
| Списки | `listView`, `gridView`, `singleChildScrollView`, `listTile`, `refreshIndicator` |
| Контент | `text`, `image`, `icon`, `card`, `divider`, `chip`, `badge`, `circleAvatar` |
| Ввод | `form`, `textFormField`, `checkBox`, `radioGroup`, `slider`, `dropdownMenu` |
| Логика | `conditional`, `networkWidget`, `dynamicView`, `setValue` |

::: danger Картинки грузятся напрямую
Виджет `image` тянет URL без прокси. Используй стабильный https-хостинг и
не клади в картинки ничего чувствительного.
:::
