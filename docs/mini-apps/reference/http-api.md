# HTTP API: деплой и пуши

Для автоматизации есть два HTTP-эндпоинта, авторизуемых **deploy-токеном**.
Токен создаётся в приложении: каталог → твой апп (long-press) →
«Deploy-токены». Значение показывается один раз, хранится только sha256-хеш,
максимум 5 токенов на аккаунт.

```
Authorization: Bearer man_<48 hex символов>
```

## Деплой hosted-экранов

Заменяет все экраны аппа из CI — без ручной вставки JSON в форму. Снимается
ревизия (хранятся последние 20, любую можно восстановить в приложении),
версия растёт, апп уходит на модерацию (`"submit": false` — сохранить
черновиком).

```bash
curl -X POST https://ejzybbyjwtzbibrrwrli.supabase.co/functions/v1/miniapp-deploy \
  -H "Authorization: Bearer man_..." \
  -H "Content-Type: application/json" \
  -d @screens.json
```

```json
{
  "organizationId": "mirea",
  "slug": "my-app",
  "submit": true,
  "screens": [
    { "path": "/", "title": "Главная", "json": { "type": "scaffold" } },
    { "path": "/about", "json": { "type": "scaffold" } }
  ]
}
```

Ответ:

```json
{
  "ok": true,
  "version": 7,
  "status": "pending_review",
  "validation": { "unknownWidgets": [], "unknownActions": [] }
}
```

`validation` — серверная проверка по реестру известных типов: опечатки в
`type`/`actionType` видны сразу, не дожидаясь модерации.

| Ошибка | Причина |
| --- | --- |
| `invalid_token` (401) | Токен не найден или отозван |
| `app_not_found` (422) | Slug не твой или не существует |
| `not_hosted` (422) | Апп зарегистрирован как remote |
| `suspended` (422) | Апп заморожен модерацией |
| `bad_screens` (422) | Пустой массив или больше 30 экранов |

## Пуши подписчикам

Шлёт уведомление пользователям, выдавшим аппу scope `notifications`
(см. [разрешения](/guide/publishing#разрешения-на-данные)). Жёсткая квота:
**2 пуша в сутки на пользователя на апп** — превысившие лимит получатели
молча исключаются из рассылки.

Доставка идёт через **Yandex Cloud Notification Service**: платформа сама
доводит уведомление до FCM (Android), APNs (iOS), HMS (Huawei) и RuStore —
тебе как разработчику аппа думать об этом не нужно, формат запроса один.

```bash
curl -X POST https://ejzybbyjwtzbibrrwrli.supabase.co/functions/v1/miniapp-notify \
  -H "Authorization: Bearer man_..." \
  -H "Content-Type: application/json" \
  -d '{"organizationId":"mirea","slug":"my-app",
       "title":"Новый дроп","body":"Загляни!","page":"/news"}'
```

- `title` ≤ 80 символов, `body` ≤ 200; заголовок уведомления автоматически
  префиксуется именем аппа.
- `page` — необязательный путь: тап по уведомлению откроет апп сразу на
  этой странице (через диплинк `?page=`).
- Ответ: `{ "ok": true, "delivered": 12, "users": 9 }`.

::: warning Условия для пушей
Апп должен быть опубликован и декларировать scope `notifications`.
Злоупотребление рассылками — прямой путь к заморозке и отзыву скоупа
модерацией.
:::
