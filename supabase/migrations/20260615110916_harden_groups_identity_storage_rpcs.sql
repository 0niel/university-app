create or replace function app_api_v1.create_study_group(
  p_organization_id text, p_name text, p_emoji text default '🎓'::text,
  p_description text default ''::text, p_discoverable boolean default true)
  returns jsonb language plpgsql security definer set search_path to ''
as $function$
declare v_user uuid := (select auth.uid()); v_id uuid;
begin
  if v_user is null then raise exception 'Unauthorized'; end if;
  if core.current_study_group_id() is not null then
    raise exception 'Already a member of a group';
  end if;
  perform core.enforce_rate_limit('create_study_group', 5, interval '1 day');
  insert into core.study_groups
    (organization_id, owner_id, name, emoji, description, join_code, is_discoverable)
  values (p_organization_id, v_user,
          core.validate_text(p_name, 'Название', 100, true),
          left(coalesce(nullif(p_emoji, ''), '🎓'), 16),
          core.validate_text(p_description, 'Описание', 2000, false),
          core.gen_group_join_code(), coalesce(p_discoverable, true))
  returning id into v_id;
  insert into core.study_group_members (group_id, user_id, role)
  values (v_id, v_user, 'owner');
  update core.study_group_invites set status = 'revoked'
  where target_user_id = v_user and status = 'pending';
  return app_api_v1.get_my_study_group(p_organization_id);
end;
$function$;

create or replace function app_api_v1.update_study_group(
  p_organization_id text, p_name text default null::text,
  p_emoji text default null::text, p_description text default null::text,
  p_discoverable boolean default null::boolean)
  returns jsonb language plpgsql security definer set search_path to ''
as $function$
declare v_user uuid := (select auth.uid());
begin
  if v_user is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('update_study_group', 30, interval '1 hour');
  update core.study_groups set
    name = coalesce(nullif(core.validate_text(p_name, 'Название', 100, false), ''), name),
    emoji = coalesce(nullif(left(coalesce(p_emoji, ''), 16), ''), emoji),
    description = case when p_description is null then description
                      else core.validate_text(p_description, 'Описание', 2000, false) end,
    is_discoverable = coalesce(p_discoverable, is_discoverable),
    updated_at = now()
  where owner_id = v_user;
  if not found then raise exception 'Only the owner can edit the group'; end if;
  return app_api_v1.get_my_study_group(p_organization_id);
end;
$function$;

create or replace function app_api_v1.set_user_identity(
  p_organization_id text, p_full_name text, p_handle text)
  returns jsonb language plpgsql security definer set search_path to ''
as $function$
declare
  v_uid uuid := (select auth.uid());
  v_name text := core.validate_text(p_full_name, 'Имя', 100, true);
  v_handle text := lower(btrim(regexp_replace(coalesce(p_handle, ''), '^@+', '')));
begin
  if v_uid is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('set_user_identity', 20, interval '1 hour');
  if v_handle !~ '^[a-z0-9_]{3,20}$' then raise exception 'handle_invalid'; end if;
  if exists (
    select 1 from core.user_academic_profiles p
    where lower(p.handle) = v_handle and p.user_id <> v_uid
  ) then raise exception 'handle_taken'; end if;

  insert into core.user_academic_profiles (user_id, organization_id, full_name, handle)
  values (v_uid, p_organization_id, v_name, v_handle)
  on conflict (user_id) do update set
    full_name = excluded.full_name, handle = excluded.handle,
    organization_id =
      coalesce(core.user_academic_profiles.organization_id, excluded.organization_id),
    updated_at = now();
  return app_api_v1.get_profile_overview(p_organization_id);
end;
$function$;

create or replace function app_api_v1.upsert_user_academic_profile(
  p_organization_id text, p_handle text default null::text,
  p_group text default null::text, p_course integer default null::integer,
  p_full_name text default null::text, p_student_card_number text default null::text,
  p_card_valid_until date default null::date)
  returns jsonb language plpgsql set search_path to ''
as $function$
declare v_uid uuid := (select auth.uid());
begin
  if v_uid is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('upsert_user_academic_profile', 30, interval '1 hour');
  insert into core.user_academic_profiles
    (user_id, organization_id, handle, academic_group, course, full_name,
     student_card_number, card_valid_until)
  values (v_uid, p_organization_id,
     nullif(core.validate_text(p_handle, 'Ник', 40, false), ''),
     nullif(core.validate_text(p_group, 'Группа', 60, false), ''),
     case when p_course is null then null else least(greatest(p_course, 1), 12) end,
     nullif(core.validate_text(p_full_name, 'Имя', 100, false), ''),
     nullif(core.validate_text(p_student_card_number, 'Студбилет', 60, false), ''),
     p_card_valid_until)
  on conflict (user_id) do update set
    handle = coalesce(excluded.handle, core.user_academic_profiles.handle),
    academic_group = coalesce(excluded.academic_group, core.user_academic_profiles.academic_group),
    course = coalesce(excluded.course, core.user_academic_profiles.course),
    full_name = coalesce(excluded.full_name, core.user_academic_profiles.full_name),
    student_card_number = coalesce(excluded.student_card_number, core.user_academic_profiles.student_card_number),
    card_valid_until = coalesce(excluded.card_valid_until, core.user_academic_profiles.card_valid_until);
  return app_api_v1.get_profile_overview(p_organization_id);
end;
$function$;

-- set_mini_app_storage: add explicit auth gate, rate limit, key/value size caps.
create or replace function app_api_v1.set_mini_app_storage(
  p_app_id uuid, p_key text, p_value jsonb default null::jsonb)
  returns void language plpgsql set search_path to ''
as $function$
declare v_user_id uuid := (select auth.uid()); v_count integer;
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  if p_value is null then
    delete from core.mini_app_user_storage
    where user_id = v_user_id and app_id = p_app_id and key = p_key;
    return;
  end if;
  perform core.enforce_rate_limit('set_mini_app_storage', 120, interval '1 hour');
  if char_length(coalesce(p_key, '')) = 0 or char_length(p_key) > 100 then
    raise exception 'Некорректный ключ' using errcode = '22023';
  end if;
  if octet_length(p_value::text) > 16384 then
    raise exception 'Значение слишком большое (максимум 16 КБ)' using errcode = '22023';
  end if;
  select count(*) into v_count from core.mini_app_user_storage
  where user_id = v_user_id and app_id = p_app_id;
  if v_count >= 50 and not exists (
    select 1 from core.mini_app_user_storage
    where user_id = v_user_id and app_id = p_app_id and key = p_key
  ) then
    raise exception 'Storage quota exceeded (50 keys per app)';
  end if;
  insert into core.mini_app_user_storage (user_id, app_id, key, value)
  values (v_user_id, p_app_id, p_key, p_value)
  on conflict (user_id, app_id, key) do update set value = excluded.value;
end;
$function$;

create or replace function app_api_v1.set_user_preference(p_key text, p_value jsonb)
  returns void language plpgsql set search_path to ''
as $function$
declare v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('set_user_preference', 120, interval '1 hour');
  if char_length(coalesce(p_key, '')) = 0 or char_length(p_key) > 100 then
    raise exception 'Некорректный ключ' using errcode = '22023';
  end if;
  if octet_length(coalesce(p_value, '{}'::jsonb)::text) > 16384 then
    raise exception 'Значение слишком большое (максимум 16 КБ)' using errcode = '22023';
  end if;
  insert into user_private.user_preferences (user_id, key, value)
  values (v_user_id, p_key, coalesce(p_value, '{}'::jsonb))
  on conflict (user_id, key) do update set value = excluded.value;
end;
$function$;

-- wifi_observations_submit: reject absurdly large AP batches up front.
create or replace function app_api_v1.wifi_observations_submit(
  p_latitude double precision, p_longitude double precision,
  p_accuracy_m double precision, p_aps jsonb)
  returns integer language plpgsql security definer set search_path to ''
as $function$
declare
  v_user_id uuid := (select auth.uid());
  v_last timestamptz; v_ap record; v_old core.wifi_beacons%rowtype;
  v_dist double precision; v_count integer := 0;
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  if p_latitude is null or p_longitude is null
     or p_latitude not between -90 and 90
     or p_longitude not between -180 and 180
     or p_accuracy_m is null or p_accuracy_m <= 0 or p_accuracy_m > 100
     or p_aps is null or jsonb_typeof(p_aps) <> 'array'
     or jsonb_array_length(p_aps) = 0
     or jsonb_array_length(p_aps) > 200 then
    return 0;
  end if;

  select last_at into v_last from core.wifi_submit_log
  where user_id = v_user_id for update;
  if v_last is not null and v_last > now() - interval '15 seconds' then
    return 0;
  end if;
  insert into core.wifi_submit_log as l (user_id, last_at)
  values (v_user_id, now())
  on conflict (user_id) do update set last_at = now();

  for v_ap in
    select lower(trim(elem->>'bssid')) as bssid
    from jsonb_array_elements(p_aps) elem limit 40
  loop
    if v_ap.bssid is null or v_ap.bssid !~ '^[0-9a-f]{2}(:[0-9a-f]{2}){5}$' then continue; end if;
    if substring(v_ap.bssid, 2, 1) in ('2', '6', 'a', 'e') then continue; end if;
    select * into v_old from core.wifi_beacons where bssid = v_ap.bssid for update;
    if not found then
      insert into core.wifi_beacons (bssid, latitude, longitude, accuracy_m)
      values (v_ap.bssid, p_latitude, p_longitude, greatest(40, p_accuracy_m * 2))
      on conflict (bssid) do nothing;
      v_count := v_count + 1; continue;
    end if;
    v_dist := core.haversine_m(v_old.latitude, v_old.longitude, p_latitude, p_longitude);
    if v_dist > 1000 then
      if v_old.drift_count >= 2 then
        update core.wifi_beacons set latitude = p_latitude, longitude = p_longitude,
          accuracy_m = greatest(40, p_accuracy_m * 2), observations = 1,
          drift_count = 0, last_seen = now() where bssid = v_ap.bssid;
      else
        update core.wifi_beacons set drift_count = drift_count + 1, last_seen = now()
        where bssid = v_ap.bssid;
      end if;
    else
      update core.wifi_beacons set
        latitude = latitude + 0.3 * (p_latitude - latitude),
        longitude = longitude + 0.3 * (p_longitude - longitude),
        accuracy_m = greatest(30, 0.7 * accuracy_m + 0.3 * (v_dist + p_accuracy_m)),
        observations = least(observations + 1, 1000000),
        drift_count = 0, last_seen = now() where bssid = v_ap.bssid;
    end if;
    v_count := v_count + 1;
  end loop;
  return v_count;
end;
$function$;
