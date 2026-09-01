update core.term
set is_current = false
where organization_id = 'mirea'
  and id <> 20262
  and is_current;

insert into core.term (
  id,
  organization_id,
  code,
  title,
  starts_on,
  ends_on,
  is_current,
  changes_active
)
values (
  20262,
  'mirea',
  '2026-autumn',
  'Осенний семестр 2026/27',
  '2026-09-01',
  '2027-01-31',
  true,
  false
)
on conflict (id) do update
set organization_id = excluded.organization_id,
    code = excluded.code,
    title = excluded.title,
    starts_on = excluded.starts_on,
    ends_on = excluded.ends_on,
    is_current = excluded.is_current,
    changes_active = excluded.changes_active;

create table if not exists core.schedule_item_occurrence_2026a
partition of core.schedule_item_occurrence for values in (20262);

create table if not exists core.schedule_item_change_2026a
partition of core.schedule_item_change for values in (20262);

create or replace function internal.activate_schedule_term_after_sync()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if new.source_type = 'schedule'
    and new.status = 'succeeded'
    and new.metadata @> '{"full_sync": true}'::jsonb
    and old.status is distinct from new.status then
    update core.term
    set changes_active = true
    where organization_id = new.organization_id
      and is_current;
  end if;
  return new;
end;
$$;

revoke all on function internal.activate_schedule_term_after_sync()
from public, anon, authenticated;

drop trigger if exists activate_schedule_term_after_sync
on internal.sync_runs;

create trigger activate_schedule_term_after_sync
after update of status on internal.sync_runs
for each row execute function internal.activate_schedule_term_after_sync();
