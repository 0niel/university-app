alter table user_private.friend_location_preferences
  add column visible_to_students boolean not null default false;

delete from public.friend_locations where is_ghost;

create index friend_locations_fresh_idx
on public.friend_locations (updated_at desc)
where not is_ghost;

create or replace function app_api_v1.get_location_visibility()
returns boolean
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if not exists (
    select 1
    from core.user_academic_profiles profile
    join auth.users account on account.id = profile.user_id
    where profile.user_id = v_user_id
      and not coalesce(account.is_anonymous, false)
  ) then
    raise exception 'Student map is unavailable' using errcode = '42501';
  end if;
  return coalesce((
    select preference.visible_to_students
    from user_private.friend_location_preferences preference
    where preference.user_id = v_user_id
  ), false);
end;
$$;

create or replace function app_api_v1.set_location_visibility(
  p_visible_to_students boolean
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_previous boolean;
begin
  if p_visible_to_students is null then
    raise exception 'Location visibility is required' using errcode = '22023';
  end if;
  perform 1
  from core.user_academic_profiles profile
  join auth.users account on account.id = profile.user_id
  where profile.user_id = v_user_id
    and not coalesce(account.is_anonymous, false)
  for share of profile;
  if not found then
    raise exception 'Student map is unavailable' using errcode = '42501';
  end if;
  insert into user_private.friend_location_preferences (user_id)
  values (v_user_id)
  on conflict (user_id) do nothing;
  select preference.visible_to_students into v_previous
  from user_private.friend_location_preferences preference
  where preference.user_id = v_user_id
  for update;
  if v_previous is distinct from p_visible_to_students then
    update user_private.friend_location_preferences preference
    set visible_to_students = p_visible_to_students,
      updated_at = clock_timestamp()
    where preference.user_id = v_user_id;
    delete from public.friend_locations location
    where location.user_id = v_user_id;
  end if;
end;
$$;

create or replace function app_api_v1.get_map_students()
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_organization_id text;
  v_result jsonb;
begin
  select profile.organization_id into v_organization_id
  from core.user_academic_profiles profile
  join auth.users account on account.id = profile.user_id
  where profile.user_id = v_user_id
    and not coalesce(account.is_anonymous, false);
  if v_organization_id is null then
    raise exception 'Student map is unavailable' using errcode = '42501';
  end if;
  select coalesce(jsonb_agg(jsonb_build_object(
    'friendshipId', coalesce(friendship.id::text, ''),
    'userId', profile.user_id,
    'fullName', profile.full_name,
    'handle', profile.handle,
    'group', profile.academic_group,
    'latitude', location.latitude,
    'longitude', location.longitude,
    'locationUpdatedAt', location.updated_at
  ) order by profile.full_name, profile.user_id), '[]'::jsonb)
  into v_result
  from public.friend_locations location
  join user_private.friend_location_preferences preference
    on preference.user_id = location.user_id
    and preference.visible_to_students
    and not preference.is_ghost
  join core.user_academic_profiles profile
    on profile.user_id = location.user_id
    and profile.organization_id = v_organization_id
  join auth.users account on account.id = profile.user_id
    and not coalesce(account.is_anonymous, false)
  left join core.friendships friendship
    on friendship.organization_id = v_organization_id
    and friendship.status = 'accepted'
    and least(friendship.requester_id, friendship.addressee_id)
      = least(profile.user_id, v_user_id)
    and greatest(friendship.requester_id, friendship.addressee_id)
      = greatest(profile.user_id, v_user_id)
  where location.user_id <> v_user_id
    and not location.is_ghost
    and location.updated_at >= now() - interval '5 minutes';
  return v_result;
end;
$$;

create or replace function app_api_v1.get_friends()
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_organization_id text;
  v_result jsonb;
begin
  select profile.organization_id into v_organization_id
  from core.user_academic_profiles profile
  where profile.user_id = v_user_id;
  if v_organization_id is null then
    raise exception 'Friends are unavailable' using errcode = '42501';
  end if;
  select coalesce(jsonb_agg(jsonb_build_object(
    'friendshipId', edge.id,
    'userId', edge.friend_id,
    'fullName', profile.full_name,
    'handle', profile.handle,
    'group', profile.academic_group,
    'latitude', case when location.is_ghost then null else location.latitude end,
    'longitude', case when location.is_ghost then null else location.longitude end,
    'battery', case when location.is_ghost then null else location.battery end,
    'mood', case when location.is_ghost then '' else coalesce(location.mood, '') end,
    'isGhost', coalesce(location.is_ghost, false),
    'locationUpdatedAt', case when location.is_ghost then null
      else location.updated_at end
  ) order by profile.full_name, edge.friend_id), '[]'::jsonb)
  into v_result
  from (
    select friendship.id,
      case when friendship.requester_id = v_user_id
        then friendship.addressee_id else friendship.requester_id end friend_id
    from core.friendships friendship
    where friendship.organization_id = v_organization_id
      and friendship.status = 'accepted'
      and v_user_id in (friendship.requester_id, friendship.addressee_id)
  ) edge
  join core.user_academic_profiles profile
    on profile.user_id = edge.friend_id
    and profile.organization_id = v_organization_id
  left join public.friend_locations location
    on location.user_id = edge.friend_id
    and location.updated_at >= now() - interval '5 minutes';
  return v_result;
end;
$$;

drop policy if exists "owner or friends can read locations"
on public.friend_locations;
create policy "owner or friends can read locations"
on public.friend_locations for select to authenticated
using (
  (select auth.uid()) = user_id
  or (
    not is_ghost
    and updated_at >= now() - interval '5 minutes'
    and core.are_friends((select auth.uid()), user_id)
  )
);

create or replace function internal.reconcile_friendships_on_org_change()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if old.organization_id <> new.organization_id then
    delete from core.friendships friendship
    where new.user_id in (friendship.requester_id, friendship.addressee_id);
    delete from public.friend_locations location
    where location.user_id = new.user_id;
    update user_private.friend_location_preferences preference
    set visible_to_students = false, updated_at = clock_timestamp()
    where preference.user_id = new.user_id;
  end if;
  return new;
end;
$$;

create or replace function public.get_location_visibility()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$ select app_api_v1.get_location_visibility(); $$;

create or replace function app_api_v1.upsert_my_location(
  p_latitude double precision,
  p_longitude double precision,
  p_accuracy_m double precision default null,
  p_heading double precision default null,
  p_speed_mps double precision default null,
  p_battery integer default null
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_is_ghost boolean;
begin
  perform 1 from core.user_academic_profiles profile
  where profile.user_id = v_user_id
  for share;
  if not found then
    raise exception 'Location sharing is unavailable' using errcode = '42501';
  end if;
  insert into user_private.friend_location_preferences (user_id, is_ghost)
  values (v_user_id, false)
  on conflict (user_id) do nothing;
  select preference.is_ghost into v_is_ghost
  from user_private.friend_location_preferences preference
  where preference.user_id = v_user_id
  for update;
  if v_is_ghost then
    return;
  end if;
  insert into public.friend_locations (
    user_id, latitude, longitude, accuracy_m, heading, speed_mps, battery,
    is_ghost, updated_at
  ) values (
    v_user_id, p_latitude, p_longitude, p_accuracy_m, p_heading, p_speed_mps,
    p_battery, false, clock_timestamp()
  )
  on conflict (user_id) do update set
    latitude = excluded.latitude,
    longitude = excluded.longitude,
    accuracy_m = excluded.accuracy_m,
    heading = excluded.heading,
    speed_mps = excluded.speed_mps,
    battery = excluded.battery,
    is_ghost = excluded.is_ghost,
    updated_at = excluded.updated_at;
end;
$$;

create or replace function app_api_v1.set_ghost_mode(p_ghost boolean)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if p_ghost is null then
    raise exception 'Ghost mode is required' using errcode = '22023';
  end if;
  perform 1 from core.user_academic_profiles profile
  where profile.user_id = v_user_id
  for share;
  if not found then
    raise exception 'Ghost mode is unavailable' using errcode = '42501';
  end if;
  insert into user_private.friend_location_preferences (
    user_id, is_ghost, updated_at
  ) values (v_user_id, p_ghost, clock_timestamp())
  on conflict (user_id) do update set
    is_ghost = excluded.is_ghost,
    updated_at = excluded.updated_at;
  if p_ghost then
    delete from public.friend_locations location
    where location.user_id = v_user_id;
  else
    update public.friend_locations location
    set is_ghost = false
    where location.user_id = v_user_id;
  end if;
end;
$$;

create or replace function public.set_location_visibility(
  p_visible_to_students boolean
)
returns void
language sql
security definer
set search_path = ''
as $$ select app_api_v1.set_location_visibility(p_visible_to_students); $$;

create or replace function public.get_map_students()
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$ select app_api_v1.get_map_students(); $$;

revoke all on function app_api_v1.get_location_visibility()
from public, anon, authenticated;
revoke all on function app_api_v1.set_location_visibility(boolean)
from public, anon, authenticated;
revoke all on function app_api_v1.get_map_students()
from public, anon, authenticated;
grant execute on function app_api_v1.get_location_visibility() to service_role;
grant execute on function app_api_v1.set_location_visibility(boolean)
to service_role;
grant execute on function app_api_v1.get_map_students() to service_role;

revoke all on function public.get_location_visibility() from public, anon;
revoke all on function public.set_location_visibility(boolean) from public, anon;
revoke all on function public.get_map_students() from public, anon;
grant execute on function public.get_location_visibility()
to authenticated, service_role;
grant execute on function public.set_location_visibility(boolean)
to authenticated, service_role;
grant execute on function public.get_map_students()
to authenticated, service_role;
