-- Harden exposed RPC wrappers after advisor review.

create or replace function public.ingest_news_items(
  p_institution_id text,
  p_source jsonb,
  p_items jsonb,
  p_sync_run_id uuid default null
)
returns jsonb
language sql
security invoker
set search_path = ''
as $$
  select ingest_v1.upsert_news_items(
    p_institution_id,
    p_source,
    p_items,
    p_sync_run_id
  );
$$;

revoke all on function public.ingest_news_items(text, jsonb, jsonb, uuid)
from public, anon, authenticated;
grant execute on function public.ingest_news_items(text, jsonb, jsonb, uuid)
to service_role;

create index if not exists raw_payloads_sync_run_id_idx
on internal.raw_payloads (sync_run_id);

create index if not exists sync_errors_institution_id_idx
on internal.sync_errors (institution_id);
