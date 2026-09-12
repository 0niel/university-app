begin;

set local statement_timeout = '30s';

do $$
declare
  v_user uuid := extensions.gen_random_uuid();
  v_other uuid := extensions.gen_random_uuid();
  v_guest uuid := extensions.gen_random_uuid();
  v_hint text;
  v_count bigint;
begin
  insert into auth.users (id, is_anonymous) values
    (v_user, false), (v_other, false), (v_guest, true);

  if has_function_privilege('anon',
    'core.enforce_content_write_limit(text,integer,integer,integer,bigint,bigint,uuid)', 'EXECUTE')
    or has_function_privilege('authenticated',
    'core.enforce_content_write_limit(text,integer,integer,integer,bigint,bigint,uuid)', 'EXECUTE')
    or has_function_privilege('service_role',
    'core.enforce_content_write_limit(text,integer,integer,integer,bigint,bigint,uuid)', 'EXECUTE')
    or has_table_privilege('authenticated', 'core.content_write_events', 'SELECT,INSERT,UPDATE,DELETE')
    or has_table_privilege('anon', 'core.content_write_events', 'SELECT,INSERT,UPDATE,DELETE') then
    raise exception 'Clients can bypass or inspect the content limiter';
  end if;

  perform core.enforce_content_write_limit('contract-minute', 2, 10, 20, p_user_id => v_user);
  perform core.enforce_content_write_limit('contract-minute', 2, 10, 20, p_user_id => v_user);
  begin
    perform core.enforce_content_write_limit('contract-minute', 2, 10, 20, p_user_id => v_user);
    raise exception 'Minute limit accepted an extra write' using errcode = 'XX000';
  exception when sqlstate 'P0001' then
    get stacked diagnostics v_hint = pg_exception_hint;
    if v_hint <> 'rate_limited:contract-minute' then raise exception 'Wrong limiter hint'; end if;
  end;

  select count(*) into v_count from core.content_write_events
  where user_id = v_user and action = 'contract-minute';
  if v_count <> 2 then raise exception 'Rejected calls changed the ledger'; end if;

  perform core.enforce_content_write_limit('contract-minute', 2, 10, 20, p_user_id => v_other);
  update core.content_write_events set created_at = clock_timestamp() - interval '2 minutes'
  where user_id = v_user;
  perform core.enforce_content_write_limit('contract-minute', 2, 10, 20, p_user_id => v_user);

  insert into core.content_write_events (user_id, action, created_at)
  select v_user, 'contract-hour', clock_timestamp() - interval '2 minutes'
  from generate_series(1, 3);
  begin
    perform core.enforce_content_write_limit('contract-hour', 10, 3, 20, p_user_id => v_user);
    raise exception 'Hour limit accepted an extra write' using errcode = 'XX000';
  exception when sqlstate 'P0001' then null;
  end;

  insert into core.content_write_events (user_id, action, created_at)
  select v_user, 'contract-day', clock_timestamp() - interval '2 hours'
  from generate_series(1, 3);
  begin
    perform core.enforce_content_write_limit('contract-day', 10, 20, 3, p_user_id => v_user);
    raise exception 'Day limit accepted an extra write' using errcode = 'XX000';
  exception when sqlstate 'P0001' then null;
  end;

  perform set_config('request.jwt.claims', jsonb_build_object(
    'sub', v_guest, 'role', 'authenticated', 'is_anonymous', false)::text, true);
  perform core.enforce_content_write_limit('contract-guest', 3, 9, 30, p_user_id => v_guest);
  begin
    perform core.enforce_content_write_limit('contract-guest', 3, 9, 30, p_user_id => v_guest);
    raise exception 'Guest quota trusted the supplied claim' using errcode = 'XX000';
  exception when sqlstate 'P0001' then null;
  end;

  perform core.enforce_content_write_limit('contract-bytes', 20, 30, 40, 100, 100, v_user);
  begin
    perform core.enforce_content_write_limit('contract-bytes', 20, 30, 40, 0, 100, v_user);
    raise exception 'Full byte quota allowed another upload preflight' using errcode = 'XX000';
  exception when sqlstate 'P0001' then null;
  end;
  begin
    perform core.enforce_content_write_limit('contract-bytes', 20, 30, 40, 1, 100, v_user);
    raise exception 'Byte limit accepted an extra byte' using errcode = 'XX000';
  exception when sqlstate 'P0001' then null;
  end;
  perform core.enforce_content_write_limit('contract-other-bytes', 20, 30, 40, 100, 100, v_user);

  update core.content_write_events set created_at = clock_timestamp() - interval '25 hours'
  where user_id = v_user and action = 'contract-bytes';
  perform core.enforce_content_write_limit('contract-bytes', 20, 30, 40, 100, 100, v_user);

  begin
    perform core.enforce_content_write_limit('contract-rollback', 1, 1, 1, p_user_id => v_user);
    raise exception 'Abort mutation' using errcode = 'XX000';
  exception when sqlstate 'XX000' then null;
  end;
  if exists (select from core.content_write_events where user_id = v_user and action = 'contract-rollback') then
    raise exception 'Rolled back mutation consumed quota';
  end if;
  perform core.enforce_content_write_limit('contract-rollback', 1, 1, 1, p_user_id => v_user);

  insert into core.content_write_events (user_id, action, created_at)
  select v_other, 'contract-global', clock_timestamp() from generate_series(1, 1199);
  begin
    perform core.enforce_content_write_limit('contract-new-action', 5000, 6000, 7000, p_user_id => v_other);
    raise exception 'Changing action bypassed the global minute limit' using errcode = 'XX000';
  exception when sqlstate 'P0001' then null;
  end;

  update core.content_write_events set created_at = clock_timestamp() - interval '2 hours'
  where user_id = v_other;
  insert into core.content_write_events (user_id, action, created_at)
  select v_other, 'contract-global-day', clock_timestamp() - interval '2 hours'
  from generate_series(1, 10800);
  begin
    perform core.enforce_content_write_limit('contract-new-action', 5000, 6000, 7000, p_user_id => v_other);
    raise exception 'Changing action bypassed the global day limit' using errcode = 'XX000';
  exception when sqlstate 'P0001' then null;
  end;

  update auth.users set banned_until = clock_timestamp() + interval '1 hour' where id = v_user;
  perform set_config('request.jwt.claims', jsonb_build_object(
    'sub', v_user, 'role', 'authenticated', 'is_anonymous', false)::text, true);
  perform set_config('request.jwt.claim.sub', v_user::text, true);
  begin
    perform core.enforce_content_write_limit('contract-banned', 10, 20, 30);
    raise exception 'Banned account used a stale access token' using errcode = 'XX000';
  exception when insufficient_privilege then null;
  end;
  perform set_config('request.jwt.claims', '{"role":"service_role"}', true);
  perform set_config('request.jwt.claim.sub', '', true);
  begin
    perform core.enforce_content_write_limit('contract-banned-service', 10, 20, 30, p_user_id => v_user);
    raise exception 'Banned account used a deploy or upload owner' using errcode = 'XX000';
  exception when insufficient_privilege then null;
  end;
  update auth.users set banned_until = null, deleted_at = clock_timestamp() where id = v_user;
  begin
    perform core.enforce_content_write_limit('contract-deleted', 10, 20, 30, p_user_id => v_user);
    raise exception 'Deleted account wrote content' using errcode = 'XX000';
  exception when insufficient_privilege then null;
  end;
end;
$$;

rollback;
