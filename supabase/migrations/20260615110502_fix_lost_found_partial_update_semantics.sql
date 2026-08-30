-- validate_text returns '' (never NULL) for NULL input, which broke the
-- "NULL means keep existing" contract of the partial update. Validate only
-- when a value is actually supplied.
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
  set item_name = case when p_item_name is null then item_name
                       else core.validate_text(p_item_name, 'Название', 200, true) end,
      description = case when p_description is null then description
                        else core.validate_text(p_description, 'Описание', 4000, false) end,
      status = case when p_status is null then status
                    else core.validate_text(p_status, 'Статус', 40, true) end,
      telegram_contact_info = case when p_telegram is null then telegram_contact_info
                                   else core.validate_text(p_telegram, 'Telegram', 100, false) end,
      phone_number_contact_info = case when p_phone is null then phone_number_contact_info
                                       else core.validate_text(p_phone, 'Телефон', 40, false) end,
      category = case when p_category is null then category
                      else core.validate_text(p_category, 'Категория', 40, true) end,
      location = case when p_location is null then location
                      else core.validate_text(p_location, 'Место', 200, false) end
  where id = p_id and author_id = v_user_id;
end;
$function$;

-- Preserve NULL (not '') for optional contact/description fields on insert,
-- matching the prior behaviour the UI expects.
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
