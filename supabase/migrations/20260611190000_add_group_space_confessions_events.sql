-- Group space (links, posts+likes, fund, birthdays), anonymous confessions
-- (Подслушано) and campus events (Афиша) with RSVPs.
-- Applied remotely as three migrations:
--   add_group_space_confessions_events (tables)
--   add_group_space_confessions_events_rpcs (app_api_v1)
--   add_group_space_confessions_events_wrappers (public)

-- ── Group space: links ───────────────────────────────────────────────────────

create table core.group_links (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id)
    on delete cascade,
  academic_group text not null,
  kind text not null default 'link',
  emoji text not null default '🔗',
  title text not null,
  url text not null,
  created_by uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  constraint group_links_kind_valid check (kind in ('link', 'telegram')),
  constraint group_links_title_not_empty check (length(trim(title)) > 0),
  constraint group_links_url_not_empty check (length(trim(url)) > 0)
);

create index group_links_group_idx
on core.group_links (academic_group, created_at desc);

alter table core.group_links enable row level security;

create policy "group links readable by groupmates"
on core.group_links for select to authenticated
using (academic_group = core.current_academic_group());

create policy "groupmates insert links"
on core.group_links for insert to authenticated
with check (
  (select auth.uid()) = created_by
  and academic_group = core.current_academic_group()
);

create policy "authors delete own links"
on core.group_links for delete to authenticated
using ((select auth.uid()) = created_by);

grant select, insert, delete on core.group_links to authenticated;
grant all on core.group_links to service_role;

-- ── Group space: posts (announcements + shared notes) ────────────────────────

create table core.group_posts (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id)
    on delete cascade,
  academic_group text not null,
  author_id uuid not null references auth.users(id) on delete cascade,
  kind text not null default 'note',
  title text not null,
  body text not null default '',
  is_pinned boolean not null default false,
  created_at timestamptz not null default now(),
  constraint group_posts_kind_valid check (kind in ('announcement', 'note')),
  constraint group_posts_title_not_empty check (length(trim(title)) > 0)
);

create index group_posts_group_idx
on core.group_posts (academic_group, is_pinned desc, created_at desc);

alter table core.group_posts enable row level security;

create policy "group posts readable by groupmates"
on core.group_posts for select to authenticated
using (academic_group = core.current_academic_group());

create policy "groupmates insert posts"
on core.group_posts for insert to authenticated
with check (
  (select auth.uid()) = author_id
  and academic_group = core.current_academic_group()
);

create policy "authors update own posts"
on core.group_posts for update to authenticated
using ((select auth.uid()) = author_id)
with check ((select auth.uid()) = author_id);

create policy "authors delete own posts"
on core.group_posts for delete to authenticated
using ((select auth.uid()) = author_id);

grant select, insert, update, delete on core.group_posts to authenticated;
grant all on core.group_posts to service_role;

create table core.group_post_likes (
  post_id uuid not null references core.group_posts(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (post_id, user_id)
);

alter table core.group_post_likes enable row level security;

create policy "likes readable by groupmates"
on core.group_post_likes for select to authenticated
using (
  exists (
    select 1 from core.group_posts p
    where p.id = post_id
      and p.academic_group = core.current_academic_group()
  )
);

create policy "users like group posts"
on core.group_post_likes for insert to authenticated
with check (
  (select auth.uid()) = user_id
  and exists (
    select 1 from core.group_posts p
    where p.id = post_id
      and p.academic_group = core.current_academic_group()
  )
);

create policy "users unlike own likes"
on core.group_post_likes for delete to authenticated
using ((select auth.uid()) = user_id);

grant select, insert, delete on core.group_post_likes to authenticated;
grant all on core.group_post_likes to service_role;

-- ── Group space: shared fund (касса) ─────────────────────────────────────────

create table core.group_funds (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id)
    on delete cascade,
  academic_group text not null,
  title text not null,
  goal_amount integer not null,
  is_active boolean not null default true,
  created_by uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  constraint group_funds_goal_positive check (goal_amount > 0),
  constraint group_funds_title_not_empty check (length(trim(title)) > 0)
);

create index group_funds_group_idx
on core.group_funds (academic_group, is_active, created_at desc);

alter table core.group_funds enable row level security;

create policy "funds readable by groupmates"
on core.group_funds for select to authenticated
using (academic_group = core.current_academic_group());

create policy "groupmates create funds"
on core.group_funds for insert to authenticated
with check (
  (select auth.uid()) = created_by
  and academic_group = core.current_academic_group()
);

create policy "creators update own funds"
on core.group_funds for update to authenticated
using ((select auth.uid()) = created_by)
with check ((select auth.uid()) = created_by);

grant select, insert, update on core.group_funds to authenticated;
grant all on core.group_funds to service_role;

create table core.group_fund_contributions (
  fund_id uuid not null references core.group_funds(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  amount integer not null,
  created_at timestamptz not null default now(),
  primary key (fund_id, user_id),
  constraint fund_contributions_amount_positive check (amount > 0)
);

alter table core.group_fund_contributions enable row level security;

create policy "contributions readable by groupmates"
on core.group_fund_contributions for select to authenticated
using (
  exists (
    select 1 from core.group_funds f
    where f.id = fund_id
      and f.academic_group = core.current_academic_group()
  )
);

create policy "users contribute to group funds"
on core.group_fund_contributions for insert to authenticated
with check (
  (select auth.uid()) = user_id
  and exists (
    select 1 from core.group_funds f
    where f.id = fund_id
      and f.academic_group = core.current_academic_group()
      and f.is_active
  )
);

create policy "users update own contributions"
on core.group_fund_contributions for update to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

grant select, insert, update on core.group_fund_contributions
  to authenticated;
grant all on core.group_fund_contributions to service_role;

-- ── Birthdays ────────────────────────────────────────────────────────────────

alter table core.user_academic_profiles
  add column if not exists birth_date date;

-- ── Confessions (Подслушано) — author is never exposed ───────────────────────

create table core.confessions (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id)
    on delete cascade,
  author_id uuid not null references auth.users(id) on delete cascade,
  body text not null,
  tag text not null default '',
  created_at timestamptz not null default now(),
  constraint confessions_body_not_empty check (length(trim(body)) > 0),
  constraint confessions_body_max check (length(body) <= 2000)
);

create index confessions_org_idx
on core.confessions (organization_id, created_at desc);

alter table core.confessions enable row level security;

create policy "confessions readable by org users"
on core.confessions for select to authenticated
using (true);

create policy "users insert own confessions"
on core.confessions for insert to authenticated
with check ((select auth.uid()) = author_id);

create policy "authors delete own confessions"
on core.confessions for delete to authenticated
using ((select auth.uid()) = author_id);

grant select, insert, delete on core.confessions to authenticated;
grant all on core.confessions to service_role;

create table core.confession_likes (
  confession_id uuid not null references core.confessions(id)
    on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (confession_id, user_id)
);

alter table core.confession_likes enable row level security;

create policy "confession likes readable"
on core.confession_likes for select to authenticated
using (true);

create policy "users like confessions"
on core.confession_likes for insert to authenticated
with check ((select auth.uid()) = user_id);

create policy "users unlike confessions"
on core.confession_likes for delete to authenticated
using ((select auth.uid()) = user_id);

grant select, insert, delete on core.confession_likes to authenticated;
grant all on core.confession_likes to service_role;

-- ── Campus events (Афиша) ────────────────────────────────────────────────────

create table core.campus_events (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id)
    on delete cascade,
  title text not null,
  description text not null default '',
  emoji text not null default '🎉',
  category text not null default 'other',
  place text not null default '',
  starts_at timestamptz not null,
  created_by uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  constraint campus_events_title_not_empty check (length(trim(title)) > 0)
);

create index campus_events_org_idx
on core.campus_events (organization_id, starts_at);

alter table core.campus_events enable row level security;

create policy "events readable by org users"
on core.campus_events for select to authenticated
using (true);

create policy "users create events"
on core.campus_events for insert to authenticated
with check ((select auth.uid()) = created_by);

create policy "creators update own events"
on core.campus_events for update to authenticated
using ((select auth.uid()) = created_by)
with check ((select auth.uid()) = created_by);

create policy "creators delete own events"
on core.campus_events for delete to authenticated
using ((select auth.uid()) = created_by);

grant select, insert, update, delete on core.campus_events to authenticated;
grant all on core.campus_events to service_role;

create table core.event_rsvps (
  event_id uuid not null references core.campus_events(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (event_id, user_id)
);

alter table core.event_rsvps enable row level security;

create policy "rsvps readable by org users"
on core.event_rsvps for select to authenticated
using (true);

create policy "users rsvp"
on core.event_rsvps for insert to authenticated
with check ((select auth.uid()) = user_id);

create policy "users cancel own rsvp"
on core.event_rsvps for delete to authenticated
using ((select auth.uid()) = user_id);

grant select, insert, delete on core.event_rsvps to authenticated;
grant all on core.event_rsvps to service_role;

-- ═════════════════════════════════════════════════════════════════════════════
-- app_api_v1 RPCs. Reads are security definer where groupmate/author names
-- are needed (profiles are owner-RLS'd); access is always gated on the
-- caller's own academic group / authentication.
-- ═════════════════════════════════════════════════════════════════════════════

create or replace function app_api_v1.get_group_space(p_organization_id text)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  with me as (
    select
      (select auth.uid()) as user_id,
      core.current_academic_group() as academic_group
  ),
  members as (
    select p.user_id, p.full_name, p.birth_date
    from core.user_academic_profiles p, me
    where p.academic_group = me.academic_group
      and me.academic_group is not null
  )
  select jsonb_build_object(
    'group', (select academic_group from me),
    'memberCount', (select count(*) from members),
    'memberNames', (
      select coalesce(jsonb_agg(full_name), '[]'::jsonb)
      from (select full_name from members limit 5) m
    ),
    'links', (
      select coalesce(
        jsonb_agg(
          jsonb_build_object(
            'id', l.id,
            'kind', l.kind,
            'emoji', l.emoji,
            'title', l.title,
            'url', l.url,
            'addedBy', coalesce(
              (select split_part(m.full_name, ' ', 1)
               from members m where m.user_id = l.created_by),
              'аноним'
            ),
            'isMine', l.created_by = (select user_id from me)
          )
          order by l.created_at
        ),
        '[]'::jsonb
      )
      from core.group_links l, me
      where l.academic_group = me.academic_group
    ),
    'announcement', (
      select jsonb_build_object(
        'id', p.id,
        'title', p.title,
        'body', p.body,
        'authorName', coalesce(
          (select split_part(m.full_name, ' ', 1)
           from members m where m.user_id = p.author_id),
          'аноним'
        ),
        'createdAt', p.created_at,
        'isMine', p.author_id = (select user_id from me)
      )
      from core.group_posts p, me
      where p.academic_group = me.academic_group
        and p.kind = 'announcement'
      order by p.created_at desc
      limit 1
    ),
    'notes', (
      select coalesce(
        jsonb_agg(
          jsonb_build_object(
            'id', p.id,
            'title', p.title,
            'body', p.body,
            'authorName', coalesce(
              (select split_part(m.full_name, ' ', 1)
               from members m where m.user_id = p.author_id),
              'аноним'
            ),
            'createdAt', p.created_at,
            'isPinned', p.is_pinned,
            'isMine', p.author_id = (select user_id from me),
            'likes', (
              select count(*) from core.group_post_likes gl
              where gl.post_id = p.id
            ),
            'likedByMe', exists (
              select 1 from core.group_post_likes gl
              where gl.post_id = p.id
                and gl.user_id = (select user_id from me)
            )
          )
          order by p.is_pinned desc, p.created_at desc
        ),
        '[]'::jsonb
      )
      from core.group_posts p, me
      where p.academic_group = me.academic_group and p.kind = 'note'
    ),
    'birthdays', (
      select coalesce(
        jsonb_agg(
          jsonb_build_object(
            'name', b.full_name,
            'date', b.next_birthday,
            'isMe', b.user_id = (select user_id from me)
          )
          order by b.next_birthday
        ),
        '[]'::jsonb
      )
      from (
        select
          m.user_id,
          m.full_name,
          (m.birth_date + make_interval(
            years => extract(year from age(now(), m.birth_date))::int
              + case
                  when (m.birth_date + make_interval(
                    years => extract(
                      year from age(now(), m.birth_date)
                    )::int
                  ))::date < current_date then 1
                  else 0
                end
          ))::date as next_birthday
        from members m
        where m.birth_date is not null
      ) b
      where b.next_birthday <= current_date + 60
    ),
    'fund', (
      select jsonb_build_object(
        'id', f.id,
        'title', f.title,
        'goal', f.goal_amount,
        'total', coalesce(
          (select sum(c.amount) from core.group_fund_contributions c
           where c.fund_id = f.id),
          0
        ),
        'contributors', (
          select count(*) from core.group_fund_contributions c
          where c.fund_id = f.id
        ),
        'myAmount', coalesce(
          (select c.amount from core.group_fund_contributions c
           where c.fund_id = f.id
             and c.user_id = (select user_id from me)),
          0
        )
      )
      from core.group_funds f, me
      where f.academic_group = me.academic_group and f.is_active
      order by f.created_at desc
      limit 1
    )
  );
$$;

create or replace function app_api_v1.add_group_link(
  p_organization_id text,
  p_title text,
  p_url text,
  p_emoji text default '🔗',
  p_kind text default 'link'
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group text := core.current_academic_group();
  v_id uuid;
begin
  if v_user_id is null or v_group is null then
    raise exception 'Unauthorized or no academic group';
  end if;
  insert into core.group_links (
    organization_id, academic_group, kind, emoji, title, url, created_by
  )
  values (
    p_organization_id, v_group, p_kind, coalesce(p_emoji, '🔗'),
    p_title, p_url, v_user_id
  )
  returning id into v_id;
  return v_id;
end;
$$;

create or replace function app_api_v1.delete_group_link(p_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$
  delete from core.group_links
  where id = p_id and created_by = (select auth.uid());
$$;

create or replace function app_api_v1.create_group_post(
  p_organization_id text,
  p_title text,
  p_body text default '',
  p_kind text default 'note',
  p_pinned boolean default false
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group text := core.current_academic_group();
  v_id uuid;
begin
  if v_user_id is null or v_group is null then
    raise exception 'Unauthorized or no academic group';
  end if;
  insert into core.group_posts (
    organization_id, academic_group, author_id, kind, title, body, is_pinned
  )
  values (
    p_organization_id, v_group, v_user_id, p_kind, p_title,
    coalesce(p_body, ''), coalesce(p_pinned, false)
  )
  returning id into v_id;
  return v_id;
end;
$$;

create or replace function app_api_v1.delete_group_post(p_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$
  delete from core.group_posts
  where id = p_id and author_id = (select auth.uid());
$$;

create or replace function app_api_v1.toggle_group_post_like(p_id uuid)
returns boolean
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_deleted boolean;
begin
  delete from core.group_post_likes
  where post_id = p_id and user_id = v_user_id;
  v_deleted := found;
  if not v_deleted then
    insert into core.group_post_likes (post_id, user_id)
    values (p_id, v_user_id)
    on conflict do nothing;
    return true;
  end if;
  return false;
end;
$$;

create or replace function app_api_v1.create_group_fund(
  p_organization_id text,
  p_title text,
  p_goal integer
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group text := core.current_academic_group();
  v_id uuid;
begin
  if v_user_id is null or v_group is null then
    raise exception 'Unauthorized or no academic group';
  end if;
  insert into core.group_funds (
    organization_id, academic_group, title, goal_amount, created_by
  )
  values (p_organization_id, v_group, p_title, p_goal, v_user_id)
  returning id into v_id;
  return v_id;
end;
$$;

create or replace function app_api_v1.contribute_to_fund(
  p_fund_id uuid,
  p_amount integer
)
returns void
language sql
security invoker
set search_path = ''
as $$
  insert into core.group_fund_contributions (fund_id, user_id, amount)
  values (p_fund_id, (select auth.uid()), p_amount)
  on conflict (fund_id, user_id)
  do update set amount = core.group_fund_contributions.amount
    + excluded.amount;
$$;

create or replace function app_api_v1.set_my_birth_date(p_date date)
returns void
language sql
security invoker
set search_path = ''
as $$
  update core.user_academic_profiles
  set birth_date = p_date
  where user_id = (select auth.uid());
$$;

create or replace function app_api_v1.get_confessions(
  p_organization_id text,
  p_limit integer default 50
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
        'id', c.id,
        'body', c.body,
        'tag', c.tag,
        'createdAt', c.created_at,
        'likes', (
          select count(*) from core.confession_likes cl
          where cl.confession_id = c.id
        ),
        'likedByMe', exists (
          select 1 from core.confession_likes cl
          where cl.confession_id = c.id
            and cl.user_id = (select auth.uid())
        ),
        'isMine', c.author_id = (select auth.uid())
      )
      order by c.created_at desc
    ),
    '[]'::jsonb
  )
  from (
    select * from core.confessions
    where organization_id = p_organization_id
    order by created_at desc
    limit least(coalesce(p_limit, 50), 100)
  ) c;
$$;

create or replace function app_api_v1.create_confession(
  p_organization_id text,
  p_body text,
  p_tag text default ''
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
  insert into core.confessions (organization_id, author_id, body, tag)
  values (p_organization_id, v_user_id, p_body, coalesce(p_tag, ''))
  returning id into v_id;
  return v_id;
end;
$$;

create or replace function app_api_v1.toggle_confession_like(p_id uuid)
returns boolean
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_deleted boolean;
begin
  delete from core.confession_likes
  where confession_id = p_id and user_id = v_user_id;
  v_deleted := found;
  if not v_deleted then
    insert into core.confession_likes (confession_id, user_id)
    values (p_id, v_user_id)
    on conflict do nothing;
    return true;
  end if;
  return false;
end;
$$;

create or replace function app_api_v1.delete_confession(p_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$
  delete from core.confessions
  where id = p_id and author_id = (select auth.uid());
$$;

create or replace function app_api_v1.get_events(p_organization_id text)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', e.id,
        'title', e.title,
        'description', e.description,
        'emoji', e.emoji,
        'category', e.category,
        'place', e.place,
        'startsAt', e.starts_at,
        'goingCount', (
          select count(*) from core.event_rsvps r where r.event_id = e.id
        ),
        'isGoing', exists (
          select 1 from core.event_rsvps r
          where r.event_id = e.id and r.user_id = (select auth.uid())
        ),
        'isMine', e.created_by = (select auth.uid()),
        'goingNames', (
          select coalesce(jsonb_agg(g.first_name), '[]'::jsonb)
          from (
            select split_part(p.full_name, ' ', 1) as first_name
            from core.event_rsvps r
            join core.user_academic_profiles p on p.user_id = r.user_id
            where r.event_id = e.id
            order by r.created_at
            limit 3
          ) g
        )
      )
      order by e.starts_at
    ),
    '[]'::jsonb
  )
  from core.campus_events e
  where e.organization_id = p_organization_id
    and e.starts_at > now() - interval '12 hours';
$$;

create or replace function app_api_v1.create_event(
  p_organization_id text,
  p_title text,
  p_starts_at timestamptz,
  p_place text default '',
  p_emoji text default '🎉',
  p_category text default 'other',
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
  insert into core.campus_events (
    organization_id, title, description, emoji, category, place,
    starts_at, created_by
  )
  values (
    p_organization_id, p_title, coalesce(p_description, ''),
    coalesce(p_emoji, '🎉'), coalesce(p_category, 'other'),
    coalesce(p_place, ''), p_starts_at, v_user_id
  )
  returning id into v_id;
  return v_id;
end;
$$;

create or replace function app_api_v1.set_event_rsvp(
  p_event_id uuid,
  p_going boolean
)
returns void
language sql
security invoker
set search_path = ''
as $$
  with del as (
    delete from core.event_rsvps
    where event_id = p_event_id
      and user_id = (select auth.uid())
      and p_going = false
  )
  insert into core.event_rsvps (event_id, user_id)
  select p_event_id, (select auth.uid())
  where p_going
  on conflict do nothing;
$$;

create or replace function app_api_v1.delete_event(p_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$
  delete from core.campus_events
  where id = p_id and created_by = (select auth.uid());
$$;

-- ═════════════════════════════════════════════════════════════════════════════
-- public wrappers
-- ═════════════════════════════════════════════════════════════════════════════

create or replace function public.get_group_space(p_organization_id text)
returns jsonb language sql stable security definer set search_path = ''
as $$ select app_api_v1.get_group_space(p_organization_id); $$;

create or replace function public.add_group_link(
  p_organization_id text, p_title text, p_url text,
  p_emoji text default '🔗', p_kind text default 'link'
)
returns uuid language sql security invoker set search_path = ''
as $$
  select app_api_v1.add_group_link(
    p_organization_id, p_title, p_url, p_emoji, p_kind
  );
$$;

create or replace function public.delete_group_link(p_id uuid)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.delete_group_link(p_id); $$;

create or replace function public.create_group_post(
  p_organization_id text, p_title text, p_body text default '',
  p_kind text default 'note', p_pinned boolean default false
)
returns uuid language sql security invoker set search_path = ''
as $$
  select app_api_v1.create_group_post(
    p_organization_id, p_title, p_body, p_kind, p_pinned
  );
$$;

create or replace function public.delete_group_post(p_id uuid)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.delete_group_post(p_id); $$;

create or replace function public.toggle_group_post_like(p_id uuid)
returns boolean language sql security invoker set search_path = ''
as $$ select app_api_v1.toggle_group_post_like(p_id); $$;

create or replace function public.create_group_fund(
  p_organization_id text, p_title text, p_goal integer
)
returns uuid language sql security invoker set search_path = ''
as $$
  select app_api_v1.create_group_fund(p_organization_id, p_title, p_goal);
$$;

create or replace function public.contribute_to_fund(
  p_fund_id uuid, p_amount integer
)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.contribute_to_fund(p_fund_id, p_amount); $$;

create or replace function public.set_my_birth_date(p_date date)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.set_my_birth_date(p_date); $$;

create or replace function public.get_confessions(
  p_organization_id text, p_limit integer default 50
)
returns jsonb language sql stable security invoker set search_path = ''
as $$ select app_api_v1.get_confessions(p_organization_id, p_limit); $$;

create or replace function public.create_confession(
  p_organization_id text, p_body text, p_tag text default ''
)
returns uuid language sql security invoker set search_path = ''
as $$
  select app_api_v1.create_confession(p_organization_id, p_body, p_tag);
$$;

create or replace function public.toggle_confession_like(p_id uuid)
returns boolean language sql security invoker set search_path = ''
as $$ select app_api_v1.toggle_confession_like(p_id); $$;

create or replace function public.delete_confession(p_id uuid)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.delete_confession(p_id); $$;

create or replace function public.get_events(p_organization_id text)
returns jsonb language sql stable security definer set search_path = ''
as $$ select app_api_v1.get_events(p_organization_id); $$;

create or replace function public.create_event(
  p_organization_id text, p_title text, p_starts_at timestamptz,
  p_place text default '', p_emoji text default '🎉',
  p_category text default 'other', p_description text default ''
)
returns uuid language sql security invoker set search_path = ''
as $$
  select app_api_v1.create_event(
    p_organization_id, p_title, p_starts_at, p_place, p_emoji,
    p_category, p_description
  );
$$;

create or replace function public.set_event_rsvp(
  p_event_id uuid, p_going boolean
)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.set_event_rsvp(p_event_id, p_going); $$;

create or replace function public.delete_event(p_id uuid)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.delete_event(p_id); $$;

-- lock down
revoke all on function public.get_group_space(text) from public, anon;
revoke all on function public.add_group_link(text, text, text, text, text)
  from public, anon;
revoke all on function public.delete_group_link(uuid) from public, anon;
revoke all on function
  public.create_group_post(text, text, text, text, boolean)
  from public, anon;
revoke all on function public.delete_group_post(uuid) from public, anon;
revoke all on function public.toggle_group_post_like(uuid) from public, anon;
revoke all on function public.create_group_fund(text, text, integer)
  from public, anon;
revoke all on function public.contribute_to_fund(uuid, integer)
  from public, anon;
revoke all on function public.set_my_birth_date(date) from public, anon;
revoke all on function public.get_confessions(text, integer)
  from public, anon;
revoke all on function public.create_confession(text, text, text)
  from public, anon;
revoke all on function public.toggle_confession_like(uuid) from public, anon;
revoke all on function public.delete_confession(uuid) from public, anon;
revoke all on function public.get_events(text) from public, anon;
revoke all on function
  public.create_event(text, text, timestamptz, text, text, text, text)
  from public, anon;
revoke all on function public.set_event_rsvp(uuid, boolean)
  from public, anon;
revoke all on function public.delete_event(uuid) from public, anon;

grant execute on function public.get_group_space(text) to authenticated;
grant execute on function
  public.add_group_link(text, text, text, text, text) to authenticated;
grant execute on function public.delete_group_link(uuid) to authenticated;
grant execute on function
  public.create_group_post(text, text, text, text, boolean)
  to authenticated;
grant execute on function public.delete_group_post(uuid) to authenticated;
grant execute on function public.toggle_group_post_like(uuid)
  to authenticated;
grant execute on function public.create_group_fund(text, text, integer)
  to authenticated;
grant execute on function public.contribute_to_fund(uuid, integer)
  to authenticated;
grant execute on function public.set_my_birth_date(date) to authenticated;
grant execute on function public.get_confessions(text, integer)
  to authenticated;
grant execute on function public.create_confession(text, text, text)
  to authenticated;
grant execute on function public.toggle_confession_like(uuid)
  to authenticated;
grant execute on function public.delete_confession(uuid) to authenticated;
grant execute on function public.get_events(text) to authenticated;
grant execute on function
  public.create_event(text, text, timestamptz, text, text, text, text)
  to authenticated;
grant execute on function public.set_event_rsvp(uuid, boolean)
  to authenticated;
grant execute on function public.delete_event(uuid) to authenticated;
