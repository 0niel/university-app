-- Makes every settings toggle real:
--   1. Schedule-change push — AFTER INSERT trigger on core.schedule_item_change
--      (core.schedule_change_log, referenced by the older digest-diff design,
--      was dropped in 20260614012000_drop_legacy_schedule.sql when the
--      canonical schedule_item model replaced it; schedule_item_change is its
--      live successor — same trigger-SCD2 idea, keyed by source_uid/term
--      instead of a per-target digest). Fans out to users whose
--      selected_schedule preference matches one of the changed item's
--      group/teacher/classroom memberships, deduped per (change row, user)
--      and capped at 3 pushes per user within a short window so one ingest
--      burst can't storm a user's notification tray. 'cancel' rows are
--      skipped: by the time an item is fully orphaned (deleted from
--      schedule_item), the ingest reconcile step has already removed *all*
--      of its group/teacher/classroom edges in prior statements of the same
--      transaction (core.upsert_schedule_payload), so no membership survives
--      to resolve affected users against — a pre-existing gap in the
--      canonical model's change-capture, not something a downstream trigger
--      can recover. add/move/room/teacher/update rows (the vast majority of
--      real-world changes) resolve normally since the item itself still
--      exists.
--   2. Quest evening reminder — daily 17:00 UTC cron nudging users who still
--      have an incomplete daily quest (including users with no progress rows
--      at all today).
--   3. Leaderboard weekly digest — Monday 08:00 UTC cron telling each grouped
--      user their current group rank.
--   4. profile_visibility enforcement — 'nobody' users are anonymized on the
--      leaderboard (ranks stay stable) and excluded from search/roster/
--      suggestion RPCs; 'group' visibility restricts to groupmates in the
--      RPCs that can surface non-groupmates.
-- All new pushes reuse internal.notify_app_push_gated (added in
-- 20260813150000) so the notifications_enabled + per-kind toggles are
-- respected end to end.

-- ── 1. Schedule-change push ──────────────────────────────────────────────────

create table if not exists internal.schedule_change_notifications (
  change_id bigint not null,
  user_id uuid not null references auth.users(id) on delete cascade,
  notified_at timestamptz not null default now(),
  primary key (change_id, user_id)
);

create index if not exists schedule_change_notifications_user_time_idx
on internal.schedule_change_notifications (user_id, notified_at desc);

alter table internal.schedule_change_notifications enable row level security;
grant all on internal.schedule_change_notifications to service_role;

create or replace function internal.notify_schedule_item_change()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_item_id uuid;
  v_kind_label text;
  v_subject text;
  v_body text;
  v_user record;
  v_recent_count integer;
begin
  if new.change_kind = 'cancel' then
    return new; -- membership already gone by the time the item is deleted
  end if;

  select si.id into v_item_id
  from core.schedule_item si
  where si.organization_id = new.organization_id
    and si.term_id = new.term_id
    and si.source_uid = new.source_uid;

  if not found then
    return new;
  end if;

  v_kind_label := case new.change_kind
    when 'add' then 'добавлено'
    when 'move' then 'перенесено'
    when 'room' then 'изменена аудитория'
    when 'teacher' then 'изменён преподаватель'
    else 'изменение'
  end;
  v_subject := coalesce(nullif(new.new_value ->> 'title', ''), 'Занятие');
  v_body := v_subject || ' · '
    || coalesce(to_char(new.lesson_date, 'DD.MM'), '') || ' · ' || v_kind_label;

  for v_user in
    select pref.user_id
    from core.schedule_item_group ig
    join core.schedule_groups g on g.id = ig.group_id
    join user_private.user_preferences pref
      on pref.key = 'selected_schedule'
      and pref.value ->> 'type' = 'group'
      and pref.value ->> 'uid' = g.external_id
    where ig.item_id = v_item_id and g.external_id is not null
    union
    select pref.user_id
    from core.schedule_item_teacher it
    join core.schedule_teachers t on t.id = it.teacher_id
    join user_private.user_preferences pref
      on pref.key = 'selected_schedule'
      and pref.value ->> 'type' = 'teacher'
      and pref.value ->> 'uid' = t.external_id
    where it.item_id = v_item_id and t.external_id is not null
    union
    select pref.user_id
    from core.schedule_item_classroom ic
    join core.schedule_classrooms c on c.id = ic.classroom_id
    join user_private.user_preferences pref
      on pref.key = 'selected_schedule'
      and pref.value ->> 'type' = 'classroom'
      and pref.value ->> 'uid' = c.external_id
    where ic.item_id = v_item_id and c.external_id is not null
  loop
    if exists (
      select 1 from internal.schedule_change_notifications n
      where n.change_id = new.id and n.user_id = v_user.user_id
    ) then
      continue;
    end if;

    -- Cap pushes per user within one ingest burst (schedule_item_change rows
    -- for a full re-sync land in a quick succession of INSERTs).
    select count(*) into v_recent_count
    from internal.schedule_change_notifications n
    where n.user_id = v_user.user_id
      and n.notified_at >= now() - interval '2 minutes';

    if v_recent_count >= 3 then
      continue;
    end if;

    insert into internal.schedule_change_notifications (change_id, user_id)
    values (new.id, v_user.user_id)
    on conflict (change_id, user_id) do nothing;

    perform internal.notify_app_push_gated(
      v_user.user_id, 'schedule_change',
      '📅 Изменение расписания',
      v_body,
      '/schedule'
    );
  end loop;

  return new;
end;
$$;

revoke all on function internal.notify_schedule_item_change()
from public, anon, authenticated;

drop trigger if exists schedule_item_change_notify
on core.schedule_item_change;

create trigger schedule_item_change_notify
after insert on core.schedule_item_change
for each row execute function internal.notify_schedule_item_change();

-- ── 2. Quest evening reminder ────────────────────────────────────────────────

create or replace function internal.send_quest_evening_reminders()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_today date := (now() at time zone 'UTC')::date;
  v_user record;
begin
  for v_user in
    select p.user_id
    from core.user_gamification_profiles p
    where exists (
      select 1
      from core.quest_definitions qd
      where qd.period = 'daily'
        and not exists (
          select 1
          from core.user_quest_progress uqp
          where uqp.user_id = p.user_id
            and uqp.quest_id = qd.id
            and uqp.period_start = v_today
            and uqp.is_completed
        )
    )
  loop
    perform internal.notify_app_push_gated(
      v_user.user_id, 'quest',
      '🎯 Квесты ждут',
      'Успей закрыть дневные квесты до полуночи',
      '/profile'
    );
  end loop;
end;
$$;

revoke all on function internal.send_quest_evening_reminders()
from public, anon, authenticated;

select cron.schedule(
  'quest-evening-reminder',
  '0 17 * * *',
  $$select internal.send_quest_evening_reminders()$$
);

-- ── 3. Leaderboard weekly digest ─────────────────────────────────────────────

create or replace function internal.send_leaderboard_weekly_digest()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_row record;
begin
  for v_row in
    select
      p.user_id,
      row_number() over (
        partition by p.organization_id, a.academic_group
        order by p.xp desc
      ) as rnk
    from core.user_gamification_profiles p
    join core.user_academic_profiles a on a.user_id = p.user_id
    where coalesce(a.academic_group, '') <> ''
  loop
    perform internal.notify_app_push_gated(
      v_row.user_id, 'leaderboard',
      '🏆 Рейтинг недели',
      'Ты #' || v_row.rnk || ' в группе — открой профиль',
      '/profile'
    );
  end loop;
end;
$$;

revoke all on function internal.send_leaderboard_weekly_digest()
from public, anon, authenticated;

select cron.schedule(
  'leaderboard-weekly',
  '0 8 * * 1',
  $$select internal.send_leaderboard_weekly_digest()$$
);

-- ── 4. profile_visibility enforcement ────────────────────────────────────────

-- (a) leaderboard: 'nobody' users show up as anonymous "Ниндзя" (no handle to
-- strip here) so ranks and scope filtering stay stable for everyone else.
create or replace function app_api_v1.get_leaderboard(
  p_organization_id text,
  p_scope text default 'group',
  p_limit integer default 50
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_group text;
  v_inst text;
  v_year text;
begin
  if v_uid is null then raise exception 'Unauthorized'; end if;

  select a.academic_group into v_group
  from core.user_academic_profiles a where a.user_id = v_uid;
  v_inst := split_part(coalesce(v_group, ''), '-', 1);
  v_year := split_part(coalesce(v_group, ''), '-', 3);

  return coalesce(
    (select jsonb_agg(row_order)
     from (
       select jsonb_build_object(
           'userId',        p.user_id,
           'displayName',   case
             when p.user_id <> v_uid
               and coalesce(settings.profile_visibility, 'everyone') = 'nobody'
             then 'Ниндзя'
             else coalesce(au.raw_user_meta_data->>'full_name',
                            a.full_name, 'Студент')
           end,
           'xp',            p.xp,
           'level',         p.level,
           'streakDays',    p.streak_days,
           'isCurrentUser', p.user_id = v_uid
         ) as row_order
       from core.user_gamification_profiles p
       join auth.users au on au.id = p.user_id
       left join core.user_academic_profiles a on a.user_id = p.user_id
       left join user_private.user_settings settings
         on settings.user_id = p.user_id
       where p.organization_id = p_organization_id
         and case p_scope
           when 'group'   then v_group is not null and a.academic_group = v_group
           when 'course'  then v_inst <> ''
                               and split_part(coalesce(a.academic_group, ''), '-', 1) = v_inst
                               and split_part(coalesce(a.academic_group, ''), '-', 3) = v_year
           when 'faculty' then v_inst <> ''
                               and split_part(coalesce(a.academic_group, ''), '-', 1) = v_inst
           else true
         end
       order by p.xp desc
       limit least(greatest(coalesce(p_limit, 50), 1), 200)
     ) sub),
    '[]'::jsonb);
end;
$$;

-- (b) search_users: exclude 'nobody' entirely; 'group' visibility only
-- surfaces to fellow group members.
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
  v_group text;
  v_query text := btrim(coalesce(p_query, ''));
  v_result jsonb;
begin
  select profile.organization_id, profile.academic_group
  into v_organization_id, v_group
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
    left join user_private.user_settings settings
      on settings.user_id = profile.user_id
    where profile.organization_id = v_organization_id
      and profile.user_id <> v_user_id
      and (
        profile.full_name ilike '%' || v_query || '%'
        or profile.handle ilike '%' || v_query || '%'
        or profile.academic_group ilike '%' || v_query || '%'
      )
      and coalesce(settings.profile_visibility, 'everyone') <> 'nobody'
      and (
        coalesce(settings.profile_visibility, 'everyone') <> 'group'
        or (v_group is not null and profile.academic_group = v_group)
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

-- (c) get_group_members: roster is already scoped to the caller's own group,
-- so 'group' visibility is satisfied by construction — only 'nobody' hides.
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
  left join user_private.user_settings settings
    on settings.user_id = profile.user_id
  where v_group is not null
    and profile.organization_id = v_organization_id
    and profile.academic_group = v_group
    and (
      profile.user_id = v_user_id
      or coalesce(settings.profile_visibility, 'everyone') <> 'nobody'
    );
  return jsonb_build_object('group', v_group, 'members', v_members);
end;
$$;

-- (d) get_people_you_may_know: candidates here are never groupmates of the
-- caller (already excluded below), so both 'nobody' and 'group' visibility
-- hide a candidate from this feed.
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
    left join user_private.user_settings settings
      on settings.user_id = mutual.user_id
    where coalesce(profile.full_name, '') <> ''
      and (v_group is null or profile.academic_group is distinct from v_group)
      and coalesce(settings.profile_visibility, 'everyone') not in (
        'nobody', 'group'
      )
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
