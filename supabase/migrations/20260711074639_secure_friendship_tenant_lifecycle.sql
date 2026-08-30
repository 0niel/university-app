alter table core.friendships
  add column if not exists organization_id text;

update core.friendships friendship
set organization_id = requester.organization_id
from core.user_academic_profiles requester,
     core.user_academic_profiles addressee
where requester.user_id = friendship.requester_id
  and addressee.user_id = friendship.addressee_id
  and requester.organization_id = addressee.organization_id;

delete from core.friendships
where organization_id is null;

alter table core.friendships
  alter column organization_id set not null,
  add constraint friendships_organization_fk
    foreign key (organization_id)
    references core.organizations(id)
    on delete cascade;

create index if not exists friendships_organization_status_idx
on core.friendships (organization_id, status, updated_at desc);

create or replace function internal.guard_friendship_organization()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  perform 1
  from core.user_academic_profiles profile
  where profile.user_id in (new.requester_id, new.addressee_id)
  order by profile.user_id
  for update;
  if not exists (
    select 1
    from core.user_academic_profiles requester
    join core.user_academic_profiles addressee
      on addressee.user_id = new.addressee_id
      and addressee.organization_id = requester.organization_id
    where requester.user_id = new.requester_id
      and requester.organization_id = new.organization_id
  ) then
    raise exception 'Friendship participants must share an organization'
      using errcode = '23514';
  end if;
  return new;
end;
$$;

drop trigger if exists guard_friendship_organization
on core.friendships;
create trigger guard_friendship_organization
before insert or update of requester_id, addressee_id, organization_id
on core.friendships
for each row execute function internal.guard_friendship_organization();

revoke all on function internal.guard_friendship_organization()
from public, anon, authenticated;
grant execute on function internal.guard_friendship_organization()
to service_role;

drop policy if exists "participants can read friendship"
on core.friendships;
drop policy if exists "users can send friend requests"
on core.friendships;
drop policy if exists "addressee can accept friendship"
on core.friendships;
drop policy if exists "participants can remove friendship"
on core.friendships;

create policy "same organization participants read friendship"
on core.friendships for select to authenticated
using (
  (select auth.uid()) in (requester_id, addressee_id)
  and exists (
    select 1
    from core.user_academic_profiles viewer
    where viewer.user_id = (select auth.uid())
      and viewer.organization_id = friendships.organization_id
  )
);

revoke select, insert, update, delete on core.friendships
from authenticated;
revoke insert, update, delete on public.friend_locations
from authenticated;
grant select on public.friend_locations to authenticated;

create or replace function core.are_friends(a uuid, b uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from core.friendships friendship
    join core.user_academic_profiles first_profile
      on first_profile.user_id = a
      and first_profile.organization_id = friendship.organization_id
    join core.user_academic_profiles second_profile
      on second_profile.user_id = b
      and second_profile.organization_id = friendship.organization_id
    where friendship.status = 'accepted'
      and least(friendship.requester_id, friendship.addressee_id) = least(a, b)
      and greatest(friendship.requester_id, friendship.addressee_id)
        = greatest(a, b)
  );
$$;

revoke all on function core.are_friends(uuid, uuid)
from public, anon;
grant execute on function core.are_friends(uuid, uuid)
to authenticated, service_role;

create or replace function app_api_v1.search_users(p_query text)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_organization_id text;
  v_query text := btrim(coalesce(p_query, ''));
  v_result jsonb;
begin
  select profile.organization_id into v_organization_id
  from core.user_academic_profiles profile
  where profile.user_id = v_user_id;
  if v_organization_id is null then
    raise exception 'People search is unavailable' using errcode = '42501';
  end if;
  if char_length(v_query) < 2 or char_length(v_query) > 80 then
    raise exception 'Search query length is invalid' using errcode = '22023';
  end if;
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'userId', candidate.user_id,
        'fullName', candidate.full_name,
        'handle', candidate.handle,
        'group', candidate.academic_group,
        'friendshipId', friendship.id,
        'friendshipStatus', friendship.status,
        'isIncoming', friendship.addressee_id = v_user_id
      ) order by candidate.full_name, candidate.user_id
    ),
    '[]'::jsonb
  ) into v_result
  from (
    select profile.*
    from core.user_academic_profiles profile
    where profile.organization_id = v_organization_id
      and profile.user_id <> v_user_id
      and (
        profile.full_name ilike '%' || v_query || '%'
        or profile.handle ilike '%' || v_query || '%'
        or profile.academic_group ilike '%' || v_query || '%'
      )
    order by profile.full_name, profile.user_id
    limit 20
  ) candidate
  left join core.friendships friendship
    on friendship.organization_id = v_organization_id
    and least(friendship.requester_id, friendship.addressee_id)
      = least(candidate.user_id, v_user_id)
    and greatest(friendship.requester_id, friendship.addressee_id)
      = greatest(candidate.user_id, v_user_id);
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
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'friendshipId', edge.id,
        'userId', edge.friend_id,
        'fullName', profile.full_name,
        'handle', profile.handle,
        'group', profile.academic_group,
        'latitude', case when location.is_ghost then null
          else location.latitude end,
        'longitude', case when location.is_ghost then null
          else location.longitude end,
        'battery', case when location.is_ghost then null
          else location.battery end,
        'mood', case when location.is_ghost then ''
          else coalesce(location.mood, '') end,
        'isGhost', coalesce(location.is_ghost, false),
        'locationUpdatedAt', case when location.is_ghost then null
          else location.updated_at end
      ) order by profile.full_name, edge.friend_id
    ),
    '[]'::jsonb
  ) into v_result
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
    on location.user_id = edge.friend_id;
  return v_result;
end;
$$;

create or replace function app_api_v1.get_friend_requests()
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
    raise exception 'Friend requests are unavailable' using errcode = '42501';
  end if;
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'friendshipId', friendship.id,
        'userId', friendship.requester_id,
        'fullName', profile.full_name,
        'handle', profile.handle,
        'group', profile.academic_group,
        'createdAt', friendship.created_at
      ) order by friendship.created_at desc
    ),
    '[]'::jsonb
  ) into v_result
  from core.friendships friendship
  join core.user_academic_profiles profile
    on profile.user_id = friendship.requester_id
    and profile.organization_id = v_organization_id
  where friendship.organization_id = v_organization_id
    and friendship.status = 'pending'
    and friendship.addressee_id = v_user_id;
  return v_result;
end;
$$;

create or replace function app_api_v1.send_friend_request(p_user_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_organization_id text;
begin
  select sender.organization_id into v_organization_id
  from core.user_academic_profiles sender
  join core.user_academic_profiles recipient
    on recipient.user_id = p_user_id
    and recipient.organization_id = sender.organization_id
  where sender.user_id = v_user_id;
  if v_organization_id is null or p_user_id = v_user_id then
    raise exception 'Friend request is unavailable' using errcode = '42501';
  end if;
  perform core.enforce_rate_limit(
    'send_friend_request', 30, interval '1 hour'
  );
  insert into core.friendships (
    requester_id, addressee_id, organization_id
  ) values (v_user_id, p_user_id, v_organization_id)
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
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_organization_id text;
begin
  select profile.organization_id into v_organization_id
  from core.user_academic_profiles profile
  where profile.user_id = v_user_id;
  if coalesce(p_accept, false) then
    update core.friendships friendship
    set status = 'accepted'
    where friendship.id = p_friendship_id
      and friendship.addressee_id = v_user_id
      and friendship.organization_id = v_organization_id
      and friendship.status = 'pending';
  else
    delete from core.friendships friendship
    where friendship.id = p_friendship_id
      and friendship.addressee_id = v_user_id
      and friendship.organization_id = v_organization_id
      and friendship.status = 'pending';
  end if;
  if not found then
    raise exception 'Friend request is unavailable' using errcode = '42501';
  end if;
end;
$$;

create or replace function app_api_v1.remove_friend(p_user_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_organization_id text;
begin
  select profile.organization_id into v_organization_id
  from core.user_academic_profiles profile
  where profile.user_id = v_user_id;
  delete from core.friendships friendship
  where friendship.organization_id = v_organization_id
    and least(friendship.requester_id, friendship.addressee_id)
      = least(v_user_id, p_user_id)
    and greatest(friendship.requester_id, friendship.addressee_id)
      = greatest(v_user_id, p_user_id);
  if not found then
    raise exception 'Friendship is unavailable' using errcode = '42501';
  end if;
end;
$$;

create or replace function app_api_v1.get_group_members()
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_organization_id text;
  v_group text;
  v_members jsonb;
begin
  select profile.organization_id, profile.academic_group
  into v_organization_id, v_group
  from core.user_academic_profiles profile
  where profile.user_id = v_user_id;
  if v_organization_id is null then
    raise exception 'Group roster is unavailable' using errcode = '42501';
  end if;
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'userId', profile.user_id,
        'fullName', profile.full_name,
        'handle', profile.handle,
        'isMe', profile.user_id = v_user_id,
        'isFriend', friendship.status = 'accepted',
        'friendshipStatus', friendship.status
      ) order by profile.full_name, profile.user_id
    ),
    '[]'::jsonb
  ) into v_members
  from core.user_academic_profiles profile
  left join core.friendships friendship
    on friendship.organization_id = v_organization_id
    and least(friendship.requester_id, friendship.addressee_id)
      = least(profile.user_id, v_user_id)
    and greatest(friendship.requester_id, friendship.addressee_id)
      = greatest(profile.user_id, v_user_id)
  where v_group is not null
    and profile.organization_id = v_organization_id
    and profile.academic_group = v_group;
  return jsonb_build_object('group', v_group, 'members', v_members);
end;
$$;

create or replace function app_api_v1.get_people_you_may_know(
  p_limit integer default 12
)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_organization_id text;
  v_group text;
  v_result jsonb;
begin
  select profile.organization_id, profile.academic_group
  into v_organization_id, v_group
  from core.user_academic_profiles profile
  where profile.user_id = v_user_id;
  if v_organization_id is null then
    raise exception 'Friend suggestions are unavailable' using errcode = '42501';
  end if;
  if p_limit is null or p_limit < 0 or p_limit > 50 then
    raise exception 'Suggestion limit is invalid' using errcode = '22023';
  end if;
  with my_friends as (
    select case when friendship.requester_id = v_user_id
      then friendship.addressee_id else friendship.requester_id end friend_id
    from core.friendships friendship
    where friendship.organization_id = v_organization_id
      and friendship.status = 'accepted'
      and v_user_id in (friendship.requester_id, friendship.addressee_id)
  ), candidates as (
    select case when friendship.requester_id = mine.friend_id
      then friendship.addressee_id else friendship.requester_id end user_id
    from core.friendships friendship
    join my_friends mine
      on mine.friend_id in (
        friendship.requester_id, friendship.addressee_id
      )
    where friendship.organization_id = v_organization_id
      and friendship.status = 'accepted'
  ), mutuals as (
    select candidate.user_id, count(*)::integer mutual_count
    from candidates candidate
    where candidate.user_id <> v_user_id
      and candidate.user_id not in (select friend_id from my_friends)
    group by candidate.user_id
  ), ranked as (
    select
      mutual.user_id,
      mutual.mutual_count,
      profile.full_name,
      profile.handle,
      profile.academic_group
    from mutuals mutual
    join core.user_academic_profiles profile
      on profile.user_id = mutual.user_id
      and profile.organization_id = v_organization_id
    where coalesce(profile.full_name, '') <> ''
      and (v_group is null or profile.academic_group is distinct from v_group)
      and not exists (
        select 1
        from core.friendships existing
        where existing.organization_id = v_organization_id
          and least(existing.requester_id, existing.addressee_id)
            = least(mutual.user_id, v_user_id)
          and greatest(existing.requester_id, existing.addressee_id)
            = greatest(mutual.user_id, v_user_id)
      )
    order by mutual.mutual_count desc, profile.full_name, mutual.user_id
    limit p_limit
  )
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'userId', ranked.user_id,
        'fullName', ranked.full_name,
        'handle', ranked.handle,
        'group', ranked.academic_group,
        'mutualCount', ranked.mutual_count
      ) order by ranked.mutual_count desc, ranked.full_name, ranked.user_id
    ),
    '[]'::jsonb
  ) into v_result
  from ranked;
  return v_result;
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
  if not exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = v_user_id
  ) then
    raise exception 'Location sharing is unavailable' using errcode = '42501';
  end if;
  insert into user_private.friend_location_preferences (user_id, is_ghost)
  values (v_user_id, false)
  on conflict (user_id) do nothing;
  select preference.is_ghost into v_is_ghost
  from user_private.friend_location_preferences preference
  where preference.user_id = v_user_id
  for update;
  insert into public.friend_locations (
    user_id, latitude, longitude, accuracy_m, heading, speed_mps, battery,
    is_ghost, updated_at
  ) values (
    v_user_id, p_latitude, p_longitude, p_accuracy_m, p_heading, p_speed_mps,
    p_battery, coalesce(v_is_ghost, false), clock_timestamp()
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
  v_is_ghost boolean := coalesce(p_ghost, false);
begin
  if not exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = v_user_id
  ) then
    raise exception 'Ghost mode is unavailable' using errcode = '42501';
  end if;
  insert into user_private.friend_location_preferences (
    user_id, is_ghost, updated_at
  ) values (v_user_id, v_is_ghost, clock_timestamp())
  on conflict (user_id) do update set
    is_ghost = excluded.is_ghost,
    updated_at = excluded.updated_at;
  update public.friend_locations location
  set is_ghost = v_is_ghost
  where location.user_id = v_user_id;
end;
$$;

create or replace function app_api_v1.set_location_mood(p_mood text)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_mood text := btrim(coalesce(p_mood, ''));
begin
  if char_length(v_mood) > 40 or not exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = v_user_id
  ) then
    raise exception 'Location mood is unavailable' using errcode = '42501';
  end if;
  update public.friend_locations location
  set mood = v_mood
  where location.user_id = v_user_id;
end;
$$;

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
  end if;
  return new;
end;
$$;

drop trigger if exists reconcile_friendships_on_org_change
on core.user_academic_profiles;
create trigger reconcile_friendships_on_org_change
after update of organization_id on core.user_academic_profiles
for each row execute function internal.reconcile_friendships_on_org_change();

create or replace function public.get_ghost_mode()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$ select app_api_v1.get_ghost_mode(); $$;

create or replace function public.send_friend_request(p_user_id uuid)
returns void
language sql
security definer
set search_path = ''
as $$ select app_api_v1.send_friend_request(p_user_id); $$;

create or replace function public.respond_friend_request(
  p_friendship_id uuid,
  p_accept boolean
)
returns void
language sql
security definer
set search_path = ''
as $$
  select app_api_v1.respond_friend_request(p_friendship_id, p_accept);
$$;

create or replace function public.remove_friend(p_user_id uuid)
returns void
language sql
security definer
set search_path = ''
as $$ select app_api_v1.remove_friend(p_user_id); $$;

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
security definer
set search_path = ''
as $$
  select app_api_v1.upsert_my_location(
    p_latitude, p_longitude, p_accuracy_m, p_heading, p_speed_mps, p_battery
  );
$$;

create or replace function public.set_ghost_mode(p_ghost boolean)
returns void
language sql
security definer
set search_path = ''
as $$ select app_api_v1.set_ghost_mode(p_ghost); $$;

create or replace function public.set_location_mood(p_mood text)
returns void
language sql
security definer
set search_path = ''
as $$ select app_api_v1.set_location_mood(p_mood); $$;

revoke all on function internal.reconcile_friendships_on_org_change()
from public, anon, authenticated;
grant execute on function internal.reconcile_friendships_on_org_change()
to service_role;

revoke all on function app_api_v1.search_users(text)
from public, anon, authenticated;
revoke all on function app_api_v1.get_friends()
from public, anon, authenticated;
revoke all on function app_api_v1.get_friend_requests()
from public, anon, authenticated;
revoke all on function app_api_v1.send_friend_request(uuid)
from public, anon, authenticated;
revoke all on function app_api_v1.respond_friend_request(uuid, boolean)
from public, anon, authenticated;
revoke all on function app_api_v1.remove_friend(uuid)
from public, anon, authenticated;
revoke all on function app_api_v1.get_group_members()
from public, anon, authenticated;
revoke all on function app_api_v1.get_people_you_may_know(integer)
from public, anon, authenticated;
revoke all on function app_api_v1.upsert_my_location(
  double precision, double precision, double precision,
  double precision, double precision, integer
) from public, anon, authenticated;
revoke all on function app_api_v1.get_ghost_mode()
from public, anon, authenticated;
revoke all on function app_api_v1.set_ghost_mode(boolean)
from public, anon, authenticated;
revoke all on function app_api_v1.set_location_mood(text)
from public, anon, authenticated;

grant execute on function app_api_v1.search_users(text) to service_role;
grant execute on function app_api_v1.get_friends() to service_role;
grant execute on function app_api_v1.get_friend_requests() to service_role;
grant execute on function app_api_v1.send_friend_request(uuid)
to service_role;
grant execute on function app_api_v1.respond_friend_request(uuid, boolean)
to service_role;
grant execute on function app_api_v1.remove_friend(uuid) to service_role;
grant execute on function app_api_v1.get_group_members() to service_role;
grant execute on function app_api_v1.get_people_you_may_know(integer)
to service_role;
grant execute on function app_api_v1.upsert_my_location(
  double precision, double precision, double precision,
  double precision, double precision, integer
) to service_role;
grant execute on function app_api_v1.get_ghost_mode() to service_role;
grant execute on function app_api_v1.set_ghost_mode(boolean)
to service_role;
grant execute on function app_api_v1.set_location_mood(text)
to service_role;

revoke all on function public.search_users(text) from public, anon;
revoke all on function public.get_friends() from public, anon;
revoke all on function public.get_friend_requests() from public, anon;
revoke all on function public.send_friend_request(uuid) from public, anon;
revoke all on function public.respond_friend_request(uuid, boolean)
from public, anon;
revoke all on function public.remove_friend(uuid) from public, anon;
revoke all on function public.get_group_members() from public, anon;
revoke all on function public.get_people_you_may_know(integer)
from public, anon;
revoke all on function public.upsert_my_location(
  double precision, double precision, double precision,
  double precision, double precision, integer
) from public, anon;
revoke all on function public.get_ghost_mode() from public, anon;
revoke all on function public.set_ghost_mode(boolean) from public, anon;
revoke all on function public.set_location_mood(text) from public, anon;

grant execute on function public.search_users(text)
to authenticated, service_role;
grant execute on function public.get_friends()
to authenticated, service_role;
grant execute on function public.get_friend_requests()
to authenticated, service_role;
grant execute on function public.send_friend_request(uuid)
to authenticated, service_role;
grant execute on function public.respond_friend_request(uuid, boolean)
to authenticated, service_role;
grant execute on function public.remove_friend(uuid)
to authenticated, service_role;
grant execute on function public.get_group_members()
to authenticated, service_role;
grant execute on function public.get_people_you_may_know(integer)
to authenticated, service_role;
grant execute on function public.upsert_my_location(
  double precision, double precision, double precision,
  double precision, double precision, integer
) to authenticated, service_role;
grant execute on function public.get_ghost_mode()
to authenticated, service_role;
grant execute on function public.set_ghost_mode(boolean)
to authenticated, service_role;
grant execute on function public.set_location_mood(text)
to authenticated, service_role;
