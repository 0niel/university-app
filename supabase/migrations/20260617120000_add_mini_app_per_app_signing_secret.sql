-- Per-app signing secrets for remote mini apps.
--
-- Replaces the single platform-wide MINIAPP_PROXY_SECRET (handed out by the
-- platform team on request) with a self-service, per-app HMAC secret the owner
-- generates and copies right in the app. Per-app secrets shrink the blast
-- radius: a leak compromises one app's request verification, not every app's.
--
-- The proxy must SIGN every request with the plaintext, so unlike a deploy
-- token (we keep only its sha256) the secret has to be recoverable. We store it
-- encrypted at rest in Supabase Vault and keep only Vault ids + a short
-- fingerprint in core.mini_app_secrets. The table is service_role-only with
-- RLS and no authenticated access; the owner never reads it back — they rotate
-- to get a fresh value. Rotation keeps the previous secret valid for a grace
-- window so the developer's server has time to redeploy (the proxy emits both
-- the current and previous signatures during that window).
-- Applied remotely as: add_mini_app_per_app_signing_secret.

-- ---------------------------------------------------------------------------
-- Secret store: Vault ids + display fingerprint, locked to the platform.
-- ---------------------------------------------------------------------------

create table core.mini_app_secrets (
  app_id uuid primary key references core.mini_apps(id) on delete cascade,
  current_secret_id uuid not null,
  previous_secret_id uuid,
  previous_expires_at timestamptz,
  fingerprint text not null,
  created_at timestamptz not null default now(),
  rotated_at timestamptz
);

-- No grant to authenticated on purpose: the plaintext lives in Vault and is
-- only ever read by the security-definer proxy context. RLS with no policies
-- blocks every authenticated path even if a grant slips in later.
alter table core.mini_app_secrets enable row level security;
grant all on core.mini_app_secrets to service_role;

-- Vault secrets must not outlive their row (explicit revoke or app cascade).
create or replace function core.mini_app_secrets_cleanup_vault()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  delete from vault.secrets
  where id in (old.current_secret_id, old.previous_secret_id);
  return old;
end;
$$;

create trigger cleanup_vault_on_mini_app_secret_delete
before delete on core.mini_app_secrets
for each row execute function core.mini_app_secrets_cleanup_vault();

-- ---------------------------------------------------------------------------
-- RPC: generate / rotate. Returns the plaintext exactly once.
-- ---------------------------------------------------------------------------

create or replace function app_api_v1.rotate_mini_app_signing_secret(
  p_app_id uuid,
  p_grace_minutes integer default 1440
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_app core.mini_apps;
  v_existing core.mini_app_secrets;
  v_secret text;
  v_fingerprint text;
  v_new_id uuid;
  v_grace integer := least(greatest(coalesce(p_grace_minutes, 1440), 0), 10080);
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;
  perform core.enforce_rate_limit(
    'rotate_mini_app_signing_secret', 10, interval '1 hour'
  );

  select * into v_app from core.mini_apps
  where id = p_app_id and owner_id = v_user_id
  for update;
  if not found then
    raise exception 'Mini app not found or not owned by you';
  end if;
  if v_app.source_kind <> 'remote' then
    raise exception 'Signing secrets apply only to remote mini apps'
      using errcode = '22023';
  end if;

  v_secret := 'mns_' || encode(extensions.gen_random_bytes(24), 'hex');
  v_fingerprint := right(
    encode(extensions.digest(v_secret, 'sha256'), 'hex'), 6
  );
  v_new_id := vault.create_secret(
    v_secret,
    'miniapp_sig:' || p_app_id || ':' || extensions.gen_random_uuid(),
    'Mini app signing secret'
  );

  select * into v_existing from core.mini_app_secrets where app_id = p_app_id;
  if found then
    -- The secret retired by the previous rotation is no longer needed.
    if v_existing.previous_secret_id is not null then
      delete from vault.secrets where id = v_existing.previous_secret_id;
    end if;
    update core.mini_app_secrets
    set previous_secret_id =
          case when v_grace > 0 then v_existing.current_secret_id end,
        previous_expires_at =
          case when v_grace > 0 then now() + v_grace * interval '1 minute' end,
        current_secret_id = v_new_id,
        fingerprint = v_fingerprint,
        rotated_at = now()
    where app_id = p_app_id;
    -- No grace: retire the just-replaced secret immediately.
    if v_grace = 0 then
      delete from vault.secrets where id = v_existing.current_secret_id;
    end if;
  else
    insert into core.mini_app_secrets (app_id, current_secret_id, fingerprint)
    values (p_app_id, v_new_id, v_fingerprint);
  end if;

  return jsonb_build_object(
    'secret', v_secret,
    'fingerprint', v_fingerprint,
    'createdAt', now()
  );
end;
$$;

-- ---------------------------------------------------------------------------
-- RPC: metadata only (never the plaintext). Owner or moderator.
-- ---------------------------------------------------------------------------

create or replace function app_api_v1.get_mini_app_signing_secret_info(
  p_app_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_app core.mini_apps;
  v_sec core.mini_app_secrets;
  v_prev_active boolean;
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;
  select * into v_app from core.mini_apps where id = p_app_id;
  if not found then
    raise exception 'Mini app not found';
  end if;
  if v_app.owner_id <> v_user_id
    and not core.is_mini_app_moderator(v_app.organization_id)
  then
    raise exception 'Not allowed';
  end if;

  select * into v_sec from core.mini_app_secrets where app_id = p_app_id;
  if not found then
    return jsonb_build_object('hasSecret', false);
  end if;
  v_prev_active := v_sec.previous_secret_id is not null
    and v_sec.previous_expires_at > now();
  return jsonb_build_object(
    'hasSecret', true,
    'fingerprint', v_sec.fingerprint,
    'createdAt', v_sec.created_at,
    'rotatedAt', v_sec.rotated_at,
    'previousActive', v_prev_active,
    'previousExpiresAt',
      case when v_prev_active then v_sec.previous_expires_at end
  );
end;
$$;

-- ---------------------------------------------------------------------------
-- RPC: disable signing (drops the secret; the trigger cleans up Vault).
-- ---------------------------------------------------------------------------

create or replace function app_api_v1.revoke_mini_app_signing_secret(
  p_app_id uuid
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;
  perform 1 from core.mini_apps
  where id = p_app_id and owner_id = v_user_id;
  if not found then
    raise exception 'Mini app not found or not owned by you';
  end if;
  delete from core.mini_app_secrets where app_id = p_app_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- public wrappers + grants (authenticated only; gated inside).
-- ---------------------------------------------------------------------------

create or replace function public.rotate_mini_app_signing_secret(
  p_app_id uuid, p_grace_minutes integer default 1440
)
returns jsonb language sql security invoker set search_path = ''
as $$
  select app_api_v1.rotate_mini_app_signing_secret(p_app_id, p_grace_minutes);
$$;

create or replace function public.get_mini_app_signing_secret_info(p_app_id uuid)
returns jsonb language sql security invoker set search_path = ''
as $$ select app_api_v1.get_mini_app_signing_secret_info(p_app_id); $$;

create or replace function public.revoke_mini_app_signing_secret(p_app_id uuid)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.revoke_mini_app_signing_secret(p_app_id); $$;

revoke all on function public.rotate_mini_app_signing_secret(uuid, integer)
  from public, anon;
revoke all on function public.get_mini_app_signing_secret_info(uuid)
  from public, anon;
revoke all on function public.revoke_mini_app_signing_secret(uuid)
  from public, anon;
grant execute on function public.rotate_mini_app_signing_secret(uuid, integer)
  to authenticated;
grant execute on function public.get_mini_app_signing_secret_info(uuid)
  to authenticated;
grant execute on function public.revoke_mini_app_signing_secret(uuid)
  to authenticated;

-- ---------------------------------------------------------------------------
-- Proxy context: hand the edge function the per-app secret(s) for remote apps.
-- Same body as the permissions migration, plus the Vault lookup and the two
-- new return fields. Stable appUserId derivation lives in the edge function.
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
  v_secret_row core.mini_app_secrets;
  v_signing text;
  v_previous text;
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

    -- Per-app signing secret(s), decrypted from Vault. The previous secret is
    -- exposed only during its rotation grace window so the proxy can sign with
    -- both and a not-yet-redeployed origin keeps validating.
    if v_app.source_kind = 'remote' then
      select * into v_secret_row
      from core.mini_app_secrets where app_id = v_app.id;
      if found then
        select decrypted_secret into v_signing
        from vault.decrypted_secrets where id = v_secret_row.current_secret_id;
        if v_secret_row.previous_secret_id is not null
          and v_secret_row.previous_expires_at > now()
        then
          select decrypted_secret into v_previous
          from vault.decrypted_secrets
          where id = v_secret_row.previous_secret_id;
        end if;
      end if;
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
    'identity', v_identity,
    'signingSecret', v_signing,
    'previousSigningSecret', v_previous
  );
end;
$$;

-- ---------------------------------------------------------------------------
-- Hourly cleanup: drop Vault secrets whose rotation grace has expired.
-- ---------------------------------------------------------------------------

do $$
begin
  perform cron.schedule(
    'prune-mini-app-prev-secrets',
    '23 * * * *',
    $cron$
      with expired as (
        select app_id, previous_secret_id
        from core.mini_app_secrets
        where previous_secret_id is not null
          and previous_expires_at <= now()
      ),
      deleted as (
        delete from vault.secrets v using expired e
        where v.id = e.previous_secret_id
        returning v.id
      )
      update core.mini_app_secrets s
      set previous_secret_id = null, previous_expires_at = null
      from expired e
      where s.app_id = e.app_id
    $cron$
  );
exception
  when others then
    raise notice 'pg_cron unavailable, skipping prev-secret prune job';
end;
$$;
