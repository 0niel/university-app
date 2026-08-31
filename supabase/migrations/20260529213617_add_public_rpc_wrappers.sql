-- Thin wrappers in the exposed public schema.
--
-- Managed Supabase projects do not automatically expose newly-added schemas in
-- PostgREST. These wrappers keep Flutter and Edge Functions independent from
-- Data API schema configuration while the canonical implementation remains in
-- app_api_v1/ingest_v1.

create or replace function public.get_news_feed(
  p_institution_id text default null,
  p_limit integer default 20,
  p_offset integer default 0
)
returns table (
  id uuid,
  institution_id text,
  source_id uuid,
  source_type text,
  source_external_id text,
  source_name text,
  title text,
  summary text,
  original_url text,
  published_at timestamptz,
  news_blocks jsonb,
  news_blocks_version text
)
language sql
stable
set search_path = ''
as $$
  select *
  from app_api_v1.get_news_feed(
    p_institution_id,
    p_limit,
    p_offset
  );
$$;

create or replace function public.ingest_news_items(
  p_institution_id text,
  p_source jsonb,
  p_items jsonb,
  p_sync_run_id uuid default null
)
returns jsonb
language sql
security definer
set search_path = ''
as $$
  select ingest_v1.upsert_news_items(
    p_institution_id,
    p_source,
    p_items,
    p_sync_run_id
  );
$$;

revoke execute on function public.get_news_feed(text, integer, integer)
from public;
grant execute on function public.get_news_feed(text, integer, integer)
to anon, authenticated, service_role;

revoke execute on function public.ingest_news_items(text, jsonb, jsonb, uuid)
from public;
grant execute on function public.ingest_news_items(text, jsonb, jsonb, uuid)
to service_role;
