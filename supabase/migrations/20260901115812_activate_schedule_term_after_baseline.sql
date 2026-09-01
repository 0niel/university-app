update core.term
set is_current = false
where organization_id = 'mirea'
  and id = 20262
  and not changes_active;

update core.term
set is_current = true
where organization_id = 'mirea'
  and id = 20261
  and exists (
    select 1
    from core.term
    where organization_id = 'mirea'
      and id = 20262
      and not changes_active
  );

create or replace function internal.activate_schedule_term_after_sync()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_term_id integer;
begin
  if new.source_type = 'schedule'
    and new.status = 'succeeded'
    and new.metadata @> '{"full_sync": true}'::jsonb
    and old.status is distinct from new.status then
    v_term_id := core.term_for_date(new.organization_id, current_date);
    if v_term_id is null then
      raise exception 'No schedule term for organization % and date %', new.organization_id, current_date;
    end if;
    update core.term
    set is_current = false
    where organization_id = new.organization_id
      and is_current
      and id <> v_term_id;
    update core.term
    set is_current = true,
        changes_active = true
    where organization_id = new.organization_id
      and id = v_term_id;
  end if;
  return new;
end;
$$;

revoke all on function internal.activate_schedule_term_after_sync()
from public, anon, authenticated;
