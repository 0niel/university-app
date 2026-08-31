-- Deduplicate schedule reads across imported targets.
--
-- RTU MIREA exposes the same lesson through group, teacher and classroom
-- calendars. Even group-only import can contain the same shared lesson in
-- multiple group targets. The storage layer intentionally keeps target payloads
-- for traceability, but the app-facing entity RPC must return canonical
-- occurrences once per entity/date.

create or replace function app_api_v1.get_schedule_for_entity(
  p_entity_type text,
  p_entity text,
  p_date_from date default null,
  p_date_to date default null,
  p_institution_id text default null
)
returns jsonb
language sql
stable
set search_path = ''
as $$
  with matched_occurrences as (
    select
      so.schedule_part_id,
      so.lesson_date,
      so.start_time,
      so.end_time,
      so.lesson_number,
      sp.part_type,
      sp.subject,
      sp.title,
      sp.lesson_type,
      sp.payload,
      st.target_type,
      st.external_id as target_external_id,
      st.target_title,
      st.full_title,
      coalesce(
        'uid:' || nullif(trim(coalesce(so.source_uid, '')), ''),
        'payload_uid:' || nullif(trim(coalesce(sp.payload ->> 'uid', '')), ''),
        'payload_external:' || nullif(trim(coalesce(sp.payload ->> 'external_id', '')), ''),
        'fingerprint:' || md5(
          jsonb_strip_nulls(
            (sp.payload - 'dates')
            || jsonb_build_object(
              'part_type', sp.part_type,
              'subject', sp.subject,
              'title', sp.title,
              'lesson_type', sp.lesson_type,
              'start_time', so.start_time,
              'end_time', so.end_time,
              'lesson_number', so.lesson_number
            )
          )::text
        )
      ) as canonical_part_key,
      case
        when st.target_type = p_entity_type
          and (
            st.external_id = trim(p_entity)
            or st.id::text = trim(p_entity)
            or lower(st.target_title) = lower(trim(p_entity))
            or lower(st.full_title) = lower(trim(p_entity))
          )
          then 0
        else 1
      end as target_priority
    from core.schedule_occurrences so
    join core.schedule_parts sp on sp.id = so.schedule_part_id
    join core.schedule_targets st on st.id = sp.target_id
    where (p_institution_id is null or so.institution_id = p_institution_id)
      and (p_date_from is null or so.lesson_date >= p_date_from)
      and (p_date_to is null or so.lesson_date <= p_date_to)
      and (
        (
          p_entity_type = 'group'
          and exists (
            select 1
            from core.schedule_part_groups spg
            join core.schedule_groups g on g.id = spg.group_id
            where spg.schedule_part_id = sp.id
              and (
                g.id::text = trim(p_entity)
                or g.external_id = trim(p_entity)
                or lower(g.name) = lower(trim(p_entity))
              )
          )
        )
        or (
          p_entity_type = 'teacher'
          and exists (
            select 1
            from core.schedule_part_teachers spt
            join core.schedule_teachers t on t.id = spt.teacher_id
            where spt.schedule_part_id = sp.id
              and (
                t.id::text = trim(p_entity)
                or t.external_id = trim(p_entity)
                or lower(t.full_name) = lower(trim(p_entity))
              )
          )
        )
        or (
          p_entity_type = 'classroom'
          and exists (
            select 1
            from core.schedule_part_classrooms spc
            join core.schedule_classrooms c on c.id = spc.classroom_id
            where spc.schedule_part_id = sp.id
              and (
                c.id::text = trim(p_entity)
                or c.external_id = trim(p_entity)
                or lower(c.name) = lower(trim(p_entity))
              )
          )
        )
        or (
          p_entity_type = 'campus'
          and exists (
            select 1
            from core.schedule_part_classrooms spc
            join core.schedule_classrooms c on c.id = spc.classroom_id
            join core.schedule_campuses campus on campus.id = c.campus_id
            where spc.schedule_part_id = sp.id
              and (
                campus.id::text = trim(p_entity)
                or campus.external_id = trim(p_entity)
                or lower(campus.name) = lower(trim(p_entity))
                or lower(campus.short_name) = lower(trim(p_entity))
              )
          )
        )
      )
  ),
  deduped_occurrences as (
    select distinct on (canonical_part_key, lesson_date)
      canonical_part_key,
      lesson_date,
      start_time,
      end_time,
      lesson_number,
      payload,
      target_priority
    from matched_occurrences
    order by
      canonical_part_key,
      lesson_date,
      target_priority,
      target_type,
      target_external_id
  ),
  dates as (
    select
      canonical_part_key,
      jsonb_agg(to_char(lesson_date, 'DD-MM-YYYY') order by lesson_date) as dates,
      min(lesson_date) as first_date
    from deduped_occurrences
    group by canonical_part_key
  ),
  chosen_parts as (
    select distinct on (canonical_part_key)
      canonical_part_key,
      payload,
      start_time,
      lesson_number
    from deduped_occurrences
    order by
      canonical_part_key,
      target_priority,
      lesson_date,
      start_time nulls last,
      lesson_number nulls last
  )
  select coalesce(
    jsonb_agg(
      chosen_parts.payload || jsonb_build_object('dates', dates.dates)
      order by dates.first_date, chosen_parts.start_time, chosen_parts.lesson_number
    ),
    '[]'::jsonb
  )
  from chosen_parts
  join dates on dates.canonical_part_key = chosen_parts.canonical_part_key;
$$;

grant execute on function app_api_v1.get_schedule_for_entity(text, text, date, date, text)
to anon, authenticated, service_role;
