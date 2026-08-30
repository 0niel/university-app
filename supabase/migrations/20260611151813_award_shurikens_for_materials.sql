-- «За материал начислим +30 шурикенов» из шторки загрузки — теперь
-- реально начисляем (только за публичные материалы).

create or replace function app_api_v1.create_lesson_material(
  p_organization_id text,
  p_subject_name text,
  p_lesson_date date,
  p_lesson_bells_number integer,
  p_lesson_uid text,
  p_material_type text,
  p_title text,
  p_file_name text,
  p_file_path text,
  p_mime_type text,
  p_file_size bigint,
  p_is_public boolean,
  p_is_anonymous boolean
)
returns jsonb
language plpgsql
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_row core.lesson_materials;
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;

  if split_part(p_file_path, '/', 1) <> v_user_id::text then
    raise exception 'File path must start with the current user id';
  end if;

  insert into core.lesson_materials (
    organization_id,
    user_id,
    subject_name,
    lesson_date,
    lesson_bells_number,
    lesson_uid,
    material_type,
    title,
    file_name,
    file_path,
    mime_type,
    file_size,
    is_public,
    is_anonymous
  )
  values (
    p_organization_id,
    v_user_id,
    p_subject_name,
    p_lesson_date,
    p_lesson_bells_number,
    nullif(trim(coalesce(p_lesson_uid, '')), ''),
    p_material_type,
    p_title,
    p_file_name,
    p_file_path,
    nullif(trim(coalesce(p_mime_type, '')), ''),
    p_file_size,
    coalesce(p_is_public, true),
    coalesce(p_is_anonymous, false)
  )
  returning * into v_row;

  if v_row.is_public then
    perform core.apply_shuriken_delta(
      v_user_id, '📘', 'Залил материал «' || left(p_title, 60) || '»', 30
    );
  end if;

  return jsonb_build_object(
    'id', v_row.id,
    'type', v_row.material_type,
    'title', v_row.title,
    'fileName', v_row.file_name,
    'filePath', v_row.file_path,
    'mimeType', v_row.mime_type,
    'fileSize', v_row.file_size,
    'isPublic', v_row.is_public,
    'isAnonymous', v_row.is_anonymous,
    'downloadCount', v_row.download_count,
    'likeCount', v_row.like_count,
    'authorName', case when v_row.is_anonymous then 'Аноним' else 'Студент' end,
    'createdAt', v_row.created_at
  );
end;
$$;

-- То же для материалов из Банка знаний (без файла).
create or replace function app_api_v1.create_public_material(
  p_organization_id text,
  p_title text,
  p_subject_name text,
  p_material_type text default 'note',
  p_price integer default 0,
  p_pages integer default 0
)
returns uuid
language plpgsql
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_id uuid;
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;
  insert into core.lesson_materials (
    organization_id, user_id, subject_name, lesson_date,
    lesson_bells_number, material_type, title, file_name, file_path,
    is_public, metadata
  )
  values (
    p_organization_id, v_user_id, coalesce(p_subject_name, ''),
    current_date, 0, coalesce(p_material_type, 'note'), p_title, '', '',
    true,
    jsonb_build_object(
      'price', greatest(coalesce(p_price, 0), 0),
      'pages', greatest(coalesce(p_pages, 0), 0)
    )
  )
  returning id into v_id;

  perform core.apply_shuriken_delta(
    v_user_id, '📘', 'Залил материал «' || left(p_title, 60) || '»', 30
  );
  return v_id;
end;
$$;
