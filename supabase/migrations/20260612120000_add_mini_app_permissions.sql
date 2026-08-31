-- Mini app permissions (consent system).
--
-- Apps declare the data scopes they want (requested_permissions); users
-- explicitly grant a subset before the first launch (mini_app_consents).
-- The proxy forwards ONLY granted data to remote origins; without grants a
-- developer only ever sees a pseudonymous per-app user id. The Supabase
-- session/JWT is never forwarded under any scope.
--
-- Scopes:
--   identity — real user UUID
--   email    — university email
--   profile  — full name + course
--   group    — academic group code
-- Applied remotely as: add_mini_app_permissions.

alter table core.mini_apps
  add column requested_permissions text[] not null default '{}';

alter table core.mini_apps
  add constraint mini_apps_permissions_valid check (
    requested_permissions
      <@ array['identity', 'email', 'profile', 'group']::text[]
  );

create table core.mini_app_consents (
  user_id uuid not null references auth.users(id) on delete cascade,
  app_id uuid not null references core.mini_apps(id) on delete cascade,
  scopes text[] not null default '{}',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint mini_app_consents_scopes_valid check (
    scopes <@ array['identity', 'email', 'profile', 'group']::text[]
  ),
  primary key (user_id, app_id)
);

create trigger set_mini_app_consents_updated_at
before update on core.mini_app_consents
for each row execute function core.set_updated_at();

alter table core.mini_app_consents enable row level security;

create policy "users manage own consents"
on core.mini_app_consents for all to authenticated
using (user_id = (select auth.uid()))
with check (user_id = (select auth.uid()));

grant select, insert, update, delete on core.mini_app_consents
  to authenticated;
grant all on core.mini_app_consents to service_role;

-- ---------------------------------------------------------------------------
-- Serializer: expose requested + granted scopes to the viewer.
-- grantedPermissions is null when the user has not decided yet — the client
-- uses that to show the consent sheet before the first launch.
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

-- ---------------------------------------------------------------------------
-- Consent RPC: stores the user's decision. Scopes are clamped to what the
-- app actually requested, so a malicious client cannot self-grant extras.
-- ---------------------------------------------------------------------------

create or replace function app_api_v1.set_mini_app_consents(
  p_app_id uuid,
  p_scopes text[]
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_requested text[];
  v_clamped text[];
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;
  select requested_permissions into v_requested
  from core.mini_apps where id = p_app_id;
  if v_requested is null then
    raise exception 'Mini app not found';
  end if;

  select coalesce(array_agg(s), '{}') into v_clamped
  from unnest(coalesce(p_scopes, '{}')) s
  where s = any (v_requested);

  insert into core.mini_app_consents (user_id, app_id, scopes)
  values (v_user_id, p_app_id, v_clamped)
  on conflict (user_id, app_id) do update set scopes = excluded.scopes;
end;
$$;

create or replace function public.set_mini_app_consents(
  p_app_id uuid, p_scopes text[]
)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.set_mini_app_consents(p_app_id, p_scopes); $$;

revoke all on function public.set_mini_app_consents(uuid, text[])
  from public, anon;
grant execute on function public.set_mini_app_consents(uuid, text[])
  to authenticated;

-- ---------------------------------------------------------------------------
-- Authoring RPCs get a p_permissions parameter (new signatures, the old
-- ones are dropped so PostgREST overload resolution stays unambiguous).
-- ---------------------------------------------------------------------------

drop function public.submit_mini_app(text, text, text, text, text, text, text, text[], text, text, text, jsonb, boolean);
drop function app_api_v1.submit_mini_app(text, text, text, text, text, text, text, text[], text, text, text, jsonb, boolean);
drop function public.update_mini_app(uuid, text, text, text, text, text, text[], text, text, jsonb, boolean);
drop function app_api_v1.update_mini_app(uuid, text, text, text, text, text, text[], text, text, jsonb, boolean);

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
  end if;
end;
$$;

create or replace function public.submit_mini_app(
  p_organization_id text, p_slug text, p_name text,
  p_description text default '', p_icon_emoji text default '🧩',
  p_accent_color text default '#7C5CFF', p_category text default 'other',
  p_tags text[] default '{}', p_source_kind text default 'hosted',
  p_origin_url text default null, p_entry_path text default '/',
  p_screens jsonb default '[]'::jsonb, p_permissions text[] default '{}',
  p_as_draft boolean default false
)
returns jsonb language sql security invoker set search_path = ''
as $$
  select app_api_v1.submit_mini_app(
    p_organization_id, p_slug, p_name, p_description, p_icon_emoji,
    p_accent_color, p_category, p_tags, p_source_kind, p_origin_url,
    p_entry_path, p_screens, p_permissions, p_as_draft
  );
$$;

create or replace function public.update_mini_app(
  p_app_id uuid, p_name text default null, p_description text default null,
  p_icon_emoji text default null, p_accent_color text default null,
  p_category text default null, p_tags text[] default null,
  p_origin_url text default null, p_entry_path text default null,
  p_screens jsonb default null, p_permissions text[] default null,
  p_submit boolean default true
)
returns void language sql security invoker set search_path = ''
as $$
  select app_api_v1.update_mini_app(
    p_app_id, p_name, p_description, p_icon_emoji, p_accent_color,
    p_category, p_tags, p_origin_url, p_entry_path, p_screens,
    p_permissions, p_submit
  );
$$;

revoke all on function public.submit_mini_app(text, text, text, text, text, text, text, text[], text, text, text, jsonb, text[], boolean) from public, anon;
revoke all on function public.update_mini_app(uuid, text, text, text, text, text, text[], text, text, jsonb, text[], boolean) from public, anon;
grant execute on function public.submit_mini_app(text, text, text, text, text, text, text, text[], text, text, text, jsonb, text[], boolean) to authenticated;
grant execute on function public.update_mini_app(uuid, text, text, text, text, text, text[], text, text, jsonb, text[], boolean) to authenticated;

-- ---------------------------------------------------------------------------
-- Proxy context: returns the granted scopes plus ONLY the granted identity
-- fields, so the edge function never even reads undisclosed data.
-- ---------------------------------------------------------------------------

create or replace function public.mini_app_proxy_context(
  p_user_id uuid,
  p_organization_id text,
  p_slug text,
  p_path text default null,
  p_rate_limit integer default 180
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_app core.mini_apps;
  v_screen jsonb;
  v_is_moderator boolean;
  v_scopes text[];
  v_identity jsonb := '{}'::jsonb;
begin
  if not core.register_mini_app_proxy_hit(p_user_id, p_rate_limit) then
    return jsonb_build_object('allowed', false, 'reason', 'rate_limited');
  end if;

  select * into v_app
  from core.mini_apps a
  where a.organization_id = p_organization_id and a.slug = p_slug;
  if not found then
    return jsonb_build_object('allowed', false, 'reason', 'not_found');
  end if;

  select exists (
    select 1 from core.mini_app_moderators m
    where m.organization_id = p_organization_id and m.user_id = p_user_id
  ) into v_is_moderator;

  if v_app.status <> 'published'
    and v_app.owner_id <> p_user_id
    and not v_is_moderator
  then
    return jsonb_build_object('allowed', false, 'reason', 'not_published');
  end if;

  if v_app.source_kind = 'hosted' then
    select s.json into v_screen
    from core.mini_app_screens s
    where s.app_id = v_app.id
      and s.path = coalesce(p_path, v_app.entry_path);
  else
    -- Granted scopes, clamped to what the app currently requests.
    select coalesce(array_agg(s), '{}') into v_scopes
    from core.mini_app_consents c, unnest(c.scopes) s
    where c.app_id = v_app.id
      and c.user_id = p_user_id
      and s = any (v_app.requested_permissions);

    if 'email' = any (v_scopes) then
      v_identity := v_identity || jsonb_build_object(
        'email', (select u.email from auth.users u where u.id = p_user_id)
      );
    end if;
    if 'profile' = any (v_scopes) then
      v_identity := v_identity || coalesce(
        (
          select jsonb_build_object('name', ap.full_name, 'course', ap.course)
          from core.user_academic_profiles ap
          where ap.user_id = p_user_id
            and ap.organization_id = p_organization_id
        ),
        '{}'::jsonb
      );
    end if;
    if 'group' = any (v_scopes) then
      v_identity := v_identity || coalesce(
        (
          select jsonb_build_object('group', ap.academic_group)
          from core.user_academic_profiles ap
          where ap.user_id = p_user_id
            and ap.organization_id = p_organization_id
        ),
        '{}'::jsonb
      );
    end if;
  end if;

  return jsonb_build_object(
    'allowed', true,
    'app', jsonb_build_object(
      'id', v_app.id,
      'slug', v_app.slug,
      'name', v_app.name,
      'sourceKind', v_app.source_kind,
      'originUrl', v_app.origin_url,
      'entryPath', v_app.entry_path,
      'status', v_app.status
    ),
    'screen', v_screen,
    'permissions', to_jsonb(coalesce(v_scopes, '{}')),
    'identity', v_identity
  );
end;
$$;
