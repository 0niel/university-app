-- Keep the schedule RPC compatible with packages/schedule DatesConverter.
-- Flutter domain JSON expects dates formatted as dd-MM-yyyy.

create or replace function ingest_v1.parse_schedule_date(p_value text)
returns date
language plpgsql
immutable
set search_path = ''
as $$
declare
  v_value text := nullif(trim(p_value), '');
begin
  if v_value is null then
    return null;
  end if;

  begin
    return (v_value::timestamptz)::date;
  exception when others then
    begin
      return to_date(v_value, 'DD-MM-YYYY');
    exception when others then
      return null;
    end;
  end;
end;
$$;

revoke execute on function ingest_v1.parse_schedule_date(text)
from public;
grant execute on function ingest_v1.parse_schedule_date(text)
to service_role;

create or replace function app_api_v1.get_schedule_for_target(
  p_target_type text,
  p_target text,
  p_institution_id text default null
)
returns jsonb
language sql
stable
set search_path = ''
as $$
  with selected_target as (
    select st.id
    from core.schedule_targets st
    where st.is_active
      and st.target_type = p_target_type
      and (p_institution_id is null or st.institution_id = p_institution_id)
      and (
        st.external_id = trim(p_target)
        or lower(st.target_title) = lower(trim(p_target))
        or lower(st.full_title) = lower(trim(p_target))
      )
    order by
      case when st.external_id = trim(p_target) then 0 else 1 end,
      st.target_title
    limit 1
  ),
  parts as (
    select
      sp.id,
      sp.first_date,
      sp.start_time,
      sp.lesson_number,
      sp.payload,
      coalesce(
        jsonb_agg(
          to_char(spd.lesson_date, 'DD-MM-YYYY')
          order by spd.lesson_date
        ) filter (where spd.lesson_date is not null),
        '[]'::jsonb
      ) as dates
    from core.schedule_parts sp
    join selected_target st on st.id = sp.target_id
    left join core.schedule_part_dates spd on spd.schedule_part_id = sp.id
    group by sp.id
  )
  select coalesce(
    jsonb_agg(
      parts.payload || jsonb_build_object('dates', parts.dates)
      order by parts.first_date, parts.start_time, parts.lesson_number
    ),
    '[]'::jsonb
  )
  from parts;
$$;

do $$
declare
  v_definition text;
  v_updated_definition text;
begin
  v_definition := pg_get_functiondef(
    'ingest_v1.upsert_schedule_payload(text,jsonb,jsonb,uuid)'::regprocedure
  );

  v_updated_definition := replace(
    v_definition,
    $old$
          begin
            v_dates := array_append(
              v_dates,
              (trim(both '"' from v_date_value::text)::timestamptz)::date
            );
          exception when others then
            v_skipped := v_skipped + 1;
          end;
$old$,
    $new$
          v_date := ingest_v1.parse_schedule_date(
            trim(both '"' from v_date_value::text)
          );

          if v_date is null then
            v_skipped := v_skipped + 1;
          else
            v_dates := array_append(v_dates, v_date);
          end if;
$new$
  );

  if v_updated_definition = v_definition then
    raise exception 'Failed to patch ingest_v1.upsert_schedule_payload date parser';
  end if;

  execute v_updated_definition;
end;
$$;
