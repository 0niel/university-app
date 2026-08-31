-- Parse Flutter domain dates before ISO timestamps.
-- Postgres may interpret 01-09-2026 as January 9 in DateStyle-dependent casts.

create or replace function ingest_v1.parse_schedule_date(p_value text)
returns date
language plpgsql
stable
set search_path = ''
as $$
declare
  v_value text := nullif(trim(p_value), '');
begin
  if v_value is null then
    return null;
  end if;

  if v_value ~ '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' then
    return to_date(v_value, 'DD-MM-YYYY');
  end if;

  begin
    return (v_value::timestamptz)::date;
  exception when others then
    return null;
  end;
end;
$$;

revoke execute on function ingest_v1.parse_schedule_date(text)
from public;
grant execute on function ingest_v1.parse_schedule_date(text)
to service_role;
