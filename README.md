# University App

Открытая платформа студенческого приложения на Flutter. Репозиторий можно
адаптировать под другой университет без форка бизнес-логики: tenant, публичный
брендинг и deep links задаются конфигурацией, а университетские источники данных
подключаются через нормализованный ingest-контракт Supabase.

Конфигурация по умолчанию сохраняет совместимость с РТУ МИРЭА. Встроенный
MIREA-фетчер выключен по умолчанию и не должен использоваться для другого
tenant.

## Технологии и архитектура

- Flutter 3.44.2 и Dart 3.12 с null safety.
- Feature-first BLoC-архитектура: UI и BLoC находятся в `lib/<feature>`, а
  переиспользуемые клиенты, модели и репозитории — в Dart workspace `packages/`.
- `bloc`/`hydrated_bloc` для состояния, `yx_scope` для dependency injection и
  `go_router` для навигации.
- Freezed и `json_serializable` для генерируемых immutable-моделей и JSON DTO.
- Supabase Auth, Storage, миграции, RPC и Edge Functions как серверный контракт.
- Отдельный Python 3.12 worker для официальных новостей, Telegram-публикаций и
  Telegram Stories.

Основной поток данных:

```text
внешний источник -> Python worker -> Edge Function /ingest
                 -> Supabase RPC/таблицы -> repository -> BLoC -> Flutter UI
```

Flutter не должен обращаться к внутренним таблицам или использовать
`service_role`. Привилегированная запись контента проходит через защищённую
функцию [`supabase/functions/ingest`](supabase/functions/ingest), а схема БД
изменяется только миграциями из
[`supabase/migrations`](supabase/migrations).

## Быстрый старт

Нужны [Flutter](https://docs.flutter.dev/get-started/install), FVM и Java 17 для
Android. Версия Flutter закреплена в `.fvmrc`.

```bash
dart pub global activate fvm
fvm install
fvm flutter pub get
```

Создайте две локальные compile-time конфигурации:

```bash
cp .env.example .env
cp config/university.example.json config/university.local.json
```

В PowerShell используйте `Copy-Item` вместо `cp`. В `.env` укажите публичные
`SUPABASE_URL` и `SUPABASE_PUBLISHABLE_KEY`. В
`config/university.local.json` задайте tenant и брендинг. Затем проверьте
конфигурацию и сгенерируйте код:

```bash
fvm dart run tool/configure_university.dart
fvm dart run build_runner build
```

Запуск development flavor на Android/iOS/macOS:

```bash
fvm flutter run \
  --flavor development \
  --target lib/main/main_development.dart \
  --dart-define-from-file=.env \
  --dart-define-from-file=config/university.local.json \
  --dart-define-from-file=config/firebase.local.json
```

Firebase-файл опционален: без него Analytics и FCM корректно отключаются.
Нативные `google-services.json`, `GoogleService-Info.plist` и сгенерированный
`firebase_options.dart` не являются частью открытого исходного кода.

Для Windows уберите `--flavor development`. Подробности о схеме конфигурации и
режиме `--check` описаны в
[`docs/university-configuration.md`](docs/university-configuration.md).

Локальные `.env`, tenant-файлы, Firebase-конфигурация, ключи подписи и Telegram
session-файлы нельзя коммитить. Пример university config содержит только
публичные значения и не заменяет настройку собственных Firebase/Supabase
проектов.

## Supabase

Локальная конфигурация находится в `supabase/config.toml`. Для работы с
миграциями нужен [Supabase CLI и Docker](https://supabase.com/docs/guides/local-development/cli/getting-started):

```bash
supabase start
supabase db reset
```

Не изменяйте уже применённые миграции: создавайте новую через
`supabase migration new <name>`. Секрет ingest-функции хранится только на
сервере и в локальном окружении worker.

Для одного tenant задайте Edge secrets `INGEST_API_KEY` и
`INGEST_ORGANIZATION_ID`. Общий backend нескольких университетов должен
использовать `INGEST_TENANT_KEYS` — JSON-карту `organization_id` к отдельному
ключу каждого worker. Не используйте один неприкреплённый ключ для всех tenant.

## Фетчер контента

Worker находится в `tools/social_media_fetcher` и использует
[uv](https://docs.astral.sh/uv/). Он нормализует контент и отправляет его в
Edge ingest; напрямую в БД не пишет.

Для RSS/Atom и официальных API предпочтителен no-code путь через self-hosted
n8n: импортируйте готовый
[`rss-to-ingest.json`](tools/social_media_fetcher/n8n/rss-to-ingest.json) и
используйте HTTP Request node для Facebook Graph API, YouTube, Mastodon или
иного документированного API. Python-коннектор оставлен для источников, которым
нужна пользовательская сессия или особая обработка, например Telegram Stories.
Полный контракт и правила расширения — в
[`tools/social_media_fetcher/docs/architecture.md`](tools/social_media_fetcher/docs/architecture.md).

```bash
cd tools/social_media_fetcher
cp .env.example .env
uv sync --locked
uv run python worker.py
```

`MIREA_ENABLED=true` допустим только при `APP_ORGANIZATION_ID=mirea`. Telegram
подключается явно через `TELEGRAM_CHANNELS` и `TELEGRAM_STORY_CHANNELS`. Для
пользовательской Telegram-сессии используйте отдельный согласованный аккаунт и
`setup_telegram_session.py`; полученный session string считается секретом и не
должен попадать в логи, issues или Git.

Stories-медиа загружается только через подписанные Storage URL. Workflow
`cleanup-story-media.yml` независимо от Telegram-сессии удаляет истёкшие и
осиротевшие объекты; для него задаются `SUPABASE_URL`,
`INGEST_ORGANIZATION_ID` и tenant-bound `INGEST_API_KEY`.

## Проверки

```bash
fvm dart analyze --fatal-warnings
fvm flutter test

cd tools/social_media_fetcher
uv run ruff format --check .
uv run ruff check .
uv run pytest
```

CI повторяет анализ и тесты Flutter и ключевых workspace-пакетов, проверки
Python worker, format/lint/type-check Edge ingest и fresh replay Supabase
миграций. CI имеет только read-доступ к репозиторию. Релиз Shorebird запускается
только вручную отдельным workflow.

## Участие

Перед pull request прочитайте [CONTRIBUTING.md](CONTRIBUTING.md) и
[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md). Уязвимости нельзя публиковать в
обычных issues — используйте [SECURITY.md](SECURITY.md).

Проект распространяется по лицензии [MIT](LICENSE).
