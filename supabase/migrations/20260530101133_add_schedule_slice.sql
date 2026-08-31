-- Supabase-first schedule slice.
--
-- The first schedule version is target-based on purpose:
-- - search targets mirror the university schedule API
-- - schedule parts keep the current Flutter domain JSON contract
-- - later migrations can add fully normalized lesson entities without breaking
--   app_api_v1 or ingest_v1

create extension if not exists pg_trgm with schema extensions;

create table core.schedule_targets (
  id uuid primary key default extensions.gen_random_uuid(),
  institution_id text not null references core.institutions(id) on delete cascade,
  target_type text not null,
  external_id text not null,
  target_title text not null,
  full_title text not null,
  ical_url text,
  schedule_image_url text,
  schedule_update_image_url text,
  ui_url text,
  current_hash_version integer,
  current_hash text,
  is_active boolean not null default true,
  last_synced_at timestamptz,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint schedule_targets_type_valid check (
    target_type in ('group', 'teacher', 'classroom')
  ),
  constraint schedule_targets_external_id_not_empty check (
    length(trim(external_id)) > 0
  ),
  constraint schedule_targets_target_title_not_empty check (
    length(trim(target_title)) > 0
  ),
  constraint schedule_targets_unique_external unique (
    institution_id,
    target_type,
    external_id
  )
);

create index schedule_targets_lookup_idx
on core.schedule_targets (institution_id, target_type, external_id);

create index schedule_targets_active_idx
on core.schedule_targets (institution_id, target_type, is_active);

create index schedule_targets_title_trgm_idx
on core.schedule_targets using gin (target_title extensions.gin_trgm_ops);

create index schedule_targets_full_title_trgm_idx
on core.schedule_targets using gin (full_title extensions.gin_trgm_ops);

create trigger set_schedule_targets_updated_at
before update on core.schedule_targets
for each row execute function core.set_updated_at();

create table core.schedule_parts (
  id uuid primary key default extensions.gen_random_uuid(),
  institution_id text not null references core.institutions(id) on delete cascade,
  target_id uuid not null references core.schedule_targets(id) on delete cascade,
  part_type text not null,
  external_id text not null,
  subject text,
  title text,
  lesson_type text,
  lesson_number integer,
  start_time time,
  end_time time,
  teachers jsonb not null default '[]'::jsonb,
  classrooms jsonb not null default '[]'::jsonb,
  groups text[] not null default '{}'::text[],
  payload jsonb not null,
  raw_data jsonb not null default '{}'::jsonb,
  content_hash text not null,
  first_date date,
  last_date date,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint schedule_parts_type_valid check (
    part_type in ('lesson', 'holiday', 'unknown')
  ),
  constraint schedule_parts_external_id_not_empty check (
    length(trim(external_id)) > 0
  ),
  constraint schedule_parts_teachers_is_array check (
    jsonb_typeof(teachers) = 'array'
  ),
  constraint schedule_parts_classrooms_is_array check (
    jsonb_typeof(classrooms) = 'array'
  ),
  constraint schedule_parts_payload_is_object check (
    jsonb_typeof(payload) = 'object'
  ),
  constraint schedule_parts_unique_external unique (target_id, external_id)
);

create index schedule_parts_target_order_idx
on core.schedule_parts (target_id, first_date, start_time, lesson_number);

create index schedule_parts_institution_date_idx
on core.schedule_parts (institution_id, first_date, last_date);

create index schedule_parts_groups_gin_idx
on core.schedule_parts using gin (groups);

create trigger set_schedule_parts_updated_at
before update on core.schedule_parts
for each row execute function core.set_updated_at();

create table core.schedule_part_dates (
  id uuid primary key default extensions.gen_random_uuid(),
  institution_id text not null references core.institutions(id) on delete cascade,
  target_id uuid not null references core.schedule_targets(id) on delete cascade,
  schedule_part_id uuid not null references core.schedule_parts(id) on delete cascade,
  lesson_date date not null,
  created_at timestamptz not null default now(),
  constraint schedule_part_dates_unique unique (schedule_part_id, lesson_date)
);

create index schedule_part_dates_target_date_idx
on core.schedule_part_dates (target_id, lesson_date);

create index schedule_part_dates_institution_date_idx
on core.schedule_part_dates (institution_id, lesson_date);

create table core.lesson_reactions (
  id uuid primary key default extensions.gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  subject_name text not null,
  lesson_date date not null,
  lesson_bells_number integer not null,
  reaction_type text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint lesson_reactions_subject_not_empty check (
    length(trim(subject_name)) > 0
  ),
  constraint lesson_reactions_lesson_bells_number_positive check (
    lesson_bells_number > 0
  ),
  constraint lesson_reactions_reaction_type_not_empty check (
    length(trim(reaction_type)) > 0
  ),
  constraint lesson_reactions_unique_user_lesson unique (
    user_id,
    subject_name,
    lesson_date,
    lesson_bells_number
  )
);

create index lesson_reactions_lesson_idx
on core.lesson_reactions (subject_name, lesson_date, lesson_bells_number);

create trigger set_lesson_reactions_updated_at
before update on core.lesson_reactions
for each row execute function core.set_updated_at();

alter table core.schedule_targets enable row level security;
alter table core.schedule_parts enable row level security;
alter table core.schedule_part_dates enable row level security;
alter table core.lesson_reactions enable row level security;

create policy "public can read active schedule targets"
on core.schedule_targets
for select
to anon, authenticated
using (is_active);

create policy "public can read active-target schedule parts"
on core.schedule_parts
for select
to anon, authenticated
using (
  exists (
    select 1
    from core.schedule_targets st
    where st.id = schedule_parts.target_id
      and st.is_active
  )
);

create policy "public can read active-target schedule dates"
on core.schedule_part_dates
for select
to anon, authenticated
using (
  exists (
    select 1
    from core.schedule_targets st
    where st.id = schedule_part_dates.target_id
      and st.is_active
  )
);

create policy "public can read lesson reactions"
on core.lesson_reactions
for select
to anon, authenticated
using (true);

create policy "users can insert own lesson reactions"
on core.lesson_reactions
for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "users can update own lesson reactions"
on core.lesson_reactions
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "users can delete own lesson reactions"
on core.lesson_reactions
for delete
to authenticated
using ((select auth.uid()) = user_id);

grant select on core.schedule_targets to anon, authenticated;
grant select on core.schedule_parts to anon, authenticated;
grant select on core.schedule_part_dates to anon, authenticated;
grant select, insert, update, delete on core.lesson_reactions to authenticated;
grant select on core.lesson_reactions to anon;
grant all on core.schedule_targets to service_role;
grant all on core.schedule_parts to service_role;
grant all on core.schedule_part_dates to service_role;
grant all on core.lesson_reactions to service_role;

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
  ical_url text
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
    st.ical_url
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
          to_char(spd.lesson_date, 'YYYY-MM-DD"T"00:00:00.000')
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

create or replace function app_api_v1.get_lesson_reactions(
  p_subject_name text,
  p_lesson_date date,
  p_lesson_bells_number integer
)
returns jsonb
language sql
stable
set search_path = ''
as $$
  with rows as (
    select lr.reaction_type, lr.user_id
    from core.lesson_reactions lr
    where lr.subject_name = p_subject_name
      and lr.lesson_date = p_lesson_date
      and lr.lesson_bells_number = p_lesson_bells_number
  ),
  counts as (
    select coalesce(jsonb_object_agg(reaction_type, count), '{}'::jsonb) as data
    from (
      select reaction_type, count(*)::int as count
      from rows
      group by reaction_type
    ) grouped
  )
  select jsonb_build_object(
    'counts', (select data from counts),
    'userReaction', (
      select reaction_type
      from rows
      where user_id = (select auth.uid())
      limit 1
    )
  );
$$;

create or replace function app_api_v1.upsert_lesson_reaction(
  p_subject_name text,
  p_lesson_date date,
  p_lesson_bells_number integer,
  p_reaction_type text
)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;

  insert into core.lesson_reactions (
    user_id,
    subject_name,
    lesson_date,
    lesson_bells_number,
    reaction_type
  )
  values (
    v_user_id,
    p_subject_name,
    p_lesson_date,
    p_lesson_bells_number,
    p_reaction_type
  )
  on conflict (
    user_id,
    subject_name,
    lesson_date,
    lesson_bells_number
  ) do update
  set reaction_type = excluded.reaction_type;

  return app_api_v1.get_lesson_reactions(
    p_subject_name,
    p_lesson_date,
    p_lesson_bells_number
  );
end;
$$;

create or replace function app_api_v1.delete_lesson_reaction(
  p_subject_name text,
  p_lesson_date date,
  p_lesson_bells_number integer
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;

  delete from core.lesson_reactions lr
  where lr.user_id = v_user_id
    and lr.subject_name = p_subject_name
    and lr.lesson_date = p_lesson_date
    and lr.lesson_bells_number = p_lesson_bells_number;
end;
$$;

create or replace function ingest_v1.normalize_schedule_target_type(
  p_target jsonb
)
returns text
language sql
immutable
set search_path = ''
as $$
  select case
    when p_target ->> 'target_type' in ('group', 'teacher', 'classroom')
      then p_target ->> 'target_type'
    when p_target ->> 'type' in ('group', 'teacher', 'classroom')
      then p_target ->> 'type'
    when p_target ->> 'scheduleTarget' = '1'
      or p_target ->> 'schedule_target' = '1'
      then 'group'
    when p_target ->> 'scheduleTarget' = '2'
      or p_target ->> 'schedule_target' = '2'
      then 'teacher'
    when p_target ->> 'scheduleTarget' = '3'
      or p_target ->> 'schedule_target' = '3'
      then 'classroom'
    else null
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
  v_dates date[];
  v_date date;
  v_lesson_bells jsonb;
  v_teachers jsonb;
  v_classrooms jsonb;
  v_groups text[];
  v_received integer := 0;
  v_targets_upserted integer := 0;
  v_parts_upserted integer := 0;
  v_skipped integer := 0;
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
      v_skipped := v_skipped + 1;
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
        else 'unknown'
      end;

      v_dates := array[]::date[];
      if jsonb_typeof(v_part -> 'dates') = 'array' then
        for v_date_value in
          select value from jsonb_array_elements(v_part -> 'dates') as date_value(value)
        loop
          begin
            v_dates := array_append(
              v_dates,
              (trim(both '"' from v_date_value::text)::timestamptz)::date
            );
          exception when others then
            v_skipped := v_skipped + 1;
          end;
        end loop;
      end if;

      if coalesce(array_length(v_dates, 1), 0) = 0 then
        v_skipped := v_skipped + 1;
        continue;
      end if;

      v_lesson_bells := coalesce(
        v_part -> 'lesson_bells',
        v_part -> 'lessonBells',
        '{}'::jsonb
      );
      v_teachers := coalesce(v_part -> 'teachers', '[]'::jsonb);
      v_classrooms := coalesce(v_part -> 'classrooms', '[]'::jsonb);

      select coalesce(array_agg(value), '{}'::text[])
      into v_groups
      from jsonb_array_elements_text(coalesce(v_part -> 'groups', '[]'::jsonb)) as groups(value);

      v_part_external_id := coalesce(
        nullif(trim(v_part ->> 'external_id'), ''),
        md5(
          v_target_id::text
          || ':'
          || coalesce(v_part ->> 'type', '')
          || ':'
          || coalesce(v_part ->> 'subject', v_part ->> 'title', '')
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
      end loop;

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
      coalesce(nullif(trim(p_source ->> 'source_external_id'), ''), v_target_type),
      'schedule_target',
      v_target_type || ':' || v_external_id,
      v_target
    );
  end loop;

  if p_sync_run_id is not null then
    update internal.sync_runs
    set
      items_received = v_received,
      items_upserted = v_parts_upserted,
      items_skipped = v_skipped,
      status = case when v_skipped = 0 then 'succeeded' else 'partial' end,
      finished_at = now()
    where id = p_sync_run_id;
  end if;

  return jsonb_build_object(
    'institution_id', p_institution_id,
    'targets_received', v_received,
    'targets_upserted', v_targets_upserted,
    'parts_upserted', v_parts_upserted,
    'items_skipped', v_skipped
  );
end;
$$;

grant execute on function app_api_v1.search_schedule_targets(text, text, text, integer)
to anon, authenticated, service_role;
grant execute on function app_api_v1.get_schedule_for_target(text, text, text)
to anon, authenticated, service_role;
grant execute on function app_api_v1.get_lesson_reactions(text, date, integer)
to anon, authenticated, service_role;
grant execute on function app_api_v1.upsert_lesson_reaction(text, date, integer, text)
to authenticated, service_role;
grant execute on function app_api_v1.delete_lesson_reaction(text, date, integer)
to authenticated, service_role;

revoke execute on function ingest_v1.normalize_schedule_target_type(jsonb)
from public;
grant execute on function ingest_v1.normalize_schedule_target_type(jsonb)
to service_role;
revoke execute on function ingest_v1.upsert_schedule_payload(text, jsonb, jsonb, uuid)
from public;
grant execute on function ingest_v1.upsert_schedule_payload(text, jsonb, jsonb, uuid)
to service_role;

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
  ical_url text
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

create or replace function public.get_schedule_for_target(
  p_target_type text,
  p_target text,
  p_institution_id text default null
)
returns jsonb
language sql
stable
set search_path = ''
as $$
  select app_api_v1.get_schedule_for_target(
    p_target_type,
    p_target,
    p_institution_id
  );
$$;

create or replace function public.get_lesson_reactions(
  p_subject_name text,
  p_lesson_date date,
  p_lesson_bells_number integer
)
returns jsonb
language sql
stable
set search_path = ''
as $$
  select app_api_v1.get_lesson_reactions(
    p_subject_name,
    p_lesson_date,
    p_lesson_bells_number
  );
$$;

create or replace function public.upsert_lesson_reaction(
  p_subject_name text,
  p_lesson_date date,
  p_lesson_bells_number integer,
  p_reaction_type text
)
returns jsonb
language sql
set search_path = ''
as $$
  select app_api_v1.upsert_lesson_reaction(
    p_subject_name,
    p_lesson_date,
    p_lesson_bells_number,
    p_reaction_type
  );
$$;

create or replace function public.delete_lesson_reaction(
  p_subject_name text,
  p_lesson_date date,
  p_lesson_bells_number integer
)
returns void
language sql
set search_path = ''
as $$
  select app_api_v1.delete_lesson_reaction(
    p_subject_name,
    p_lesson_date,
    p_lesson_bells_number
  );
$$;

create or replace function public.ingest_schedule_payload(
  p_institution_id text,
  p_source jsonb,
  p_targets jsonb,
  p_sync_run_id uuid default null
)
returns jsonb
language sql
security invoker
set search_path = ''
as $$
  select ingest_v1.upsert_schedule_payload(
    p_institution_id,
    p_source,
    p_targets,
    p_sync_run_id
  );
$$;

revoke all on function public.search_schedule_targets(text, text, text, integer)
from public;
grant execute on function public.search_schedule_targets(text, text, text, integer)
to anon, authenticated, service_role;

revoke all on function public.get_schedule_for_target(text, text, text)
from public;
grant execute on function public.get_schedule_for_target(text, text, text)
to anon, authenticated, service_role;

revoke all on function public.get_lesson_reactions(text, date, integer)
from public;
grant execute on function public.get_lesson_reactions(text, date, integer)
to anon, authenticated, service_role;

revoke all on function public.upsert_lesson_reaction(text, date, integer, text)
from public, anon;
grant execute on function public.upsert_lesson_reaction(text, date, integer, text)
to authenticated, service_role;

revoke all on function public.delete_lesson_reaction(text, date, integer)
from public, anon;
grant execute on function public.delete_lesson_reaction(text, date, integer)
to authenticated, service_role;

revoke all on function public.ingest_schedule_payload(text, jsonb, jsonb, uuid)
from public, anon, authenticated;
grant execute on function public.ingest_schedule_payload(text, jsonb, jsonb, uuid)
to service_role;
