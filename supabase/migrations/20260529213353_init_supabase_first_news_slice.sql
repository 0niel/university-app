-- Supabase-first base slice.
--
-- This migration intentionally starts from a clean contract:
-- - core: canonical normalized data
-- - internal: sync observability and raw payloads
-- - app_api_v1: stable client-facing read API
-- - ingest_v1: trusted connector/fetcher API

create extension if not exists pgcrypto with schema extensions;

create schema if not exists core;
create schema if not exists internal;
create schema if not exists app_api_v1;
create schema if not exists ingest_v1;

revoke all on schema core from public;
revoke all on schema internal from public;
revoke all on schema app_api_v1 from public;
revoke all on schema ingest_v1 from public;

create or replace function core.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table core.institutions (
  id text primary key,
  name text not null,
  timezone text not null default 'UTC',
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint institutions_id_not_empty check (length(trim(id)) > 0),
  constraint institutions_name_not_empty check (length(trim(name)) > 0)
);

create trigger set_institutions_updated_at
before update on core.institutions
for each row execute function core.set_updated_at();

create table core.news_sources (
  id uuid primary key default extensions.gen_random_uuid(),
  institution_id text not null references core.institutions(id) on delete cascade,
  source_type text not null,
  source_external_id text not null,
  source_name text not null,
  source_url text,
  category text,
  is_active boolean not null default true,
  last_fetched_at timestamptz,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint news_sources_source_type_not_empty check (length(trim(source_type)) > 0),
  constraint news_sources_source_external_id_not_empty check (length(trim(source_external_id)) > 0),
  constraint news_sources_source_name_not_empty check (length(trim(source_name)) > 0),
  constraint news_sources_unique_source unique (
    institution_id,
    source_type,
    source_external_id
  )
);

create index news_sources_institution_active_idx
on core.news_sources (institution_id, is_active);

create trigger set_news_sources_updated_at
before update on core.news_sources
for each row execute function core.set_updated_at();

create table core.news_items (
  id uuid primary key default extensions.gen_random_uuid(),
  institution_id text not null references core.institutions(id) on delete cascade,
  source_id uuid not null references core.news_sources(id) on delete cascade,
  source_type text not null,
  source_external_id text not null,
  source_name text not null,
  external_id text not null,
  title text not null,
  summary text,
  original_url text,
  published_at timestamptz not null,
  raw_data jsonb not null default '{}'::jsonb,
  news_blocks jsonb not null default '[]'::jsonb,
  news_blocks_version text not null default '1.0.0',
  processed_at timestamptz,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint news_items_external_id_not_empty check (length(trim(external_id)) > 0),
  constraint news_items_title_not_empty check (length(trim(title)) > 0),
  constraint news_items_news_blocks_is_array check (jsonb_typeof(news_blocks) = 'array'),
  constraint news_items_unique_external unique (
    institution_id,
    source_type,
    source_external_id,
    external_id
  )
);

create index news_items_feed_idx
on core.news_items (institution_id, published_at desc, created_at desc);

create index news_items_source_idx
on core.news_items (source_id, published_at desc);

create index news_items_news_blocks_gin_idx
on core.news_items using gin (news_blocks);

create trigger set_news_items_updated_at
before update on core.news_items
for each row execute function core.set_updated_at();

create table internal.sync_runs (
  id uuid primary key default extensions.gen_random_uuid(),
  institution_id text references core.institutions(id) on delete set null,
  source text not null,
  source_type text,
  status text not null default 'running',
  started_at timestamptz not null default now(),
  finished_at timestamptz,
  items_received integer not null default 0,
  items_upserted integer not null default 0,
  items_skipped integer not null default 0,
  items_failed integer not null default 0,
  error_message text,
  metadata jsonb not null default '{}'::jsonb,
  constraint sync_runs_status_valid check (
    status in ('running', 'succeeded', 'failed', 'partial')
  )
);

create index sync_runs_institution_started_idx
on internal.sync_runs (institution_id, started_at desc);

create table internal.sync_errors (
  id uuid primary key default extensions.gen_random_uuid(),
  sync_run_id uuid references internal.sync_runs(id) on delete cascade,
  institution_id text references core.institutions(id) on delete set null,
  source text,
  entity text,
  external_id text,
  message text not null,
  details jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index sync_errors_sync_run_idx
on internal.sync_errors (sync_run_id, created_at desc);

create table internal.raw_payloads (
  id uuid primary key default extensions.gen_random_uuid(),
  sync_run_id uuid references internal.sync_runs(id) on delete set null,
  institution_id text references core.institutions(id) on delete cascade,
  source_type text not null,
  source_external_id text not null,
  entity text not null,
  external_id text,
  payload jsonb not null,
  received_at timestamptz not null default now()
);

create index raw_payloads_lookup_idx
on internal.raw_payloads (
  institution_id,
  source_type,
  source_external_id,
  entity,
  external_id
);

create table internal.checkpoints (
  institution_id text not null references core.institutions(id) on delete cascade,
  source text not null,
  checkpoint jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (institution_id, source)
);

create trigger set_checkpoints_updated_at
before update on internal.checkpoints
for each row execute function core.set_updated_at();

alter table core.institutions enable row level security;
alter table core.news_sources enable row level security;
alter table core.news_items enable row level security;
alter table internal.sync_runs enable row level security;
alter table internal.sync_errors enable row level security;
alter table internal.raw_payloads enable row level security;
alter table internal.checkpoints enable row level security;

create policy "public can read institutions"
on core.institutions
for select
to anon, authenticated
using (true);

create policy "public can read active news sources"
on core.news_sources
for select
to anon, authenticated
using (is_active);

create policy "public can read active-source news items"
on core.news_items
for select
to anon, authenticated
using (
  exists (
    select 1
    from core.news_sources ns
    where ns.id = news_items.source_id
      and ns.is_active
  )
);

grant usage on schema core to anon, authenticated, service_role;
grant select on core.institutions to anon, authenticated;
grant select on core.news_sources to anon, authenticated;
grant select on core.news_items to anon, authenticated;
grant all on all tables in schema core to service_role;
grant usage on schema internal to service_role;
grant all on all tables in schema internal to service_role;

create or replace function app_api_v1.get_news_feed(
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
  select
    ni.id,
    ni.institution_id,
    ni.source_id,
    ni.source_type,
    ni.source_external_id,
    ni.source_name,
    ni.title,
    ni.summary,
    ni.original_url,
    ni.published_at,
    ni.news_blocks,
    ni.news_blocks_version
  from core.news_items ni
  join core.news_sources ns on ns.id = ni.source_id
  where ns.is_active
    and (p_institution_id is null or ni.institution_id = p_institution_id)
  order by ni.published_at desc, ni.created_at desc
  limit least(greatest(coalesce(p_limit, 20), 1), 100)
  offset greatest(coalesce(p_offset, 0), 0);
$$;

create or replace function ingest_v1.upsert_news_items(
  p_institution_id text,
  p_source jsonb,
  p_items jsonb,
  p_sync_run_id uuid default null
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_source_type text := nullif(trim(p_source ->> 'source_type'), '');
  v_source_external_id text := coalesce(
    nullif(trim(p_source ->> 'source_external_id'), ''),
    nullif(trim(p_source ->> 'source_id'), '')
  );
  v_source_name text := coalesce(
    nullif(trim(p_source ->> 'source_name'), ''),
    nullif(trim(p_source ->> 'name'), ''),
    v_source_external_id
  );
  v_source_uuid uuid;
  v_item jsonb;
  v_external_id text;
  v_published_at timestamptz;
  v_news_blocks jsonb;
  v_upserted integer := 0;
  v_skipped integer := 0;
begin
  if nullif(trim(p_institution_id), '') is null then
    raise exception 'p_institution_id is required';
  end if;

  if v_source_type is null then
    raise exception 'p_source.source_type is required';
  end if;

  if v_source_external_id is null then
    raise exception 'p_source.source_id/source_external_id is required';
  end if;

  if jsonb_typeof(p_items) is distinct from 'array' then
    raise exception 'p_items must be a JSON array';
  end if;

  insert into core.institutions (id, name, timezone, metadata)
  values (
    p_institution_id,
    coalesce(nullif(trim(p_source ->> 'institution_name'), ''), p_institution_id),
    coalesce(nullif(trim(p_source ->> 'timezone'), ''), 'UTC'),
    coalesce(p_source -> 'institution_metadata', '{}'::jsonb)
  )
  on conflict (id) do update
  set
    name = excluded.name,
    timezone = excluded.timezone,
    metadata = core.institutions.metadata || excluded.metadata;

  insert into core.news_sources (
    institution_id,
    source_type,
    source_external_id,
    source_name,
    source_url,
    category,
    is_active,
    last_fetched_at,
    metadata
  )
  values (
    p_institution_id,
    v_source_type,
    v_source_external_id,
    v_source_name,
    nullif(trim(p_source ->> 'source_url'), ''),
    nullif(trim(p_source ->> 'category'), ''),
    coalesce((p_source ->> 'is_active')::boolean, true),
    now(),
    coalesce(p_source -> 'metadata', '{}'::jsonb)
  )
  on conflict (institution_id, source_type, source_external_id) do update
  set
    source_name = excluded.source_name,
    source_url = excluded.source_url,
    category = excluded.category,
    is_active = excluded.is_active,
    last_fetched_at = excluded.last_fetched_at,
    metadata = core.news_sources.metadata || excluded.metadata
  returning id into v_source_uuid;

  for v_item in
    select value from jsonb_array_elements(p_items) as item(value)
  loop
    v_external_id := nullif(trim(v_item ->> 'external_id'), '');

    if v_external_id is null then
      v_skipped := v_skipped + 1;

      if p_sync_run_id is not null then
        insert into internal.sync_errors (
          sync_run_id,
          institution_id,
          source,
          entity,
          message,
          details
        )
        values (
          p_sync_run_id,
          p_institution_id,
          v_source_type || ':' || v_source_external_id,
          'news_items',
          'Skipped news item without external_id',
          v_item
        );
      end if;

      continue;
    end if;

    begin
      v_published_at := coalesce(
        nullif(v_item ->> 'published_at', '')::timestamptz,
        now()
      );
    exception when others then
      v_published_at := now();
    end;

    v_news_blocks := case
      when jsonb_typeof(v_item -> 'news_blocks') = 'array'
        then v_item -> 'news_blocks'
      else '[]'::jsonb
    end;

    insert into core.news_items (
      institution_id,
      source_id,
      source_type,
      source_external_id,
      source_name,
      external_id,
      title,
      summary,
      original_url,
      published_at,
      raw_data,
      news_blocks,
      news_blocks_version,
      processed_at,
      metadata
    )
    values (
      p_institution_id,
      v_source_uuid,
      v_source_type,
      v_source_external_id,
      v_source_name,
      v_external_id,
      coalesce(nullif(trim(v_item ->> 'title'), ''), v_source_name),
      nullif(trim(v_item ->> 'summary'), ''),
      nullif(trim(v_item ->> 'original_url'), ''),
      v_published_at,
      coalesce(v_item -> 'raw_data', '{}'::jsonb),
      v_news_blocks,
      coalesce(nullif(trim(v_item ->> 'news_blocks_version'), ''), '1.0.0'),
      now(),
      coalesce(v_item -> 'metadata', '{}'::jsonb)
    )
    on conflict (
      institution_id,
      source_type,
      source_external_id,
      external_id
    ) do update
    set
      source_id = excluded.source_id,
      source_name = excluded.source_name,
      title = excluded.title,
      summary = excluded.summary,
      original_url = excluded.original_url,
      published_at = excluded.published_at,
      raw_data = excluded.raw_data,
      news_blocks = excluded.news_blocks,
      news_blocks_version = excluded.news_blocks_version,
      processed_at = excluded.processed_at,
      metadata = core.news_items.metadata || excluded.metadata;

    insert into internal.raw_payloads (
      sync_run_id,
      institution_id,
      source_type,
      source_external_id,
      entity,
      external_id,
      payload
    )
    values (
      p_sync_run_id,
      p_institution_id,
      v_source_type,
      v_source_external_id,
      'news_items',
      v_external_id,
      v_item
    );

    v_upserted := v_upserted + 1;
  end loop;

  if p_sync_run_id is not null then
    update internal.sync_runs
    set
      items_received = jsonb_array_length(p_items),
      items_upserted = v_upserted,
      items_skipped = v_skipped,
      status = case when v_skipped = 0 then 'succeeded' else 'partial' end,
      finished_at = now()
    where id = p_sync_run_id;
  end if;

  return jsonb_build_object(
    'institution_id', p_institution_id,
    'source_type', v_source_type,
    'source_external_id', v_source_external_id,
    'items_received', jsonb_array_length(p_items),
    'items_upserted', v_upserted,
    'items_skipped', v_skipped
  );
end;
$$;

grant usage on schema app_api_v1 to anon, authenticated, service_role;
revoke execute on function app_api_v1.get_news_feed(text, integer, integer)
from public;
grant execute on function app_api_v1.get_news_feed(text, integer, integer)
to anon, authenticated, service_role;

grant usage on schema ingest_v1 to service_role;
revoke execute on function ingest_v1.upsert_news_items(text, jsonb, jsonb, uuid)
from public;
grant execute on function ingest_v1.upsert_news_items(text, jsonb, jsonb, uuid)
to service_role;
