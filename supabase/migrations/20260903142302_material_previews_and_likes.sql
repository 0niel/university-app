insert into storage.buckets (
  id, name, public, file_size_limit, allowed_mime_types
)
values (
  'lesson-materials', 'lesson-materials', false, 104857600,
  array[
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-powerpoint',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'application/vnd.ms-excel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'application/zip',
    'text/plain',
    'text/markdown',
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/heic',
    'image/gif',
    'video/mp4',
    'video/quicktime',
    'video/webm',
    'application/octet-stream'
  ]::text[]
)
on conflict (id) do update
set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

alter table core.lesson_materials
add column if not exists preview_path text,
add column if not exists batch_id uuid,
add column if not exists width integer,
add column if not exists height integer,
add column if not exists duration_seconds integer;

alter table core.lesson_materials
drop constraint if exists lesson_materials_preview_path_valid;

alter table core.lesson_materials
add constraint lesson_materials_preview_path_valid check (
  preview_path is null or (
    preview_path <> file_path
    and split_part(preview_path, '/', 1) = user_id::text
  )
);

alter table core.lesson_materials
drop constraint if exists lesson_materials_dimensions_valid;

alter table core.lesson_materials
add constraint lesson_materials_dimensions_valid check (
  (width is null or width between 1 and 20000)
  and (height is null or height between 1 and 20000)
  and (duration_seconds is null or duration_seconds between 0 and 86400)
);

create index if not exists lesson_materials_batch_id_idx
on core.lesson_materials(batch_id)
where batch_id is not null;

create table if not exists core.material_likes (
  user_id uuid not null references auth.users(id) on delete cascade,
  material_id uuid not null references core.lesson_materials(id) on delete cascade,
  organization_id text not null references core.organizations(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, material_id)
);

create index if not exists material_likes_material_id_idx
on core.material_likes(material_id);

alter table core.material_likes enable row level security;
revoke all on core.material_likes from public, anon, authenticated;
grant select on core.material_likes to authenticated;
grant all on core.material_likes to service_role;

drop policy if exists "users read own material likes" on core.material_likes;
create policy "users read own material likes"
on core.material_likes for select to authenticated
using (user_id = (select auth.uid()));

create or replace function core.sync_material_like_count()
returns trigger
language plpgsql security definer set search_path = ''
as $$
begin
  if tg_op = 'INSERT' then
    update core.lesson_materials
    set like_count = like_count + 1
    where id = new.material_id;
    return new;
  elsif tg_op = 'DELETE' then
    update core.lesson_materials
    set like_count = greatest(like_count - 1, 0)
    where id = old.material_id;
    return old;
  end if;
  return null;
end;
$$;

drop trigger if exists material_likes_sync_count on core.material_likes;
create trigger material_likes_sync_count
after insert or delete on core.material_likes
for each row execute function core.sync_material_like_count();

revoke all on function core.sync_material_like_count() from public, anon, authenticated;

create or replace function core.require_material_preview(p_preview_path text)
returns void
language plpgsql security invoker set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
begin
  if p_preview_path is null then
    return;
  end if;
  if v_uid is null or split_part(p_preview_path, '/', 1) <> v_uid::text
    or p_preview_path ~ '(^|/)\.\.?(/|$)' then
    raise exception 'Preview ownership required' using errcode = '42501';
  end if;
  if not exists (
    select 1 from storage.objects object
    where object.bucket_id = 'lesson-materials' and object.name = p_preview_path
      and coalesce(nullif(object.owner_id, ''), object.owner::text) = v_uid::text
      and object.archived_at is null and not object.is_delete_marker
      and coalesce(object.metadata ->> 'mimetype', '') like 'image/%'
  ) then
    raise exception 'Owned preview image required' using errcode = '42501';
  end if;
end;
$$;

revoke all on function core.require_material_preview(text) from public, anon, authenticated;

create or replace function app_api_v1.create_public_material_v3(
  p_organization_id text, p_title text, p_subject_names text[],
  p_material_type text default 'note', p_price integer default 0,
  p_pages integer default 0, p_is_anonymous boolean default false,
  p_file_name text default '', p_file_path text default '',
  p_mime_type text default null, p_file_size bigint default 0,
  p_preview_path text default null, p_width integer default null,
  p_height integer default null, p_duration_seconds integer default null,
  p_batch_id uuid default null
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
  perform core.require_material_preview(p_preview_path);
  if p_width is not null and p_width not between 1 and 20000
    or p_height is not null and p_height not between 1 and 20000
    or p_duration_seconds is not null and p_duration_seconds not between 0 and 86400 then
    raise exception 'Invalid material dimensions' using errcode = '22023';
  end if;
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
    is_public, is_anonymous, metadata, preview_path, width, height,
    duration_seconds, batch_id
  ) values (
    p_organization_id, v_uid, v_subjects[1], current_date, 0,
    p_material_type, v_title, v_file_name, p_file_path,
    coalesce(nullif(trim(p_mime_type), ''), 'application/octet-stream'), p_file_size,
    true, coalesce(p_is_anonymous, false), jsonb_build_object(
      'price', p_price, 'pages', p_pages, 'subjectNames', v_subjects,
      'storageObjectId', v_object_id
    ), p_preview_path, p_width, p_height, p_duration_seconds, p_batch_id
  ) returning id into v_id;
  perform core.reward_material_upload(v_id, v_object_id);
  return v_id;
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
language sql security invoker set search_path = ''
as $$
  select app_api_v1.create_public_material_v3(
    p_organization_id, p_title, p_subject_names, p_material_type,
    p_price, p_pages, p_is_anonymous, p_file_name, p_file_path,
    p_mime_type, p_file_size
  );
$$;

create or replace function public.create_public_material_v3(
  p_organization_id text, p_title text, p_subject_names text[],
  p_material_type text default 'note', p_price integer default 0,
  p_pages integer default 0, p_is_anonymous boolean default false,
  p_file_name text default '', p_file_path text default '',
  p_mime_type text default null, p_file_size bigint default 0,
  p_preview_path text default null, p_width integer default null,
  p_height integer default null, p_duration_seconds integer default null,
  p_batch_id uuid default null
)
returns uuid
language sql security invoker set search_path = ''
as $$
  select app_api_v1.create_public_material_v3(
    p_organization_id, p_title, p_subject_names, p_material_type,
    p_price, p_pages, p_is_anonymous, p_file_name, p_file_path,
    p_mime_type, p_file_size, p_preview_path, p_width, p_height,
    p_duration_seconds, p_batch_id
  );
$$;

create or replace function app_api_v1.create_lesson_material_v2(
  p_organization_id text, p_subject_name text, p_lesson_date date,
  p_lesson_bells_number integer, p_lesson_uid text, p_material_type text,
  p_title text, p_file_name text, p_file_path text, p_mime_type text,
  p_file_size bigint, p_is_public boolean, p_is_anonymous boolean,
  p_preview_path text default null, p_width integer default null,
  p_height integer default null, p_duration_seconds integer default null,
  p_batch_id uuid default null
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
  perform core.require_material_preview(p_preview_path);
  if p_width is not null and p_width not between 1 and 20000
    or p_height is not null and p_height not between 1 and 20000
    or p_duration_seconds is not null and p_duration_seconds not between 0 and 86400 then
    raise exception 'Invalid material dimensions' using errcode = '22023';
  end if;
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
    is_public, is_anonymous, metadata, preview_path, width, height,
    duration_seconds, batch_id
  ) values (
    p_organization_id, v_uid, core.validate_text(p_subject_name, 'Предмет', 300, true),
    p_lesson_date, p_lesson_bells_number, nullif(trim(coalesce(p_lesson_uid, '')), ''),
    p_material_type, core.validate_text(p_title, 'Название', 200, true),
    core.validate_text(p_file_name, 'Имя файла', 300, true), p_file_path,
    coalesce(nullif(trim(p_mime_type), ''), 'application/octet-stream'), p_file_size,
    coalesce(p_is_public, true), coalesce(p_is_anonymous, false),
    jsonb_build_object('storageObjectId', v_object_id), p_preview_path, p_width,
    p_height, p_duration_seconds, p_batch_id
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
    'createdAt', v_row.created_at, 'previewPath', v_row.preview_path,
    'width', v_row.width, 'height', v_row.height,
    'durationSeconds', v_row.duration_seconds, 'batchId', v_row.batch_id
  );
end;
$$;

create or replace function public.create_lesson_material_v2(
  p_organization_id text, p_subject_name text, p_lesson_date date,
  p_lesson_bells_number integer, p_lesson_uid text, p_material_type text,
  p_title text, p_file_name text, p_file_path text, p_mime_type text,
  p_file_size bigint, p_is_public boolean, p_is_anonymous boolean,
  p_preview_path text default null, p_width integer default null,
  p_height integer default null, p_duration_seconds integer default null,
  p_batch_id uuid default null
)
returns jsonb
language sql security invoker set search_path = ''
as $$
  select app_api_v1.create_lesson_material_v2(
    p_organization_id, p_subject_name, p_lesson_date, p_lesson_bells_number,
    p_lesson_uid, p_material_type, p_title, p_file_name, p_file_path,
    p_mime_type, p_file_size, p_is_public, p_is_anonymous, p_preview_path,
    p_width, p_height, p_duration_seconds, p_batch_id
  );
$$;

create or replace function app_api_v1.toggle_material_like(p_id uuid)
returns jsonb
language plpgsql security definer set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_material core.lesson_materials;
  v_liked boolean;
  v_likes integer;
begin
  select material.* into v_material from core.lesson_materials material
  join core.user_academic_profiles profile on profile.user_id = v_uid
    and profile.organization_id = material.organization_id
  where material.id = p_id and material.is_public
  for update of material;
  if v_uid is null or not found then
    raise exception 'Material access denied' using errcode = '42501';
  end if;
  perform core.enforce_rate_limit('toggle_material_like', 120, interval '1 hour');
  if exists (
    select 1 from core.material_likes like_row
    where like_row.user_id = v_uid and like_row.material_id = p_id
  ) then
    delete from core.material_likes
    where user_id = v_uid and material_id = p_id;
    v_liked := false;
  else
    insert into core.material_likes (user_id, material_id, organization_id)
    values (v_uid, p_id, v_material.organization_id);
    v_liked := true;
  end if;
  select like_count into strict v_likes from core.lesson_materials where id = p_id;
  return jsonb_build_object('liked', v_liked, 'likes', v_likes);
end;
$$;

create or replace function public.toggle_material_like(p_id uuid)
returns jsonb
language sql security invoker set search_path = ''
as $$ select app_api_v1.toggle_material_like(p_id); $$;

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
    'requiresRepublish', not core.material_file_is_valid(material::core.lesson_materials),
    'previewPath', material.preview_path, 'width', material.width,
    'height', material.height, 'durationSeconds', material.duration_seconds,
    'batchId', material.batch_id,
    'isLiked', exists (
      select 1 from core.material_likes like_row
      where like_row.material_id = material.id and like_row.user_id = v_uid
    )
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

create or replace function app_api_v1.get_lesson_materials(
  p_organization_id text,
  p_subject_name text,
  p_lesson_date date,
  p_lesson_bells_number integer
)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', lm.id,
        'type', lm.material_type,
        'title', lm.title,
        'fileName', lm.file_name,
        'filePath', lm.file_path,
        'mimeType', lm.mime_type,
        'fileSize', lm.file_size,
        'isPublic', lm.is_public,
        'isAnonymous', lm.is_anonymous,
        'downloadCount', lm.download_count,
        'likeCount', lm.like_count,
        'authorName',
          case
            when lm.is_anonymous then 'Аноним'
            else coalesce(nullif(lm.metadata ->> 'author_name', ''), 'Студент')
          end,
        'createdAt', lm.created_at,
        'previewPath', lm.preview_path,
        'width', lm.width,
        'height', lm.height,
        'durationSeconds', lm.duration_seconds,
        'batchId', lm.batch_id,
        'isLiked', exists (
          select 1 from core.material_likes like_row
          where like_row.material_id = lm.id and like_row.user_id = (select auth.uid())
        )
      )
      order by lm.created_at desc
    ),
    '[]'::jsonb
  )
  from core.lesson_materials lm
  where lm.organization_id = p_organization_id
    and lm.subject_name = p_subject_name
    and lm.lesson_date = p_lesson_date
    and lm.lesson_bells_number = p_lesson_bells_number;
$$;

do $$
declare v_signature text;
begin
  foreach v_signature in array array[
    'app_api_v1.create_public_material_v3(text,text,text[],text,integer,integer,boolean,text,text,text,bigint,text,integer,integer,integer,uuid)',
    'app_api_v1.create_lesson_material_v2(text,text,date,integer,text,text,text,text,text,text,bigint,boolean,boolean,text,integer,integer,integer,uuid)',
    'app_api_v1.toggle_material_like(uuid)',
    'public.create_public_material_v3(text,text,text[],text,integer,integer,boolean,text,text,text,bigint,text,integer,integer,integer,uuid)',
    'public.create_lesson_material_v2(text,text,date,integer,text,text,text,text,text,text,bigint,boolean,boolean,text,integer,integer,integer,uuid)',
    'public.toggle_material_like(uuid)'
  ] loop
    execute format('revoke all on function %s from public, anon', v_signature);
    execute format('grant execute on function %s to authenticated, service_role', v_signature);
  end loop;
end;
$$;

notify pgrst, 'reload schema';
