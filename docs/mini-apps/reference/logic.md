# Логика и выражения

Внутри `appStateScope` плейсхолдеры <span v-pre>`{{ … }}`</span> — это не просто
подстановка значения, а **выражения**: арифметика, сравнения, тернарник,
вызовы функций. Плюс есть декларативные узлы потока — `appIf`, `appForEach`,
`appSwitch`. Вместе это позволяет описывать реальную логику экрана прямо в
JSON, без обращения к серверу на каждый чих.

::: tip Где работают выражения
Выражения и узлы потока резолвятся реактивным слоем `appStateScope`. Всё, что
описано ниже, должно жить **внутри** `appStateScope` — он задаёт область
состояния и перерисовывает поддерево при изменениях. Снаружи
<span v-pre>`{{ … }}`</span> остаётся обычной подстановкой из реестра.
:::

## Выражения в плейсхолдерах

Если вся строка — это один плейсхолдер, возвращается **типизированное**
значение (число, bool, список, объект). Если плейсхолдер вписан в текст —
значение подставляется строкой.

```json
{ "type": "appStateScope", "initial": { "score": 91, "name": "Аня" }, "child": {
  "type": "column", "crossAxisAlignment": "start", "children": [
    { "type": "text", "data": "Привет, {{state.name}}!" },
    { "type": "text", "data": "{{state.score >= 80 ? 'Отлично' : 'Ещё чуть-чуть'}}" },
    { "type": "appProgressRing", "progress": "{{state.score / 100}}" }
  ]
}}
```

В первой строке значение склеивается в текст, во второй тернарник вернёт
строку, в третьей <span v-pre>`{{state.score / 100}}`</span> вернёт **число**
`0.91` — ровно то, что ждёт `progress`.

### Операторы

| Группа | Операторы |
| --- | --- |
| Арифметика | `+` `-` `*` `/` `%` `~/` (целочисленное деление) |
| Сравнение | `==` `!=` `<` `<=` `>` `>=` |
| Логика | `&&` `\|\|` `!` |
| Значение по умолчанию | `??` |
| Тернарник | `условие ? a : b` |

### Доступ к данным

- Поля объекта — через точку: <span v-pre>`{{state.user.name}}`</span>.
- Элемент списка — по индексу: <span v-pre>`{{state.items[0]}}`</span>.
- Длина списка/строки: <span v-pre>`{{state.items.length}}`</span>.
- Нет ключа? Вернётся `null` (выражение не падает). Подстрахуйся через `??`:
  <span v-pre>`{{state.nickname ?? 'гость'}}`</span>.

### Функции

Доступен только этот набор чистых функций — больше ничего вызвать нельзя
(см. [Песочница](#песочница)).

| Функция | Что делает |
| --- | --- |
| `len(x)` | длина строки / списка / объекта |
| `upper(s)` `lower(s)` `trim(s)` | работа со строкой |
| `round(n)` `floor(n)` `ceil(n)` `abs(n)` | округление и модуль |
| `min(a,b)` `max(a,b)` `clamp(n,lo,hi)` | сравнение чисел |
| `int(x)` `num(x)` `str(x)` `bool(x)` | приведение типов |
| `contains(coll, x)` | есть ли элемент / подстрока / ключ |
| `join(list, sep)` | склейка списка в строку |
| `keys(map)` `values(map)` | ключи / значения объекта |

```json
{ "type": "text", "data": "Выбрано: {{len(state.selected)}} из {{len(state.all)}}" }
```

## Условия: appIf

`appIf` рендерит `child`, когда `condition` истинно, иначе `else` (если задан).
`condition` — это **голое выражение** (без <span v-pre>`{{ }}`</span>).
Ложная ветка без `else` просто исчезает из дерева.

```json
{ "type": "appIf",
  "condition": "state.cart.length > 0",
  "child": { "type": "appButton", "label": "Оформить ({{state.cart.length}})" },
  "else": { "type": "appEmptyState", "title": "Корзина пуста" } }
```

«Истинно» — это `true`, ненулевое число, непустая строка/список/объект;
`null`, `0`, `''` и пустые коллекции — «ложно».

## Списки: appForEach

`appForEach` разворачивает массив в набор виджетов. `items` — выражение,
дающее список; `template` — шаблон одного элемента, внутри которого доступны
<span v-pre>`{{item}}`</span> и <span v-pre>`{{index}}`</span>.

```json
{ "type": "appForEach",
  "items": "state.lessons",
  "as": "column",
  "template": {
    "type": "appListRow",
    "title": "{{item.name}}",
    "subtitle": "{{index + 1}} пара · {{item.room}}"
  }
}
```

- `as` — тип контейнера для элементов (`column` по умолчанию, можно `row`,
  `wrap`, `listView`). Лишние поля (`spacing`, выравнивания) пробрасываются в
  контейнер.
- Не список в `items` (или его нет) — узел исчезает.

## Ветвление: appSwitch

`appSwitch` выбирает ветку по значению `value`. В `cases` сравнение идёт по
**литералу** `when`; если ничего не совпало — рисуется `default`.

```json
{ "type": "appSwitch",
  "value": "state.tab",
  "cases": [
    { "when": "today", "child": { "type": "text", "data": "Сегодня" } },
    { "when": "week",  "child": { "type": "text", "data": "Неделя" } }
  ],
  "default": { "type": "text", "data": "Выбери вкладку" }
}
```

Чтобы сравнить с вычисляемым значением, оберни `when` в
<span v-pre>`{{ }}`</span>: <span v-pre>`"when": "{{state.defaultTab}}"`</span>.

## Данные с сервера → состояние: fetch

Экшен [`fetch`](/reference/actions#fetch) запрашивает бэкенд через прокси и
кладёт JSON-ответ в состояние — дальше его рисует `appForEach`. Это и есть
рендер произвольных данных API без перезагрузки экрана.

```json
{ "type": "appStateScope", "initial": { "lessons": [], "busy": false }, "child": {
  "type": "column", "children": [
    { "type": "appButton", "label": "Загрузить расписание",
      "onPressed": { "actionType": "fetch", "path": "/api/lessons",
        "saveAs": "lessons", "pick": "items", "loadingKey": "busy" } },
    { "type": "appIf", "condition": "state.busy",
      "child": { "type": "appProgressRing" } },
    { "type": "appForEach", "items": "state.lessons", "template": {
      "type": "appListRow", "title": "{{item.name}}", "subtitle": "{{item.room}}"
    }}
  ]
}}
```

## Управление потоком в экшенах

Логику ветвления и повторов можно вешать не только на дерево, но и на сами
экшены.

### runIf

Запускает `then`, если `condition` (голое выражение) истинно, иначе `else`.
Решение принимается **в момент вызова**, по актуальному состоянию.

```json
{ "actionType": "runIf",
  "condition": "state.cart.length > 0",
  "then": { "actionType": "openPage", "path": "/checkout" },
  "else": { "actionType": "showToast", "message": "Корзина пуста" } }
```

### forEachAction

Выполняет экшен `do` по разу на каждый элемент списка из `items` (выражение).
Внутри `do` доступны <span v-pre>`{{item}}`</span> и
<span v-pre>`{{index}}`</span>; итерации идут последовательно. Имена можно
переопределить через `itemVar` / `indexVar`.

```json
{ "actionType": "forEachAction",
  "items": "state.exams",
  "do": { "actionType": "addCalendarEvent",
          "title": "Экзамен: {{item.subject}}",
          "start": "{{item.start}}" } }
```

Так одной кнопкой можно, например, добавить все экзамены в календарь или
запланировать напоминания по всем выбранным парам.

## setState с выражением

`setState` умеет вычислять новое значение из текущего состояния — поле
`expression`. Подробнее на странице
[Состояние и хранилище](/reference/state-storage#setstate).

```json
{ "actionType": "setState", "key": "total", "expression": "state.price * state.qty" }
```

## Песочница

Движок выражений **чистый и не Тьюринг-полный**: нет циклов, нет своих
функций, нет доступа к устройству или сети из самого выражения. Вызвать можно
только функции из таблицы выше, прочитать — только то, что лежит в `state`.
Битое или вредоносное выражение в худшем случае вернёт `null` — экран не
упадёт. Поэтому экраны остаются статически проверяемыми и проходят модерацию.
