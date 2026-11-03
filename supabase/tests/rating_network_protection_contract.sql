begin;
set local statement_timeout = '30s';
set local lock_timeout = '3s';

create function pg_temp.expect_rating_network_error(p_sql text, p_state text, p_hint text)
returns void language plpgsql as $$
declare v_hint text;
begin
  begin
    execute p_sql;
  exception when others then
    get stacked diagnostics v_hint = pg_exception_hint;
    if sqlstate = p_state and v_hint = p_hint then return; end if;
    raise;
  end;
  raise exception 'Rating network protection was bypassed';
end;
$$;

create function pg_temp.set_rating_actor(p_user_id uuid, p_session_id uuid, p_role text default 'authenticated')
returns void language plpgsql as $$
begin
  perform set_config('request.jwt.claim.sub', coalesce(p_user_id::text, ''), true);
  perform set_config('request.jwt.claim.role', p_role, true);
  perform set_config('request.jwt.claims', jsonb_strip_nulls(jsonb_build_object(
    'sub', p_user_id, 'session_id', p_session_id, 'role', p_role
  ))::text, true);
end;
$$;

do $$
declare
  v_users uuid[] := '{}';
  v_sessions uuid[] := '{}';
  v_user uuid;
  v_session uuid;
  v_guest uuid := extensions.gen_random_uuid();
  v_app uuid := extensions.gen_random_uuid();
  v_expired uuid := extensions.gen_random_uuid();
  v_target text := 'Network teacher ' || extensions.gen_random_uuid()::text;
  v_other_target text := 'Other teacher ' || extensions.gen_random_uuid()::text;
  v_hour_target text := 'Hourly teacher ' || extensions.gen_random_uuid()::text;
  v_ip inet := '192.0.2.50';
  v_count bigint;
  v_role text;
  v_table text;
  v_review uuid;
begin
  foreach v_role in array array['anon', 'authenticated', 'service_role'] loop
    if has_table_privilege(v_role, 'internal.rating_write_audit', 'SELECT,INSERT,UPDATE,DELETE')
      or has_function_privilege(v_role, 'internal.protect_rating_network()', 'EXECUTE') then
      raise exception 'Rating network audit is directly accessible: %', v_role;
    end if;
  end loop;
  if not (select relrowsecurity from pg_class where oid = 'internal.rating_write_audit'::regclass)
    or exists (select 1 from pg_constraint
      where conrelid = 'internal.rating_write_audit'::regclass and contype = 'f') then
    raise exception 'Rating audit privacy or durable retention is missing';
  end if;
  foreach v_table in array array['core.teacher_reviews', 'core.lesson_reviews', 'core.mini_app_ratings'] loop
    if not exists (select 1 from pg_trigger
      where tgrelid = v_table::regclass and tgname = 'rating_network_protection'
        and tgfoid = 'internal.protect_rating_network()'::regprocedure
        and tgenabled = 'O' and tgtype = 23) then
      raise exception 'Rating network trigger is missing: %', v_table;
    end if;
  end loop;

  perform set_config('request.jwt.claim.sub', '', true);
  perform set_config('request.jwt.claim.role', '', true);
  perform set_config('request.jwt.claims', '{}', true);
  insert into core.organizations(id, name) values ('rating-network-contract', 'Rating Network Contract');
  for i in 1..12 loop
    v_user := extensions.gen_random_uuid();
    v_session := extensions.gen_random_uuid();
    v_users := array_append(v_users, v_user);
    v_sessions := array_append(v_sessions, v_session);
    insert into auth.users(id, is_anonymous, created_at, email_confirmed_at)
    values (v_user, false, now() - interval '3 days', now() - interval '2 days');
    insert into core.user_academic_profiles(user_id, organization_id)
    values (v_user, 'rating-network-contract');
    insert into auth.sessions(id, user_id, created_at, updated_at, ip)
    values (v_session, v_user, now(), now(), case when i = 12 then '2001:db8::50'::inet else v_ip end);
  end loop;
  insert into auth.users(id, is_anonymous) values (v_guest, true);
  insert into core.mini_apps(id, organization_id, owner_id, slug, name)
  values (v_app, 'rating-network-contract', v_users[1], 'rating-network-contract', 'Rating Network Contract');
  insert into core.teacher_reviews(organization_id, user_id, teacher_name, clarity, loyalty, usefulness, body)
  values ('rating-network-contract', v_users[1], 'Maintenance teacher', 4, 4, 4, 'Fixture');
  if exists (select 1 from internal.rating_write_audit where user_id = any(v_users)) then
    raise exception 'Maintenance fixture consumed rating network quota';
  end if;
  delete from core.teacher_reviews where teacher_name = 'Maintenance teacher' and user_id = v_users[1];

  for i in 1..10 loop
    perform pg_temp.set_rating_actor(v_users[i], v_sessions[i]);
    perform set_config('request.headers', jsonb_build_object(
      'x-forwarded-for', '198.51.100.' || i, 'x-real-ip', '203.0.113.' || i
    )::text, true);
    perform public.upsert_teacher_review('rating-network-contract', v_target, 4, 4, 4, 'Initial', false);
  end loop;
  if (select count(*) from internal.rating_write_audit
      where source_table = 'core.teacher_reviews'
        and target_key = jsonb_build_array('rating-network-contract', v_target)
        and ip_address = v_ip) <> 10 then
    raise exception 'Trusted session IP grouping was replaced by spoofed headers';
  end if;
  perform pg_temp.set_rating_actor(v_users[11], v_sessions[11]);
  perform pg_temp.expect_rating_network_error(format(
    'select public.upsert_teacher_review(%L,%L,1,1,1,%L,true)',
    'rating-network-contract', v_target, ''
  ), 'P0001', 'rating_network_account_limit');
  if exists (select 1 from core.teacher_reviews where user_id = v_users[11] and teacher_name = v_target)
    or exists (select 1 from internal.rating_write_audit where user_id = v_users[11]) then
    raise exception 'Rejected network write persisted content or audit';
  end if;

  perform pg_temp.set_rating_actor(v_users[1], v_sessions[1]);
  select count(*) into v_count from internal.rating_write_audit where user_id = v_users[1];
  perform public.upsert_teacher_review('rating-network-contract', v_target, 5, 4, 4, 'Edited', false);
  if (select count(*) from internal.rating_write_audit where user_id = v_users[1]) <> v_count + 1 then
    raise exception 'Upsert changed content without exactly one rating audit event';
  end if;
  perform public.upsert_teacher_review('rating-network-contract', v_target, 5, 4, 4, 'Edited', false);
  update core.teacher_reviews set body = body where user_id = v_users[1] and teacher_name = v_target;
  if (select count(*) from internal.rating_write_audit where user_id = v_users[1]) <> v_count + 1 then
    raise exception 'No-op upsert or update consumed rating network quota';
  end if;
  delete from core.teacher_reviews where user_id = v_users[1] and teacher_name = v_target;
  perform public.upsert_teacher_review('rating-network-contract', v_target, 5, 4, 4, 'Reinserted', false);
  if (select count(distinct user_id) from internal.rating_write_audit
      where source_table = 'core.teacher_reviews'
        and target_key = jsonb_build_array('rating-network-contract', v_target) and ip_address = v_ip) <> 10 then
    raise exception 'Editing or deleting a review reset distinct account quota';
  end if;

  perform pg_temp.set_rating_actor(null, null, 'service_role');
  perform pg_temp.expect_rating_network_error(format(
    'insert into core.teacher_reviews(organization_id,user_id,teacher_name,clarity,loyalty,usefulness) values(%L,%L,%L,1,1,1)',
    'rating-network-contract', v_users[11], v_target
  ), 'P0001', 'rating_network_account_limit');
  insert into core.teacher_reviews(organization_id, user_id, teacher_name, clarity, loyalty, usefulness, body)
  values ('rating-network-contract', v_users[11], v_other_target, 3, 3, 3, 'Service');
  if not exists (select 1 from internal.rating_write_audit
      where user_id = v_users[11] and session_id = v_sessions[11] and ip_address = v_ip
        and target_key = jsonb_build_array('rating-network-contract', v_other_target)) then
    raise exception 'Service write lost canonical actor or latest trusted session';
  end if;
  perform pg_temp.set_rating_actor(v_users[12], v_sessions[12]);
  perform public.upsert_teacher_review('rating-network-contract', v_target, 3, 3, 3, 'Other network', false);

  perform pg_temp.set_rating_actor(v_users[11], v_sessions[1]);
  perform pg_temp.expect_rating_network_error(format(
    'select public.upsert_teacher_review(%L,%L,3,3,3,%L,false)',
    'rating-network-contract', 'Forged session teacher', 'Invalid'
  ), '42501', 'rating_session_unavailable');
  perform pg_temp.set_rating_actor(v_users[11], extensions.gen_random_uuid());
  perform pg_temp.expect_rating_network_error(format(
    'select public.upsert_teacher_review(%L,%L,3,3,3,%L,false)',
    'rating-network-contract', 'Revoked session teacher', 'Invalid'
  ), '42501', 'rating_session_unavailable');
  insert into auth.sessions(id, user_id, created_at, updated_at, not_after, ip)
  values (v_expired, v_users[11], now(), now(), now() - interval '1 minute', v_ip);
  perform pg_temp.set_rating_actor(v_users[11], v_expired);
  perform pg_temp.expect_rating_network_error(format(
    'select public.upsert_teacher_review(%L,%L,3,3,3,%L,false)',
    'rating-network-contract', 'Expired session teacher', 'Invalid'
  ), '42501', 'rating_session_unavailable');

  perform pg_temp.set_rating_actor(v_users[1], v_sessions[1]);
  insert into core.lesson_reviews(organization_id, user_id, subject_name, lesson_date,
    lesson_bells_number, lesson_uid, body, rating)
  values ('rating-network-contract', v_users[1], 'Network lesson', current_date, 1, 'network-uid', 'Lesson', 4)
  returning id into v_review;
  select count(*) into v_count from internal.rating_write_audit
  where source_table = 'core.lesson_reviews' and user_id = v_users[1];
  update core.lesson_reviews set like_count = like_count + 1, updated_at = clock_timestamp()
  where id = v_review;
  if (select count(*) from internal.rating_write_audit
      where source_table = 'core.lesson_reviews' and user_id = v_users[1]) <> v_count then
    raise exception 'Derived lesson counters consumed rating network quota';
  end if;
  update core.lesson_reviews set lesson_uid = 'network-uid-alias', rating = 5 where id = v_review;
  if (select count(distinct target_key) from internal.rating_write_audit
      where source_table = 'core.lesson_reviews' and user_id = v_users[1]) <> 1 then
    raise exception 'Lesson UID alias reset canonical target grouping';
  end if;
  insert into core.mini_app_ratings(app_id, user_id, rating) values (v_app, v_users[1], 4);
  select count(*) into v_count from internal.rating_write_audit where source_table = 'core.mini_app_ratings';
  insert into core.mini_app_ratings(app_id, user_id, rating) values (v_app, v_users[1], 4)
  on conflict (app_id, user_id) do update set rating = excluded.rating;
  if (select count(*) from internal.rating_write_audit where source_table = 'core.mini_app_ratings') <> v_count
    or not exists (select 1 from internal.rating_write_audit
      where source_table = 'core.mini_app_ratings' and target_key = jsonb_build_array(v_app)) then
    raise exception 'Mini-app rating target or no-op accounting is invalid';
  end if;

  insert into internal.rating_write_audit(user_id, source_table, target_key, session_id, ip_address, operation, created_at)
  select v_users[1], 'core.teacher_reviews', jsonb_build_array('rating-network-contract', v_hour_target),
    v_sessions[1], v_ip, 'UPDATE', clock_timestamp() - interval '10 minutes'
  from generate_series(1, 59);
  perform public.upsert_teacher_review('rating-network-contract', v_hour_target, 4, 4, 4, 'Sixtieth', false);
  perform pg_temp.expect_rating_network_error(format(
    'select public.upsert_teacher_review(%L,%L,5,5,5,%L,false)',
    'rating-network-contract', v_hour_target, 'Over hourly limit'
  ), 'P0001', 'rating_network_write_limit');
  if (select count(*) from internal.rating_write_audit
      where source_table = 'core.teacher_reviews'
        and target_key = jsonb_build_array('rating-network-contract', v_hour_target)) <> 60 then
    raise exception 'Rejected hourly write changed durable audit';
  end if;

  perform pg_temp.set_rating_actor(null, null, '');
  delete from auth.users where id = v_users[2];
  if not exists (select 1 from internal.rating_write_audit where user_id = v_users[2]) then
    raise exception 'Deleting an account erased its rating network history';
  end if;
  perform pg_temp.set_rating_actor(v_users[11], v_sessions[11]);
  perform pg_temp.expect_rating_network_error(format(
    'select public.upsert_teacher_review(%L,%L,1,1,1,%L,true)',
    'rating-network-contract', v_target, ''
  ), 'P0001', 'rating_network_account_limit');
  update internal.rating_write_audit set created_at = clock_timestamp() - interval '25 hours'
  where source_table = 'core.teacher_reviews'
    and target_key = jsonb_build_array('rating-network-contract', v_target) and ip_address = v_ip;
  perform public.upsert_teacher_review('rating-network-contract', v_target, 3, 3, 3, 'Next day', false);

  perform pg_temp.set_rating_actor(v_guest, null);
  perform public.set_user_preference('rating-network-private', '{"enabled":true}', null);
  perform public.delete_user_preference('rating-network-private');
  if exists (select 1 from internal.rating_write_audit where user_id = v_guest) then
    raise exception 'Private guest preferences consumed rating network quota';
  end if;
  perform pg_temp.set_rating_actor(v_users[12], null);
  perform public.upsert_teacher_review('rating-network-contract', 'SQL mock teacher', 4, 4, 4, 'Mock', false);
  if not exists (select 1 from internal.rating_write_audit
      where user_id = v_users[12] and ip_address is null and session_id is null
        and target_key = jsonb_build_array('rating-network-contract', 'SQL mock teacher')) then
    raise exception 'Privileged SQL fixture without a JWT session lost no-IP compatibility';
  end if;
end;
$$;

do $$
declare
  v_user uuid := extensions.gen_random_uuid();
  v_other_user uuid := extensions.gen_random_uuid();
  v_session uuid := extensions.gen_random_uuid();
  v_other_session uuid := extensions.gen_random_uuid();
  v_newer_session uuid := extensions.gen_random_uuid();
  v_expired_session uuid := extensions.gen_random_uuid();
  v_revoked_session uuid := extensions.gen_random_uuid();
  v_teacher uuid := extensions.gen_random_uuid();
  v_teacher_name text := 'Session teacher ' || extensions.gen_random_uuid()::text;
  v_claims text;
  v_sub text;
  v_role text;
  v_result jsonb;
  v_has_dispatch boolean := to_regprocedure('public.miniapp_teacher_reviews_dispatch(uuid,text,jsonb)') is not null;
begin
  if has_function_privilege('anon', 'public.miniapp_teacher_reviews_session_dispatch(uuid,uuid,text,jsonb)', 'EXECUTE')
    or has_function_privilege('authenticated', 'public.miniapp_teacher_reviews_session_dispatch(uuid,uuid,text,jsonb)', 'EXECUTE')
    or not has_function_privilege('service_role', 'public.miniapp_teacher_reviews_session_dispatch(uuid,uuid,text,jsonb)', 'EXECUTE') then
    raise exception 'Teacher session dispatch is outside its service-only boundary';
  end if;
  perform pg_temp.set_rating_actor(null, null, '');
  insert into auth.users(id, is_anonymous, created_at, email_confirmed_at) values
    (v_user, false, now() - interval '3 days', now() - interval '2 days'),
    (v_other_user, false, now() - interval '3 days', now() - interval '2 days');
  insert into auth.sessions(id, user_id, created_at, updated_at, not_after, ip) values
    (v_session, v_user, now() - interval '1 hour', now() - interval '1 hour', null, '192.0.2.80'),
    (v_other_session, v_other_user, now(), now(), null, '192.0.2.81'),
    (v_newer_session, v_user, now(), now(), null, '192.0.2.82'),
    (v_expired_session, v_user, now(), now(), now() - interval '1 minute', '192.0.2.83'),
    (v_revoked_session, v_user, now(), now(), null, '192.0.2.84');
  delete from auth.sessions where id = v_revoked_session;
  if v_has_dispatch then
    insert into core.user_academic_profiles(user_id, organization_id) values (v_user, 'mirea');
    insert into core.schedule_teachers(id, organization_id, full_name, normalized_name, identity_key)
    values (v_teacher, 'mirea', v_teacher_name, lower(v_teacher_name), v_teacher::text);
  end if;

  perform pg_temp.set_rating_actor(v_other_user, v_other_session, 'service_role');
  v_claims := current_setting('request.jwt.claims', true);
  v_sub := current_setting('request.jwt.claim.sub', true);
  v_role := current_setting('request.jwt.claim.role', true);
  execute 'set local role service_role';
  perform pg_temp.expect_rating_network_error(format(
    'select public.miniapp_teacher_reviews_session_dispatch(%L,%L,%L,%L)',
    v_user, v_other_session, 'state', '{}'
  ), '42501', 'rating_session_unavailable');
  perform pg_temp.expect_rating_network_error(format(
    'select public.miniapp_teacher_reviews_session_dispatch(%L,%L,%L,%L)',
    v_user, v_revoked_session, 'state', '{}'
  ), '42501', 'rating_session_unavailable');
  perform pg_temp.expect_rating_network_error(format(
    'select public.miniapp_teacher_reviews_session_dispatch(%L,%L,%L,%L)',
    v_user, v_expired_session, 'state', '{}'
  ), '42501', 'rating_session_unavailable');

  if v_has_dispatch then
    v_result := public.miniapp_teacher_reviews_session_dispatch(v_user, v_session, 'review',
      jsonb_build_object('id', v_teacher, 'clarity', 4, 'loyalty', 4, 'usefulness', 4,
        'body', 'Session contract', 'anonymous', false));
    if v_result ->> 'ok' is distinct from 'true' then
      raise exception 'Service session dispatch did not publish the rating';
    end if;
    if current_setting('request.jwt.claims', true) is distinct from v_claims
      or current_setting('request.jwt.claim.sub', true) is distinct from v_sub
      or current_setting('request.jwt.claim.role', true) is distinct from v_role then
      raise exception 'Successful session dispatch leaked its actor context';
    end if;
    begin
      perform public.miniapp_teacher_reviews_session_dispatch(v_user, v_session, 'contract-invalid-action', '{}');
      raise exception 'Invalid service action was accepted' using errcode = 'XX000';
    exception when sqlstate '22023' then null;
    end;
  else
    begin
      perform public.miniapp_teacher_reviews_session_dispatch(v_user, v_session, 'state', '{}');
      raise exception 'Absent teacher dispatcher was accepted' using errcode = 'XX000';
    exception when undefined_function then null;
    end;
  end if;
  if current_setting('request.jwt.claims', true) is distinct from v_claims
    or current_setting('request.jwt.claim.sub', true) is distinct from v_sub
    or current_setting('request.jwt.claim.role', true) is distinct from v_role then
    raise exception 'Rejected session dispatch leaked its actor context';
  end if;
  execute 'reset role';
  if v_has_dispatch and (
    (select count(*) from internal.rating_write_audit where user_id = v_user) <> 1
    or not exists (select 1 from internal.rating_write_audit
      where user_id = v_user and session_id = v_session and ip_address = '192.0.2.80'::inet
        and target_key = jsonb_build_array('mirea', v_teacher_name))
  ) then
    raise exception 'Service dispatch replaced its verified session with a newer session';
  end if;
end;
$$;

rollback;
