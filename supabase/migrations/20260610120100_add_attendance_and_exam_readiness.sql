-- Attendance marks + exam readiness: per-user schedule companions powering the
-- "Посещаемость" and "Сессия" screens. Attendance stores explicit marks only
-- (a lesson without a mark counts as attended), readiness is a 0–100 per
-- subject self-assessment shown as progress toward each exam. Mirrors the
-- user_activities slice conventions: core table + owner RLS + app_api_v1
-- functions behind thin public wrappers.

-- ── lesson attendance ────────────────────────────────────────────────────────

create table core.lesson_attendance (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  subject_name text not null,
  lesson_date date not null,
  lesson_bells_number integer not null,
  status text not null default 'missed',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint lesson_attendance_subject_not_empty
    check (length(trim(subject_name)) > 0),
  constraint lesson_attendance_status_valid
    check (status in ('missed', 'attended')),
  constraint lesson_attendance_unique_occurrence unique (
    user_id, subject_name, lesson_date, lesson_bells_number
  )
);

create index lesson_attendance_user_idx
on core.lesson_attendance (user_id, lesson_date);

create index lesson_attendance_org_idx
on core.lesson_attendance (organization_id);

create trigger set_lesson_attendance_updated_at
before update on core.lesson_attendance
for each row execute function core.set_updated_at();

alter table core.lesson_attendance enable row level security;

create policy "users can read own attendance"
on core.lesson_attendance
for select
to authenticated
using ((select auth.uid()) = user_id);

create policy "users can insert own attendance"
on core.lesson_attendance
for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "users can update own attendance"
on core.lesson_attendance
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "users can delete own attendance"
on core.lesson_attendance
for delete
to authenticated
using ((select auth.uid()) = user_id);

grant select, insert, update, delete on core.lesson_attendance to authenticated;
grant all on core.lesson_attendance to service_role;

-- ── exam readiness ───────────────────────────────────────────────────────────

create table core.exam_readiness (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  subject_name text not null,
  readiness smallint not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint exam_readiness_subject_not_empty
    check (length(trim(subject_name)) > 0),
  constraint exam_readiness_range_valid
    check (readiness between 0 and 100),
  constraint exam_readiness_unique_subject unique (
    user_id, organization_id, subject_name
  )
);

create index exam_readiness_org_idx
on core.exam_readiness (organization_id);

create trigger set_exam_readiness_updated_at
before update on core.exam_readiness
for each row execute function core.set_updated_at();

alter table core.exam_readiness enable row level security;

create policy "users can read own readiness"
on core.exam_readiness
for select
to authenticated
using ((select auth.uid()) = user_id);

create policy "users can insert own readiness"
on core.exam_readiness
for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "users can update own readiness"
on core.exam_readiness
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "users can delete own readiness"
on core.exam_readiness
for delete
to authenticated
using ((select auth.uid()) = user_id);

grant select, insert, update, delete on core.exam_readiness to authenticated;
grant all on core.exam_readiness to service_role;

-- ── app_api_v1 implementation ────────────────────────────────────────────────

create or replace function app_api_v1.get_lesson_attendance(
  p_organization_id text
)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'subjectName', la.subject_name,
        'lessonDate', la.lesson_date,
        'lessonBellsNumber', la.lesson_bells_number,
        'status', la.status
      )
      order by la.lesson_date
    ),
    '[]'::jsonb
  )
  from core.lesson_attendance la
  where la.organization_id = p_organization_id
    and la.user_id = (select auth.uid());
$$;

create or replace function app_api_v1.set_lesson_attendance(
  p_organization_id text,
  p_subject_name text,
  p_lesson_date date,
  p_lesson_bells_number integer,
  p_status text
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

  -- A null status clears the explicit mark (back to "attended by default").
  if p_status is null then
    delete from core.lesson_attendance
    where user_id = v_user_id
      and organization_id = p_organization_id
      and subject_name = p_subject_name
      and lesson_date = p_lesson_date
      and lesson_bells_number = p_lesson_bells_number;
    return;
  end if;

  insert into core.lesson_attendance (
    organization_id, user_id, subject_name,
    lesson_date, lesson_bells_number, status
  )
  values (
    p_organization_id, v_user_id, p_subject_name,
    p_lesson_date, p_lesson_bells_number, p_status
  )
  on conflict (user_id, subject_name, lesson_date, lesson_bells_number)
  do update set status = excluded.status;
end;
$$;

create or replace function app_api_v1.get_exam_readiness(
  p_organization_id text
)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'subjectName', er.subject_name,
        'readiness', er.readiness
      )
      order by er.subject_name
    ),
    '[]'::jsonb
  )
  from core.exam_readiness er
  where er.organization_id = p_organization_id
    and er.user_id = (select auth.uid());
$$;

create or replace function app_api_v1.set_exam_readiness(
  p_organization_id text,
  p_subject_name text,
  p_readiness integer
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

  insert into core.exam_readiness (
    organization_id, user_id, subject_name, readiness
  )
  values (
    p_organization_id, v_user_id, p_subject_name,
    least(greatest(coalesce(p_readiness, 0), 0), 100)
  )
  on conflict (user_id, organization_id, subject_name)
  do update set readiness = excluded.readiness;
end;
$$;

-- ── public wrappers ──────────────────────────────────────────────────────────

create or replace function public.get_lesson_attendance(p_organization_id text)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select app_api_v1.get_lesson_attendance(p_organization_id);
$$;

create or replace function public.set_lesson_attendance(
  p_organization_id text,
  p_subject_name text,
  p_lesson_date date,
  p_lesson_bells_number integer,
  p_status text
)
returns void
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.set_lesson_attendance(
    p_organization_id, p_subject_name, p_lesson_date,
    p_lesson_bells_number, p_status
  );
$$;

create or replace function public.get_exam_readiness(p_organization_id text)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select app_api_v1.get_exam_readiness(p_organization_id);
$$;

create or replace function public.set_exam_readiness(
  p_organization_id text,
  p_subject_name text,
  p_readiness integer
)
returns void
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.set_exam_readiness(
    p_organization_id, p_subject_name, p_readiness
  );
$$;

revoke all on function public.get_lesson_attendance(text) from public;
grant execute on function public.get_lesson_attendance(text) to authenticated;

revoke all on function public.set_lesson_attendance(text, text, date, integer, text)
from public;
grant execute on function public.set_lesson_attendance(text, text, date, integer, text)
to authenticated;

revoke all on function public.get_exam_readiness(text) from public;
grant execute on function public.get_exam_readiness(text) to authenticated;

revoke all on function public.set_exam_readiness(text, text, integer) from public;
grant execute on function public.set_exam_readiness(text, text, integer)
to authenticated;
