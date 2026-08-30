-- Reusable security primitives for content-creation RPCs:
--   * core.enforce_rate_limit  — per-user sliding-window throttle (tighter for guests)
--   * core.validate_text       — trim + required + max-length guard
-- Tables live in the non-REST-exposed `core` schema; only SECURITY DEFINER
-- functions touch the throttle table, so no direct client access is possible.

create table if not exists core.rate_limit_events (
  user_id    uuid        not null,
  action     text        not null,
  created_at timestamptz not null default now()
);

create index if not exists rate_limit_events_lookup
  on core.rate_limit_events (user_id, action, created_at desc);

-- Lock the throttle table down: only the DEFINER function (owned by postgres)
-- ever reads/writes it. Deny everything else.
alter table core.rate_limit_events enable row level security;
revoke all on core.rate_limit_events from anon, authenticated;

-- ---------------------------------------------------------------------------
-- Per-user rate limit. Counts the caller's recent calls for `p_action` inside
-- `p_per`; raises (SQLSTATE P0001, hint `rate_limited:<action>`) when the cap
-- is hit, otherwise records the call. Anonymous/guest sessions get 1/3 the cap.
-- ---------------------------------------------------------------------------
create or replace function core.enforce_rate_limit(
  p_action text,
  p_max    integer,
  p_per    interval default interval '1 hour'
) returns void
  language plpgsql
  security definer
  set search_path = ''
as $$
declare
  v_uid      uuid := (select auth.uid());
  v_claims   text := nullif(current_setting('request.jwt.claims', true), '');
  v_is_guest boolean :=
    coalesce((v_claims::jsonb ->> 'is_anonymous')::boolean, false);
  v_eff_max  integer := case when v_is_guest then greatest(1, p_max / 3) else p_max end;
  v_count    integer;
begin
  if v_uid is null then
    raise exception 'Требуется вход в аккаунт' using errcode = '42501';
  end if;

  -- Serialize concurrent calls for this (user, action) so a burst of parallel
  -- requests cannot slip past the window check.
  perform pg_advisory_xact_lock(
    hashtextextended(v_uid::text || ':' || p_action, 0)
  );

  select count(*) into v_count
  from core.rate_limit_events
  where user_id = v_uid
    and action = p_action
    and created_at > now() - p_per;

  if v_count >= v_eff_max then
    raise exception 'Слишком много запросов, попробуйте позже'
      using errcode = 'P0001', hint = 'rate_limited:' || p_action;
  end if;

  insert into core.rate_limit_events (user_id, action) values (v_uid, p_action);
end;
$$;

-- ---------------------------------------------------------------------------
-- Trim + validate a free-text field. Returns the trimmed value.
-- ---------------------------------------------------------------------------
create or replace function core.validate_text(
  p_value    text,
  p_field    text,
  p_max      integer,
  p_required boolean default false
) returns text
  language plpgsql
  immutable
  set search_path = ''
as $$
declare
  v text := btrim(coalesce(p_value, ''));
begin
  if p_required and v = '' then
    raise exception 'Поле «%» обязательно для заполнения', p_field
      using errcode = '22023';
  end if;
  if char_length(v) > p_max then
    raise exception 'Поле «%» слишком длинное (максимум % символов)', p_field, p_max
      using errcode = '22001';
  end if;
  return v;
end;
$$;

grant execute on function core.enforce_rate_limit(text, integer, interval)
  to authenticated, anon;
grant execute on function core.validate_text(text, text, integer, boolean)
  to authenticated, anon;

-- Daily purge so the throttle ledger stays small (window is <= 1 day in practice).
select cron.schedule(
  'purge-rate-limit-events',
  '17 3 * * *',
  $cron$ delete from core.rate_limit_events where created_at < now() - interval '2 days' $cron$
);
