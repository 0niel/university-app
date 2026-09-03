alter table core.mini_app_push_log
  add column if not exists reservation_id uuid,
  add column if not exists reserved_at timestamptz;

update core.mini_app_push_log
set reservation_id = coalesce(reservation_id, extensions.gen_random_uuid()),
    reserved_at = coalesce(reserved_at, sent_at, now())
where reservation_id is null or reserved_at is null;

alter table core.mini_app_push_log
  alter column reservation_id set not null,
  alter column reservation_id set default extensions.gen_random_uuid(),
  alter column reserved_at set not null,
  alter column reserved_at set default now(),
  alter column sent_at drop not null,
  alter column sent_at drop default;

create unique index if not exists mini_app_push_reservation_user_idx
on core.mini_app_push_log (reservation_id, user_id);

drop index if exists core.mini_app_push_log_idx;
create index mini_app_push_log_idx
on core.mini_app_push_log (app_id, user_id, reserved_at desc, sent_at desc);

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
  v_reservation_id uuid := extensions.gen_random_uuid();
begin
  select user_id into v_user_id
  from core.mini_app_deploy_tokens
  where token_hash = p_token_hash;
  if v_user_id is null then
    return jsonb_build_object('ok', false, 'reason', 'invalid_token');
  end if;

  select * into v_app
  from core.mini_apps
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

  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(v_app.id::text, 0)
  );

  delete from core.mini_app_push_log
  where app_id = v_app.id
    and sent_at is null
    and reserved_at <= now() - interval '15 minutes';

  with eligible as (
    select c.user_id
    from core.mini_app_consents c
    where c.app_id = v_app.id
      and 'notifications' = any (c.scopes)
      and (
        select count(*)
        from core.mini_app_push_log l
        where l.app_id = v_app.id
          and l.user_id = c.user_id
          and (
            l.sent_at > now() - interval '24 hours'
            or (
              l.sent_at is null
              and l.reserved_at > now() - interval '15 minutes'
            )
          )
      ) < least(greatest(coalesce(p_daily_limit, 2), 1), 5)
    limit 5000
  ), reserved as (
    insert into core.mini_app_push_log (
      app_id,
      user_id,
      reservation_id
    )
    select v_app.id, user_id, v_reservation_id
    from eligible
    returning user_id
  )
  select coalesce(jsonb_agg(user_id), '[]'::jsonb)
  into v_recipients
  from reserved;

  return jsonb_build_object(
    'ok', true,
    'appId', v_app.id,
    'appName', v_app.name,
    'slug', v_app.slug,
    'reservationId', v_reservation_id,
    'recipients', v_recipients
  );
end;
$$;

create or replace function public.finalize_mini_app_push(
  p_app_id uuid,
  p_reservation_id uuid,
  p_user_ids uuid[]
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(p_app_id::text, 0)
  );

  delete from core.mini_app_push_log
  where app_id = p_app_id
    and reservation_id = p_reservation_id
    and sent_at is null
    and not (user_id = any(coalesce(p_user_ids, '{}'::uuid[])));

  update core.mini_app_push_log
  set sent_at = now()
  where app_id = p_app_id
    and reservation_id = p_reservation_id
    and sent_at is null
    and user_id = any(coalesce(p_user_ids, '{}'::uuid[]));
end;
$$;

create or replace function public.log_mini_app_push(
  p_app_id uuid,
  p_user_ids uuid[]
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(p_app_id::text, 0)
  );

  insert into core.mini_app_push_log (app_id, user_id, sent_at)
  select p_app_id, recipient, now()
  from unnest(coalesce(p_user_ids, '{}'::uuid[])) recipient
  where recipient is not null
  group by recipient;
end;
$$;

create or replace function public.mini_app_push_devices(
  p_app_id uuid,
  p_reservation_id uuid
)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(jsonb_agg(jsonb_build_object(
    'user_id', d.user_id,
    'fcm_token', d.fcm_token,
    'platform', d.platform,
    'cns_endpoint_arn', d.cns_endpoint_arn
  )), '[]'::jsonb)
  from core.user_devices d
  where exists (
    select 1 from core.mini_app_push_log l
    where l.app_id = p_app_id
      and l.reservation_id = p_reservation_id
      and l.user_id = d.user_id
      and l.sent_at is null
      and l.reserved_at > now() - interval '15 minutes'
  );
$$;

create or replace function public.set_mini_app_push_endpoint(
  p_app_id uuid,
  p_reservation_id uuid,
  p_fcm_token text,
  p_endpoint_arn text
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if nullif(trim(p_endpoint_arn), '') is null then
    raise exception 'Endpoint is required' using errcode = '22023';
  end if;
  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(p_app_id::text, 0)
  );
  update core.user_devices d
  set cns_endpoint_arn = p_endpoint_arn
  where d.fcm_token = p_fcm_token
    and exists (
      select 1 from core.mini_app_push_log l
      where l.app_id = p_app_id
        and l.reservation_id = p_reservation_id
        and l.user_id = d.user_id
        and l.sent_at is null
        and l.reserved_at > now() - interval '15 minutes'
    );
end;
$$;

create or replace function public.delete_mini_app_push_devices(
  p_app_id uuid,
  p_reservation_id uuid,
  p_fcm_tokens text[]
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(p_app_id::text, 0)
  );
  delete from core.user_devices d
  where d.fcm_token = any(coalesce(p_fcm_tokens, '{}'::text[]))
    and exists (
      select 1 from core.mini_app_push_log l
      where l.app_id = p_app_id
        and l.reservation_id = p_reservation_id
        and l.user_id = d.user_id
        and l.sent_at is null
        and l.reserved_at > now() - interval '15 minutes'
    );
end;
$$;

revoke all on function public.log_mini_app_push(uuid, uuid[])
from public, anon, authenticated;
revoke all on function public.mini_app_push_devices(uuid, uuid)
from public, anon, authenticated;
revoke all on function public.set_mini_app_push_endpoint(uuid, uuid, text, text)
from public, anon, authenticated;
revoke all on function public.delete_mini_app_push_devices(uuid, uuid, text[])
from public, anon, authenticated;
grant execute on function public.log_mini_app_push(uuid, uuid[])
to service_role;
grant execute on function public.mini_app_push_devices(uuid, uuid)
to service_role;
grant execute on function public.set_mini_app_push_endpoint(uuid, uuid, text, text)
to service_role;
grant execute on function public.delete_mini_app_push_devices(uuid, uuid, text[])
to service_role;
revoke all on function public.mini_app_notify_context(text, text, text, integer)
from public, anon, authenticated;
revoke all on function public.finalize_mini_app_push(uuid, uuid, uuid[])
from public, anon, authenticated;
grant execute on function public.mini_app_notify_context(text, text, text, integer)
to service_role;
grant execute on function public.finalize_mini_app_push(uuid, uuid, uuid[])
to service_role;

notify pgrst, 'reload schema';
