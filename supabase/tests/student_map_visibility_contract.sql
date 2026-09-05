begin;

do $$
declare
  v_signature text;
begin
  foreach v_signature in array array[
    'get_location_visibility()',
    'set_location_visibility(boolean)',
    'get_map_students()'
  ] loop
    if has_function_privilege('anon', 'public.' || v_signature, 'EXECUTE')
      or not has_function_privilege(
        'authenticated', 'public.' || v_signature, 'EXECUTE'
      )
      or has_function_privilege(
        'authenticated', 'app_api_v1.' || v_signature, 'EXECUTE'
      )
    then
      raise exception 'Student map privileges are invalid: %', v_signature;
    end if;
  end loop;
end;
$$;

do $$
declare
  v_viewer uuid := extensions.gen_random_uuid();
  v_student uuid := extensions.gen_random_uuid();
  v_outsider uuid := extensions.gen_random_uuid();
  v_guest uuid := extensions.gen_random_uuid();
  v_unenrolled uuid := extensions.gen_random_uuid();
  v_rows jsonb;
  v_count integer;
  v_timestamp timestamptz;
begin
  insert into core.organizations (id, name)
  values ('map-test-a', 'Map Test A'), ('map-test-b', 'Map Test B');
  insert into auth.users (id, is_anonymous) values
    (v_viewer, false), (v_student, false), (v_outsider, false),
    (v_guest, true), (v_unenrolled, false);
  insert into core.user_academic_profiles (
    user_id, organization_id, full_name, academic_group
  ) values
    (v_viewer, 'map-test-a', 'Map Viewer', 'ONE'),
    (v_student, 'map-test-a', 'Map Student', 'TWO'),
    (v_outsider, 'map-test-b', 'Map Outsider', 'ONE'),
    (v_guest, 'map-test-a', 'Map Guest', 'ONE');
  perform set_config('request.jwt.claim.role', 'authenticated', true);
  perform set_config('request.jwt.claim.sub', v_student::text, true);
  execute 'set local role authenticated';
  if public.get_location_visibility() then
    raise exception 'Existing student opted into public sharing by default';
  end if;
  perform public.upsert_my_location(55.75, 37.61);
  execute 'reset role';
  perform set_config('request.jwt.claim.sub', v_viewer::text, true);
  execute 'set local role authenticated';
  if public.get_map_students() <> '[]'::jsonb then
    raise exception 'Friends-only location leaked to a non-friend';
  end if;
  execute 'reset role';
  perform set_config('request.jwt.claim.sub', v_student::text, true);
  execute 'set local role authenticated';
  perform public.set_location_visibility(true);
  if public.get_location_visibility() is distinct from true then
    raise exception 'Student visibility did not persist independently';
  end if;
  execute 'reset role';
  if exists (select 1 from public.friend_locations where user_id = v_student) then
    raise exception 'Audience switch retained a location from prior consent';
  end if;
  execute 'set local role authenticated';
  perform public.upsert_my_location(55.75, 37.61, 10, 45, 1, 90);
  perform public.set_location_mood('private status');
  execute 'reset role';
  select updated_at into v_timestamp from public.friend_locations
  where user_id = v_student;
  execute 'set local role authenticated';
  perform public.set_location_visibility(true);
  execute 'reset role';
  if not exists (
    select 1 from public.friend_locations
    where user_id = v_student and updated_at = v_timestamp
  ) then
    raise exception 'Idempotent audience update cleared or refreshed location';
  end if;
  perform set_config('request.jwt.claim.sub', v_viewer::text, true);
  execute 'set local role authenticated';
  select public.get_map_students() into v_rows;
  select count(*) into v_count from public.friend_locations;
  execute 'reset role';
  if jsonb_array_length(v_rows) <> 1
    or v_rows->0->>'userId' <> v_student::text
    or v_rows->0->>'friendshipId' <> ''
    or v_rows->0 ?| array['battery', 'mood', 'heading', 'speed_mps', 'email']
    or v_count <> 0
  then
    raise exception 'Student projection or direct location access is invalid';
  end if;
  perform set_config('request.jwt.claim.sub', v_outsider::text, true);
  execute 'set local role authenticated';
  if public.get_map_students() <> '[]'::jsonb then
    raise exception 'Student location crossed the organization boundary';
  end if;
  execute 'reset role';
  perform set_config('request.jwt.claim.sub', v_guest::text, true);
  execute 'set local role authenticated';
  begin
    perform public.get_map_students();
    raise exception 'Anonymous student accessed public locations';
  exception when insufficient_privilege then null;
  end;
  begin
    perform public.set_location_visibility(true);
    raise exception 'Anonymous student enabled public visibility';
  exception when insufficient_privilege then null;
  end;
  execute 'reset role';
  perform set_config('request.jwt.claim.sub', v_unenrolled::text, true);
  execute 'set local role authenticated';
  begin
    perform public.get_map_students();
    raise exception 'Unenrolled account accessed public locations';
  exception when insufficient_privilege then null;
  end;
  execute 'reset role';
  update public.friend_locations set updated_at = now() - interval '6 minutes'
  where user_id = v_student;
  insert into core.friendships (
    requester_id, addressee_id, organization_id, status
  ) values (v_viewer, v_student, 'map-test-a', 'accepted');
  perform set_config('request.jwt.claim.sub', v_viewer::text, true);
  execute 'set local role authenticated';
  select public.get_friends() into v_rows;
  select count(*) into v_count from public.friend_locations;
  if public.get_map_students() <> '[]'::jsonb or v_count <> 0
    or jsonb_array_length(v_rows) <> 1
    or v_rows->0->>'latitude' is not null
    or v_rows->0->>'locationUpdatedAt' is not null
  then
    raise exception 'Expired coordinates remain accessible';
  end if;
  execute 'reset role';
  perform set_config('request.jwt.claim.sub', v_student::text, true);
  execute 'set local role authenticated';
  perform public.upsert_my_location(55.8, 37.7);
  perform public.set_ghost_mode(true);
  perform public.upsert_my_location(55.9, 37.8);
  execute 'reset role';
  if exists (select 1 from public.friend_locations where user_id = v_student)
    or not public.get_ghost_mode()
    or not public.get_location_visibility()
  then
    raise exception 'Hidden publisher retained coordinates or lost preferences';
  end if;
  execute 'set local role authenticated';
  perform public.set_ghost_mode(false);
  execute 'reset role';
  if exists (select 1 from public.friend_locations where user_id = v_student) then
    raise exception 'Unhide resurrected coordinates';
  end if;
  execute 'set local role authenticated';
  perform public.upsert_my_location(55.8, 37.7);
  perform public.set_location_visibility(false);
  execute 'reset role';
  if public.get_location_visibility()
    or exists (select 1 from public.friend_locations where user_id = v_student)
  then
    raise exception 'Opt-out retained public coordinates';
  end if;
  perform public.set_location_visibility(true);
  update core.user_academic_profiles set organization_id = 'map-test-b'
  where user_id = v_student;
  if public.get_location_visibility() then
    raise exception 'Public consent carried across an organization change';
  end if;
end;
$$;

rollback;
