create or replace function app_api_v1.list_public_materials_v1(
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
        'fileName', case
          when material.file_path = ''
            or not material.storage_file_exists then ''
          when material.is_anonymous
              and split_part(material.file_path, '/', 1) <> 'bank' then ''
          else material.file_name
        end,
        'mimeType', case
          when material.file_path = ''
            or not material.storage_file_exists then ''
          when material.is_anonymous
              and split_part(material.file_path, '/', 1) <> 'bank' then ''
          else coalesce(material.mime_type, '')
        end,
        'fileSize', case
          when material.file_path = ''
            or not material.storage_file_exists then 0
          when material.is_anonymous
              and split_part(material.file_path, '/', 1) <> 'bank' then 0
          else material.file_size
        end,
        'hasFile', material.file_path <> ''
          and material.storage_file_exists
          and (
          not material.is_anonymous
          or split_part(material.file_path, '/', 1) = 'bank'
        ),
        'requiresRepublish', material.file_path <> ''
          and material.is_anonymous
          and split_part(material.file_path, '/', 1) <> 'bank',
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
    select
      source_material.*,
      exists (
        select 1
        from storage.objects stored_object
        where stored_object.bucket_id = 'lesson-materials'
          and stored_object.name = source_material.file_path
      ) as storage_file_exists
    from core.lesson_materials source_material
    where source_material.organization_id = p_organization_id
      and source_material.is_public
    order by source_material.download_count desc,
      source_material.created_at desc
    limit least(greatest(coalesce(p_limit, 50), 0), 100)
  ) material;

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
  if v_material.file_path = '' or not exists (
    select 1
    from storage.objects stored_object
    where stored_object.bucket_id = 'lesson-materials'
      and stored_object.name = v_material.file_path
  ) then
    raise exception 'Material does not have a file' using errcode = '22023';
  end if;
  if v_material.is_anonymous
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

create or replace function app_api_v1.get_public_materials(
  p_organization_id text,
  p_limit integer default 50
)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select app_api_v1.list_public_materials_v1(
    p_organization_id,
    p_limit
  );
$$;

revoke all on function app_api_v1.list_public_materials_v1(text, integer)
from public, anon;
grant execute on function app_api_v1.list_public_materials_v1(text, integer)
to authenticated, service_role;
