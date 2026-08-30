# Возможности устройства

Мини-аппы умеют не только рисовать экраны, но и обращаться к устройству:
взять геопозицию, сделать фото, отсканировать код. Захват выполняет само
приложение Mirea Ninja — твой сервер при этом ничего лишнего не получает.

## Как это работает

1. Экшен (`getLocation` / `pickImage` / `scanCode`) запускает нативный захват.
2. Результат записывается в реактивное состояние ближайшего `appStateScope`
   под ключом `saveAs` — его сразу видно как <span v-pre>`{{state.<key>}}`</span>.
3. Дальше ты сам решаешь, что с ним делать: показать (`text`, `image`) или
   отправить на сервер обычным `networkRequest`, читающим <span v-pre>`{{state.<key>}}`</span>.

::: tip Захват и отправка — два шага
Follow-up `onResult` нужен для побочных эффектов (тост, вибро, смена вкладки),
он **не несёт** свежее значение. Чтобы отправить захваченное на бэкенд,
сделай отдельную кнопку с `networkRequest`, которая читает <span v-pre>`{{state.*}}`</span> —
к моменту нажатия состояние уже обновлено.
:::

## Разрешения

Сенсорные возможности закрыты скоупами согласия — заявляй их при публикации
(как `profile`/`group`), пользователь подтверждает доступ:

| Скоуп | Что открывает |
| --- | --- |
| `location` | `getLocation` |
| `camera` | `pickImage`, `scanCode` |
| `files` | `pickFile` |
| `calendar` | `addCalendarEvent` |

Если апп заявил скоуп, но пользователь его ещё не выдал, при первом обращении
покажется быстрый запрос. Не заявленный скоуп недоступен — экшен вернёт
«отказ» и выполнит `onCancel`.

Действия без скоупа (`authenticate`, `scheduleReminder`, `readClipboard`,
`pickDateTime`, `share`, `copyToClipboard`, `hapticFeedback`) ничего не
утаскивают с устройства — их гейтит сама система (биометрия, разрешение на
уведомления и т.д.).

## `getLocation`

Пишет `<saveAs>Lat`, `<saveAs>Lng` и `<saveAs>Accuracy` (метры). По умолчанию
`saveAs` = `loc`.

```json
{ "type": "appStateScope", "initial": {}, "child": {
  "type": "column", "crossAxisAlignment": "stretch", "children": [
    { "type": "appButton", "label": "Где я?", "expanded": true,
      "onPressed": { "actionType": "getLocation", "saveAs": "loc" } },
    { "type": "sizedBox", "height": 12 },
    { "type": "appMetaPill", "text": "{{state.locLat}}, {{state.locLng}}" },
    { "type": "appButton", "label": "Отметиться", "expanded": true,
      "onPressed": { "actionType": "networkRequest", "url": "/checkin",
        "method": "post",
        "body": { "lat": "{{state.locLat}}", "lng": "{{state.locLng}}" } } }
  ]
}}
```

## `pickImage`

Снимает (`source: camera`) или выбирает (`source: gallery`) фото, загружает
его и кладёт публичный URL в `<saveAs>` (по умолчанию `photo`).

```json
{ "type": "appStateScope", "initial": {}, "child": {
  "type": "column", "crossAxisAlignment": "stretch", "children": [
    { "type": "appButton", "label": "Сделать фото", "expanded": true,
      "onPressed": { "actionType": "pickImage", "source": "camera",
        "saveAs": "photo" } },
    { "type": "image", "src": "{{state.photo}}", "height": 200 }
  ]
}}
```

::: danger URL фото публичный
Загруженное фото доступно по прямой ссылке (как иконки аппов). Не снимай через
`pickImage` ничего чувствительного.
:::

## `scanCode`

Открывает сканер и кладёт распознанный текст QR/штрихкода в `<saveAs>`
(по умолчанию `code`).

```json
{ "type": "appButton", "label": "Сканировать билет", "expanded": true,
  "onPressed": { "actionType": "scanCode", "saveAs": "ticket",
    "onResult": { "actionType": "showToast", "message": "Код принят" } } }
```

## `pickFile`

Выбирает файл, загружает его и кладёт публичный URL в `<saveAs>`, а имя — в
`<saveAs>Name` (по умолчанию `file`). Скоуп `files`. Поддерживаются картинки,
PDF, txt/csv, zip и офисные форматы.

```json
{ "type": "appButton", "label": "Прикрепить", "expanded": true,
  "onPressed": { "actionType": "pickFile", "saveAs": "doc" } }
```

## `addCalendarEvent`

Добавляет событие в календарь устройства. Скоуп `calendar`. Время — ISO-8601.

```json
{ "actionType": "addCalendarEvent", "title": "Экзамен",
  "start": "2026-06-22T10:00:00", "end": "2026-06-22T12:00:00",
  "location": "А-401", "notes": "Не забыть зачётку", "saveAs": "added" }
```

## `authenticate`

Запрашивает биометрию/код устройства и пишет результат (`true`/нет) в
`<saveAs>` (по умолчанию `authOk`). `onResult` — при успехе, `onCancel` — при
отказе. Данные не покидают устройство.

```json
{ "actionType": "authenticate", "reason": "Подтвердите оплату",
  "saveAs": "paid", "onResult": { "actionType": "reload" } }
```

## `scheduleReminder`

Планирует локальное уведомление на `when` (ISO-8601) и кладёт id в `<saveAs>`
(по умолчанию `reminderId`). Удобно в паре с `pickDateTime`.

```json
{ "actionType": "scheduleReminder", "title": "Дедлайн", "body": "Сдать работу",
  "when": "{{state.when}}", "saveAs": "rid" }
```

## `readClipboard` / `pickDateTime`

`readClipboard` кладёт текст из буфера в `<saveAs>` (по умолчанию `clipboard`).
`pickDateTime` открывает пикер (`mode`: `date` · `time` · `datetime`) и пишет
ISO-строку в `<saveAs>` (по умолчанию `datetime`).

```json
{ "actionType": "readClipboard", "saveAs": "pasted" }
{ "actionType": "pickDateTime", "mode": "datetime", "saveAs": "deadline" }
```

## Общие параметры

| Поле | Для кого | Значение |
| --- | --- | --- |
| `saveAs` | все | ключ состояния для результата |
| `source` | `pickImage` | `camera` (по умолчанию) или `gallery` |
| `mode` | `pickDateTime` | `date` · `time` · `datetime` (по умолчанию) |
| `onResult` | все | экшен после удачного захвата (без значения) |
| `onCancel` | все | экшен при отказе/отмене |
