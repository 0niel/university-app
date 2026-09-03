alter table core.marketplace_listings
  add column if not exists media jsonb not null default '[]'::jsonb,
  add column if not exists telegram_contact text,
  add column if not exists is_free boolean not null default false;

update core.marketplace_listings
set is_free = (price = 0)
where is_free is distinct from (price = 0);

alter table core.marketplace_listings
  drop constraint if exists marketplace_price_category_consistent;
alter table core.marketplace_listings
  drop constraint if exists marketplace_is_free_price_consistent;
alter table core.marketplace_listings
  add constraint marketplace_is_free_price_consistent check (
    not is_free or price = 0
  );

alter table core.marketplace_listings
  drop constraint if exists marketplace_telegram_contact_format;
alter table core.marketplace_listings
  add constraint marketplace_telegram_contact_format check (
    telegram_contact is null or telegram_contact ~ '^[A-Za-z0-9_]{5,32}$'
  );

update core.marketplace_listings
set media = '[]'::jsonb
where jsonb_typeof(media) <> 'array';

create or replace function internal.marketplace_media_valid(
  p_media jsonb,
  p_user_id uuid
)
returns boolean
language plpgsql
immutable
set search_path = ''
as $$
declare
  v_media jsonb := coalesce(p_media, '[]'::jsonb);
  v_item jsonb;
  v_kind text;
  v_path text;
  v_video_count integer := 0;
begin
  if jsonb_typeof(v_media) <> 'array' then
    return false;
  end if;
  if jsonb_array_length(v_media) > 7 or octet_length(v_media::text) > 6000 then
    return false;
  end if;
  for v_item in select * from jsonb_array_elements(v_media) loop
    if jsonb_typeof(v_item) <> 'object' then
      return false;
    end if;
    v_kind := v_item ->> 'kind';
    v_path := v_item ->> 'path';
    if v_kind is null or v_kind not in ('image', 'video') or v_path is null then
      return false;
    end if;
    if v_path !~ (
      '^' || p_user_id::text || '/[0-9a-f]{32}\.(jpe?g|png|webp|mp4|mov)$'
    ) then
      return false;
    end if;
    if v_kind = 'image' and v_path !~ '\.(jpe?g|png|webp)$' then
      return false;
    end if;
    if v_kind = 'video' then
      if v_path !~ '\.(mp4|mov)$' then
        return false;
      end if;
      v_video_count := v_video_count + 1;
      if coalesce((v_item ->> 'duration')::numeric, 0) < 0
        or coalesce((v_item ->> 'duration')::numeric, 0) > 60
      then
        return false;
      end if;
    end if;
    if v_item ? 'width' and (
      jsonb_typeof(v_item -> 'width') <> 'number'
      or (v_item ->> 'width')::numeric < 0
      or (v_item ->> 'width')::numeric > 10000
    ) then
      return false;
    end if;
    if v_item ? 'height' and (
      jsonb_typeof(v_item -> 'height') <> 'number'
      or (v_item ->> 'height')::numeric < 0
      or (v_item ->> 'height')::numeric > 10000
    ) then
      return false;
    end if;
  end loop;
  if v_video_count > 1 then
    return false;
  end if;
  return true;
end;
$$;

revoke all on function internal.marketplace_media_valid(jsonb, uuid)
from public, anon, authenticated;
grant execute on function internal.marketplace_media_valid(jsonb, uuid)
to service_role;

alter table core.marketplace_listings
  drop constraint if exists marketplace_media_valid;
alter table core.marketplace_listings
  add constraint marketplace_media_valid check (
    internal.marketplace_media_valid(media, seller_id)
  );

insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
) values (
  'marketplace-media',
  'marketplace-media',
  true,
  52428800,
  array[
    'image/jpeg',
    'image/png',
    'image/webp',
    'video/mp4',
    'video/quicktime'
  ]
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "public read marketplace media" on storage.objects;
drop policy if exists "users upload own marketplace media" on storage.objects;
drop policy if exists "users delete own marketplace media" on storage.objects;

create policy "public read marketplace media"
on storage.objects for select to public
using (bucket_id = 'marketplace-media');

create policy "users upload own marketplace media"
on storage.objects for insert to authenticated
with check (
  bucket_id = 'marketplace-media'
  and (storage.foldername(name))[1] = (select auth.uid())::text
  and name ~ (
    '^' || (select auth.uid())::text
    || '/[0-9a-f]{32}\.(jpe?g|png|webp|mp4|mov)$'
  )
);

create policy "users delete own marketplace media"
on storage.objects for delete to authenticated
using (
  bucket_id = 'marketplace-media'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

create or replace function app_api_v1.get_listings(p_organization_id text)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null or not exists (
    select 1
    from core.user_academic_profiles viewer
    where viewer.user_id = v_user_id
      and viewer.organization_id = p_organization_id
  ) then
    raise exception 'Marketplace is unavailable' using errcode = '42501';
  end if;
  return (
    select coalesce(
      jsonb_agg(row.payload order by row.is_sold, row.created_at desc),
      '[]'::jsonb
    )
    from (
      select
        listing.is_sold,
        listing.created_at,
        jsonb_build_object(
          'id', listing.id,
          'title', listing.title,
          'description', listing.description,
          'price', listing.price,
          'category', listing.category,
          'emoji', internal.marketplace_emoji(listing.category),
          'isSold', listing.is_sold,
          'isFree', listing.is_free,
          'media', listing.media,
          'createdAt', listing.created_at,
          'isMine', listing.seller_id = v_user_id,
          'sellerName', case
            when profile.full_name = '' then ''
            else split_part(profile.full_name, ' ', 1)
              || case
                when split_part(profile.full_name, ' ', 2) = '' then ''
                else ' ' || left(split_part(profile.full_name, ' ', 2), 1) || '.'
              end
          end,
          'showContact', listing.show_contact,
          'telegramHandle', case
            when listing.show_contact or listing.seller_id = v_user_id
              then listing.telegram_contact
          end
        ) as payload
      from core.marketplace_listings listing
      join core.user_academic_profiles profile
        on profile.user_id = listing.seller_id
        and profile.organization_id = listing.organization_id
      where listing.organization_id = p_organization_id
        and listing.archived_at is null
        and (not listing.is_sold or listing.seller_id = v_user_id)
      order by listing.is_sold, listing.created_at desc
      limit 100
    ) row
  );
end;
$$;

create or replace function app_api_v1.create_listing_v2(
  p_organization_id text,
  p_title text,
  p_price integer,
  p_category text,
  p_description text,
  p_is_free boolean,
  p_media jsonb,
  p_telegram_contact text,
  p_show_contact boolean
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_category text := btrim(coalesce(p_category, ''));
  v_is_free boolean := coalesce(p_is_free, false);
  v_price integer := case when v_is_free then 0 else coalesce(p_price, -1) end;
  v_media jsonb := coalesce(p_media, '[]'::jsonb);
  v_telegram text := ltrim(btrim(coalesce(p_telegram_contact, '')), '@');
  v_id uuid;
begin
  if v_user_id is null or not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'Marketplace is unavailable' using errcode = '42501';
  end if;
  if v_category !~ '^[a-z][a-z0-9_]{0,39}$'
    or v_price < 0
    or v_price > 100000000
    or not internal.marketplace_media_valid(v_media, v_user_id)
    or v_telegram !~ '^[A-Za-z0-9_]{5,32}$'
  then
    raise exception 'Invalid listing options' using errcode = '22023';
  end if;
  perform core.enforce_rate_limit('create_listing', 20, interval '1 hour');
  insert into core.marketplace_listings (
    organization_id,
    seller_id,
    title,
    description,
    price,
    category,
    emoji,
    show_contact,
    is_free,
    media,
    telegram_contact
  ) values (
    p_organization_id,
    v_user_id,
    core.validate_text(p_title, 'Title', 120, true),
    core.validate_text(p_description, 'Description', 4000, false),
    v_price,
    v_category,
    internal.marketplace_emoji(v_category),
    coalesce(p_show_contact, false),
    v_is_free,
    v_media,
    v_telegram
  ) returning id into v_id;
  return v_id;
end;
$$;

create or replace function app_api_v1.update_listing(
  p_id uuid,
  p_title text,
  p_price integer,
  p_category text,
  p_description text,
  p_is_free boolean,
  p_media jsonb,
  p_telegram_contact text,
  p_show_contact boolean
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_category text := btrim(coalesce(p_category, ''));
  v_is_free boolean := coalesce(p_is_free, false);
  v_price integer := case when v_is_free then 0 else coalesce(p_price, -1) end;
  v_media jsonb := coalesce(p_media, '[]'::jsonb);
  v_telegram text := ltrim(btrim(coalesce(p_telegram_contact, '')), '@');
  v_old_media jsonb;
  v_removed jsonb;
begin
  if v_category !~ '^[a-z][a-z0-9_]{0,39}$'
    or v_price < 0
    or v_price > 100000000
    or not internal.marketplace_media_valid(v_media, v_user_id)
    or v_telegram !~ '^[A-Za-z0-9_]{5,32}$'
  then
    raise exception 'Invalid listing options' using errcode = '22023';
  end if;
  perform core.enforce_rate_limit('update_listing', 30, interval '1 hour');
  select listing.media into v_old_media
  from core.marketplace_listings listing
  where listing.id = p_id
    and listing.seller_id = v_user_id
    and listing.archived_at is null
    and exists (
      select 1
      from core.user_academic_profiles seller
      where seller.user_id = v_user_id
        and seller.organization_id = listing.organization_id
    )
  for update of listing;
  if not found then
    raise exception 'Listing is unavailable' using errcode = '42501';
  end if;
  update core.marketplace_listings listing
  set
    title = core.validate_text(p_title, 'Title', 120, true),
    description = core.validate_text(p_description, 'Description', 4000, false),
    price = v_price,
    category = v_category,
    emoji = internal.marketplace_emoji(v_category),
    is_free = v_is_free,
    media = v_media,
    telegram_contact = v_telegram,
    show_contact = coalesce(p_show_contact, false),
    updated_at = clock_timestamp()
  where listing.id = p_id
    and listing.seller_id = v_user_id;
  select coalesce(jsonb_agg(old_item.value ->> 'path'), '[]'::jsonb)
  into v_removed
  from jsonb_array_elements(coalesce(v_old_media, '[]'::jsonb)) old_item
  where not exists (
    select 1
    from jsonb_array_elements(v_media) new_item
    where new_item ->> 'path' = old_item.value ->> 'path'
  );
  return v_removed;
end;
$$;

create or replace function app_api_v1.archive_listing(p_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_media jsonb;
begin
  perform core.enforce_rate_limit('archive_listing', 30, interval '1 hour');
  update core.marketplace_listings listing
  set archived_at = clock_timestamp(), updated_at = clock_timestamp()
  where listing.id = p_id
    and listing.seller_id = v_user_id
    and listing.archived_at is null
    and exists (
      select 1
      from core.user_academic_profiles seller
      where seller.user_id = v_user_id
        and seller.organization_id = listing.organization_id
    )
  returning listing.media into v_media;
  if not found then
    raise exception 'Listing is unavailable' using errcode = '42501';
  end if;
  return coalesce((
    select jsonb_agg(item.value ->> 'path')
    from jsonb_array_elements(coalesce(v_media, '[]'::jsonb)) item
  ), '[]'::jsonb);
end;
$$;

drop function if exists public.delete_listing(uuid);
drop function if exists app_api_v1.delete_listing(uuid);

create function app_api_v1.delete_listing(p_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_media jsonb;
begin
  delete from core.marketplace_listings listing
  where listing.id = p_id
    and listing.seller_id = v_user_id
    and exists (
      select 1
      from core.user_academic_profiles seller
      where seller.user_id = v_user_id
        and seller.organization_id = listing.organization_id
    )
  returning listing.media into v_media;
  if not found then
    raise exception 'Listing is unavailable' using errcode = '42501';
  end if;
  return coalesce((
    select jsonb_agg(item.value ->> 'path')
    from jsonb_array_elements(coalesce(v_media, '[]'::jsonb)) item
  ), '[]'::jsonb);
end;
$$;

create function public.delete_listing(p_id uuid)
returns jsonb language sql security definer set search_path = ''
as $$ select app_api_v1.delete_listing(p_id); $$;

create or replace function public.create_listing_v2(
  p_organization_id text,
  p_title text,
  p_price integer,
  p_category text,
  p_description text,
  p_is_free boolean,
  p_media jsonb,
  p_telegram_contact text,
  p_show_contact boolean
)
returns uuid language sql security definer set search_path = ''
as $$
  select app_api_v1.create_listing_v2(
    p_organization_id,
    p_title,
    p_price,
    p_category,
    p_description,
    p_is_free,
    p_media,
    p_telegram_contact,
    p_show_contact
  );
$$;

create or replace function public.update_listing(
  p_id uuid,
  p_title text,
  p_price integer,
  p_category text,
  p_description text,
  p_is_free boolean,
  p_media jsonb,
  p_telegram_contact text,
  p_show_contact boolean
)
returns jsonb language sql security definer set search_path = ''
as $$
  select app_api_v1.update_listing(
    p_id,
    p_title,
    p_price,
    p_category,
    p_description,
    p_is_free,
    p_media,
    p_telegram_contact,
    p_show_contact
  );
$$;

create or replace function public.archive_listing(p_id uuid)
returns jsonb language sql security definer set search_path = ''
as $$ select app_api_v1.archive_listing(p_id); $$;

revoke all on function app_api_v1.create_listing_v2(
  text, text, integer, text, text, boolean, jsonb, text, boolean
) from public, anon, authenticated;
revoke all on function app_api_v1.update_listing(
  uuid, text, integer, text, text, boolean, jsonb, text, boolean
) from public, anon, authenticated;
revoke all on function app_api_v1.archive_listing(uuid)
from public, anon, authenticated;
revoke all on function app_api_v1.delete_listing(uuid)
from public, anon, authenticated;

grant execute on function app_api_v1.create_listing_v2(
  text, text, integer, text, text, boolean, jsonb, text, boolean
) to service_role;
grant execute on function app_api_v1.update_listing(
  uuid, text, integer, text, text, boolean, jsonb, text, boolean
) to service_role;
grant execute on function app_api_v1.archive_listing(uuid) to service_role;
grant execute on function app_api_v1.delete_listing(uuid) to service_role;

revoke all on function public.create_listing_v2(
  text, text, integer, text, text, boolean, jsonb, text, boolean
) from public, anon;
revoke all on function public.update_listing(
  uuid, text, integer, text, text, boolean, jsonb, text, boolean
) from public, anon;
revoke all on function public.archive_listing(uuid) from public, anon;
revoke all on function public.delete_listing(uuid) from public, anon;

grant execute on function public.create_listing_v2(
  text, text, integer, text, text, boolean, jsonb, text, boolean
) to authenticated, service_role;
grant execute on function public.update_listing(
  uuid, text, integer, text, text, boolean, jsonb, text, boolean
) to authenticated, service_role;
grant execute on function public.archive_listing(uuid)
to authenticated, service_role;
grant execute on function public.delete_listing(uuid)
to authenticated, service_role;

notify pgrst, 'reload schema';
