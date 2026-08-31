# University content fetcher

This project normalizes university content into the protected Supabase `ingest` Edge Function. Every payload is scoped by `APP_ORGANIZATION_ID`, so a university can add its own sources without forking the mobile app or database logic.

Use the smallest suitable integration:

- Import the ready [n8n RSS workflow](n8n/rss-to-ingest.json) for RSS/Atom and use n8n's HTTP Request node for official APIs such as Facebook Graph API.
- Configure the built-in `rss` code connector when a small, versioned deployment is preferable.
- Configure the built-in `json` connector for a public JSON API with field paths in `CONTENT_SOURCES`.
- Keep the Python Telegram connector only for functionality that needs a Telegram user session, including Stories.

The complete extension model is in [docs/architecture.md](docs/architecture.md).

## Local setup

```powershell
uv sync --group dev
Copy-Item .env.example .env
uv run python worker.py
```

Keep `.env`, `*.session`, and local Python environments private. They are ignored by Git; inject production values through the deployment secret store instead.

## Official website profile

Set `OFFICIAL_NEWS_ENABLED=true` and configure the source metadata:

```dotenv
APP_ORGANIZATION_ID=example-university
OFFICIAL_NEWS_ENABLED=true
OFFICIAL_NEWS_URL=https://university.example/news/
OFFICIAL_NEWS_SOURCE_ID=official
OFFICIAL_NEWS_SOURCE_NAME=Example University
OFFICIAL_NEWS_CATEGORY=university
OFFICIAL_NEWS_LINK_SELECTOR=a[href*="/news/"]
OFFICIAL_NEWS_ARTICLE_SELECTORS=article,main
```

`OFFICIAL_NEWS_LINK_SELECTOR` identifies cards on the listing page. `OFFICIAL_NEWS_ARTICLE_SELECTORS` is an ordered list of CSS selectors used to find the article body. The built-in `MIREA_ENABLED=true` profile remains available for the existing MIREA deployment; do not enable it together with the generic profile.

## Generic RSS/Atom profile

`CONTENT_SOURCES` is a JSON list, so one worker can ingest several university feeds without code changes:

```dotenv
CONTENT_SOURCES=[{"id":"official-feed","provider":"rss","name":"Example University","source_url":"https://university.example/news","feed_url":"https://university.example/news/feed.xml","category":"university"}]
```

Run it once with `uv run python sync_sources.py`, or let `worker.py` schedule it with the existing interval.

## No-code n8n profile

Import [`n8n/rss-to-ingest.json`](n8n/rss-to-ingest.json) into a self-hosted n8n instance. Configure these n8n environment variables and activate the workflow:

```dotenv
APP_ORGANIZATION_ID=example-university
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_INGEST_KEY=dedicated-tenant-ingest-secret
RSS_FEED_URL=https://university.example/news/feed.xml
SOURCE_ID=official-news
SOURCE_NAME=Example University
SOURCE_URL=https://university.example/news
SOURCE_CATEGORY=university
```

The workflow reads those values at runtime; it does not embed an ingest secret. For Facebook, VK, YouTube, Mastodon, or another authenticated API, replace the RSS node with n8n's HTTP Request node, keep its token in an n8n credential, and retain the final ingest node.

## Generic public JSON API profile

Use this only for public endpoints without credentials. `metadata` defines dot-separated paths inside the JSON response; this keeps simple university APIs configurable while n8n remains the safer option for authenticated providers.

```dotenv
CONTENT_SOURCES=[{"id":"public-api","provider":"json","name":"Example University","source_url":"https://university.example/news","feed_url":"https://api.university.example/news","metadata":{"items_path":"data.items","id_path":"id","title_path":"title","url_path":"url","published_at_path":"published_at","summary_path":"summary"}}]
```

`items_path` must resolve to a list of JSON objects. `title_path` and `url_path` are required; `id_path`, `published_at_path`, `summary_path`, and `html_path` are optional. Dates can be ISO-8601 or Unix timestamps.

## Telegram

Provide `TELEGRAM_API_ID`, `TELEGRAM_API_HASH`, and `TELEGRAM_SESSION_STRING` through private configuration, then list public channels in `TELEGRAM_CHANNELS` and `TELEGRAM_STORY_CHANNELS`. The worker checkpoints message ingestion, reconciles recent edits, and uploads story media through signed Supabase URLs.

Verify a locally generated session without fetching or publishing content:

```powershell
uv run python setup_telegram_session.py --check-session
```

## Validation

```powershell
uv run ruff check .
uv run pytest
```
