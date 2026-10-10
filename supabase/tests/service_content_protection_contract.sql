begin;
set local statement_timeout = '30s';

do $$
declare
  v_user uuid := extensions.gen_random_uuid();
  v_guest uuid := extensions.gen_random_uuid();
  v_fresh uuid := extensions.gen_random_uuid();
  v_result jsonb;
  v_target regprocedure;
  v_signature text;
  v_before bigint;
begin
  insert into auth.users(id, is_anonymous, created_at, email_confirmed_at) values
    (v_user, false, clock_timestamp() - interval '2 days', clock_timestamp() - interval '2 days'),
    (v_guest, true, clock_timestamp() - interval '2 days', null),
    (v_fresh, false, clock_timestamp(), clock_timestamp());

  if has_function_privilege('authenticated', 'internal.enforce_miniapp_action(uuid,text,text,jsonb)', 'EXECUTE')
    or has_function_privilege('anon', 'internal.enforce_miniapp_action(uuid,text,text,jsonb)', 'EXECUTE')
    or has_function_privilege('authenticated', 'public.record_mini_app_request(uuid,text,text,text,text,text,text,text)', 'EXECUTE')
    or has_table_privilege('service_role', 'internal.mini_app_request_audit', 'SELECT,INSERT,UPDATE,DELETE') then
    raise exception 'Request audit or action guard is reachable outside its trusted boundary';
  end if;
  perform internal.enforce_miniapp_action(v_guest, 'teacher-reviews', 'state', '{}');
  begin
    perform internal.enforce_miniapp_action(v_guest, 'learning-roadmap', 'save_note', '{}');
    raise exception 'Guest account created a private roadmap note' using errcode = 'XX000';
  exception when insufficient_privilege then null;
  end;
  perform internal.enforce_miniapp_action(v_fresh, 'learning-roadmap', 'save_note', '{}');
  perform internal.enforce_miniapp_action(v_guest, 'teacher-reviews', 'settings', '{}');
  perform internal.enforce_miniapp_action(v_guest, 'student-discounts', 'favorite', '{"saved":false}');
  begin
    perform internal.enforce_miniapp_action(v_guest, 'student-discounts', 'favorite', '{"saved":true}');
    raise exception 'Guest account created a discount favorite' using errcode = 'XX000';
  exception when insufficient_privilege then null;
  end;
  begin
    perform internal.enforce_miniapp_action(v_guest, 'queue', 'join', '{}');
    raise exception 'Guest account joined a dynamic queue' using errcode = 'XX000';
  exception when insufficient_privilege then null;
  end;
  begin
    perform internal.enforce_miniapp_action(v_guest, 'teacher-reviews', 'follow', '{"follow":true}');
    raise exception 'Guest account created a teacher follow' using errcode = 'XX000';
  exception when insufficient_privilege then null;
  end;
  perform internal.enforce_miniapp_action(v_guest, 'teacher-reviews', 'vote', '{"helpful":false}');
  begin
    perform internal.enforce_miniapp_action(v_guest, 'teacher-reviews', 'vote', '{"helpful":true}');
    raise exception 'Guest account added a helpful vote' using errcode = 'XX000';
  exception when insufficient_privilege then null;
  end;
  begin
    perform internal.enforce_miniapp_action(v_fresh, 'teacher-reviews', 'review', '{}');
    raise exception 'Newly confirmed account published a rating' using errcode = 'XX000';
  exception when insufficient_privilege then null;
  end;
  perform internal.enforce_miniapp_action(v_user, 'teacher-reviews', 'review', '{}');

  for i in 1..5 loop
    perform internal.enforce_miniapp_action(v_user, 'iskra', 'reserve_photo', '{}');
    perform internal.enforce_miniapp_action(v_user, 'iskra', 'cancel_photo', '{}');
  end loop;
  begin
    perform internal.enforce_miniapp_action(v_user, 'iskra', 'reserve_photo', '{}');
    raise exception 'Refunding a photo reservation reset the attempts budget' using errcode = 'XX000';
  exception when sqlstate 'P0001' then null;
  end;

  foreach v_signature in array array[
    'miniapp_teacher_reviews.dispatch(uuid,text,jsonb)',
    'miniapp_iskra.dispatch(uuid,text,jsonb)',
    'miniapp_queue.dispatch(uuid,text,jsonb)',
    'miniapp_student_discounts.dispatch(uuid,text,jsonb)',
    'public.miniapp_learning_roadmap(uuid,text,jsonb)'
  ] loop
    v_target := to_regprocedure(v_signature);
    if v_target is not null and position('internal.enforce_miniapp_action' in pg_get_functiondef(v_target)) = 0 then
      raise exception 'Service dispatch bypasses the actor guard: %', v_signature;
    end if;
  end loop;

  v_result := public.record_mini_app_request(v_user, 'mirea', 'teacher-reviews', 'api', '/api/vote', 'POST', '192.0.2.19', 'contract-agent');
  if not (v_result ->> 'allowed')::boolean then raise exception 'Established user request rejected'; end if;
  insert into internal.mini_app_request_audit(user_id, organization_id, slug, kind, path, method, ip_address, allowed)
  select v_user, 'mirea', 'teacher-reviews', 'api', '/api/vote', 'POST', '192.0.2.19', true
  from generate_series(1, 299);
  v_result := public.record_mini_app_request(v_guest, 'mirea', 'teacher-reviews', 'api', '/api/vote', 'POST', '192.0.2.19', 'contract-agent');
  if v_result ->> 'reason' <> 'rate_limited' then raise exception 'New account bypassed network request limit'; end if;
  if not exists(select from internal.mini_app_request_audit where user_id = v_guest and reason = 'rate_limited' and not allowed) then
    raise exception 'Rejected network request was not recorded';
  end if;
  v_result := public.record_mini_app_request(v_guest, 'mirea', 'teacher-reviews', 'screen', '/', 'GET', '192.0.2.19', 'contract-agent');
  if not (v_result ->> 'allowed')::boolean then raise exception 'Shared network quota blocked guest screen reads'; end if;

  select count(*) into v_before from internal.mini_app_request_audit where user_id = v_guest;
  insert into internal.mini_app_request_audit(user_id, organization_id, slug, kind, path, method, allowed)
  select v_guest, 'mirea', 'teacher-reviews', 'screen', '/', 'GET', true
  from generate_series(1, 180 - v_before::integer);
  for i in 1..20 loop
    v_result := public.record_mini_app_request(v_guest, 'mirea', 'teacher-reviews', 'screen', '/', 'GET', null, null);
    if v_result ->> 'reason' <> 'rate_limited' then raise exception 'Screen actor quota bypassed'; end if;
  end loop;
  if (select count(*) from internal.mini_app_request_audit where user_id = v_guest) <> 180 then
    raise exception 'Rejected screen traffic caused unbounded audit growth';
  end if;

  insert into internal.mini_app_request_audit(user_id, organization_id, slug, kind, path, method, ip_address, allowed)
  select extensions.gen_random_uuid(), 'mirea', 'teacher-reviews', 'screen', '/', 'GET', '192.0.2.20', false
  from generate_series(1, 600);
  select count(*) into v_before from internal.mini_app_request_audit;
  v_result := public.record_mini_app_request(v_fresh, 'mirea', 'teacher-reviews', 'api', '/api/vote', 'POST', '192.0.2.20', null);
  if v_result ->> 'reason' <> 'rate_limited' or (select count(*)from internal.mini_app_request_audit) <> v_before then
    raise exception 'Cross-account rejected traffic caused unbounded audit growth';
  end if;
  v_result := public.record_mini_app_request(v_fresh, 'mirea', 'teacher-reviews', 'screen', '/', 'GET', '192.0.2.20', null);
  if not (v_result ->> 'allowed')::boolean then raise exception 'Audit cap blocked shared network screen reads'; end if;

  update auth.users set banned_until = clock_timestamp() + interval '1 day' where id = v_user;
  begin
    perform internal.enforce_miniapp_action(v_user, 'teacher-reviews', 'state', '{}');
    raise exception 'Banned account reached service content' using errcode = 'XX000';
  exception when insufficient_privilege then null;
  end;
  v_result := public.record_mini_app_request(v_user, 'mirea', 'teacher-reviews', 'screen', '/', 'GET', null, null);
  if v_result ->> 'reason' <> 'account_unavailable' then raise exception 'Banned proxy request accepted'; end if;
  if to_regprocedure('miniapp_iskra.dispatch(uuid,text,jsonb)') is not null then
    perform miniapp_iskra.dispatch(null, 'cleanup_results', '{"items":[]}');
  end if;
end;
$$;

rollback;
