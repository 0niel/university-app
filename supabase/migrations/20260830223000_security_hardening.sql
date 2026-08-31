alter table core.mini_app_push_log
  add column if not exists reservation_id uuid,
  add column if not exists reserved_at timestamptz;

update core.mini_app_push_log
set reservation_id = coalesce(reservation_id, extensions.gen_random_uuid()),
    reserved_at = coalesce(reserved_at, sent_at, now())
where reservation_id is null or reserved_at is null;

alter table core.mini_app_push_log
  alter column reservation_id set not null,
  alter column reservation_id set default extensions.gen_random_uuid(),
  alter column reserved_at set not null,
  alter column reserved_at set default now(),
  alter column sent_at drop not null,
  alter column sent_at drop default;

create unique index if not exists mini_app_push_reservation_user_idx
on core.mini_app_push_log (reservation_id, user_id);

drop index if exists core.mini_app_push_log_idx;
create index mini_app_push_log_idx
on core.mini_app_push_log (app_id, user_id, reserved_at desc, sent_at desc);

create or replace function public.mini_app_notify_context(
  p_token_hash text,
  p_organization_id text,
  p_slug text,
  p_daily_limit integer default 2
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid;
  v_app core.mini_apps;
  v_recipients jsonb;
  v_reservation_id uuid := extensions.gen_random_uuid();
begin
  select user_id into v_user_id
  from core.mini_app_deploy_tokens
  where token_hash = p_token_hash;
  if v_user_id is null then
    return jsonb_build_object('ok', false, 'reason', 'invalid_token');
  end if;

  select * into v_app
  from core.mini_apps
  where organization_id = p_organization_id
    and slug = lower(trim(p_slug))
    and owner_id = v_user_id;
  if not found then
    return jsonb_build_object('ok', false, 'reason', 'app_not_found');
  end if;
  if v_app.status <> 'published' then
    return jsonb_build_object('ok', false, 'reason', 'not_published');
  end if;
  if not ('notifications' = any (v_app.requested_permissions)) then
    return jsonb_build_object('ok', false, 'reason', 'scope_not_requested');
  end if;

  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(v_app.id::text, 0)
  );

  delete from core.mini_app_push_log
  where app_id = v_app.id
    and sent_at is null
    and reserved_at <= now() - interval '15 minutes';

  with eligible as (
    select c.user_id
    from core.mini_app_consents c
    where c.app_id = v_app.id
      and 'notifications' = any (c.scopes)
      and (
        select count(*)
        from core.mini_app_push_log l
        where l.app_id = v_app.id
          and l.user_id = c.user_id
          and (
            l.sent_at > now() - interval '24 hours'
            or (
              l.sent_at is null
              and l.reserved_at > now() - interval '15 minutes'
            )
          )
      ) < least(greatest(coalesce(p_daily_limit, 2), 1), 5)
    limit 5000
  ), reserved as (
    insert into core.mini_app_push_log (
      app_id,
      user_id,
      reservation_id
    )
    select v_app.id, user_id, v_reservation_id
    from eligible
    returning user_id
  )
  select coalesce(jsonb_agg(user_id), '[]'::jsonb)
  into v_recipients
  from reserved;

  return jsonb_build_object(
    'ok', true,
    'appId', v_app.id,
    'appName', v_app.name,
    'slug', v_app.slug,
    'reservationId', v_reservation_id,
    'recipients', v_recipients
  );
end;
$$;

create or replace function public.finalize_mini_app_push(
  p_app_id uuid,
  p_reservation_id uuid,
  p_user_ids uuid[]
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  delete from core.mini_app_push_log
  where app_id = p_app_id
    and reservation_id = p_reservation_id
    and not (user_id = any(coalesce(p_user_ids, '{}'::uuid[])));

  update core.mini_app_push_log
  set sent_at = now()
  where app_id = p_app_id
    and reservation_id = p_reservation_id
    and user_id = any(coalesce(p_user_ids, '{}'::uuid[]));
end;
$$;

drop function if exists public.log_mini_app_push(uuid, uuid[]);
revoke all on function public.mini_app_notify_context(text, text, text, integer)
from public, anon, authenticated;
revoke all on function public.finalize_mini_app_push(uuid, uuid, uuid[])
from public, anon, authenticated;
grant execute on function public.mini_app_notify_context(text, text, text, integer)
to service_role;
grant execute on function public.finalize_mini_app_push(uuid, uuid, uuid[])
to service_role;

create or replace function core.require_lesson_material_upload(
  p_user_id uuid,
  p_file_path text,
  p_expected_size bigint
)
returns uuid
language plpgsql
security definer
set search_path to ''
as $function$
declare
  v_object_id uuid;
  v_actual_size bigint;
begin
  if p_user_id is null or (
    (select auth.uid()) is distinct from p_user_id
    and coalesce((select auth.role()), '') <> 'service_role'
  ) then
    raise exception 'Unauthorized';
  end if;
  if split_part(p_file_path, '/', 1) <> p_user_id::text then
    raise exception 'File path must start with the current user id';
  end if;

  select id, nullif(metadata ->> 'size', '')::bigint
  into v_object_id, v_actual_size
  from storage.objects
  where bucket_id = 'lesson-materials'
    and name = p_file_path
  for update;

  if v_object_id is null then
    raise exception 'Uploaded file not found' using errcode = '22023';
  end if;
  if v_actual_size is null or v_actual_size <> p_expected_size then
    raise exception 'Uploaded file size mismatch' using errcode = '22023';
  end if;

  return v_object_id;
end;
$function$;

revoke all on function core.require_lesson_material_upload(uuid, text, bigint)
from public, anon;
grant execute on function core.require_lesson_material_upload(uuid, text, bigint)
to authenticated, service_role;

create or replace function app_api_v1.create_lesson_material(
  p_organization_id text, p_subject_name text, p_lesson_date date,
  p_lesson_bells_number integer, p_lesson_uid text, p_material_type text,
  p_title text, p_file_name text, p_file_path text, p_mime_type text,
  p_file_size bigint, p_is_public boolean, p_is_anonymous boolean)
returns jsonb
language plpgsql
set search_path to ''
as $function$
declare
  v_user_id uuid := (select auth.uid());
  v_row core.lesson_materials;
  v_storage_object_id uuid;
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('upload_material', 30, interval '1 hour');
  perform core.enforce_rate_limit('upload_material', 150, interval '1 day');

  if coalesce(p_file_size, 0) < 0 or coalesce(p_file_size, 0) > 52428800 then
    raise exception 'Файл слишком большой (максимум 50 МБ)' using errcode = '22023';
  end if;
  v_storage_object_id := core.require_lesson_material_upload(
    v_user_id, p_file_path, p_file_size
  );

  insert into core.lesson_materials (
    organization_id, user_id, subject_name, lesson_date, lesson_bells_number,
    lesson_uid, material_type, title, file_name, file_path, mime_type,
    file_size, is_public, is_anonymous, metadata)
  values (
    p_organization_id, v_user_id,
    core.validate_text(p_subject_name, 'Предмет', 300, false),
    p_lesson_date, p_lesson_bells_number,
    nullif(trim(coalesce(p_lesson_uid, '')), ''),
    core.validate_text(p_material_type, 'Тип', 40, false),
    core.validate_text(p_title, 'Название', 200, true),
    core.validate_text(p_file_name, 'Имя файла', 300, false),
    p_file_path, nullif(trim(coalesce(p_mime_type, '')), ''),
    p_file_size, coalesce(p_is_public, true), coalesce(p_is_anonymous, false),
    jsonb_build_object('storageObjectId', v_storage_object_id))
  returning * into v_row;

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
returns uuid
language plpgsql
set search_path to ''
as $function$
declare
  v_user_id uuid := (select auth.uid());
  v_id uuid;
  v_storage_object_id uuid;
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('upload_material', 30, interval '1 hour');
  perform core.enforce_rate_limit('upload_material', 150, interval '1 day');

  if coalesce(p_file_size, 0) < 0 or coalesce(p_file_size, 0) > 52428800 then
    raise exception 'Файл слишком большой (максимум 50 МБ)' using errcode = '22023';
  end if;
  if coalesce(p_file_path, '') <> '' then
    v_storage_object_id := core.require_lesson_material_upload(
      v_user_id, p_file_path, p_file_size
    );
  elsif coalesce(p_file_size, 0) <> 0 or coalesce(p_file_name, '') <> '' then
    raise exception 'File metadata requires an uploaded file' using errcode = '22023';
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
      'pages', least(greatest(coalesce(p_pages, 0), 0), 100000),
      'storageObjectId', v_storage_object_id))
  returning id into v_id;
  return v_id;
end;
$function$;

revoke all on function app_api_v1.create_lesson_material(
  text, text, date, integer, text, text, text, text, text, text, bigint,
  boolean, boolean
) from public, anon;
grant execute on function app_api_v1.create_lesson_material(
  text, text, date, integer, text, text, text, text, text, text, bigint,
  boolean, boolean
) to authenticated, service_role;
revoke all on function app_api_v1.create_public_material(
  text, text, text, text, integer, integer, boolean, text, text, text, bigint
) from public, anon;
grant execute on function app_api_v1.create_public_material(
  text, text, text, text, integer, integer, boolean, text, text, text, bigint
) to authenticated, service_role;

revoke insert, update, delete on core.user_quest_progress
from authenticated, anon;
drop policy if exists "users can insert own quest progress"
on core.user_quest_progress;
drop policy if exists "users can update own quest progress"
on core.user_quest_progress;
drop function if exists public.increment_quest_progress(text, integer, date);
drop function if exists app_api_v1.increment_quest_progress(text, integer, date);

create or replace function app_api_v1.sync_gamification()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_newly jsonb;
begin
  if v_uid is null then
    raise exception 'Not authenticated' using errcode = '42501';
  end if;
  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(v_uid::text, 182741)
  );
  perform core.refresh_quest_progress(v_uid);
  v_newly := core.evaluate_achievements(v_uid);
  return jsonb_build_object('newlyEarned', v_newly);
end;
$$;

create or replace function internal.run_gamification_sweep()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user record;
begin
  for v_user in select user_id from core.user_gamification_profiles loop
    perform pg_catalog.pg_advisory_xact_lock(
      pg_catalog.hashtextextended(v_user.user_id::text, 182741)
    );
    perform core.refresh_quest_progress(v_user.user_id);
    perform core.evaluate_achievements(v_user.user_id);
  end loop;
end;
$$;

revoke all on function app_api_v1.sync_gamification() from public, anon;
grant execute on function app_api_v1.sync_gamification() to authenticated;
revoke all on function internal.run_gamification_sweep()
from public, anon, authenticated;
