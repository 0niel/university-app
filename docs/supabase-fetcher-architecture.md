# Supabase and content-ingestion architecture

The application is multi-tenant. A university is an `organization`, and every
client request, source and stored item is scoped by `organization_id`.
Configuration of the Flutter deployment is described in
[university-configuration.md](university-configuration.md).

## Runtime boundaries

```text
Flutter
  -> Supabase Auth
  -> public RPC / app_api_v1 read contracts
  -> direct Storage only where its RLS policy permits it

Source connector
  -> protected /functions/v1/ingest
  -> ingest_v1 write functions
  -> core canonical tables
  -> app_api_v1 read contracts
  -> repository -> BLoC -> Flutter
```

Flutter must not query `core`, `internal`, or `ingest_v1` directly. It never
receives a service-role key or an ingest key. Privileged writes and external
source synchronization always cross the protected `ingest` Edge Function.

## Schemas and responsibilities

| Layer | Responsibility |
| --- | --- |
| `core` | Normalized, canonical application data. |
| `internal` | Sync runs, checkpoints, raw source data and other worker-only state. |
| `ingest_v1` | Trusted write functions used only by the ingest boundary. |
| `app_api_v1` and public RPC wrappers | Stable, client-facing read and user-owned write contracts. |

New public tables require RLS and explicit grants. New client-facing views and
RPC must preserve organization scope and avoid exposing internal payloads.

## Content sources

Use the lightest connector that supports the source:

| Source | Integration |
| --- | --- |
| RSS/Atom or documented HTTP API | The n8n workflow in `tools/social_media_fetcher/n8n` or another low-code connector. |
| Official university website | The generic official-news profile in `tools/social_media_fetcher`. |
| Telegram history and Stories | The dedicated Python connector, configured with a private session secret. |
| University schedule with compatible search/iCal API | `tools/schedule_fetcher`. |

All connectors normalize data before ingesting it. They do not write to
Postgres directly. The social worker records a sync run before fetching, sends
its ID with every batch, advances a checkpoint only after the complete batch
is accepted, and records failures without advancing it.

The social worker is configured entirely through environment variables. Its
README documents RSS, official-news and Telegram profiles. Production secrets
belong in the deployment secret store; `.env`, Telegram session files and
ingest keys must not be committed.

## Ingest contract

`supabase/functions/ingest` accepts normalized entities, validates tenant-bound
credentials and delegates to trusted database functions. Current entities
include:

- `news_items` for news, channel posts and Stories;
- `schedule` for normalized schedule targets and parts;
- `sync_start` and `sync_finish` for durable synchronization state;
- `story_media_upload`, `story_media_delete` and `story_media_cleanup` for
  signed Story-media operations.

The worker must treat a 4xx ingest response as a confirmed rejection. It may
roll back media uploaded solely for that rejected Story batch; it must not roll
back when the outcome of a successful ingest is unknown.

## Schedule sources

Schedule targets and occurrences are source-neutral. External identifiers stay
in source metadata; internal records use database identities. The MIREA parser
is an optional source adapter, not an app-wide dependency. To import a
compatible university source, provide its base URL and source metadata to the
schedule fetcher instead of changing Flutter code.

## Database change workflow

This repository uses imperative SQL migrations.

1. Create a new migration with the Supabase CLI; never alter an applied file.
2. Keep raw and canonical data separate, and preserve tenant isolation in every
   function, index and policy.
3. Run local migration replay and the relevant SQL/Edge-function tests.
4. Review RLS, grants, function search paths and Storage policies before
   deployment.

Do not put project URLs, secret values, manual production commands or transient
verification logs into migrations or documentation.

## Extension rules

- Add a new university as configuration plus source records, not a Flutter fork.
- Add a new upstream provider behind the ingest contract, with fixtures and
  contract tests.
- Prefer source-neutral naming (`organization`, `source`, `target`) outside a
  source adapter.
- Keep source-specific parsing isolated in its package or worker connector.
- Expose only stable DTOs through repositories and BLoCs.
