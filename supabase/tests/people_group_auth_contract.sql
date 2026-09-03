begin;

set local statement_timeout = '20s';
set local lock_timeout = '5s';

do $$
declare
  v_normal uuid := extensions.gen_random_uuid();
  v_guest uuid := extensions.gen_random_uuid();
  v_peer uuid := extensions.gen_random_uuid();
  v_outsider uuid := extensions.gen_random_uuid();
  v_missing uuid := extensions.gen_random_uuid();
  v_group_id uuid := extensions.gen_random_uuid();
  v_other_group_id uuid := extensions.gen_random_uuid();
  v_user_id uuid;
  v_is_guest boolean;
  v_rows jsonb;
  v_roster jsonb;
  v_group jsonb;
  v_query text;
  v_failures text[] := '{}';
  v_normal_people_pass boolean := false;
  v_guest_people_pass boolean := false;
  v_normal_members_type text;
  v_guest_members_type text;
  v_missing_denied integer := 0;
begin
  insert into core.organizations (id, name)
  values
    ('people-group-auth-a', 'People Group Auth A'),
    ('people-group-auth-b', 'People Group Auth B');

  insert into auth.users (id, is_anonymous, raw_app_meta_data)
  values
    (v_normal, false, '{"contract":"people_group_auth"}'),
    (v_guest, true, '{"contract":"people_group_auth"}'),
    (v_peer, false, '{"contract":"people_group_auth"}'),
    (v_outsider, false, '{"contract":"people_group_auth"}'),
    (v_missing, true, '{"contract":"people_group_auth"}');

  insert into core.user_academic_profiles (
    user_id, organization_id, academic_group, full_name
  ) values
    (v_normal, 'people-group-auth-a', 'SAME-01', 'People Contract Normal'),
    (v_guest, 'people-group-auth-a', 'SAME-01', 'People Contract Guest'),
    (v_peer, 'people-group-auth-a', 'SAME-01', 'People Contract Peer'),
    (v_outsider, 'people-group-auth-b', 'SAME-01', 'People Contract Outsider');

  insert into core.study_groups (
    id, organization_id, owner_id, name, join_code
  ) values
    (
      v_group_id, 'people-group-auth-a', v_normal,
      'People Contract Primary', 'PEOPLEA1'
    ),
    (
      v_other_group_id, 'people-group-auth-b', v_outsider,
      'People Contract Outside', 'PEOPLEB1'
    );
  insert into core.study_group_members (group_id, user_id, role)
  values
    (v_group_id, v_normal, 'owner'),
    (v_group_id, v_peer, 'member'),
    (v_other_group_id, v_outsider, 'owner');

  foreach v_user_id in array array[v_normal, v_guest] loop
    v_is_guest := v_user_id = v_guest;
    perform set_config('request.jwt.claim.role', 'authenticated', true);
    perform set_config('request.jwt.claim.sub', v_user_id::text, true);
    perform set_config(
      'request.jwt.claims',
      jsonb_build_object(
        'sub', v_user_id, 'role', 'authenticated',
        'is_anonymous', v_is_guest
      )::text,
      true
    );
    execute 'set local role authenticated';
    if (select auth.uid()) is distinct from v_user_id
      or (select (auth.jwt()->>'is_anonymous')::boolean)
        is distinct from v_is_guest then
      raise exception 'Authentication fixture claims are invalid';
    end if;

    v_rows := public.search_users('People Contract');
    if jsonb_array_length(v_rows) <> 2 or exists (
      select 1 from jsonb_array_elements(v_rows) candidate
      where (candidate->>'userId')::uuid not in (v_normal, v_guest, v_peer)
        or (candidate->>'userId')::uuid = v_user_id
    ) then
      raise exception 'Profile-backed people search failed or crossed tenant';
    end if;

    v_roster := public.get_group_members();
    if v_roster->>'group' <> 'SAME-01'
      or jsonb_array_length(v_roster->'members') <> 3
      or exists (
        select 1 from jsonb_array_elements(v_roster->'members') member
        where (member->>'userId')::uuid not in (v_normal, v_guest, v_peer)
      ) then
      raise exception 'Profile-backed academic roster failed or crossed tenant';
    end if;
    if public.get_people_you_may_know(12) <> '[]'::jsonb then
      raise exception 'Suggestions invented connections for an isolated fixture';
    end if;
    if v_is_guest then
      v_guest_people_pass := true;
    else
      v_normal_people_pass := true;
    end if;

    begin
      v_group := public.get_my_study_group('people-group-auth-a');
      if v_is_guest then
        v_guest_members_type := jsonb_typeof(v_group->'members');
      else
        v_normal_members_type := jsonb_typeof(v_group->'members');
      end if;
      if (v_group->>'hasGroup')::boolean is distinct from not v_is_guest then
        raise exception 'Academic profile was confused with study-group membership';
      end if;
      if jsonb_typeof(v_group->'members') is distinct from 'array' then
        raise exception 'Study-group members is not an array';
      end if;
      if jsonb_typeof(v_group->'incomingInvites') is distinct from 'array'
        or jsonb_typeof(v_group->'pendingRequests') is distinct from 'array' then
        raise exception 'Study-group invitations or requests is not an array';
      end if;
      if not v_is_guest then
        if (v_group->'group'->>'id')::uuid is distinct from v_group_id
          or jsonb_array_length(v_group->'members') <> 2 then
          raise exception 'Existing study-group membership is unavailable';
        end if;
      elsif jsonb_array_length(v_group->'members') <> 0 then
        raise exception 'A user without study membership received study members';
      end if;
    exception when others then
      v_failures := array_append(
        v_failures, format('group guest=%s: %s %s', v_is_guest, sqlstate, sqlerrm)
      );
    end;

    begin
      v_rows := public.search_study_groups(
        'people-group-auth-a', 'People Contract'
      );
      if jsonb_array_length(v_rows) <> 1
        or (v_rows->0->>'id')::uuid is distinct from v_group_id then
        raise exception 'Study-group discovery failed or crossed tenant';
      end if;
    exception when others then
      v_failures := array_append(
        v_failures,
        format('discovery guest=%s: %s %s', v_is_guest, sqlstate, sqlerrm)
      );
    end;
    begin
      perform public.search_study_groups(
        'people-group-auth-b', 'People Contract'
      );
      v_failures := array_append(
        v_failures, format('Cross-tenant discovery accepted guest=%s', v_is_guest)
      );
    exception
      when insufficient_privilege then null;
    end;
    begin
      perform public.get_my_study_group('people-group-auth-b');
      v_failures := array_append(
        v_failures, format('Cross-tenant group lookup accepted guest=%s', v_is_guest)
      );
    exception
      when insufficient_privilege then null;
      when raise_exception then
        if sqlerrm <> 'study_group_organization_mismatch' then raise; end if;
    end;
    execute 'reset role';
  end loop;

  execute 'set local role authenticated';
  begin
    v_group := public.create_study_group(
      'people-group-auth-a', 'People Contract Guest'
    );
    if not coalesce((v_group->>'hasGroup')::boolean, false)
      or not coalesce((v_group->>'isOwner')::boolean, false)
      or (select auth.uid()) is distinct from v_guest
      or not coalesce((select (auth.jwt()->>'is_anonymous')::boolean), false)
    then
      raise exception 'Guest could not create a study group without identity change';
    end if;
    if jsonb_typeof(v_group->'members') is distinct from 'array' then
      raise exception 'Created guest group members is not an array';
    end if;
    if jsonb_array_length(v_group->'members') <> 1
      or (v_group->'members'->0->>'userId')::uuid is distinct from v_guest then
      raise exception 'Created guest group does not include its owner';
    end if;
  exception when others then
    v_failures := array_append(
      v_failures, format('guest creation: %s %s', sqlstate, sqlerrm)
    );
  end;
  execute 'reset role';

  perform set_config('request.jwt.claim.sub', v_missing::text, true);
  perform set_config(
    'request.jwt.claims',
    jsonb_build_object(
      'sub', v_missing, 'role', 'authenticated', 'is_anonymous', true
    )::text,
    true
  );
  execute 'set local role authenticated';
  foreach v_query in array array[
    'select public.search_users(''People Contract'')',
    'select public.get_group_members()',
    'select public.get_people_you_may_know(12)',
    'select public.get_my_study_group(''people-group-auth-a'')',
    'select public.search_study_groups(''people-group-auth-a'', ''People'')',
    'select public.create_study_group(''people-group-auth-a'', ''Missing'')'
  ] loop
    begin
      execute v_query;
      v_failures := array_append(
        v_failures, format('Missing-profile guest accepted: %s', v_query)
      );
    exception
      when insufficient_privilege then v_missing_denied := v_missing_denied + 1;
      when others then
        v_failures := array_append(
          v_failures, format('Missing-profile error: %s %s', sqlstate, sqlerrm)
        );
    end;
  end loop;
  execute 'reset role';
  if cardinality(v_failures) > 0 then
    raise exception 'People/group auth contract: %', jsonb_build_object(
      'failures', v_failures,
      'normal_people_pass', v_normal_people_pass,
      'guest_people_pass', v_guest_people_pass,
      'normal_group_members_type', v_normal_members_type,
      'guest_group_members_type', v_guest_members_type,
      'missing_profile_denied', v_missing_denied
    );
  end if;
end;
$$;

rollback;
