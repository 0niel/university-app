-- create_lesson_material: shared upload throttle (hour + day), length caps,
-- and a file-size ceiling matching the 50 MB bucket limit.
create or replace function app_api_v1.create_lesson_material(
  p_organization_id text, p_subject_name text, p_lesson_date date,
  p_lesson_bells_number integer, p_lesson_uid text, p_material_type text,
  p_title text, p_file_name text, p_file_path text, p_mime_type text,
  p_file_size bigint, p_is_public boolean, p_is_anonymous boolean)
  returns jsonb language plpgsql set search_path to ''
as $function$
declare
  v_user_id uuid := (select auth.uid());
  v_row core.lesson_materials;
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('upload_material', 30, interval '1 hour');
  perform core.enforce_rate_limit('upload_material', 150, interval '1 day');

  if split_part(p_file_path, '/', 1) <> v_user_id::text then
    raise exception 'File path must start with the current user id';
  end if;
  if coalesce(p_file_size, 0) < 0 or coalesce(p_file_size, 0) > 52428800 then
    raise exception 'Файл слишком большой (максимум 50 МБ)' using errcode = '22023';
  end if;

  insert into core.lesson_materials (
    organization_id, user_id, subject_name, lesson_date, lesson_bells_number,
    lesson_uid, material_type, title, file_name, file_path, mime_type,
    file_size, is_public, is_anonymous)
  values (
    p_organization_id, v_user_id,
    core.validate_text(p_subject_name, 'Предмет', 300, false),
    p_lesson_date, p_lesson_bells_number,
    nullif(trim(coalesce(p_lesson_uid, '')), ''),
    core.validate_text(p_material_type, 'Тип', 40, false),
    core.validate_text(p_title, 'Название', 200, true),
    core.validate_text(p_file_name, 'Имя файла', 300, false),
    p_file_path, nullif(trim(coalesce(p_mime_type, '')), ''),
    p_file_size, coalesce(p_is_public, true), coalesce(p_is_anonymous, false))
  returning * into v_row;

  if v_row.is_public then
    perform core.apply_shuriken_delta(
      v_user_id, '📘', 'Залил материал «' || left(p_title, 60) || '»', 30);
  end if;

  return jsonb_build_object(
    'id', v_row.id, 'type', v_row.material_type, 'title', v_row.title,
    'fileName', v_row.file_name, 'filePath', v_row.file_path,
    'mimeType', v_row.mime_type, 'fileSize', v_row.file_size,
    'isPublic', v_row.is_public, 'isAnonymous', v_row.is_anonymous,
    'downloadCount', v_row.download_count, 'likeCount', v_row.like_count,
    'authorName', case when v_row.is_anonymous then 'Аноним' else 'Студент' end,
    'createdAt', v_row.created_at);
end;
$function$;

create or replace function app_api_v1.create_public_material(
  p_organization_id text, p_title text, p_subject_name text,
  p_material_type text default 'note'::text, p_price integer default 0,
  p_pages integer default 0, p_is_anonymous boolean default false,
  p_file_name text default ''::text, p_file_path text default ''::text,
  p_mime_type text default null::text, p_file_size bigint default 0)
  returns uuid language plpgsql set search_path to ''
as $function$
declare
  v_user_id uuid := (select auth.uid());
  v_id uuid;
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('upload_material', 30, interval '1 hour');
  perform core.enforce_rate_limit('upload_material', 150, interval '1 day');

  if p_file_path <> '' and split_part(p_file_path, '/', 1) <> v_user_id::text then
    raise exception 'File path must start with the current user id';
  end if;
  if coalesce(p_file_size, 0) < 0 or coalesce(p_file_size, 0) > 52428800 then
    raise exception 'Файл слишком большой (максимум 50 МБ)' using errcode = '22023';
  end if;

  insert into core.lesson_materials (
    organization_id, user_id, subject_name, lesson_date, lesson_bells_number,
    material_type, title, file_name, file_path, mime_type, file_size,
    is_public, is_anonymous, metadata)
  values (
    p_organization_id, v_user_id,
    core.validate_text(p_subject_name, 'Предмет', 300, false),
    current_date, 0, core.validate_text(p_material_type, 'Тип', 40, false),
    core.validate_text(p_title, 'Название', 200, true),
    core.validate_text(p_file_name, 'Имя файла', 300, false),
    coalesce(p_file_path, ''), nullif(trim(coalesce(p_mime_type, '')), ''),
    coalesce(p_file_size, 0), true, coalesce(p_is_anonymous, false),
    jsonb_build_object(
      'price', least(greatest(coalesce(p_price, 0), 0), 1000000),
      'pages', least(greatest(coalesce(p_pages, 0), 0), 100000)))
  returning id into v_id;

  perform core.apply_shuriken_delta(
    v_user_id, '📘', 'Залил материал «' || left(p_title, 60) || '»', 30);
  return v_id;
end;
$function$;

create or replace function app_api_v1.create_lost_found_item(
  p_organization_id text, p_item_name text, p_status text,
  p_description text default null::text, p_telegram text default null::text,
  p_phone text default null::text, p_author_email text default ''::text,
  p_category text default 'other'::text, p_location text default ''::text,
  p_images jsonb default '[]'::jsonb)
  returns jsonb language plpgsql set search_path to ''
as $function$
declare
  v_user_id uuid := (select auth.uid());
  v_id uuid;
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('create_lost_found_item', 10, interval '1 hour');
  perform core.enforce_rate_limit('create_lost_found_item', 30, interval '1 day');

  if p_images is not null then
    if jsonb_typeof(p_images) <> 'array' then
      raise exception 'images must be an array' using errcode = '22023';
    end if;
    if jsonb_array_length(p_images) > 10 then
      raise exception 'Слишком много изображений (максимум 10)' using errcode = '22023';
    end if;
    if octet_length(p_images::text) > 8000 then
      raise exception 'Некорректные данные изображений' using errcode = '22023';
    end if;
  end if;

  insert into core.lost_found_items (
    organization_id, author_id, author_email, item_name, description,
    status, telegram_contact_info, phone_number_contact_info,
    category, location, images)
  values (
    p_organization_id, v_user_id,
    core.validate_text(p_author_email, 'Email', 200, false),
    core.validate_text(p_item_name, 'Название', 200, true),
    nullif(core.validate_text(p_description, 'Описание', 4000, false), ''),
    core.validate_text(p_status, 'Статус', 40, true),
    nullif(core.validate_text(p_telegram, 'Telegram', 100, false), ''),
    nullif(core.validate_text(p_phone, 'Телефон', 40, false), ''),
    core.validate_text(coalesce(p_category, 'other'), 'Категория', 40, false),
    core.validate_text(p_location, 'Место', 200, false),
    coalesce(p_images, '[]'::jsonb))
  returning id into v_id;
  return jsonb_build_object('id', v_id);
end;
$function$;

create or replace function app_api_v1.update_lost_found_item(
  p_id uuid, p_item_name text default null::text,
  p_description text default null::text, p_status text default null::text,
  p_telegram text default null::text, p_phone text default null::text,
  p_category text default null::text, p_location text default null::text)
  returns void language plpgsql set search_path to ''
as $function$
declare v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('update_lost_found_item', 30, interval '1 hour');
  update core.lost_found_items
  set item_name = coalesce(core.validate_text(p_item_name, 'Название', 200, false), item_name),
      description = coalesce(core.validate_text(p_description, 'Описание', 4000, false), description),
      status = coalesce(core.validate_text(p_status, 'Статус', 40, false), status),
      telegram_contact_info = coalesce(core.validate_text(p_telegram, 'Telegram', 100, false), telegram_contact_info),
      phone_number_contact_info = coalesce(core.validate_text(p_phone, 'Телефон', 40, false), phone_number_contact_info),
      category = coalesce(core.validate_text(p_category, 'Категория', 40, false), category),
      location = coalesce(core.validate_text(p_location, 'Место', 200, false), location)
  where id = p_id and author_id = v_user_id;
end;
$function$;
