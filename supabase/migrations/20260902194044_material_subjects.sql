alter table core.lesson_materials
drop constraint if exists lesson_materials_lesson_bells_number_positive;

alter table core.lesson_materials
add constraint lesson_materials_lesson_bells_number_positive check (
  lesson_bells_number > 0
  or (
    lesson_bells_number = 0
    and is_public
    and split_part(file_path, '/', 1) = 'bank'
  )
);

alter table core.lesson_materials
drop constraint if exists lesson_materials_material_type_valid;

alter table core.lesson_materials
add constraint lesson_materials_material_type_valid check (
  material_type in ('note', 'board', 'task', 'extra')
  or (
    material_type in ('exam', 'cheat')
    and lesson_bells_number = 0
    and is_public
    and split_part(file_path, '/', 1) = 'bank'
  )
);

create or replace function app_api_v1.search_material_subjects(
  p_organization_id text,
  p_query text default '',
  p_limit integer default 40
)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_query text := regexp_replace(
    translate(lower(coalesce(p_query, '')), 'ё', 'е'),
    '[^a-zа-я0-9+#]', '', 'g'
  );
  v_result jsonb;
begin
  if (select auth.uid()) is null or not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = (select auth.uid())
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'Organization access denied' using errcode = '42501';
  end if;

  with subject_values as (
    select discipline.name as subject
    from core.schedule_disciplines discipline
    where discipline.organization_id = p_organization_id
    union
    select material.subject_name
    from core.lesson_materials material
    where material.organization_id = p_organization_id and material.is_public
    union
    select value #>> '{}'
    from core.lesson_materials material
    cross join lateral jsonb_array_elements(
      case
        when jsonb_typeof(material.metadata -> 'subjectNames') = 'array'
          then material.metadata -> 'subjectNames'
        else '[]'::jsonb
      end
    ) value
    where material.organization_id = p_organization_id
      and material.is_public
      and jsonb_typeof(value) = 'string'
  ), normalized as (
    select trim(subject) as subject, regexp_replace(
      translate(lower(subject), 'ё', 'е'), '[^a-zа-я0-9+#]', '', 'g'
    ) as search_value
    from subject_values
    where nullif(trim(subject), '') is not null
  ), matches as (
    select distinct on (translate(lower(subject), 'ё', 'е')) subject, search_value,
      case
        when search_value = v_query then 0
        when starts_with(search_value, v_query) then 1
        else 2
      end as rank
    from normalized
    where v_query = '' or strpos(search_value, v_query) > 0
    order by translate(lower(subject), 'ё', 'е'), subject
  ), limited as (
    select subject, rank from matches
    order by rank, subject
    limit least(greatest(coalesce(p_limit, 40), 1), 100)
  )
  select coalesce(jsonb_agg(subject order by rank, subject), '[]'::jsonb)
  into v_result from limited;

  return v_result;
end;
$$;

create or replace function app_api_v1.create_public_material_v2(
  p_organization_id text,
  p_title text,
  p_subject_names text[],
  p_material_type text default 'note',
  p_price integer default 0,
  p_pages integer default 0,
  p_is_anonymous boolean default false,
  p_file_name text default '',
  p_file_path text default '',
  p_mime_type text default null,
  p_file_size bigint default 0
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_subjects text[];
  v_id uuid;
begin
  if (select auth.uid()) is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if cardinality(coalesce(p_subject_names, '{}'::text[])) > 10
    or exists (
      select 1 from unnest(p_subject_names) subject
      where subject is null or char_length(trim(subject)) > 300
    ) then
    raise exception 'Choose up to 10 valid subjects' using errcode = '22023';
  end if;

  select coalesce(array_agg(subject order by ordinal), '{}'::text[])
  into v_subjects
  from (
    select distinct on (translate(lower(trim(value)), 'ё', 'е'))
      trim(value) as subject, ordinal
    from unnest(p_subject_names) with ordinality as input(value, ordinal)
    where nullif(trim(value), '') is not null
    order by translate(lower(trim(value)), 'ё', 'е'), ordinal
  ) unique_subjects;

  if cardinality(v_subjects) = 0 then
    raise exception 'Select at least one subject' using errcode = '22023';
  end if;

  v_id := app_api_v1.create_public_material(
    p_organization_id, p_title, coalesce(v_subjects[1], ''),
    p_material_type, p_price, p_pages, p_is_anonymous,
    p_file_name, p_file_path, p_mime_type, p_file_size
  );

  update core.lesson_materials
  set metadata = coalesce(metadata, '{}'::jsonb)
    || jsonb_build_object('subjectNames', v_subjects)
  where id = v_id and user_id = (select auth.uid());

  return v_id;
end;
$$;

create or replace function app_api_v1.list_public_materials_v2(
  p_organization_id text,
  p_limit integer default 50
)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_materials jsonb;
  v_result jsonb;
begin
  if (select auth.uid()) is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  v_materials := app_api_v1.list_public_materials_v1(
    p_organization_id, p_limit
  );
  select coalesce(jsonb_agg(
    listed.value || jsonb_build_object(
      'subjectNames', case
        when jsonb_typeof(material.metadata -> 'subjectNames') = 'array'
          then coalesce((
            select jsonb_agg(subject.value)
            from jsonb_array_elements(material.metadata -> 'subjectNames')
              as subject(value)
            where jsonb_typeof(subject.value) = 'string'
          ), '[]'::jsonb)
        when nullif(trim(material.subject_name), '') is not null
          then jsonb_build_array(material.subject_name)
        else '[]'::jsonb
      end
    ) order by listed.ordinal
  ), '[]'::jsonb)
  into v_result
  from jsonb_array_elements(v_materials) with ordinality as listed(value, ordinal)
  join core.lesson_materials material
    on material.id = (listed.value ->> 'id')::uuid
    and material.organization_id = p_organization_id
    and material.is_public;
  return v_result;
end;
$$;

create or replace function public.search_material_subjects(
  p_organization_id text,
  p_query text default '',
  p_limit integer default 40
)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select app_api_v1.search_material_subjects(
    p_organization_id, p_query, p_limit
  );
$$;

create or replace function public.create_public_material_v2(
  p_organization_id text,
  p_title text,
  p_subject_names text[],
  p_material_type text default 'note',
  p_price integer default 0,
  p_pages integer default 0,
  p_is_anonymous boolean default false,
  p_file_name text default '',
  p_file_path text default '',
  p_mime_type text default null,
  p_file_size bigint default 0
)
returns uuid
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.create_public_material_v2(
    p_organization_id, p_title, p_subject_names, p_material_type,
    p_price, p_pages, p_is_anonymous, p_file_name, p_file_path,
    p_mime_type, p_file_size
  );
$$;

create or replace function public.list_public_materials_v2(
  p_organization_id text,
  p_limit integer default 50
)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select app_api_v1.list_public_materials_v2(p_organization_id, p_limit);
$$;

revoke all on function app_api_v1.search_material_subjects(text, text, integer)
from public, anon;
revoke all on function app_api_v1.create_public_material_v2(
  text, text, text[], text, integer, integer, boolean, text, text, text, bigint
) from public, anon;
revoke all on function app_api_v1.list_public_materials_v2(text, integer)
from public, anon;
revoke all on function public.search_material_subjects(text, text, integer)
from public, anon;
revoke all on function public.create_public_material_v2(
  text, text, text[], text, integer, integer, boolean, text, text, text, bigint
) from public, anon;
revoke all on function public.list_public_materials_v2(text, integer)
from public, anon;

grant execute on function app_api_v1.search_material_subjects(text, text, integer)
to authenticated, service_role;
grant execute on function app_api_v1.create_public_material_v2(
  text, text, text[], text, integer, integer, boolean, text, text, text, bigint
) to authenticated, service_role;
grant execute on function app_api_v1.list_public_materials_v2(text, integer)
to authenticated, service_role;
grant execute on function public.search_material_subjects(text, text, integer)
to authenticated, service_role;
grant execute on function public.create_public_material_v2(
  text, text, text[], text, integer, integer, boolean, text, text, text, bigint
) to authenticated, service_role;
grant execute on function public.list_public_materials_v2(text, integer)
to authenticated, service_role;

create or replace function app_api_v1.search_schedule_targets(
  p_target_type text,
  p_query text default '',
  p_organization_id text default null,
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
security invoker
set search_path = ''
as $$
  with query as (
    select regexp_replace(
      translate(lower(coalesce(p_query, '')), 'ё', 'е'),
      '[^a-zа-я0-9]', '', 'g'
    ) as value
  ), targets as (
    select st.target_type, st.external_id, st.target_title, st.full_title,
      st.source_links,
      regexp_replace(
        translate(lower(st.target_title), 'ё', 'е'), '[^a-zа-я0-9]', '', 'g'
      ) as normalized_title,
      regexp_replace(
        translate(lower(st.full_title), 'ё', 'е'), '[^a-zа-я0-9]', '', 'g'
      ) as normalized_full_title,
      regexp_replace(
        translate(lower(st.external_id), 'ё', 'е'), '[^a-zа-я0-9]', '', 'g'
      ) as normalized_external_id
    from core.schedule_targets st
    where st.is_active
      and st.target_type = p_target_type
      and (p_organization_id is null or st.organization_id = p_organization_id)
  )
  select st.target_type, st.external_id, st.target_title, st.full_title,
    st.source_links
  from targets st
  cross join query q
  where q.value = ''
    or st.normalized_title like '%' || q.value || '%'
    or st.normalized_full_title like '%' || q.value || '%'
    or st.external_id = trim(p_query)
    or st.normalized_external_id = q.value
  order by
    case
      when st.normalized_title = q.value
        or st.normalized_full_title = q.value
        or st.external_id = trim(p_query)
        or st.normalized_external_id = q.value then 0
      when starts_with(st.normalized_title, q.value)
        or starts_with(st.normalized_full_title, q.value) then 1
      else 2
    end,
    st.target_title,
    st.external_id
  limit least(greatest(coalesce(p_limit, 20), 1), 100);
$$;
