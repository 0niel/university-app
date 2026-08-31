create table core.material_entitlements (
  material_id uuid not null references core.lesson_materials(id)
    on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  organization_id text not null references core.organizations(id)
    on delete cascade,
  price_paid integer not null check (price_paid >= 0),
  created_at timestamptz not null default now(),
  primary key (material_id, user_id)
);

create index material_entitlements_user_idx
on core.material_entitlements (user_id, created_at desc);

alter table core.material_entitlements enable row level security;

create policy "users read own material entitlements"
on core.material_entitlements for select to authenticated
using (user_id = (select auth.uid()));

grant select on core.material_entitlements to authenticated;
grant all on core.material_entitlements to service_role;

create or replace function core.require_lesson_material_upload(
  p_user_id uuid,
  p_file_path text,
  p_expected_size bigint
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_object_id uuid;
  v_actual_size bigint;
begin
  if p_user_id is null or (
    (select auth.uid()) is distinct from p_user_id
    and coalesce((select auth.role()), '') <> 'service_role'
  ) then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;

  select id, nullif(metadata ->> 'size', '')::bigint
  into v_object_id, v_actual_size
  from storage.objects
  where bucket_id = 'lesson-materials'
    and name = p_file_path
    and owner_id = p_user_id::text
  for update;

  if v_object_id is null then
    raise exception 'Uploaded file not found' using errcode = '22023';
  end if;
  if v_actual_size is null or v_actual_size <> p_expected_size then
    raise exception 'Uploaded file size mismatch' using errcode = '22023';
  end if;

  return v_object_id;
end;
$$;

create or replace function app_api_v1.get_public_materials(
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
  v_user_id uuid := (select auth.uid());
  v_result jsonb;
begin
  if v_user_id is null or not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'Organization access denied' using errcode = '42501';
  end if;

  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', material.id,
        'title', material.title,
        'subjectName', material.subject_name,
        'materialType', material.material_type,
        'downloads', material.download_count,
        'likes', material.like_count,
        'price', case
          when material.metadata ->> 'price' ~ '^[0-9]{1,7}$'
            then (material.metadata ->> 'price')::integer
          else 0
        end,
        'pages', case
          when material.metadata ->> 'pages' ~ '^[0-9]{1,7}$'
            then (material.metadata ->> 'pages')::integer
          else 0
        end,
        'fileName', material.file_name,
        'mimeType', coalesce(material.mime_type, ''),
        'fileSize', material.file_size,
        'hasFile', material.file_path <> '' and (
          not material.is_anonymous
          or split_part(material.file_path, '/', 1) = 'bank'
          or material.user_id = v_user_id
        ),
        'createdAt', material.created_at,
        'isMine', material.user_id = v_user_id,
        'authorName', case
          when material.is_anonymous then 'Аноним'
          else coalesce(
            (
              select split_part(profile.full_name, ' ', 1) || ' '
                || left(split_part(profile.full_name, ' ', 2), 1) || '.'
              from core.user_academic_profiles profile
              where profile.user_id = material.user_id
            ),
            'студент'
          )
        end
      )
      order by material.download_count desc, material.created_at desc
    ),
    '[]'::jsonb
  )
  into v_result
  from (
    select *
    from core.lesson_materials
    where organization_id = p_organization_id and is_public
    order by download_count desc, created_at desc
    limit least(greatest(coalesce(p_limit, 50), 0), 100)
  ) material;

  return v_result;
end;
$$;

create or replace function app_api_v1.get_top_material_authors(
  p_organization_id text
)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_result jsonb;
begin
  if v_user_id is null or not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'Organization access denied' using errcode = '42501';
  end if;

  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'name', author.full_name,
        'downloads', author.downloads,
        'materials', author.materials
      )
      order by author.downloads desc
    ),
    '[]'::jsonb
  )
  into v_result
  from (
    select
      coalesce(profile.full_name, 'Студент') as full_name,
      sum(material.download_count) as downloads,
      count(*) as materials
    from core.lesson_materials material
    left join core.user_academic_profiles profile
      on profile.user_id = material.user_id
    where material.organization_id = p_organization_id
      and material.is_public
      and not material.is_anonymous
    group by profile.full_name
    order by downloads desc
    limit 3
  ) author;

  return v_result;
end;
$$;

create or replace function app_api_v1.access_public_material(p_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_material core.lesson_materials%rowtype;
  v_price integer;
  v_entitled_material_id uuid;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;

  select material.*
  into v_material
  from core.lesson_materials material
  where material.id = p_id and material.is_public
  for update;

  if not found then
    raise exception 'Material not found' using errcode = 'P0002';
  end if;
  if not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = v_material.organization_id
  ) then
    raise exception 'Organization access denied' using errcode = '42501';
  end if;
  if v_material.file_path = '' then
    raise exception 'Material does not have a file' using errcode = '22023';
  end if;
  if v_material.is_anonymous
      and v_material.user_id <> v_user_id
      and split_part(v_material.file_path, '/', 1) <> 'bank' then
    raise exception 'Anonymous material must be republished'
      using errcode = '22023';
  end if;

  v_price := case
    when v_material.metadata ->> 'price' ~ '^[0-9]{1,7}$'
      then (v_material.metadata ->> 'price')::integer
    else 0
  end;

  if v_material.user_id <> v_user_id and v_price > 0 then
    insert into core.material_entitlements (
      material_id,
      user_id,
      organization_id,
      price_paid
    )
    values (
      v_material.id,
      v_user_id,
      v_material.organization_id,
      v_price
    )
    on conflict (material_id, user_id) do nothing
    returning material_id into v_entitled_material_id;

    if v_entitled_material_id is not null then
      perform core.apply_organization_shuriken_delta(
        v_user_id,
        v_material.organization_id,
        '📘',
        'Материал · ' || left(v_material.title, 80),
        -v_price
      );
    end if;
  end if;

  return jsonb_build_object(
    'filePath', v_material.file_path,
    'fileName', v_material.file_name,
    'mimeType', coalesce(v_material.mime_type, ''),
    'fileSize', v_material.file_size
  );
end;
$$;

create or replace function app_api_v1.increment_material_downloads(p_id uuid)
returns void
language sql
security definer
set search_path = ''
as $$
  update core.lesson_materials material
  set download_count = material.download_count + 1
  where material.id = p_id
    and material.is_public
    and exists (
      select 1
      from core.user_academic_profiles profile
      where profile.user_id = (select auth.uid())
        and profile.organization_id = material.organization_id
    )
    and (
      material.user_id = (select auth.uid())
      or case
        when material.metadata ->> 'price' ~ '^[0-9]{1,7}$'
          then (material.metadata ->> 'price')::integer = 0
        else true
      end
      or exists (
        select 1
        from core.material_entitlements entitlement
        where entitlement.material_id = material.id
          and entitlement.user_id = (select auth.uid())
      )
    );
$$;

create or replace function app_api_v1.create_public_material(
  p_organization_id text,
  p_title text,
  p_subject_name text,
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
  v_user_id uuid := (select auth.uid());
  v_id uuid;
  v_storage_object_id uuid;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'Organization access denied' using errcode = '42501';
  end if;
  if coalesce(p_file_path, '') = ''
      or coalesce(p_file_name, '') = ''
      or coalesce(p_file_size, 0) <= 0 then
    raise exception 'A material file is required' using errcode = '22023';
  end if;
  if p_file_size > 52428800 then
    raise exception 'File is too large' using errcode = '22023';
  end if;
  if split_part(p_file_path, '/', 1) <> 'bank' then
    raise exception 'Invalid material file path' using errcode = '22023';
  end if;

  perform core.enforce_rate_limit('upload_material', 30, interval '1 hour');
  perform core.enforce_rate_limit('upload_material', 150, interval '1 day');
  v_storage_object_id := core.require_lesson_material_upload(
    v_user_id,
    p_file_path,
    p_file_size
  );

  insert into core.lesson_materials (
    organization_id,
    user_id,
    subject_name,
    lesson_date,
    lesson_bells_number,
    material_type,
    title,
    file_name,
    file_path,
    mime_type,
    file_size,
    is_public,
    is_anonymous,
    metadata
  )
  values (
    p_organization_id,
    v_user_id,
    core.validate_text(p_subject_name, 'Предмет', 300, false),
    current_date,
    0,
    core.validate_text(p_material_type, 'Тип', 40, false),
    core.validate_text(p_title, 'Название', 200, true),
    core.validate_text(p_file_name, 'Имя файла', 300, false),
    p_file_path,
    nullif(trim(coalesce(p_mime_type, '')), ''),
    p_file_size,
    true,
    coalesce(p_is_anonymous, false),
    jsonb_build_object(
      'price', least(greatest(coalesce(p_price, 0), 0), 500),
      'pages', least(greatest(coalesce(p_pages, 0), 0), 100000),
      'storageObjectId', v_storage_object_id
    )
  )
  returning id into v_id;

  perform core.apply_organization_shuriken_delta(
    v_user_id,
    p_organization_id,
    '📘',
    'Залил материал «' || left(p_title, 60) || '»',
    30
  );
  return v_id;
end;
$$;

create or replace function app_api_v1.ensure_gamification_profile(
  p_organization_id text
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'Organization access denied' using errcode = '42501';
  end if;

  insert into core.user_gamification_profiles (user_id, organization_id)
  values (v_user_id, p_organization_id)
  on conflict (user_id) do nothing;

  return app_api_v1.get_gamification_profile();
end;
$$;

create or replace function public.access_public_material(p_id uuid)
returns jsonb
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.access_public_material(p_id);
$$;

drop policy if exists "public can read linked lesson material files"
on storage.objects;
drop policy if exists "users can upload own lesson material files"
on storage.objects;
drop policy if exists "users can update own lesson material files"
on storage.objects;
drop policy if exists "users can delete own lesson material files"
on storage.objects;

create policy "authorized users can read linked lesson material files"
on storage.objects for select to authenticated
using (
  bucket_id = 'lesson-materials'
  and exists (
    select 1
    from core.lesson_materials material
    where material.file_path = storage.objects.name
      and (
        material.user_id = (select auth.uid())
        or (
          material.is_public
          and exists (
            select 1
            from core.user_academic_profiles profile
            where profile.user_id = (select auth.uid())
              and profile.organization_id = material.organization_id
          )
          and (
            case
              when material.metadata ->> 'price' ~ '^[0-9]{1,7}$'
                then (material.metadata ->> 'price')::integer = 0
              else true
            end
            or exists (
              select 1
              from core.material_entitlements entitlement
              where entitlement.material_id = material.id
                and entitlement.user_id = (select auth.uid())
            )
          )
          and (
            not material.is_anonymous
            or split_part(material.file_path, '/', 1) = 'bank'
          )
        )
      )
  )
);

create policy "users can upload owned lesson material files"
on storage.objects for insert to authenticated
with check (
  bucket_id = 'lesson-materials'
  and owner_id = (select auth.uid())::text
);

create policy "users can update owned lesson material files"
on storage.objects for update to authenticated
using (
  bucket_id = 'lesson-materials'
  and owner_id = (select auth.uid())::text
)
with check (
  bucket_id = 'lesson-materials'
  and owner_id = (select auth.uid())::text
);

create policy "users can delete owned lesson material files"
on storage.objects for delete to authenticated
using (
  bucket_id = 'lesson-materials'
  and owner_id = (select auth.uid())::text
);

revoke all on function app_api_v1.get_public_materials(text, integer)
from public, anon;
revoke all on function app_api_v1.get_top_material_authors(text)
from public, anon;
revoke all on function app_api_v1.access_public_material(uuid)
from public, anon;
revoke all on function app_api_v1.increment_material_downloads(uuid)
from public, anon;
revoke all on function app_api_v1.create_public_material(
  text, text, text, text, integer, integer, boolean, text, text, text, bigint
) from public, anon;
revoke all on function public.access_public_material(uuid)
from public, anon;

grant execute on function app_api_v1.get_public_materials(text, integer)
to authenticated, service_role;
grant execute on function app_api_v1.get_top_material_authors(text)
to authenticated, service_role;
grant execute on function app_api_v1.access_public_material(uuid)
to authenticated, service_role;
grant execute on function app_api_v1.increment_material_downloads(uuid)
to authenticated, service_role;
grant execute on function app_api_v1.create_public_material(
  text, text, text, text, integer, integer, boolean, text, text, text, bigint
) to authenticated, service_role;
grant execute on function public.access_public_material(uuid)
to authenticated;

drop policy if exists "users can insert own profile"
on core.user_gamification_profiles;
drop policy if exists "users can update own profile"
on core.user_gamification_profiles;
revoke insert, update, delete on core.user_gamification_profiles
from authenticated;
