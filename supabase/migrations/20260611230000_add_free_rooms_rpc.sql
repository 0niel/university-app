-- Real free-rooms computation from the schedule graph: a room is free if
-- no occurrence overlaps now; "freeUntil" is the next occurrence start
-- today (null = free until end of day). Applied remotely as:
-- add_free_rooms_rpc.

create or replace function app_api_v1.get_free_rooms(p_organization_id text)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  with org as (
    select coalesce(o.timezone, 'Europe/Moscow') as tz
    from core.organizations o
    where o.id = p_organization_id
  ),
  today as (
    select (now() at time zone (select tz from org))::date as d
  ),
  busy as (
    select
      pc.classroom_id,
      o.starts_at,
      o.ends_at
    from core.schedule_occurrences o
    join core.schedule_part_classrooms pc
      on pc.schedule_part_id = o.schedule_part_id
    where o.organization_id = p_organization_id
      and o.occurrence_date = (select d from today)
      and o.starts_at is not null
      and o.ends_at is not null
  ),
  rooms as (
    select
      c.id,
      c.name,
      cam.short_name as campus,
      exists (
        select 1 from busy b
        where b.classroom_id = c.id
          and b.starts_at <= now()
          and b.ends_at > now()
      ) as occupied_now,
      (
        select min(b.starts_at) from busy b
        where b.classroom_id = c.id and b.starts_at > now()
      ) as next_busy_at
    from core.schedule_classrooms c
    left join core.schedule_campuses cam on cam.id = c.campus_id
    where c.organization_id = p_organization_id
      and c.name !~* 'online|дистан|сдо'
  )
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'room', r.name,
        'campus', r.campus,
        'freeUntil', r.next_busy_at
      )
      order by r.name
    ),
    '[]'::jsonb
  )
  from rooms r
  where not r.occupied_now;
$$;

create or replace function public.get_free_rooms(p_organization_id text)
returns jsonb language sql stable security definer set search_path = ''
as $$ select app_api_v1.get_free_rooms(p_organization_id); $$;

revoke all on function public.get_free_rooms(text) from public, anon;
grant execute on function public.get_free_rooms(text) to authenticated;
