create table user_private.friend_location_preferences (
  user_id uuid primary key references auth.users(id) on delete cascade,
  is_ghost boolean not null default false,
  updated_at timestamptz not null default now()
);

insert into user_private.friend_location_preferences (
  user_id,
  is_ghost,
  updated_at
)
select location.user_id, location.is_ghost, location.updated_at
from public.friend_locations location
on conflict (user_id) do update set
  is_ghost = excluded.is_ghost,
  updated_at = excluded.updated_at;

alter table user_private.friend_location_preferences enable row level security;
revoke all on user_private.friend_location_preferences
from public, anon, authenticated;
grant all on user_private.friend_location_preferences to service_role;

create or replace function app_api_v1.get_ghost_mode()
returns boolean
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;

  return coalesce(
    (
      select preference.is_ghost
      from user_private.friend_location_preferences preference
      where preference.user_id = v_user_id
    ),
    false
  );
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
  v_is_ghost boolean := coalesce(p_ghost, false);
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;

  insert into user_private.friend_location_preferences (
    user_id,
    is_ghost,
    updated_at
  )
  values (v_user_id, v_is_ghost, now())
  on conflict (user_id) do update set
    is_ghost = excluded.is_ghost,
    updated_at = excluded.updated_at;

  update public.friend_locations
  set is_ghost = v_is_ghost, updated_at = now()
  where user_id = v_user_id;
end;
$$;

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
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;

  select coalesce(preference.is_ghost, false)
  into v_is_ghost
  from user_private.friend_location_preferences preference
  where preference.user_id = v_user_id;
  v_is_ghost := coalesce(v_is_ghost, false);

  insert into public.friend_locations (
    user_id,
    latitude,
    longitude,
    accuracy_m,
    heading,
    speed_mps,
    battery,
    is_ghost,
    updated_at
  )
  values (
    v_user_id,
    p_latitude,
    p_longitude,
    p_accuracy_m,
    p_heading,
    p_speed_mps,
    p_battery,
    v_is_ghost,
    now()
  )
  on conflict (user_id) do update set
    latitude = excluded.latitude,
    longitude = excluded.longitude,
    accuracy_m = excluded.accuracy_m,
    heading = excluded.heading,
    speed_mps = excluded.speed_mps,
    battery = excluded.battery,
    is_ghost = v_is_ghost,
    updated_at = excluded.updated_at;
end;
$$;

create or replace function public.get_ghost_mode()
returns boolean
language sql
stable
security invoker
set search_path = ''
as $$ select app_api_v1.get_ghost_mode(); $$;

revoke all on function app_api_v1.get_ghost_mode()
from public, anon;
revoke all on function app_api_v1.set_ghost_mode(boolean)
from public, anon;
revoke all on function app_api_v1.upsert_my_location(
  double precision,
  double precision,
  double precision,
  double precision,
  double precision,
  integer
) from public, anon;
revoke all on function public.get_ghost_mode() from public, anon;

grant execute on function app_api_v1.get_ghost_mode()
to authenticated, service_role;
grant execute on function app_api_v1.set_ghost_mode(boolean)
to authenticated, service_role;
grant execute on function app_api_v1.upsert_my_location(
  double precision,
  double precision,
  double precision,
  double precision,
  double precision,
  integer
) to authenticated, service_role;
grant execute on function public.get_ghost_mode()
to authenticated, service_role;
