alter table core.lost_found_items
  add column if not exists show_contact boolean not null default false,
  add column if not exists archived_at timestamptz;

create table if not exists core.lost_found_image_cleanup_queue (
  path text primary key,
  user_id uuid not null,
  attempts integer not null default 0,
  last_error text,
  created_at timestamptz not null default clock_timestamp()
);

update core.lost_found_items
set author_email = '';

update core.lost_found_items
set category = 'other'
where category !~ '^[a-z][a-z0-9_]{0,39}$';

insert into core.lost_found_image_cleanup_queue (path, user_id)
select image.value #>> '{}', item.author_id
from core.lost_found_items item
cross join lateral jsonb_array_elements(
  case when jsonb_typeof(item.images) = 'array'
    then item.images else '[]'::jsonb end
) as image(value)
where jsonb_typeof(image.value) = 'string'
  and image.value #>> '{}' ~ (
    '^' || item.author_id::text
    || '/[0-9]+_[0-4][.](jpe?g|png|webp)$'
  )
  and (
    not exists (
      select 1
      from core.user_academic_profiles profile
      where profile.user_id = item.author_id
        and profile.organization_id = item.organization_id
    )
    or case
      when jsonb_typeof(item.images) <> 'array' then true
      else jsonb_array_length(item.images) > 5
        or exists (
          select 1
          from jsonb_array_elements(item.images) candidate
          where jsonb_typeof(candidate) <> 'string'
            or candidate #>> '{}'
              !~ '^[0-9a-f-]{36}/[0-9]+_[0-4][.](jpe?g|png|webp)$'
        )
    end
  )
on conflict (path) do nothing;

update core.lost_found_items item
set archived_at = clock_timestamp(), updated_at = clock_timestamp()
where not exists (
  select 1
  from core.user_academic_profiles profile
  where profile.user_id = item.author_id
    and profile.organization_id = item.organization_id
);

update core.lost_found_items
set images = '[]'::jsonb
where case
  when jsonb_typeof(images) <> 'array' then true
  else jsonb_array_length(images) > 5
    or exists (
      select 1
      from jsonb_array_elements(images) image
      where jsonb_typeof(image) <> 'string'
        or image #>> '{}'
          !~ '^[0-9a-f-]{36}/[0-9]+_[0-4][.](jpe?g|png|webp)$'
    )
end;

alter table core.lost_found_items
  drop constraint if exists lost_found_category_valid;
alter table core.lost_found_items
  drop constraint if exists lost_found_category_format;
alter table core.lost_found_items
  add constraint lost_found_category_format check (
    category ~ '^[a-z][a-z0-9_]{0,39}$'
  );
alter table core.lost_found_items
  drop constraint if exists lost_found_images_valid;
alter table core.lost_found_items
  add constraint lost_found_images_valid check (
    jsonb_typeof(images) = 'array'
    and jsonb_array_length(images) <= 5
    and octet_length(images::text) <= 2000
  );

create index if not exists lost_found_active_org_idx
on core.lost_found_items (organization_id, status, created_at desc)
where archived_at is null;

create table if not exists core.lost_found_upload_tickets (
  path text primary key,
  user_id uuid not null,
  organization_id text not null,
  expires_at timestamptz not null,
  consumed_at timestamptz,
  created_at timestamptz not null default clock_timestamp()
);

create index if not exists lost_found_upload_tickets_expiry_idx
on core.lost_found_upload_tickets (expires_at)
where consumed_at is null;

alter table core.lost_found_upload_tickets enable row level security;
alter table core.lost_found_image_cleanup_queue enable row level security;
revoke all on core.lost_found_upload_tickets from public, anon, authenticated;
revoke all on core.lost_found_image_cleanup_queue
from public, anon, authenticated;

drop policy if exists "lost found readable by org users"
on core.lost_found_items;
drop policy if exists "users create own lost found items"
on core.lost_found_items;
drop policy if exists "authors update own lost found items"
on core.lost_found_items;
drop policy if exists "authors delete own lost found items"
on core.lost_found_items;

create policy "organization members read active lost found items"
on core.lost_found_items for select to authenticated
using (
  archived_at is null
  and exists (
    select 1
    from core.user_academic_profiles viewer
    where viewer.user_id = (select auth.uid())
      and viewer.organization_id = lost_found_items.organization_id
  )
  and exists (
    select 1
    from core.user_academic_profiles author
    where author.user_id = lost_found_items.author_id
      and author.organization_id = lost_found_items.organization_id
  )
);

revoke select, insert, update, delete on core.lost_found_items
from authenticated;

insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
) values (
  'lost-found-images',
  'lost-found-images',
  false,
  8388608,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

create or replace function internal.can_read_lost_found_image(
  p_object_name text
)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from core.lost_found_items item
    join core.user_academic_profiles viewer
      on viewer.user_id = (select auth.uid())
      and viewer.organization_id = item.organization_id
    join core.user_academic_profiles author
      on author.user_id = item.author_id
      and author.organization_id = item.organization_id
    where item.archived_at is null
      and item.images ? p_object_name
  );
$$;

revoke all on function internal.can_read_lost_found_image(text)
from public, anon;
grant execute on function internal.can_read_lost_found_image(text)
to authenticated, service_role;

create or replace function internal.can_upload_lost_found_image(
  p_object_name text
)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from core.lost_found_upload_tickets ticket
    where ticket.path = p_object_name
      and ticket.user_id = (select auth.uid())
      and ticket.expires_at > now()
      and ticket.consumed_at is null
  );
$$;

revoke all on function internal.can_upload_lost_found_image(text)
from public, anon;
grant execute on function internal.can_upload_lost_found_image(text)
to authenticated, service_role;

create or replace function internal.can_delete_lost_found_image(
  p_object_name text
)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from core.lost_found_image_cleanup_queue queue
    where queue.path = p_object_name
      and queue.user_id = (select auth.uid())
  ) or exists (
    select 1
    from core.lost_found_upload_tickets ticket
    where ticket.path = p_object_name
      and ticket.user_id = (select auth.uid())
      and ticket.consumed_at is null
  );
$$;

revoke all on function internal.can_delete_lost_found_image(text)
from public, anon;
grant execute on function internal.can_delete_lost_found_image(text)
to authenticated, service_role;

drop policy if exists "organization members read lost found images"
on storage.objects;
drop policy if exists "users upload own lost found images"
on storage.objects;
drop policy if exists "users delete own lost found images"
on storage.objects;

create policy "organization members read lost found images"
on storage.objects for select to authenticated
using (
  bucket_id = 'lost-found-images'
  and internal.can_read_lost_found_image(name)
);

create policy "users upload own lost found images"
on storage.objects for insert to authenticated
with check (
  bucket_id = 'lost-found-images'
  and (storage.foldername(name))[1] = (select auth.uid())::text
  and name ~ (
    '^' || (select auth.uid())::text
    || '/[0-9]+_[0-4][.](jpe?g|png|webp)$'
  )
  and internal.can_upload_lost_found_image(name)
);

create policy "users delete own lost found images"
on storage.objects for delete to authenticated
using (
  bucket_id = 'lost-found-images'
  and (storage.foldername(name))[1] = (select auth.uid())::text
  and internal.can_delete_lost_found_image(name)
);

create or replace function internal.lost_found_images_valid(
  p_images jsonb,
  p_user_id uuid
)
returns boolean
language sql
immutable
set search_path = ''
as $$
  select case
    when jsonb_typeof(coalesce(p_images, '[]'::jsonb)) <> 'array' then false
    else jsonb_array_length(coalesce(p_images, '[]'::jsonb)) <= 5
      and octet_length(coalesce(p_images, '[]'::jsonb)::text) <= 2000
      and not exists (
        select 1
        from jsonb_array_elements(coalesce(p_images, '[]'::jsonb)) image
        where jsonb_typeof(image) <> 'string'
          or image #>> '{}' !~ (
            '^' || p_user_id::text
            || '/[0-9]+_[0-4][.](jpe?g|png|webp)$'
          )
      )
  end;
$$;

revoke all on function internal.lost_found_images_valid(jsonb, uuid)
from public, anon, authenticated;
grant execute on function internal.lost_found_images_valid(jsonb, uuid)
to service_role;

create or replace function app_api_v1.reserve_lost_found_image_uploads(
  p_organization_id text,
  p_paths jsonb
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_paths jsonb := coalesce(p_paths, '[]'::jsonb);
begin
  if v_user_id is null or not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'Lost and found is unavailable' using errcode = '42501';
  end if;
  if not internal.lost_found_images_valid(v_paths, v_user_id) then
    raise exception 'Invalid upload paths' using errcode = '22023';
  end if;
  perform core.enforce_rate_limit(
    'reserve_lost_found_image_uploads', 20, interval '1 hour'
  );
  insert into core.lost_found_image_cleanup_queue (path, user_id)
  select ticket.path, ticket.user_id
  from core.lost_found_upload_tickets ticket
  where ticket.user_id = v_user_id
    and ticket.consumed_at is null
    and ticket.expires_at <= clock_timestamp()
  on conflict (path) do nothing;
  delete from core.lost_found_upload_tickets ticket
  where ticket.user_id = v_user_id
    and ticket.consumed_at is null
    and ticket.expires_at <= clock_timestamp();
  if (
    select count(*)
    from core.lost_found_upload_tickets ticket
    where ticket.user_id = v_user_id
      and ticket.consumed_at is null
  ) + jsonb_array_length(v_paths) > 5 then
    raise exception 'Too many active upload reservations'
      using errcode = '54000';
  end if;
  insert into core.lost_found_upload_tickets (
    path, user_id, organization_id, expires_at
  )
  select
    element.value #>> '{}',
    v_user_id,
    p_organization_id,
    clock_timestamp() + interval '15 minutes'
  from jsonb_array_elements(v_paths) as element(value)
  on conflict (path) do nothing;
  if (
    select count(*)
    from core.lost_found_upload_tickets ticket
    where ticket.path in (
      select element.value #>> '{}'
      from jsonb_array_elements(v_paths) as element(value)
    )
      and ticket.user_id = v_user_id
      and ticket.organization_id = p_organization_id
      and ticket.expires_at > clock_timestamp()
      and ticket.consumed_at is null
  ) <> jsonb_array_length(v_paths) then
    raise exception 'Upload paths are unavailable' using errcode = '23505';
  end if;
end;
$$;

create or replace function app_api_v1.release_lost_found_image_uploads(
  p_paths jsonb
)
returns void
language sql
security definer
set search_path = ''
as $$
  delete from core.lost_found_upload_tickets ticket
  where ticket.user_id = (select auth.uid())
    and ticket.consumed_at is null
    and ticket.path in (
      select element.value #>> '{}'
      from jsonb_array_elements(
        coalesce(p_paths, '[]'::jsonb)
      ) as element(value)
      where jsonb_typeof(element.value) = 'string'
    );
$$;

create or replace function app_api_v1.get_lost_found_image_cleanup_paths()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_paths jsonb;
begin
  insert into core.lost_found_image_cleanup_queue (path, user_id)
  select ticket.path, ticket.user_id
  from core.lost_found_upload_tickets ticket
  where ticket.user_id = v_user_id
    and ticket.consumed_at is null
    and ticket.expires_at <= clock_timestamp()
  on conflict (path) do nothing;
  delete from core.lost_found_upload_tickets ticket
  where ticket.user_id = v_user_id
    and ticket.consumed_at is null
    and ticket.expires_at <= clock_timestamp();
  select coalesce(
    jsonb_agg(queue.path order by queue.created_at), '[]'::jsonb
  ) into v_paths
  from (
    select item.path, item.created_at
    from core.lost_found_image_cleanup_queue item
    where item.user_id = v_user_id
    order by item.created_at
    limit 50
  ) queue;
  return v_paths;
end;
$$;

create or replace function app_api_v1.ack_lost_found_image_cleanup(
  p_paths jsonb
)
returns void
language sql
security definer
set search_path = ''
as $$
  delete from core.lost_found_image_cleanup_queue queue
  where queue.user_id = (select auth.uid())
    and queue.path in (
      select element.value #>> '{}'
      from jsonb_array_elements(
        coalesce(p_paths, '[]'::jsonb)
      ) as element(value)
      where jsonb_typeof(element.value) = 'string'
    );
$$;

create or replace function app_api_v1.get_lost_found_items(
  p_organization_id text,
  p_status text default null,
  p_query text default null,
  p_author_id uuid default null,
  p_limit integer default 50,
  p_offset integer default 0
)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_query text := lower(btrim(coalesce(p_query, '')));
begin
  if v_user_id is null or not exists (
    select 1
    from core.user_academic_profiles viewer
    where viewer.user_id = v_user_id
      and viewer.organization_id = p_organization_id
  ) then
    raise exception 'Lost and found is unavailable' using errcode = '42501';
  end if;
  if p_status is not null and p_status not in ('lost', 'found') then
    raise exception 'Invalid status' using errcode = '22023';
  end if;
  return (
    select coalesce(
      jsonb_agg(row.payload order by row.created_at desc),
      '[]'::jsonb
    )
    from (
      select
        item.created_at,
        jsonb_build_object(
          'id', item.id,
          'authorId', item.author_id,
          'authorName', case
            when profile.full_name = '' then ''
            else split_part(profile.full_name, ' ', 1)
              || case
                when split_part(profile.full_name, ' ', 2) = '' then ''
                else ' ' || left(split_part(profile.full_name, ' ', 2), 1) || '.'
              end
          end,
          'itemName', item.item_name,
          'description', item.description,
          'status', item.status,
          'category', item.category,
          'location', item.location,
          'images', item.images,
          'showContact', item.show_contact,
          'telegramContactInfo', case
            when item.show_contact or item.author_id = v_user_id
              then item.telegram_contact_info
          end,
          'phoneNumberContactInfo', case
            when item.show_contact or item.author_id = v_user_id
              then item.phone_number_contact_info
          end,
          'createdAt', item.created_at,
          'isMine', item.author_id = v_user_id
        ) as payload
      from core.lost_found_items item
      join core.user_academic_profiles profile
        on profile.user_id = item.author_id
        and profile.organization_id = item.organization_id
      where item.organization_id = p_organization_id
        and item.archived_at is null
        and (p_status is null or item.status = p_status)
        and (p_author_id is null or item.author_id = p_author_id)
        and (
          v_query = ''
          or position(v_query in lower(item.item_name)) > 0
          or position(v_query in lower(coalesce(item.description, ''))) > 0
        )
      order by item.created_at desc
      limit least(greatest(coalesce(p_limit, 50), 1), 100)
      offset greatest(coalesce(p_offset, 0), 0)
    ) row
  );
end;
$$;

create or replace function app_api_v1.get_lost_found_item(p_id uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_item core.lost_found_items%rowtype;
  v_name text;
begin
  select item.* into v_item
  from core.lost_found_items item
  where item.id = p_id
    and item.archived_at is null
    and exists (
      select 1
      from core.user_academic_profiles viewer
      where viewer.user_id = v_user_id
        and viewer.organization_id = item.organization_id
    )
    and exists (
      select 1
      from core.user_academic_profiles author
      where author.user_id = item.author_id
        and author.organization_id = item.organization_id
    );
  if not found then
    raise exception 'Lost and found item is unavailable'
      using errcode = '42501';
  end if;
  select case
    when profile.full_name = '' then ''
    else split_part(profile.full_name, ' ', 1)
      || case
        when split_part(profile.full_name, ' ', 2) = '' then ''
        else ' ' || left(split_part(profile.full_name, ' ', 2), 1) || '.'
      end
  end into v_name
  from core.user_academic_profiles profile
  where profile.user_id = v_item.author_id
    and profile.organization_id = v_item.organization_id;
  return jsonb_build_object(
    'id', v_item.id,
    'authorId', v_item.author_id,
    'authorName', v_name,
    'itemName', v_item.item_name,
    'description', v_item.description,
    'status', v_item.status,
    'category', v_item.category,
    'location', v_item.location,
    'images', v_item.images,
    'showContact', v_item.show_contact,
    'telegramContactInfo', case
      when v_item.show_contact or v_item.author_id = v_user_id
        then v_item.telegram_contact_info
    end,
    'phoneNumberContactInfo', case
      when v_item.show_contact or v_item.author_id = v_user_id
        then v_item.phone_number_contact_info
    end,
    'createdAt', v_item.created_at,
    'isMine', v_item.author_id = v_user_id
  );
end;
$$;

create or replace function app_api_v1.count_lost_found_items(
  p_organization_id text,
  p_status text default null,
  p_query text default null,
  p_author_id uuid default null
)
returns integer
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_query text := lower(btrim(coalesce(p_query, '')));
begin
  if v_user_id is null or not exists (
    select 1
    from core.user_academic_profiles viewer
    where viewer.user_id = v_user_id
      and viewer.organization_id = p_organization_id
  ) then
    raise exception 'Lost and found is unavailable' using errcode = '42501';
  end if;
  if p_status is not null and p_status not in ('lost', 'found') then
    raise exception 'Invalid status' using errcode = '22023';
  end if;
  return (
    select count(*)::integer
    from core.lost_found_items item
    join core.user_academic_profiles author
      on author.user_id = item.author_id
      and author.organization_id = item.organization_id
    where item.organization_id = p_organization_id
      and item.archived_at is null
      and (p_status is null or item.status = p_status)
      and (p_author_id is null or item.author_id = p_author_id)
      and (
        v_query = ''
        or position(v_query in lower(item.item_name)) > 0
        or position(v_query in lower(coalesce(item.description, ''))) > 0
      )
  );
end;
$$;

create or replace function app_api_v1.create_lost_found_item(
  p_organization_id text,
  p_item_name text,
  p_status text,
  p_description text,
  p_telegram text,
  p_phone text,
  p_author_email text,
  p_category text,
  p_location text,
  p_images jsonb,
  p_show_contact boolean,
  p_client_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_category text := btrim(coalesce(p_category, ''));
  v_status text := btrim(coalesce(p_status, ''));
  v_telegram text := nullif(btrim(coalesce(p_telegram, '')), '');
  v_phone text := nullif(btrim(coalesce(p_phone, '')), '');
  v_images jsonb := coalesce(p_images, '[]'::jsonb);
  v_id uuid;
begin
  if v_user_id is null or not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'Lost and found is unavailable' using errcode = '42501';
  end if;
  if v_status not in ('lost', 'found')
    or v_category !~ '^[a-z][a-z0-9_]{0,39}$'
    or not internal.lost_found_images_valid(v_images, v_user_id)
    or char_length(coalesce(p_author_email, '')) > 320
    or (v_telegram is not null and v_telegram !~ '^@?[A-Za-z0-9_]{5,32}$')
    or (v_phone is not null and v_phone !~ '^[+]?[0-9 ()-]{7,24}$')
    or (
      coalesce(p_show_contact, false)
      and v_telegram is null
      and v_phone is null
    )
  then
    raise exception 'Invalid lost and found item options'
      using errcode = '22023';
  end if;
  select item.id into v_id
  from core.lost_found_items item
  where item.id = p_client_id
    and item.author_id = v_user_id
    and item.organization_id = p_organization_id;
  if found then
    return jsonb_build_object('id', v_id);
  end if;
  if p_client_id is null or exists (
    select 1
    from jsonb_array_elements(v_images) image
    where not exists (
      select 1
      from core.lost_found_upload_tickets ticket
      where ticket.path = image #>> '{}'
        and ticket.user_id = v_user_id
        and ticket.organization_id = p_organization_id
        and ticket.expires_at > clock_timestamp()
        and ticket.consumed_at is null
    )
  ) then
    raise exception 'Image upload reservation is unavailable'
      using errcode = '42501';
  end if;
  perform core.enforce_rate_limit(
    'create_lost_found_item', 10, interval '1 hour'
  );
  insert into core.lost_found_items (
    id,
    organization_id,
    author_id,
    author_email,
    item_name,
    description,
    status,
    telegram_contact_info,
    phone_number_contact_info,
    category,
    location,
    images,
    show_contact
  ) values (
    p_client_id,
    p_organization_id,
    v_user_id,
    '',
    core.validate_text(p_item_name, 'Title', 120, true),
    nullif(core.validate_text(p_description, 'Description', 4000, false), ''),
    v_status,
    v_telegram,
    v_phone,
    v_category,
    core.validate_text(p_location, 'Location', 200, false),
    v_images,
    coalesce(p_show_contact, false)
  ) returning id into v_id;
  delete from core.lost_found_upload_tickets ticket
  where ticket.user_id = v_user_id
    and ticket.path in (
      select image #>> '{}' from jsonb_array_elements(v_images) image
    );
  return jsonb_build_object('id', v_id);
end;
$$;

create or replace function app_api_v1.create_lost_found_item(
  p_organization_id text,
  p_item_name text,
  p_status text,
  p_description text,
  p_telegram text,
  p_phone text,
  p_author_email text,
  p_category text,
  p_location text,
  p_images jsonb,
  p_show_contact boolean
)
returns jsonb
language sql
security definer
set search_path = ''
as $$
  select app_api_v1.create_lost_found_item(
    p_organization_id,
    p_item_name,
    p_status,
    p_description,
    p_telegram,
    p_phone,
    p_author_email,
    p_category,
    p_location,
    p_images,
    p_show_contact,
    extensions.gen_random_uuid()
  );
$$;

create or replace function app_api_v1.create_lost_found_item(
  p_organization_id text,
  p_item_name text,
  p_status text,
  p_description text default null,
  p_telegram text default null,
  p_phone text default null,
  p_author_email text default '',
  p_category text default 'other',
  p_location text default '',
  p_images jsonb default '[]'::jsonb
)
returns jsonb
language sql
security definer
set search_path = ''
as $$
  select app_api_v1.create_lost_found_item(
    p_organization_id,
    p_item_name,
    p_status,
    p_description,
    p_telegram,
    p_phone,
    p_author_email,
    p_category,
    p_location,
    p_images,
    false
  );
$$;

create or replace function app_api_v1.update_lost_found_item(
  p_id uuid,
  p_item_name text default null,
  p_description text default null,
  p_status text default null,
  p_telegram text default null,
  p_phone text default null,
  p_category text default null,
  p_location text default null
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_telegram text;
  v_phone text;
  v_show_contact boolean;
begin
  select
    case when p_telegram is null then item.telegram_contact_info
      else nullif(btrim(p_telegram), '') end,
    case when p_phone is null then item.phone_number_contact_info
      else nullif(btrim(p_phone), '') end,
    item.show_contact
  into v_telegram, v_phone, v_show_contact
  from core.lost_found_items item
  where item.id = p_id
    and item.author_id = v_user_id
    and item.archived_at is null
    and exists (
      select 1
      from core.user_academic_profiles author
      where author.user_id = v_user_id
        and author.organization_id = item.organization_id
    )
  for update of item;
  if not found then
    raise exception 'Lost and found item is unavailable'
      using errcode = '42501';
  end if;
  if p_status is not null and p_status not in ('lost', 'found') then
    raise exception 'Invalid status' using errcode = '22023';
  end if;
  if p_category is not null
    and btrim(p_category) !~ '^[a-z][a-z0-9_]{0,39}$'
  then
    raise exception 'Invalid category' using errcode = '22023';
  end if;
  if (v_telegram is not null and v_telegram !~ '^@?[A-Za-z0-9_]{5,32}$')
    or (v_phone is not null and v_phone !~ '^[+]?[0-9 ()-]{7,24}$')
    or (v_show_contact and v_telegram is null and v_phone is null)
  then
    raise exception 'Invalid contact' using errcode = '22023';
  end if;
  update core.lost_found_items item
  set
    item_name = case when p_item_name is null then item.item_name
      else core.validate_text(p_item_name, 'Title', 120, true) end,
    description = case when p_description is null then item.description
      else nullif(core.validate_text(
        p_description, 'Description', 4000, false
      ), '') end,
    status = coalesce(p_status, item.status),
    telegram_contact_info = v_telegram,
    phone_number_contact_info = v_phone,
    category = coalesce(btrim(p_category), item.category),
    location = case when p_location is null then item.location
      else core.validate_text(p_location, 'Location', 200, false) end
  where item.id = p_id
    and item.author_id = v_user_id
    and item.archived_at is null
    and exists (
      select 1
      from core.user_academic_profiles author
      where author.user_id = v_user_id
        and author.organization_id = item.organization_id
    );
end;
$$;

drop function if exists public.delete_lost_found_item(uuid);
drop function if exists app_api_v1.delete_lost_found_item(uuid);

create function app_api_v1.delete_lost_found_item(p_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_images jsonb;
begin
  delete from core.lost_found_items item
  where item.id = p_id
    and item.author_id = v_user_id
    and exists (
      select 1
      from core.user_academic_profiles author
      where author.user_id = v_user_id
        and author.organization_id = item.organization_id
    )
  returning item.images into v_images;
  if not found then
    raise exception 'Lost and found item is unavailable'
      using errcode = '42501';
  end if;
  insert into core.lost_found_image_cleanup_queue (path, user_id)
  select image #>> '{}', v_user_id
  from jsonb_array_elements(coalesce(v_images, '[]'::jsonb)) image
  on conflict (path) do nothing;
  return coalesce(v_images, '[]'::jsonb);
end;
$$;

create or replace function app_api_v1.cancel_lost_found_item(p_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_images jsonb;
begin
  if exists (
    select 1
    from core.lost_found_items item
    where item.id = p_id and item.author_id <> v_user_id
  ) then
    raise exception 'Lost and found item is unavailable'
      using errcode = '42501';
  end if;
  delete from core.lost_found_items item
  where item.id = p_id and item.author_id = v_user_id
  returning item.images into v_images;
  if not found then
    return jsonb_build_object('deleted', false, 'paths', '[]'::jsonb);
  end if;
  insert into core.lost_found_image_cleanup_queue (path, user_id)
  select image #>> '{}', v_user_id
  from jsonb_array_elements(coalesce(v_images, '[]'::jsonb)) image
  on conflict (path) do nothing;
  return jsonb_build_object(
    'deleted', true,
    'paths', coalesce(v_images, '[]'::jsonb)
  );
end;
$$;

create or replace function internal.archive_lost_found_on_org_change()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if old.organization_id <> new.organization_id then
    insert into core.lost_found_image_cleanup_queue (path, user_id)
    select image #>> '{}', new.user_id
    from core.lost_found_items item
    cross join lateral jsonb_array_elements(item.images) image
    where item.author_id = new.user_id
      and item.organization_id = old.organization_id
      and item.archived_at is null
    on conflict (path) do nothing;
    update core.lost_found_items item
    set archived_at = clock_timestamp(), updated_at = clock_timestamp()
    where item.author_id = new.user_id
      and item.organization_id = old.organization_id
      and item.archived_at is null;
  end if;
  return new;
end;
$$;

drop trigger if exists archive_lost_found_on_org_change
on core.user_academic_profiles;
create trigger archive_lost_found_on_org_change
after update of organization_id on core.user_academic_profiles
for each row execute function internal.archive_lost_found_on_org_change();

create or replace function public.get_lost_found_items(
  p_organization_id text,
  p_status text default null,
  p_query text default null,
  p_author_id uuid default null,
  p_limit integer default 50,
  p_offset integer default 0
)
returns jsonb language sql stable security definer set search_path = ''
as $$
  select app_api_v1.get_lost_found_items(
    p_organization_id, p_status, p_query, p_author_id, p_limit, p_offset
  );
$$;

create function public.get_lost_found_item(p_id uuid)
returns jsonb language sql stable security definer set search_path = ''
as $$ select app_api_v1.get_lost_found_item(p_id); $$;

create function public.count_lost_found_items(
  p_organization_id text,
  p_status text default null,
  p_query text default null,
  p_author_id uuid default null
)
returns integer language sql stable security definer set search_path = ''
as $$
  select app_api_v1.count_lost_found_items(
    p_organization_id, p_status, p_query, p_author_id
  );
$$;

create or replace function public.create_lost_found_item(
  p_organization_id text,
  p_item_name text,
  p_status text,
  p_description text default null,
  p_telegram text default null,
  p_phone text default null,
  p_author_email text default '',
  p_category text default 'other',
  p_location text default '',
  p_images jsonb default '[]'::jsonb
)
returns jsonb language sql security definer set search_path = ''
as $$
  select app_api_v1.create_lost_found_item(
    p_organization_id,
    p_item_name,
    p_status,
    p_description,
    p_telegram,
    p_phone,
    p_author_email,
    p_category,
    p_location,
    p_images
  );
$$;

create function public.create_lost_found_item(
  p_organization_id text,
  p_item_name text,
  p_status text,
  p_description text,
  p_telegram text,
  p_phone text,
  p_author_email text,
  p_category text,
  p_location text,
  p_images jsonb,
  p_show_contact boolean
)
returns jsonb language sql security definer set search_path = ''
as $$
  select app_api_v1.create_lost_found_item(
    p_organization_id,
    p_item_name,
    p_status,
    p_description,
    p_telegram,
    p_phone,
    p_author_email,
    p_category,
    p_location,
    p_images,
    p_show_contact
  );
$$;

create function public.create_lost_found_item(
  p_organization_id text,
  p_item_name text,
  p_status text,
  p_description text,
  p_telegram text,
  p_phone text,
  p_author_email text,
  p_category text,
  p_location text,
  p_images jsonb,
  p_show_contact boolean,
  p_client_id uuid
)
returns jsonb language sql security definer set search_path = ''
as $$
  select app_api_v1.create_lost_found_item(
    p_organization_id,
    p_item_name,
    p_status,
    p_description,
    p_telegram,
    p_phone,
    p_author_email,
    p_category,
    p_location,
    p_images,
    p_show_contact,
    p_client_id
  );
$$;

create or replace function public.update_lost_found_item(
  p_id uuid,
  p_item_name text default null,
  p_description text default null,
  p_status text default null,
  p_telegram text default null,
  p_phone text default null,
  p_category text default null,
  p_location text default null
)
returns void language sql security definer set search_path = ''
as $$
  select app_api_v1.update_lost_found_item(
    p_id,
    p_item_name,
    p_description,
    p_status,
    p_telegram,
    p_phone,
    p_category,
    p_location
  );
$$;

create function public.delete_lost_found_item(p_id uuid)
returns jsonb language sql security definer set search_path = ''
as $$ select app_api_v1.delete_lost_found_item(p_id); $$;

create function public.cancel_lost_found_item(p_id uuid)
returns jsonb language sql security definer set search_path = ''
as $$ select app_api_v1.cancel_lost_found_item(p_id); $$;

create function public.reserve_lost_found_image_uploads(
  p_organization_id text,
  p_paths jsonb
)
returns void language sql security definer set search_path = ''
as $$
  select app_api_v1.reserve_lost_found_image_uploads(
    p_organization_id, p_paths
  );
$$;

create function public.release_lost_found_image_uploads(p_paths jsonb)
returns void language sql security definer set search_path = ''
as $$ select app_api_v1.release_lost_found_image_uploads(p_paths); $$;

create function public.get_lost_found_image_cleanup_paths()
returns jsonb language sql security definer set search_path = ''
as $$ select app_api_v1.get_lost_found_image_cleanup_paths(); $$;

create function public.ack_lost_found_image_cleanup(p_paths jsonb)
returns void language sql security definer set search_path = ''
as $$ select app_api_v1.ack_lost_found_image_cleanup(p_paths); $$;

revoke all on function app_api_v1.get_lost_found_items(
  text, text, text, uuid, integer, integer
) from public, anon, authenticated;
revoke all on function app_api_v1.get_lost_found_item(uuid)
from public, anon, authenticated;
revoke all on function app_api_v1.count_lost_found_items(
  text, text, text, uuid
) from public, anon, authenticated;
revoke all on function app_api_v1.create_lost_found_item(
  text, text, text, text, text, text, text, text, text, jsonb
) from public, anon, authenticated;
revoke all on function app_api_v1.create_lost_found_item(
  text, text, text, text, text, text, text, text, text, jsonb, boolean
) from public, anon, authenticated;
revoke all on function app_api_v1.update_lost_found_item(
  uuid, text, text, text, text, text, text, text
) from public, anon, authenticated;
revoke all on function app_api_v1.delete_lost_found_item(uuid)
from public, anon, authenticated;

grant execute on function app_api_v1.get_lost_found_items(
  text, text, text, uuid, integer, integer
) to service_role;
grant execute on function app_api_v1.get_lost_found_item(uuid)
to service_role;
grant execute on function app_api_v1.count_lost_found_items(
  text, text, text, uuid
) to service_role;
grant execute on function app_api_v1.create_lost_found_item(
  text, text, text, text, text, text, text, text, text, jsonb
) to service_role;
grant execute on function app_api_v1.create_lost_found_item(
  text, text, text, text, text, text, text, text, text, jsonb, boolean
) to service_role;
grant execute on function app_api_v1.update_lost_found_item(
  uuid, text, text, text, text, text, text, text
) to service_role;
grant execute on function app_api_v1.delete_lost_found_item(uuid)
to service_role;

revoke all on function public.get_lost_found_items(
  text, text, text, uuid, integer, integer
) from public, anon;
revoke all on function public.get_lost_found_item(uuid)
from public, anon;
revoke all on function public.count_lost_found_items(
  text, text, text, uuid
) from public, anon;
revoke all on function public.create_lost_found_item(
  text, text, text, text, text, text, text, text, text, jsonb
) from public, anon;
revoke all on function public.create_lost_found_item(
  text, text, text, text, text, text, text, text, text, jsonb, boolean
) from public, anon;
revoke all on function public.update_lost_found_item(
  uuid, text, text, text, text, text, text, text
) from public, anon;
revoke all on function public.delete_lost_found_item(uuid)
from public, anon;

grant execute on function public.get_lost_found_items(
  text, text, text, uuid, integer, integer
) to authenticated, service_role;
grant execute on function public.get_lost_found_item(uuid)
to authenticated, service_role;
grant execute on function public.count_lost_found_items(
  text, text, text, uuid
) to authenticated, service_role;
grant execute on function public.create_lost_found_item(
  text, text, text, text, text, text, text, text, text, jsonb
) to authenticated, service_role;
grant execute on function public.create_lost_found_item(
  text, text, text, text, text, text, text, text, text, jsonb, boolean
) to authenticated, service_role;
grant execute on function public.update_lost_found_item(
  uuid, text, text, text, text, text, text, text
) to authenticated, service_role;
grant execute on function public.delete_lost_found_item(uuid)
to authenticated, service_role;

revoke all on function app_api_v1.create_lost_found_item(
  text, text, text, text, text, text, text, text, text, jsonb, boolean, uuid
) from public, anon, authenticated;
revoke all on function app_api_v1.cancel_lost_found_item(uuid)
from public, anon, authenticated;
revoke all on function app_api_v1.reserve_lost_found_image_uploads(text, jsonb)
from public, anon, authenticated;
revoke all on function app_api_v1.release_lost_found_image_uploads(jsonb)
from public, anon, authenticated;
revoke all on function app_api_v1.get_lost_found_image_cleanup_paths()
from public, anon, authenticated;
revoke all on function app_api_v1.ack_lost_found_image_cleanup(jsonb)
from public, anon, authenticated;

grant execute on function app_api_v1.create_lost_found_item(
  text, text, text, text, text, text, text, text, text, jsonb, boolean, uuid
) to service_role;
grant execute on function app_api_v1.cancel_lost_found_item(uuid)
to service_role;
grant execute on function app_api_v1.reserve_lost_found_image_uploads(
  text, jsonb
) to service_role;
grant execute on function app_api_v1.release_lost_found_image_uploads(jsonb)
to service_role;
grant execute on function app_api_v1.get_lost_found_image_cleanup_paths()
to service_role;
grant execute on function app_api_v1.ack_lost_found_image_cleanup(jsonb)
to service_role;

revoke all on function public.create_lost_found_item(
  text, text, text, text, text, text, text, text, text, jsonb, boolean, uuid
) from public, anon;
revoke all on function public.cancel_lost_found_item(uuid)
from public, anon;
revoke all on function public.reserve_lost_found_image_uploads(text, jsonb)
from public, anon;
revoke all on function public.release_lost_found_image_uploads(jsonb)
from public, anon;
revoke all on function public.get_lost_found_image_cleanup_paths()
from public, anon;
revoke all on function public.ack_lost_found_image_cleanup(jsonb)
from public, anon;

grant execute on function public.create_lost_found_item(
  text, text, text, text, text, text, text, text, text, jsonb, boolean, uuid
) to authenticated, service_role;
grant execute on function public.cancel_lost_found_item(uuid)
to authenticated, service_role;
grant execute on function public.reserve_lost_found_image_uploads(text, jsonb)
to authenticated, service_role;
grant execute on function public.release_lost_found_image_uploads(jsonb)
to authenticated, service_role;
grant execute on function public.get_lost_found_image_cleanup_paths()
to authenticated, service_role;
grant execute on function public.ack_lost_found_image_cleanup(jsonb)
to authenticated, service_role;
