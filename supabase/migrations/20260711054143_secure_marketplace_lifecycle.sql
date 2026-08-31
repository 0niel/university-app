alter table core.marketplace_listings
  add column if not exists show_contact boolean not null default false,
  add column if not exists archived_at timestamptz,
  add column if not exists updated_at timestamptz not null default now();

update core.marketplace_listings
set category = 'free'
where price = 0 and category <> 'free';

update core.marketplace_listings
set price = 0
where category = 'free' and price <> 0;

alter table core.marketplace_listings
  drop constraint if exists marketplace_category_valid;
alter table core.marketplace_listings
  drop constraint if exists marketplace_category_format;
alter table core.marketplace_listings
  add constraint marketplace_category_format check (
    category ~ '^[a-z][a-z0-9_]{0,39}$'
  );
alter table core.marketplace_listings
  drop constraint if exists marketplace_price_category_consistent;
alter table core.marketplace_listings
  add constraint marketplace_price_category_consistent check (
    (category = 'free') = (price = 0)
  );
alter table core.marketplace_listings
  drop constraint if exists marketplace_price_upper_bound;
alter table core.marketplace_listings
  add constraint marketplace_price_upper_bound check (price <= 100000000);

update core.marketplace_listings listing
set archived_at = clock_timestamp(), updated_at = clock_timestamp()
where not exists (
  select 1
  from core.user_academic_profiles profile
  where profile.user_id = listing.seller_id
    and profile.organization_id = listing.organization_id
);

create index if not exists marketplace_active_org_idx
on core.marketplace_listings (organization_id, is_sold, created_at desc)
where archived_at is null;

drop policy if exists "listings readable by org users"
on core.marketplace_listings;
drop policy if exists "users create own listings"
on core.marketplace_listings;
drop policy if exists "sellers update own listings"
on core.marketplace_listings;
drop policy if exists "sellers delete own listings"
on core.marketplace_listings;

create policy "organization members read active listings"
on core.marketplace_listings for select to authenticated
using (
  archived_at is null
  and (not is_sold or seller_id = (select auth.uid()))
  and exists (
    select 1
    from core.user_academic_profiles viewer
    where viewer.user_id = (select auth.uid())
      and viewer.organization_id = marketplace_listings.organization_id
  )
  and exists (
    select 1
    from core.user_academic_profiles seller
    where seller.user_id = marketplace_listings.seller_id
      and seller.organization_id = marketplace_listings.organization_id
  )
);

revoke insert, update, delete on core.marketplace_listings
from authenticated;
grant select on core.marketplace_listings to authenticated;

create or replace function internal.marketplace_emoji(p_category text)
returns text
language sql
immutable
set search_path = ''
as $$
  select case p_category
    when 'books' then '📚'
    when 'tech' then '💻'
    when 'cloth' then '🧥'
    when 'free' then '🎁'
    else '📦'
  end;
$$;

revoke all on function internal.marketplace_emoji(text)
from public, anon, authenticated;
grant execute on function internal.marketplace_emoji(text) to service_role;

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
          'sellerHandle', case
            when listing.show_contact then nullif(profile.handle, '')
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

create or replace function app_api_v1.create_listing(
  p_organization_id text,
  p_title text,
  p_price integer,
  p_category text,
  p_emoji text,
  p_description text,
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
  v_price integer := coalesce(p_price, -1);
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
    or char_length(coalesce(p_emoji, '')) > 16
    or ((v_category = 'free') <> (v_price = 0))
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
    show_contact
  ) values (
    p_organization_id,
    v_user_id,
    core.validate_text(p_title, 'Title', 120, true),
    core.validate_text(p_description, 'Description', 4000, false),
    v_price,
    v_category,
    internal.marketplace_emoji(v_category),
    coalesce(p_show_contact, false)
  ) returning id into v_id;
  return v_id;
end;
$$;

create or replace function app_api_v1.create_listing(
  p_organization_id text,
  p_title text,
  p_price integer,
  p_category text default 'other',
  p_emoji text default '📦',
  p_description text default ''
)
returns uuid
language sql
security definer
set search_path = ''
as $$
  select app_api_v1.create_listing(
    p_organization_id,
    p_title,
    p_price,
    p_category,
    p_emoji,
    p_description,
    false
  );
$$;

create or replace function app_api_v1.set_listing_sold(
  p_id uuid,
  p_sold boolean
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  update core.marketplace_listings listing
  set is_sold = coalesce(p_sold, false), updated_at = clock_timestamp()
  where listing.id = p_id
    and listing.seller_id = v_user_id
    and listing.archived_at is null
    and exists (
      select 1
      from core.user_academic_profiles seller
      where seller.user_id = v_user_id
        and seller.organization_id = listing.organization_id
    );
  if not found then
    raise exception 'Listing is unavailable' using errcode = '42501';
  end if;
end;
$$;

create or replace function app_api_v1.delete_listing(p_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  delete from core.marketplace_listings listing
  where listing.id = p_id
    and listing.seller_id = v_user_id
    and exists (
      select 1
      from core.user_academic_profiles seller
      where seller.user_id = v_user_id
        and seller.organization_id = listing.organization_id
    );
  if not found then
    raise exception 'Listing is unavailable' using errcode = '42501';
  end if;
end;
$$;

create or replace function internal.archive_marketplace_on_org_change()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if old.organization_id <> new.organization_id then
    update core.marketplace_listings listing
    set archived_at = clock_timestamp(), updated_at = clock_timestamp()
    where listing.seller_id = new.user_id
      and listing.organization_id = old.organization_id
      and listing.archived_at is null;
  end if;
  return new;
end;
$$;

drop trigger if exists archive_marketplace_on_org_change
on core.user_academic_profiles;
create trigger archive_marketplace_on_org_change
after update of organization_id on core.user_academic_profiles
for each row execute function internal.archive_marketplace_on_org_change();

create or replace function public.get_listings(p_organization_id text)
returns jsonb language sql stable security definer set search_path = ''
as $$ select app_api_v1.get_listings(p_organization_id); $$;

create or replace function public.create_listing(
  p_organization_id text,
  p_title text,
  p_price integer,
  p_category text default 'other',
  p_emoji text default '📦',
  p_description text default ''
)
returns uuid language sql security definer set search_path = ''
as $$
  select app_api_v1.create_listing(
    p_organization_id,
    p_title,
    p_price,
    p_category,
    p_emoji,
    p_description
  );
$$;

create or replace function public.create_listing(
  p_organization_id text,
  p_title text,
  p_price integer,
  p_category text,
  p_emoji text,
  p_description text,
  p_show_contact boolean
)
returns uuid language sql security definer set search_path = ''
as $$
  select app_api_v1.create_listing(
    p_organization_id,
    p_title,
    p_price,
    p_category,
    p_emoji,
    p_description,
    p_show_contact
  );
$$;

create or replace function public.set_listing_sold(
  p_id uuid,
  p_sold boolean
)
returns void language sql security definer set search_path = ''
as $$ select app_api_v1.set_listing_sold(p_id, p_sold); $$;

create or replace function public.delete_listing(p_id uuid)
returns void language sql security definer set search_path = ''
as $$ select app_api_v1.delete_listing(p_id); $$;

revoke all on function app_api_v1.get_listings(text)
from public, anon, authenticated;
revoke all on function app_api_v1.create_listing(
  text, text, integer, text, text, text
) from public, anon, authenticated;
revoke all on function app_api_v1.create_listing(
  text, text, integer, text, text, text, boolean
) from public, anon, authenticated;
revoke all on function app_api_v1.set_listing_sold(uuid, boolean)
from public, anon, authenticated;
revoke all on function app_api_v1.delete_listing(uuid)
from public, anon, authenticated;

grant execute on function app_api_v1.get_listings(text) to service_role;
grant execute on function app_api_v1.create_listing(
  text, text, integer, text, text, text
) to service_role;
grant execute on function app_api_v1.create_listing(
  text, text, integer, text, text, text, boolean
) to service_role;
grant execute on function app_api_v1.set_listing_sold(uuid, boolean)
to service_role;
grant execute on function app_api_v1.delete_listing(uuid) to service_role;

revoke all on function public.get_listings(text) from public, anon;
revoke all on function public.create_listing(
  text, text, integer, text, text, text
) from public, anon;
revoke all on function public.create_listing(
  text, text, integer, text, text, text, boolean
) from public, anon;
revoke all on function public.set_listing_sold(uuid, boolean)
from public, anon;
revoke all on function public.delete_listing(uuid) from public, anon;

grant execute on function public.get_listings(text)
to authenticated, service_role;
grant execute on function public.create_listing(
  text, text, integer, text, text, text
) to authenticated, service_role;
grant execute on function public.create_listing(
  text, text, integer, text, text, text, boolean
) to authenticated, service_role;
grant execute on function public.set_listing_sold(uuid, boolean)
to authenticated, service_role;
grant execute on function public.delete_listing(uuid)
to authenticated, service_role;
