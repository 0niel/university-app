# Состояние и хранилище

Мини-апп умеет хранить данные без своего сервера. Есть два независимых
механизма, и они решают разные задачи:

| | `setState` | `setStorage` |
| --- | --- | --- |
| Где живёт | в памяти экрана | в Postgres, на пользователя и апп |
| Переживает перезапуск | нет | да |
| Обновление UI | на месте, скролл сохраняется | нужен `reload`/`openPage` |
| Плейсхолдер | <span v-pre>`{{state.key}}`</span> | <span v-pre>`{{storage.key}}`</span> |
| Зачем | переключатели, табы, счётчики на экране | чеклисты, настройки, прогресс |

Оба доступны и hosted-, и remote-аппам, но storage особенно полезен
hosted-аппам: он даёт персистентность там, где сервера нет вообще.

## Реактивное состояние: appStateScope + setState {#setstate}

`appStateScope` — это граница локального состояния. Он задаёт начальные
значения и оборачивает поддерево, внутри которого работают плейсхолдеры
<span v-pre>`{{state.<key>}}`</span>. Экшен `setState` меняет значение, и
**перерисовывается только это поддерево** — экран не перезагружается, скролл
и позиции остаются на месте. Состояние живёт в памяти и при выходе из
экрана сбрасывается.

Внутри scope <span v-pre>`{{ … }}`</span> — это полноценные **выражения**
(арифметика, сравнения, тернарник, функции), а рядом доступны узлы потока
`appIf` / `appForEach` / `appSwitch`. Всё это — на странице
[Логика и выражения](/reference/logic).

```json
{
  "type": "appStateScope",
  "initial": { "count": 0 },
  "child": {
    "type": "column",
    "crossAxisAlignment": "start",
    "children": [
      { "type": "text", "data": "Счёт: {{state.count}}" },
      { "type": "sizedBox", "height": 12 },
      { "type": "appButton", "label": "+5",
        "onPressed": { "actionType": "setState", "key": "count", "add": 5 } }
    ]
  }
}
```

### Поля setState

- `key` — имя значения внутри ближайшего `appStateScope`.
- `value` — задать литерал (строку, число, bool, объект).
- `add` — прибавить число к текущему значению (если значения нет, считается
  нулём). Используется вместо `value`.
- `expression` — вычислить значение из текущего состояния, например
  `"state.price * state.qty"`. См. [Логика и выражения](/reference/logic).
- `action` — необязательный экшен, который выполнится после изменения.

```json
{ "actionType": "setState", "key": "tab", "value": "week",
  "action": { "actionType": "hapticFeedback", "style": "selection" } }
```

Типичный приём — локальные табы без обращения к серверу:

```json
{ "type": "appStateScope", "initial": { "tab": "today" }, "child": {
  "type": "column", "children": [
    { "type": "appSegmentedControl", "options": [
      { "label": "Сегодня", "onSelected": { "actionType": "setState", "key": "tab", "value": "today" } },
      { "label": "Неделя",  "onSelected": { "actionType": "setState", "key": "tab", "value": "week" } }
    ]},
    { "type": "text", "data": "Активная вкладка: {{state.tab}}" }
  ]
}}
```

::: tip setState или openPage
`setState` хорош, когда данные уже на экране и нужно показать другой срез.
Если контент надо догрузить с сервера — это `networkRequest` или `openPage`.
:::

## Персональное хранилище: setStorage {#setstorage}

`setStorage` пишет одно значение в постоянное хранилище — своё у каждого
пользователя в каждом аппе. Значения читаются как
<span v-pre>`{{storage.<key>}}`</span> и подставляются на следующем рендере,
поэтому после записи обнови UI: `reload` для текущего экрана или `openPage`
для перехода.

```json
{ "type": "text", "data": "Серия: {{storage.streak}} дней" }
```

```json
{ "actionType": "multiAction", "actions": [
  { "actionType": "setStorage", "key": "streak", "value": 7 },
  { "actionType": "reload" }
]}
```

- `"value": null` удаляет ключ.
- Значения подставляются при рендере — после записи нужен `reload`/`openPage`.
- При запуске аппа всё хранилище загружается разом, так что плейсхолдеры на
  стартовом экране резолвятся сразу.

### Лимиты хранилища

| Ограничение | Значение |
| --- | --- |
| Ключей на пользователя на апп | **50** |
| Размер значения | **≤ 8 КБ** (любой JSON) |
| Формат ключа | `^[a-zA-Z0-9_.\-]{1,64}$` (буквы, цифры, `_ . -`, 1–64 символа) |

Превышение лимита ключей или размера значения — ошибка записи, апп должен
это пережить. Хранилище не предназначено под большие данные: держи в нём
флаги, счётчики и компактные настройки, а не списки на тысячи элементов.

### Пример: счётчик без сервера

```json
{
  "type": "appCard",
  "child": {
    "type": "column",
    "crossAxisAlignment": "start",
    "children": [
      { "type": "text", "data": "Выпито воды: {{storage.water}} ст." },
      { "type": "sizedBox", "height": 12 },
      { "type": "appButton", "label": "+1 стакан", "expanded": true,
        "onPressed": { "actionType": "multiAction", "actions": [
          { "actionType": "setStorage", "key": "water", "value": 1 },
          { "actionType": "reload" }
        ]}}
    ]
  }
}
```

Чтобы увеличивать счётчик, считай новое значение на стороне логики экрана
(например, в `appStateScope` через `setState` `add`, а итог фиксируй в
`setStorage`) — само хранилище умеет только записать заданное значение.

## Плейсхолдеры

Под капотом и <span v-pre>`{{state.*}}`</span>, и
<span v-pre>`{{storage.*}}`</span> — это реестр подстановок Stac. Туда же
пишет встроенный экшен `setValue` (ключ <span v-pre>`{{key}}`</span> без
префикса) — низкоуровневый аналог, если нужен просто временный регистр
значения в пределах экрана.

::: warning Плейсхолдеры считаются при рендере
Значение подставляется в момент отрисовки виджета. `setState` сам
перерисовывает свой scope; для `setStorage` и `setValue` перерисовку
запускаешь ты (`reload` / `openPage`).
:::
