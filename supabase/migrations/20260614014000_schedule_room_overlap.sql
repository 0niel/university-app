-- Room availability & conflict detection over canonical occurrences using GiST
-- range overlap on schedule_item_occurrence.span. The table is term-partitioned,
-- so a per-partition GiST(span) index is naturally term-scoped (partition pruning
-- handles term). btree_gist is enabled for future composite (scalar+range) indexes.
create extension if not exists btree_gist with schema extensions;

create index if not exists schedule_item_occ_span_gist
  on core.schedule_item_occurrence using gist (span);

-- Free rooms in an ARBITRARY [from, to] window (generalizes the "free now"
-- get_free_rooms). A room is free when no occurrence of any item taught in it
-- overlaps the window.
create or replace function app_api_v1.get_free_rooms_window(
  p_organization_id text, p_from timestamptz, p_to timestamptz
) returns jsonb language sql stable security invoker set search_path = '' as $$
  select coalesce(
    jsonb_agg(jsonb_build_object('room', name, 'campus', campus) order by name),
    '[]'::jsonb
  )
  from (
    select c.name, cam.short_name as campus
    from core.schedule_classrooms c
    left join core.schedule_campuses cam on cam.id = c.campus_id
    where c.organization_id = p_organization_id
      and c.name !~* 'online|дистан|сдо'
      and not exists (
        select 1
        from core.schedule_item_classroom ic
        join core.schedule_item_occurrence o on o.item_id = ic.item_id
        where ic.classroom_id = c.id
          and o.span && tstzrange(p_from, p_to)
      )
  ) z;
$$;

-- Double-booking report for a date: same room, two different lessons whose time
-- spans overlap. Read-only diagnostic — the source data is messy, so we surface
-- clashes rather than forbidding them with an EXCLUDE constraint.
create or replace function app_api_v1.get_room_conflicts(
  p_organization_id text, p_date date
) returns jsonb language sql stable security invoker set search_path = '' as $$
  select coalesce(
    jsonb_agg(jsonb_build_object(
      'room', c.name, 'campus', cam.short_name, 'date', a.lesson_date,
      'lessonA', sia.title, 'startA', lower(a.span), 'endA', upper(a.span),
      'lessonB', sib.title, 'startB', lower(b.span), 'endB', upper(b.span)
    ) order by c.name, a.span),
    '[]'::jsonb
  )
  from core.schedule_item_occurrence a
  join core.schedule_item_occurrence b
    on b.lesson_date = a.lesson_date and a.item_id < b.item_id and a.span && b.span
  join core.schedule_item_classroom ica on ica.item_id = a.item_id
  join core.schedule_item_classroom icb on icb.item_id = b.item_id and icb.classroom_id = ica.classroom_id
  join core.schedule_classrooms c on c.id = ica.classroom_id and c.organization_id = p_organization_id
  left join core.schedule_campuses cam on cam.id = c.campus_id
  join core.schedule_item sia on sia.id = a.item_id
  join core.schedule_item sib on sib.id = b.item_id
  where a.lesson_date = p_date and a.span is not null;
$$;

create or replace function public.get_free_rooms_window(
  p_organization_id text, p_from timestamptz, p_to timestamptz
) returns jsonb language sql stable security invoker set search_path = '' as $$
  select app_api_v1.get_free_rooms_window(p_organization_id, p_from, p_to);
$$;

create or replace function public.get_room_conflicts(
  p_organization_id text, p_date date
) returns jsonb language sql stable security invoker set search_path = '' as $$
  select app_api_v1.get_room_conflicts(p_organization_id, p_date);
$$;

do $$
declare f text;
begin
  foreach f in array array[
    'app_api_v1.get_free_rooms_window(text,timestamptz,timestamptz)',
    'app_api_v1.get_room_conflicts(text,date)',
    'public.get_free_rooms_window(text,timestamptz,timestamptz)',
    'public.get_room_conflicts(text,date)'
  ] loop
    execute format('grant execute on function %s to anon, authenticated, service_role', f);
  end loop;
end $$;
