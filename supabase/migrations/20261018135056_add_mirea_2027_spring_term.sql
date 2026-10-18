insert into core.term (
  id, organization_id, code, title, starts_on, ends_on,
  is_current, changes_active
)
values (
  20271, 'mirea', '2027-spring', 'Весенний семестр 2026/27',
  '2027-02-01', '2027-08-31', false, false
)
on conflict (id) do update
set organization_id = excluded.organization_id,
    code = excluded.code,
    title = excluded.title,
    starts_on = excluded.starts_on,
    ends_on = excluded.ends_on;

create table if not exists core.schedule_item_occurrence_2027s
partition of core.schedule_item_occurrence for values in (20271);

create table if not exists core.schedule_item_change_2027s
partition of core.schedule_item_change for values in (20271);
