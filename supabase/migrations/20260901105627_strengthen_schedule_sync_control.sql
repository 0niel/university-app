create or replace function public.ingest_schedule_payload(
  p_organization_id text,
  p_source jsonb,
  p_targets jsonb,
  p_sync_run_id uuid default null
)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_source text := coalesce(
    nullif(btrim(p_source ->> 'source_external_id'), ''),
    nullif(btrim(p_source ->> 'source_id'), '')
  );
  v_result jsonb;
  v_items_upserted integer;
  v_items_skipped integer;
begin
  if p_sync_run_id is null then
    raise exception 'Schedule sync run is required' using errcode = '22023';
  end if;

  perform 1
  from internal.sync_runs sync_run
  where sync_run.id = p_sync_run_id
    and sync_run.organization_id = p_organization_id
    and sync_run.source = v_source
    and sync_run.source_type = 'schedule'
    and sync_run.status = 'running'
  for update;

  if not found then
    raise exception 'Schedule sync run does not match this source'
      using errcode = '42501';
  end if;

  v_result := ingest_v1.upsert_schedule_payload(
    p_organization_id,
    p_source,
    p_targets,
    p_sync_run_id
  );

  if v_result ? 'error' then
    raise exception '%', v_result ->> 'error' using errcode = '22023';
  end if;

  v_items_upserted := coalesce((v_result ->> 'items_upserted')::integer, 0);
  v_items_skipped := coalesce((v_result ->> 'items_skipped')::integer, 0);

  update internal.sync_runs
  set
    items_received = items_received + v_items_upserted + v_items_skipped,
    items_upserted = items_upserted + v_items_upserted,
    items_skipped = items_skipped + v_items_skipped
  where id = p_sync_run_id
    and status = 'running';

  if not found then
    raise exception 'Schedule sync run is no longer active'
      using errcode = '55000';
  end if;

  return v_result;
end;
$$;

revoke all on function public.ingest_schedule_payload(text, jsonb, jsonb, uuid)
from public, anon, authenticated;

grant execute on function public.ingest_schedule_payload(text, jsonb, jsonb, uuid)
to service_role;
