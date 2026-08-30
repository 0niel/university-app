# Деплой бэкенда на Yandex Cloud

Remote-аппу нужен https-сервер со стабильным хостом: прокси пиннит трафик
к зарегистрированному origin (см. [Свой сервер и прокси](/reference/backend)).
Yandex Cloud Functions + API Gateway дают такой хост без своего железа —
функция отдаёт экраны и API, шлюз даёт постоянный домен и роутинг по путям.

```
Прокси ──(https)──▶ API Gateway ──▶ Cloud Function
   origin = https://<id>.apigw.yandexcloud.net
   GET  /        → JSON стартового экрана
   GET  /stats   → JSON страницы /stats   (openPage)
   POST /api/...  → твой обработчик        (networkRequest)
```

Прокси добавляет к запросам [identity-заголовки](/reference/backend#проверка-подписи).
Функция читает их из `event.headers`.

## 1. Функция

Одного файла достаточно — `crypto` встроен в Node.js, зависимостей нет.
Обработчик получает HTTP-запрос как `event` и возвращает объект ответа.

```js
// index.js
const crypto = require("node:crypto");

exports.handler = async (event) => {
  const method = (event.httpMethod || "GET").toUpperCase();
  const path = (event.path || "/").replace(/\/+$/, "") || "/";
  const headers = lowerKeys(event.headers || {});

  // GET — отдаём экраны (Stac JSON)
  if (method === "GET") {
    if (path === "/") return json(200, homeScreen());
    if (path === "/stats") return json(200, statsScreen());
    return json(404, { error: "screen not found" });
  }

  // POST — API. Если используешь identity, проверь подпись прокси.
  if (method === "POST" && path === "/api/vote") {
    const user = verifyNinja(headers); // null, если подпись не настроена
    const body = parseBody(event);
    // ...записать голос по user.appUserId...
    return json(200, { ok: true, option: body.option });
  }

  return json(404, { error: "not found" });
};

// --- экраны ----------------------------------------------------------------

function homeScreen() {
  return {
    type: "scaffold",
    body: {
      type: "padding",
      padding: { left: 16, right: 16, top: 16 },
      child: {
        type: "column",
        crossAxisAlignment: "stretch",
        children: [
          { type: "appSectionTitle", title: "Привет с Yandex Cloud" },
          { type: "appButton", label: "Статистика", expanded: true,
            onPressed: { actionType: "openPage", path: "/stats",
              title: "Статистика" } },
        ],
      },
    },
  };
}

function statsScreen() {
  return { type: "scaffold", body: { type: "center",
    child: { type: "text", data: "Тут живые данные с сервера" } } };
}

// --- хелперы ----------------------------------------------------------------

function json(statusCode, payload) {
  return {
    statusCode,
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  };
}

function parseBody(event) {
  if (!event.body) return {};
  const raw = event.isBase64Encoded
    ? Buffer.from(event.body, "base64").toString("utf8")
    : event.body;
  try { return JSON.parse(raw); } catch { return {}; }
}

function lowerKeys(obj) {
  const out = {};
  for (const [k, v] of Object.entries(obj)) out[k.toLowerCase()] = v;
  return out;
}

// Проверяет, что запрос пришёл от прокси Mirea Ninja. NINJA_SECRET должен
// совпадать с секретом платформы (выдаётся командой). Без секрета подписи
// не приходят — функция работает анонимно по appUserId.
function verifyNinja(headers) {
  const appUserId = headers["x-mireaninja-app-user"];
  const ts = headers["x-mireaninja-timestamp"];
  const sig = headers["x-mireaninja-signature"];
  const secret = process.env.NINJA_SECRET;
  if (!secret || !sig) return appUserId ? { appUserId } : null;

  if (!ts || Math.abs(Date.now() / 1000 - Number(ts)) > 300) {
    throw new Error("stale signature");
  }
  const expected = crypto
    .createHmac("sha256", secret)
    .update(`${appUserId}.${ts}`)
    .digest("hex");
  if (!crypto.timingSafeEqual(Buffer.from(sig), Buffer.from(expected))) {
    throw new Error("bad signature");
  }
  // ФИО/группа приходят как base64(utf-8):
  // Buffer.from(headers["x-mireaninja-name"], "base64").toString("utf8")
  return { appUserId, scopes: (headers["x-mireaninja-scopes"] || "").split(",") };
}
```

::: warning Держись лимитов прокси
Ответ — валидный JSON ≤ 512 КБ, без редиректов, быстрее 10 секунд. Ставь
`--execution-timeout` функции меньше 10 с и помни про холодный старт: первый
запрос после простоя медленнее.
:::

## 2. Деплой функции

[Установи `yc`](https://yandex.cloud/ru/docs/cli/quickstart) и
авторизуйся. Затем:

```bash
# код в zip (можно и каталогом через --source-path .)
zip function.zip index.js

yc serverless function create --name mirea-miniapp

yc serverless function version create \
  --function-name mirea-miniapp \
  --runtime nodejs18 \
  --entrypoint index.handler \
  --memory 128m \
  --execution-timeout 5s \
  --source-path ./function.zip \
  --environment NINJA_SECRET=<секрет_платформы>
```

Запиши ID функции — он понадобится шлюзу:

```bash
yc serverless function get --name mirea-miniapp --format json
```

## 3. API Gateway → стабильный хост

Шлюз даёт постоянный домен и роутит все пути на функцию. Сначала —
сервис-аккаунт с правом вызывать функции:

```bash
yc iam service-account create --name miniapp-invoker
# выдай ему роль functions.functionInvoker на каталог (folder)
yc resource-manager folder add-access-binding <folder_id> \
  --role functions.functionInvoker \
  --subject serviceAccount:<service_account_id>
```

Спецификация `spec.yaml` — корень плюс жадный путь `/{proxy+}`, методы
`get` и `post` (добавь `put`/`patch`/`delete`, если апп их шлёт):

```yaml
openapi: 3.0.0
info:
  title: mirea-miniapp
  version: 1.0.0
paths:
  /:
    get:
      x-yc-apigateway-integration:
        type: cloud_functions
        function_id: <function_id>
        service_account_id: <service_account_id>
    post:
      x-yc-apigateway-integration:
        type: cloud_functions
        function_id: <function_id>
        service_account_id: <service_account_id>
  /{proxy+}:
    get:
      parameters:
        - { name: proxy, in: path, required: true, schema: { type: string } }
      x-yc-apigateway-integration:
        type: cloud_functions
        function_id: <function_id>
        service_account_id: <service_account_id>
    post:
      parameters:
        - { name: proxy, in: path, required: true, schema: { type: string } }
      x-yc-apigateway-integration:
        type: cloud_functions
        function_id: <function_id>
        service_account_id: <service_account_id>
```

```bash
yc serverless api-gateway create --name mirea-miniapp-gw --spec spec.yaml
yc serverless api-gateway get --name mirea-miniapp-gw --format json
```

В ответе будет `domain` — это и есть origin: `https://<id>.apigw.yandexcloud.net`.
Проверь руками:

```bash
curl https://<id>.apigw.yandexcloud.net/        # JSON стартового экрана
curl https://<id>.apigw.yandexcloud.net/stats   # JSON страницы /stats
```

::: tip Быстрая проверка без шлюза
Для разовой проверки стартового экрана функцию можно сделать публичной
(`yc serverless function allow-unauthenticated-invoke mirea-miniapp`) и
открыть `https://functions.yandexcloud.net/<function_id>`. Хост там общий, а
роутинг по внутренним путям (`/stats`, `/api/...`) даёт именно API Gateway —
для боевого аппа нужен он.
:::

## 4. Регистрация аппа

В приложении: **Сервисы → Мини-аппы → Создать**, источник — **Remote**.

- **Origin** — домен шлюза `https://<id>.apigw.yandexcloud.net`.
- **Стартовый путь** — `/`.
- **Разрешения** — выбери скоупы, если используешь identity
  ([подробнее](/guide/publishing#разрешения-на-данные)).

После одобрения апп открывается у пользователей: клиент дёргает прокси,
прокси — твой шлюз, шлюз — функцию. Перед отправкой пройди
[чек-лист бэкенда](/reference/backend#чек-лист-перед-публикацией).

::: info Экраны можно обновлять без модерации
У remote-аппа содержимое экранов живёт на твоём сервере: задеплоил новую
версию функции — пользователи видят её сразу. На модерацию возвращают
только правки метаданных и origin.
:::
