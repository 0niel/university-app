begin;

do $$
declare
  v_formatted jsonb;
  v_compact jsonb;
  v_ids text[];
  v_rpc text;
begin
  foreach v_rpc in array array[
    'app_api_v1.search_schedule_targets(text,text,text,integer)',
    'public.search_schedule_targets(text,text,text,integer)'
  ] loop
    if not has_function_privilege('anon', v_rpc, 'EXECUTE')
      or not has_function_privilege('authenticated', v_rpc, 'EXECUTE') then
      raise exception 'Schedule search grants changed for %', v_rpc;
    end if;
  end loop;

  insert into core.organizations (id, name) values
    ('schedule-search-contract', 'Schedule Search Contract'),
    ('schedule-search-other', 'Schedule Search Other');
  insert into core.schedule_targets (
    organization_id, target_type, external_id, target_title,
    full_title, is_active, source_links
  ) values
    ('schedule-search-contract', 'group', 'exact', 'ХЕБО-06-24',
      'ХЕБО-06-24', true, '{"ui":"https://example.invalid/schedule"}'),
    ('schedule-search-contract', 'group', 'prefix', 'ХЕБО-06-24-1',
      'ХЕБО-06-24-1', true, '{}'),
    ('schedule-search-contract', 'group', 'contains', 'А-ХЕБО-06-24',
      'А-ХЕБО-06-24', true, '{}'),
    ('schedule-search-contract', 'group', 'inactive', 'ХЕБО-06-24',
      'ХЕБО-06-24', false, '{}'),
    ('schedule-search-contract', 'teacher', 'teacher', 'ХЕБО-06-24',
      'ХЕБО-06-24', true, '{}'),
    ('schedule-search-other', 'group', 'other', 'ХЕБО-06-24',
      'ХЕБО-06-24', true, '{}'),
    ('schedule-search-contract', 'teacher', 'teacher-yo', 'Фёдоров И. И.',
      'Фёдоров Иван Иванович', true, '{}');

  select jsonb_agg(to_jsonb(result) - 'ordinality' order by result.ordinality)
  into v_formatted
  from public.search_schedule_targets(
    'group', 'ХЕБО-06-24', 'schedule-search-contract', 20
  ) with ordinality result;
  select jsonb_agg(to_jsonb(result) - 'ordinality' order by result.ordinality),
    array_agg(result.external_id order by result.ordinality)
  into v_compact, v_ids
  from public.search_schedule_targets(
    'group', 'хебо0624', 'schedule-search-contract', 20
  ) with ordinality result;

  if v_formatted is distinct from v_compact
    or v_ids is distinct from array['exact', 'prefix', 'contains'] then
    raise exception 'Normalized schedule search differs or ranking is invalid';
  end if;
  if v_compact -> 0 -> 'source_links' is distinct from
    '{"ui":"https://example.invalid/schedule"}'::jsonb then
    raise exception 'Schedule source links were lost';
  end if;

  select array_agg(result.external_id order by result.ordinality)
  into v_ids
  from public.search_schedule_targets(
    'teacher', 'федоровии', 'schedule-search-contract', 20
  ) with ordinality result;
  if v_ids is distinct from array['teacher-yo'] then
    raise exception 'Schedule search did not normalize the letter yo';
  end if;

  select array_agg(result.external_id order by result.ordinality)
  into v_ids
  from public.search_schedule_targets(
    'group', 'EXACT', 'schedule-search-contract', 1
  ) with ordinality result;
  if v_ids is distinct from array['exact'] then
    raise exception 'Schedule external identifier lookup failed';
  end if;
end;
$$;

rollback;
