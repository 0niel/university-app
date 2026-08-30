begin;

do $$
declare
  v_definition text;
  v_user_id uuid := extensions.gen_random_uuid();
  v_is_ghost boolean;
begin
  if to_regclass('user_private.friend_location_preferences') is null then
    raise exception 'Missing durable friend-location preferences';
  end if;


  if exists (
    select 1
    from public.friend_locations location
    left join user_private.friend_location_preferences preference
      on preference.user_id = location.user_id
    where location.is_ghost
      and preference.is_ghost is distinct from true
  ) then
    raise exception 'Existing ghost-mode state was not backfilled';
  end if;

  if has_table_privilege(
    'authenticated',
    'user_private.friend_location_preferences',
    'SELECT'
  ) or has_table_privilege(
    'authenticated',
    'user_private.friend_location_preferences',
    'INSERT'
  ) then
    raise exception 'Friend-location preferences are directly exposed';
  end if;

  if to_regprocedure('public.get_ghost_mode()') is null
    or not has_function_privilege(
      'authenticated',
      'public.get_ghost_mode()',
      'EXECUTE'
    ) then
    raise exception 'Authenticated ghost-mode read contract is missing';
  end if;

  v_definition := pg_get_functiondef(
    'app_api_v1.set_ghost_mode(boolean)'::regprocedure
  );
  if position('friend_location_preferences' in v_definition) = 0
    or position('on conflict (user_id)' in v_definition) = 0 then
    raise exception 'Ghost mode is not persisted before a location exists';
  end if;

  v_definition := pg_get_functiondef(
    'app_api_v1.upsert_my_location(double precision,double precision,double precision,double precision,double precision,integer)'::regprocedure
  );
  if position('friend_location_preferences' in v_definition) = 0
    or position('is_ghost = v_is_ghost' in v_definition) = 0 then
    raise exception 'Location upsert can reset persisted ghost mode';
  end if;

  insert into auth.users (id) values (v_user_id);
  perform set_config('request.jwt.claim.sub', v_user_id::text, true);
  perform app_api_v1.set_ghost_mode(true);
  perform app_api_v1.upsert_my_location(55.0, 37.0);

  select location.is_ghost
  into v_is_ghost
  from public.friend_locations location
  where location.user_id = v_user_id;

  if v_is_ghost is distinct from true then
    raise exception 'First location publish reset active ghost mode';
  end if;
end;
$$;

rollback;
