-- Mini apps platform (BDUI/Stac): user-published server-driven mini apps
-- with moderation, reports, ratings, per-user hiding and full-text search.
-- All mini app traffic is proxied through the `miniapp-proxy` edge function;
-- this migration also ships its rate-limit helper and the icons bucket.
-- Applied remotely as: add_mini_apps_platform.

-- ---------------------------------------------------------------------------
-- Moderators
-- ---------------------------------------------------------------------------

create table core.mini_app_moderators (
  organization_id text not null references core.organizations(id)
    on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (organization_id, user_id)
);

alter table core.mini_app_moderators enable row level security;

grant select on core.mini_app_moderators to authenticated;
grant all on core.mini_app_moderators to service_role;

-- Security definer so RLS policies and triggers can consult the moderator
-- list without recursive policy evaluation.
create or replace function core.is_mini_app_moderator(p_organization_id text)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from core.mini_app_moderators m
    where m.organization_id = p_organization_id
      and m.user_id = (select auth.uid())
  );
$$;

revoke all on function core.is_mini_app_moderator(text) from public, anon;
grant execute on function core.is_mini_app_moderator(text) to authenticated;
grant execute on function core.is_mini_app_moderator(text) to service_role;

create policy "moderators visible to self and other moderators"
on core.mini_app_moderators for select to authenticated
using (
  user_id = (select auth.uid())
  or core.is_mini_app_moderator(organization_id)
);

-- ---------------------------------------------------------------------------
-- Mini apps
-- ---------------------------------------------------------------------------

-- array_to_string is only STABLE; for a text[] input it is deterministic,
-- so this immutable wrapper is safe to use in the generated search column.
create or replace function core.mini_app_tags_to_text(p_tags text[])
returns text
language sql
immutable
set search_path = ''
as $$
  select coalesce(array_to_string(p_tags, ' '), '');
$$;

create table core.mini_apps (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id)
    on delete cascade,
  owner_id uuid not null references auth.users(id) on delete cascade,
  slug text not null,
  name text not null,
  description text not null default '',
  icon_emoji text not null default '🧩',
  icon_url text,
  accent_color text not null default '#7C5CFF',
  category text not null default 'other',
  tags text[] not null default '{}',
  -- hosted: screens live in core.mini_app_screens;
  -- remote: screens are fetched from origin_url by the proxy.
  source_kind text not null default 'hosted',
  origin_url text,
  entry_path text not null default '/',
  status text not null default 'draft',
  review_notes text,
  version integer not null default 1,
  launch_count bigint not null default 0,
  rating_avg numeric(3, 2) not null default 0,
  rating_count integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  published_at timestamptz,
  search tsvector generated always as (
    to_tsvector(
      'simple',
      coalesce(name, '') || ' ' || coalesce(description, '') || ' '
        || core.mini_app_tags_to_text(tags)
    )
  ) stored,
  constraint mini_apps_slug_format check (slug ~ '^[a-z0-9][a-z0-9-]{2,39}$'),
  constraint mini_apps_name_not_empty check (length(trim(name)) > 0),
  constraint mini_apps_accent_color_hex
    check (accent_color ~* '^#[0-9a-f]{6}$'),
  constraint mini_apps_category_valid check (
    category in ('study', 'campus', 'tools', 'fun', 'social', 'other')
  ),
  constraint mini_apps_source_kind_valid check (
    source_kind in ('hosted', 'remote')
  ),
  constraint mini_apps_origin_https check (
    origin_url is null or origin_url ~* '^https://'
  ),
  constraint mini_apps_remote_needs_origin check (
    source_kind <> 'remote' or origin_url is not null
  ),
  constraint mini_apps_entry_path_format check (entry_path ~ '^/'),
  constraint mini_apps_status_valid check (
    status in ('draft', 'pending_review', 'published', 'rejected', 'suspended')
  ),
  unique (organization_id, slug)
);

create index mini_apps_org_status_idx
on core.mini_apps (organization_id, status, launch_count desc);

create index mini_apps_owner_idx on core.mini_apps (owner_id, created_at desc);

create index mini_apps_search_idx on core.mini_apps using gin (search);

create trigger set_mini_apps_updated_at
before update on core.mini_apps
for each row execute function core.set_updated_at();

-- Owners may only move their app between draft/pending_review (submit,
-- unpublish, resubmit). Everything else (publish/reject/suspend/restore)
-- requires a moderator. A suspended app is frozen for its owner.
create or replace function core.mini_apps_guard_status()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if new.status is distinct from old.status
    and not core.is_mini_app_moderator(new.organization_id)
    and (select auth.uid()) is not null
  then
    if old.status = 'suspended' then
      raise exception 'Suspended mini apps can only be restored by moderators';
    end if;
    if new.status not in ('draft', 'pending_review') then
      raise exception 'Only moderators can set mini app status to %',
        new.status;
    end if;
  end if;
  if new.status = 'published' and new.published_at is null then
    new.published_at := now();
  end if;
  return new;
end;
$$;

create trigger guard_mini_apps_status
before update on core.mini_apps
for each row execute function core.mini_apps_guard_status();

alter table core.mini_apps enable row level security;

create policy "published mini apps readable, own and moderated always"
on core.mini_apps for select to authenticated
using (
  status = 'published'
  or owner_id = (select auth.uid())
  or core.is_mini_app_moderator(organization_id)
);

create policy "users create own mini apps"
on core.mini_apps for insert to authenticated
with check (
  owner_id = (select auth.uid())
  and status in ('draft', 'pending_review')
);

create policy "owners and moderators update mini apps"
on core.mini_apps for update to authenticated
using (
  owner_id = (select auth.uid())
  or core.is_mini_app_moderator(organization_id)
)
with check (
  owner_id = (select auth.uid())
  or core.is_mini_app_moderator(organization_id)
);

create policy "owners and moderators delete mini apps"
on core.mini_apps for delete to authenticated
using (
  owner_id = (select auth.uid())
  or core.is_mini_app_moderator(organization_id)
);

grant select, insert, update, delete on core.mini_apps to authenticated;
grant all on core.mini_apps to service_role;

-- ---------------------------------------------------------------------------
-- Hosted screens (BDUI JSON stored in Supabase)
-- ---------------------------------------------------------------------------

create table core.mini_app_screens (
  id uuid primary key default extensions.gen_random_uuid(),
  app_id uuid not null references core.mini_apps(id) on delete cascade,
  path text not null default '/',
  title text,
  json jsonb not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint mini_app_screens_path_format check (path ~ '^/'),
  constraint mini_app_screens_json_is_object
    check (jsonb_typeof(json) = 'object'),
  unique (app_id, path)
);

create trigger set_mini_app_screens_updated_at
before update on core.mini_app_screens
for each row execute function core.set_updated_at();

alter table core.mini_app_screens enable row level security;

create policy "screens readable with their app"
on core.mini_app_screens for select to authenticated
using (
  exists (
    select 1
    from core.mini_apps a
    where a.id = app_id
      and (
        a.status = 'published'
        or a.owner_id = (select auth.uid())
        or core.is_mini_app_moderator(a.organization_id)
      )
  )
);

create policy "owners manage screens"
on core.mini_app_screens for all to authenticated
using (
  exists (
    select 1 from core.mini_apps a
    where a.id = app_id and a.owner_id = (select auth.uid())
  )
)
with check (
  exists (
    select 1 from core.mini_apps a
    where a.id = app_id and a.owner_id = (select auth.uid())
  )
);

grant select, insert, update, delete on core.mini_app_screens
  to authenticated;
grant all on core.mini_app_screens to service_role;

-- ---------------------------------------------------------------------------
-- Reports
-- ---------------------------------------------------------------------------

create table core.mini_app_reports (
  id uuid primary key default extensions.gen_random_uuid(),
  app_id uuid not null references core.mini_apps(id) on delete cascade,
  reporter_id uuid not null references auth.users(id) on delete cascade,
  reason text not null,
  details text not null default '',
  status text not null default 'open',
  resolved_by uuid references auth.users(id) on delete set null,
  resolved_at timestamptz,
  created_at timestamptz not null default now(),
  constraint mini_app_reports_reason_valid check (
    reason in ('spam', 'inappropriate', 'broken', 'scam', 'privacy', 'other')
  ),
  constraint mini_app_reports_status_valid check (
    status in ('open', 'resolved', 'dismissed')
  )
);

create unique index mini_app_reports_one_open_per_user_idx
on core.mini_app_reports (app_id, reporter_id)
where status = 'open';

create index mini_app_reports_open_idx
on core.mini_app_reports (status, created_at desc);

alter table core.mini_app_reports enable row level security;

create policy "reporters and moderators read reports"
on core.mini_app_reports for select to authenticated
using (
  reporter_id = (select auth.uid())
  or exists (
    select 1 from core.mini_apps a
    where a.id = app_id and core.is_mini_app_moderator(a.organization_id)
  )
);

create policy "users report visible apps"
on core.mini_app_reports for insert to authenticated
with check (
  reporter_id = (select auth.uid())
  and exists (select 1 from core.mini_apps a where a.id = app_id)
);

create policy "moderators resolve reports"
on core.mini_app_reports for update to authenticated
using (
  exists (
    select 1 from core.mini_apps a
    where a.id = app_id and core.is_mini_app_moderator(a.organization_id)
  )
);

grant select, insert, update on core.mini_app_reports to authenticated;
grant all on core.mini_app_reports to service_role;

-- ---------------------------------------------------------------------------
-- Per-user hiding
-- ---------------------------------------------------------------------------

create table core.mini_app_hidden (
  user_id uuid not null references auth.users(id) on delete cascade,
  app_id uuid not null references core.mini_apps(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, app_id)
);

alter table core.mini_app_hidden enable row level security;

create policy "users manage own hidden apps"
on core.mini_app_hidden for all to authenticated
using (user_id = (select auth.uid()))
with check (user_id = (select auth.uid()));

grant select, insert, delete on core.mini_app_hidden to authenticated;
grant all on core.mini_app_hidden to service_role;

-- ---------------------------------------------------------------------------
-- Ratings
-- ---------------------------------------------------------------------------

create table core.mini_app_ratings (
  app_id uuid not null references core.mini_apps(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  rating integer not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint mini_app_ratings_range check (rating between 1 and 5),
  primary key (app_id, user_id)
);

create trigger set_mini_app_ratings_updated_at
before update on core.mini_app_ratings
for each row execute function core.set_updated_at();

alter table core.mini_app_ratings enable row level security;

create policy "users read own ratings"
on core.mini_app_ratings for select to authenticated
using (user_id = (select auth.uid()));

create policy "users manage own ratings"
on core.mini_app_ratings for all to authenticated
using (user_id = (select auth.uid()))
with check (user_id = (select auth.uid()));

grant select, insert, update, delete on core.mini_app_ratings
  to authenticated;
grant all on core.mini_app_ratings to service_role;

-- Denormalized aggregates on core.mini_apps keep the catalog query cheap.
create or replace function core.refresh_mini_app_rating()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_app uuid := coalesce(new.app_id, old.app_id);
begin
  update core.mini_apps a
  set rating_avg = coalesce(s.avg_rating, 0),
      rating_count = coalesce(s.cnt, 0)
  from (
    select round(avg(r.rating)::numeric, 2) as avg_rating, count(*) as cnt
    from core.mini_app_ratings r
    where r.app_id = v_app
  ) s
  where a.id = v_app;
  return coalesce(new, old);
end;
$$;

create trigger refresh_mini_app_rating_aggregates
after insert or update or delete on core.mini_app_ratings
for each row execute function core.refresh_mini_app_rating();

-- ---------------------------------------------------------------------------
-- Moderation log
-- ---------------------------------------------------------------------------

create table core.mini_app_moderation_log (
  id uuid primary key default extensions.gen_random_uuid(),
  app_id uuid not null references core.mini_apps(id) on delete cascade,
  moderator_id uuid references auth.users(id) on delete set null,
  action text not null,
  notes text not null default '',
  created_at timestamptz not null default now(),
  constraint mini_app_moderation_action_valid check (
    action in (
      'approved', 'rejected', 'suspended', 'restored', 'auto_suspended',
      'reports_resolved', 'reports_dismissed'
    )
  )
);

create index mini_app_moderation_log_app_idx
on core.mini_app_moderation_log (app_id, created_at desc);

alter table core.mini_app_moderation_log enable row level security;

create policy "moderators and owners read moderation log"
on core.mini_app_moderation_log for select to authenticated
using (
  exists (
    select 1 from core.mini_apps a
    where a.id = app_id
      and (
        a.owner_id = (select auth.uid())
        or core.is_mini_app_moderator(a.organization_id)
      )
  )
);

grant select on core.mini_app_moderation_log to authenticated;
grant all on core.mini_app_moderation_log to service_role;

-- Safety valve: a published app with 5+ open reports is auto-suspended and
-- lands in the moderation queue for review.
create or replace function core.mini_apps_auto_suspend()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_open integer;
begin
  select count(*) into v_open
  from core.mini_app_reports r
  where r.app_id = new.app_id and r.status = 'open';
  if v_open >= 5 then
    update core.mini_apps a
    set status = 'suspended',
        review_notes = 'Auto-suspended: ' || v_open || ' open reports'
    where a.id = new.app_id and a.status = 'published';
    if found then
      insert into core.mini_app_moderation_log (app_id, moderator_id, action, notes)
      values (new.app_id, null, 'auto_suspended', v_open || ' open reports');
    end if;
  end if;
  return new;
end;
$$;

create trigger auto_suspend_reported_mini_apps
after insert on core.mini_app_reports
for each row execute function core.mini_apps_auto_suspend();

-- ---------------------------------------------------------------------------
-- Proxy rate limiting (used by the miniapp-proxy edge function, service role)
-- ---------------------------------------------------------------------------

create unlogged table core.mini_app_proxy_hits (
  user_id uuid not null,
  bucket timestamptz not null,
  hits integer not null default 0,
  primary key (user_id, bucket)
);

grant all on core.mini_app_proxy_hits to service_role;

-- Returns false when the per-user requests-per-minute budget is exhausted.
create or replace function core.register_mini_app_proxy_hit(
  p_user_id uuid,
  p_limit integer default 180
)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_bucket timestamptz := date_trunc('minute', now());
  v_hits integer;
begin
  insert into core.mini_app_proxy_hits as h (user_id, bucket, hits)
  values (p_user_id, v_bucket, 1)
  on conflict (user_id, bucket) do update set hits = h.hits + 1
  returning hits into v_hits;
  return v_hits <= p_limit;
end;
$$;

revoke all on function core.register_mini_app_proxy_hit(uuid, integer)
  from public, anon, authenticated;
grant execute on function core.register_mini_app_proxy_hit(uuid, integer)
  to service_role;

-- Stale buckets are garbage; prune hourly when pg_cron is available.
do $$
begin
  perform cron.schedule(
    'prune-mini-app-proxy-hits',
    '17 * * * *',
    $cron$delete from core.mini_app_proxy_hits
      where bucket < now() - interval '1 hour'$cron$
  );
exception
  when others then
    raise notice 'pg_cron unavailable, skipping proxy hits prune job';
end;
$$;

-- ---------------------------------------------------------------------------
-- Icons bucket
-- ---------------------------------------------------------------------------

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'mini-app-icons', 'mini-app-icons', true, 2097152,
  array['image/png', 'image/jpeg', 'image/webp']
)
on conflict (id) do nothing;

-- Note: no SELECT policy on purpose — the bucket is public, objects are
-- served by URL; a broad SELECT policy would only enable bucket listing.

create policy "users upload icons into own folder"
on storage.objects for insert to authenticated
with check (
  bucket_id = 'mini-app-icons'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

create policy "users replace icons in own folder"
on storage.objects for update to authenticated
using (
  bucket_id = 'mini-app-icons'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

create policy "users delete icons in own folder"
on storage.objects for delete to authenticated
using (
  bucket_id = 'mini-app-icons'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

-- ---------------------------------------------------------------------------
-- RPC: shared row serializer
-- ---------------------------------------------------------------------------

create or replace function app_api_v1.mini_app_to_json(
  a core.mini_apps,
  p_viewer uuid
)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select jsonb_build_object(
    'id', a.id,
    'slug', a.slug,
    'name', a.name,
    'description', a.description,
    'iconEmoji', a.icon_emoji,
    'iconUrl', a.icon_url,
    'accentColor', a.accent_color,
    'category', a.category,
    'tags', to_jsonb(a.tags),
    'sourceKind', a.source_kind,
    'originUrl', case when a.owner_id = p_viewer then a.origin_url end,
    'entryPath', a.entry_path,
    'status', a.status,
    'reviewNotes',
      case
        when a.owner_id = p_viewer
          or core.is_mini_app_moderator(a.organization_id)
        then a.review_notes
      end,
    'version', a.version,
    'launchCount', a.launch_count,
    'ratingAvg', a.rating_avg,
    'ratingCount', a.rating_count,
    'ownerId', a.owner_id,
    'isOwner', a.owner_id = p_viewer,
    'myRating', (
      select r.rating from core.mini_app_ratings r
      where r.app_id = a.id and r.user_id = p_viewer
    ),
    'isHidden', exists (
      select 1 from core.mini_app_hidden h
      where h.app_id = a.id and h.user_id = p_viewer
    ),
    'hasMyOpenReport', exists (
      select 1 from core.mini_app_reports rp
      where rp.app_id = a.id
        and rp.reporter_id = p_viewer
        and rp.status = 'open'
    ),
    'openReportCount', (
      case
        when core.is_mini_app_moderator(a.organization_id) then (
          select count(*) from core.mini_app_reports rp
          where rp.app_id = a.id and rp.status = 'open'
        )
      end
    ),
    'createdAt', a.created_at,
    'updatedAt', a.updated_at,
    'publishedAt', a.published_at
  );
$$;

-- ---------------------------------------------------------------------------
-- RPC: catalog
-- ---------------------------------------------------------------------------

create or replace function app_api_v1.get_mini_apps(
  p_organization_id text,
  p_query text default null,
  p_category text default null,
  p_include_hidden boolean default false,
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
    jsonb_agg(app_api_v1.mini_app_to_json(a, (select auth.uid()))),
    '[]'::jsonb
  )
  from (
    select *
    from core.mini_apps ma
    where ma.organization_id = p_organization_id
      and ma.status = 'published'
      and (p_category is null or ma.category = p_category)
      and (
        p_query is null
        or trim(p_query) = ''
        or ma.search @@ websearch_to_tsquery('simple', p_query)
        or ma.name ilike '%' || p_query || '%'
      )
      and (
        p_include_hidden
        or not exists (
          select 1 from core.mini_app_hidden h
          where h.app_id = ma.id and h.user_id = (select auth.uid())
        )
      )
    order by ma.launch_count desc, ma.rating_avg desc, ma.created_at desc
    limit least(coalesce(nullif(p_limit, 0), 50), 100)
    offset greatest(coalesce(p_offset, 0), 0)
  ) a;
$$;

create or replace function app_api_v1.get_mini_app(
  p_organization_id text,
  p_slug text
)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select app_api_v1.mini_app_to_json(a, (select auth.uid()))
  from core.mini_apps a
  where a.organization_id = p_organization_id and a.slug = p_slug;
$$;

create or replace function app_api_v1.get_my_mini_apps(
  p_organization_id text
)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      app_api_v1.mini_app_to_json(a, (select auth.uid()))
      order by a.updated_at desc
    ),
    '[]'::jsonb
  )
  from core.mini_apps a
  where a.organization_id = p_organization_id
    and a.owner_id = (select auth.uid());
$$;

-- ---------------------------------------------------------------------------
-- RPC: authoring
-- ---------------------------------------------------------------------------

-- p_screens: [{"path": "/", "title": "Home", "json": {...}}, ...]
create or replace function app_api_v1.submit_mini_app(
  p_organization_id text,
  p_slug text,
  p_name text,
  p_description text default '',
  p_icon_emoji text default '🧩',
  p_accent_color text default '#7C5CFF',
  p_category text default 'other',
  p_tags text[] default '{}',
  p_source_kind text default 'hosted',
  p_origin_url text default null,
  p_entry_path text default '/',
  p_screens jsonb default '[]'::jsonb,
  p_as_draft boolean default false
)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_id uuid;
  v_screen jsonb;
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;
  if p_source_kind = 'hosted'
    and jsonb_array_length(coalesce(p_screens, '[]'::jsonb)) = 0
  then
    raise exception 'Hosted mini apps need at least one screen';
  end if;

  insert into core.mini_apps (
    organization_id, owner_id, slug, name, description, icon_emoji,
    accent_color, category, tags, source_kind, origin_url, entry_path, status
  )
  values (
    p_organization_id, v_user_id, lower(trim(p_slug)), trim(p_name),
    coalesce(p_description, ''), coalesce(p_icon_emoji, '🧩'),
    coalesce(p_accent_color, '#7C5CFF'), coalesce(p_category, 'other'),
    coalesce(p_tags, '{}'), coalesce(p_source_kind, 'hosted'),
    p_origin_url, coalesce(p_entry_path, '/'),
    case when p_as_draft then 'draft' else 'pending_review' end
  )
  returning id into v_id;

  for v_screen in
    select value from jsonb_array_elements(coalesce(p_screens, '[]'::jsonb))
  loop
    insert into core.mini_app_screens (app_id, path, title, json)
    values (
      v_id,
      coalesce(v_screen ->> 'path', '/'),
      v_screen ->> 'title',
      coalesce(v_screen -> 'json', '{}'::jsonb)
    );
  end loop;

  return jsonb_build_object('id', v_id);
end;
$$;

-- Updating a published app always sends it back to review: the catalog must
-- never serve unreviewed content.
create or replace function app_api_v1.update_mini_app(
  p_app_id uuid,
  p_name text default null,
  p_description text default null,
  p_icon_emoji text default null,
  p_accent_color text default null,
  p_category text default null,
  p_tags text[] default null,
  p_origin_url text default null,
  p_entry_path text default null,
  p_screens jsonb default null,
  p_submit boolean default true
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_app core.mini_apps;
  v_screen jsonb;
begin
  select * into v_app from core.mini_apps
  where id = p_app_id and owner_id = v_user_id
  for update;
  if not found then
    raise exception 'Mini app not found or not owned by you';
  end if;
  if v_app.status = 'suspended' then
    raise exception 'Suspended mini apps cannot be edited';
  end if;

  update core.mini_apps
  set name = coalesce(trim(p_name), name),
      description = coalesce(p_description, description),
      icon_emoji = coalesce(p_icon_emoji, icon_emoji),
      accent_color = coalesce(p_accent_color, accent_color),
      category = coalesce(p_category, category),
      tags = coalesce(p_tags, tags),
      origin_url = coalesce(p_origin_url, origin_url),
      entry_path = coalesce(p_entry_path, entry_path),
      version = version + 1,
      status = case when p_submit then 'pending_review' else 'draft' end
  where id = p_app_id;

  if p_screens is not null then
    delete from core.mini_app_screens where app_id = p_app_id;
    for v_screen in select value from jsonb_array_elements(p_screens)
    loop
      insert into core.mini_app_screens (app_id, path, title, json)
      values (
        p_app_id,
        coalesce(v_screen ->> 'path', '/'),
        v_screen ->> 'title',
        coalesce(v_screen -> 'json', '{}'::jsonb)
      );
    end loop;
  end if;
end;
$$;

create or replace function app_api_v1.delete_mini_app(p_app_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$
  delete from core.mini_apps
  where id = p_app_id and owner_id = (select auth.uid());
$$;

create or replace function app_api_v1.get_mini_app_screens(p_app_id uuid)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', s.id,
        'path', s.path,
        'title', s.title,
        'json', s.json,
        'updatedAt', s.updated_at
      )
      order by s.path
    ),
    '[]'::jsonb
  )
  from core.mini_app_screens s
  join core.mini_apps a on a.id = s.app_id
  where s.app_id = p_app_id
    and (
      a.owner_id = (select auth.uid())
      or core.is_mini_app_moderator(a.organization_id)
    );
$$;

-- ---------------------------------------------------------------------------
-- RPC: user feedback (report / hide / rate / launch)
-- ---------------------------------------------------------------------------

create or replace function app_api_v1.report_mini_app(
  p_app_id uuid,
  p_reason text,
  p_details text default ''
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
begin
  insert into core.mini_app_reports (app_id, reporter_id, reason, details)
  values (p_app_id, (select auth.uid()), p_reason, coalesce(p_details, ''))
  on conflict (app_id, reporter_id) where status = 'open'
  do update set reason = excluded.reason, details = excluded.details;
end;
$$;

create or replace function app_api_v1.set_mini_app_hidden(
  p_app_id uuid,
  p_hidden boolean
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if p_hidden then
    insert into core.mini_app_hidden (user_id, app_id)
    values ((select auth.uid()), p_app_id)
    on conflict do nothing;
  else
    delete from core.mini_app_hidden
    where user_id = (select auth.uid()) and app_id = p_app_id;
  end if;
end;
$$;

create or replace function app_api_v1.rate_mini_app(
  p_app_id uuid,
  p_rating integer
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
begin
  insert into core.mini_app_ratings (app_id, user_id, rating)
  values (p_app_id, (select auth.uid()), p_rating)
  on conflict (app_id, user_id) do update set rating = excluded.rating;
end;
$$;

-- Security definer: any user launches bump the counter, but the mini_apps
-- update policy only covers owners/moderators.
create or replace function app_api_v1.track_mini_app_launch(p_app_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if (select auth.uid()) is null then
    raise exception 'Unauthorized';
  end if;
  update core.mini_apps
  set launch_count = launch_count + 1
  where id = p_app_id and status = 'published';
end;
$$;

-- ---------------------------------------------------------------------------
-- RPC: moderation
-- ---------------------------------------------------------------------------

create or replace function app_api_v1.is_mini_app_moderator(
  p_organization_id text
)
returns boolean
language sql
stable
security invoker
set search_path = ''
as $$
  select core.is_mini_app_moderator(p_organization_id);
$$;

create or replace function app_api_v1.get_mini_apps_moderation_queue(
  p_organization_id text
)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select case
    when not core.is_mini_app_moderator(p_organization_id) then
      jsonb_build_object('pending', '[]'::jsonb, 'reported', '[]'::jsonb)
    else jsonb_build_object(
      'pending', coalesce(
        (
          select jsonb_agg(
            app_api_v1.mini_app_to_json(a, (select auth.uid()))
            order by a.updated_at
          )
          from core.mini_apps a
          where a.organization_id = p_organization_id
            and a.status = 'pending_review'
        ),
        '[]'::jsonb
      ),
      'reported', coalesce(
        (
          select jsonb_agg(reported order by reported -> 'reports' -> 0)
          from (
            select app_api_v1.mini_app_to_json(a, (select auth.uid()))
              || jsonb_build_object(
                'reports', (
                  select jsonb_agg(
                    jsonb_build_object(
                      'id', r.id,
                      'reason', r.reason,
                      'details', r.details,
                      'status', r.status,
                      'createdAt', r.created_at
                    )
                    order by r.created_at desc
                  )
                  from core.mini_app_reports r
                  where r.app_id = a.id and r.status = 'open'
                )
              ) as reported
            from core.mini_apps a
            where a.organization_id = p_organization_id
              and exists (
                select 1 from core.mini_app_reports r
                where r.app_id = a.id and r.status = 'open'
              )
          ) q
        ),
        '[]'::jsonb
      )
    )
  end;
$$;

-- Security definer: publishing flips status values owners are not allowed
-- to set themselves (the BEFORE trigger checks moderator membership, which
-- still resolves to the calling moderator via auth.uid()).
create or replace function app_api_v1.moderate_mini_app(
  p_app_id uuid,
  p_action text,
  p_notes text default ''
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_app core.mini_apps;
  v_status text;
  v_log_action text;
begin
  select * into v_app from core.mini_apps where id = p_app_id for update;
  if not found then
    raise exception 'Mini app not found';
  end if;
  if not core.is_mini_app_moderator(v_app.organization_id) then
    raise exception 'Moderator role required';
  end if;

  v_status := case p_action
    when 'approve' then 'published'
    when 'reject' then 'rejected'
    when 'suspend' then 'suspended'
    when 'restore' then 'published'
    else null
  end;
  if v_status is null then
    raise exception 'Unknown moderation action %', p_action;
  end if;
  v_log_action := case p_action
    when 'approve' then 'approved'
    when 'reject' then 'rejected'
    when 'suspend' then 'suspended'
    when 'restore' then 'restored'
  end;

  update core.mini_apps
  set status = v_status,
      review_notes = nullif(trim(coalesce(p_notes, '')), ''),
      published_at = case
        when v_status = 'published' then coalesce(published_at, now())
        else published_at
      end
  where id = p_app_id;

  insert into core.mini_app_moderation_log (app_id, moderator_id, action, notes)
  values (p_app_id, v_user_id, v_log_action, coalesce(p_notes, ''));
end;
$$;

create or replace function app_api_v1.resolve_mini_app_reports(
  p_app_id uuid,
  p_dismiss boolean default false,
  p_notes text default ''
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_org text;
begin
  select organization_id into v_org from core.mini_apps where id = p_app_id;
  if v_org is null then
    raise exception 'Mini app not found';
  end if;
  if not core.is_mini_app_moderator(v_org) then
    raise exception 'Moderator role required';
  end if;

  update core.mini_app_reports
  set status = case when p_dismiss then 'dismissed' else 'resolved' end,
      resolved_by = v_user_id,
      resolved_at = now()
  where app_id = p_app_id and status = 'open';

  insert into core.mini_app_moderation_log (app_id, moderator_id, action, notes)
  values (
    p_app_id, v_user_id,
    case when p_dismiss then 'reports_dismissed' else 'reports_resolved' end,
    coalesce(p_notes, '')
  );
end;
$$;

-- ---------------------------------------------------------------------------
-- public wrappers
-- ---------------------------------------------------------------------------

create or replace function public.get_mini_apps(
  p_organization_id text, p_query text default null,
  p_category text default null, p_include_hidden boolean default false,
  p_limit integer default 50, p_offset integer default 0
)
returns jsonb language sql stable security invoker set search_path = ''
as $$
  select app_api_v1.get_mini_apps(
    p_organization_id, p_query, p_category, p_include_hidden,
    p_limit, p_offset
  );
$$;

create or replace function public.get_mini_app(
  p_organization_id text, p_slug text
)
returns jsonb language sql stable security invoker set search_path = ''
as $$ select app_api_v1.get_mini_app(p_organization_id, p_slug); $$;

create or replace function public.get_my_mini_apps(p_organization_id text)
returns jsonb language sql stable security invoker set search_path = ''
as $$ select app_api_v1.get_my_mini_apps(p_organization_id); $$;

create or replace function public.submit_mini_app(
  p_organization_id text, p_slug text, p_name text,
  p_description text default '', p_icon_emoji text default '🧩',
  p_accent_color text default '#7C5CFF', p_category text default 'other',
  p_tags text[] default '{}', p_source_kind text default 'hosted',
  p_origin_url text default null, p_entry_path text default '/',
  p_screens jsonb default '[]'::jsonb, p_as_draft boolean default false
)
returns jsonb language sql security invoker set search_path = ''
as $$
  select app_api_v1.submit_mini_app(
    p_organization_id, p_slug, p_name, p_description, p_icon_emoji,
    p_accent_color, p_category, p_tags, p_source_kind, p_origin_url,
    p_entry_path, p_screens, p_as_draft
  );
$$;

create or replace function public.update_mini_app(
  p_app_id uuid, p_name text default null, p_description text default null,
  p_icon_emoji text default null, p_accent_color text default null,
  p_category text default null, p_tags text[] default null,
  p_origin_url text default null, p_entry_path text default null,
  p_screens jsonb default null, p_submit boolean default true
)
returns void language sql security invoker set search_path = ''
as $$
  select app_api_v1.update_mini_app(
    p_app_id, p_name, p_description, p_icon_emoji, p_accent_color,
    p_category, p_tags, p_origin_url, p_entry_path, p_screens, p_submit
  );
$$;

create or replace function public.delete_mini_app(p_app_id uuid)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.delete_mini_app(p_app_id); $$;

create or replace function public.get_mini_app_screens(p_app_id uuid)
returns jsonb language sql stable security invoker set search_path = ''
as $$ select app_api_v1.get_mini_app_screens(p_app_id); $$;

create or replace function public.report_mini_app(
  p_app_id uuid, p_reason text, p_details text default ''
)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.report_mini_app(p_app_id, p_reason, p_details); $$;

create or replace function public.set_mini_app_hidden(
  p_app_id uuid, p_hidden boolean
)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.set_mini_app_hidden(p_app_id, p_hidden); $$;

create or replace function public.rate_mini_app(
  p_app_id uuid, p_rating integer
)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.rate_mini_app(p_app_id, p_rating); $$;

create or replace function public.track_mini_app_launch(p_app_id uuid)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.track_mini_app_launch(p_app_id); $$;

create or replace function public.is_mini_app_moderator(
  p_organization_id text
)
returns boolean language sql stable security invoker set search_path = ''
as $$ select app_api_v1.is_mini_app_moderator(p_organization_id); $$;

create or replace function public.get_mini_apps_moderation_queue(
  p_organization_id text
)
returns jsonb language sql stable security invoker set search_path = ''
as $$
  select app_api_v1.get_mini_apps_moderation_queue(p_organization_id);
$$;

create or replace function public.moderate_mini_app(
  p_app_id uuid, p_action text, p_notes text default ''
)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.moderate_mini_app(p_app_id, p_action, p_notes); $$;

create or replace function public.resolve_mini_app_reports(
  p_app_id uuid, p_dismiss boolean default false, p_notes text default ''
)
returns void language sql security invoker set search_path = ''
as $$
  select app_api_v1.resolve_mini_app_reports(p_app_id, p_dismiss, p_notes);
$$;

-- Lock down the wrappers: authenticated users only.
revoke all on function public.get_mini_apps(text, text, text, boolean, integer, integer) from public, anon;
revoke all on function public.get_mini_app(text, text) from public, anon;
revoke all on function public.get_my_mini_apps(text) from public, anon;
revoke all on function public.submit_mini_app(text, text, text, text, text, text, text, text[], text, text, text, jsonb, boolean) from public, anon;
revoke all on function public.update_mini_app(uuid, text, text, text, text, text, text[], text, text, jsonb, boolean) from public, anon;
revoke all on function public.delete_mini_app(uuid) from public, anon;
revoke all on function public.get_mini_app_screens(uuid) from public, anon;
revoke all on function public.report_mini_app(uuid, text, text) from public, anon;
revoke all on function public.set_mini_app_hidden(uuid, boolean) from public, anon;
revoke all on function public.rate_mini_app(uuid, integer) from public, anon;
revoke all on function public.track_mini_app_launch(uuid) from public, anon;
revoke all on function public.is_mini_app_moderator(text) from public, anon;
revoke all on function public.get_mini_apps_moderation_queue(text) from public, anon;
revoke all on function public.moderate_mini_app(uuid, text, text) from public, anon;
revoke all on function public.resolve_mini_app_reports(uuid, boolean, text) from public, anon;

grant execute on function public.get_mini_apps(text, text, text, boolean, integer, integer) to authenticated;
grant execute on function public.get_mini_app(text, text) to authenticated;
grant execute on function public.get_my_mini_apps(text) to authenticated;
grant execute on function public.submit_mini_app(text, text, text, text, text, text, text, text[], text, text, text, jsonb, boolean) to authenticated;
grant execute on function public.update_mini_app(uuid, text, text, text, text, text, text[], text, text, jsonb, boolean) to authenticated;
grant execute on function public.delete_mini_app(uuid) to authenticated;
grant execute on function public.get_mini_app_screens(uuid) to authenticated;
grant execute on function public.report_mini_app(uuid, text, text) to authenticated;
grant execute on function public.set_mini_app_hidden(uuid, boolean) to authenticated;
grant execute on function public.rate_mini_app(uuid, integer) to authenticated;
grant execute on function public.track_mini_app_launch(uuid) to authenticated;
grant execute on function public.is_mini_app_moderator(text) to authenticated;
grant execute on function public.get_mini_apps_moderation_queue(text) to authenticated;
grant execute on function public.moderate_mini_app(uuid, text, text) to authenticated;
grant execute on function public.resolve_mini_app_reports(uuid, boolean, text) to authenticated;
