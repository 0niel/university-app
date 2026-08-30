-- Mini apps platform, wave 3 (part B):
--  * personal deploy tokens (CI-деплой hosted-экранов через miniapp-deploy);
--  * notifications consent scope + push delivery log (miniapp-notify).
-- Applied remotely as: add_mini_app_tokens_and_push.

-- ---------------------------------------------------------------------------
-- notifications scope
-- ---------------------------------------------------------------------------

alter table core.mini_apps drop constraint mini_apps_permissions_valid;
alter table core.mini_apps add constraint mini_apps_permissions_valid check (
  requested_permissions
    <@ array['identity', 'email', 'profile', 'group', 'notifications']::text[]
);

alter table core.mini_app_consents
  drop constraint mini_app_consents_scopes_valid;
alter table core.mini_app_consents
  add constraint mini_app_consents_scopes_valid check (
    scopes
      <@ array['identity', 'email', 'profile', 'group', 'notifications']::text[]
  );

-- ---------------------------------------------------------------------------
-- Deploy tokens
-- ---------------------------------------------------------------------------

create table core.mini_app_deploy_tokens (
  id uuid primary key default extensions.gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null default '',
  token_hash text not null unique,
  created_at timestamptz not null default now(),
  last_used_at timestamptz
);

alter table core.mini_app_deploy_tokens enable row level security;

create policy "users see own deploy tokens"
on core.mini_app_deploy_tokens for select to authenticated
using (user_id = (select auth.uid()));

grant select on core.mini_app_deploy_tokens to authenticated;
grant all on core.mini_app_deploy_tokens to service_role;

-- Returns the plaintext token exactly once; only the sha256 hash is stored.
create or replace function app_api_v1.create_mini_app_deploy_token(
  p_name text default ''
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_token text;
  v_id uuid;
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;
  if (
    select count(*) from core.mini_app_deploy_tokens
    where user_id = v_user_id
  ) >= 5 then
    raise exception 'Token limit reached (5)';
  end if;
  v_token := 'man_' || encode(extensions.gen_random_bytes(24), 'hex');
  insert into core.mini_app_deploy_tokens (user_id, name, token_hash)
  values (
    v_user_id,
    coalesce(p_name, ''),
    encode(extensions.digest(v_token, 'sha256'), 'hex')
  )
  returning id into v_id;
  return jsonb_build_object('id', v_id, 'token', v_token);
end;
$$;

create or replace function app_api_v1.list_mini_app_deploy_tokens()
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', t.id,
        'name', t.name,
        'createdAt', t.created_at,
        'lastUsedAt', t.last_used_at
      )
      order by t.created_at desc
    ),
    '[]'::jsonb
  )
  from core.mini_app_deploy_tokens t
  where t.user_id = (select auth.uid());
$$;

create or replace function app_api_v1.revoke_mini_app_deploy_token(p_id uuid)
returns void
language sql
security definer
set search_path = ''
as $$
  delete from core.mini_app_deploy_tokens
  where id = p_id and user_id = (select auth.uid());
$$;

create or replace function public.create_mini_app_deploy_token(
  p_name text default ''
)
returns jsonb language sql security invoker set search_path = ''
as $$ select app_api_v1.create_mini_app_deploy_token(p_name); $$;

create or replace function public.list_mini_app_deploy_tokens()
returns jsonb language sql stable security invoker set search_path = ''
as $$ select app_api_v1.list_mini_app_deploy_tokens(); $$;

create or replace function public.revoke_mini_app_deploy_token(p_id uuid)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.revoke_mini_app_deploy_token(p_id); $$;

revoke all on function public.create_mini_app_deploy_token(text)
  from public, anon;
revoke all on function public.list_mini_app_deploy_tokens()
  from public, anon;
revoke all on function public.revoke_mini_app_deploy_token(uuid)
  from public, anon;
grant execute on function public.create_mini_app_deploy_token(text)
  to authenticated;
grant execute on function public.list_mini_app_deploy_tokens()
  to authenticated;
grant execute on function public.revoke_mini_app_deploy_token(uuid)
  to authenticated;

-- Token-authenticated deploy used by the miniapp-deploy edge function
-- (service_role only). Replaces all screens, snapshots a revision and
-- sends the app back to moderation (or to draft with p_submit = false).
create or replace function public.mini_app_deploy(
  p_token_hash text,
  p_organization_id text,
  p_slug text,
  p_screens jsonb,
  p_submit boolean default true
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid;
  v_app core.mini_apps;
  v_screen jsonb;
begin
  select user_id into v_user_id from core.mini_app_deploy_tokens
  where token_hash = p_token_hash;
  if v_user_id is null then
    return jsonb_build_object('ok', false, 'reason', 'invalid_token');
  end if;
  update core.mini_app_deploy_tokens
  set last_used_at = now() where token_hash = p_token_hash;

  select * into v_app from core.mini_apps
  where organization_id = p_organization_id
    and slug = lower(trim(p_slug))
    and owner_id = v_user_id
  for update;
  if not found then
    return jsonb_build_object('ok', false, 'reason', 'app_not_found');
  end if;
  if v_app.status = 'suspended' then
    return jsonb_build_object('ok', false, 'reason', 'suspended');
  end if;
  if v_app.source_kind <> 'hosted' then
    return jsonb_build_object('ok', false, 'reason', 'not_hosted');
  end if;
  if jsonb_typeof(p_screens) <> 'array'
    or jsonb_array_length(p_screens) = 0
    or jsonb_array_length(p_screens) > 30
  then
    return jsonb_build_object('ok', false, 'reason', 'bad_screens');
  end if;

  delete from core.mini_app_screens where app_id = v_app.id;
  for v_screen in select value from jsonb_array_elements(p_screens)
  loop
    insert into core.mini_app_screens (app_id, path, title, json)
    values (
      v_app.id,
      coalesce(v_screen ->> 'path', '/'),
      v_screen ->> 'title',
      coalesce(v_screen -> 'json', '{}'::jsonb)
    );
  end loop;

  update core.mini_apps
  set version = version + 1,
      status = case when p_submit then 'pending_review' else 'draft' end
  where id = v_app.id;

  perform core.snapshot_mini_app_screens(v_app.id, v_app.version + 1);

  return jsonb_build_object(
    'ok', true,
    'version', v_app.version + 1,
    'status', case when p_submit then 'pending_review' else 'draft' end,
    'validation', app_api_v1.validate_mini_app_screens(p_screens)
  );
end;
$$;

revoke all on function
  public.mini_app_deploy(text, text, text, jsonb, boolean)
  from public, anon, authenticated;
grant execute on function
  public.mini_app_deploy(text, text, text, jsonb, boolean)
  to service_role;

-- ---------------------------------------------------------------------------
-- Push log + notify context (used by the miniapp-notify edge function)
-- ---------------------------------------------------------------------------

create table core.mini_app_push_log (
  app_id uuid not null references core.mini_apps(id) on delete cascade,
  user_id uuid not null,
  sent_at timestamptz not null default now()
);

create index mini_app_push_log_idx
on core.mini_app_push_log (app_id, user_id, sent_at desc);

alter table core.mini_app_push_log enable row level security;

grant all on core.mini_app_push_log to service_role;

-- Resolves the developer by token and returns users who granted the
-- `notifications` scope and are under the per-day quota.
create or replace function public.mini_app_notify_context(
  p_token_hash text,
  p_organization_id text,
  p_slug text,
  p_daily_limit integer default 2
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid;
  v_app core.mini_apps;
  v_recipients jsonb;
begin
  select user_id into v_user_id from core.mini_app_deploy_tokens
  where token_hash = p_token_hash;
  if v_user_id is null then
    return jsonb_build_object('ok', false, 'reason', 'invalid_token');
  end if;

  select * into v_app from core.mini_apps
  where organization_id = p_organization_id
    and slug = lower(trim(p_slug))
    and owner_id = v_user_id;
  if not found then
    return jsonb_build_object('ok', false, 'reason', 'app_not_found');
  end if;
  if v_app.status <> 'published' then
    return jsonb_build_object('ok', false, 'reason', 'not_published');
  end if;
  if not ('notifications' = any (v_app.requested_permissions)) then
    return jsonb_build_object('ok', false, 'reason', 'scope_not_requested');
  end if;

  select coalesce(jsonb_agg(q.user_id), '[]'::jsonb) into v_recipients
  from (
    select c.user_id
    from core.mini_app_consents c
    where c.app_id = v_app.id
      and 'notifications' = any (c.scopes)
      and (
        select count(*) from core.mini_app_push_log l
        where l.app_id = v_app.id
          and l.user_id = c.user_id
          and l.sent_at > now() - interval '24 hours'
      ) < least(greatest(coalesce(p_daily_limit, 2), 1), 5)
    limit 5000
  ) q;

  return jsonb_build_object(
    'ok', true,
    'appId', v_app.id,
    'appName', v_app.name,
    'slug', v_app.slug,
    'recipients', v_recipients
  );
end;
$$;

create or replace function public.log_mini_app_push(
  p_app_id uuid,
  p_user_ids uuid[]
)
returns void
language sql
security definer
set search_path = ''
as $$
  insert into core.mini_app_push_log (app_id, user_id)
  select p_app_id, unnest(p_user_ids);
$$;

revoke all on function
  public.mini_app_notify_context(text, text, text, integer)
  from public, anon, authenticated;
revoke all on function public.log_mini_app_push(uuid, uuid[])
  from public, anon, authenticated;
grant execute on function
  public.mini_app_notify_context(text, text, text, integer)
  to service_role;
grant execute on function public.log_mini_app_push(uuid, uuid[])
  to service_role;

do $$
begin
  perform cron.schedule(
    'prune-mini-app-push-log',
    '41 3 * * *',
    $cron$delete from core.mini_app_push_log
      where sent_at < now() - interval '30 days'$cron$
  );
exception
  when others then
    raise notice 'pg_cron unavailable, skipping push log prune job';
end;
$$;
