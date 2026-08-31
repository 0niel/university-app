-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║ Canonical read path: rebuild get_schedule_for_target / get_schedule_for_  ║
-- ║ entity over core.schedule_item + membership edges. Wire shape is rebuilt  ║
-- ║ from entity metadata (byte-compatible with the existing Flutter contract) ║
-- ║ and now ALWAYS carries the full group list (fixes combined-lecture/поток  ║
-- ║ display). Kind-aware: emits __lesson_schedule__ / __holiday__ /           ║
-- ║ __calendar_event__.                                                       ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- sargable entity lookups used by the resolver below
create index if not exists schedule_groups_org_lname_idx       on core.schedule_groups     (organization_id, lower(name));
create index if not exists schedule_groups_org_extid_idx       on core.schedule_groups     (organization_id, external_id);
create index if not exists schedule_teachers_org_lname_idx     on core.schedule_teachers   (organization_id, lower(full_name));
create index if not exists schedule_teachers_org_extid_idx     on core.schedule_teachers   (organization_id, external_id);
create index if not exists schedule_classrooms_org_lname_idx   on core.schedule_classrooms (organization_id, lower(name));
create index if not exists schedule_classrooms_org_extid_idx   on core.schedule_classrooms (organization_id, external_id);

-- drop the legacy implementations (they carry param defaults CREATE OR REPLACE can't change);
-- public wrappers first (they depend on the app_api_v1 bodies).
drop function if exists public.get_schedule_for_entity(text, text, date, date, text);
drop function if exists public.get_schedule_for_target(text, text, text);
drop function if exists app_api_v1.get_schedule_for_entity(text, text, date, date, text);
drop function if exists app_api_v1.get_schedule_for_target(text, text, text);

-- ── resolve an entity (group/teacher/classroom/campus) to its item ids ────────
create or replace function app_api_v1.schedule_resolve_item_ids(
  p_type text, p_entity text, p_org text
) returns uuid[] language sql stable set search_path = '' as $$
  select array(
    select e.item_id from core.schedule_item_group e
      where p_type = 'group' and e.group_id in (
        select id from core.schedule_groups
        where organization_id = p_org and (
          external_id = trim(p_entity) or id::text = trim(p_entity)
          or lower(name) = lower(trim(p_entity))))
    union
    select e.item_id from core.schedule_item_teacher e
      where p_type = 'teacher' and e.teacher_id in (
        select id from core.schedule_teachers
        where organization_id = p_org and (
          external_id = trim(p_entity) or id::text = trim(p_entity)
          or lower(full_name) = lower(trim(p_entity))))
    union
    select e.item_id from core.schedule_item_classroom e
      where p_type = 'classroom' and e.classroom_id in (
        select id from core.schedule_classrooms
        where organization_id = p_org and (
          external_id = trim(p_entity) or id::text = trim(p_entity)
          or lower(name) = lower(trim(p_entity))))
    union
    select e.item_id from core.schedule_item_classroom e
      join core.schedule_classrooms c on c.id = e.classroom_id
      where p_type = 'campus' and c.campus_id in (
        select id from core.schedule_campuses
        where organization_id = p_org and (
          external_id = trim(p_entity) or id::text = trim(p_entity)
          or lower(name) = lower(trim(p_entity)) or lower(short_name) = lower(trim(p_entity))))
  );
$$;

-- ── build the Flutter wire JSON array for a set of items ──────────────────────
create or replace function app_api_v1.schedule_items_wire(p_item_ids uuid[])
returns jsonb language sql stable set search_path = '' as $$
  select coalesce(jsonb_agg(elem order by ord_date, ord_start nulls last, ord_num nulls last), '[]'::jsonb)
  from (
    select
      si.first_date as ord_date, si.start_time as ord_start, si.lesson_number as ord_num,
      case si.kind
        when 'lesson' then jsonb_strip_nulls(jsonb_build_object(
          'type', '__lesson_schedule__',
          'subject', si.title,
          'lesson_type', si.lesson_type,
          'teachers', coalesce((
            select jsonb_agg(t.metadata order by t.full_name)
            from core.schedule_item_teacher e join core.schedule_teachers t on t.id = e.teacher_id
            where e.item_id = si.id), '[]'::jsonb),
          'classrooms', coalesce((
            select jsonb_agg(c.metadata order by c.name)
            from core.schedule_item_classroom e join core.schedule_classrooms c on c.id = e.classroom_id
            where e.item_id = si.id), '[]'::jsonb),
          'lesson_bells', jsonb_build_object(
            'number', si.lesson_number,
            'start_time', to_char(si.start_time, 'HH24:MI'),
            'end_time', to_char(si.end_time, 'HH24:MI')),
          'groups', (
            select jsonb_agg(g.name order by g.name)
            from core.schedule_item_group e join core.schedule_groups g on g.id = e.group_id
            where e.item_id = si.id),
          'group_entities', (
            select jsonb_agg(g.metadata - 'target_id' order by g.name)
            from core.schedule_item_group e join core.schedule_groups g on g.id = e.group_id
            where e.item_id = si.id),
          'uid', si.source_uid,
          'dates', (select jsonb_agg(to_char(d, 'DD-MM-YYYY') order by o)
                    from unnest(si.dates) with ordinality as x(d, o))
        ))
        when 'holiday' then jsonb_build_object(
          'type', '__holiday__', 'title', si.title,
          'dates', (select jsonb_agg(to_char(d, 'DD-MM-YYYY') order by o)
                    from unnest(si.dates) with ordinality as x(d, o)))
        else jsonb_strip_nulls(jsonb_build_object(
          'type', '__calendar_event__', 'kind', si.kind, 'title', si.title,
          'description', si.attributes ->> 'description',
          'location', si.attributes ->> 'location',
          'is_all_day', si.is_all_day, 'uid', si.source_uid,
          'starts_at', si.attributes ->> 'starts_at',
          'ends_at', si.attributes ->> 'ends_at',
          'source_links', si.attributes -> 'source_links',
          'dates', (select jsonb_agg(to_char(d, 'DD-MM-YYYY') order by o)
                    from unnest(si.dates) with ordinality as x(d, o))
        ))
      end as elem
    from core.schedule_item si
    where si.id = any(p_item_ids)
  ) z;
$$;

-- ── public-facing read RPCs (same signatures, rebuilt bodies) ─────────────────
create or replace function app_api_v1.get_schedule_for_target(
  p_target_type text, p_target text, p_organization_id text default null
) returns jsonb language sql stable set search_path = '' as $$
  select app_api_v1.schedule_items_wire(
    app_api_v1.schedule_resolve_item_ids(p_target_type, p_target, p_organization_id));
$$;

create or replace function app_api_v1.get_schedule_for_entity(
  p_entity_type text, p_entity text, p_date_from date default null, p_date_to date default null, p_organization_id text default null
) returns jsonb language sql stable set search_path = '' as $$
  select app_api_v1.schedule_items_wire(array(
    select si.id from core.schedule_item si
    where si.id = any(app_api_v1.schedule_resolve_item_ids(p_entity_type, p_entity, p_organization_id))
      and (p_date_from is null or si.dates[cardinality(si.dates)] >= p_date_from)
      and (p_date_to   is null or si.dates[1] <= p_date_to)
  ));
$$;

create or replace function public.get_schedule_for_target(
  p_target_type text, p_target text, p_organization_id text default null
) returns jsonb language sql stable set search_path = '' as $$
  select app_api_v1.get_schedule_for_target(p_target_type, p_target, p_organization_id);
$$;

create or replace function public.get_schedule_for_entity(
  p_entity_type text, p_entity text, p_date_from date default null, p_date_to date default null, p_organization_id text default null
) returns jsonb language sql stable set search_path = '' as $$
  select app_api_v1.get_schedule_for_entity(p_entity_type, p_entity, p_date_from, p_date_to, p_organization_id);
$$;

-- ── grants ────────────────────────────────────────────────────────────────────
do $$
declare f text;
begin
  foreach f in array array[
    'app_api_v1.schedule_resolve_item_ids(text,text,text)',
    'app_api_v1.schedule_items_wire(uuid[])',
    'app_api_v1.get_schedule_for_target(text,text,text)',
    'app_api_v1.get_schedule_for_entity(text,text,date,date,text)',
    'public.get_schedule_for_target(text,text,text)',
    'public.get_schedule_for_entity(text,text,date,date,text)'
  ] loop
    execute format('grant execute on function %s to anon, authenticated, service_role', f);
  end loop;
end $$;
