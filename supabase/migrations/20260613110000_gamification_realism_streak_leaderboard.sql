-- Makes the gamified Profile / Ninja-Path screens show REAL data instead of
-- placeholders:
--   * leaderboard scopes (group / course / faculty / all) actually filter,
--     derived from the academic group code (e.g. ИКБО-09-22 → institute ИКБО,
--     stream year 22);
--   * the headline streak counter is recomputed from real active-days, and a
--     longest-streak record is tracked + exposed (for "Рекорд N дней").
-- Applied remotely as: gamification_realism_streak_leaderboard.

-- ── Longest-streak record ────────────────────────────────────────────────────
alter table core.user_gamification_profiles
  add column if not exists longest_streak integer not null default 0;

-- Expose longestStreak alongside the existing fields. ensure_gamification_profile
-- delegates here, so both entry points pick it up.
create or replace function app_api_v1.get_gamification_profile()
returns jsonb
language sql
stable
set search_path = ''
as $$
  select coalesce(
    (select jsonb_build_object(
        'userId', p.user_id, 'xp', p.xp, 'level', p.level,
        'shurikens', p.shurikens, 'streakDays', p.streak_days,
        'longestStreak', p.longest_streak, 'lastActiveDate', p.last_active_date,
        'recentBadge', (
          select jsonb_build_object('id', bd.id, 'name', bd.name,
                                    'emoji', bd.emoji, 'rarity', bd.rarity)
          from core.user_badges ub
          join core.badge_definitions bd on bd.id = ub.badge_id
          where ub.user_id = (select auth.uid()) and ub.is_earned = true
          order by ub.earned_at desc limit 1))
      from core.user_gamification_profiles p
      where p.user_id = (select auth.uid())),
    '{}'::jsonb);
$$;

-- Recompute the streak from real active days: count consecutive days ending
-- today (or yesterday if today isn't logged yet), and roll the record forward.
create or replace function app_api_v1.record_active_day()
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_today date := (now() at time zone 'UTC')::date;
  v_day date;
  v_streak integer := 0;
begin
  if v_uid is null then raise exception 'Unauthorized'; end if;

  insert into core.user_active_days (user_id, active_on)
  values (v_uid, v_today)
  on conflict do nothing;

  v_day := v_today;
  if not exists (
    select 1 from core.user_active_days
    where user_id = v_uid and active_on = v_day
  ) then
    v_day := v_today - 1;
  end if;

  while exists (
    select 1 from core.user_active_days
    where user_id = v_uid and active_on = v_day
  ) loop
    v_streak := v_streak + 1;
    v_day := v_day - 1;
  end loop;

  update core.user_gamification_profiles
  set streak_days = v_streak,
      longest_streak = greatest(longest_streak, v_streak),
      last_active_date = v_today,
      updated_at = now()
  where user_id = v_uid;
end;
$$;

-- ── Real leaderboard scopes ──────────────────────────────────────────────────
-- group   → exact academic group; course → same institute + admission year
-- (stream/«Поток»); faculty → same institute («Институт»); all → org-wide.
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
           'displayName',   coalesce(au.raw_user_meta_data->>'full_name',
                                     a.full_name, 'Студент'),
           'xp',            p.xp,
           'level',         p.level,
           'streakDays',    p.streak_days,
           'isCurrentUser', p.user_id = v_uid
         ) as row_order
       from core.user_gamification_profiles p
       join auth.users au on au.id = p.user_id
       left join core.user_academic_profiles a on a.user_id = p.user_id
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
