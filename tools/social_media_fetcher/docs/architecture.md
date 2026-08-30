# Content ingestion architecture

The protected Supabase `ingest` Edge Function is the only stable integration boundary. A source integration transforms external content into this HTTP contract; it never writes to Postgres directly.

Built-in code connectors create a sync run before fetching. They attach it to every ingest request, advance a checkpoint only after a complete accepted batch, and record failures without moving that checkpoint.

## Choose the lightest integration

| Source capability | Recommended path | Examples |
| --- | --- | --- |
| RSS/Atom or documented HTTP API | n8n workflow | university site, Facebook Page Graph API, YouTube, Mastodon |
| Static or JS-rendered public web page | n8n HTTP Request workflow or a hosted extractor | university news page without a feed |
| Requires a user account or bespoke media handling | Python connector | Telegram channel history, Telegram Stories |

Self-hosted n8n is the no-code default. It keeps credentials in its encrypted credential store, has a visual editor, and can use HTTP Request for every provider with an official API. Import `n8n/rss-to-ingest.json`, configure its documented environment variables, then activate the workflow. The export reads the tenant ingest key at runtime and contains no secret value.

For Facebook, use a university-controlled Page access token through the official Graph API in an n8n HTTP Request node. Do not add HTML scraping or a personal account session. The same pattern applies to Instagram, LinkedIn, YouTube, VK, Mastodon, and any future API: fetch, map to the ingest payload, POST to `/functions/v1/ingest`.

## Code connectors

`CONTENT_SOURCES` accepts a JSON array. The built-in `rss` connector maps RSS/Atom entries to app-renderable news blocks; the `json` connector maps a public JSON API through dot-separated field paths. Both flow through the same idempotent sync-run and ingest contract.

```dotenv
CONTENT_SOURCES=[{"id":"official-feed","provider":"rss","name":"Example University","source_url":"https://university.example/news","feed_url":"https://university.example/news/feed.xml","category":"university"}]
```

```dotenv
CONTENT_SOURCES=[{"id":"public-api","provider":"json","name":"Example University","source_url":"https://university.example/news","feed_url":"https://api.university.example/news","metadata":{"items_path":"data.items","title_path":"title","url_path":"url"}}]
```

The JSON connector intentionally has no authentication or arbitrary request-header settings. Use n8n credentials and its HTTP Request node for authenticated APIs, so provider tokens stay out of repository configuration and can be rotated without a code deployment.

To add a code connector, implement the `ContentProvider` protocol in `src/pipeline`, return `NormalizedContent`, and register a provider factory in `src/pipeline/runner.py`. This isolates provider authentication and parsing from ingestion, storage, and Flutter UI contracts.

Telegram user sessions remain a specialist connector because bots cannot provide the same access to public-channel history and stories. Store that session only in the deployment secret store. Never commit it, paste it into an issue, or share one account between universities.

## Tenant isolation

Each workflow or connector has exactly one `APP_ORGANIZATION_ID` and one matching tenant ingest key. The Edge Function validates the organization before it accepts content. The mobile client has no ingest key and no service role key.
