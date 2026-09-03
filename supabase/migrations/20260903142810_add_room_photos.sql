create table if not exists core.room_photos (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id) on delete cascade,
  campus text not null check (char_length(campus) between 1 and 120),
  room_key text not null check (char_length(room_key) between 1 and 120),
  path text not null unique,
  width integer check (width is null or width between 1 and 20000),
  height integer check (height is null or height between 1 and 20000),
  created_by uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create index if not exists room_photos_org_campus_room_idx
on core.room_photos (organization_id, campus, room_key);

alter table core.room_photos enable row level security;
revoke all on core.room_photos from public, anon, authenticated;
grant all on core.room_photos to service_role;

insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
) values (
  'room-photos',
  'room-photos',
  true,
  8388608,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "authenticated users upload own room photos" on storage.objects;
drop policy if exists "owners delete own room photos" on storage.objects;

create policy "authenticated users upload own room photos"
on storage.objects for insert to authenticated
with check (
  bucket_id = 'room-photos'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

create policy "owners delete own room photos"
on storage.objects for delete to authenticated
using (
  bucket_id = 'room-photos'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

create or replace function app_api_v1.get_room_photos(
  p_organization_id text,
  p_campus text,
  p_room_key text
)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_campus text := btrim(coalesce(p_campus, ''));
  v_room_key text := btrim(coalesce(p_room_key, ''));
begin
  if v_uid is null or not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = v_uid
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'Room photos are unavailable' using errcode = '42501';
  end if;
  if v_campus = '' or v_room_key = '' then
    raise exception 'Invalid room' using errcode = '22023';
  end if;
  return (
    select coalesce(jsonb_agg(row.payload order by row.created_at desc), '[]'::jsonb)
    from (
      select
        photo.created_at,
        jsonb_build_object(
          'id', photo.id,
          'path', photo.path,
          'width', photo.width,
          'height', photo.height,
          'createdBy', photo.created_by,
          'authorName', case
            when coalesce(profile.full_name, '') = '' then ''
            else split_part(profile.full_name, ' ', 1)
              || case
                when split_part(profile.full_name, ' ', 2) = '' then ''
                else ' ' || left(split_part(profile.full_name, ' ', 2), 1) || '.'
              end
          end,
          'createdAt', photo.created_at,
          'isMine', photo.created_by = v_uid
        ) as payload
      from core.room_photos photo
      left join core.user_academic_profiles profile
        on profile.user_id = photo.created_by
        and profile.organization_id = photo.organization_id
      where photo.organization_id = p_organization_id
        and photo.campus = v_campus
        and photo.room_key = v_room_key
      order by photo.created_at desc
      limit 100
    ) row
  );
end;
$$;

create or replace function app_api_v1.add_room_photo(
  p_organization_id text,
  p_campus text,
  p_room_key text,
  p_path text,
  p_width integer default null,
  p_height integer default null
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_campus text := core.validate_text(p_campus, 'Кампус', 120, true);
  v_room_key text := core.validate_text(p_room_key, 'Аудитория', 120, true);
  v_path text := btrim(coalesce(p_path, ''));
  v_id uuid;
  v_full_name text;
begin
  if v_uid is null or not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = v_uid
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'Room photos are unavailable' using errcode = '42501';
  end if;
  if v_path = '' or split_part(v_path, '/', 1) <> v_uid::text then
    raise exception 'Invalid photo path' using errcode = '42501';
  end if;
  if not exists (
    select 1 from storage.objects object
    where object.bucket_id = 'room-photos'
      and object.name = v_path
      and coalesce(nullif(object.owner_id, ''), object.owner::text) = v_uid::text
  ) then
    raise exception 'Owned uploaded file required' using errcode = '42501';
  end if;
  if p_width is not null and (p_width <= 0 or p_width > 20000) then
    raise exception 'Invalid photo width' using errcode = '22023';
  end if;
  if p_height is not null and (p_height <= 0 or p_height > 20000) then
    raise exception 'Invalid photo height' using errcode = '22023';
  end if;
  perform core.enforce_rate_limit('add_room_photo', 20, interval '1 hour');
  insert into core.room_photos (
    organization_id, campus, room_key, path, width, height, created_by
  ) values (
    p_organization_id, v_campus, v_room_key, v_path, p_width, p_height, v_uid
  ) returning id into v_id;
  select coalesce(profile.full_name, '') into v_full_name
  from core.user_academic_profiles profile
  where profile.user_id = v_uid and profile.organization_id = p_organization_id;
  return jsonb_build_object(
    'id', v_id,
    'path', v_path,
    'width', p_width,
    'height', p_height,
    'createdBy', v_uid,
    'authorName', case
      when coalesce(v_full_name, '') = '' then ''
      else split_part(v_full_name, ' ', 1)
        || case
          when split_part(v_full_name, ' ', 2) = '' then ''
          else ' ' || left(split_part(v_full_name, ' ', 2), 1) || '.'
        end
    end,
    'createdAt', now(),
    'isMine', true
  );
end;
$$;

create or replace function app_api_v1.delete_room_photo(p_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_path text;
begin
  delete from core.room_photos photo
  where photo.id = p_id
    and photo.created_by = v_uid
  returning photo.path into v_path;
  if not found then
    raise exception 'Room photo is unavailable' using errcode = '42501';
  end if;
  delete from storage.objects object
  where object.bucket_id = 'room-photos'
    and object.name = v_path;
end;
$$;

create or replace function public.get_room_photos(
  p_organization_id text,
  p_campus text,
  p_room_key text
)
returns jsonb language sql stable security definer set search_path = ''
as $$ select app_api_v1.get_room_photos(p_organization_id, p_campus, p_room_key); $$;

create or replace function public.add_room_photo(
  p_organization_id text,
  p_campus text,
  p_room_key text,
  p_path text,
  p_width integer default null,
  p_height integer default null
)
returns jsonb language sql security definer set search_path = ''
as $$
  select app_api_v1.add_room_photo(
    p_organization_id, p_campus, p_room_key, p_path, p_width, p_height
  );
$$;

create or replace function public.delete_room_photo(p_id uuid)
returns void language sql security definer set search_path = ''
as $$ select app_api_v1.delete_room_photo(p_id); $$;

revoke all on function app_api_v1.get_room_photos(text, text, text)
from public, anon, authenticated;
revoke all on function app_api_v1.add_room_photo(text, text, text, text, integer, integer)
from public, anon, authenticated;
revoke all on function app_api_v1.delete_room_photo(uuid)
from public, anon, authenticated;

grant execute on function app_api_v1.get_room_photos(text, text, text)
to service_role;
grant execute on function app_api_v1.add_room_photo(text, text, text, text, integer, integer)
to service_role;
grant execute on function app_api_v1.delete_room_photo(uuid)
to service_role;

revoke all on function public.get_room_photos(text, text, text) from public, anon;
revoke all on function public.add_room_photo(text, text, text, text, integer, integer)
from public, anon;
revoke all on function public.delete_room_photo(uuid) from public, anon;

grant execute on function public.get_room_photos(text, text, text)
to authenticated, service_role;
grant execute on function public.add_room_photo(text, text, text, text, integer, integer)
to authenticated, service_role;
grant execute on function public.delete_room_photo(uuid)
to authenticated, service_role;

notify pgrst, 'reload schema';
