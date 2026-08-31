# Участие в разработке

Спасибо за вклад. Перед началом проверьте существующие issues и коротко опишите
предлагаемое поведение. Для больших архитектурных изменений сначала согласуйте
контракт и границы задачи. Соблюдайте [кодекс поведения](CODE_OF_CONDUCT.md).

Информацию об уязвимостях отправляйте приватно по инструкции из
[SECURITY.md](SECURITY.md), а не через публичный issue.

## Настройка окружения

Проект использует Flutter 3.44.2, Dart 3.12, Java 17 для Android и FVM. Это Dart
workspace: `flutter pub get` из корня подключает пакеты из `packages/`, отдельный
bootstrap-инструмент не нужен.

```bash
dart pub global activate fvm
fvm install
fvm flutter pub get
cp .env.example .env
cp config/university.example.json config/university.local.json
fvm dart run tool/configure_university.dart
fvm dart run build_runner build
```

В PowerShell используйте `Copy-Item` вместо `cp`. В `.env` задаются публичные
compile-time параметры приложения (`SUPABASE_URL` и
`SUPABASE_PUBLISHABLE_KEY`), а в `config/university.local.json` — tenant и
публичный брендинг. Оба файла передаются Flutter отдельно:

```bash
fvm flutter run \
  --flavor development \
  --target lib/main/main_development.dart \
  --dart-define-from-file=.env \
  --dart-define-from-file=config/university.local.json
```

Подробнее: [`docs/university-configuration.md`](docs/university-configuration.md).

## Архитектурные правила

- Группируйте presentation-код по feature в `lib/`; выносите общие клиенты,
  domain/data-контракты и репозитории в подходящий пакет workspace.
- Widget отправляет события и отображает state. I/O размещается в repository и
  client/data-source слоях, а не в `build()`.
- Для состояния приложения используйте BLoC; зависимости регистрируйте через
  существующий `yx_scope`. Не добавляйте второй DI/state-management подход.
- Новые JSON DTO делайте immutable через Freezed и `json_serializable`. Не
  пишите вручную `==`, `copyWith`, `fromJson` и `toJson`, когда их может
  безопасно сгенерировать проект.
- Сохраняйте null safety: не используйте `!`, если значение можно проверить и
  сузить flow analysis.
- Публичный Supabase-контракт — RPC/Edge Functions. Не связывайте Flutter с
  внутренними таблицами и никогда не добавляйте `service_role` в клиент.
- Университетская специфика должна быть конфигурацией или отдельным adapter, а
  не условием, размазанным по UI и domain-коду.
- Комментарий должен объяснять неочевидное решение или ограничение. Не
  дублируйте код пересказами и шаблонными doc comments.

## Изменение схемы и ingest

Создавайте миграции командой:

```bash
supabase migration new <descriptive_name>
```

Не переписывайте уже применённые миграции. Проверяйте полный локальный replay
через `supabase db reset` при доступном Docker. Сохраняйте tenant scope через
`organization_id`, RLS и существующие публичные RPC.

Фетчеры должны нормализовать данные и вызывать защищённый
`supabase/functions/ingest`, а не писать напрямую в `core.*`. Для нового
университета добавляйте provider/adapter и фикстуры; MIREA-provider не является
универсальным fallback.

## Генерация и форматирование

После изменения Freezed, JSON, router или другой генерируемой модели выполните:

```bash
fvm dart run build_runner build
fvm dart format lib test packages tool
```

Builders работают в границах пакета. Если модель находится в
`packages/<name>`, повторите `fvm dart run build_runner build` из каталога
этого пакета.

Генерируемые файлы меняются только через исходную модель и build runner.

## Проверки перед pull request

Минимум для Flutter/Dart:

```bash
fvm dart analyze --fatal-warnings
fvm flutter test
```

Если затронут Python worker:

```bash
cd tools/social_media_fetcher
uv sync --locked
uv run ruff format --check .
uv run ruff check .
uv run pytest
```

Если затронут `supabase/functions/ingest`:

```bash
deno fmt --check supabase/functions/ingest
deno lint supabase/functions/ingest
deno check supabase/functions/ingest/index.ts
deno test supabase/functions/ingest
```

Добавляйте unit-тесты для repository/BLoC и regression-тест для исправленной
ошибки. Для BLoC проверяйте успешный и ошибочный сценарии; для интеграций
используйте локальные фикстуры вместо живого внешнего API.

## Pull request

- Делайте одну логическую задачу на pull request и не включайте несвязанные
  форматирования или generated-файлы.
- Опишите пользовательский эффект, архитектурное решение и выполненные проверки.
- Для UI приложите скриншоты и проверьте light/dark theme, большой масштаб
  текста и semantics интерактивных элементов.
- Используйте понятные сообщения коммитов; если применяете Conventional Commits,
  выбирайте scope по feature или package.

Никогда не прикладывайте `.env`, Firebase-файлы, ключи подписи, Supabase ingest
secret, Telegram API hash/session string, дампы пользовательских сессий или
персональные данные. Если секрет случайно попал в Git или логи, немедленно
отзовите его и сообщите сопровождающим приватно.
