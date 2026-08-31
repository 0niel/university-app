create or replace function app_api_v1.submit_mini_app(
  p_organization_id text, p_slug text, p_name text,
  p_description text default ''::text, p_icon_emoji text default '🧩'::text,
  p_accent_color text default '#7C5CFF'::text, p_category text default 'other'::text,
  p_tags text[] default '{}'::text[], p_source_kind text default 'hosted'::text,
  p_origin_url text default null::text, p_entry_path text default '/'::text,
  p_screens jsonb default '[]'::jsonb, p_permissions text[] default '{}'::text[],
  p_as_draft boolean default false)
  returns jsonb language plpgsql set search_path to ''
as $function$
declare
  v_user_id uuid := (select auth.uid());
  v_id uuid;
  v_slug text;
  v_screen jsonb;
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('submit_mini_app', 10, interval '1 hour');

  v_slug := lower(trim(coalesce(p_slug, '')));
  if v_slug !~ '^[a-z0-9][a-z0-9_-]{1,63}$' then
    raise exception 'Некорректный slug' using errcode = '22023';
  end if;
  if p_origin_url is not null and p_origin_url !~* '^https?://' then
    raise exception 'origin_url должен начинаться с https://' using errcode = '22023';
  end if;
  if array_length(p_tags, 1) > 20 or array_length(p_permissions, 1) > 40 then
    raise exception 'Слишком много тегов или разрешений' using errcode = '22023';
  end if;
  if jsonb_array_length(coalesce(p_screens, '[]'::jsonb)) > 50
     or octet_length(coalesce(p_screens, '[]'::jsonb)::text) > 1048576 then
    raise exception 'Слишком большой набор экранов' using errcode = '22023';
  end if;
  if p_source_kind = 'hosted'
     and jsonb_array_length(coalesce(p_screens, '[]'::jsonb)) = 0 then
    raise exception 'Hosted mini apps need at least one screen';
  end if;

  insert into core.mini_apps (
    organization_id, owner_id, slug, name, description, icon_emoji,
    accent_color, category, tags, source_kind, origin_url, entry_path,
    requested_permissions, status)
  values (
    p_organization_id, v_user_id, v_slug,
    core.validate_text(p_name, 'Название', 100, true),
    core.validate_text(p_description, 'Описание', 4000, false),
    left(coalesce(p_icon_emoji, '🧩'), 16),
    left(coalesce(p_accent_color, '#7C5CFF'), 16),
    core.validate_text(coalesce(p_category, 'other'), 'Категория', 40, false),
    coalesce(p_tags, '{}'), coalesce(p_source_kind, 'hosted'),
    p_origin_url, left(coalesce(p_entry_path, '/'), 300),
    coalesce(p_permissions, '{}'),
    case when p_as_draft then 'draft' else 'pending_review' end)
  returning id into v_id;

  for v_screen in select value from jsonb_array_elements(coalesce(p_screens, '[]'::jsonb)) loop
    insert into core.mini_app_screens (app_id, path, title, json)
    values (v_id, coalesce(v_screen ->> 'path', '/'), v_screen ->> 'title',
            coalesce(v_screen -> 'json', '{}'::jsonb));
  end loop;
  perform core.snapshot_mini_app_screens(v_id, 1);
  return jsonb_build_object('id', v_id);
end;
$function$;

create or replace function app_api_v1.update_mini_app(
  p_app_id uuid, p_name text default null::text, p_description text default null::text,
  p_icon_emoji text default null::text, p_accent_color text default null::text,
  p_category text default null::text, p_tags text[] default null::text[],
  p_origin_url text default null::text, p_entry_path text default null::text,
  p_screens jsonb default null::jsonb, p_permissions text[] default null::text[],
  p_submit boolean default true)
  returns void language plpgsql set search_path to ''
as $function$
declare
  v_user_id uuid := (select auth.uid());
  v_app core.mini_apps;
  v_screen jsonb;
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('update_mini_app', 30, interval '1 hour');
  select * into v_app from core.mini_apps
  where id = p_app_id and owner_id = v_user_id for update;
  if not found then
    raise exception 'Mini app not found or not owned by you';
  end if;
  if v_app.status = 'suspended' then
    raise exception 'Suspended mini apps cannot be edited';
  end if;
  if p_origin_url is not null and p_origin_url !~* '^https?://' then
    raise exception 'origin_url должен начинаться с https://' using errcode = '22023';
  end if;
  if array_length(p_tags, 1) > 20 or array_length(p_permissions, 1) > 40 then
    raise exception 'Слишком много тегов или разрешений' using errcode = '22023';
  end if;
  if p_screens is not null
     and (jsonb_array_length(p_screens) > 50
          or octet_length(p_screens::text) > 1048576) then
    raise exception 'Слишком большой набор экранов' using errcode = '22023';
  end if;

  update core.mini_apps
  set name = case when p_name is null then name
                  else core.validate_text(p_name, 'Название', 100, true) end,
      description = case when p_description is null then description
                        else core.validate_text(p_description, 'Описание', 4000, false) end,
      icon_emoji = left(coalesce(p_icon_emoji, icon_emoji), 16),
      accent_color = left(coalesce(p_accent_color, accent_color), 16),
      category = coalesce(p_category, category),
      tags = coalesce(p_tags, tags),
      origin_url = coalesce(p_origin_url, origin_url),
      entry_path = left(coalesce(p_entry_path, entry_path), 300),
      requested_permissions = coalesce(p_permissions, requested_permissions),
      version = version + 1,
      status = case when p_submit then 'pending_review' else 'draft' end
  where id = p_app_id;

  if p_screens is not null then
    delete from core.mini_app_screens where app_id = p_app_id;
    for v_screen in select value from jsonb_array_elements(p_screens) loop
      insert into core.mini_app_screens (app_id, path, title, json)
      values (p_app_id, coalesce(v_screen ->> 'path', '/'), v_screen ->> 'title',
              coalesce(v_screen -> 'json', '{}'::jsonb));
    end loop;
    perform core.snapshot_mini_app_screens(p_app_id, v_app.version + 1);
  end if;
end;
$function$;

-- report_mini_app: add auth gate + rate limit + length caps.
create or replace function app_api_v1.report_mini_app(
  p_app_id uuid, p_reason text, p_details text default ''::text)
  returns void language plpgsql set search_path to ''
as $function$
declare v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('report_mini_app', 20, interval '1 hour');
  insert into core.mini_app_reports (app_id, reporter_id, reason, details)
  values (p_app_id, v_user_id,
          core.validate_text(p_reason, 'Причина', 200, true),
          core.validate_text(p_details, 'Детали', 2000, false))
  on conflict (app_id, reporter_id) where status = 'open'
  do update set reason = excluded.reason, details = excluded.details;
end;
$function$;

-- rate_mini_app: add auth gate + rate limit + bound rating.
create or replace function app_api_v1.rate_mini_app(p_app_id uuid, p_rating integer)
  returns void language plpgsql set search_path to ''
as $function$
declare v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('rate_mini_app', 60, interval '1 hour');
  insert into core.mini_app_ratings (app_id, user_id, rating)
  values (p_app_id, v_user_id, greatest(1, least(5, coalesce(p_rating, 0))))
  on conflict (app_id, user_id) do update set rating = excluded.rating;
end;
$function$;
