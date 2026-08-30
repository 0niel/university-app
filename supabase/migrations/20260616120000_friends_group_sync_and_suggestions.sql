-- Friends: group-matching + "people you may know".
--
-- 1. Sync the active group schedule into core.user_academic_profiles.academic_group
--    so group-based matching (get_group_members, group RLS) has a value to match
--    on. The selected schedule already syncs to user_private.user_preferences
--    (key 'selected_schedule'); a trigger mirrors a *group* selection into the
--    profile's academic_group. Teacher/classroom selections leave it untouched.
-- 2. get_group_members now returns { group, members } so the sheet can show the
--    group code, and isFriend means accepted (not merely pending).
-- 3. get_people_you_may_know: friends-of-friends ranked by mutual count, with
--    same-group non-friends as a fallback signal.

-- ── 1. active group → academic_group ─────────────────────────────────────────

create or replace function core.sync_academic_group_from_schedule()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_group text := nullif(btrim(new.value->>'name'), '');
begin
  if coalesce(new.value->>'type', '') <> 'group' or v_group is null then
    return new;
  end if;
  update core.user_academic_profiles
     set academic_group = v_group, updated_at = now()
   where user_id = new.user_id
     and coalesce(academic_group, '') is distinct from v_group;
  return new;
end;
$$;

drop trigger if exists sync_academic_group_from_schedule
  on user_private.user_preferences;

create trigger sync_academic_group_from_schedule
after insert or update on user_private.user_preferences
for each row
when (new.key = 'selected_schedule')
execute function core.sync_academic_group_from_schedule();

-- Backfill: existing users who already picked a group schedule but have no
-- academic_group on their profile yet.
update core.user_academic_profiles p
   set academic_group = nullif(btrim(pref.value->>'name'), ''), updated_at = now()
  from user_private.user_preferences pref
 where pref.user_id = p.user_id
   and pref.key = 'selected_schedule'
   and coalesce(pref.value->>'type', '') = 'group'
   and nullif(btrim(pref.value->>'name'), '') is not null
   and coalesce(p.academic_group, '') = '';

-- ── 2. group roster (now returns the group code alongside members) ───────────

create or replace function app_api_v1.get_group_members()
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select jsonb_build_object(
    'group', core.current_academic_group(),
    'members', coalesce(
      (
        select jsonb_agg(
          jsonb_build_object(
            'userId', p.user_id,
            'fullName', p.full_name,
            'handle', p.handle,
            'isMe', p.user_id = (select auth.uid()),
            'isFriend', f.id is not null and f.status = 'accepted',
            'friendshipStatus', f.status
          )
          order by p.full_name
        )
        from core.user_academic_profiles p
        left join core.friendships f
          on least(f.requester_id, f.addressee_id)
               = least(p.user_id, (select auth.uid()))
         and greatest(f.requester_id, f.addressee_id)
               = greatest(p.user_id, (select auth.uid()))
        where p.academic_group is not null
          and p.academic_group = core.current_academic_group()
      ),
      '[]'::jsonb
    )
  );
$$;

-- ── 3. people you may know ───────────────────────────────────────────────────

-- Suggestions to befriend: friends-of-friends ranked by shared-friend count.
-- Excludes self, anyone already connected (pending or accepted), and members of
-- the caller's own academic group — those are surfaced in the "from your group"
-- section, so listing them here too would duplicate the same people. Security
-- definer: profiles are owner-RLS'd but suggestions need to read peers.
create or replace function app_api_v1.get_people_you_may_know(
  p_limit integer default 12
)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  with my_friends as (
    select case
             when f.requester_id = (select auth.uid())
               then f.addressee_id else f.requester_id
           end as fid
    from core.friendships f
    where f.status = 'accepted'
      and (select auth.uid()) in (f.requester_id, f.addressee_id)
  ),
  fof as (
    select case
             when f.requester_id = mf.fid then f.addressee_id
             else f.requester_id
           end as cid
    from core.friendships f
    join my_friends mf on mf.fid in (f.requester_id, f.addressee_id)
    where f.status = 'accepted'
  ),
  mutuals as (
    select cid, count(*)::int as mutual
    from fof
    where cid <> (select auth.uid())
      and cid not in (select fid from my_friends)
    group by cid
  ),
  ranked as (
    select m.cid, m.mutual, p.full_name, p.handle, p.academic_group
    from mutuals m
    join core.user_academic_profiles p on p.user_id = m.cid
    where coalesce(p.full_name, '') <> ''
      and not (
        core.current_academic_group() is not null
        and p.academic_group = core.current_academic_group()
      )
      and not exists (
        select 1 from core.friendships f2
        where least(f2.requester_id, f2.addressee_id)
                = least(m.cid, (select auth.uid()))
          and greatest(f2.requester_id, f2.addressee_id)
                = greatest(m.cid, (select auth.uid()))
      )
    order by m.mutual desc, p.full_name
    limit greatest(p_limit, 0)
  )
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'userId', r.cid,
        'fullName', r.full_name,
        'handle', r.handle,
        'group', r.academic_group,
        'mutualCount', r.mutual
      )
      order by r.mutual desc, r.full_name
    ),
    '[]'::jsonb
  )
  from ranked r;
$$;

create or replace function public.get_people_you_may_know(
  p_limit integer default 12
)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select app_api_v1.get_people_you_may_know(p_limit);
$$;

revoke all on function public.get_people_you_may_know(integer) from public, anon;
grant execute on function public.get_people_you_may_know(integer) to authenticated;
