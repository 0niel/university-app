-- Mini apps platform, wave 3 (part A):
--  * per-user key-value storage for hosted apps (setStorage/getStorage);
--  * known widget/action registry + server-side screen validation;
--  * screen revisions (history, restore, moderation diff);
--  * daily launch stats (launches + unique users) for app owners;
--  * recently opened apps;
--  * featured apps (модераторские подборки) + catalog sorting.
-- Applied remotely as: add_mini_app_storage_stats_revisions.

-- ---------------------------------------------------------------------------
-- Per-user storage
-- ---------------------------------------------------------------------------

create table core.mini_app_user_storage (
  user_id uuid not null references auth.users(id) on delete cascade,
  app_id uuid not null references core.mini_apps(id) on delete cascade,
  key text not null,
  value jsonb not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint mini_app_storage_key_format check (key ~ '^[a-zA-Z0-9_.\-]{1,64}$'),
  constraint mini_app_storage_value_size check (pg_column_size(value) <= 8192),
  primary key (user_id, app_id, key)
);

create trigger set_mini_app_user_storage_updated_at
before update on core.mini_app_user_storage
for each row execute function core.set_updated_at();

alter table core.mini_app_user_storage enable row level security;

create policy "users manage own mini app storage"
on core.mini_app_user_storage for all to authenticated
using (user_id = (select auth.uid()))
with check (user_id = (select auth.uid()));

grant select, insert, update, delete on core.mini_app_user_storage
  to authenticated;
grant all on core.mini_app_user_storage to service_role;

create or replace function app_api_v1.get_mini_app_storage(p_app_id uuid)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select coalesce(jsonb_object_agg(s.key, s.value), '{}'::jsonb)
  from core.mini_app_user_storage s
  where s.app_id = p_app_id and s.user_id = (select auth.uid());
$$;

-- p_value = null deletes the key. Hard cap of 50 keys per user per app.
create or replace function app_api_v1.set_mini_app_storage(
  p_app_id uuid,
  p_key text,
  p_value jsonb default null
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_count integer;
begin
  if p_value is null then
    delete from core.mini_app_user_storage
    where user_id = v_user_id and app_id = p_app_id and key = p_key;
    return;
  end if;
  select count(*) into v_count from core.mini_app_user_storage
  where user_id = v_user_id and app_id = p_app_id;
  if v_count >= 50 and not exists (
    select 1 from core.mini_app_user_storage
    where user_id = v_user_id and app_id = p_app_id and key = p_key
  ) then
    raise exception 'Storage quota exceeded (50 keys per app)';
  end if;
  insert into core.mini_app_user_storage (user_id, app_id, key, value)
  values (v_user_id, p_app_id, p_key, p_value)
  on conflict (user_id, app_id, key) do update set value = excluded.value;
end;
$$;

create or replace function public.get_mini_app_storage(p_app_id uuid)
returns jsonb language sql stable security invoker set search_path = ''
as $$ select app_api_v1.get_mini_app_storage(p_app_id); $$;

create or replace function public.set_mini_app_storage(
  p_app_id uuid, p_key text, p_value jsonb default null
)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.set_mini_app_storage(p_app_id, p_key, p_value); $$;

revoke all on function public.get_mini_app_storage(uuid) from public, anon;
revoke all on function public.set_mini_app_storage(uuid, text, jsonb)
  from public, anon;
grant execute on function public.get_mini_app_storage(uuid) to authenticated;
grant execute on function public.set_mini_app_storage(uuid, text, jsonb)
  to authenticated;

-- ---------------------------------------------------------------------------
-- Known type registry + validation
-- ---------------------------------------------------------------------------

create table core.mini_app_known_types (
  kind text not null,
  name text not null,
  constraint mini_app_known_types_kind check (kind in ('widget', 'action')),
  primary key (kind, name)
);

alter table core.mini_app_known_types enable row level security;

create policy "known types readable"
on core.mini_app_known_types for select to authenticated using (true);

grant select on core.mini_app_known_types to authenticated;
grant all on core.mini_app_known_types to service_role;

insert into core.mini_app_known_types (kind, name) values
  -- Stac built-in widgets
  ('widget','alertDialog'),('widget','align'),('widget','appBar'),
  ('widget','aspectRatio'),('widget','autocomplete'),('widget','backdropFilter'),
  ('widget','badge'),('widget','bottomNavigationBar'),('widget','bottomNavigationView'),
  ('widget','card'),('widget','carouselView'),('widget','center'),
  ('widget','checkBox'),('widget','chip'),('widget','clipOval'),
  ('widget','clipRRect'),('widget','circleAvatar'),('widget','circularProgressIndicator'),
  ('widget','coloredBox'),('widget','column'),('widget','conditional'),
  ('widget','container'),('widget','drawer'),('widget','dropdownMenu'),
  ('widget','customScrollView'),('widget','defaultBottomNavigationController'),
  ('widget','defaultNavigationController'),('widget','defaultTabController'),
  ('widget','divider'),('widget','dynamicView'),('widget','elevatedButton'),
  ('widget','expanded'),('widget','filledButton'),('widget','fittedBox'),
  ('widget','flexible'),('widget','floatingActionButton'),('widget','form'),
  ('widget','fractionallySizedBox'),('widget','gestureDetector'),('widget','gridView'),
  ('widget','hero'),('widget','icon'),('widget','iconButton'),('widget','image'),
  ('widget','inkWell'),('widget','limitedBox'),('widget','linearProgressIndicator'),
  ('widget','listTile'),('widget','listView'),('widget','navigationBar'),
  ('widget','navigationView'),('widget','networkWidget'),('widget','opacity'),
  ('widget','outlinedButton'),('widget','padding'),('widget','pageView'),
  ('widget','placeholder'),('widget','positioned'),('widget','radio'),
  ('widget','radioGroup'),('widget','refreshIndicator'),('widget','row'),
  ('widget','safeArea'),('widget','scaffold'),('widget','selectableText'),
  ('widget','setValue'),('widget','singleChildScrollView'),('widget','sizedBox'),
  ('widget','slider'),('widget','sliverAppBar'),('widget','sliverGrid'),
  ('widget','sliverFillRemaining'),('widget','sliverList'),('widget','sliverVisibility'),
  ('widget','sliverOpacity'),('widget','sliverSafeArea'),('widget','sliverPadding'),
  ('widget','sliverToBoxAdapter'),('widget','spacer'),('widget','stack'),
  ('widget','tab'),('widget','tabBar'),('widget','tabBarView'),('widget','table'),
  ('widget','tableCell'),('widget','text'),('widget','textButton'),
  ('widget','textField'),('widget','textFormField'),('widget','tooltip'),
  ('widget','wrap'),('widget','visibility'),('widget','verticalDivider'),
  -- Mirea Ninja design-system widgets
  ('widget','appAvatar'),('widget','appAvatarStack'),('widget','appButton'),
  ('widget','appCard'),('widget','appChip'),('widget','appEmptyState'),
  ('widget','appErrorState'),('widget','appIconButton'),('widget','appLineIcon'),
  ('widget','appListRow'),('widget','appLiveBadge'),('widget','appMetaPill'),
  ('widget','appProgressRing'),('widget','appSectionTitle'),
  ('widget','appSegmentedControl'),('widget','appTag'),
  -- Stac built-in actions
  ('action','navigate'),('action','none'),('action','networkRequest'),
  ('action','showModalBottomSheet'),('action','showDialog'),
  ('action','getFormValue'),('action','validateForm'),('action','showSnackBar'),
  ('action','setValue'),('action','multiAction'),('action','delay'),
  -- Platform actions
  ('action','closeMiniApp'),('action','confirm'),('action','copyToClipboard'),
  ('action','hapticFeedback'),('action','openDeepLink'),('action','openMiniApp'),
  ('action','openPage'),('action','openSheet'),('action','openUrl'),
  ('action','pop'),('action','reload'),('action','share'),('action','showToast'),
  ('action','setStorage')
on conflict do nothing;

-- Walks the screen JSON and reports unknown widget `type` and `actionType`
-- discriminators. Warnings only: unknown values render as empty widgets.
create or replace function app_api_v1.validate_mini_app_screens(
  p_screens jsonb
)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select jsonb_build_object(
    'unknownWidgets', coalesce(
      (
        select jsonb_agg(distinct v)
        from (
          select jsonb_path_query(p_screens, '$.**.type') #>> '{}' as v
        ) q
        where q.v is not null
          and not exists (
            select 1 from core.mini_app_known_types k
            where k.kind = 'widget' and k.name = q.v
          )
      ),
      '[]'::jsonb
    ),
    'unknownActions', coalesce(
      (
        select jsonb_agg(distinct v)
        from (
          select
            jsonb_path_query(p_screens, '$.**.actionType') #>> '{}' as v
        ) q
        where q.v is not null
          and not exists (
            select 1 from core.mini_app_known_types k
            where k.kind = 'action' and k.name = q.v
          )
      ),
      '[]'::jsonb
    )
  );
$$;

create or replace function public.validate_mini_app_screens(p_screens jsonb)
returns jsonb language sql stable security invoker set search_path = ''
as $$ select app_api_v1.validate_mini_app_screens(p_screens); $$;

revoke all on function public.validate_mini_app_screens(jsonb)
  from public, anon;
grant execute on function public.validate_mini_app_screens(jsonb)
  to authenticated;

-- ---------------------------------------------------------------------------
-- Screen revisions
-- ---------------------------------------------------------------------------

create table core.mini_app_screen_revisions (
  id uuid primary key default extensions.gen_random_uuid(),
  app_id uuid not null references core.mini_apps(id) on delete cascade,
  version integer not null,
  screens jsonb not null,
  created_at timestamptz not null default now(),
  unique (app_id, version)
);

create index mini_app_screen_revisions_app_idx
on core.mini_app_screen_revisions (app_id, version desc);

alter table core.mini_app_screen_revisions enable row level security;

create policy "owners and moderators read revisions"
on core.mini_app_screen_revisions for select to authenticated
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

grant select on core.mini_app_screen_revisions to authenticated;
grant all on core.mini_app_screen_revisions to service_role;

-- Snapshots the current screens of an app as the given version; keeps the
-- last 20 revisions. Called from the authoring/deploy RPCs (definer).
create or replace function core.snapshot_mini_app_screens(
  p_app_id uuid,
  p_version integer
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  -- Callable by authenticated users from the authoring RPC chain: restrict
  -- to apps they own (service role passes with auth.uid() = null).
  if (select auth.uid()) is not null and not exists (
    select 1 from core.mini_apps a
    where a.id = p_app_id and a.owner_id = (select auth.uid())
  ) then
    raise exception 'Not the app owner';
  end if;

  insert into core.mini_app_screen_revisions (app_id, version, screens)
  select p_app_id, p_version, coalesce(
    jsonb_agg(
      jsonb_build_object('path', s.path, 'title', s.title, 'json', s.json)
      order by s.path
    ),
    '[]'::jsonb
  )
  from core.mini_app_screens s
  where s.app_id = p_app_id
  on conflict (app_id, version) do update set screens = excluded.screens;

  delete from core.mini_app_screen_revisions r
  where r.app_id = p_app_id
    and r.version < p_version - 19;
end;
$$;

revoke all on function core.snapshot_mini_app_screens(uuid, integer)
  from public, anon;
grant execute on function core.snapshot_mini_app_screens(uuid, integer)
  to authenticated;
grant execute on function core.snapshot_mini_app_screens(uuid, integer)
  to service_role;

create or replace function app_api_v1.get_mini_app_revisions(p_app_id uuid)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'version', r.version,
        'createdAt', r.created_at,
        'screens', r.screens
      )
      order by r.version desc
    ),
    '[]'::jsonb
  )
  from core.mini_app_screen_revisions r
  where r.app_id = p_app_id;
$$;

-- Restores a snapshot as the new current screens. Content change → back to
-- moderation, exactly like a manual edit.
create or replace function app_api_v1.restore_mini_app_revision(
  p_app_id uuid,
  p_version integer
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_app core.mini_apps;
  v_screens jsonb;
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

  select screens into v_screens from core.mini_app_screen_revisions
  where app_id = p_app_id and version = p_version;
  if v_screens is null then
    raise exception 'Revision not found';
  end if;

  delete from core.mini_app_screens where app_id = p_app_id;
  for v_screen in select value from jsonb_array_elements(v_screens)
  loop
    insert into core.mini_app_screens (app_id, path, title, json)
    values (
      p_app_id,
      coalesce(v_screen ->> 'path', '/'),
      v_screen ->> 'title',
      coalesce(v_screen -> 'json', '{}'::jsonb)
    );
  end loop;

  update core.mini_apps
  set version = version + 1, status = 'pending_review'
  where id = p_app_id;

  perform core.snapshot_mini_app_screens(p_app_id, v_app.version + 1);
end;
$$;

create or replace function public.get_mini_app_revisions(p_app_id uuid)
returns jsonb language sql stable security invoker set search_path = ''
as $$ select app_api_v1.get_mini_app_revisions(p_app_id); $$;

create or replace function public.restore_mini_app_revision(
  p_app_id uuid, p_version integer
)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.restore_mini_app_revision(p_app_id, p_version); $$;

revoke all on function public.get_mini_app_revisions(uuid) from public, anon;
revoke all on function public.restore_mini_app_revision(uuid, integer)
  from public, anon;
grant execute on function public.get_mini_app_revisions(uuid)
  to authenticated;
grant execute on function public.restore_mini_app_revision(uuid, integer)
  to authenticated;

-- ---------------------------------------------------------------------------
-- Daily stats + recents (both fed by track_mini_app_launch)
-- ---------------------------------------------------------------------------

create table core.mini_app_stats_daily (
  app_id uuid not null references core.mini_apps(id) on delete cascade,
  day date not null,
  launches integer not null default 0,
  unique_users integer not null default 0,
  primary key (app_id, day)
);

create table core.mini_app_daily_users (
  app_id uuid not null references core.mini_apps(id) on delete cascade,
  day date not null,
  user_id uuid not null,
  primary key (app_id, day, user_id)
);

create table core.mini_app_recents (
  user_id uuid not null references auth.users(id) on delete cascade,
  app_id uuid not null references core.mini_apps(id) on delete cascade,
  last_opened_at timestamptz not null default now(),
  primary key (user_id, app_id)
);

alter table core.mini_app_stats_daily enable row level security;
alter table core.mini_app_daily_users enable row level security;
alter table core.mini_app_recents enable row level security;

create policy "owners and moderators read stats"
on core.mini_app_stats_daily for select to authenticated
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

create policy "users read own recents"
on core.mini_app_recents for select to authenticated
using (user_id = (select auth.uid()));

grant select on core.mini_app_stats_daily to authenticated;
grant select on core.mini_app_recents to authenticated;
grant all on core.mini_app_stats_daily to service_role;
grant all on core.mini_app_daily_users to service_role;
grant all on core.mini_app_recents to service_role;

-- track_mini_app_launch now also feeds the daily rollup and recents.
create or replace function app_api_v1.track_mini_app_launch(p_app_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_new_user boolean := false;
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;

  update core.mini_apps
  set launch_count = launch_count + 1
  where id = p_app_id and status = 'published';
  if not found then
    return;
  end if;

  insert into core.mini_app_daily_users (app_id, day, user_id)
  values (p_app_id, current_date, v_user_id)
  on conflict do nothing;
  v_new_user := found;

  insert into core.mini_app_stats_daily as s (app_id, day, launches, unique_users)
  values (p_app_id, current_date, 1, case when v_new_user then 1 else 0 end)
  on conflict (app_id, day) do update
  set launches = s.launches + 1,
      unique_users = s.unique_users + (case when v_new_user then 1 else 0 end);

  insert into core.mini_app_recents (user_id, app_id, last_opened_at)
  values (v_user_id, p_app_id, now())
  on conflict (user_id, app_id) do update set last_opened_at = now();
end;
$$;

create or replace function app_api_v1.get_mini_app_stats(
  p_app_id uuid,
  p_days integer default 30
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
        'day', s.day,
        'launches', s.launches,
        'uniqueUsers', s.unique_users
      )
      order by s.day
    ),
    '[]'::jsonb
  )
  from core.mini_app_stats_daily s
  where s.app_id = p_app_id
    and s.day > current_date - least(greatest(p_days, 1), 90);
$$;

create or replace function app_api_v1.get_recent_mini_apps(
  p_organization_id text,
  p_limit integer default 10
)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select coalesce(jsonb_agg(app order by opened desc), '[]'::jsonb)
  from (
    select app_api_v1.mini_app_to_json(a, (select auth.uid())) as app,
           r.last_opened_at as opened
    from core.mini_app_recents r
    join core.mini_apps a on a.id = r.app_id
    where r.user_id = (select auth.uid())
      and a.organization_id = p_organization_id
      and a.status = 'published'
    order by r.last_opened_at desc
    limit least(greatest(coalesce(p_limit, 10), 1), 20)
  ) q;
$$;

create or replace function public.get_mini_app_stats(
  p_app_id uuid, p_days integer default 30
)
returns jsonb language sql stable security invoker set search_path = ''
as $$ select app_api_v1.get_mini_app_stats(p_app_id, p_days); $$;

create or replace function public.get_recent_mini_apps(
  p_organization_id text, p_limit integer default 10
)
returns jsonb language sql stable security invoker set search_path = ''
as $$
  select app_api_v1.get_recent_mini_apps(p_organization_id, p_limit);
$$;

revoke all on function public.get_mini_app_stats(uuid, integer)
  from public, anon;
revoke all on function public.get_recent_mini_apps(text, integer)
  from public, anon;
grant execute on function public.get_mini_app_stats(uuid, integer)
  to authenticated;
grant execute on function public.get_recent_mini_apps(text, integer)
  to authenticated;

do $$
begin
  perform cron.schedule(
    'prune-mini-app-daily-users',
    '23 3 * * *',
    $cron$delete from core.mini_app_daily_users
      where day < current_date - 60$cron$
  );
exception
  when others then
    raise notice 'pg_cron unavailable, skipping daily users prune job';
end;
$$;

-- ---------------------------------------------------------------------------
-- Featured + catalog sorting
-- ---------------------------------------------------------------------------

alter table core.mini_apps add column featured_at timestamptz;

-- moderation log actions for feature/unfeature
alter table core.mini_app_moderation_log
  drop constraint mini_app_moderation_action_valid;
alter table core.mini_app_moderation_log
  add constraint mini_app_moderation_action_valid check (
    action in (
      'approved', 'rejected', 'suspended', 'restored', 'auto_suspended',
      'reports_resolved', 'reports_dismissed', 'featured', 'unfeatured'
    )
  );

create or replace function app_api_v1.set_mini_app_featured(
  p_app_id uuid,
  p_featured boolean
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

  update core.mini_apps
  set featured_at = case when p_featured then now() end
  where id = p_app_id;

  insert into core.mini_app_moderation_log (app_id, moderator_id, action)
  values (
    p_app_id, v_user_id,
    case when p_featured then 'featured' else 'unfeatured' end
  );
end;
$$;

create or replace function public.set_mini_app_featured(
  p_app_id uuid, p_featured boolean
)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.set_mini_app_featured(p_app_id, p_featured); $$;

revoke all on function public.set_mini_app_featured(uuid, boolean)
  from public, anon;
grant execute on function public.set_mini_app_featured(uuid, boolean)
  to authenticated;

-- Serializer gains isFeatured.
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
    'isFeatured', a.featured_at is not null,
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
    'requestedPermissions', to_jsonb(a.requested_permissions),
    'grantedPermissions', (
      select to_jsonb(c.scopes) from core.mini_app_consents c
      where c.app_id = a.id and c.user_id = p_viewer
    ),
    'createdAt', a.created_at,
    'updatedAt', a.updated_at,
    'publishedAt', a.published_at
  );
$$;

-- Catalog gains p_sort: popular | new | top. Featured apps float first.
create or replace function app_api_v1.get_mini_apps(
  p_organization_id text,
  p_query text default null,
  p_category text default null,
  p_include_hidden boolean default false,
  p_limit integer default 50,
  p_offset integer default 0,
  p_sort text default 'popular'
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
    order by
      ma.featured_at desc nulls last,
      case when p_sort = 'new' then ma.published_at end desc nulls last,
      case when p_sort = 'top' then ma.rating_avg end desc nulls last,
      case when p_sort = 'top' then ma.rating_count end desc nulls last,
      ma.launch_count desc,
      ma.created_at desc
    limit least(coalesce(nullif(p_limit, 0), 50), 100)
    offset greatest(coalesce(p_offset, 0), 0)
  ) a;
$$;

drop function public.get_mini_apps(text, text, text, boolean, integer, integer);

create or replace function public.get_mini_apps(
  p_organization_id text, p_query text default null,
  p_category text default null, p_include_hidden boolean default false,
  p_limit integer default 50, p_offset integer default 0,
  p_sort text default 'popular'
)
returns jsonb language sql stable security invoker set search_path = ''
as $$
  select app_api_v1.get_mini_apps(
    p_organization_id, p_query, p_category, p_include_hidden,
    p_limit, p_offset, p_sort
  );
$$;

revoke all on function public.get_mini_apps(text, text, text, boolean, integer, integer, text) from public, anon;
grant execute on function public.get_mini_apps(text, text, text, boolean, integer, integer, text) to authenticated;

-- ---------------------------------------------------------------------------
-- Authoring RPCs snapshot revisions on every content write.
-- ---------------------------------------------------------------------------

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
  p_permissions text[] default '{}',
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
    accent_color, category, tags, source_kind, origin_url, entry_path,
    requested_permissions, status
  )
  values (
    p_organization_id, v_user_id, lower(trim(p_slug)), trim(p_name),
    coalesce(p_description, ''), coalesce(p_icon_emoji, '🧩'),
    coalesce(p_accent_color, '#7C5CFF'), coalesce(p_category, 'other'),
    coalesce(p_tags, '{}'), coalesce(p_source_kind, 'hosted'),
    p_origin_url, coalesce(p_entry_path, '/'),
    coalesce(p_permissions, '{}'),
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

  perform core.snapshot_mini_app_screens(v_id, 1);

  return jsonb_build_object('id', v_id);
end;
$$;

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
  p_permissions text[] default null,
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
      requested_permissions =
        coalesce(p_permissions, requested_permissions),
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
    perform core.snapshot_mini_app_screens(p_app_id, v_app.version + 1);
  end if;
end;
$$;
