-- Generalize schedule storage from an RTU MIREA target dump to an
-- open-source calendar model.
--
-- Principles:
-- - source-specific links live in source_links/metadata, not first-class columns
-- - every schedule item can become a calendar occurrence
-- - lessons are just one occurrence kind
-- - legacy grouped Flutter RPCs remain compatible

alter table core.schedule_targets
add column if not exists source_links jsonb not null default '{}'::jsonb;

alter table core.schedule_targets
drop constraint if exists schedule_targets_source_links_is_object;

alter table core.schedule_targets
add constraint schedule_targets_source_links_is_object check (
  jsonb_typeof(source_links) = 'object'
);

update core.schedule_targets
set source_links = source_links || jsonb_strip_nulls(
  jsonb_build_object(
    'calendar_feed', ical_url,
    'preview_image', schedule_image_url,
    'update_preview_image', schedule_update_image_url,
    'web', ui_url
  )
)
where
  to_regclass('core.schedule_targets') is not null
  and (
    ical_url is not null
    or schedule_image_url is not null
    or schedule_update_image_url is not null
    or ui_url is not null
  );

alter table core.schedule_occurrences
add column if not exists occurrence_date date,
add column if not exists starts_at timestamptz,
add column if not exists ends_at timestamptz,
add column if not exists is_all_day boolean not null default false,
add column if not exists timezone text,
add column if not exists occurrence_kind text,
add column if not exists source_links jsonb not null default '{}'::jsonb;

alter table core.schedule_occurrences
drop constraint if exists schedule_occurrences_source_links_is_object;

alter table core.schedule_occurrences
add constraint schedule_occurrences_source_links_is_object check (
  jsonb_typeof(source_links) = 'object'
);

alter table core.schedule_occurrences
drop constraint if exists schedule_occurrences_time_range_valid;

alter table core.schedule_occurrences
add constraint schedule_occurrences_time_range_valid check (
  starts_at is null
  or ends_at is null
  or ends_at >= starts_at
);

create or replace function core.schedule_local_datetime(
  p_date date,
  p_time time,
  p_timezone text
)
returns timestamptz
language sql
immutable
set search_path = ''
as $$
  select pg_catalog.make_timestamptz(
    extract(year from p_date)::integer,
    extract(month from p_date)::integer,
    extract(day from p_date)::integer,
    extract(hour from coalesce(p_time, time '00:00'))::integer,
    extract(minute from coalesce(p_time, time '00:00'))::integer,
    extract(second from coalesce(p_time, time '00:00')),
    coalesce(nullif(trim(p_timezone), ''), 'UTC')
  );
$$;

create or replace function core.set_schedule_occurrence_calendar_fields()
returns trigger
language plpgsql
set search_path = ''
as $$
declare
  v_timezone text;
  v_starts_at_text text;
  v_ends_at_text text;
  v_kind text;
  v_source_links jsonb;
begin
  select coalesce(nullif(trim(i.timezone), ''), 'UTC')
  into v_timezone
  from core.institutions i
  where i.id = new.institution_id;

  v_timezone := coalesce(
    nullif(trim(new.payload ->> 'timezone'), ''),
    nullif(trim(new.timezone), ''),
    v_timezone,
    'UTC'
  );

  v_starts_at_text := coalesce(
    nullif(trim(new.payload ->> 'starts_at'), ''),
    nullif(trim(new.payload ->> 'start_at'), ''),
    nullif(trim(new.payload ->> 'startsAt'), ''),
    nullif(trim(new.payload ->> 'startAt'), '')
  );

  v_ends_at_text := coalesce(
    nullif(trim(new.payload ->> 'ends_at'), ''),
    nullif(trim(new.payload ->> 'end_at'), ''),
    nullif(trim(new.payload ->> 'endsAt'), ''),
    nullif(trim(new.payload ->> 'endAt'), '')
  );

  v_kind := coalesce(
    nullif(trim(new.payload ->> 'part_type'), ''),
    nullif(trim(new.payload ->> 'kind'), ''),
    nullif(trim(new.payload ->> 'type'), ''),
    'unknown'
  );

  v_kind := case
    when v_kind = '__lesson_schedule__' then 'lesson'
    when v_kind = '__holiday__' then 'holiday'
    when v_kind in ('lesson', 'holiday', 'event', 'exam', 'deadline', 'note', 'custom') then v_kind
    else 'unknown'
  end;

  v_source_links := coalesce(new.payload -> 'source_links', new.payload -> 'sourceLinks', '{}'::jsonb);
  if jsonb_typeof(v_source_links) is distinct from 'object' then
    v_source_links := '{}'::jsonb;
  end if;

  new.timezone := v_timezone;
  new.occurrence_kind := coalesce(nullif(trim(new.occurrence_kind), ''), v_kind);
  new.source_links := coalesce(new.source_links, '{}'::jsonb) || v_source_links;
  new.is_all_day := coalesce(
    (new.payload ->> 'is_all_day')::boolean,
    (new.payload ->> 'isAllDay')::boolean,
    new.is_all_day,
    new.start_time is null and new.end_time is null
  );

  new.starts_at := coalesce(
    new.starts_at,
    case when v_starts_at_text is null then null else v_starts_at_text::timestamptz end,
    core.schedule_local_datetime(new.lesson_date, new.start_time, v_timezone)
  );

  new.ends_at := coalesce(
    new.ends_at,
    case when v_ends_at_text is null then null else v_ends_at_text::timestamptz end,
    case
      when new.end_time is not null and new.lesson_date is not null then
        core.schedule_local_datetime(
          case
            when new.start_time is not null and new.end_time < new.start_time
              then new.lesson_date + 1
            else new.lesson_date
          end,
          new.end_time,
          v_timezone
        )
      when new.is_all_day and new.starts_at is not null then new.starts_at + interval '1 day'
      else new.starts_at
    end
  );

  new.occurrence_date := coalesce(
    new.occurrence_date,
    (new.starts_at at time zone v_timezone)::date,
    new.lesson_date
  );

  return new;
end;
$$;

drop trigger if exists set_schedule_occurrence_calendar_fields
on core.schedule_occurrences;

create trigger set_schedule_occurrence_calendar_fields
before insert or update on core.schedule_occurrences
for each row execute function core.set_schedule_occurrence_calendar_fields();

update core.schedule_occurrences
set updated_at = updated_at;

create index if not exists schedule_occurrences_institution_starts_at_idx
on core.schedule_occurrences (institution_id, starts_at, ends_at);

create index if not exists schedule_occurrences_institution_kind_starts_at_idx
on core.schedule_occurrences (institution_id, occurrence_kind, starts_at);

-- search_schedule_targets changes return shape, so recreate wrappers.
drop function if exists public.search_schedule_targets(text, text, text, integer);
drop function if exists app_api_v1.search_schedule_targets(text, text, text, integer);

create or replace function app_api_v1.search_schedule_targets(
  p_target_type text,
  p_query text default '',
  p_institution_id text default null,
  p_limit integer default 20
)
returns table (
  target_type text,
  external_id text,
  target_title text,
  full_title text,
  source_links jsonb
)
language sql
stable
set search_path = ''
as $$
  select
    st.target_type,
    st.external_id,
    st.target_title,
    st.full_title,
    st.source_links
  from core.schedule_targets st
  where st.is_active
    and st.target_type = p_target_type
    and (p_institution_id is null or st.institution_id = p_institution_id)
    and (
      nullif(trim(coalesce(p_query, '')), '') is null
      or st.target_title ilike '%' || trim(p_query) || '%'
      or st.full_title ilike '%' || trim(p_query) || '%'
      or st.external_id = trim(p_query)
    )
  order by
    case
      when lower(st.target_title) = lower(trim(coalesce(p_query, ''))) then 0
      when lower(st.full_title) = lower(trim(coalesce(p_query, ''))) then 1
      when st.target_title ilike trim(coalesce(p_query, '')) || '%' then 2
      when st.full_title ilike trim(coalesce(p_query, '')) || '%' then 3
      else 4
    end,
    st.target_title
  limit least(greatest(coalesce(p_limit, 20), 1), 100);
$$;

create or replace function public.search_schedule_targets(
  p_target_type text,
  p_query text default '',
  p_institution_id text default null,
  p_limit integer default 20
)
returns table (
  target_type text,
  external_id text,
  target_title text,
  full_title text,
  source_links jsonb
)
language sql
stable
set search_path = ''
as $$
  select *
  from app_api_v1.search_schedule_targets(
    p_target_type,
    p_query,
    p_institution_id,
    p_limit
  );
$$;

grant execute on function app_api_v1.search_schedule_targets(text, text, text, integer)
to anon, authenticated, service_role;

revoke all on function public.search_schedule_targets(text, text, text, integer)
from public;

grant execute on function public.search_schedule_targets(text, text, text, integer)
to anon, authenticated, service_role;

create or replace function app_api_v1.get_schedule_occurrences_for_entity(
  p_entity_type text,
  p_entity text,
  p_starts_at timestamptz default null,
  p_ends_at timestamptz default null,
  p_institution_id text default null
)
returns jsonb
language sql
stable
set search_path = ''
as $$
  with matched as (
    select
      so.id,
      so.schedule_part_id,
      so.occurrence_kind,
      so.occurrence_date,
      so.starts_at,
      so.ends_at,
      so.is_all_day,
      so.timezone,
      so.lesson_number,
      so.source_uid,
      so.occurrence_key,
      so.source_links,
      so.payload,
      sp.part_type,
      sp.subject,
      sp.title,
      sp.lesson_type,
      st.target_type,
      st.external_id as target_external_id,
      coalesce(
        'uid:' || nullif(trim(coalesce(so.source_uid, '')), ''),
        'payload_uid:' || nullif(trim(coalesce(sp.payload ->> 'uid', '')), ''),
        'payload_external:' || nullif(trim(coalesce(sp.payload ->> 'external_id', '')), ''),
        'fingerprint:' || md5(
          jsonb_strip_nulls(
            (sp.payload - 'dates')
            || jsonb_build_object(
              'kind', so.occurrence_kind,
              'subject', sp.subject,
              'title', sp.title,
              'starts_at', so.starts_at,
              'ends_at', so.ends_at,
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
      and (p_starts_at is null or coalesce(so.ends_at, so.starts_at) >= p_starts_at)
      and (p_ends_at is null or so.starts_at <= p_ends_at)
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
  deduped as (
    select distinct on (canonical_part_key, starts_at, ends_at)
      *
    from matched
    order by
      canonical_part_key,
      starts_at,
      ends_at,
      target_priority,
      target_type,
      target_external_id
  )
  select coalesce(
    jsonb_agg(
      jsonb_strip_nulls(
        jsonb_build_object(
          'id', id,
          'schedule_part_id', schedule_part_id,
          'kind', occurrence_kind,
          'title', coalesce(title, subject),
          'subject', subject,
          'lesson_type', lesson_type,
          'lesson_number', lesson_number,
          'occurrence_date', occurrence_date,
          'starts_at', starts_at,
          'ends_at', ends_at,
          'is_all_day', is_all_day,
          'timezone', timezone,
          'source_uid', source_uid,
          'occurrence_key', occurrence_key,
          'source_links', source_links,
          'payload', payload
        )
      )
      order by starts_at, ends_at, lesson_number
    ),
    '[]'::jsonb
  )
  from deduped;
$$;

create or replace function public.get_schedule_occurrences_for_entity(
  p_entity_type text,
  p_entity text,
  p_starts_at timestamptz default null,
  p_ends_at timestamptz default null,
  p_institution_id text default null
)
returns jsonb
language sql
stable
set search_path = ''
as $$
  select app_api_v1.get_schedule_occurrences_for_entity(
    p_entity_type,
    p_entity,
    p_starts_at,
    p_ends_at,
    p_institution_id
  );
$$;

grant execute on function app_api_v1.get_schedule_occurrences_for_entity(text, text, timestamptz, timestamptz, text)
to anon, authenticated, service_role;

revoke all on function public.get_schedule_occurrences_for_entity(text, text, timestamptz, timestamptz, text)
from public;

grant execute on function public.get_schedule_occurrences_for_entity(text, text, timestamptz, timestamptz, text)
to anon, authenticated, service_role;

-- Replace ingest so target links are stored generically.
create or replace function ingest_v1.upsert_schedule_payload(
  p_institution_id text,
  p_source jsonb,
  p_targets jsonb,
  p_sync_run_id uuid default null
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_target jsonb;
  v_part jsonb;
  v_date_value jsonb;
  v_group_entity jsonb;
  v_teacher_entity jsonb;
  v_classroom_entity jsonb;
  v_group_name text;
  v_institution_name text := coalesce(nullif(trim(p_source ->> 'institution_name'), ''), p_institution_id);
  v_target_type text;
  v_external_id text;
  v_target_title text;
  v_full_title text;
  v_target_source_links jsonb;
  v_target_id uuid;
  v_part_id uuid;
  v_part_type text;
  v_part_external_id text;
  v_source_uid text;
  v_subject text;
  v_discipline_id uuid;
  v_group_id uuid;
  v_teacher_id uuid;
  v_classroom_id uuid;
  v_dates date[];
  v_date date;
  v_lesson_bells jsonb;
  v_teachers jsonb;
  v_classrooms jsonb;
  v_group_entities jsonb;
  v_groups text[];
  v_received integer := 0;
  v_targets_upserted integer := 0;
  v_parts_upserted integer := 0;
  v_occurrences_upserted integer := 0;
  v_items_skipped integer := 0;
  v_full_replace boolean;
begin
  if nullif(trim(p_institution_id), '') is null then
    raise exception 'p_institution_id is required';
  end if;

  if jsonb_typeof(p_targets) is distinct from 'array' then
    raise exception 'p_targets must be a JSON array';
  end if;

  insert into core.institutions (id, name, timezone, metadata)
  values (
    p_institution_id,
    v_institution_name,
    coalesce(nullif(trim(p_source ->> 'timezone'), ''), 'Europe/Moscow'),
    coalesce(p_source -> 'institution_metadata', '{}'::jsonb)
  )
  on conflict (id) do update
  set name = excluded.name,
      timezone = excluded.timezone,
      metadata = core.institutions.metadata || excluded.metadata;

  for v_target in select value from jsonb_array_elements(p_targets) as target(value) loop
    v_received := v_received + 1;
    v_target_type := ingest_v1.normalize_schedule_target_type(v_target);
    v_external_id := coalesce(
      nullif(trim(v_target ->> 'external_id'), ''),
      nullif(trim(v_target ->> 'id'), ''),
      nullif(trim(v_target ->> 'uid'), '')
    );
    v_target_title := coalesce(
      nullif(trim(v_target ->> 'target_title'), ''),
      nullif(trim(v_target ->> 'targetTitle'), ''),
      nullif(trim(v_target ->> 'title'), ''),
      nullif(trim(v_target ->> 'name'), ''),
      nullif(trim(v_target ->> 'full_title'), ''),
      nullif(trim(v_target ->> 'fullTitle'), '')
    );
    v_full_title := coalesce(
      nullif(trim(v_target ->> 'full_title'), ''),
      nullif(trim(v_target ->> 'fullTitle'), ''),
      v_target_title
    );

    if v_target_type is null or v_external_id is null or v_target_title is null then
      v_items_skipped := v_items_skipped + 1;
      continue;
    end if;

    v_target_source_links := coalesce(v_target -> 'source_links', v_target -> 'sourceLinks', '{}'::jsonb);
    if jsonb_typeof(v_target_source_links) is distinct from 'object' then
      v_target_source_links := '{}'::jsonb;
    end if;
    v_target_source_links := v_target_source_links || jsonb_strip_nulls(
      jsonb_build_object(
        'calendar_feed', coalesce(v_target ->> 'calendar_feed_url', v_target ->> 'source_feed_url', v_target ->> 'ical_url', v_target ->> 'iCalLink'),
        'preview_image', coalesce(v_target ->> 'preview_image_url', v_target ->> 'schedule_image_url', v_target ->> 'scheduleImageLink'),
        'update_preview_image', coalesce(v_target ->> 'update_preview_image_url', v_target ->> 'schedule_update_image_url', v_target ->> 'scheduleUpdateImageLink'),
        'web', coalesce(v_target ->> 'web_url', v_target ->> 'ui_url', v_target ->> 'scheduleUIAddToCalendarLink')
      )
    );

    insert into core.schedule_targets (
      institution_id,
      target_type,
      external_id,
      target_title,
      full_title,
      source_links,
      current_hash_version,
      current_hash,
      is_active,
      last_synced_at,
      metadata
    )
    values (
      p_institution_id,
      v_target_type,
      v_external_id,
      v_target_title,
      v_full_title,
      v_target_source_links,
      nullif(coalesce(v_target ->> 'hash_version', v_target ->> 'hashVersion'), '')::integer,
      nullif(trim(coalesce(v_target ->> 'hash', v_target ->> 'current_hash', '')), ''),
      coalesce((v_target ->> 'is_active')::boolean, true),
      now(),
      coalesce(v_target -> 'metadata', '{}'::jsonb)
    )
    on conflict (institution_id, target_type, external_id) do update
    set target_title = excluded.target_title,
        full_title = excluded.full_title,
        source_links = core.schedule_targets.source_links || excluded.source_links,
        current_hash_version = excluded.current_hash_version,
        current_hash = excluded.current_hash,
        is_active = excluded.is_active,
        last_synced_at = excluded.last_synced_at,
        metadata = core.schedule_targets.metadata || excluded.metadata
    returning id into v_target_id;

    v_targets_upserted := v_targets_upserted + 1;
    v_full_replace := coalesce((v_target ->> 'full_replace')::boolean, true);

    if v_full_replace then
      delete from core.schedule_parts where target_id = v_target_id;
    end if;

    if jsonb_typeof(v_target -> 'parts') is distinct from 'array' then
      continue;
    end if;

    for v_part in select value from jsonb_array_elements(v_target -> 'parts') as part(value) loop
      v_part_type := case
        when coalesce(v_part ->> 'part_type', v_part ->> 'type') in ('lesson', '__lesson_schedule__') then 'lesson'
        when coalesce(v_part ->> 'part_type', v_part ->> 'type') in ('holiday', '__holiday__') then 'holiday'
        when coalesce(v_part ->> 'part_type', v_part ->> 'type') in ('event', 'exam', 'deadline', 'note', 'custom') then coalesce(v_part ->> 'part_type', v_part ->> 'type')
        else 'unknown'
      end;

      v_dates := array[]::date[];
      if jsonb_typeof(v_part -> 'dates') = 'array' then
        for v_date_value in select value from jsonb_array_elements(v_part -> 'dates') as date_value(value) loop
          v_date := ingest_v1.parse_schedule_date(trim(both '"' from v_date_value::text));
          if v_date is null then
            v_items_skipped := v_items_skipped + 1;
          else
            v_dates := array_append(v_dates, v_date);
          end if;
        end loop;
      end if;

      if coalesce(array_length(v_dates, 1), 0) = 0 then
        v_items_skipped := v_items_skipped + 1;
        continue;
      end if;

      v_lesson_bells := coalesce(v_part -> 'lesson_bells', v_part -> 'lessonBells', '{}'::jsonb);
      v_teachers := coalesce(v_part -> 'teachers', '[]'::jsonb);
      v_classrooms := coalesce(v_part -> 'classrooms', '[]'::jsonb);
      v_group_entities := coalesce(v_part -> 'group_entities', v_part -> 'groupEntities', '[]'::jsonb);

      if jsonb_typeof(v_teachers) is distinct from 'array' then v_teachers := '[]'::jsonb; end if;
      if jsonb_typeof(v_classrooms) is distinct from 'array' then v_classrooms := '[]'::jsonb; end if;
      if jsonb_typeof(v_group_entities) is distinct from 'array' then v_group_entities := '[]'::jsonb; end if;

      select coalesce(array_agg(value), '{}'::text[])
      into v_groups
      from jsonb_array_elements_text(coalesce(v_part -> 'groups', '[]'::jsonb)) as groups(value);

      v_source_uid := nullif(trim(coalesce(v_part ->> 'uid', v_part ->> 'external_id', '')), '');
      v_subject := coalesce(nullif(trim(v_part ->> 'subject'), ''), nullif(trim(v_part ->> 'title'), ''));
      v_discipline_id := ingest_v1.upsert_schedule_discipline(p_institution_id, v_subject, null, '{}'::jsonb);

      v_part_external_id := coalesce(
        v_source_uid,
        md5(
          v_target_id::text || ':' ||
          coalesce(v_part ->> 'type', '') || ':' ||
          coalesce(v_subject, '') || ':' ||
          coalesce(v_lesson_bells ->> 'number', '') || ':' ||
          coalesce(v_lesson_bells ->> 'startTime', v_lesson_bells ->> 'start_time', '') || ':' ||
          coalesce(v_lesson_bells ->> 'endTime', v_lesson_bells ->> 'end_time', '') || ':' ||
          array_to_string(v_dates, ',') || ':' ||
          v_teachers::text || ':' ||
          v_classrooms::text
        )
      );

      insert into core.schedule_parts (
        institution_id,
        target_id,
        discipline_id,
        part_type,
        external_id,
        subject,
        title,
        lesson_type,
        lesson_number,
        start_time,
        end_time,
        teachers,
        classrooms,
        groups,
        payload,
        raw_data,
        content_hash,
        first_date,
        last_date,
        metadata
      )
      values (
        p_institution_id,
        v_target_id,
        v_discipline_id,
        v_part_type,
        v_part_external_id,
        nullif(trim(v_part ->> 'subject'), ''),
        nullif(trim(v_part ->> 'title'), ''),
        nullif(trim(coalesce(v_part ->> 'lesson_type', v_part ->> 'lessonType')), ''),
        nullif(v_lesson_bells ->> 'number', '')::integer,
        nullif(coalesce(v_lesson_bells ->> 'start_time', v_lesson_bells ->> 'startTime'), '')::time,
        nullif(coalesce(v_lesson_bells ->> 'end_time', v_lesson_bells ->> 'endTime'), '')::time,
        v_teachers,
        v_classrooms,
        v_groups,
        v_part,
        coalesce(v_part -> 'raw_data', '{}'::jsonb),
        md5(v_part::text),
        (select min(d) from unnest(v_dates) as d),
        (select max(d) from unnest(v_dates) as d),
        coalesce(v_part -> 'metadata', '{}'::jsonb)
      )
      on conflict (target_id, external_id) do update
      set discipline_id = excluded.discipline_id,
          part_type = excluded.part_type,
          subject = excluded.subject,
          title = excluded.title,
          lesson_type = excluded.lesson_type,
          lesson_number = excluded.lesson_number,
          start_time = excluded.start_time,
          end_time = excluded.end_time,
          teachers = excluded.teachers,
          classrooms = excluded.classrooms,
          groups = excluded.groups,
          payload = excluded.payload,
          raw_data = excluded.raw_data,
          content_hash = excluded.content_hash,
          first_date = excluded.first_date,
          last_date = excluded.last_date,
          metadata = core.schedule_parts.metadata || excluded.metadata
      returning id into v_part_id;

      delete from core.schedule_part_dates where schedule_part_id = v_part_id;
      delete from core.schedule_part_groups where schedule_part_id = v_part_id;
      delete from core.schedule_part_teachers where schedule_part_id = v_part_id;
      delete from core.schedule_part_classrooms where schedule_part_id = v_part_id;
      delete from core.schedule_occurrences where schedule_part_id = v_part_id;

      foreach v_date in array v_dates loop
        insert into core.schedule_part_dates (institution_id, target_id, schedule_part_id, lesson_date)
        values (p_institution_id, v_target_id, v_part_id, v_date)
        on conflict (schedule_part_id, lesson_date) do nothing;

        insert into core.schedule_occurrences (
          institution_id,
          target_id,
          schedule_part_id,
          discipline_id,
          lesson_date,
          start_time,
          end_time,
          lesson_number,
          source_uid,
          occurrence_key,
          content_hash,
          payload
        )
        values (
          p_institution_id,
          v_target_id,
          v_part_id,
          v_discipline_id,
          v_date,
          nullif(coalesce(v_lesson_bells ->> 'start_time', v_lesson_bells ->> 'startTime'), '')::time,
          nullif(coalesce(v_lesson_bells ->> 'end_time', v_lesson_bells ->> 'endTime'), '')::time,
          nullif(v_lesson_bells ->> 'number', '')::integer,
          v_source_uid,
          coalesce(v_source_uid, v_part_external_id) || ':' || v_date::text,
          md5(v_part::text || ':' || v_date::text),
          v_part || jsonb_build_object('dates', jsonb_build_array(to_char(v_date, 'DD-MM-YYYY')))
        )
        on conflict (schedule_part_id, lesson_date) do update
        set discipline_id = excluded.discipline_id,
            start_time = excluded.start_time,
            end_time = excluded.end_time,
            lesson_number = excluded.lesson_number,
            source_uid = excluded.source_uid,
            occurrence_key = excluded.occurrence_key,
            content_hash = excluded.content_hash,
            payload = excluded.payload;

        v_occurrences_upserted := v_occurrences_upserted + 1;
      end loop;

      if jsonb_array_length(v_group_entities) > 0 then
        for v_group_entity in select value from jsonb_array_elements(v_group_entities) as entity(value) loop
          v_group_id := ingest_v1.upsert_schedule_group(
            p_institution_id,
            coalesce(v_group_entity ->> 'name', v_group_entity ->> 'title'),
            coalesce(v_group_entity ->> 'uid', v_group_entity ->> 'external_id'),
            v_group_entity
          );
          if v_group_id is not null then
            insert into core.schedule_part_groups (schedule_part_id, group_id)
            values (v_part_id, v_group_id)
            on conflict do nothing;
          end if;
        end loop;
      else
        foreach v_group_name in array v_groups loop
          v_group_id := ingest_v1.upsert_schedule_group(p_institution_id, v_group_name, null, '{}'::jsonb);
          if v_group_id is not null then
            insert into core.schedule_part_groups (schedule_part_id, group_id)
            values (v_part_id, v_group_id)
            on conflict do nothing;
          end if;
        end loop;
      end if;

      if v_target_type = 'group' then
        v_group_id := ingest_v1.upsert_schedule_group(
          p_institution_id,
          v_full_title,
          v_external_id,
          jsonb_build_object('target_id', v_target_id)
        );
        if v_group_id is not null then
          insert into core.schedule_part_groups (schedule_part_id, group_id)
          values (v_part_id, v_group_id)
          on conflict do nothing;
        end if;
      end if;

      for v_teacher_entity in select value from jsonb_array_elements(v_teachers) as entity(value) loop
        v_teacher_id := ingest_v1.upsert_schedule_teacher(
          p_institution_id,
          coalesce(v_teacher_entity ->> 'name', v_teacher_entity #>> '{}'),
          coalesce(v_teacher_entity ->> 'uid', v_teacher_entity ->> 'external_id'),
          v_teacher_entity
        );
        if v_teacher_id is not null then
          insert into core.schedule_part_teachers (schedule_part_id, teacher_id)
          values (v_part_id, v_teacher_id)
          on conflict do nothing;
        end if;
      end loop;

      if v_target_type = 'teacher' then
        v_teacher_id := ingest_v1.upsert_schedule_teacher(
          p_institution_id,
          v_full_title,
          v_external_id,
          jsonb_build_object('target_id', v_target_id)
        );
        if v_teacher_id is not null then
          insert into core.schedule_part_teachers (schedule_part_id, teacher_id)
          values (v_part_id, v_teacher_id)
          on conflict do nothing;
        end if;
      end if;

      for v_classroom_entity in select value from jsonb_array_elements(v_classrooms) as entity(value) loop
        v_classroom_id := ingest_v1.upsert_schedule_classroom(
          p_institution_id,
          coalesce(v_classroom_entity ->> 'name', v_classroom_entity #>> '{}'),
          coalesce(v_classroom_entity ->> 'uid', v_classroom_entity ->> 'external_id'),
          coalesce(v_classroom_entity #>> '{campus,name}', v_classroom_entity #>> '{campus,short_name}'),
          v_classroom_entity #>> '{campus,short_name}',
          coalesce(v_classroom_entity #>> '{campus,uid}', v_classroom_entity #>> '{campus,external_id}'),
          v_classroom_entity
        );
        if v_classroom_id is not null then
          insert into core.schedule_part_classrooms (schedule_part_id, classroom_id)
          values (v_part_id, v_classroom_id)
          on conflict do nothing;
        end if;
      end loop;

      if v_target_type = 'classroom' then
        v_classroom_id := ingest_v1.upsert_schedule_classroom(
          p_institution_id,
          v_full_title,
          v_external_id,
          null,
          null,
          null,
          jsonb_build_object('target_id', v_target_id)
        );
        if v_classroom_id is not null then
          insert into core.schedule_part_classrooms (schedule_part_id, classroom_id)
          values (v_part_id, v_classroom_id)
          on conflict do nothing;
        end if;
      end if;

      v_parts_upserted := v_parts_upserted + 1;
    end loop;

    insert into internal.raw_payloads (
      sync_run_id,
      institution_id,
      source_type,
      source_external_id,
      entity,
      external_id,
      payload
    )
    values (
      p_sync_run_id,
      p_institution_id,
      coalesce(nullif(trim(p_source ->> 'source_type'), ''), 'schedule'),
      coalesce(nullif(trim(p_source ->> 'source_external_id'), ''), 'unknown'),
      'schedule_targets',
      v_external_id,
      v_target
    );
  end loop;

  return jsonb_build_object(
    'institution_id', p_institution_id,
    'targets_received', v_received,
    'targets_upserted', v_targets_upserted,
    'parts_upserted', v_parts_upserted,
    'occurrences_upserted', v_occurrences_upserted,
    'items_skipped', v_items_skipped
  );
end;
$$;

alter table core.schedule_targets
drop column if exists ical_url,
drop column if exists schedule_image_url,
drop column if exists schedule_update_image_url,
drop column if exists ui_url;
