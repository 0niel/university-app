-- Relational schedule layer over the existing target/payload contract.
--
-- This keeps app_api_v1.get_schedule_for_target compatible, while allowing
-- exact filters by group, teacher, classroom, campus and date range.

create or replace function ingest_v1.normalize_schedule_text(p_value text)
returns text
language sql
immutable
set search_path = ''
as $$
  select nullif(
    lower(regexp_replace(trim(coalesce(p_value, '')), '\s+', ' ', 'g')),
    ''
  );
$$;

create or replace function ingest_v1.schedule_identity_key(
  p_external_id text,
  p_fingerprint text
)
returns text
language sql
immutable
set search_path = ''
as $$
  select case
    when nullif(trim(coalesce(p_external_id, '')), '') is not null
      then 'source:' || trim(p_external_id)
    else 'synthetic:' || p_fingerprint
  end;
$$;

alter table core.schedule_parts
drop constraint if exists schedule_parts_type_valid;

alter table core.schedule_parts
add constraint schedule_parts_type_valid check (
  part_type in (
    'lesson',
    'holiday',
    'event',
    'exam',
    'deadline',
    'note',
    'custom',
    'unknown'
  )
);

create table core.schedule_groups (
  id uuid primary key default extensions.gen_random_uuid(),
  institution_id text not null references core.institutions(id) on delete cascade,
  external_id text,
  name text not null,
  normalized_name text not null,
  identity_key text not null,
  identity_confidence text not null default 'synthetic',
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint schedule_groups_name_not_empty check (length(trim(name)) > 0),
  constraint schedule_groups_identity_confidence_valid check (
    identity_confidence in ('source', 'synthetic', 'manual')
  ),
  constraint schedule_groups_unique_identity unique (institution_id, identity_key)
);

create table core.schedule_teachers (
  id uuid primary key default extensions.gen_random_uuid(),
  institution_id text not null references core.institutions(id) on delete cascade,
  external_id text,
  full_name text not null,
  normalized_name text not null,
  identity_key text not null,
  identity_confidence text not null default 'synthetic',
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint schedule_teachers_name_not_empty check (length(trim(full_name)) > 0),
  constraint schedule_teachers_identity_confidence_valid check (
    identity_confidence in ('source', 'synthetic', 'manual')
  ),
  constraint schedule_teachers_unique_identity unique (institution_id, identity_key)
);

create table core.schedule_campuses (
  id uuid primary key default extensions.gen_random_uuid(),
  institution_id text not null references core.institutions(id) on delete cascade,
  external_id text,
  name text not null,
  short_name text,
  normalized_name text not null,
  identity_key text not null,
  identity_confidence text not null default 'synthetic',
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint schedule_campuses_name_not_empty check (length(trim(name)) > 0),
  constraint schedule_campuses_identity_confidence_valid check (
    identity_confidence in ('source', 'synthetic', 'manual')
  ),
  constraint schedule_campuses_unique_identity unique (institution_id, identity_key)
);

create table core.schedule_classrooms (
  id uuid primary key default extensions.gen_random_uuid(),
  institution_id text not null references core.institutions(id) on delete cascade,
  external_id text,
  campus_id uuid references core.schedule_campuses(id) on delete set null,
  name text not null,
  normalized_name text not null,
  identity_key text not null,
  identity_confidence text not null default 'synthetic',
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint schedule_classrooms_name_not_empty check (length(trim(name)) > 0),
  constraint schedule_classrooms_identity_confidence_valid check (
    identity_confidence in ('source', 'synthetic', 'manual')
  ),
  constraint schedule_classrooms_unique_identity unique (institution_id, identity_key)
);

create table core.schedule_disciplines (
  id uuid primary key default extensions.gen_random_uuid(),
  institution_id text not null references core.institutions(id) on delete cascade,
  external_id text,
  name text not null,
  normalized_name text not null,
  identity_key text not null,
  identity_confidence text not null default 'synthetic',
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint schedule_disciplines_name_not_empty check (length(trim(name)) > 0),
  constraint schedule_disciplines_identity_confidence_valid check (
    identity_confidence in ('source', 'synthetic', 'manual')
  ),
  constraint schedule_disciplines_unique_identity unique (institution_id, identity_key)
);

alter table core.schedule_parts
add column if not exists discipline_id uuid references core.schedule_disciplines(id) on delete set null;

create table core.schedule_part_groups (
  schedule_part_id uuid not null references core.schedule_parts(id) on delete cascade,
  group_id uuid not null references core.schedule_groups(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (schedule_part_id, group_id)
);

create table core.schedule_part_teachers (
  schedule_part_id uuid not null references core.schedule_parts(id) on delete cascade,
  teacher_id uuid not null references core.schedule_teachers(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (schedule_part_id, teacher_id)
);

create table core.schedule_part_classrooms (
  schedule_part_id uuid not null references core.schedule_parts(id) on delete cascade,
  classroom_id uuid not null references core.schedule_classrooms(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (schedule_part_id, classroom_id)
);

create table core.schedule_occurrences (
  id uuid primary key default extensions.gen_random_uuid(),
  institution_id text not null references core.institutions(id) on delete cascade,
  target_id uuid not null references core.schedule_targets(id) on delete cascade,
  schedule_part_id uuid not null references core.schedule_parts(id) on delete cascade,
  discipline_id uuid references core.schedule_disciplines(id) on delete set null,
  lesson_date date not null,
  start_time time,
  end_time time,
  lesson_number integer,
  source_uid text,
  occurrence_key text not null,
  content_hash text not null,
  payload jsonb not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint schedule_occurrences_unique_part_date unique (
    schedule_part_id,
    lesson_date
  ),
  constraint schedule_occurrences_unique_key unique (
    target_id,
    occurrence_key
  )
);

create table core.schedule_occurrence_reactions (
  id uuid primary key default extensions.gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  occurrence_id uuid not null references core.schedule_occurrences(id) on delete cascade,
  reaction_type text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint schedule_occurrence_reactions_type_not_empty check (
    length(trim(reaction_type)) > 0
  ),
  constraint schedule_occurrence_reactions_unique_user unique (
    user_id,
    occurrence_id
  )
);

create index schedule_groups_search_idx
on core.schedule_groups using gin (name extensions.gin_trgm_ops);

create index schedule_teachers_search_idx
on core.schedule_teachers using gin (full_name extensions.gin_trgm_ops);

create index schedule_campuses_search_idx
on core.schedule_campuses using gin (name extensions.gin_trgm_ops);

create index schedule_classrooms_search_idx
on core.schedule_classrooms using gin (name extensions.gin_trgm_ops);

create index schedule_classrooms_campus_idx
on core.schedule_classrooms (campus_id);

create index schedule_disciplines_search_idx
on core.schedule_disciplines using gin (name extensions.gin_trgm_ops);

create index schedule_parts_discipline_idx
on core.schedule_parts (discipline_id);

create index schedule_part_groups_group_idx
on core.schedule_part_groups (group_id, schedule_part_id);

create index schedule_part_teachers_teacher_idx
on core.schedule_part_teachers (teacher_id, schedule_part_id);

create index schedule_part_classrooms_classroom_idx
on core.schedule_part_classrooms (classroom_id, schedule_part_id);

create index schedule_occurrences_target_date_idx
on core.schedule_occurrences (target_id, lesson_date, start_time);

create index schedule_occurrences_part_date_idx
on core.schedule_occurrences (schedule_part_id, lesson_date);

create index schedule_occurrences_institution_date_idx
on core.schedule_occurrences (institution_id, lesson_date, start_time);

create trigger set_schedule_groups_updated_at
before update on core.schedule_groups
for each row execute function core.set_updated_at();

create trigger set_schedule_teachers_updated_at
before update on core.schedule_teachers
for each row execute function core.set_updated_at();

create trigger set_schedule_campuses_updated_at
before update on core.schedule_campuses
for each row execute function core.set_updated_at();

create trigger set_schedule_classrooms_updated_at
before update on core.schedule_classrooms
for each row execute function core.set_updated_at();

create trigger set_schedule_disciplines_updated_at
before update on core.schedule_disciplines
for each row execute function core.set_updated_at();

create trigger set_schedule_occurrences_updated_at
before update on core.schedule_occurrences
for each row execute function core.set_updated_at();

create trigger set_schedule_occurrence_reactions_updated_at
before update on core.schedule_occurrence_reactions
for each row execute function core.set_updated_at();

create or replace function ingest_v1.upsert_schedule_group(
  p_institution_id text,
  p_name text,
  p_external_id text default null,
  p_metadata jsonb default '{}'::jsonb
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_id uuid;
  v_name text := nullif(trim(p_name), '');
  v_external_id text := nullif(trim(coalesce(p_external_id, '')), '');
  v_normalized_name text;
  v_identity_key text;
begin
  if v_name is null then
    return null;
  end if;

  v_normalized_name := ingest_v1.normalize_schedule_text(v_name);
  v_identity_key := ingest_v1.schedule_identity_key(
    v_external_id,
    md5(v_normalized_name)
  );

  insert into core.schedule_groups (
    institution_id,
    external_id,
    name,
    normalized_name,
    identity_key,
    identity_confidence,
    metadata
  )
  values (
    p_institution_id,
    v_external_id,
    v_name,
    v_normalized_name,
    v_identity_key,
    case when v_external_id is null then 'synthetic' else 'source' end,
    coalesce(p_metadata, '{}'::jsonb)
  )
  on conflict (institution_id, identity_key) do update
  set
    external_id = coalesce(excluded.external_id, core.schedule_groups.external_id),
    name = excluded.name,
    normalized_name = excluded.normalized_name,
    identity_confidence = case
      when excluded.external_id is not null then 'source'
      else core.schedule_groups.identity_confidence
    end,
    metadata = core.schedule_groups.metadata || excluded.metadata
  returning id into v_id;

  return v_id;
end;
$$;

create or replace function ingest_v1.upsert_schedule_teacher(
  p_institution_id text,
  p_name text,
  p_external_id text default null,
  p_metadata jsonb default '{}'::jsonb
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_id uuid;
  v_name text := nullif(trim(p_name), '');
  v_external_id text := nullif(trim(coalesce(p_external_id, '')), '');
  v_normalized_name text;
  v_identity_key text;
begin
  if v_name is null then
    return null;
  end if;

  v_normalized_name := ingest_v1.normalize_schedule_text(v_name);
  v_identity_key := ingest_v1.schedule_identity_key(
    v_external_id,
    md5(v_normalized_name)
  );

  insert into core.schedule_teachers (
    institution_id,
    external_id,
    full_name,
    normalized_name,
    identity_key,
    identity_confidence,
    metadata
  )
  values (
    p_institution_id,
    v_external_id,
    v_name,
    v_normalized_name,
    v_identity_key,
    case when v_external_id is null then 'synthetic' else 'source' end,
    coalesce(p_metadata, '{}'::jsonb)
  )
  on conflict (institution_id, identity_key) do update
  set
    external_id = coalesce(excluded.external_id, core.schedule_teachers.external_id),
    full_name = excluded.full_name,
    normalized_name = excluded.normalized_name,
    identity_confidence = case
      when excluded.external_id is not null then 'source'
      else core.schedule_teachers.identity_confidence
    end,
    metadata = core.schedule_teachers.metadata || excluded.metadata
  returning id into v_id;

  return v_id;
end;
$$;

create or replace function ingest_v1.upsert_schedule_campus(
  p_institution_id text,
  p_name text,
  p_short_name text default null,
  p_external_id text default null,
  p_metadata jsonb default '{}'::jsonb
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_id uuid;
  v_name text := nullif(trim(coalesce(p_name, p_short_name)), '');
  v_short_name text := nullif(trim(coalesce(p_short_name, '')), '');
  v_external_id text := nullif(trim(coalesce(p_external_id, '')), '');
  v_normalized_name text;
  v_identity_key text;
begin
  if v_name is null then
    return null;
  end if;

  v_normalized_name := ingest_v1.normalize_schedule_text(coalesce(v_short_name, v_name));
  v_identity_key := ingest_v1.schedule_identity_key(
    v_external_id,
    md5(v_normalized_name)
  );

  insert into core.schedule_campuses (
    institution_id,
    external_id,
    name,
    short_name,
    normalized_name,
    identity_key,
    identity_confidence,
    metadata
  )
  values (
    p_institution_id,
    v_external_id,
    v_name,
    v_short_name,
    v_normalized_name,
    v_identity_key,
    case when v_external_id is null then 'synthetic' else 'source' end,
    coalesce(p_metadata, '{}'::jsonb)
  )
  on conflict (institution_id, identity_key) do update
  set
    external_id = coalesce(excluded.external_id, core.schedule_campuses.external_id),
    name = excluded.name,
    short_name = coalesce(excluded.short_name, core.schedule_campuses.short_name),
    normalized_name = excluded.normalized_name,
    identity_confidence = case
      when excluded.external_id is not null then 'source'
      else core.schedule_campuses.identity_confidence
    end,
    metadata = core.schedule_campuses.metadata || excluded.metadata
  returning id into v_id;

  return v_id;
end;
$$;

create or replace function ingest_v1.upsert_schedule_classroom(
  p_institution_id text,
  p_name text,
  p_external_id text default null,
  p_campus_name text default null,
  p_campus_short_name text default null,
  p_campus_external_id text default null,
  p_metadata jsonb default '{}'::jsonb
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_id uuid;
  v_campus_id uuid;
  v_name text := nullif(trim(p_name), '');
  v_external_id text := nullif(trim(coalesce(p_external_id, '')), '');
  v_normalized_name text;
  v_identity_key text;
begin
  if v_name is null then
    return null;
  end if;

  v_campus_id := ingest_v1.upsert_schedule_campus(
    p_institution_id,
    p_campus_name,
    p_campus_short_name,
    p_campus_external_id,
    '{}'::jsonb
  );

  v_normalized_name := ingest_v1.normalize_schedule_text(v_name);
  v_identity_key := ingest_v1.schedule_identity_key(
    v_external_id,
    md5(v_normalized_name || ':' || coalesce(v_campus_id::text, ''))
  );

  insert into core.schedule_classrooms (
    institution_id,
    external_id,
    campus_id,
    name,
    normalized_name,
    identity_key,
    identity_confidence,
    metadata
  )
  values (
    p_institution_id,
    v_external_id,
    v_campus_id,
    v_name,
    v_normalized_name,
    v_identity_key,
    case when v_external_id is null then 'synthetic' else 'source' end,
    coalesce(p_metadata, '{}'::jsonb)
  )
  on conflict (institution_id, identity_key) do update
  set
    external_id = coalesce(excluded.external_id, core.schedule_classrooms.external_id),
    campus_id = coalesce(excluded.campus_id, core.schedule_classrooms.campus_id),
    name = excluded.name,
    normalized_name = excluded.normalized_name,
    identity_confidence = case
      when excluded.external_id is not null then 'source'
      else core.schedule_classrooms.identity_confidence
    end,
    metadata = core.schedule_classrooms.metadata || excluded.metadata
  returning id into v_id;

  return v_id;
end;
$$;

create or replace function ingest_v1.upsert_schedule_discipline(
  p_institution_id text,
  p_name text,
  p_external_id text default null,
  p_metadata jsonb default '{}'::jsonb
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_id uuid;
  v_name text := nullif(trim(p_name), '');
  v_external_id text := nullif(trim(coalesce(p_external_id, '')), '');
  v_normalized_name text;
  v_identity_key text;
begin
  if v_name is null then
    return null;
  end if;

  v_normalized_name := ingest_v1.normalize_schedule_text(v_name);
  v_identity_key := ingest_v1.schedule_identity_key(
    v_external_id,
    md5(v_normalized_name)
  );

  insert into core.schedule_disciplines (
    institution_id,
    external_id,
    name,
    normalized_name,
    identity_key,
    identity_confidence,
    metadata
  )
  values (
    p_institution_id,
    v_external_id,
    v_name,
    v_normalized_name,
    v_identity_key,
    case when v_external_id is null then 'synthetic' else 'source' end,
    coalesce(p_metadata, '{}'::jsonb)
  )
  on conflict (institution_id, identity_key) do update
  set
    external_id = coalesce(excluded.external_id, core.schedule_disciplines.external_id),
    name = excluded.name,
    normalized_name = excluded.normalized_name,
    identity_confidence = case
      when excluded.external_id is not null then 'source'
      else core.schedule_disciplines.identity_confidence
    end,
    metadata = core.schedule_disciplines.metadata || excluded.metadata
  returning id into v_id;

  return v_id;
end;
$$;

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
  v_institution_name text := coalesce(
    nullif(trim(p_source ->> 'institution_name'), ''),
    p_institution_id
  );
  v_target_type text;
  v_external_id text;
  v_target_title text;
  v_full_title text;
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
  set
    name = excluded.name,
    timezone = excluded.timezone,
    metadata = core.institutions.metadata || excluded.metadata;

  for v_target in
    select value from jsonb_array_elements(p_targets) as target(value)
  loop
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

    insert into core.schedule_targets (
      institution_id,
      target_type,
      external_id,
      target_title,
      full_title,
      ical_url,
      schedule_image_url,
      schedule_update_image_url,
      ui_url,
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
      coalesce(v_target ->> 'ical_url', v_target ->> 'iCalLink'),
      coalesce(v_target ->> 'schedule_image_url', v_target ->> 'scheduleImageLink'),
      coalesce(v_target ->> 'schedule_update_image_url', v_target ->> 'scheduleUpdateImageLink'),
      coalesce(v_target ->> 'ui_url', v_target ->> 'scheduleUIAddToCalendarLink'),
      nullif(coalesce(v_target ->> 'hash_version', v_target ->> 'hashVersion'), '')::integer,
      nullif(trim(coalesce(v_target ->> 'hash', v_target ->> 'current_hash', '')), ''),
      coalesce((v_target ->> 'is_active')::boolean, true),
      now(),
      coalesce(v_target -> 'metadata', '{}'::jsonb)
    )
    on conflict (institution_id, target_type, external_id) do update
    set
      target_title = excluded.target_title,
      full_title = excluded.full_title,
      ical_url = excluded.ical_url,
      schedule_image_url = excluded.schedule_image_url,
      schedule_update_image_url = excluded.schedule_update_image_url,
      ui_url = excluded.ui_url,
      current_hash_version = excluded.current_hash_version,
      current_hash = excluded.current_hash,
      is_active = excluded.is_active,
      last_synced_at = excluded.last_synced_at,
      metadata = core.schedule_targets.metadata || excluded.metadata
    returning id into v_target_id;

    v_targets_upserted := v_targets_upserted + 1;
    v_full_replace := coalesce((v_target ->> 'full_replace')::boolean, true);

    if v_full_replace then
      delete from core.schedule_parts
      where target_id = v_target_id;
    end if;

    if jsonb_typeof(v_target -> 'parts') is distinct from 'array' then
      continue;
    end if;

    for v_part in
      select value from jsonb_array_elements(v_target -> 'parts') as part(value)
    loop
      v_part_type := case
        when coalesce(v_part ->> 'part_type', v_part ->> 'type') in ('lesson', '__lesson_schedule__')
          then 'lesson'
        when coalesce(v_part ->> 'part_type', v_part ->> 'type') in ('holiday', '__holiday__')
          then 'holiday'
        when coalesce(v_part ->> 'part_type', v_part ->> 'type') in ('event', 'exam', 'deadline', 'note', 'custom')
          then coalesce(v_part ->> 'part_type', v_part ->> 'type')
        else 'unknown'
      end;

      v_dates := array[]::date[];
      if jsonb_typeof(v_part -> 'dates') = 'array' then
        for v_date_value in
          select value from jsonb_array_elements(v_part -> 'dates') as date_value(value)
        loop
          v_date := ingest_v1.parse_schedule_date(
            trim(both '"' from v_date_value::text)
          );

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

      v_lesson_bells := coalesce(
        v_part -> 'lesson_bells',
        v_part -> 'lessonBells',
        '{}'::jsonb
      );
      v_teachers := coalesce(v_part -> 'teachers', '[]'::jsonb);
      v_classrooms := coalesce(v_part -> 'classrooms', '[]'::jsonb);
      v_group_entities := coalesce(
        v_part -> 'group_entities',
        v_part -> 'groupEntities',
        '[]'::jsonb
      );

      if jsonb_typeof(v_teachers) is distinct from 'array' then
        v_teachers := '[]'::jsonb;
      end if;
      if jsonb_typeof(v_classrooms) is distinct from 'array' then
        v_classrooms := '[]'::jsonb;
      end if;
      if jsonb_typeof(v_group_entities) is distinct from 'array' then
        v_group_entities := '[]'::jsonb;
      end if;

      select coalesce(array_agg(value), '{}'::text[])
      into v_groups
      from jsonb_array_elements_text(coalesce(v_part -> 'groups', '[]'::jsonb)) as groups(value);

      v_source_uid := nullif(trim(coalesce(v_part ->> 'uid', v_part ->> 'external_id', '')), '');
      v_subject := coalesce(
        nullif(trim(v_part ->> 'subject'), ''),
        nullif(trim(v_part ->> 'title'), '')
      );
      v_discipline_id := ingest_v1.upsert_schedule_discipline(
        p_institution_id,
        v_subject,
        null,
        '{}'::jsonb
      );

      v_part_external_id := coalesce(
        v_source_uid,
        md5(
          v_target_id::text
          || ':'
          || coalesce(v_part ->> 'type', '')
          || ':'
          || coalesce(v_subject, '')
          || ':'
          || coalesce(v_lesson_bells ->> 'number', '')
          || ':'
          || coalesce(v_lesson_bells ->> 'startTime', v_lesson_bells ->> 'start_time', '')
          || ':'
          || coalesce(v_lesson_bells ->> 'endTime', v_lesson_bells ->> 'end_time', '')
          || ':'
          || array_to_string(v_dates, ',')
          || ':'
          || v_teachers::text
          || ':'
          || v_classrooms::text
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
      set
        discipline_id = excluded.discipline_id,
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

      delete from core.schedule_part_dates
      where schedule_part_id = v_part_id;
      delete from core.schedule_part_groups
      where schedule_part_id = v_part_id;
      delete from core.schedule_part_teachers
      where schedule_part_id = v_part_id;
      delete from core.schedule_part_classrooms
      where schedule_part_id = v_part_id;
      delete from core.schedule_occurrences
      where schedule_part_id = v_part_id;

      foreach v_date in array v_dates loop
        insert into core.schedule_part_dates (
          institution_id,
          target_id,
          schedule_part_id,
          lesson_date
        )
        values (
          p_institution_id,
          v_target_id,
          v_part_id,
          v_date
        )
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
        set
          discipline_id = excluded.discipline_id,
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
        for v_group_entity in
          select value from jsonb_array_elements(v_group_entities) as entity(value)
        loop
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
          v_group_id := ingest_v1.upsert_schedule_group(
            p_institution_id,
            v_group_name,
            null,
            '{}'::jsonb
          );
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

      for v_teacher_entity in
        select value from jsonb_array_elements(v_teachers) as entity(value)
      loop
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

      for v_classroom_entity in
        select value from jsonb_array_elements(v_classrooms) as entity(value)
      loop
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

create or replace function app_api_v1.search_schedule_entities(
  p_entity_type text,
  p_query text default '',
  p_institution_id text default null,
  p_limit integer default 20
)
returns table (
  entity_type text,
  id uuid,
  external_id text,
  title text,
  subtitle text
)
language sql
stable
set search_path = ''
as $$
  with params as (
    select
      nullif(trim(coalesce(p_query, '')), '') as query,
      least(greatest(coalesce(p_limit, 20), 1), 100) as result_limit
  ),
  rows as (
    select
      'group'::text as entity_type,
      g.id,
      g.external_id,
      g.name as title,
      null::text as subtitle
    from core.schedule_groups g, params p
    where p_entity_type = 'group'
      and (p_institution_id is null or g.institution_id = p_institution_id)
      and (
        p.query is null
        or g.name ilike '%' || p.query || '%'
        or g.external_id = p.query
      )
    union all
    select
      'teacher'::text,
      t.id,
      t.external_id,
      t.full_name,
      null::text
    from core.schedule_teachers t, params p
    where p_entity_type = 'teacher'
      and (p_institution_id is null or t.institution_id = p_institution_id)
      and (
        p.query is null
        or t.full_name ilike '%' || p.query || '%'
        or t.external_id = p.query
      )
    union all
    select
      'classroom'::text,
      c.id,
      c.external_id,
      c.name,
      coalesce(campus.short_name, campus.name)
    from core.schedule_classrooms c
    left join core.schedule_campuses campus on campus.id = c.campus_id,
      params p
    where p_entity_type = 'classroom'
      and (p_institution_id is null or c.institution_id = p_institution_id)
      and (
        p.query is null
        or c.name ilike '%' || p.query || '%'
        or c.external_id = p.query
      )
    union all
    select
      'campus'::text,
      campus.id,
      campus.external_id,
      campus.name,
      campus.short_name
    from core.schedule_campuses campus, params p
    where p_entity_type = 'campus'
      and (p_institution_id is null or campus.institution_id = p_institution_id)
      and (
        p.query is null
        or campus.name ilike '%' || p.query || '%'
        or campus.short_name ilike '%' || p.query || '%'
        or campus.external_id = p.query
      )
  )
  select rows.*
  from rows, params p
  order by
    case
      when p.query is not null and lower(rows.title) = lower(p.query) then 0
      when p.query is not null and rows.title ilike p.query || '%' then 1
      else 2
    end,
    rows.title
  limit (select result_limit from params);
$$;

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
  with matched_parts as (
    select distinct sp.id
    from core.schedule_parts sp
    where (p_institution_id is null or sp.institution_id = p_institution_id)
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
  dates as (
    select
      so.schedule_part_id,
      jsonb_agg(to_char(so.lesson_date, 'DD-MM-YYYY') order by so.lesson_date) as dates,
      min(so.lesson_date) as first_date
    from core.schedule_occurrences so
    join matched_parts mp on mp.id = so.schedule_part_id
    where (p_date_from is null or so.lesson_date >= p_date_from)
      and (p_date_to is null or so.lesson_date <= p_date_to)
    group by so.schedule_part_id
  ),
  parts as (
    select
      sp.id,
      d.first_date,
      sp.start_time,
      sp.lesson_number,
      sp.payload,
      d.dates
    from core.schedule_parts sp
    join dates d on d.schedule_part_id = sp.id
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

create or replace function public.search_schedule_entities(
  p_entity_type text,
  p_query text default '',
  p_institution_id text default null,
  p_limit integer default 20
)
returns table (
  entity_type text,
  id uuid,
  external_id text,
  title text,
  subtitle text
)
language sql
stable
set search_path = ''
as $$
  select *
  from app_api_v1.search_schedule_entities(
    p_entity_type,
    p_query,
    p_institution_id,
    p_limit
  );
$$;

create or replace function public.get_schedule_for_entity(
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
  select app_api_v1.get_schedule_for_entity(
    p_entity_type,
    p_entity,
    p_date_from,
    p_date_to,
    p_institution_id
  );
$$;

alter table core.schedule_groups enable row level security;
alter table core.schedule_teachers enable row level security;
alter table core.schedule_campuses enable row level security;
alter table core.schedule_classrooms enable row level security;
alter table core.schedule_disciplines enable row level security;
alter table core.schedule_part_groups enable row level security;
alter table core.schedule_part_teachers enable row level security;
alter table core.schedule_part_classrooms enable row level security;
alter table core.schedule_occurrences enable row level security;
alter table core.schedule_occurrence_reactions enable row level security;

create policy "Public can read schedule groups"
on core.schedule_groups
for select
to anon, authenticated
using (true);

create policy "Public can read schedule teachers"
on core.schedule_teachers
for select
to anon, authenticated
using (true);

create policy "Public can read schedule campuses"
on core.schedule_campuses
for select
to anon, authenticated
using (true);

create policy "Public can read schedule classrooms"
on core.schedule_classrooms
for select
to anon, authenticated
using (true);

create policy "Public can read schedule disciplines"
on core.schedule_disciplines
for select
to anon, authenticated
using (true);

create policy "Public can read schedule part groups"
on core.schedule_part_groups
for select
to anon, authenticated
using (true);

create policy "Public can read schedule part teachers"
on core.schedule_part_teachers
for select
to anon, authenticated
using (true);

create policy "Public can read schedule part classrooms"
on core.schedule_part_classrooms
for select
to anon, authenticated
using (true);

create policy "Public can read schedule occurrences"
on core.schedule_occurrences
for select
to anon, authenticated
using (true);

create policy "Users can read own occurrence reactions"
on core.schedule_occurrence_reactions
for select
to authenticated
using ((select auth.uid()) = user_id);

create policy "Users can insert own occurrence reactions"
on core.schedule_occurrence_reactions
for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "Users can update own occurrence reactions"
on core.schedule_occurrence_reactions
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "Users can delete own occurrence reactions"
on core.schedule_occurrence_reactions
for delete
to authenticated
using ((select auth.uid()) = user_id);

grant select on core.schedule_groups to anon, authenticated;
grant select on core.schedule_teachers to anon, authenticated;
grant select on core.schedule_campuses to anon, authenticated;
grant select on core.schedule_classrooms to anon, authenticated;
grant select on core.schedule_disciplines to anon, authenticated;
grant select on core.schedule_part_groups to anon, authenticated;
grant select on core.schedule_part_teachers to anon, authenticated;
grant select on core.schedule_part_classrooms to anon, authenticated;
grant select on core.schedule_occurrences to anon, authenticated;
grant select, insert, update, delete on core.schedule_occurrence_reactions
to authenticated;

grant all on core.schedule_groups to service_role;
grant all on core.schedule_teachers to service_role;
grant all on core.schedule_campuses to service_role;
grant all on core.schedule_classrooms to service_role;
grant all on core.schedule_disciplines to service_role;
grant all on core.schedule_part_groups to service_role;
grant all on core.schedule_part_teachers to service_role;
grant all on core.schedule_part_classrooms to service_role;
grant all on core.schedule_occurrences to service_role;
grant all on core.schedule_occurrence_reactions to service_role;

revoke execute on function ingest_v1.normalize_schedule_text(text)
from public;
revoke execute on function ingest_v1.schedule_identity_key(text, text)
from public;
revoke execute on function ingest_v1.upsert_schedule_group(text, text, text, jsonb)
from public;
revoke execute on function ingest_v1.upsert_schedule_teacher(text, text, text, jsonb)
from public;
revoke execute on function ingest_v1.upsert_schedule_campus(text, text, text, text, jsonb)
from public;
revoke execute on function ingest_v1.upsert_schedule_classroom(text, text, text, text, text, text, jsonb)
from public;
revoke execute on function ingest_v1.upsert_schedule_discipline(text, text, text, jsonb)
from public;

grant execute on function ingest_v1.normalize_schedule_text(text)
to service_role;
grant execute on function ingest_v1.schedule_identity_key(text, text)
to service_role;
grant execute on function ingest_v1.upsert_schedule_group(text, text, text, jsonb)
to service_role;
grant execute on function ingest_v1.upsert_schedule_teacher(text, text, text, jsonb)
to service_role;
grant execute on function ingest_v1.upsert_schedule_campus(text, text, text, text, jsonb)
to service_role;
grant execute on function ingest_v1.upsert_schedule_classroom(text, text, text, text, text, text, jsonb)
to service_role;
grant execute on function ingest_v1.upsert_schedule_discipline(text, text, text, jsonb)
to service_role;

grant execute on function app_api_v1.search_schedule_entities(text, text, text, integer)
to anon, authenticated, service_role;
grant execute on function app_api_v1.get_schedule_for_entity(text, text, date, date, text)
to anon, authenticated, service_role;

revoke all on function public.search_schedule_entities(text, text, text, integer)
from public;
grant execute on function public.search_schedule_entities(text, text, text, integer)
to anon, authenticated, service_role;

revoke all on function public.get_schedule_for_entity(text, text, date, date, text)
from public;
grant execute on function public.get_schedule_for_entity(text, text, date, date, text)
to anon, authenticated, service_role;
