begin;

set local statement_timeout = '20s';
set local lock_timeout = '5s';

do $$
declare
  v_run_id uuid;
  v_parts jsonb;
  v_result jsonb;
  v_flags_before jsonb;
  v_flags_after jsonb;
  v_count integer;
begin
  if core.term_for_date('mirea', '2027-01-31') is distinct from 20262
    or core.term_for_date('mirea', '2027-02-01') is distinct from 20271
    or core.term_for_date('mirea', '2027-02-03') is distinct from 20271
    or core.term_for_date('mirea', '2027-08-31') is distinct from 20271
    or core.term_for_date('mirea', '2027-09-01') is not distinct from 20271 then
    raise exception 'Spring 2027 schedule term boundaries are invalid';
  end if;
  if not exists (
    select 1 from core.term
    where id = 20271 and organization_id = 'mirea'
      and not is_current and not changes_active
  ) then
    raise exception 'A future schedule term was activated before its baseline';
  end if;
  if not exists (
    select 1 from pg_catalog.pg_inherits
    where inhrelid = 'core.schedule_item_occurrence_2027s'::regclass
      and inhparent = 'core.schedule_item_occurrence'::regclass
  ) or not exists (
    select 1 from pg_catalog.pg_inherits
    where inhrelid = 'core.schedule_item_change_2027s'::regclass
      and inhparent = 'core.schedule_item_change'::regclass
  ) then
    raise exception 'Spring 2027 schedule partitions are missing';
  end if;
  select jsonb_object_agg(id::text, jsonb_build_array(is_current, changes_active))
  into v_flags_before from core.term where organization_id = 'mirea';

  insert into internal.sync_runs (organization_id, source, source_type)
  values ('mirea', 'spring-2027-contract', 'schedule')
  returning id into v_run_id;
  select jsonb_agg(jsonb_build_object(
    'uid', 'spring-2027-contract-' || n,
    'part_type', 'lesson',
    'subject', 'Spring 2027 contract',
    'dates', jsonb_build_array('03-02-2027'),
    'lesson_bells', jsonb_build_object(
      'number', n, 'start_time', '09:00', 'end_time', '10:30'
    )
  )) into v_parts from generate_series(1, 3) n;

  v_result := public.ingest_schedule_payload(
    'mirea',
    '{"source_external_id":"spring-2027-contract"}'::jsonb,
    jsonb_build_array(jsonb_build_object(
      'target_type', 'group', 'external_id', 'spring-2027-contract',
      'target_title', 'Spring 2027 contract', 'full_replace', false,
      'parts', v_parts
    )),
    v_run_id
  );
  if (v_result ->> 'items_skipped')::integer is distinct from 0
    or (v_result ->> 'items_upserted')::integer is distinct from 3
    or (v_result ->> 'occurrences_upserted')::integer is distinct from 3 then
    raise exception 'Future schedule lessons were skipped: %', v_result;
  end if;
  select count(*) into v_count
  from core.schedule_item_occurrence occurrence
  join core.schedule_item item on item.id = occurrence.item_id
  where item.organization_id = 'mirea'
    and item.source_uid in (
      'spring-2027-contract-1', 'spring-2027-contract-2', 'spring-2027-contract-3'
    )
    and occurrence.term_id = 20271
    and occurrence.lesson_date = date '2027-02-03'
    and occurrence.tableoid = 'core.schedule_item_occurrence_2027s'::regclass;
  if v_count <> 3 then
    raise exception 'Future schedule occurrences did not reach their partition';
  end if;
  if exists (
    select 1 from core.schedule_item_change
    where organization_id = 'mirea' and source_uid in (
      'spring-2027-contract-1', 'spring-2027-contract-2', 'spring-2027-contract-3'
    )
  ) then
    raise exception 'Future baseline ingest emitted schedule notifications';
  end if;
  select jsonb_object_agg(id::text, jsonb_build_array(is_current, changes_active))
  into v_flags_after from core.term where organization_id = 'mirea';
  if v_flags_after is distinct from v_flags_before then
    raise exception 'Future lesson ingestion changed schedule activation flags';
  end if;
end;
$$;

rollback;
