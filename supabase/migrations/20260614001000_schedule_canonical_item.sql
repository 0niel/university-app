-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║ Canonical schedule model (schedule_item) — replaces the per-target,        ║
-- ║ per-date materialization (schedule_parts / schedule_part_dates /           ║
-- ║ schedule_occurrences). One row per physical schedule item, recurrence as   ║
-- ║ dates[], thin membership edges, term-partitioned occurrence + change feed. ║
-- ║ Audit: tools/schedule_fetcher/.logs/audit_synthesis.md                     ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- ── core.term ────────────────────────────────────────────────────────────────
-- Multi-semester scope + retention unit. id is an explicit deterministic int
-- (year*10 + sem; sem 1=spring,2=autumn) so partitions are reproducible.
create table if not exists core.term (
  id              int primary key,
  organization_id text not null,
  code            text not null,
  title           text not null,
  starts_on       date not null,
  ends_on         date not null,
  is_current      boolean not null default false,
  -- During the initial bulk backfill this stays false so the change trigger
  -- does not fabricate "add" rows for every item; flipped true once a term's
  -- baseline is established.
  changes_active  boolean not null default false,
  created_at      timestamptz not null default now(),
  unique (organization_id, code),
  constraint term_dates_valid check (ends_on >= starts_on)
);

insert into core.term (id, organization_id, code, title, starts_on, ends_on, is_current) values
  (20252, 'mirea', '2025-autumn', 'Осенний семестр 2025/26', '2025-09-01', '2026-01-31', false),
  (20261, 'mirea', '2026-spring', 'Весенний семестр 2025/26', '2026-02-01', '2026-08-31', true)
on conflict (id) do nothing;

create or replace function core.term_for_date(p_org text, p_date date)
returns int language sql stable set search_path = '' as $$
  select id from core.term
  where organization_id = p_org and p_date between starts_on and ends_on
  order by starts_on desc limit 1;
$$;

-- ── core.schedule_item (canonical, NOT partitioned) ──────────────────────────
create table if not exists core.schedule_item (
  id              uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null,
  term_id         int  not null references core.term(id),
  source_uid      text not null,                    -- iCal UID; target-independent
  kind            text not null,                    -- lesson|holiday|event|exam|deadline|note|custom|unknown
  title           text not null,                    -- subject (lessons) / title (others); display value
  -- lesson-only attributes (null for non-lessons):
  lesson_type     text,
  lesson_number   int,
  discipline_id   uuid references core.schedule_disciplines,
  start_time      time,
  end_time        time,
  is_all_day      boolean not null default false,
  -- calendar-item extras stored once per item (description/location/starts_at/ends_at/source_links):
  attributes      jsonb,
  dates           date[] not null,                  -- recurrence stored ONCE
  first_date      date generated always as (dates[1]) stored,
  content_hash    text not null,                    -- diff key for change history
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  constraint schedule_item_natural_key unique (organization_id, term_id, source_uid),
  constraint schedule_item_kind_valid
    check (kind in ('lesson','holiday','event','exam','deadline','note','custom','unknown')),
  constraint schedule_item_lesson_time
    check (kind <> 'lesson' or (start_time is not null and end_time is not null)),
  constraint schedule_item_dates_present check (cardinality(dates) > 0)
);

create index if not exists schedule_item_org_term_idx on core.schedule_item (organization_id, term_id);
create index if not exists schedule_item_discipline_idx on core.schedule_item (discipline_id);
create index if not exists schedule_item_first_date_idx on core.schedule_item using brin (first_date);

-- ── membership edges (single source of truth for who attends) ─────────────────
create table if not exists core.schedule_item_group (
  item_id  uuid not null references core.schedule_item(id) on delete cascade,
  group_id uuid not null references core.schedule_groups(id),
  primary key (item_id, group_id)
);
create table if not exists core.schedule_item_teacher (
  item_id    uuid not null references core.schedule_item(id) on delete cascade,
  teacher_id uuid not null references core.schedule_teachers(id),
  primary key (item_id, teacher_id)
);
create table if not exists core.schedule_item_classroom (
  item_id      uuid not null references core.schedule_item(id) on delete cascade,
  classroom_id uuid not null references core.schedule_classrooms(id),
  primary key (item_id, classroom_id)
);
create index if not exists schedule_item_group_group_idx on core.schedule_item_group (group_id);
create index if not exists schedule_item_teacher_teacher_idx on core.schedule_item_teacher (teacher_id);
create index if not exists schedule_item_classroom_classroom_idx on core.schedule_item_classroom (classroom_id);

-- ── core.schedule_item_occurrence (derived, skinny, term-partitioned) ─────────
-- Only for the calendar/free-room conflict path. List reads use schedule_item.dates[].
create table if not exists core.schedule_item_occurrence (
  item_id     uuid not null references core.schedule_item(id) on delete cascade,
  term_id     int  not null,
  lesson_date date not null,
  start_time  time,
  end_time    time,
  -- span GENERATED from same-row columns (no subquery); NULL for all-day items.
  span tstzrange generated always as (
    case when start_time is null then null else
      tstzrange((lesson_date + start_time) at time zone 'Europe/Moscow',
                (lesson_date + end_time)   at time zone 'Europe/Moscow')
    end
  ) stored,
  primary key (item_id, lesson_date, term_id)
) partition by list (term_id);

create table if not exists core.schedule_item_occurrence_2025a partition of core.schedule_item_occurrence for values in (20252);
create table if not exists core.schedule_item_occurrence_2026s partition of core.schedule_item_occurrence for values in (20261);
create table if not exists core.schedule_item_occurrence_default partition of core.schedule_item_occurrence default;
create index if not exists schedule_item_occ_date_brin on core.schedule_item_occurrence using brin (lesson_date);

-- ── core.schedule_item_change (trigger SCD2, term-partitioned) ────────────────
create table if not exists core.schedule_item_change (
  id              bigint generated always as identity,
  organization_id text not null,
  term_id         int  not null,
  source_uid      text not null,
  lesson_date     date,
  change_kind     text not null,                    -- add|cancel|move|room|teacher|update
  old_value       jsonb not null default '{}'::jsonb,
  new_value       jsonb not null default '{}'::jsonb,
  detected_at     timestamptz not null default now(),
  primary key (id, term_id),
  constraint schedule_item_change_kind_valid
    check (change_kind in ('add','cancel','move','room','teacher','update'))
) partition by list (term_id);

create table if not exists core.schedule_item_change_2025a partition of core.schedule_item_change for values in (20252);
create table if not exists core.schedule_item_change_2026s partition of core.schedule_item_change for values in (20261);
create table if not exists core.schedule_item_change_default partition of core.schedule_item_change default;
create index if not exists schedule_item_change_org_term_idx on core.schedule_item_change (organization_id, term_id, detected_at desc);
create index if not exists schedule_item_change_uid_idx on core.schedule_item_change (source_uid);

-- ── change-capture trigger (guarded against backfill noise) ───────────────────
create or replace function core.capture_schedule_item_change()
returns trigger language plpgsql security definer set search_path = '' as $$
declare
  v_term core.term%rowtype;
  v_kind text;
begin
  if tg_op = 'DELETE' then
    select * into v_term from core.term where id = old.term_id;
    if v_term.changes_active then
      insert into core.schedule_item_change(organization_id, term_id, source_uid, lesson_date, change_kind, old_value, new_value)
      values (old.organization_id, old.term_id, old.source_uid, old.first_date, 'cancel', to_jsonb(old), '{}'::jsonb);
    end if;
    return old;
  end if;

  select * into v_term from core.term where id = new.term_id;
  if not v_term.changes_active then
    return new;  -- initial backfill: establish baseline silently
  end if;

  if tg_op = 'INSERT' then
    v_kind := 'add';
  else
    -- classify the dominant change (time > room > teacher > generic)
    v_kind := case
      when old.start_time is distinct from new.start_time
        or old.dates is distinct from new.dates then 'move'
      else 'update'
    end;
  end if;

  insert into core.schedule_item_change(organization_id, term_id, source_uid, lesson_date, change_kind, old_value, new_value)
  values (new.organization_id, new.term_id, new.source_uid, new.first_date, v_kind,
          case when tg_op = 'INSERT' then '{}'::jsonb else to_jsonb(old) end, to_jsonb(new));
  return new;
end; $$;

create trigger schedule_item_change_ins_del
  after insert or delete on core.schedule_item
  for each row execute function core.capture_schedule_item_change();

create trigger schedule_item_change_upd
  after update on core.schedule_item
  for each row
  when (old.content_hash is distinct from new.content_hash or old.dates is distinct from new.dates)
  execute function core.capture_schedule_item_change();

-- ── RLS (schedule data is public-read; writes are service-role only) ──────────
do $$
declare t text;
begin
  foreach t in array array[
    'term','schedule_item','schedule_item_group','schedule_item_teacher',
    'schedule_item_classroom','schedule_item_occurrence','schedule_item_change'
  ] loop
    execute format('alter table core.%I enable row level security', t);
    execute format($f$create policy %I on core.%I for select to anon, authenticated using (true)$f$,
                   t || '_public_read', t);
    execute format('grant select on core.%I to anon, authenticated', t);
    execute format('grant all on core.%I to service_role', t);
  end loop;
end $$;
