-- Friends graph + Zenly-style live locations.
--
-- core.friendships stores the social graph (request → accepted) with owner
-- RLS. public.friend_locations stores each user's last known location; it
-- lives in the exposed public schema so supabase_flutter can subscribe to
-- postgres_changes (RLS-filtered) for the realtime friends map. Writes go
-- through app_api_v1 functions behind thin public wrappers, mirroring the
-- attendance slice conventions.

-- ── friendships ──────────────────────────────────────────────────────────────

create table core.friendships (
  id uuid primary key default extensions.gen_random_uuid(),
  requester_id uuid not null references auth.users(id) on delete cascade,
  addressee_id uuid not null references auth.users(id) on delete cascade,
  status text not null default 'pending',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint friendships_status_valid check (status in ('pending', 'accepted')),
  constraint friendships_no_self check (requester_id <> addressee_id)
);

-- One edge per unordered pair.
create unique index friendships_pair_unique
on core.friendships (
  least(requester_id, addressee_id),
  greatest(requester_id, addressee_id)
);

create index friendships_addressee_idx on core.friendships (addressee_id);

create trigger set_friendships_updated_at
before update on core.friendships
for each row execute function core.set_updated_at();

alter table core.friendships enable row level security;

create policy "participants can read friendship"
on core.friendships
for select
to authenticated
using ((select auth.uid()) in (requester_id, addressee_id));

create policy "users can send friend requests"
on core.friendships
for insert
to authenticated
with check ((select auth.uid()) = requester_id and status = 'pending');

create policy "addressee can accept friendship"
on core.friendships
for update
to authenticated
using ((select auth.uid()) = addressee_id)
with check ((select auth.uid()) = addressee_id);

create policy "participants can remove friendship"
on core.friendships
for delete
to authenticated
using ((select auth.uid()) in (requester_id, addressee_id));

grant select, insert, update, delete on core.friendships to authenticated;
grant all on core.friendships to service_role;

-- Helper used by friend_locations RLS; security definer so the location
-- policy does not re-enter friendships RLS.
create or replace function core.are_friends(a uuid, b uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from core.friendships f
    where f.status = 'accepted'
      and least(f.requester_id, f.addressee_id) = least(a, b)
      and greatest(f.requester_id, f.addressee_id) = greatest(a, b)
  );
$$;

revoke all on function core.are_friends(uuid, uuid) from public, anon;
grant execute on function core.are_friends(uuid, uuid) to authenticated;

-- ── live locations (public schema → realtime postgres_changes) ──────────────

create table public.friend_locations (
  user_id uuid primary key references auth.users(id) on delete cascade,
  latitude double precision not null,
  longitude double precision not null,
  accuracy_m double precision,
  heading double precision,
  speed_mps double precision,
  battery smallint,
  mood text not null default '',
  is_ghost boolean not null default false,
  updated_at timestamptz not null default now(),
  constraint friend_locations_lat_valid check (latitude between -90 and 90),
  constraint friend_locations_lng_valid check (longitude between -180 and 180),
  constraint friend_locations_battery_valid
    check (battery is null or battery between 0 and 100),
  constraint friend_locations_mood_short check (length(mood) <= 40)
);

alter table public.friend_locations replica identity full;

alter table public.friend_locations enable row level security;

create policy "owner or friends can read locations"
on public.friend_locations
for select
to authenticated
using (
  (select auth.uid()) = user_id
  or (
    not is_ghost
    and core.are_friends((select auth.uid()), user_id)
  )
);

create policy "owner can insert own location"
on public.friend_locations
for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "owner can update own location"
on public.friend_locations
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "owner can delete own location"
on public.friend_locations
for delete
to authenticated
using ((select auth.uid()) = user_id);

grant select, insert, update, delete on public.friend_locations to authenticated;
grant all on public.friend_locations to service_role;

alter publication supabase_realtime add table public.friend_locations;

-- ── app_api_v1 implementation ────────────────────────────────────────────────

-- Search students by name / handle / group to add as friends. Security
-- definer: academic profiles are owner-RLS'd but search needs to see peers.
create or replace function app_api_v1.search_users(p_query text)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'userId', uap.user_id,
        'fullName', uap.full_name,
        'handle', uap.handle,
        'group', uap.academic_group,
        'friendshipId', f.id,
        'friendshipStatus', f.status,
        'isIncoming', f.addressee_id = (select auth.uid())
      )
      order by uap.full_name
    ),
    '[]'::jsonb
  )
  from (
    select *
    from core.user_academic_profiles p
    where p.user_id <> (select auth.uid())
      and (
        p.full_name ilike '%' || p_query || '%'
        or p.handle ilike '%' || p_query || '%'
        or p.academic_group ilike '%' || p_query || '%'
      )
    limit 20
  ) uap
  left join core.friendships f
    on least(f.requester_id, f.addressee_id)
         = least(uap.user_id, (select auth.uid()))
   and greatest(f.requester_id, f.addressee_id)
         = greatest(uap.user_id, (select auth.uid()));
$$;

-- Accepted friends with profile + last known location (for list & map seed).
create or replace function app_api_v1.get_friends()
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'friendshipId', f.id,
        'userId', friend_id,
        'fullName', uap.full_name,
        'handle', uap.handle,
        'group', uap.academic_group,
        'latitude', case when fl.is_ghost then null else fl.latitude end,
        'longitude', case when fl.is_ghost then null else fl.longitude end,
        'battery', case when fl.is_ghost then null else fl.battery end,
        'mood', coalesce(fl.mood, ''),
        'isGhost', coalesce(fl.is_ghost, false),
        'locationUpdatedAt',
          case when fl.is_ghost then null else fl.updated_at end
      )
      order by uap.full_name
    ),
    '[]'::jsonb
  )
  from (
    select f.id,
           case
             when f.requester_id = (select auth.uid()) then f.addressee_id
             else f.requester_id
           end as friend_id
    from core.friendships f
    where f.status = 'accepted'
      and (select auth.uid()) in (f.requester_id, f.addressee_id)
  ) f
  left join core.user_academic_profiles uap on uap.user_id = f.friend_id
  left join public.friend_locations fl on fl.user_id = f.friend_id;
$$;

-- Incoming pending requests.
create or replace function app_api_v1.get_friend_requests()
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'friendshipId', f.id,
        'userId', f.requester_id,
        'fullName', uap.full_name,
        'handle', uap.handle,
        'group', uap.academic_group,
        'createdAt', f.created_at
      )
      order by f.created_at desc
    ),
    '[]'::jsonb
  )
  from core.friendships f
  left join core.user_academic_profiles uap on uap.user_id = f.requester_id
  where f.status = 'pending'
    and f.addressee_id = (select auth.uid());
$$;

create or replace function app_api_v1.send_friend_request(p_user_id uuid)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;
  if p_user_id = v_user_id then
    raise exception 'Cannot befriend yourself';
  end if;

  insert into core.friendships (requester_id, addressee_id)
  values (v_user_id, p_user_id)
  on conflict (
    least(requester_id, addressee_id),
    greatest(requester_id, addressee_id)
  ) do nothing;
end;
$$;

create or replace function app_api_v1.respond_friend_request(
  p_friendship_id uuid,
  p_accept boolean
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;

  if p_accept then
    update core.friendships
    set status = 'accepted'
    where id = p_friendship_id
      and addressee_id = v_user_id
      and status = 'pending';
  else
    delete from core.friendships
    where id = p_friendship_id
      and addressee_id = v_user_id
      and status = 'pending';
  end if;
end;
$$;

create or replace function app_api_v1.remove_friend(p_user_id uuid)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;

  delete from core.friendships
  where least(requester_id, addressee_id) = least(v_user_id, p_user_id)
    and greatest(requester_id, addressee_id) = greatest(v_user_id, p_user_id);
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
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;

  insert into public.friend_locations (
    user_id, latitude, longitude, accuracy_m, heading, speed_mps, battery,
    updated_at
  )
  values (
    v_user_id, p_latitude, p_longitude, p_accuracy_m, p_heading, p_speed_mps,
    p_battery, now()
  )
  on conflict (user_id) do update set
    latitude = excluded.latitude,
    longitude = excluded.longitude,
    accuracy_m = excluded.accuracy_m,
    heading = excluded.heading,
    speed_mps = excluded.speed_mps,
    battery = excluded.battery,
    updated_at = now();
end;
$$;

create or replace function app_api_v1.set_ghost_mode(p_ghost boolean)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;

  update public.friend_locations
  set is_ghost = p_ghost, updated_at = now()
  where user_id = v_user_id;
end;
$$;

create or replace function app_api_v1.set_location_mood(p_mood text)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;

  update public.friend_locations
  set mood = coalesce(p_mood, ''), updated_at = now()
  where user_id = v_user_id;
end;
$$;

-- ── public wrappers ──────────────────────────────────────────────────────────

create or replace function public.search_users(p_query text)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select app_api_v1.search_users(p_query);
$$;

create or replace function public.get_friends()
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select app_api_v1.get_friends();
$$;

create or replace function public.get_friend_requests()
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select app_api_v1.get_friend_requests();
$$;

create or replace function public.send_friend_request(p_user_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.send_friend_request(p_user_id);
$$;

create or replace function public.respond_friend_request(
  p_friendship_id uuid,
  p_accept boolean
)
returns void
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.respond_friend_request(p_friendship_id, p_accept);
$$;

create or replace function public.remove_friend(p_user_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.remove_friend(p_user_id);
$$;

create or replace function public.upsert_my_location(
  p_latitude double precision,
  p_longitude double precision,
  p_accuracy_m double precision default null,
  p_heading double precision default null,
  p_speed_mps double precision default null,
  p_battery integer default null
)
returns void
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.upsert_my_location(
    p_latitude, p_longitude, p_accuracy_m, p_heading, p_speed_mps, p_battery
  );
$$;

create or replace function public.set_ghost_mode(p_ghost boolean)
returns void
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.set_ghost_mode(p_ghost);
$$;

create or replace function public.set_location_mood(p_mood text)
returns void
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.set_location_mood(p_mood);
$$;

-- Lock the wrappers down to signed-in users.
revoke all on function public.search_users(text) from public, anon;
revoke all on function public.get_friends() from public, anon;
revoke all on function public.get_friend_requests() from public, anon;
revoke all on function public.send_friend_request(uuid) from public, anon;
revoke all on function public.respond_friend_request(uuid, boolean)
  from public, anon;
revoke all on function public.remove_friend(uuid) from public, anon;
revoke all on function public.upsert_my_location(
  double precision, double precision, double precision, double precision,
  double precision, integer
) from public, anon;
revoke all on function public.set_ghost_mode(boolean) from public, anon;
revoke all on function public.set_location_mood(text) from public, anon;

grant execute on function public.search_users(text) to authenticated;
grant execute on function public.get_friends() to authenticated;
grant execute on function public.get_friend_requests() to authenticated;
grant execute on function public.send_friend_request(uuid) to authenticated;
grant execute on function public.respond_friend_request(uuid, boolean)
  to authenticated;
grant execute on function public.remove_friend(uuid) to authenticated;
grant execute on function public.upsert_my_location(
  double precision, double precision, double precision, double precision,
  double precision, integer
) to authenticated;
grant execute on function public.set_ghost_mode(boolean) to authenticated;
grant execute on function public.set_location_mood(text) to authenticated;
