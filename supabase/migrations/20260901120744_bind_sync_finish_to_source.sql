create or replace function public.finish_content_sync(
  p_organization_id text,
  p_sync_run_id uuid,
  p_status text,
  p_checkpoint jsonb default null,
  p_error_message text default null,
  p_metadata jsonb default '{}'::jsonb
)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if exists (
    select 1
    from internal.sync_runs
    where id = p_sync_run_id
      and organization_id = p_organization_id
      and source_type = 'schedule'
  ) then
    raise exception 'Schedule sync source is required' using errcode = '22023';
  end if;
  return ingest_v1.finish_content_sync(
    p_organization_id,
    p_sync_run_id,
    p_status,
    p_checkpoint,
    p_error_message,
    p_metadata
  );
end;
$$;

create or replace function public.finish_content_sync(
  p_organization_id text,
  p_sync_run_id uuid,
  p_source text,
  p_source_type text,
  p_status text,
  p_checkpoint jsonb default null,
  p_error_message text default null,
  p_metadata jsonb default '{}'::jsonb
)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_target_hashes jsonb;
  v_target_count integer;
  v_result jsonb;
begin
  if not exists (
    select 1
    from internal.sync_runs
    where id = p_sync_run_id
      and organization_id = p_organization_id
      and source = p_source
      and source_type = p_source_type
  ) then
    raise exception 'Sync run source mismatch' using errcode = 'P0002';
  end if;
  if p_source_type = 'schedule' and lower(btrim(p_status)) = 'succeeded' then
    v_target_hashes := p_checkpoint -> 'target_hashes';
    if jsonb_typeof(v_target_hashes) is distinct from 'object' then
      raise exception 'Schedule target checkpoint is missing';
    end if;
    select count(*)
    into v_target_count
    from jsonb_object_keys(v_target_hashes);
    if v_target_count < 2400 then
      raise exception 'Schedule target checkpoint is incomplete: %', v_target_count;
    end if;
  end if;
  v_result := ingest_v1.finish_content_sync(
    p_organization_id,
    p_sync_run_id,
    p_status,
    p_checkpoint,
    p_error_message,
    p_metadata
  );
  if p_source_type = 'schedule' and lower(btrim(p_status)) = 'succeeded' then
    update core.schedule_targets
    set is_active = false
    where organization_id = p_organization_id
      and is_active
      and not (v_target_hashes ? (target_type || ':' || external_id));
  end if;
  return v_result;
end;
$$;

revoke all on function public.finish_content_sync(
  text,
  uuid,
  text,
  text,
  text,
  jsonb,
  text,
  jsonb
) from public, anon, authenticated;

grant execute on function public.finish_content_sync(
  text,
  uuid,
  text,
  text,
  text,
  jsonb,
  text,
  jsonb
) to service_role;
