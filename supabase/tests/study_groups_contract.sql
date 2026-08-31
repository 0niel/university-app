begin;

do $$
declare
  v_table text;
  v_rpc text;
begin
  foreach v_table in array array[
    'core.study_groups',
    'core.study_group_members',
    'core.study_group_invites'
  ]
  loop
    if to_regclass(v_table) is null then
      raise exception 'Missing relation: %', v_table;
    end if;

    if not exists (
      select 1
      from pg_class c
      where c.oid = to_regclass(v_table)
        and c.relrowsecurity
    ) then
      raise exception 'RLS is disabled for: %', v_table;
    end if;
  end loop;

  foreach v_rpc in array array[
    'public.get_my_study_group(text)',
    'public.create_study_group(text,text,text,text,boolean)',
    'public.update_study_group(text,text,text,text,boolean)',
    'public.delete_study_group(text)',
    'public.leave_study_group()',
    'public.invite_to_study_group(uuid)',
    'public.invite_to_study_group_by_handle(text)',
    'public.respond_group_invite(uuid,boolean)',
    'public.join_group_by_code(text,text)',
    'public.request_to_join_group(uuid)',
    'public.respond_join_request(uuid,boolean)',
    'public.remove_group_member(uuid)',
    'public.get_my_group_invites()',
    'public.search_study_groups(text,text)'
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
  end loop;

  if to_regprocedure('core.current_study_group_id()') is null
    or to_regprocedure('core.current_study_group_organization_id()') is null
    or to_regprocedure('core.gen_group_join_code()') is null then
    raise exception 'Missing study-group helper functions';
  end if;

  if has_function_privilege(
    'authenticated',
    'core.current_study_group_organization_id()',
    'EXECUTE'
  ) then
    raise exception 'Study-group organization helper is client-executable';
  end if;

  if has_function_privilege(
    'authenticated',
    'app_api_v1.get_my_study_group(text)',
    'EXECUTE'
  ) then
    raise exception 'Unguarded study-group lookup is client-executable';
  end if;

  if position(
    'study_group_organization_mismatch' in pg_get_functiondef(
      'public.get_my_study_group(text)'::regprocedure
    )
  ) = 0 or position(
    'study_group_organization_mismatch' in pg_get_functiondef(
      'app_api_v1.create_study_group(text,text,text,text,boolean)'::regprocedure
    )
  ) = 0 or position(
    'pg_advisory_xact_lock' in pg_get_functiondef(
      'app_api_v1.create_study_group(text,text,text,text,boolean)'::regprocedure
    )
  ) = 0 then
    raise exception 'Study-group organization mismatch is not guarded';
  end if;

  if has_column_privilege(
    'authenticated',
    'core.study_groups',
    'join_code',
    'SELECT'
  ) then
    raise exception 'Join codes are directly readable';
  end if;

  if not has_column_privilege(
    'authenticated',
    'core.study_groups',
    'id',
    'SELECT'
  ) then
    raise exception 'Community RPCs cannot resolve study group ids';
  end if;

  if not exists (
    select 1
    from pg_attribute
    where attrelid = 'core.group_posts'::regclass
      and attname = 'group_id'
      and not attisdropped
  ) or not exists (
    select 1
    from pg_attribute
    where attrelid = 'core.group_links'::regclass
      and attname = 'group_id'
      and not attisdropped
  ) or not exists (
    select 1
    from pg_attribute
    where attrelid = 'core.group_notes'::regclass
      and attname = 'group_id'
      and not attisdropped
  ) then
    raise exception 'Community content is not linked to study groups';
  end if;
end;
$$;

do $$
declare
  v_same_org_user uuid := extensions.gen_random_uuid();
  v_mismatched_user uuid := extensions.gen_random_uuid();
  v_first_result jsonb;
  v_second_result jsonb;
  v_group_result jsonb;
  v_group_id uuid;
begin
  insert into core.organizations (id, name)
  values
    ('study-groups-contract-a', 'Study Groups Contract A'),
    ('study-groups-contract-b', 'Study Groups Contract B');

  insert into auth.users (id)
  values (v_same_org_user), (v_mismatched_user);

  insert into core.user_academic_profiles (
    user_id,
    organization_id,
    academic_group
  )
  values
    (v_same_org_user, 'study-groups-contract-a', 'GROUP-A'),
    (v_mismatched_user, 'study-groups-contract-b', 'GROUP-B');

  perform set_config('request.jwt.claim.role', 'authenticated', true);
  perform set_config(
    'request.jwt.claim.sub',
    v_same_org_user::text,
    true
  );
  execute 'set local role authenticated';
  v_first_result := public.create_study_group(
    'study-groups-contract-a',
    'First group'
  );
  v_second_result := public.create_study_group(
    'study-groups-contract-a',
    'Duplicate request'
  );
  v_group_result := public.get_my_study_group(
    'study-groups-contract-a'
  );
  execute 'reset role';

  v_group_id := (v_first_result -> 'group' ->> 'id')::uuid;
  if v_group_id is null
    or (v_second_result -> 'group' ->> 'id')::uuid <> v_group_id
    or (v_group_result -> 'group' ->> 'id')::uuid <> v_group_id
    or not coalesce((v_group_result ->> 'hasGroup')::boolean, false)
    or (
      select count(*)
      from core.study_groups study_group
      where study_group.owner_id = v_same_org_user
    ) <> 1
    or (
      select count(*)
      from core.study_group_members membership
      where membership.user_id = v_same_org_user
    ) <> 1 then
    raise exception 'Study-group creation is not idempotent';
  end if;

  perform set_config(
    'request.jwt.claim.sub',
    v_mismatched_user::text,
    true
  );
  execute 'set local role authenticated';
  perform public.create_study_group(
    'study-groups-contract-b',
    'Legacy group'
  );
  execute 'reset role';

  update core.user_academic_profiles
  set organization_id = 'study-groups-contract-a'
  where user_id = v_mismatched_user;

  execute 'set local role authenticated';
  begin
    perform app_api_v1.get_my_study_group(
      'study-groups-contract-a'
    );
    raise exception 'Unguarded study-group lookup was exposed';
  exception
    when insufficient_privilege then null;
  end;
  begin
    perform public.get_my_study_group('study-groups-contract-a');
    raise exception 'Cross-organization membership was hidden';
  exception
    when raise_exception then
      if sqlerrm <> 'study_group_organization_mismatch' then
        raise;
      end if;
  end;
  begin
    perform public.create_study_group(
      'study-groups-contract-a',
      'Conflicting group'
    );
    raise exception 'Cross-organization duplicate group was created';
  exception
    when raise_exception then
      if sqlerrm <> 'study_group_organization_mismatch' then
        raise;
      end if;
  end;
  execute 'reset role';
end;
$$;

rollback;
