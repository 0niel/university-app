-- User activities: non-class calendar items (events, retakes, extra classes,
-- consultations, personal) owned by a single student. Mirrors the contract
-- style of the lesson_materials/reviews slice: core table + RLS + owner-scoped
-- app_api_v1 functions exposed through thin public wrappers.

create table core.user_activities (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  activity_type text not null,
  title text not null,
  place text,
  subtitle text,
  lesson_uid text,
  starts_at timestamptz not null,
  ends_at timestamptz,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint user_activities_title_not_empty
    check (length(trim(title)) > 0),
  constraint user_activities_type_valid
    check (activity_type in ('event', 'retake', 'extra', 'personal', 'consult')),
  constraint user_activities_interval_valid
    check (ends_at is null or ends_at >= starts_at),
  constraint user_activities_metadata_is_object
    check (jsonb_typeof(metadata) = 'object')
);

create index user_activities_user_range_idx
on core.user_activities (user_id, starts_at);

create index user_activities_org_idx
on core.user_activities (organization_id, starts_at);

create trigger set_user_activities_updated_at
before update on core.user_activities
for each row execute function core.set_updated_at();

alter table core.user_activities enable row level security;

create policy "users can read own activities"
on core.user_activities
for select
to authenticated
using ((select auth.uid()) = user_id);

create policy "users can insert own activities"
on core.user_activities
for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "users can update own activities"
on core.user_activities
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "users can delete own activities"
on core.user_activities
for delete
to authenticated
using ((select auth.uid()) = user_id);

grant select, insert, update, delete on core.user_activities to authenticated;
grant all on core.user_activities to service_role;

-- ── app_api_v1 implementation ────────────────────────────────────────────────

create or replace function app_api_v1.get_user_activities(
  p_organization_id text,
  p_from date,
  p_to date
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
        'id', ua.id,
        'activityType', ua.activity_type,
        'title', ua.title,
        'place', ua.place,
        'subtitle', ua.subtitle,
        'lessonUid', ua.lesson_uid,
        'startsAt', ua.starts_at,
        'endsAt', ua.ends_at
      )
      order by ua.starts_at
    ),
    '[]'::jsonb
  )
  from core.user_activities ua
  where ua.organization_id = p_organization_id
    and ua.user_id = (select auth.uid())
    and (ua.starts_at at time zone 'UTC')::date between p_from and p_to;
$$;

create or replace function app_api_v1.upsert_user_activity(
  p_organization_id text,
  p_id uuid,
  p_activity_type text,
  p_title text,
  p_place text,
  p_subtitle text,
  p_lesson_uid text,
  p_starts_at timestamptz,
  p_ends_at timestamptz
)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_row core.user_activities;
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;

  if p_id is null then
    insert into core.user_activities (
      organization_id,
      user_id,
      activity_type,
      title,
      place,
      subtitle,
      lesson_uid,
      starts_at,
      ends_at
    )
    values (
      p_organization_id,
      v_user_id,
      p_activity_type,
      p_title,
      nullif(trim(coalesce(p_place, '')), ''),
      nullif(trim(coalesce(p_subtitle, '')), ''),
      nullif(trim(coalesce(p_lesson_uid, '')), ''),
      p_starts_at,
      p_ends_at
    )
    returning * into v_row;
  else
    update core.user_activities
    set
      activity_type = p_activity_type,
      title = p_title,
      place = nullif(trim(coalesce(p_place, '')), ''),
      subtitle = nullif(trim(coalesce(p_subtitle, '')), ''),
      lesson_uid = nullif(trim(coalesce(p_lesson_uid, '')), ''),
      starts_at = p_starts_at,
      ends_at = p_ends_at
    where id = p_id and user_id = v_user_id
    returning * into v_row;

    if v_row.id is null then
      raise exception 'Activity not found';
    end if;
  end if;

  return jsonb_build_array(
    jsonb_build_object(
      'id', v_row.id,
      'activityType', v_row.activity_type,
      'title', v_row.title,
      'place', v_row.place,
      'subtitle', v_row.subtitle,
      'lessonUid', v_row.lesson_uid,
      'startsAt', v_row.starts_at,
      'endsAt', v_row.ends_at
    )
  );
end;
$$;

create or replace function app_api_v1.delete_user_activity(p_id uuid)
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

  delete from core.user_activities
  where id = p_id and user_id = v_user_id;
end;
$$;

-- ── public wrappers ──────────────────────────────────────────────────────────

create or replace function public.get_user_activities(
  p_organization_id text,
  p_from date,
  p_to date
)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select app_api_v1.get_user_activities(p_organization_id, p_from, p_to);
$$;

create or replace function public.upsert_user_activity(
  p_organization_id text,
  p_id uuid,
  p_activity_type text,
  p_title text,
  p_place text,
  p_subtitle text,
  p_lesson_uid text,
  p_starts_at timestamptz,
  p_ends_at timestamptz
)
returns jsonb
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.upsert_user_activity(
    p_organization_id,
    p_id,
    p_activity_type,
    p_title,
    p_place,
    p_subtitle,
    p_lesson_uid,
    p_starts_at,
    p_ends_at
  );
$$;

create or replace function public.delete_user_activity(p_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.delete_user_activity(p_id);
$$;

revoke all on function public.get_user_activities(text, date, date) from public;
grant execute on function public.get_user_activities(text, date, date)
to authenticated;

revoke all on function public.upsert_user_activity(
  text, uuid, text, text, text, text, text, timestamptz, timestamptz
) from public;
grant execute on function public.upsert_user_activity(
  text, uuid, text, text, text, text, text, timestamptz, timestamptz
) to authenticated;

revoke all on function public.delete_user_activity(uuid) from public;
grant execute on function public.delete_user_activity(uuid) to authenticated;
