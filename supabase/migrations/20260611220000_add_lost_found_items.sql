-- Lost & found items (Бюро находок), replacing the Serverpod endpoint.
-- Applied remotely as: add_lost_found_items.

create table core.lost_found_items (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id)
    on delete cascade,
  author_id uuid not null references auth.users(id) on delete cascade,
  author_email text not null default '',
  item_name text not null,
  description text,
  status text not null default 'lost',
  category text not null default 'other',
  location text not null default '',
  images jsonb not null default '[]'::jsonb,
  telegram_contact_info text,
  phone_number_contact_info text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint lost_found_name_not_empty check (length(trim(item_name)) > 0),
  constraint lost_found_status_valid check (status in ('lost', 'found')),
  constraint lost_found_category_valid check (
    category in ('tech', 'docs', 'keys', 'cloth', 'other')
  )
);

create index lost_found_org_idx
on core.lost_found_items (organization_id, status, created_at desc);

create trigger set_lost_found_items_updated_at
before update on core.lost_found_items
for each row execute function core.set_updated_at();

alter table core.lost_found_items enable row level security;

create policy "lost found readable by org users"
on core.lost_found_items for select to authenticated using (true);

create policy "users create own lost found items"
on core.lost_found_items for insert to authenticated
with check ((select auth.uid()) = author_id);

create policy "authors update own lost found items"
on core.lost_found_items for update to authenticated
using ((select auth.uid()) = author_id)
with check ((select auth.uid()) = author_id);

create policy "authors delete own lost found items"
on core.lost_found_items for delete to authenticated
using ((select auth.uid()) = author_id);

grant select, insert, update, delete on core.lost_found_items
  to authenticated;
grant all on core.lost_found_items to service_role;

-- RPCs
create or replace function app_api_v1.get_lost_found_items(
  p_organization_id text,
  p_status text default null,
  p_query text default null,
  p_author_id uuid default null,
  p_limit integer default 50,
  p_offset integer default 0
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
        'id', i.id,
        'authorId', i.author_id,
        'authorEmail', i.author_email,
        'authorName', coalesce(
          (select split_part(p.full_name, ' ', 1) || ' '
              || left(split_part(p.full_name, ' ', 2), 1) || '.'
           from core.user_academic_profiles p
           where p.user_id = i.author_id),
          ''
        ),
        'itemName', i.item_name,
        'description', i.description,
        'status', i.status,
        'category', i.category,
        'location', i.location,
        'images', i.images,
        'telegramContactInfo', i.telegram_contact_info,
        'phoneNumberContactInfo', i.phone_number_contact_info,
        'createdAt', i.created_at
      )
      order by i.created_at desc
    ),
    '[]'::jsonb
  )
  from (
    select *
    from core.lost_found_items li
    where li.organization_id = p_organization_id
      and (p_status is null or li.status = p_status)
      and (p_author_id is null or li.author_id = p_author_id)
      and (
        p_query is null
        or li.item_name ilike '%' || p_query || '%'
        or li.description ilike '%' || p_query || '%'
      )
    order by li.created_at desc
    limit least(coalesce(nullif(p_limit, 0), 50), 100)
    offset greatest(coalesce(p_offset, 0), 0)
  ) i;
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
  p_location text default ''
)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_id uuid;
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;
  insert into core.lost_found_items (
    organization_id, author_id, author_email, item_name, description,
    status, telegram_contact_info, phone_number_contact_info,
    category, location
  )
  values (
    p_organization_id, v_user_id, coalesce(p_author_email, ''),
    p_item_name, p_description, p_status, p_telegram, p_phone,
    coalesce(p_category, 'other'), coalesce(p_location, '')
  )
  returning id into v_id;
  return jsonb_build_object('id', v_id);
end;
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
language sql
security invoker
set search_path = ''
as $$
  update core.lost_found_items
  set
    item_name = coalesce(p_item_name, item_name),
    description = coalesce(p_description, description),
    status = coalesce(p_status, status),
    telegram_contact_info = coalesce(p_telegram, telegram_contact_info),
    phone_number_contact_info =
      coalesce(p_phone, phone_number_contact_info),
    category = coalesce(p_category, category),
    location = coalesce(p_location, location)
  where id = p_id and author_id = (select auth.uid());
$$;

create or replace function app_api_v1.delete_lost_found_item(p_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$
  delete from core.lost_found_items
  where id = p_id and author_id = (select auth.uid());
$$;

-- public wrappers
create or replace function public.get_lost_found_items(
  p_organization_id text, p_status text default null,
  p_query text default null, p_author_id uuid default null,
  p_limit integer default 50, p_offset integer default 0
)
returns jsonb language sql stable security invoker set search_path = ''
as $$
  select app_api_v1.get_lost_found_items(
    p_organization_id, p_status, p_query, p_author_id, p_limit, p_offset
  );
$$;

create or replace function public.create_lost_found_item(
  p_organization_id text, p_item_name text, p_status text,
  p_description text default null, p_telegram text default null,
  p_phone text default null, p_author_email text default '',
  p_category text default 'other', p_location text default ''
)
returns jsonb language sql security invoker set search_path = ''
as $$
  select app_api_v1.create_lost_found_item(
    p_organization_id, p_item_name, p_status, p_description,
    p_telegram, p_phone, p_author_email, p_category, p_location
  );
$$;

create or replace function public.update_lost_found_item(
  p_id uuid, p_item_name text default null,
  p_description text default null, p_status text default null,
  p_telegram text default null, p_phone text default null,
  p_category text default null, p_location text default null
)
returns void language sql security invoker set search_path = ''
as $$
  select app_api_v1.update_lost_found_item(
    p_id, p_item_name, p_description, p_status, p_telegram, p_phone,
    p_category, p_location
  );
$$;

create or replace function public.delete_lost_found_item(p_id uuid)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.delete_lost_found_item(p_id); $$;

revoke all on function
  public.get_lost_found_items(text, text, text, uuid, integer, integer)
  from public, anon;
revoke all on function
  public.create_lost_found_item(
    text, text, text, text, text, text, text, text, text
  )
  from public, anon;
revoke all on function
  public.update_lost_found_item(
    uuid, text, text, text, text, text, text, text
  )
  from public, anon;
revoke all on function public.delete_lost_found_item(uuid)
  from public, anon;

grant execute on function
  public.get_lost_found_items(text, text, text, uuid, integer, integer)
  to authenticated;
grant execute on function
  public.create_lost_found_item(
    text, text, text, text, text, text, text, text, text
  )
  to authenticated;
grant execute on function
  public.update_lost_found_item(
    uuid, text, text, text, text, text, text, text
  )
  to authenticated;
grant execute on function public.delete_lost_found_item(uuid)
  to authenticated;
