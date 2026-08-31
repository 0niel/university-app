alter table internal.raw_payloads
add column if not exists payload_hash text generated always as (
  encode(extensions.digest(payload::text, 'sha256'), 'hex')
) stored;

with ranked as (
  select
    id,
    row_number() over (
      partition by
        organization_id,
        source_type,
        source_external_id,
        entity,
        external_id,
        payload_hash
      order by received_at desc, id desc
    ) as position
  from internal.raw_payloads
  where external_id is not null
)
delete from internal.raw_payloads payload
using ranked
where payload.id = ranked.id
  and ranked.position > 1;

create unique index if not exists raw_payloads_item_unique_idx
on internal.raw_payloads (
  organization_id,
  source_type,
  source_external_id,
  entity,
  external_id,
  payload_hash
)
where external_id is not null;

create or replace function internal.reconcile_raw_payload()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.sync_run_id is null then
    begin
      new.sync_run_id := nullif(
        current_setting('app.sync_run_id', true),
        ''
      )::uuid;
    exception
      when invalid_text_representation then
        raise exception 'Invalid synchronization run context' using errcode = '22023';
    end;
  end if;

  if new.external_id is null then
    return new;
  end if;

  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(
      concat_ws(
        ':',
        new.organization_id,
        new.source_type,
        new.source_external_id,
        new.entity,
        new.external_id,
        new.payload::text
      ),
      0
    )
  );

  update internal.raw_payloads payload
  set
    sync_run_id = new.sync_run_id,
    payload = new.payload,
    received_at = new.received_at
  where payload.organization_id = new.organization_id
    and payload.source_type = new.source_type
    and payload.source_external_id = new.source_external_id
    and payload.entity = new.entity
    and payload.external_id = new.external_id
    and payload.payload = new.payload;

  return case when found then null else new end;
end;
$$;

drop trigger if exists reconcile_raw_payload
on internal.raw_payloads;
create trigger reconcile_raw_payload
before insert on internal.raw_payloads
for each row execute function internal.reconcile_raw_payload();

revoke all on function internal.reconcile_raw_payload()
from public, anon, authenticated;

create or replace function core.preserve_organization_identity_on_ingest()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if current_setting('app.content_ingest', true) = 'true' then
    new.name = old.name;
    new.timezone = old.timezone;
    new.metadata = old.metadata;
  end if;
  return new;
end;
$$;

drop trigger if exists preserve_organization_identity_on_ingest
on core.organizations;
create trigger preserve_organization_identity_on_ingest
before update on core.organizations
for each row execute function core.preserve_organization_identity_on_ingest();

with ranked as (
  select
    id,
    row_number() over (
      partition by organization_id, source
      order by started_at desc, id desc
    ) as position
  from internal.sync_runs
  where status = 'running'
)
update internal.sync_runs sync_run
set
  status = 'failed',
  finished_at = now(),
  error_message = 'Superseded during checkpoint migration'
from ranked
where sync_run.id = ranked.id
  and ranked.position > 1;

create unique index if not exists sync_runs_one_running_source_idx
on internal.sync_runs (organization_id, source)
where status = 'running';

create or replace function ingest_v1.begin_content_sync(
  p_organization_id text,
  p_source text,
  p_source_type text,
  p_metadata jsonb default '{}'::jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_source text := nullif(btrim(p_source), '');
  v_source_type text := nullif(btrim(p_source_type), '');
  v_sync_run_id uuid;
  v_checkpoint jsonb;
begin
  if nullif(btrim(p_organization_id), '') is null
    or v_source is null
    or v_source_type is null then
    raise exception 'Organization, source and source type are required'
      using errcode = '22023';
  end if;
  if length(v_source) > 300 or length(v_source_type) > 100 then
    raise exception 'Sync source is too long' using errcode = '22023';
  end if;
  if jsonb_typeof(coalesce(p_metadata, '{}'::jsonb)) <> 'object' then
    raise exception 'Sync metadata must be an object' using errcode = '22023';
  end if;

  insert into core.organizations (id, name, timezone, metadata)
  values (p_organization_id, p_organization_id, 'UTC', '{}'::jsonb)
  on conflict (id) do nothing;

  update internal.sync_runs
  set
    status = 'failed',
    finished_at = now(),
    error_message = 'Stale synchronization lease expired'
  where organization_id = p_organization_id
    and source = v_source
    and status = 'running'
    and started_at < now() - interval '1 hour';

  if exists (
    select 1
    from internal.sync_runs sync_run
    where sync_run.organization_id = p_organization_id
      and sync_run.source = v_source
      and sync_run.status = 'running'
  ) then
    raise exception 'Synchronization is already running'
      using errcode = '55000';
  end if;

  insert into internal.sync_runs (
    organization_id,
    source,
    source_type,
    metadata
  )
  values (
    p_organization_id,
    v_source,
    v_source_type,
    coalesce(p_metadata, '{}'::jsonb)
  )
  returning id into v_sync_run_id;

  select checkpoint.checkpoint
  into v_checkpoint
  from internal.checkpoints checkpoint
  where checkpoint.organization_id = p_organization_id
    and checkpoint.source = v_source;

  return jsonb_build_object(
    'sync_run_id', v_sync_run_id,
    'checkpoint', coalesce(v_checkpoint, '{}'::jsonb)
  );
end;
$$;

create or replace function ingest_v1.finish_content_sync(
  p_organization_id text,
  p_sync_run_id uuid,
  p_status text,
  p_checkpoint jsonb default null,
  p_error_message text default null,
  p_metadata jsonb default '{}'::jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_status text := lower(btrim(coalesce(p_status, '')));
  v_source text;
  v_current_status text;
  v_items_skipped integer;
  v_items_failed integer;
begin
  if v_status not in ('succeeded', 'failed', 'partial') then
    raise exception 'Invalid sync status' using errcode = '22023';
  end if;
  if jsonb_typeof(coalesce(p_metadata, '{}'::jsonb)) <> 'object' then
    raise exception 'Sync metadata must be an object' using errcode = '22023';
  end if;
  if v_status = 'succeeded'
    and jsonb_typeof(coalesce(p_checkpoint, '{}'::jsonb)) <> 'object' then
    raise exception 'Sync checkpoint must be an object' using errcode = '22023';
  end if;

  select
    sync_run.source,
    sync_run.status,
    sync_run.items_skipped,
    sync_run.items_failed
  into
    v_source,
    v_current_status,
    v_items_skipped,
    v_items_failed
  from internal.sync_runs sync_run
  where sync_run.id = p_sync_run_id
    and sync_run.organization_id = p_organization_id
  for update;

  if not found then
    raise exception 'Sync run not found' using errcode = 'P0002';
  end if;

  if v_status = 'failed' and v_current_status in ('succeeded', 'failed') then
    return jsonb_build_object(
      'sync_run_id', p_sync_run_id,
      'status', v_current_status,
      'checkpoint_advanced', false
    );
  end if;
  if v_status = 'succeeded' and v_current_status in ('failed', 'partial') then
    raise exception 'Unsuccessful synchronization cannot be completed'
      using errcode = '55000';
  end if;
  if v_status = 'succeeded'
    and (v_items_skipped > 0 or v_items_failed > 0) then
    raise exception 'Incomplete synchronization cannot advance a checkpoint'
      using errcode = '55000';
  end if;

  update internal.sync_runs
  set
    status = v_status,
    finished_at = now(),
    error_message = case
      when v_status = 'succeeded' then null
      else left(nullif(btrim(p_error_message), ''), 2000)
    end,
    metadata = internal.sync_runs.metadata || coalesce(p_metadata, '{}'::jsonb)
  where id = p_sync_run_id;

  if v_status = 'failed' then
    insert into internal.sync_errors (
      sync_run_id,
      organization_id,
      source,
      entity,
      message
    )
    values (
      p_sync_run_id,
      p_organization_id,
      v_source,
      'sync',
      coalesce(
        left(nullif(btrim(p_error_message), ''), 2000),
        'Content synchronization failed'
      )
    );
  elsif v_status = 'succeeded' then
    insert into internal.checkpoints (organization_id, source, checkpoint)
    values (
      p_organization_id,
      v_source,
      coalesce(p_checkpoint, '{}'::jsonb)
    )
    on conflict (organization_id, source) do update
    set checkpoint = excluded.checkpoint;
  end if;

  return jsonb_build_object(
    'sync_run_id', p_sync_run_id,
    'status', v_status,
    'checkpoint_advanced', v_status = 'succeeded'
  );
end;
$$;

create or replace function public.begin_content_sync(
  p_organization_id text,
  p_source text,
  p_source_type text,
  p_metadata jsonb default '{}'::jsonb
)
returns jsonb
language sql
security invoker
set search_path = ''
as $$
  select ingest_v1.begin_content_sync(
    p_organization_id,
    p_source,
    p_source_type,
    p_metadata
  );
$$;

create or replace function public.finish_content_sync(
  p_organization_id text,
  p_sync_run_id uuid,
  p_status text,
  p_checkpoint jsonb default null,
  p_error_message text default null,
  p_metadata jsonb default '{}'::jsonb
)
returns jsonb
language sql
security invoker
set search_path = ''
as $$
  select ingest_v1.finish_content_sync(
    p_organization_id,
    p_sync_run_id,
    p_status,
    p_checkpoint,
    p_error_message,
    p_metadata
  );
$$;

create or replace function public.ingest_news_items(
  p_organization_id text,
  p_source jsonb,
  p_items jsonb,
  p_sync_run_id uuid default null
)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_source text := nullif(btrim(p_source ->> 'source_type'), '')
    || ':'
    || coalesce(
      nullif(btrim(p_source ->> 'source_external_id'), ''),
      nullif(btrim(p_source ->> 'source_id'), '')
    );
  v_result jsonb;
begin
  if p_sync_run_id is not null and not exists (
    select 1
    from internal.sync_runs sync_run
    where sync_run.id = p_sync_run_id
      and sync_run.organization_id = p_organization_id
      and sync_run.source = v_source
      and sync_run.status = 'running'
  ) then
    raise exception 'Sync run does not match this source'
      using errcode = '42501';
  end if;

  perform set_config('app.content_ingest', 'true', true);
  if p_sync_run_id is not null then
    perform set_config('app.sync_run_id', p_sync_run_id::text, true);
  end if;

  v_result := ingest_v1.upsert_news_items(
    p_organization_id,
    p_source,
    p_items,
    null
  );

  if p_sync_run_id is not null then
    update internal.sync_runs
    set
      items_received = coalesce((v_result ->> 'items_received')::integer, 0),
      items_upserted = coalesce((v_result ->> 'items_upserted')::integer, 0),
      items_skipped = coalesce((v_result ->> 'items_skipped')::integer, 0),
      items_failed = 0
    where id = p_sync_run_id
      and status = 'running';
  end if;

  return v_result;
end;
$$;

create or replace function internal.prune_content_sync_history(
  p_raw_before timestamptz default now() - interval '90 days',
  p_runs_before timestamptz default now() - interval '180 days'
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_raw_deleted integer;
  v_runs_deleted integer;
begin
  delete from internal.raw_payloads
  where received_at < p_raw_before;
  get diagnostics v_raw_deleted = row_count;

  delete from internal.sync_runs
  where status <> 'running'
    and finished_at < p_runs_before;
  get diagnostics v_runs_deleted = row_count;

  return jsonb_build_object(
    'raw_payloads_deleted', v_raw_deleted,
    'sync_runs_deleted', v_runs_deleted
  );
end;
$$;

create index if not exists raw_payloads_retention_idx
on internal.raw_payloads (received_at);

create index if not exists sync_runs_retention_idx
on internal.sync_runs (finished_at)
where status <> 'running';

revoke all on function internal.prune_content_sync_history(
  timestamptz,
  timestamptz
) from public, anon, authenticated;
grant execute on function internal.prune_content_sync_history(
  timestamptz,
  timestamptz
) to service_role;

do $$
begin
  perform cron.schedule(
    'prune-content-sync-history',
    '17 3 * * *',
    'select internal.prune_content_sync_history()'
  );
exception
  when others then
    raise notice 'pg_cron unavailable, skipping content sync history pruning';
end;
$$;

revoke all on function ingest_v1.begin_content_sync(
  text,
  text,
  text,
  jsonb
) from public, anon, authenticated;
grant execute on function ingest_v1.begin_content_sync(
  text,
  text,
  text,
  jsonb
) to service_role;

revoke all on function ingest_v1.finish_content_sync(
  text,
  uuid,
  text,
  jsonb,
  text,
  jsonb
) from public, anon, authenticated;
grant execute on function ingest_v1.finish_content_sync(
  text,
  uuid,
  text,
  jsonb,
  text,
  jsonb
) to service_role;

revoke all on function public.begin_content_sync(
  text,
  text,
  text,
  jsonb
) from public, anon, authenticated;
grant execute on function public.begin_content_sync(
  text,
  text,
  text,
  jsonb
) to service_role;

revoke all on function public.finish_content_sync(
  text,
  uuid,
  text,
  jsonb,
  text,
  jsonb
) from public, anon, authenticated;
grant execute on function public.finish_content_sync(
  text,
  uuid,
  text,
  jsonb,
  text,
  jsonb
) to service_role;

revoke all on function public.ingest_news_items(
  text,
  jsonb,
  jsonb,
  uuid
) from public, anon, authenticated;
grant execute on function public.ingest_news_items(
  text,
  jsonb,
  jsonb,
  uuid
) to service_role;
