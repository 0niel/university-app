-- Schedule change log: a per-target feed of schedule changes (перенос, отмена,
-- добавление, замена преподавателя, смена аудитории) powering the "Изменения"
-- screen. Changes are detected by diffing a stored digest of future lesson
-- occurrences against the current schedule state. The refresh runs on a
-- pg_cron timer (and can be invoked by the ingest pipeline via the
-- service-role wrapper) so the detection survives the ingest's full-replace
-- strategy without producing delete/insert noise.

-- ── tables ───────────────────────────────────────────────────────────────────

create table core.schedule_change_log (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id) on delete cascade,
  target_id uuid not null references core.schedule_targets(id) on delete cascade,
  change_kind text not null,
  subject text not null,
  lesson_date date not null,
  lesson_number integer,
  old_value jsonb not null default '{}'::jsonb,
  new_value jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  constraint schedule_change_log_kind_valid
    check (change_kind in ('add', 'cancel', 'move', 'room', 'teacher')),
  constraint schedule_change_log_subject_not_empty
    check (length(trim(subject)) > 0)
);

create index schedule_change_log_target_created_idx
on core.schedule_change_log (target_id, created_at desc);

create index schedule_change_log_org_created_idx
on core.schedule_change_log (organization_id, created_at desc);

alter table core.schedule_change_log enable row level security;

-- Schedule data is public, so its change feed is public too.
create policy "schedule changes are readable by everyone"
on core.schedule_change_log
for select
to anon, authenticated
using (true);

grant select on core.schedule_change_log to anon, authenticated;
grant all on core.schedule_change_log to service_role;

-- Last-seen digest of every target's future occurrences. Internal bookkeeping:
-- no client access, the refresh function (security definer) owns the writes.
create table core.schedule_target_digests (
  target_id uuid primary key references core.schedule_targets(id) on delete cascade,
  organization_id text not null references core.organizations(id) on delete cascade,
  digest jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table core.schedule_target_digests enable row level security;
grant all on core.schedule_target_digests to service_role;

-- ── refresh ──────────────────────────────────────────────────────────────────

create or replace function core.refresh_schedule_change_log()
returns integer
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_target record;
  v_old jsonb;
  v_new jsonb;
  v_total_logged integer := 0;
  v_pending integer;
  v_key text;
  v_old_val jsonb;
  v_new_val jsonb;
  v_kind text;
begin
  for v_target in
    select t.id, t.organization_id
    from core.schedule_targets t
    where t.is_active
  loop
    -- Current digest of future lessons keyed by subject + date + start slot.
    -- Subgroup duplicates (same subject and slot) merge their rooms/teachers.
    with occ as (
      select
        coalesce(p.subject, p.title, '') as subject,
        d.lesson_date,
        p.lesson_number,
        p.start_time,
        p.end_time,
        coalesce((
          select array_agg(c ->> 'name' order by c ->> 'name')
          from jsonb_array_elements(p.classrooms) c
          where coalesce(trim(c ->> 'name'), '') <> ''
        ), '{}'::text[]) as rooms,
        coalesce((
          select array_agg(t2 ->> 'name' order by t2 ->> 'name')
          from jsonb_array_elements(p.teachers) t2
          where coalesce(trim(t2 ->> 'name'), '') <> ''
        ), '{}'::text[]) as teachers
      from core.schedule_parts p
      join core.schedule_part_dates d on d.schedule_part_id = p.id
      where p.target_id = v_target.id
        and p.part_type = 'lesson'
        and d.lesson_date >= current_date
        and coalesce(p.subject, p.title, '') <> ''
    ),
    grouped as (
      select
        occ.subject,
        occ.lesson_date,
        occ.start_time,
        max(occ.lesson_number) as lesson_number,
        max(occ.end_time) as end_time,
        coalesce(
          array_agg(distinct room order by room) filter (where room is not null),
          '{}'::text[]
        ) as rooms,
        coalesce(
          array_agg(distinct teacher order by teacher) filter (where teacher is not null),
          '{}'::text[]
        ) as teachers
      from occ
      left join lateral unnest(occ.rooms) as room on true
      left join lateral unnest(occ.teachers) as teacher on true
      group by occ.subject, occ.lesson_date, occ.start_time
    )
    select coalesce(
      jsonb_object_agg(
        md5(
          grouped.subject || '|' || grouped.lesson_date::text || '|'
          || coalesce(grouped.start_time::text, grouped.lesson_number::text, '')
        ),
        jsonb_build_object(
          'subject', grouped.subject,
          'date', grouped.lesson_date,
          'number', grouped.lesson_number,
          'start', grouped.start_time::text,
          'end', grouped.end_time::text,
          'rooms', to_jsonb(grouped.rooms),
          'teachers', to_jsonb(grouped.teachers)
        )
      ),
      '{}'::jsonb
    )
    into v_new
    from grouped;

    select d.digest into v_old
    from core.schedule_target_digests d
    where d.target_id = v_target.id;

    -- First sighting: store the baseline silently.
    if v_old is null then
      insert into core.schedule_target_digests (target_id, organization_id, digest)
      values (v_target.id, v_target.organization_id, v_new);
      continue;
    end if;

    -- Anti-noise guards: an emptied schedule (ingest hiccup or semester end)
    -- and bulk rewrites (> 50 changed slots) are not user-facing "changes".
    if v_new = '{}'::jsonb and v_old <> '{}'::jsonb then
      update core.schedule_target_digests
      set digest = v_new, updated_at = now()
      where target_id = v_target.id;
      continue;
    end if;

    select
      count(*) filter (
        where o.value is not null and n.value is null
      )
      + count(*) filter (
        where o.value is null and n.value is not null
      )
      + count(*) filter (
        where o.value is not null and n.value is not null
          and o.value is distinct from n.value
      )
    into v_pending
    from jsonb_each(v_old) o
    full outer join jsonb_each(v_new) n on n.key = o.key
    where coalesce((o.value ->> 'date')::date, (n.value ->> 'date')::date)
      >= current_date;

    if v_pending = 0 or v_pending > 50 then
      update core.schedule_target_digests
      set digest = v_new, updated_at = now()
      where target_id = v_target.id;
      continue;
    end if;

    -- Cancelled lessons.
    for v_key, v_old_val in
      select o.key, o.value
      from jsonb_each(v_old) o
      where (o.value ->> 'date')::date >= current_date
        and not (v_new ? o.key)
    loop
      insert into core.schedule_change_log (
        organization_id, target_id, change_kind, subject,
        lesson_date, lesson_number, old_value, new_value
      )
      values (
        v_target.organization_id, v_target.id, 'cancel',
        v_old_val ->> 'subject',
        (v_old_val ->> 'date')::date,
        (v_old_val ->> 'number')::integer,
        v_old_val, '{}'::jsonb
      );
      v_total_logged := v_total_logged + 1;
    end loop;

    -- Added lessons.
    for v_key, v_new_val in
      select n.key, n.value
      from jsonb_each(v_new) n
      where (n.value ->> 'date')::date >= current_date
        and not (v_old ? n.key)
    loop
      insert into core.schedule_change_log (
        organization_id, target_id, change_kind, subject,
        lesson_date, lesson_number, old_value, new_value
      )
      values (
        v_target.organization_id, v_target.id, 'add',
        v_new_val ->> 'subject',
        (v_new_val ->> 'date')::date,
        (v_new_val ->> 'number')::integer,
        '{}'::jsonb, v_new_val
      );
      v_total_logged := v_total_logged + 1;
    end loop;

    -- Modified lessons: classify by what changed (time > room > teacher).
    for v_key, v_old_val, v_new_val in
      select o.key, o.value, n.value
      from jsonb_each(v_old) o
      join jsonb_each(v_new) n on n.key = o.key
      where o.value is distinct from n.value
        and (o.value ->> 'date')::date >= current_date
    loop
      v_kind := case
        when (v_old_val ->> 'start') is distinct from (v_new_val ->> 'start')
          or (v_old_val ->> 'end') is distinct from (v_new_val ->> 'end')
          then 'move'
        when (v_old_val -> 'rooms') is distinct from (v_new_val -> 'rooms')
          then 'room'
        when (v_old_val -> 'teachers') is distinct from (v_new_val -> 'teachers')
          then 'teacher'
        else null
      end;

      if v_kind is not null then
        insert into core.schedule_change_log (
          organization_id, target_id, change_kind, subject,
          lesson_date, lesson_number, old_value, new_value
        )
        values (
          v_target.organization_id, v_target.id, v_kind,
          v_new_val ->> 'subject',
          (v_new_val ->> 'date')::date,
          (v_new_val ->> 'number')::integer,
          v_old_val, v_new_val
        );
        v_total_logged := v_total_logged + 1;
      end if;
    end loop;

    update core.schedule_target_digests
    set digest = v_new, updated_at = now()
    where target_id = v_target.id;
  end loop;

  -- The feed is a recent-history view, not an archive.
  delete from core.schedule_change_log
  where created_at < now() - interval '90 days';

  return v_total_logged;
end;
$$;

revoke all on function core.refresh_schedule_change_log() from public;
grant execute on function core.refresh_schedule_change_log() to service_role;

-- ── app_api_v1 ───────────────────────────────────────────────────────────────

create or replace function app_api_v1.get_schedule_changes(
  p_organization_id text,
  p_target_type text,
  p_target text,
  p_limit integer default 60
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
        'id', l.id,
        'changeKind', l.change_kind,
        'subject', l.subject,
        'lessonDate', l.lesson_date,
        'lessonNumber', l.lesson_number,
        'oldValue', l.old_value,
        'newValue', l.new_value,
        'createdAt', l.created_at
      )
      order by l.created_at desc
    ),
    '[]'::jsonb
  )
  from (
    select *
    from core.schedule_change_log scl
    where scl.organization_id = p_organization_id
      and scl.target_id in (
        select t.id
        from core.schedule_targets t
        where t.organization_id = p_organization_id
          and t.target_type = p_target_type
          and (
            t.external_id = trim(p_target)
            or t.id::text = trim(p_target)
            or lower(t.target_title) = lower(trim(p_target))
            or lower(t.full_title) = lower(trim(p_target))
          )
      )
    order by scl.created_at desc
    limit least(greatest(coalesce(p_limit, 60), 1), 200)
  ) l;
$$;

grant execute on function app_api_v1.get_schedule_changes(text, text, text, integer)
to anon, authenticated, service_role;

-- ── public wrappers ──────────────────────────────────────────────────────────

create or replace function public.get_schedule_changes(
  p_organization_id text,
  p_target_type text,
  p_target text,
  p_limit integer default 60
)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select app_api_v1.get_schedule_changes(
    p_organization_id, p_target_type, p_target, p_limit
  );
$$;

revoke all on function public.get_schedule_changes(text, text, text, integer)
from public;
grant execute on function public.get_schedule_changes(text, text, text, integer)
to anon, authenticated;

create or replace function public.refresh_schedule_change_log()
returns integer
language sql
security invoker
set search_path = ''
as $$
  select core.refresh_schedule_change_log();
$$;

revoke all on function public.refresh_schedule_change_log() from public;
grant execute on function public.refresh_schedule_change_log() to service_role;

-- ── pg_cron timer ────────────────────────────────────────────────────────────

do $$
begin
  create extension if not exists pg_cron;
exception when others then
  raise notice 'pg_cron extension unavailable: %', sqlerrm;
end;
$$;

do $$
begin
  perform cron.schedule(
    'schedule-change-log-refresh',
    '*/30 * * * *',
    'select core.refresh_schedule_change_log()'
  );
exception when others then
  raise notice 'pg_cron scheduling skipped: %', sqlerrm;
end;
$$;
