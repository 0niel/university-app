-- Marketplace listings (Барахолка), mentor profiles (Менторство) and
-- hackathon/project teams (Поиск команды) — org-wide, owner-managed.
-- Applied remotely as: add_marketplace_mentorship_teams (tables) and
-- add_marketplace_mentorship_teams_rpcs (RPCs + wrappers).

-- ── Marketplace ──────────────────────────────────────────────────────────────

create table core.marketplace_listings (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id)
    on delete cascade,
  seller_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  description text not null default '',
  price integer not null default 0,
  category text not null default 'other',
  emoji text not null default '📦',
  is_sold boolean not null default false,
  created_at timestamptz not null default now(),
  constraint marketplace_title_not_empty check (length(trim(title)) > 0),
  constraint marketplace_price_non_negative check (price >= 0),
  constraint marketplace_category_valid
    check (category in ('books', 'tech', 'cloth', 'free', 'other'))
);

create index marketplace_org_idx
on core.marketplace_listings (organization_id, is_sold, created_at desc);

alter table core.marketplace_listings enable row level security;

create policy "listings readable by org users"
on core.marketplace_listings for select to authenticated using (true);

create policy "users create own listings"
on core.marketplace_listings for insert to authenticated
with check ((select auth.uid()) = seller_id);

create policy "sellers update own listings"
on core.marketplace_listings for update to authenticated
using ((select auth.uid()) = seller_id)
with check ((select auth.uid()) = seller_id);

create policy "sellers delete own listings"
on core.marketplace_listings for delete to authenticated
using ((select auth.uid()) = seller_id);

grant select, insert, update, delete on core.marketplace_listings
  to authenticated;
grant all on core.marketplace_listings to service_role;

-- ── Mentorship ───────────────────────────────────────────────────────────────

create table core.mentor_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  organization_id text not null references core.organizations(id)
    on delete cascade,
  topics text[] not null default '{}',
  bio text not null default '',
  level text not null default '',
  formats text[] not null default '{}',
  price integer not null default 0,
  is_active boolean not null default true,
  sessions_count integer not null default 0,
  created_at timestamptz not null default now(),
  constraint mentor_topics_not_empty check (cardinality(topics) > 0),
  constraint mentor_profiles_price_non_negative check (price >= 0)
);

alter table core.mentor_profiles enable row level security;

create policy "mentors readable by org users"
on core.mentor_profiles for select to authenticated using (true);

create policy "users manage own mentor profile"
on core.mentor_profiles for insert to authenticated
with check ((select auth.uid()) = user_id);

create policy "mentors update own profile"
on core.mentor_profiles for update to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "mentors delete own profile"
on core.mentor_profiles for delete to authenticated
using ((select auth.uid()) = user_id);

grant select, insert, update, delete on core.mentor_profiles
  to authenticated;
grant all on core.mentor_profiles to service_role;

create table core.mentor_requests (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id)
    on delete cascade,
  mentor_user_id uuid not null references auth.users(id) on delete cascade,
  requester_id uuid not null references auth.users(id) on delete cascade,
  topic text not null default '',
  when_slot text not null default 'week',
  message text not null default '',
  created_at timestamptz not null default now(),
  constraint mentor_requests_when_valid
    check (when_slot in ('tonight', 'tomorrow', 'week')),
  constraint mentor_requests_not_self
    check (mentor_user_id <> requester_id)
);

create index mentor_requests_mentor_idx
on core.mentor_requests (mentor_user_id, created_at desc);

create index mentor_requests_requester_idx
on core.mentor_requests (requester_id);

alter table core.mentor_requests enable row level security;

create policy "mentor and requester read requests"
on core.mentor_requests for select to authenticated
using ((select auth.uid()) in (mentor_user_id, requester_id));

create policy "users send own mentor requests"
on core.mentor_requests for insert to authenticated
with check ((select auth.uid()) = requester_id);

create policy "participants delete requests"
on core.mentor_requests for delete to authenticated
using ((select auth.uid()) in (mentor_user_id, requester_id));

grant select, insert, delete on core.mentor_requests to authenticated;
grant all on core.mentor_requests to service_role;

-- ── Teams (Поиск команды) ────────────────────────────────────────────────────

create table core.teams (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id)
    on delete cascade,
  owner_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  event_name text not null default '',
  description text not null default '',
  needed_roles text[] not null default '{}',
  capacity integer not null default 5,
  created_at timestamptz not null default now(),
  constraint teams_title_not_empty check (length(trim(title)) > 0),
  constraint teams_capacity_valid check (capacity between 2 and 20)
);

create index teams_org_idx on core.teams (organization_id, created_at desc);

alter table core.teams enable row level security;

create policy "teams readable by org users"
on core.teams for select to authenticated using (true);

create policy "users create own teams"
on core.teams for insert to authenticated
with check ((select auth.uid()) = owner_id);

create policy "owners update own teams"
on core.teams for update to authenticated
using ((select auth.uid()) = owner_id)
with check ((select auth.uid()) = owner_id);

create policy "owners delete own teams"
on core.teams for delete to authenticated
using ((select auth.uid()) = owner_id);

grant select, insert, update, delete on core.teams to authenticated;
grant all on core.teams to service_role;

create table core.team_members (
  team_id uuid not null references core.teams(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (team_id, user_id)
);

alter table core.team_members enable row level security;

create policy "team members readable by org users"
on core.team_members for select to authenticated using (true);

create policy "users join teams"
on core.team_members for insert to authenticated
with check ((select auth.uid()) = user_id);

create policy "users leave teams"
on core.team_members for delete to authenticated
using ((select auth.uid()) = user_id);

grant select, insert, delete on core.team_members to authenticated;
grant all on core.team_members to service_role;

-- ═════════════════════════════════════════════════════════════════════════════
-- RPCs. Reads are security definer to expose first names from owner-RLS'd
-- academic profiles; mutations are invoker + RLS.
-- ═════════════════════════════════════════════════════════════════════════════

create or replace function app_api_v1.get_listings(p_organization_id text)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', l.id,
        'title', l.title,
        'description', l.description,
        'price', l.price,
        'category', l.category,
        'emoji', l.emoji,
        'isSold', l.is_sold,
        'createdAt', l.created_at,
        'isMine', l.seller_id = (select auth.uid()),
        'sellerName', coalesce(
          (select split_part(p.full_name, ' ', 1) || ' '
              || left(split_part(p.full_name, ' ', 2), 1) || '.'
           from core.user_academic_profiles p
           where p.user_id = l.seller_id),
          'студент'
        )
      )
      order by l.is_sold, l.created_at desc
    ),
    '[]'::jsonb
  )
  from core.marketplace_listings l
  where l.organization_id = p_organization_id
    and (not l.is_sold or l.seller_id = (select auth.uid()));
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
  insert into core.marketplace_listings (
    organization_id, seller_id, title, description, price, category, emoji
  )
  values (
    p_organization_id, v_user_id, p_title, coalesce(p_description, ''),
    greatest(coalesce(p_price, 0), 0), coalesce(p_category, 'other'),
    coalesce(p_emoji, '📦')
  )
  returning id into v_id;
  return v_id;
end;
$$;

create or replace function app_api_v1.set_listing_sold(
  p_id uuid,
  p_sold boolean
)
returns void
language sql
security invoker
set search_path = ''
as $$
  update core.marketplace_listings
  set is_sold = p_sold
  where id = p_id and seller_id = (select auth.uid());
$$;

create or replace function app_api_v1.delete_listing(p_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$
  delete from core.marketplace_listings
  where id = p_id and seller_id = (select auth.uid());
$$;

create or replace function app_api_v1.get_mentors(p_organization_id text)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'userId', m.user_id,
        'topics', to_jsonb(m.topics),
        'bio', m.bio,
        'sessions', m.sessions_count,
        'level', m.level,
        'formats', to_jsonb(m.formats),
        'price', m.price,
        'isMe', m.user_id = (select auth.uid()),
        'fullName', coalesce(p.full_name, 'Студент'),
        'course', p.course,
        'group', p.academic_group,
        'handle', p.handle
      )
      order by m.sessions_count desc, m.created_at
    ),
    '[]'::jsonb
  )
  from core.mentor_profiles m
  left join core.user_academic_profiles p on p.user_id = m.user_id
  where m.organization_id = p_organization_id and m.is_active;
$$;

create or replace function app_api_v1.upsert_mentor_profile(
  p_organization_id text,
  p_topics text[],
  p_bio text default '',
  p_level text default '',
  p_formats text[] default '{}',
  p_price integer default 0
)
returns void
language sql
security invoker
set search_path = ''
as $$
  insert into core.mentor_profiles (
    user_id, organization_id, topics, bio, level, formats, price
  )
  values (
    (select auth.uid()), p_organization_id, p_topics, coalesce(p_bio, ''),
    coalesce(p_level, ''), coalesce(p_formats, '{}'),
    greatest(coalesce(p_price, 0), 0)
  )
  on conflict (user_id)
  do update set
    topics = excluded.topics,
    bio = excluded.bio,
    level = excluded.level,
    formats = excluded.formats,
    price = excluded.price,
    is_active = true;
$$;

create or replace function app_api_v1.delete_mentor_profile()
returns void
language sql
security invoker
set search_path = ''
as $$
  delete from core.mentor_profiles
  where user_id = (select auth.uid());
$$;

create or replace function app_api_v1.create_mentor_request(
  p_organization_id text,
  p_mentor_user_id uuid,
  p_topic text default '',
  p_when_slot text default 'week',
  p_message text default ''
)
returns uuid
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
  insert into core.mentor_requests (
    organization_id, mentor_user_id, requester_id, topic, when_slot, message
  )
  values (
    p_organization_id, p_mentor_user_id, v_user_id,
    coalesce(p_topic, ''), coalesce(p_when_slot, 'week'),
    coalesce(p_message, '')
  )
  returning id into v_id;
  return v_id;
end;
$$;

create or replace function app_api_v1.get_my_mentor_requests(
  p_organization_id text
)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', r.id,
        'topic', r.topic,
        'whenSlot', r.when_slot,
        'message', r.message,
        'createdAt', r.created_at,
        'requesterName', coalesce(
          (select split_part(p.full_name, ' ', 1) || ' '
              || left(split_part(p.full_name, ' ', 2), 1) || '.'
           from core.user_academic_profiles p
           where p.user_id = r.requester_id),
          'студент'
        ),
        'requesterHandle', (
          select p.handle from core.user_academic_profiles p
          where p.user_id = r.requester_id
        )
      )
      order by r.created_at desc
    ),
    '[]'::jsonb
  )
  from core.mentor_requests r
  where r.mentor_user_id = (select auth.uid())
    and r.organization_id = p_organization_id;
$$;

create or replace function app_api_v1.delete_mentor_request(p_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$
  delete from core.mentor_requests
  where id = p_id
    and (select auth.uid()) in (mentor_user_id, requester_id);
$$;

create or replace function app_api_v1.get_teams(p_organization_id text)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', t.id,
        'title', t.title,
        'eventName', t.event_name,
        'description', t.description,
        'neededRoles', to_jsonb(t.needed_roles),
        'capacity', t.capacity,
        'createdAt', t.created_at,
        'isMine', t.owner_id = (select auth.uid()),
        'isMember', exists (
          select 1 from core.team_members tm
          where tm.team_id = t.id
            and tm.user_id = (select auth.uid())
        ),
        'memberCount', (
          select count(*) + 1 from core.team_members tm
          where tm.team_id = t.id
        ),
        'memberNames', (
          select coalesce(jsonb_agg(n.first_name), '[]'::jsonb)
          from (
            select split_part(p.full_name, ' ', 1) as first_name
            from core.user_academic_profiles p
            where p.user_id = t.owner_id
            union all
            select split_part(p.full_name, ' ', 1)
            from core.team_members tm
            join core.user_academic_profiles p on p.user_id = tm.user_id
            where tm.team_id = t.id
            limit 4
          ) n
        )
      )
      order by t.created_at desc
    ),
    '[]'::jsonb
  )
  from core.teams t
  where t.organization_id = p_organization_id;
$$;

create or replace function app_api_v1.create_team(
  p_organization_id text,
  p_title text,
  p_event_name text default '',
  p_description text default '',
  p_needed_roles text[] default '{}',
  p_capacity integer default 5
)
returns uuid
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
  insert into core.teams (
    organization_id, owner_id, title, event_name, description,
    needed_roles, capacity
  )
  values (
    p_organization_id, v_user_id, p_title, coalesce(p_event_name, ''),
    coalesce(p_description, ''), coalesce(p_needed_roles, '{}'),
    least(greatest(coalesce(p_capacity, 5), 2), 20)
  )
  returning id into v_id;
  return v_id;
end;
$$;

create or replace function app_api_v1.set_team_membership(
  p_team_id uuid,
  p_join boolean
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_capacity integer;
  v_count integer;
begin
  if p_join then
    select capacity into v_capacity from core.teams where id = p_team_id;
    select count(*) + 1 into v_count
    from core.team_members where team_id = p_team_id;
    if v_count >= v_capacity then
      raise exception 'Team is full';
    end if;
    insert into core.team_members (team_id, user_id)
    values (p_team_id, v_user_id)
    on conflict do nothing;
  else
    delete from core.team_members
    where team_id = p_team_id and user_id = v_user_id;
  end if;
end;
$$;

create or replace function app_api_v1.delete_team(p_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$
  delete from core.teams
  where id = p_id and owner_id = (select auth.uid());
$$;

-- ── public wrappers ──────────────────────────────────────────────────────────

create or replace function public.get_listings(p_organization_id text)
returns jsonb language sql stable security definer set search_path = ''
as $$ select app_api_v1.get_listings(p_organization_id); $$;

create or replace function public.create_listing(
  p_organization_id text, p_title text, p_price integer,
  p_category text default 'other', p_emoji text default '📦',
  p_description text default ''
)
returns uuid language sql security invoker set search_path = ''
as $$
  select app_api_v1.create_listing(
    p_organization_id, p_title, p_price, p_category, p_emoji, p_description
  );
$$;

create or replace function public.set_listing_sold(p_id uuid, p_sold boolean)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.set_listing_sold(p_id, p_sold); $$;

create or replace function public.delete_listing(p_id uuid)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.delete_listing(p_id); $$;

create or replace function public.get_mentors(p_organization_id text)
returns jsonb language sql stable security definer set search_path = ''
as $$ select app_api_v1.get_mentors(p_organization_id); $$;

create or replace function public.upsert_mentor_profile(
  p_organization_id text, p_topics text[], p_bio text default '',
  p_level text default '', p_formats text[] default '{}',
  p_price integer default 0
)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.upsert_mentor_profile(
  p_organization_id, p_topics, p_bio, p_level, p_formats, p_price
); $$;

create or replace function public.delete_mentor_profile()
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.delete_mentor_profile(); $$;

create or replace function public.create_mentor_request(
  p_organization_id text, p_mentor_user_id uuid, p_topic text default '',
  p_when_slot text default 'week', p_message text default ''
)
returns uuid language sql security invoker set search_path = ''
as $$ select app_api_v1.create_mentor_request(
  p_organization_id, p_mentor_user_id, p_topic, p_when_slot, p_message
); $$;

create or replace function public.get_my_mentor_requests(
  p_organization_id text
)
returns jsonb language sql stable security definer set search_path = ''
as $$ select app_api_v1.get_my_mentor_requests(p_organization_id); $$;

create or replace function public.delete_mentor_request(p_id uuid)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.delete_mentor_request(p_id); $$;

create or replace function public.get_teams(p_organization_id text)
returns jsonb language sql stable security definer set search_path = ''
as $$ select app_api_v1.get_teams(p_organization_id); $$;

create or replace function public.create_team(
  p_organization_id text, p_title text, p_event_name text default '',
  p_description text default '', p_needed_roles text[] default '{}',
  p_capacity integer default 5
)
returns uuid language sql security invoker set search_path = ''
as $$
  select app_api_v1.create_team(
    p_organization_id, p_title, p_event_name, p_description,
    p_needed_roles, p_capacity
  );
$$;

create or replace function public.set_team_membership(
  p_team_id uuid, p_join boolean
)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.set_team_membership(p_team_id, p_join); $$;

create or replace function public.delete_team(p_id uuid)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.delete_team(p_id); $$;

-- lock down
revoke all on function public.get_listings(text) from public, anon;
revoke all on function
  public.create_listing(text, text, integer, text, text, text)
  from public, anon;
revoke all on function public.set_listing_sold(uuid, boolean)
  from public, anon;
revoke all on function public.delete_listing(uuid) from public, anon;
revoke all on function public.get_mentors(text) from public, anon;
revoke all on function public.upsert_mentor_profile(
  text, text[], text, text, text[], integer
)
  from public, anon;
revoke all on function public.delete_mentor_profile() from public, anon;
revoke all on function public.create_mentor_request(
  text, uuid, text, text, text
) from public, anon;
revoke all on function public.get_my_mentor_requests(text) from public, anon;
revoke all on function public.delete_mentor_request(uuid) from public, anon;
revoke all on function public.get_teams(text) from public, anon;
revoke all on function
  public.create_team(text, text, text, text, text[], integer)
  from public, anon;
revoke all on function public.set_team_membership(uuid, boolean)
  from public, anon;
revoke all on function public.delete_team(uuid) from public, anon;

grant execute on function public.get_listings(text) to authenticated;
grant execute on function
  public.create_listing(text, text, integer, text, text, text)
  to authenticated;
grant execute on function public.set_listing_sold(uuid, boolean)
  to authenticated;
grant execute on function public.delete_listing(uuid) to authenticated;
grant execute on function public.get_mentors(text) to authenticated;
grant execute on function public.upsert_mentor_profile(
  text, text[], text, text, text[], integer
)
  to authenticated;
grant execute on function public.delete_mentor_profile() to authenticated;
grant execute on function public.create_mentor_request(
  text, uuid, text, text, text
) to authenticated;
grant execute on function public.get_my_mentor_requests(text) to authenticated;
grant execute on function public.delete_mentor_request(uuid) to authenticated;
grant execute on function public.get_teams(text) to authenticated;
grant execute on function
  public.create_team(text, text, text, text, text[], integer)
  to authenticated;
grant execute on function public.set_team_membership(uuid, boolean)
  to authenticated;
grant execute on function public.delete_team(uuid) to authenticated;
