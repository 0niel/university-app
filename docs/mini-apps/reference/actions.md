# Экшены

Экшен — это JSON-объект с полем `actionType`, который вешается на колбэки
виджетов: `onPressed`, `onTap` и т.д. Кроме встроенных экшенов Stac
платформа добавляет свои — для навигации по Mirea Ninja и взаимодействия
с хостом.

## Экшены платформы

### openDeepLink

Открывает любой разрешённый экран приложения: расписание, карту, сервисы,
другой мини-апп. Локация проверяется по белому списку
(см. [диплинки](/reference/deeplinks)).

```json
{ "actionType": "openDeepLink", "location": "/services/map" }
```

### openPage

Пушит новый экран этого же мини-аппа. Для hosted-аппов страница берётся из
сохранённых экранов, для remote — запрашивается у твоего сервера через
прокси.

```json
{ "actionType": "openPage", "path": "/details", "title": "Детали" }
```

### openMiniApp

Кросс-апп навигация: открывает любой опубликованный мини-апп, опционально
сразу на его внутренней странице. Так аппы могут ссылаться друг на друга и
собираться в экосистемы.

```json
{ "actionType": "openMiniApp", "slug": "study-timer", "page": "/stats" }
```

### pop

Закрывает верхний экран: внутреннюю страницу, диалог или шторку.
На стартовом экране ничего не делает (для выхода — `closeMiniApp`).

```json
{ "actionType": "pop" }
```

### reload

Перезагружает стартовый экран аппа — удобно для кнопки «Обновить» и
ретраев в `appErrorState`.

```json
{ "actionType": "reload" }
```

### confirm

Диалог подтверждения с кнопками дизайн-системы, запускающий follow-up
экшены.

```json
{ "actionType": "confirm", "title": "Удалить запись?",
  "message": "Действие нельзя отменить", "isDanger": true,
  "confirmLabel": "Удалить", "cancelLabel": "Отмена",
  "onConfirm": { "actionType": "networkRequest",
                 "url": "/api/items/1", "method": "delete" },
  "onCancel": { "actionType": "none" } }
```

### openSheet

Фирменная нижняя шторка, внутри — любое дерево виджетов. `pop` внутри
шторки закрывает её.

```json
{ "actionType": "openSheet", "title": "Детали",
  "child": { "type": "column", "children": [] } }
```

### setState

Меняет реактивное локальное состояние ближайшего `appStateScope` —
**на месте, без перезагрузки экрана** (скролл сохраняется). `value` задаёт
литерал, `add` прибавляет число, `expression` вычисляет значение из текущего
состояния (например `"state.price * state.qty"`), `action` запускает follow-up.
Не сохраняется между запусками. Подробно — на странице
[Состояние и хранилище](/reference/state-storage#setstate), про выражения —
[Логика и выражения](/reference/logic).

```json
{ "actionType": "setState", "key": "count", "add": 5 }
{ "actionType": "setState", "key": "total", "expression": "state.price * state.qty" }
```

### setStorage

Пишет одно значение в персональное хранилище (своё у каждого пользователя
в каждом аппе) и обновляет подстановку <span v-pre>`{{storage.<key>}}`</span>.
В отличие от `setState`, значение **переживает перезапуски**, но для
перерисовки нужен `reload`/`openPage`. `"value": null` удаляет ключ.
Лимиты и детали — на странице
[Состояние и хранилище](/reference/state-storage#setstorage).

```json
{ "actionType": "multiAction", "actions": [
  { "actionType": "setStorage", "key": "score", "value": 42 },
  { "actionType": "reload" }
]}
```

### closeMiniApp

```json
{ "actionType": "closeMiniApp" }
```

### openUrl

Только `https://`; ссылка откроется в системном браузере.

```json
{ "actionType": "openUrl", "url": "https://mirea.ru" }
```

### share

```json
{ "actionType": "share", "text": "Смотри, что нашёл!" }
```

### copyToClipboard

```json
{ "actionType": "copyToClipboard",
  "text": "PROMO-2026", "message": "Скопировано!" }
```

### hapticFeedback

Стили: `light`, `medium`, `heavy`, `selection`, `vibrate`.

```json
{ "actionType": "hapticFeedback", "style": "light" }
```

### showToast

```json
{ "actionType": "showToast", "message": "Готово!" }
```

## Сетевые запросы: networkRequest

Встроенный экшен Stac для вызова API. В мини-аппах все запросы идут через
защищённый прокси, поэтому **URL должен быть относительным путём** — он
будет вызван на твоём зарегистрированном origin-сервере. Абсолютные URL
отклоняются.

```json
{
  "actionType": "networkRequest",
  "url": "/api/vote",
  "method": "post",
  "body": {
    "option": "pizza",
    "comment": { "actionType": "getFormValue", "id": "comment" }
  },
  "results": [
    { "statusCode": 200,
      "action": { "actionType": "showToast", "message": "Голос учтён!" } },
    { "statusCode": 500,
      "action": { "actionType": "showToast", "message": "Ошибка, попробуй позже" } }
  ]
}
```

::: info Hosted-аппам сетевые запросы недоступны
У них нет origin-сервера. Нужны живые данные? Регистрируй апп как remote
([свой сервер](/reference/backend)).
:::

## Данные в состояние: fetch

`networkRequest` ветвится по статус-коду, но не отдаёт тело в твои руки.
`fetch` — наоборот: вызывает бэкенд через прокси и **кладёт JSON-ответ в
реактивное состояние**, откуда его рисуют `appForEach` и
<span v-pre>`{{ … }}`</span> — без перезагрузки экрана. Работает внутри
`appStateScope`.

```json
{ "actionType": "fetch", "path": "/api/lessons", "method": "GET",
  "query": { "day": "{{state.day}}" },
  "saveAs": "lessons", "pick": "items", "loadingKey": "busy",
  "onResult": { "actionType": "hapticFeedback", "style": "selection" },
  "onError": { "actionType": "showToast", "message": "Ошибка сети" } }
```

| Поле | Назначение |
| --- | --- |
| `path` | относительный путь к API (как в `networkRequest`) |
| `method` | HTTP-метод, по умолчанию `GET` |
| `query` / `body` | параметры запроса и тело |
| `saveAs` | ключ состояния для ответа (по умолчанию `data`) |
| `pick` | путь внутрь ответа: `"data.items"`, `"items.0.title"` |
| `loadingKey` | ключ-флаг: `true` на время запроса, `false` по завершении |
| `onResult` / `onError` | follow-up при успехе / ошибке |

Полный пример «загрузить и показать список» — на странице
[Логика и выражения](/reference/logic#данные-с-сервера-состояние-fetch).

::: tip fetch или networkRequest
`networkRequest` — для «отправить и среагировать на код ответа» (голосование,
удаление). `fetch` — для «получить данные и нарисовать их».
:::

## Управление потоком

`runIf` ветвит экшены по условию, `forEachAction` повторяет экшен по списку.
Подробно с примерами — на странице
[Логика и выражения](/reference/logic#управление-потоком-в-экшенах).

```json
{ "actionType": "runIf", "condition": "state.cart.length > 0",
  "then": { "actionType": "openPage", "path": "/checkout" },
  "else": { "actionType": "showToast", "message": "Корзина пуста" } }
```

```json
{ "actionType": "forEachAction", "items": "state.exams",
  "do": { "actionType": "addCalendarEvent",
          "title": "Экзамен: {{item.subject}}", "start": "{{item.start}}" } }
```

## Встроенные экшены Stac

| actionType | Что делает |
| --- | --- |
| `navigate` | Навигация Stac (push/pop). Внутри мини-аппов предпочитай `openPage` |
| `showDialog` / `showModalBottomSheet` | Диалог или шторка с виджетом из `widget` |
| `showSnackBar` | Снэкбар |
| `getFormValue` / `validateForm` | Работа с формами: значение поля по `id`, валидация |
| `setValue` | Записывает значение в реестр для подстановок <span v-pre>`{{key}}`</span> |
| `multiAction` | Последовательность экшенов |
| `delay` | Пауза перед следующим экшеном |
| `none` | Ничего не делает |

## Пример формы целиком

```json
{
  "type": "form",
  "child": {
    "type": "column",
    "children": [
      { "type": "textFormField", "id": "comment",
        "decoration": { "hintText": "Комментарий" },
        "validatorRules": [
          { "rule": "isLength", "options": { "min": 3 },
            "message": "Минимум 3 символа" }
        ] },
      { "type": "sizedBox", "height": 12 },
      { "type": "appButton", "label": "Отправить", "expanded": true,
        "onPressed": {
          "actionType": "validateForm",
          "isValid": { "actionType": "networkRequest",
                       "url": "/api/comments", "method": "post",
                       "body": { "text": { "actionType": "getFormValue",
                                           "id": "comment" } } }
        } }
    ]
  }
}
```
