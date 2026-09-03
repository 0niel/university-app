begin;

do $$
declare
  v_rpc text;
  v_definition text;
begin
  if to_regclass('core.search_query_events') is null then
    raise exception 'Missing search query events table';
  end if;

  if not exists (
    select 1
    from pg_class relation
    where relation.oid = 'core.search_query_events'::regclass
      and relation.relrowsecurity
  ) then
    raise exception 'RLS is disabled for search query events';
  end if;

  if has_table_privilege(
    'authenticated',
    'core.search_query_events',
    'SELECT'
  ) or has_table_privilege(
    'authenticated',
    'core.search_query_events',
    'INSERT'
  ) then
    raise exception 'Search events are directly exposed to clients';
  end if;

  foreach v_rpc in array array[
    'public.get_group_space(text)',
    'public.get_group_notes(text)',
    'public.create_group_note(text,text,text)',
    'public.search_group_posts(text)',
    'public.log_search_query(text)',
    'public.trending_searches()'
  ]
  loop
    if to_regprocedure(v_rpc) is null then
      raise exception 'Missing RPC: %', v_rpc;
    end if;
    if has_function_privilege('anon', v_rpc, 'EXECUTE') then
      raise exception 'Anonymous role can execute: %', v_rpc;
    end if;
    if not has_function_privilege('authenticated', v_rpc, 'EXECUTE') then
      raise exception 'Authenticated role cannot execute: %', v_rpc;
    end if;
    if (
      select function_row.prosecdef
      from pg_proc function_row
      where function_row.oid = to_regprocedure(v_rpc)
    ) then
      raise exception 'Public wrapper is security definer: %', v_rpc;
    end if;
  end loop;

  if to_regprocedure('public.create_group_note(text,text)') is not null then
    raise exception 'Legacy create_group_note overload is still exposed';
  end if;
  if to_regprocedure('app_api_v1.create_group_note(text,text)') is not null then
    raise exception 'Legacy internal create_group_note overload still exists';
  end if;

  foreach v_rpc in array array[
    'app_api_v1.get_group_space(text)',
    'app_api_v1.get_group_notes(text)',
    'app_api_v1.search_group_posts(text)',
    'app_api_v1.log_search_query(text)',
    'app_api_v1.trending_searches()'
  ]
  loop
    if to_regprocedure(v_rpc) is null then
      raise exception 'Missing internal RPC: %', v_rpc;
    end if;
    if has_function_privilege('anon', v_rpc, 'EXECUTE') then
      raise exception 'Anonymous role can execute internal RPC: %', v_rpc;
    end if;
    if not (
      select function_row.prosecdef
      from pg_proc function_row
      where function_row.oid = to_regprocedure(v_rpc)
    ) then
      raise exception 'Internal read RPC must enforce scope: %', v_rpc;
    end if;
  end loop;

  v_definition := pg_get_functiondef(
    to_regprocedure('app_api_v1.get_group_space(text)')
  );
  if position('''isOwner''' in v_definition) = 0
    or position('''emoji''' in v_definition) = 0
    or position('link.group_id = v_group_id' in v_definition) = 0
    or position('post.group_id = v_group_id' in v_definition) = 0 then
    raise exception 'Group-space RPC does not use stable study-group scope';
  end if;

  v_definition := pg_get_functiondef(
    to_regprocedure('app_api_v1.get_group_notes(text)')
  );
  if position('''isPersonal''' in v_definition) = 0
    or position('note.visibility' in v_definition) = 0
    or position('note.organization_id = p_organization_id' in v_definition) = 0
    or position('core.can_edit_group_note(note.id, v_user_id)' in v_definition) = 0 then
    raise exception 'Group-notes RPC does not preserve visibility scope';
  end if;

  v_definition := pg_get_functiondef(
    to_regprocedure('core.can_edit_group_note(uuid,uuid)')
  );
  if v_definition is null
    or position('note.visibility = ''personal''' in v_definition) = 0
    or position('note.owner_id = p_user_id' in v_definition) = 0
    or position('membership.group_id = note.group_id' in v_definition) = 0
    or position('group_row.organization_id = note.organization_id' in v_definition) = 0
    or position('profile.organization_id = note.organization_id' in v_definition) = 0
    or position('profile.academic_group = note.academic_group' in v_definition) = 0 then
    raise exception 'Group-note helper does not preserve ownership and group scope';
  end if;

  v_definition := pg_get_functiondef(
    to_regprocedure('app_api_v1.search_group_posts(text)')
  );
  if position('post.organization_id = v_organization_id' in v_definition) = 0
  then
    raise exception 'Group-post search is not organization scoped';
  end if;

  v_definition := pg_get_functiondef(
    to_regprocedure('app_api_v1.trending_searches()')
  );
  if position(
    'count(distinct event.user_id) >= 3' in v_definition
  ) = 0 then
    raise exception 'Trending searches lack a privacy cohort threshold';
  end if;

  if has_table_privilege('authenticated', 'core.teams', 'INSERT')
    or has_table_privilege('authenticated', 'core.teams', 'UPDATE')
    or has_table_privilege('authenticated', 'core.teams', 'DELETE')
    or has_table_privilege('authenticated', 'core.team_members', 'INSERT')
    or has_table_privilege(
      'authenticated', 'core.team_applications', 'INSERT'
    ) then
    raise exception 'Team mutations bypass the guarded RPC contract';
  end if;

  foreach v_rpc in array array[
    'public.get_teams(text)',
    'public.create_team(text,text,text,text,text[],integer,text,timestamptz,boolean)',
    'public.apply_to_team(uuid,text,text,boolean)',
    'public.set_team_membership(uuid,boolean)',
    'public.delete_team(uuid)',
    'public.delete_team_application(uuid)'
  ]
  loop
    if to_regprocedure(v_rpc) is null then
      raise exception 'Missing guarded team RPC: %', v_rpc;
    end if;
    if not (
      select function_row.prosecdef
      from pg_proc function_row
      where function_row.oid = to_regprocedure(v_rpc)
    ) then
      raise exception 'Team RPC does not enforce tenant scope: %', v_rpc;
    end if;
  end loop;

  foreach v_rpc in array array[
    'app_api_v1.get_teams(text)',
    'app_api_v1.create_team(text,text,text,text,text[],integer,text,timestamptz,boolean)',
    'app_api_v1.apply_to_team(uuid,text,text,boolean)',
    'app_api_v1.set_team_membership(uuid,boolean)'
  ]
  loop
    if has_function_privilege('authenticated', v_rpc, 'EXECUTE') then
      raise exception 'Internal team RPC is client-executable: %', v_rpc;
    end if;
  end loop;

  if not exists (
    select 1
    from pg_constraint constraint_row
    where constraint_row.conrelid = 'core.search_query_events'::regclass
      and constraint_row.conname = 'search_query_events_daily_unique'
      and constraint_row.contype = 'u'
  ) then
    raise exception 'Search event daily deduplication is missing';
  end if;
end;
$$;

rollback;
