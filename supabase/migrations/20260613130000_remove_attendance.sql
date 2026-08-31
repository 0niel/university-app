-- Remove the "Посещаемость" (attendance) feature entirely.
--   1) Lesson attendance marks: table + get/set RPCs (public + app_api_v1).
--   2) Profile attendance metric: drop user_semester_stats.attendance_rate and
--      stop returning it from get_profile_overview.
-- Exam readiness (added in the same original migration) is intentionally kept.
-- Applied remotely as: remove_attendance.

-- ── 1) lesson attendance ─────────────────────────────────────────────────────
drop function if exists public.get_lesson_attendance(text) cascade;
drop function if exists public.set_lesson_attendance(text, text, date, integer, text) cascade;
drop function if exists app_api_v1.get_lesson_attendance(text) cascade;
drop function if exists app_api_v1.set_lesson_attendance(text, text, date, integer, text) cascade;

drop table if exists core.lesson_attendance cascade;

-- ── 2) profile attendance metric ─────────────────────────────────────────────
-- Recreate the overview RPC without the attendanceRate field, then drop the col.
create or replace function app_api_v1.get_profile_overview(p_organization_id text)
returns jsonb language plpgsql security definer set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_group text;
  v_rank int;
  v_group_size int;
  v_today date := (now() at time zone 'UTC')::date;
begin
  if v_uid is null then raise exception 'Unauthorized'; end if;

  select academic_group into v_group
  from core.user_academic_profiles where user_id = v_uid;

  with peers as (
    select p.user_id, p.xp,
           rank() over (order by p.xp desc) as rnk
    from core.user_gamification_profiles p
    left join core.user_academic_profiles a on a.user_id = p.user_id
    where p.organization_id = p_organization_id
      and (v_group is null or a.academic_group = v_group)
  )
  select rnk, count(*) over () into v_rank, v_group_size
  from peers where user_id = v_uid;

  return jsonb_build_object(
    'academic', coalesce((
      select jsonb_build_object(
        'handle', a.handle, 'group', a.academic_group, 'course', a.course,
        'fullName', a.full_name, 'studentCardNumber', a.student_card_number,
        'cardValidUntil', a.card_valid_until)
      from core.user_academic_profiles a where a.user_id = v_uid), '{}'::jsonb),
    'semester', coalesce((
      select jsonb_build_object(
        'label', s.semester_label, 'moduleLabel', s.module_label,
        'gpa', s.gpa)
      from core.user_semester_stats s where s.user_id = v_uid), '{}'::jsonb),
    'groupRank', v_rank,
    'groupSize', v_group_size,
    'streakHistory', (
      select jsonb_agg(
        exists(select 1 from core.user_active_days d
               where d.user_id = v_uid and d.active_on = day)
        order by day)
      from generate_series(v_today - 13, v_today, interval '1 day') as g(day)),
    'badgeCounts', (
      select jsonb_build_object(
        'earned', count(*) filter (where coalesce(ub.is_earned, false)),
        'total', (select count(*) from core.badge_definitions))
      from core.badge_definitions bd
      left join core.user_badges ub on ub.badge_id = bd.id and ub.user_id = v_uid)
  );
end;
$$;

alter table core.user_semester_stats drop column if exists attendance_rate;
