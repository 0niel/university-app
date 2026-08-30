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
    (
      v_starts_at_text is null
      and v_ends_at_text is null
      and new.start_time is null
      and new.end_time is null
    ),
    new.is_all_day,
    false
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

update core.schedule_occurrences
set updated_at = updated_at;
