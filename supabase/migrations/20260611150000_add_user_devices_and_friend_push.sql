-- Push notifications for friend requests.
--
-- core.user_devices stores FCM registration tokens per user. Triggers on
-- core.friendships fire pg_net POSTs to the `friends-push` edge function,
-- which delivers FCM v1 pushes ("новая заявка" to the addressee, "заявка
-- принята" to the requester). The webhook URL + shared secret live in
-- internal.app_config; while unset the triggers no-op, so this migration is
-- safe to apply before the function is deployed.

create extension if not exists pg_net;

-- ── device tokens ────────────────────────────────────────────────────────────

create table core.user_devices (
  fcm_token text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  platform text not null default 'android',
  updated_at timestamptz not null default now(),
  constraint user_devices_platform_valid
    check (platform in ('android', 'ios', 'web')),
  constraint user_devices_token_not_empty check (length(fcm_token) > 20)
);

create index user_devices_user_idx on core.user_devices (user_id);

alter table core.user_devices enable row level security;

create policy "users manage own devices"
on core.user_devices
for all
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

grant select, insert, update, delete on core.user_devices to authenticated;
grant all on core.user_devices to service_role;

create or replace function app_api_v1.register_device(
  p_token text,
  p_platform text default 'android'
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;

  insert into core.user_devices (fcm_token, user_id, platform, updated_at)
  values (p_token, v_user_id, p_platform, now())
  on conflict (fcm_token) do update set
    user_id = excluded.user_id,
    platform = excluded.platform,
    updated_at = now();
end;
$$;

create or replace function app_api_v1.unregister_device(p_token text)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
begin
  delete from core.user_devices
  where fcm_token = p_token
    and user_id = (select auth.uid());
end;
$$;

create or replace function public.register_device(
  p_token text,
  p_platform text default 'android'
)
returns void
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.register_device(p_token, p_platform);
$$;

create or replace function public.unregister_device(p_token text)
returns void
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.unregister_device(p_token);
$$;

revoke all on function public.register_device(text, text) from public, anon;
revoke all on function public.unregister_device(text) from public, anon;
grant execute on function public.register_device(text, text) to authenticated;
grant execute on function public.unregister_device(text) to authenticated;

-- ── webhook config (service-managed; empty until the function is deployed) ──

create table internal.app_config (
  key text primary key,
  value text not null
);

alter table internal.app_config enable row level security;
grant all on internal.app_config to service_role;

-- ── friendship → edge function webhook ───────────────────────────────────────

create or replace function internal.notify_friend_event()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_url text;
  v_secret text;
  v_event text;
begin
  select value into v_url
  from internal.app_config where key = 'friends_push_url';
  select value into v_secret
  from internal.app_config where key = 'friends_push_secret';
  if v_url is null or v_secret is null then
    return new; -- push delivery not configured yet
  end if;

  if tg_op = 'INSERT' and new.status = 'pending' then
    v_event := 'friend_request';
  elsif tg_op = 'UPDATE'
    and new.status = 'accepted' and old.status = 'pending' then
    v_event := 'friend_accepted';
  else
    return new;
  end if;

  perform net.http_post(
    url := v_url,
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'x-push-secret', v_secret
    ),
    body := jsonb_build_object(
      'event', v_event,
      'friendship_id', new.id,
      'requester_id', new.requester_id,
      'addressee_id', new.addressee_id
    )
  );
  return new;
end;
$$;

create trigger friendships_push_on_insert
after insert on core.friendships
for each row execute function internal.notify_friend_event();

create trigger friendships_push_on_update
after update on core.friendships
for each row execute function internal.notify_friend_event();
