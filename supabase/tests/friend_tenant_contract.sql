begin;

do $$
declare
  v_function text;
begin
  foreach v_function in array array[
    'app_api_v1.search_users(text)',
    'app_api_v1.get_friends()',
    'app_api_v1.get_friend_requests()',
    'app_api_v1.send_friend_request(uuid)',
    'app_api_v1.respond_friend_request(uuid,boolean)',
    'app_api_v1.remove_friend(uuid)',
    'app_api_v1.get_group_members()',
    'app_api_v1.get_people_you_may_know(integer)',
    'app_api_v1.get_ghost_mode()',
    'app_api_v1.set_ghost_mode(boolean)',
    'app_api_v1.set_location_mood(text)',
    'app_api_v1.upsert_my_location(double precision,double precision,double precision,double precision,double precision,integer)'
  ] loop
    if has_function_privilege('anon', v_function, 'EXECUTE')
      or has_function_privilege('authenticated', v_function, 'EXECUTE')
      or not has_function_privilege('service_role', v_function, 'EXECUTE')
    then
      raise exception 'Internal friendship privileges are invalid: %',
        v_function;
    end if;
  end loop;

  foreach v_function in array array[
    'public.search_users(text)',
    'public.get_friends()',
    'public.get_friend_requests()',
    'public.send_friend_request(uuid)',
    'public.respond_friend_request(uuid,boolean)',
    'public.remove_friend(uuid)',
    'public.get_group_members()',
    'public.get_people_you_may_know(integer)',
    'public.get_ghost_mode()',
    'public.set_ghost_mode(boolean)',
    'public.set_location_mood(text)',
    'public.upsert_my_location(double precision,double precision,double precision,double precision,double precision,integer)'
  ] loop
    if has_function_privilege('anon', v_function, 'EXECUTE')
      or not has_function_privilege('authenticated', v_function, 'EXECUTE')
    then
      raise exception 'Public friendship privileges are invalid: %',
        v_function;
    end if;
  end loop;

  foreach v_function in array array[
    'public.send_friend_request(uuid)',
    'public.respond_friend_request(uuid,boolean)',
    'public.remove_friend(uuid)',
    'public.set_ghost_mode(boolean)',
    'public.set_location_mood(text)',
    'public.upsert_my_location(double precision,double precision,double precision,double precision,double precision,integer)'
  ] loop
    if not (
      select procedure.prosecdef
      from pg_catalog.pg_proc procedure
      where procedure.oid = to_regprocedure(v_function)
    ) then
      raise exception 'Mutation wrapper must be security definer: %',
        v_function;
    end if;
  end loop;

  if has_table_privilege(
    'authenticated', 'core.friendships', 'SELECT,INSERT,UPDATE,DELETE'
  ) then
    raise exception 'Direct friendship table access is available';
  end if;
  if not has_table_privilege(
    'authenticated', 'public.friend_locations', 'SELECT'
  ) or has_table_privilege(
    'authenticated', 'public.friend_locations', 'INSERT,UPDATE,DELETE'
  ) then
    raise exception 'Friend location privileges are invalid';
  end if;
end;
$$;

do $$
declare
  v_a1 uuid := extensions.gen_random_uuid();
  v_a2 uuid := extensions.gen_random_uuid();
  v_a3 uuid := extensions.gen_random_uuid();
  v_b1 uuid := extensions.gen_random_uuid();
  v_friendship_id uuid;
  v_rows jsonb;
  v_roster jsonb;
  v_location_updated_at timestamptz;
begin
  insert into core.organizations (id, name)
  values
    ('friend-test-a', 'Friend Test A'),
    ('friend-test-b', 'Friend Test B');

  insert into auth.users (id) values (v_a1), (v_a2), (v_a3), (v_b1);
  insert into core.user_academic_profiles (
    user_id, organization_id, full_name, academic_group, handle
  ) values
    (v_a1, 'friend-test-a', 'Student Alpha', 'SAME-01', 'alpha_user'),
    (v_a2, 'friend-test-a', 'Student Beta', 'SAME-01', 'beta_user'),
    (v_a3, 'friend-test-a', 'Student Gamma', 'OTHER-01', 'gamma_user'),
    (v_b1, 'friend-test-b', 'Student Outside', 'SAME-01', 'outside_user');

  perform set_config('request.jwt.claim.role', 'authenticated', true);
  perform set_config('request.jwt.claim.sub', v_a1::text, true);

  select app_api_v1.search_users('Student') into v_rows;
  if jsonb_array_length(v_rows) <> 2
    or exists (
      select 1 from jsonb_array_elements(v_rows) row
      where row->>'userId' = v_b1::text
    )
  then
    raise exception 'People search crossed organization boundary';
  end if;
  if public.get_ghost_mode() then
    raise exception 'Default durable ghost mode is invalid';
  end if;
  begin
    insert into core.friendships (
      requester_id, addressee_id, organization_id
    ) values (v_a1, v_b1, 'friend-test-a');
    raise exception 'Invalid friendship organization bypassed the guard';
  exception
    when check_violation then null;
  end;

  select app_api_v1.get_group_members() into v_roster;
  if v_roster->>'group' <> 'SAME-01'
    or jsonb_array_length(v_roster->'members') <> 2
    or exists (
      select 1 from jsonb_array_elements(v_roster->'members') member
      where member->>'userId' = v_b1::text
    )
  then
    raise exception 'Academic group roster crossed organization boundary';
  end if;

  begin
    perform app_api_v1.send_friend_request(v_b1);
    raise exception 'Cross-organization friend request was accepted';
  exception
    when insufficient_privilege then null;
  end;

  execute 'set local role authenticated';
  perform public.send_friend_request(v_a2);
  execute 'reset role';
  select friendship.id into v_friendship_id
  from core.friendships friendship
  where friendship.requester_id = v_a1
    and friendship.addressee_id = v_a2;
  if v_friendship_id is null or not exists (
    select 1 from core.friendships friendship
    where friendship.id = v_friendship_id
      and friendship.organization_id = 'friend-test-a'
  ) then
    raise exception 'Same-organization friend request was not scoped';
  end if;

  perform set_config('request.jwt.claim.sub', v_b1::text, true);
  begin
    perform app_api_v1.respond_friend_request(v_friendship_id, true);
    raise exception 'Outsider responded to another organization request';
  exception
    when insufficient_privilege then null;
  end;

  perform set_config('request.jwt.claim.sub', v_a2::text, true);
  execute 'set local role authenticated';
  perform public.respond_friend_request(v_friendship_id, true);
  perform public.upsert_my_location(55.75, 37.61);
  execute 'reset role';
  select location.updated_at into v_location_updated_at
  from public.friend_locations location
  where location.user_id = v_a2;
  execute 'set local role authenticated';
  perform public.set_location_mood('Studying');
  execute 'reset role';
  if not exists (
    select 1 from public.friend_locations location
    where location.user_id = v_a2
      and not location.is_ghost
      and location.mood = 'Studying'
      and location.updated_at = v_location_updated_at
  ) then
    raise exception 'Privacy metadata changed coordinate freshness';
  end if;
  execute 'set local role authenticated';
  perform public.set_ghost_mode(true);
  execute 'reset role';
  if exists (select 1 from public.friend_locations where user_id = v_a2) then
    raise exception 'Ghost mode retained coordinates';
  end if;
  execute 'set local role authenticated';
  perform public.set_ghost_mode(false);
  perform public.upsert_my_location(55.75, 37.61);
  execute 'reset role';
  if not core.are_friends(v_a1, v_a2) then
    raise exception 'Accepted same-organization friendship is unavailable';
  end if;

  perform set_config('request.jwt.claim.sub', v_a1::text, true);
  select app_api_v1.get_friends() into v_rows;
  if jsonb_array_length(v_rows) <> 1
    or v_rows->0->>'userId' <> v_a2::text
    or (v_rows->0->>'latitude')::double precision <> 55.75
  then
    raise exception 'Friend list or location projection is invalid';
  end if;

  update core.user_academic_profiles profile
  set organization_id = 'friend-test-b'
  where profile.user_id = v_a2;
  if exists (
    select 1 from core.friendships friendship
    where v_a2 in (friendship.requester_id, friendship.addressee_id)
  ) or exists (
    select 1 from public.friend_locations location
    where location.user_id = v_a2
  ) or core.are_friends(v_a1, v_a2) then
    raise exception 'Organization change retained social or location access';
  end if;
end;
$$;

rollback;
