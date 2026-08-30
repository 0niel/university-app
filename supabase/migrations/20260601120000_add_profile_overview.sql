-- Profile overview slice: academic identity, semester stats, streak history.
--
-- Backs the rich Profile screen blocks that gamification alone did not cover:
-- the @handle · group · course header, the virtual student-ID card, the
-- semester rings (GPA / attendance / rank-in-group) and the 14-day streak
-- fire-calendar. All owner-only under RLS; reads are surfaced through a single
-- app_api_v1.get_profile_overview RPC (+ public wrapper) to keep the screen to
-- one round-trip. group rank is computed live from gamification XP.

-- ── Academic identity ────────────────────────────────────────────────────────
create table core.user_academic_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  organization_id text not null references core.organizations(id) on delete cascade,
  handle text,
  academic_group text,
  course int,
  full_name text,
  student_card_number text,
  card_valid_until date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint course_positive check (course is null or course between 1 and 8)
);
create index user_academic_profiles_org_group_idx
  on core.user_academic_profiles (organization_id, academic_group);
create trigger set_user_academic_profiles_updated_at before update on core.user_academic_profiles
  for each row execute function core.set_updated_at();
alter table core.user_academic_profiles enable row level security;
create policy "users read own academic profile" on core.user_academic_profiles for select
  to authenticated using ((select auth.uid()) = user_id);
create policy "users insert own academic profile" on core.user_academic_profiles for insert
  to authenticated with check ((select auth.uid()) = user_id);
create policy "users update own academic profile" on core.user_academic_profiles for update
  to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
grant select, insert, update on core.user_academic_profiles to authenticated;
grant all on core.user_academic_profiles to service_role;

-- ── Semester stats (one current row per user) ────────────────────────────────
create table core.user_semester_stats (
  user_id uuid primary key references auth.users(id) on delete cascade,
  semester_label text,
  module_label text,
  gpa numeric(3,2),
  attendance_rate numeric(4,3),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint gpa_range check (gpa is null or gpa between 0 and 5),
  constraint attendance_range check (attendance_rate is null or attendance_rate between 0 and 1)
);
create trigger set_user_semester_stats_updated_at before update on core.user_semester_stats
  for each row execute function core.set_updated_at();
alter table core.user_semester_stats enable row level security;
create policy "users read own semester stats" on core.user_semester_stats for select
  to authenticated using ((select auth.uid()) = user_id);
create policy "users insert own semester stats" on core.user_semester_stats for insert
  to authenticated with check ((select auth.uid()) = user_id);
create policy "users update own semester stats" on core.user_semester_stats for update
  to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
grant select, insert, update on core.user_semester_stats to authenticated;
grant all on core.user_semester_stats to service_role;

-- ── Active-day log (streak fire-calendar) ────────────────────────────────────
create table core.user_active_days (
  user_id uuid not null references auth.users(id) on delete cascade,
  active_on date not null,
  primary key (user_id, active_on)
);
alter table core.user_active_days enable row level security;
create policy "users read own active days" on core.user_active_days for select
  to authenticated using ((select auth.uid()) = user_id);
create policy "users insert own active days" on core.user_active_days for insert
  to authenticated with check ((select auth.uid()) = user_id);
grant select, insert on core.user_active_days to authenticated;
grant all on core.user_active_days to service_role;

-- ── Read RPC: single-round-trip profile overview ─────────────────────────────
-- group_rank: 1-based position of the current user among same-academic_group
-- peers ordered by XP desc; falls back to organization-wide ranking when the
-- user has no academic_group set. Uses SECURITY DEFINER (same rationale as
-- get_leaderboard: needs to count peers' profiles the caller can't read).
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
        'gpa', s.gpa, 'attendanceRate', s.attendance_rate)
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

-- ── Write RPCs ───────────────────────────────────────────────────────────────
create or replace function app_api_v1.upsert_user_academic_profile(
  p_organization_id text, p_handle text default null, p_group text default null,
  p_course int default null, p_full_name text default null,
  p_student_card_number text default null, p_card_valid_until date default null)
returns jsonb language plpgsql security invoker set search_path = ''
as $$
declare v_uid uuid := (select auth.uid());
begin
  if v_uid is null then raise exception 'Unauthorized'; end if;
  insert into core.user_academic_profiles
    (user_id, organization_id, handle, academic_group, course, full_name,
     student_card_number, card_valid_until)
  values (v_uid, p_organization_id, p_handle, p_group, p_course, p_full_name,
     p_student_card_number, p_card_valid_until)
  on conflict (user_id) do update set
    handle = coalesce(excluded.handle, core.user_academic_profiles.handle),
    academic_group = coalesce(excluded.academic_group, core.user_academic_profiles.academic_group),
    course = coalesce(excluded.course, core.user_academic_profiles.course),
    full_name = coalesce(excluded.full_name, core.user_academic_profiles.full_name),
    student_card_number = coalesce(excluded.student_card_number, core.user_academic_profiles.student_card_number),
    card_valid_until = coalesce(excluded.card_valid_until, core.user_academic_profiles.card_valid_until);
  return app_api_v1.get_profile_overview(p_organization_id);
end;
$$;

create or replace function app_api_v1.record_active_day()
returns void language sql security invoker set search_path = ''
as $$
  insert into core.user_active_days (user_id, active_on)
  values ((select auth.uid()), (now() at time zone 'UTC')::date)
  on conflict do nothing;
$$;

-- ── public wrappers + grants ─────────────────────────────────────────────────
create or replace function public.get_profile_overview(p_organization_id text)
returns jsonb language sql security invoker set search_path = ''
as $$ select app_api_v1.get_profile_overview(p_organization_id); $$;

create or replace function public.upsert_user_academic_profile(
  p_organization_id text, p_handle text default null, p_group text default null,
  p_course int default null, p_full_name text default null,
  p_student_card_number text default null, p_card_valid_until date default null)
returns jsonb language sql security invoker set search_path = ''
as $$ select app_api_v1.upsert_user_academic_profile(p_organization_id, p_handle, p_group,
  p_course, p_full_name, p_student_card_number, p_card_valid_until); $$;

create or replace function public.record_active_day()
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.record_active_day(); $$;

revoke all on function public.get_profile_overview(text) from public;
grant execute on function public.get_profile_overview(text) to authenticated;
revoke all on function public.upsert_user_academic_profile(text,text,text,int,text,text,date) from public;
grant execute on function public.upsert_user_academic_profile(text,text,text,int,text,text,date) to authenticated;
revoke all on function public.record_active_day() from public;
grant execute on function public.record_active_day() to authenticated;
