create table core.content_write_events (
  user_id uuid not null references auth.users(id) on delete cascade,
  action text not null check (char_length(action) between 1 and 128),
  created_at timestamptz not null default clock_timestamp(),
  byte_count bigint not null default 0 check (byte_count >= 0)
);

create index content_write_events_user_window_idx
  on core.content_write_events (user_id, created_at desc)
  include (action, byte_count);

alter table core.content_write_events enable row level security;
revoke all on core.content_write_events from public, anon, authenticated;

create function core.enforce_content_write_limit(
  p_action text,
  p_per_minute integer,
  p_per_hour integer,
  p_per_day integer,
  p_bytes bigint default 0,
  p_byte_limit bigint default null,
  p_user_id uuid default null
) returns void
language plpgsql security definer set search_path = ''
as $$
declare
  v_user_id uuid := coalesce(p_user_id, (select auth.uid()));
  v_guest boolean;
  v_banned_until timestamptz;
  v_deleted_at timestamptz;
  v_divisor integer;
  v_now timestamptz;
  v_minute_count bigint;
  v_hour_count bigint;
  v_day_count bigint;
  v_global_minute_count bigint;
  v_global_day_count bigint;
  v_byte_count numeric;
begin
  if p_action is null or char_length(p_action) not between 1 and 128
    or p_per_minute is null or p_per_minute not between 1 and 1000000
    or p_per_hour is null or p_per_hour not between 1 and 1000000
    or p_per_day is null or p_per_day not between 1 and 1000000
    or p_bytes is null or p_bytes < 0
    or (p_byte_limit is not null and p_byte_limit < 1) then
    raise exception 'Invalid content rate limit configuration' using errcode = '22023';
  end if;

  if v_user_id is null then
    return;
  end if;

  select coalesce(u.is_anonymous, false), u.banned_until, u.deleted_at
  into v_guest, v_banned_until, v_deleted_at
  from auth.users u where u.id = v_user_id;
  if not found or v_deleted_at is not null then
    raise exception 'Требуется вход в аккаунт' using errcode = '42501';
  end if;
  if v_banned_until > clock_timestamp() then
    raise exception 'Аккаунт временно заблокирован' using errcode = '42501';
  end if;
  v_divisor := case when v_guest then 3 else 1 end;

  perform pg_advisory_xact_lock(hashtextextended('content-write:' || v_user_id::text, 0));
  v_now := clock_timestamp();

  select
    count(*) filter (where e.action = p_action and e.created_at > v_now - interval '1 minute'),
    count(*) filter (where e.action = p_action and e.created_at > v_now - interval '1 hour'),
    count(*) filter (where e.action = p_action),
    count(*) filter (where e.created_at > v_now - interval '1 minute'),
    count(*),
    coalesce(sum(e.byte_count) filter (where e.action = p_action), 0)
  into v_minute_count, v_hour_count, v_day_count,
    v_global_minute_count, v_global_day_count, v_byte_count
  from core.content_write_events e
  where e.user_id = v_user_id and e.created_at > v_now - interval '1 day';

  if v_minute_count >= greatest(1, p_per_minute / v_divisor)
    or v_hour_count >= greatest(1, p_per_hour / v_divisor)
    or v_day_count >= greatest(1, p_per_day / v_divisor)
    or v_global_minute_count >= 1200 / v_divisor
    or v_global_day_count >= 12000 / v_divisor
    or (p_byte_limit is not null
      and (v_byte_count >= greatest(1, p_byte_limit / v_divisor)
        or v_byte_count + p_bytes > greatest(1, p_byte_limit / v_divisor))) then
    raise exception 'Слишком много запросов, попробуйте позже'
      using errcode = 'P0001', hint = 'rate_limited:' || p_action;
  end if;

  insert into core.content_write_events (user_id, action, created_at, byte_count)
  values (v_user_id, p_action, v_now, p_bytes);
end;
$$;

revoke all on function core.enforce_content_write_limit(text, integer, integer, integer, bigint, bigint, uuid)
  from public, anon, authenticated, service_role;

select cron.schedule(
  'purge-content-write-events',
  '27 3 * * *',
  $cron$delete from core.content_write_events where created_at < clock_timestamp() - interval '2 days'$cron$
);
