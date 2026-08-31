-- Schedules the sync-telegram-feed Edge Function through pg_cron + pg_net.
-- The function scrapes public t.me/s previews and writes through the
-- begin/ingest/finish content-sync RPC path.
--
-- Runtime configuration lives in internal.app_config (set manually, never
-- committed): 'telegram_sync_url' and 'telegram_sync_secret'. The secret must
-- match the TELEGRAM_SYNC_SECRET Edge Function secret.

create or replace function internal.request_telegram_feed_sync()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_url text;
  v_secret text;
begin
  select value into v_url
  from internal.app_config where key = 'telegram_sync_url';
  select value into v_secret
  from internal.app_config where key = 'telegram_sync_secret';
  if v_url is null or v_secret is null then
    return; -- telegram sync not configured
  end if;

  perform net.http_post(
    url := v_url,
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'x-sync-secret', v_secret
    ),
    body := '{}'::jsonb,
    timeout_milliseconds := 240000
  );
end;
$$;

revoke all on function internal.request_telegram_feed_sync()
from public, anon, authenticated;

select cron.schedule(
  'sync-telegram-feed',
  '*/15 * * * *',
  $$select internal.request_telegram_feed_sync()$$
);
