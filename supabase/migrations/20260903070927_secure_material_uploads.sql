alter table core.lesson_materials
drop constraint lesson_materials_lesson_bells_number_positive;

alter table core.lesson_materials
add constraint lesson_materials_lesson_bells_number_positive check (
  lesson_bells_number > 0 or (
    lesson_bells_number = 0 and is_public and (
      split_part(file_path, '/', 1) = 'bank' or (
        split_part(file_path, '/', 1) = user_id::text
        and split_part(file_path, '/', 2) = 'bank'
        and split_part(file_path, '/', 3) <> ''
      )
    )
  )
);

alter table core.lesson_materials
drop constraint lesson_materials_material_type_valid;

alter table core.lesson_materials
add constraint lesson_materials_material_type_valid check (
  material_type in ('note', 'board', 'task', 'extra') or (
    material_type in ('exam', 'cheat') and lesson_bells_number = 0
    and is_public and (
      split_part(file_path, '/', 1) = 'bank' or (
        split_part(file_path, '/', 1) = user_id::text
        and split_part(file_path, '/', 2) = 'bank'
        and split_part(file_path, '/', 3) <> ''
      )
    )
  )
);

create table if not exists core.material_entitlements (
  user_id uuid not null references auth.users(id) on delete cascade,
  material_id uuid not null references core.lesson_materials(id) on delete cascade,
  organization_id text not null references core.organizations(id) on delete cascade,
  price_paid integer not null check (price_paid >= 0 and price_paid <= 1000000),
  created_at timestamptz not null default now(),
  primary key (user_id, material_id)
);

do $$
begin
  if (select count(*) from information_schema.columns column_info
    where column_info.table_schema = 'core' and column_info.table_name = 'material_entitlements'
      and column_info.is_nullable = 'NO' and (
        (column_info.column_name in ('user_id', 'material_id') and column_info.udt_name = 'uuid')
        or (column_info.column_name = 'organization_id' and column_info.udt_name = 'text')
        or (column_info.column_name = 'price_paid' and column_info.udt_name = 'int4')
        or (column_info.column_name = 'created_at' and column_info.udt_name = 'timestamptz')
      )) <> 5
    or not exists (
      select 1 from pg_catalog.pg_constraint constraint_row
      where constraint_row.conrelid = 'core.material_entitlements'::regclass
        and constraint_row.contype = 'p' and (
          select array_agg(attribute.attname::text order by attribute.attname)
          from unnest(constraint_row.conkey) key
          join pg_catalog.pg_attribute attribute
            on attribute.attrelid = constraint_row.conrelid and attribute.attnum = key
        ) = array['material_id', 'user_id']
    ) or (select count(distinct constraint_row.confrelid)
      from pg_catalog.pg_constraint constraint_row
      where constraint_row.conrelid = 'core.material_entitlements'::regclass
        and constraint_row.contype = 'f' and constraint_row.confrelid in (
          'auth.users'::regclass, 'core.lesson_materials'::regclass, 'core.organizations'::regclass
        )) <> 3 then
    raise exception 'Unsupported material entitlement schema';
  end if;
end;
$$;

create index if not exists material_entitlements_material_id_idx
on core.material_entitlements(material_id);

create index if not exists material_entitlements_user_idx
on core.material_entitlements(user_id, created_at desc);

alter table core.material_entitlements enable row level security;
revoke all on core.material_entitlements from public, anon, authenticated;
grant select on core.material_entitlements to authenticated;
grant all on core.material_entitlements to service_role;

drop policy if exists "users read own material entitlements" on core.material_entitlements;
create policy "users read own material entitlements"
on core.material_entitlements for select to authenticated
using (user_id = (select auth.uid()));

create table core.material_upload_rewards (
  storage_object_id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  organization_id text not null references core.organizations(id) on delete cascade,
  material_id uuid references core.lesson_materials(id) on delete set null,
  created_at timestamptz not null default now()
);

create index material_upload_rewards_user_id_idx on core.material_upload_rewards(user_id);
create index material_upload_rewards_material_id_idx on core.material_upload_rewards(material_id);
alter table core.material_upload_rewards enable row level security;
revoke all on core.material_upload_rewards from public, anon, authenticated;
grant all on core.material_upload_rewards to service_role;

insert into core.material_upload_rewards (
  storage_object_id, user_id, organization_id, material_id, created_at
)
select object.id, material.user_id, material.organization_id, material.id, material.created_at
from core.lesson_materials material
join storage.objects object on object.bucket_id = 'lesson-materials'
  and object.name = material.file_path
  and coalesce(nullif(object.owner_id, ''), object.owner::text) = material.user_id::text
where material.is_public and object.archived_at is null and not object.is_delete_marker
on conflict (storage_object_id) do nothing;

revoke insert, update, delete on core.lesson_materials from public, anon, authenticated;

do $$
declare v_columns text;
begin
  select string_agg(quote_ident(attribute.attname), ', ') into v_columns
  from pg_catalog.pg_attribute attribute
  where attribute.attrelid = 'core.lesson_materials'::regclass
    and attribute.attnum > 0 and not attribute.attisdropped;
  execute format(
    'revoke insert (%s), update (%s), references (%s) on core.lesson_materials from public, anon, authenticated',
    v_columns, v_columns, v_columns
  );
end;
$$;

create or replace function core.reward_material_upload(
  p_id uuid, p_object_id uuid
)
returns void
language plpgsql security invoker set search_path = ''
as $$
declare
  v_material core.lesson_materials;
begin
  select * into strict v_material from core.lesson_materials where id = p_id;
  insert into core.material_upload_rewards (
    storage_object_id, user_id, organization_id, material_id
  ) values (p_object_id, v_material.user_id, v_material.organization_id, p_id)
  on conflict (storage_object_id) do nothing;
  if found then
    perform core.apply_shuriken_delta(
      v_material.user_id, '📘', 'Залил материал «' || left(v_material.title, 60) || '»', 30
    );
  end if;
end;
$$;

create or replace function core.material_price(p_metadata jsonb)
returns integer
language sql immutable security invoker set search_path = ''
as $$
  select case
    when p_metadata ->> 'price' is null then 0
    when p_metadata ->> 'price' ~ '^[0-9]{1,7}$' then
      case when (p_metadata ->> 'price')::integer <= 1000000
        then (p_metadata ->> 'price')::integer end
  end;
$$;

create or replace function core.material_file_is_valid(
  p_material core.lesson_materials
)
returns boolean
language sql stable security invoker set search_path = ''
as $$
  select exists (
    select 1 from storage.objects object
    where object.bucket_id = 'lesson-materials'
      and object.name = p_material.file_path
      and coalesce(nullif(object.owner_id, ''), object.owner::text)
        = p_material.user_id::text
      and object.archived_at is null and not object.is_delete_marker
      and (
        p_material.metadata ->> 'storageObjectId' is null
        or p_material.metadata ->> 'storageObjectId' = object.id::text
      )
  );
$$;

create or replace function core.require_material_upload(
  p_organization_id text, p_file_path text, p_file_size bigint, p_mime_type text
)
returns uuid
language plpgsql security invoker set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_object storage.objects;
  v_mime text := coalesce(nullif(trim(p_mime_type), ''), 'application/octet-stream');
begin
  if v_uid is null or not exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = v_uid and profile.organization_id = p_organization_id
  ) then
    raise exception 'Organization access denied' using errcode = '42501';
  end if;
  if p_file_path is null or split_part(p_file_path, '/', 1) <> v_uid::text
    or p_file_path ~ '(^|/)\.\.?(/|$)' then
    raise exception 'File ownership required' using errcode = '42501';
  end if;
  if p_file_size is null or p_file_size <= 0 or p_file_size > 52428800 then
    raise exception 'Invalid file size' using errcode = '22023';
  end if;
  select * into v_object from storage.objects object
  where object.bucket_id = 'lesson-materials' and object.name = p_file_path
    and coalesce(nullif(object.owner_id, ''), object.owner::text) = v_uid::text
    and object.archived_at is null and not object.is_delete_marker
  for update;
  if not found then
    raise exception 'Owned uploaded file required' using errcode = '42501';
  end if;
  if coalesce(v_object.metadata ->> 'size', '') !~ '^[0-9]{1,10}$' then
    raise exception 'Invalid stored file size' using errcode = '22023';
  end if;
  if (v_object.metadata ->> 'size')::bigint <> p_file_size then
    raise exception 'File size does not match upload' using errcode = '22023';
  end if;
  if not exists (
    select 1 from storage.buckets bucket
    where bucket.id = 'lesson-materials' and not bucket.public
      and (bucket.allowed_mime_types is null or v_mime = any(bucket.allowed_mime_types))
      and (bucket.file_size_limit is null or p_file_size <= bucket.file_size_limit)
  ) or v_mime is distinct from v_object.metadata ->> 'mimetype' then
    raise exception 'Invalid file type' using errcode = '22023';
  end if;
  return v_object.id;
end;
$$;

create or replace function app_api_v1.create_public_material_v2(
  p_organization_id text, p_title text, p_subject_names text[],
  p_material_type text default 'note', p_price integer default 0,
  p_pages integer default 0, p_is_anonymous boolean default false,
  p_file_name text default '', p_file_path text default '',
  p_mime_type text default null, p_file_size bigint default 0
)
returns uuid
language plpgsql security definer set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_subjects text[];
  v_id uuid;
  v_object_id uuid;
  v_title text := core.validate_text(p_title, 'Название', 200, true);
  v_file_name text := core.validate_text(p_file_name, 'Имя файла', 300, true);
begin
  v_object_id := core.require_material_upload(
    p_organization_id, p_file_path, p_file_size, p_mime_type
  );
  if split_part(p_file_path, '/', 2) <> 'bank'
    or split_part(p_file_path, '/', 3) = ''
    or p_file_path <> v_uid::text || '/bank/' || split_part(p_file_path, '/', 3) then
    raise exception 'Invalid material bank path' using errcode = '22023';
  end if;
  if p_material_type is null
    or p_material_type not in ('note', 'board', 'task', 'extra', 'exam', 'cheat')
    or p_price is null or p_price < 0 or p_price > 1000000
    or p_pages is null or p_pages < 0 or p_pages > 100000 then
    raise exception 'Invalid material metadata' using errcode = '22023';
  end if;
  if cardinality(coalesce(p_subject_names, '{}'::text[])) not between 1 and 10
    or exists (
      select 1 from unnest(p_subject_names) subject
      where subject is null or trim(subject) = '' or char_length(trim(subject)) > 300
    ) then
    raise exception 'Choose up to 10 valid subjects' using errcode = '22023';
  end if;
  select array_agg(subject order by ordinal) into v_subjects from (
    select distinct on (translate(lower(trim(value)), 'ё', 'е'))
      trim(value) as subject, ordinal
    from unnest(p_subject_names) with ordinality as input(value, ordinal)
    order by translate(lower(trim(value)), 'ё', 'е'), ordinal
  ) subjects;

  perform core.enforce_rate_limit('upload_material', 30, interval '1 hour');
  perform core.enforce_rate_limit('upload_material', 150, interval '1 day');
  perform app_api_v1.ensure_gamification_profile(p_organization_id);
  if not exists (
    select 1 from core.user_gamification_profiles profile
    where profile.user_id = v_uid and profile.organization_id = p_organization_id
  ) then
    raise exception 'Wallet organization mismatch' using errcode = '42501';
  end if;
  insert into core.lesson_materials (
    organization_id, user_id, subject_name, lesson_date, lesson_bells_number,
    material_type, title, file_name, file_path, mime_type, file_size,
    is_public, is_anonymous, metadata
  ) values (
    p_organization_id, v_uid, v_subjects[1], current_date, 0,
    p_material_type, v_title, v_file_name, p_file_path,
    coalesce(nullif(trim(p_mime_type), ''), 'application/octet-stream'), p_file_size,
    true, coalesce(p_is_anonymous, false), jsonb_build_object(
      'price', p_price, 'pages', p_pages, 'subjectNames', v_subjects,
      'storageObjectId', v_object_id
    )
  ) returning id into v_id;
  perform core.reward_material_upload(v_id, v_object_id);
  return v_id;
end;
$$;

create or replace function app_api_v1.create_public_material(
  p_organization_id text, p_title text, p_subject_name text,
  p_material_type text default 'note', p_price integer default 0,
  p_pages integer default 0, p_is_anonymous boolean default false,
  p_file_name text default '', p_file_path text default '',
  p_mime_type text default null, p_file_size bigint default 0
)
returns uuid
language sql security invoker set search_path = ''
as $$
  select app_api_v1.create_public_material_v2(
    p_organization_id, p_title, array[p_subject_name], p_material_type,
    p_price, p_pages, p_is_anonymous, p_file_name, p_file_path, p_mime_type, p_file_size
  );
$$;

create or replace function app_api_v1.create_lesson_material(
  p_organization_id text, p_subject_name text, p_lesson_date date,
  p_lesson_bells_number integer, p_lesson_uid text, p_material_type text,
  p_title text, p_file_name text, p_file_path text, p_mime_type text,
  p_file_size bigint, p_is_public boolean, p_is_anonymous boolean
)
returns jsonb
language plpgsql security definer set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_row core.lesson_materials;
  v_object_id uuid;
begin
  v_object_id := core.require_material_upload(
    p_organization_id, p_file_path, p_file_size, p_mime_type
  );
  if p_lesson_date is null or p_lesson_bells_number is null or p_lesson_bells_number <= 0
    or p_material_type is null or p_material_type not in ('note', 'board', 'task', 'extra') then
    raise exception 'Invalid lesson material' using errcode = '22023';
  end if;
  perform core.enforce_rate_limit('upload_material', 30, interval '1 hour');
  perform core.enforce_rate_limit('upload_material', 150, interval '1 day');
  if coalesce(p_is_public, true) then
    perform app_api_v1.ensure_gamification_profile(p_organization_id);
    if not exists (
      select 1 from core.user_gamification_profiles profile
      where profile.user_id = v_uid and profile.organization_id = p_organization_id
    ) then
      raise exception 'Wallet organization mismatch' using errcode = '42501';
    end if;
  end if;
  insert into core.lesson_materials (
    organization_id, user_id, subject_name, lesson_date, lesson_bells_number,
    lesson_uid, material_type, title, file_name, file_path, mime_type, file_size,
    is_public, is_anonymous, metadata
  ) values (
    p_organization_id, v_uid, core.validate_text(p_subject_name, 'Предмет', 300, true),
    p_lesson_date, p_lesson_bells_number, nullif(trim(coalesce(p_lesson_uid, '')), ''),
    p_material_type, core.validate_text(p_title, 'Название', 200, true),
    core.validate_text(p_file_name, 'Имя файла', 300, true), p_file_path,
    coalesce(nullif(trim(p_mime_type), ''), 'application/octet-stream'), p_file_size,
    coalesce(p_is_public, true), coalesce(p_is_anonymous, false),
    jsonb_build_object('storageObjectId', v_object_id)
  ) returning * into v_row;
  if v_row.is_public then
    perform core.reward_material_upload(v_row.id, v_object_id);
  end if;
  return jsonb_build_object(
    'id', v_row.id, 'type', v_row.material_type, 'title', v_row.title,
    'fileName', v_row.file_name, 'filePath', v_row.file_path,
    'mimeType', v_row.mime_type, 'fileSize', v_row.file_size,
    'isPublic', v_row.is_public, 'isAnonymous', v_row.is_anonymous,
    'downloadCount', v_row.download_count, 'likeCount', v_row.like_count,
    'authorName', case when v_row.is_anonymous then 'Аноним' else 'Студент' end,
    'createdAt', v_row.created_at
  );
end;
$$;

create or replace function app_api_v1.list_public_materials_v2(
  p_organization_id text, p_limit integer default 50
)
returns jsonb
language plpgsql stable security definer set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_result jsonb;
begin
  if v_uid is null or not exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = v_uid and profile.organization_id = p_organization_id
  ) then
    raise exception 'Organization access denied' using errcode = '42501';
  end if;
  select coalesce(jsonb_agg(jsonb_build_object(
    'id', material.id, 'title', material.title, 'subjectName', material.subject_name,
    'materialType', material.material_type, 'downloads', material.download_count,
    'likes', material.like_count, 'price', coalesce(core.material_price(material.metadata), 0),
    'pages', case when material.metadata ->> 'pages' ~ '^[0-9]{1,7}$'
      then (material.metadata ->> 'pages')::integer else 0 end,
    'createdAt', material.created_at, 'isMine', material.user_id = v_uid,
    'authorName', case when material.is_anonymous then 'Аноним' else coalesce((
      select split_part(profile.full_name, ' ', 1) || ' '
        || left(split_part(profile.full_name, ' ', 2), 1) || '.'
      from core.user_academic_profiles profile where profile.user_id = material.user_id
    ), 'студент') end,
    'subjectNames', case
      when jsonb_typeof(material.metadata -> 'subjectNames') = 'array' then (
        select coalesce(jsonb_agg(subject), '[]'::jsonb)
        from jsonb_array_elements(material.metadata -> 'subjectNames') subject
        where jsonb_typeof(subject) = 'string'
      ) else jsonb_build_array(material.subject_name) end,
    'fileName', material.file_name, 'mimeType', material.mime_type,
    'fileSize', material.file_size,
    'hasFile', core.material_file_is_valid(material::core.lesson_materials)
      and core.material_price(material.metadata) is not null,
    'requiresRepublish', not core.material_file_is_valid(material::core.lesson_materials)
  ) order by material.download_count desc, material.created_at desc, material.id), '[]'::jsonb)
  into v_result from (
    select * from core.lesson_materials
    where organization_id = p_organization_id and is_public
    order by download_count desc, created_at desc, id
    limit least(greatest(coalesce(p_limit, 50), 1), 100)
  ) material;
  return v_result;
end;
$$;

create or replace function app_api_v1.get_public_materials(
  p_organization_id text, p_limit integer default 50
)
returns jsonb
language sql stable security invoker set search_path = ''
as $$ select app_api_v1.list_public_materials_v2(p_organization_id, p_limit); $$;

create or replace function app_api_v1.list_public_materials_v1(
  p_organization_id text, p_limit integer default 50
)
returns jsonb
language sql stable security invoker set search_path = ''
as $$ select app_api_v1.list_public_materials_v2(p_organization_id, p_limit); $$;

create or replace function app_api_v1.access_public_material(p_id uuid)
returns jsonb
language plpgsql stable security definer set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_material core.lesson_materials;
  v_price integer;
  v_access boolean;
begin
  select material.* into v_material from core.lesson_materials material
  join core.user_academic_profiles profile on profile.user_id = v_uid
    and profile.organization_id = material.organization_id
  where material.id = p_id and material.is_public;
  if v_uid is null or not found then
    raise exception 'Material access denied' using errcode = '42501';
  end if;
  v_price := core.material_price(v_material.metadata);
  if v_price is null or not core.material_file_is_valid(v_material) then
    raise exception 'Material file unavailable' using errcode = '22023';
  end if;
  v_access := v_material.user_id = v_uid or v_price = 0 or exists (
    select 1 from core.material_entitlements entitlement
    where entitlement.user_id = v_uid and entitlement.material_id = p_id
      and entitlement.organization_id = v_material.organization_id
  );
  return jsonb_build_object(
    'canDownload', v_access, 'price', v_price,
    'filePath', case when v_access then v_material.file_path end
  );
end;
$$;

create or replace function app_api_v1.get_top_material_authors(p_organization_id text)
returns jsonb
language plpgsql stable security definer set search_path = ''
as $$
declare v_result jsonb;
begin
  if (select auth.uid()) is null or not exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = (select auth.uid()) and profile.organization_id = p_organization_id
  ) then
    raise exception 'Organization access denied' using errcode = '42501';
  end if;
  select coalesce(jsonb_agg(jsonb_build_object(
    'name', author.full_name, 'downloads', author.downloads, 'materials', author.materials
  ) order by author.downloads desc), '[]'::jsonb) into v_result
  from (
    select coalesce(profile.full_name, 'Аноним') as full_name,
      sum(material.download_count) as downloads, count(*) as materials
    from core.lesson_materials material
    left join core.user_academic_profiles profile on profile.user_id = material.user_id
    where material.organization_id = p_organization_id
      and material.is_public and not material.is_anonymous
    group by profile.full_name order by downloads desc limit 3
  ) author;
  return v_result;
end;
$$;

create or replace function app_api_v1.purchase_public_material(
  p_id uuid, p_expected_price integer
)
returns jsonb
language plpgsql security definer set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_material core.lesson_materials;
  v_price integer;
  v_balance integer;
begin
  if v_uid is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  select material.* into v_material from core.lesson_materials material
  join core.user_academic_profiles profile on profile.user_id = v_uid
    and profile.organization_id = material.organization_id
  where material.id = p_id and material.is_public
  for update of material;
  if not found then
    raise exception 'Material access denied' using errcode = '42501';
  end if;
  v_price := core.material_price(v_material.metadata);
  if v_price is null or not core.material_file_is_valid(v_material) then
    raise exception 'Material file unavailable' using errcode = '22023';
  end if;
  perform 1 from storage.objects object
  where object.bucket_id = 'lesson-materials' and object.name = v_material.file_path
    and coalesce(nullif(object.owner_id, ''), object.owner::text) = v_material.user_id::text
    and object.archived_at is null and not object.is_delete_marker
    and (v_material.metadata ->> 'storageObjectId' is null
      or v_material.metadata ->> 'storageObjectId' = object.id::text)
  for share;
  if not found then
    raise exception 'Material file unavailable' using errcode = '22023';
  end if;
  if v_material.user_id = v_uid or v_price = 0 or exists (
    select 1 from core.material_entitlements entitlement
    where entitlement.user_id = v_uid and entitlement.material_id = p_id
      and entitlement.organization_id = v_material.organization_id
  ) then
    return app_api_v1.access_public_material(p_id);
  end if;
  if p_expected_price is distinct from v_price then
    raise exception 'MATERIAL_PRICE_CHANGED' using errcode = '22023';
  end if;
  select profile.shurikens into v_balance
  from core.user_gamification_profiles profile
  where profile.user_id = v_uid and profile.organization_id = v_material.organization_id
  for update;
  if not found or v_balance < v_price then
    raise exception 'MATERIAL_INSUFFICIENT_BALANCE' using errcode = '22023';
  end if;
  perform core.apply_shuriken_delta(
    v_uid, '📘', 'Материал «' || left(v_material.title, 60) || '»', -v_price
  );
  insert into core.material_entitlements (
    user_id, material_id, organization_id, price_paid
  ) values (v_uid, p_id, v_material.organization_id, v_price);
  return app_api_v1.access_public_material(p_id);
end;
$$;

create or replace function core.can_read_lesson_material_file(p_file_path text)
returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from core.lesson_materials material
    join core.user_academic_profiles profile on profile.user_id = (select auth.uid())
      and profile.organization_id = material.organization_id
    where material.file_path = p_file_path
      and core.material_file_is_valid(material)
      and (
        material.user_id = (select auth.uid()) or (
          material.is_public and (
            core.material_price(material.metadata) = 0 or exists (
              select 1 from core.material_entitlements entitlement
              where entitlement.material_id = material.id
                and entitlement.organization_id = material.organization_id
                and entitlement.user_id = (select auth.uid())
            )
          )
        )
      )
  );
$$;

drop policy if exists "public can read linked lesson material files" on storage.objects;
drop policy if exists "authorized users can read linked lesson material files" on storage.objects;

create policy "users read accessible lesson material files"
on storage.objects for select to authenticated using (
  bucket_id = 'lesson-materials' and core.can_read_lesson_material_file(name)
);

create policy "users read own lesson material uploads"
on storage.objects for select to authenticated using (
  bucket_id = 'lesson-materials'
  and split_part(name, '/', 1) = (select auth.uid())::text
  and coalesce(nullif(owner_id, ''), owner::text) = (select auth.uid())::text
  and archived_at is null and not is_delete_marker
);

create or replace function core.lesson_material_file_is_linked(p_file_path text)
returns boolean
language sql stable security definer set search_path = ''
as $$
  select case when (select auth.uid()) is null
    or split_part(p_file_path, '/', 1) is distinct from (select auth.uid())::text
    then true else exists (
      select 1 from core.lesson_materials where file_path = p_file_path
    ) end;
$$;

drop policy if exists "users can upload own lesson material files" on storage.objects;
drop policy if exists "users can upload owned lesson material files" on storage.objects;
drop policy if exists "users can update own lesson material files" on storage.objects;
drop policy if exists "users can update owned lesson material files" on storage.objects;
drop policy if exists "users can delete own lesson material files" on storage.objects;
drop policy if exists "users can delete owned lesson material files" on storage.objects;

create policy "users upload own lesson material objects"
on storage.objects for insert to authenticated with check (
  bucket_id = 'lesson-materials' and split_part(name, '/', 1) = (select auth.uid())::text
  and coalesce(nullif(owner_id, ''), owner::text) = (select auth.uid())::text
  and not core.lesson_material_file_is_linked(name)
);

create policy "users update orphaned lesson material objects"
on storage.objects for update to authenticated using (
  bucket_id = 'lesson-materials' and split_part(name, '/', 1) = (select auth.uid())::text
  and coalesce(nullif(owner_id, ''), owner::text) = (select auth.uid())::text
  and not core.lesson_material_file_is_linked(name)
) with check (
  bucket_id = 'lesson-materials' and split_part(name, '/', 1) = (select auth.uid())::text
  and coalesce(nullif(owner_id, ''), owner::text) = (select auth.uid())::text
  and not core.lesson_material_file_is_linked(name)
);

create policy "users delete orphaned lesson material objects"
on storage.objects for delete to authenticated using (
  bucket_id = 'lesson-materials' and split_part(name, '/', 1) = (select auth.uid())::text
  and coalesce(nullif(owner_id, ''), owner::text) = (select auth.uid())::text
  and not core.lesson_material_file_is_linked(name)
);

create or replace function app_api_v1.increment_material_downloads(p_id uuid)
returns void
language plpgsql security definer set search_path = ''
as $$
begin
  if not (app_api_v1.access_public_material(p_id) ->> 'canDownload')::boolean then
    raise exception 'Material access denied' using errcode = '42501';
  end if;
  update core.lesson_materials set download_count = download_count + 1
  where id = p_id;
end;
$$;

create or replace function public.access_public_material(p_id uuid)
returns jsonb
language sql stable security invoker set search_path = ''
as $$ select app_api_v1.access_public_material(p_id); $$;

create or replace function public.purchase_public_material(p_id uuid, p_expected_price integer)
returns jsonb
language sql security invoker set search_path = ''
as $$ select app_api_v1.purchase_public_material(p_id, p_expected_price); $$;

create or replace function public.get_public_materials(
  p_organization_id text, p_limit integer default 50
)
returns jsonb
language sql stable security invoker set search_path = ''
as $$ select app_api_v1.get_public_materials(p_organization_id, p_limit); $$;

create or replace function public.increment_material_downloads(p_id uuid)
returns void
language sql security invoker set search_path = ''
as $$ select app_api_v1.increment_material_downloads(p_id); $$;

create or replace function public.get_top_material_authors(p_organization_id text)
returns jsonb
language sql stable security invoker set search_path = ''
as $$ select app_api_v1.get_top_material_authors(p_organization_id); $$;

revoke all on function core.material_price(jsonb) from public, anon, authenticated;
revoke all on function core.reward_material_upload(uuid, uuid) from public, anon, authenticated;
revoke all on function core.material_file_is_valid(core.lesson_materials) from public, anon, authenticated;
revoke all on function core.require_material_upload(text, text, bigint, text) from public, anon, authenticated;
revoke all on function core.can_read_lesson_material_file(text) from public, anon;
grant execute on function core.can_read_lesson_material_file(text) to authenticated, service_role;
revoke all on function core.lesson_material_file_is_linked(text) from public, anon;
grant execute on function core.lesson_material_file_is_linked(text) to authenticated, service_role;
revoke all on function app_api_v1.access_public_material(uuid) from public, anon;
revoke all on function app_api_v1.purchase_public_material(uuid, integer) from public, anon;
revoke all on function public.access_public_material(uuid) from public, anon;
revoke all on function public.purchase_public_material(uuid, integer) from public, anon;
grant execute on function app_api_v1.access_public_material(uuid) to authenticated, service_role;
grant execute on function app_api_v1.purchase_public_material(uuid, integer) to authenticated, service_role;
grant execute on function public.access_public_material(uuid) to authenticated, service_role;
grant execute on function public.purchase_public_material(uuid, integer) to authenticated, service_role;

do $$
declare v_signature text;
begin
  foreach v_signature in array array[
    'app_api_v1.get_public_materials(text,integer)',
    'app_api_v1.get_top_material_authors(text)',
    'app_api_v1.list_public_materials_v1(text,integer)',
    'app_api_v1.list_public_materials_v2(text,integer)',
    'app_api_v1.create_public_material(text,text,text,text,integer,integer,boolean,text,text,text,bigint)',
    'app_api_v1.create_public_material_v2(text,text,text[],text,integer,integer,boolean,text,text,text,bigint)',
    'app_api_v1.create_lesson_material(text,text,date,integer,text,text,text,text,text,text,bigint,boolean,boolean)',
    'app_api_v1.increment_material_downloads(uuid)',
    'public.get_public_materials(text,integer)',
    'public.get_top_material_authors(text)',
    'public.list_public_materials_v2(text,integer)',
    'public.create_public_material(text,text,text,text,integer,integer,boolean,text,text,text,bigint)',
    'public.create_public_material_v2(text,text,text[],text,integer,integer,boolean,text,text,text,bigint)',
    'public.create_lesson_material(text,text,date,integer,text,text,text,text,text,text,bigint,boolean,boolean)',
    'public.increment_material_downloads(uuid)'
  ] loop
    execute format('revoke all on function %s from public, anon', v_signature);
    execute format('grant execute on function %s to authenticated, service_role', v_signature);
  end loop;
  if to_regprocedure('core.require_lesson_material_upload(uuid,text,bigint)') is not null then
    revoke all on function core.require_lesson_material_upload(uuid,text,bigint) from public, anon, authenticated;
  end if;
end;
$$;

do $$
begin
  if exists (select 1 from storage.buckets where id = 'lesson-materials' and public) then
    raise exception 'Lesson material bucket must remain private';
  end if;
end;
$$;

notify pgrst, 'reload schema';
