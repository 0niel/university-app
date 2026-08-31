insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
values (
  'lesson-materials',
  'lesson-materials',
  false,
  52428800,
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
    'application/octet-stream'
  ]::text[]
)
on conflict (id) do update
set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

create table core.lesson_materials (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  subject_name text not null,
  lesson_date date not null,
  lesson_bells_number integer not null,
  lesson_uid text,
  material_type text not null,
  title text not null,
  file_name text not null,
  file_path text not null unique,
  mime_type text,
  file_size bigint not null default 0,
  is_public boolean not null default true,
  is_anonymous boolean not null default false,
  download_count integer not null default 0,
  like_count integer not null default 0,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint lesson_materials_subject_not_empty
    check (length(trim(subject_name)) > 0),
  constraint lesson_materials_lesson_bells_number_positive
    check (lesson_bells_number > 0),
  constraint lesson_materials_material_type_valid
    check (material_type in ('note', 'board', 'task', 'extra')),
  constraint lesson_materials_title_not_empty
    check (length(trim(title)) > 0),
  constraint lesson_materials_file_name_not_empty
    check (length(trim(file_name)) > 0),
  constraint lesson_materials_file_path_not_empty
    check (length(trim(file_path)) > 0),
  constraint lesson_materials_file_size_valid
    check (file_size >= 0 and file_size <= 52428800),
  constraint lesson_materials_metadata_is_object
    check (jsonb_typeof(metadata) = 'object')
);

create index lesson_materials_lesson_idx
on core.lesson_materials (
  organization_id,
  subject_name,
  lesson_date,
  lesson_bells_number,
  created_at desc
);

create index lesson_materials_user_idx
on core.lesson_materials (user_id, created_at desc);

create trigger set_lesson_materials_updated_at
before update on core.lesson_materials
for each row execute function core.set_updated_at();

create table core.lesson_reviews (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  subject_name text not null,
  lesson_date date not null,
  lesson_bells_number integer not null,
  lesson_uid text,
  body text not null,
  rating integer,
  is_anonymous boolean not null default false,
  like_count integer not null default 0,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint lesson_reviews_subject_not_empty
    check (length(trim(subject_name)) > 0),
  constraint lesson_reviews_lesson_bells_number_positive
    check (lesson_bells_number > 0),
  constraint lesson_reviews_body_not_empty
    check (length(trim(body)) > 0 and length(body) <= 800),
  constraint lesson_reviews_rating_valid
    check (rating is null or rating between 1 and 5),
  constraint lesson_reviews_metadata_is_object
    check (jsonb_typeof(metadata) = 'object'),
  constraint lesson_reviews_unique_user_lesson unique (
    user_id,
    organization_id,
    subject_name,
    lesson_date,
    lesson_bells_number
  )
);

create index lesson_reviews_lesson_idx
on core.lesson_reviews (
  organization_id,
  subject_name,
  lesson_date,
  lesson_bells_number,
  created_at desc
);

create trigger set_lesson_reviews_updated_at
before update on core.lesson_reviews
for each row execute function core.set_updated_at();

alter table core.lesson_materials enable row level security;
alter table core.lesson_reviews enable row level security;

create policy "public can read public lesson materials"
on core.lesson_materials
for select
to anon, authenticated
using (is_public or (select auth.uid()) = user_id);

create policy "users can insert own lesson materials"
on core.lesson_materials
for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "users can update own lesson materials"
on core.lesson_materials
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "users can delete own lesson materials"
on core.lesson_materials
for delete
to authenticated
using ((select auth.uid()) = user_id);

create policy "public can read lesson reviews"
on core.lesson_reviews
for select
to anon, authenticated
using (true);

create policy "users can insert own lesson reviews"
on core.lesson_reviews
for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "users can update own lesson reviews"
on core.lesson_reviews
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "users can delete own lesson reviews"
on core.lesson_reviews
for delete
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "public can read linked lesson material files"
on storage.objects;

create policy "public can read linked lesson material files"
on storage.objects
for select
to anon, authenticated
using (
  bucket_id = 'lesson-materials'
  and exists (
    select 1
    from core.lesson_materials lm
    where lm.file_path = storage.objects.name
      and (lm.is_public or lm.user_id = (select auth.uid()))
  )
);

drop policy if exists "users can upload own lesson material files"
on storage.objects;

create policy "users can upload own lesson material files"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'lesson-materials'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

drop policy if exists "users can update own lesson material files"
on storage.objects;

create policy "users can update own lesson material files"
on storage.objects
for update
to authenticated
using (
  bucket_id = 'lesson-materials'
  and (storage.foldername(name))[1] = (select auth.uid())::text
)
with check (
  bucket_id = 'lesson-materials'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

drop policy if exists "users can delete own lesson material files"
on storage.objects;

create policy "users can delete own lesson material files"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'lesson-materials'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

grant select on core.lesson_materials to anon, authenticated;
grant insert, update, delete on core.lesson_materials to authenticated;
grant select on core.lesson_reviews to anon, authenticated;
grant insert, update, delete on core.lesson_reviews to authenticated;
grant all on core.lesson_materials to service_role;
grant all on core.lesson_reviews to service_role;

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
        'createdAt', lm.created_at
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
security invoker
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

create or replace function app_api_v1.get_lesson_reviews(
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
        'id', lr.id,
        'body', lr.body,
        'rating', lr.rating,
        'isAnonymous', lr.is_anonymous,
        'likeCount', lr.like_count,
        'authorName',
          case
            when lr.is_anonymous then 'Аноним'
            else coalesce(nullif(lr.metadata ->> 'author_name', ''), 'Студент')
          end,
        'createdAt', lr.created_at
      )
      order by lr.created_at desc
    ),
    '[]'::jsonb
  )
  from core.lesson_reviews lr
  where lr.organization_id = p_organization_id
    and lr.subject_name = p_subject_name
    and lr.lesson_date = p_lesson_date
    and lr.lesson_bells_number = p_lesson_bells_number;
$$;

create or replace function app_api_v1.upsert_lesson_review(
  p_organization_id text,
  p_subject_name text,
  p_lesson_date date,
  p_lesson_bells_number integer,
  p_lesson_uid text,
  p_body text,
  p_rating integer,
  p_is_anonymous boolean
)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;

  insert into core.lesson_reviews (
    organization_id,
    user_id,
    subject_name,
    lesson_date,
    lesson_bells_number,
    lesson_uid,
    body,
    rating,
    is_anonymous
  )
  values (
    p_organization_id,
    v_user_id,
    p_subject_name,
    p_lesson_date,
    p_lesson_bells_number,
    nullif(trim(coalesce(p_lesson_uid, '')), ''),
    p_body,
    p_rating,
    coalesce(p_is_anonymous, false)
  )
  on conflict (
    user_id,
    organization_id,
    subject_name,
    lesson_date,
    lesson_bells_number
  ) do update
  set
    body = excluded.body,
    rating = excluded.rating,
    is_anonymous = excluded.is_anonymous,
    lesson_uid = excluded.lesson_uid;

  return app_api_v1.get_lesson_reviews(
    p_organization_id,
    p_subject_name,
    p_lesson_date,
    p_lesson_bells_number
  );
end;
$$;

create or replace function public.get_lesson_materials(
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
  select app_api_v1.get_lesson_materials(
    p_organization_id,
    p_subject_name,
    p_lesson_date,
    p_lesson_bells_number
  );
$$;

create or replace function public.create_lesson_material(
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
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.create_lesson_material(
    p_organization_id,
    p_subject_name,
    p_lesson_date,
    p_lesson_bells_number,
    p_lesson_uid,
    p_material_type,
    p_title,
    p_file_name,
    p_file_path,
    p_mime_type,
    p_file_size,
    p_is_public,
    p_is_anonymous
  );
$$;

create or replace function public.get_lesson_reviews(
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
  select app_api_v1.get_lesson_reviews(
    p_organization_id,
    p_subject_name,
    p_lesson_date,
    p_lesson_bells_number
  );
$$;

create or replace function public.upsert_lesson_review(
  p_organization_id text,
  p_subject_name text,
  p_lesson_date date,
  p_lesson_bells_number integer,
  p_lesson_uid text,
  p_body text,
  p_rating integer,
  p_is_anonymous boolean
)
returns jsonb
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.upsert_lesson_review(
    p_organization_id,
    p_subject_name,
    p_lesson_date,
    p_lesson_bells_number,
    p_lesson_uid,
    p_body,
    p_rating,
    p_is_anonymous
  );
$$;

revoke all on function public.get_lesson_materials(text, text, date, integer)
from public;
grant execute on function public.get_lesson_materials(text, text, date, integer)
to anon, authenticated;

revoke all on function public.create_lesson_material(
  text,
  text,
  date,
  integer,
  text,
  text,
  text,
  text,
  text,
  text,
  bigint,
  boolean,
  boolean
) from public;
grant execute on function public.create_lesson_material(
  text,
  text,
  date,
  integer,
  text,
  text,
  text,
  text,
  text,
  text,
  bigint,
  boolean,
  boolean
) to authenticated;

revoke all on function public.get_lesson_reviews(text, text, date, integer)
from public;
grant execute on function public.get_lesson_reviews(text, text, date, integer)
to anon, authenticated;

revoke all on function public.upsert_lesson_review(
  text,
  text,
  date,
  integer,
  text,
  text,
  integer,
  boolean
) from public;
grant execute on function public.upsert_lesson_review(
  text,
  text,
  date,
  integer,
  text,
  text,
  integer,
  boolean
) to authenticated;
