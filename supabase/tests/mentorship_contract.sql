begin;

do $$
declare
  v_function text;
begin
  foreach v_function in array array[
    'app_api_v1.get_mentors(text)',
    'app_api_v1.upsert_mentor_profile(text,text[],text,text,text[],integer)',
    'app_api_v1.delete_mentor_profile(text)',
    'app_api_v1.delete_mentor_profile()',
    'app_api_v1.create_mentor_request(text,uuid,text,text,text)',
    'app_api_v1.get_my_mentor_requests(text)',
    'app_api_v1.act_on_mentor_request(uuid,text)',
    'app_api_v1.delete_mentor_request(uuid)'
  ] loop
    if has_function_privilege('anon', v_function, 'EXECUTE') then
      raise exception 'Anonymous role can execute %', v_function;
    end if;
    if not has_function_privilege('authenticated', v_function, 'EXECUTE') then
      raise exception 'Authenticated contract is missing for %', v_function;
    end if;
  end loop;

  if to_regprocedure('public.delete_mentor_request(uuid)') is null
    or has_function_privilege(
      'anon',
      'public.delete_mentor_request(uuid)',
      'EXECUTE'
    )
  then
    raise exception 'Safe legacy mentor request compatibility is missing';
  end if;
  if to_regprocedure('public.act_on_mentor_request(uuid,text)') is null then
    raise exception 'Mentor request lifecycle RPC is missing';
  end if;
end;
$$;

do $$
declare
  v_mentor uuid := extensions.gen_random_uuid();
  v_requester uuid := extensions.gen_random_uuid();
  v_outsider uuid := extensions.gen_random_uuid();
  v_poor_requester uuid := extensions.gen_random_uuid();
  v_tenant_mentor uuid := extensions.gen_random_uuid();
  v_tenant_requester uuid := extensions.gen_random_uuid();
  v_request_id uuid;
  v_secondary_request_id uuid;
  v_rows jsonb;
  v_status text;
  v_mentor_balance integer;
  v_requester_balance integer;
begin
  insert into core.organizations (id, name)
  values
    ('mentor-test-a', 'Mentor Test A'),
    ('mentor-test-b', 'Mentor Test B');

  insert into auth.users (id)
  values
    (v_mentor),
    (v_requester),
    (v_outsider),
    (v_poor_requester),
    (v_tenant_mentor),
    (v_tenant_requester);

  insert into core.user_academic_profiles (
    user_id,
    organization_id,
    full_name,
    academic_group,
    handle
  )
  values
    (v_mentor, 'mentor-test-a', 'Mentor User', 'A-01', 'mentor_user'),
    (v_requester, 'mentor-test-a', 'Request User', 'A-01', 'request_user'),
    (v_outsider, 'mentor-test-b', 'Outside User', 'B-01', 'outside_user'),
    (
      v_poor_requester,
      'mentor-test-a',
      'Poor Requester',
      'A-01',
      'poor_requester'
    ),
    (
      v_tenant_mentor,
      'mentor-test-b',
      'Tenant Mentor',
      'B-01',
      'tenant_mentor'
    ),
    (
      v_tenant_requester,
      'mentor-test-b',
      'Tenant Requester',
      'B-01',
      'tenant_requester'
    );

  perform set_config('request.jwt.claim.role', 'authenticated', true);
  perform set_config('request.jwt.claim.sub', v_mentor::text, true);
  perform app_api_v1.upsert_mentor_profile(
    'mentor-test-a',
    array['python'],
    'I can help',
    'course4',
    array['chat'],
    20
  );

  perform set_config('request.jwt.claim.sub', v_outsider::text, true);
  begin
    perform app_api_v1.get_mentors('mentor-test-a');
    raise exception 'Foreign organization mentors were enumerable';
  exception
    when insufficient_privilege then null;
  end;
  begin
    perform app_api_v1.create_mentor_request(
      'mentor-test-a',
      v_mentor,
      'python',
      'week',
      'Cross-tenant spam'
    );
    raise exception 'Cross-organization mentor request was created';
  exception
    when insufficient_privilege then null;
  end;

  perform set_config('request.jwt.claim.sub', v_requester::text, true);
  v_request_id := app_api_v1.create_mentor_request(
    'mentor-test-a',
    v_mentor,
    'python',
    'week',
    'Please help'
  );
  begin
    perform app_api_v1.create_mentor_request(
      'mentor-test-a',
      v_mentor,
      'python',
      'week',
      'Duplicate'
    );
    raise exception 'Duplicate active mentor request was created';
  exception
    when unique_violation then null;
  end;

  select app_api_v1.get_my_mentor_requests('mentor-test-a') into v_rows;
  if jsonb_array_length(v_rows) <> 1
    or (v_rows->0->>'isIncoming')::boolean
    or v_rows->0->>'status' <> 'pending'
    or (v_rows->0->>'price')::integer <> 20
  then
    raise exception 'Outgoing mentor request contract is invalid';
  end if;

  insert into core.user_gamification_profiles (
    user_id,
    organization_id,
    shurikens
  )
  values
    (v_mentor, 'mentor-test-a', 0),
    (v_requester, 'mentor-test-a', 50),
    (v_poor_requester, 'mentor-test-a', 10),
    (v_tenant_requester, 'mentor-test-a', 50);

  begin
    perform app_api_v1.act_on_mentor_request(v_request_id, 'accept');
    raise exception 'Requester accepted their own request';
  exception
    when invalid_parameter_value then null;
  end;

  perform set_config('request.jwt.claim.sub', v_mentor::text, true);
  perform app_api_v1.act_on_mentor_request(v_request_id, 'accept');
  select profile.shurikens
  into v_requester_balance
  from core.user_gamification_profiles profile
  where profile.user_id = v_requester;
  if v_requester_balance <> 30 then
    raise exception 'Mentorship price was not reserved on acceptance';
  end if;

  perform set_config('request.jwt.claim.sub', v_outsider::text, true);
  begin
    perform app_api_v1.act_on_mentor_request(
      v_request_id,
      'confirm_complete'
    );
    raise exception 'Outsider changed a mentor request';
  exception
    when insufficient_privilege then null;
  end;

  perform set_config('request.jwt.claim.sub', v_requester::text, true);
  perform app_api_v1.act_on_mentor_request(
    v_request_id,
    'confirm_complete'
  );
  select request.status
  into v_status
  from core.mentor_requests request
  where request.id = v_request_id;
  if v_status <> 'completion_pending' then
    raise exception 'First completion confirmation completed the session';
  end if;

  perform set_config('request.jwt.claim.sub', v_mentor::text, true);
  perform app_api_v1.act_on_mentor_request(
    v_request_id,
    'confirm_complete'
  );

  select request.status
  into v_status
  from core.mentor_requests request
  where request.id = v_request_id;
  select profile.shurikens
  into v_mentor_balance
  from core.user_gamification_profiles profile
  where profile.user_id = v_mentor;
  select profile.shurikens
  into v_requester_balance
  from core.user_gamification_profiles profile
  where profile.user_id = v_requester;

  if v_status <> 'completed'
    or v_mentor_balance <> 100
    or v_requester_balance <> 30
  then
    raise exception 'Mentorship settlement is not atomic or exact';
  end if;
  if (
    select profile.sessions_count
    from core.mentor_profiles profile
    where profile.user_id = v_mentor
  ) <> 1 then
    raise exception 'Completed mentorship session was not counted';
  end if;
  if not exists (
    select 1
    from core.user_badges badge
    where badge.user_id = v_mentor
      and badge.badge_id = 'mentor'
      and badge.is_earned
  ) then
    raise exception 'Mentor badge was not awarded';
  end if;

  begin
    perform app_api_v1.act_on_mentor_request(
      v_request_id,
      'confirm_complete'
    );
    raise exception 'Completed session accepted another confirmation';
  exception
    when invalid_parameter_value then null;
  end;
  if (
    select shurikens
    from core.user_gamification_profiles
    where user_id = v_mentor
  ) <> 100 then
    raise exception 'Mentorship reward was applied more than once';
  end if;

  perform set_config('request.jwt.claim.sub', v_requester::text, true);
  v_secondary_request_id := app_api_v1.create_mentor_request(
    'mentor-test-a',
    v_mentor,
    'python',
    'tomorrow',
    'May need to cancel'
  );
  perform set_config('request.jwt.claim.sub', v_mentor::text, true);
  perform app_api_v1.act_on_mentor_request(
    v_secondary_request_id,
    'accept'
  );
  perform app_api_v1.act_on_mentor_request(
    v_secondary_request_id,
    'cancel'
  );
  if (
    select request.status
    from core.mentor_requests request
    where request.id = v_secondary_request_id
  ) <> 'cancelled' or (
    select profile.shurikens
    from core.user_gamification_profiles profile
    where profile.user_id = v_requester
  ) <> 30 then
    raise exception 'Accepted cancellation did not release the escrow';
  end if;

  perform set_config('request.jwt.claim.sub', v_requester::text, true);
  v_secondary_request_id := app_api_v1.create_mentor_request(
    'mentor-test-a',
    v_mentor,
    'python',
    'tomorrow',
    'Completion cancellation guard'
  );
  perform set_config('request.jwt.claim.sub', v_mentor::text, true);
  perform app_api_v1.act_on_mentor_request(v_secondary_request_id, 'accept');
  perform app_api_v1.act_on_mentor_request(
    v_secondary_request_id,
    'confirm_complete'
  );
  perform set_config('request.jwt.claim.sub', v_requester::text, true);
  begin
    perform app_api_v1.act_on_mentor_request(v_secondary_request_id, 'cancel');
    raise exception 'Unconfirmed participant escaped a claimed session';
  exception
    when invalid_parameter_value then null;
  end;
  perform set_config('request.jwt.claim.sub', v_mentor::text, true);
  perform app_api_v1.delete_mentor_request(v_secondary_request_id);
  if (
    select profile.shurikens
    from core.user_gamification_profiles profile
    where profile.user_id = v_requester
  ) <> 30 then
    raise exception 'Confirmation retraction did not release the escrow';
  end if;

  perform set_config('request.jwt.claim.sub', v_requester::text, true);
  v_secondary_request_id := app_api_v1.create_mentor_request(
    'mentor-test-a',
    v_mentor,
    'python',
    'week',
    'Pair is unlocked'
  );
  perform app_api_v1.act_on_mentor_request(v_secondary_request_id, 'cancel');

  perform set_config('request.jwt.claim.sub', v_poor_requester::text, true);
  v_secondary_request_id := app_api_v1.create_mentor_request(
    'mentor-test-a',
    v_mentor,
    'python',
    'week',
    'Insufficient balance'
  );
  perform set_config('request.jwt.claim.sub', v_mentor::text, true);
  begin
    perform app_api_v1.act_on_mentor_request(v_secondary_request_id, 'accept');
    raise exception 'Paid request was accepted without sufficient balance';
  exception
    when invalid_parameter_value then null;
  end;
  if (
    select request.status
    from core.mentor_requests request
    where request.id = v_secondary_request_id
  ) <> 'pending' or (
    select profile.shurikens
    from core.user_gamification_profiles profile
    where profile.user_id = v_poor_requester
  ) <> 10 then
    raise exception 'Failed reservation changed request or balance';
  end if;
  perform set_config('request.jwt.claim.sub', v_poor_requester::text, true);
  perform app_api_v1.act_on_mentor_request(v_secondary_request_id, 'cancel');

  perform set_config('request.jwt.claim.sub', v_tenant_mentor::text, true);
  perform app_api_v1.upsert_mentor_profile(
    'mentor-test-b',
    array['python'],
    'Tenant-safe mentor',
    'course3',
    array['chat'],
    20
  );
  perform set_config('request.jwt.claim.sub', v_tenant_requester::text, true);
  v_secondary_request_id := app_api_v1.create_mentor_request(
    'mentor-test-b',
    v_tenant_mentor,
    'python',
    'week',
    'Wrong-wallet guard'
  );
  perform set_config('request.jwt.claim.sub', v_tenant_mentor::text, true);
  begin
    perform app_api_v1.act_on_mentor_request(v_secondary_request_id, 'accept');
    raise exception 'Cross-organization wallet was charged';
  exception
    when insufficient_privilege then null;
  end;
  if (
    select request.status
    from core.mentor_requests request
    where request.id = v_secondary_request_id
  ) <> 'pending' or (
    select profile.shurikens
    from core.user_gamification_profiles profile
    where profile.user_id = v_tenant_requester
      and profile.organization_id = 'mentor-test-a'
  ) <> 50 then
    raise exception 'Cross-organization settlement guard is not atomic';
  end if;
  perform set_config('request.jwt.claim.sub', v_tenant_requester::text, true);
  perform app_api_v1.act_on_mentor_request(v_secondary_request_id, 'cancel');

  update core.user_academic_profiles
  set organization_id = 'mentor-test-a'
  where user_id = v_tenant_mentor;
  perform set_config('request.jwt.claim.sub', v_tenant_requester::text, true);
  select app_api_v1.get_mentors('mentor-test-b') into v_rows;
  if exists (
    select 1
    from jsonb_array_elements(v_rows) item
    where item->>'userId' = v_tenant_mentor::text
  ) then
    raise exception 'Stale mentor profile remained discoverable';
  end if;
  begin
    perform app_api_v1.create_mentor_request(
      'mentor-test-b',
      v_tenant_mentor,
      'python',
      'week',
      'Stale profile request'
    );
    raise exception 'Stale mentor profile accepted a request';
  exception
    when insufficient_privilege then null;
  end;
  perform set_config('request.jwt.claim.sub', v_tenant_mentor::text, true);
  perform app_api_v1.upsert_mentor_profile(
    'mentor-test-a',
    array['design'],
    'Second university profile',
    'master',
    array['online'],
    0
  );
  if (
    select count(*)
    from core.mentor_profiles profile
    where profile.user_id = v_tenant_mentor
  ) <> 2 then
    raise exception 'Mentor profile moved between organizations';
  end if;
  perform app_api_v1.delete_mentor_profile();
  if not exists (
    select 1
    from core.mentor_profiles profile
    where profile.user_id = v_tenant_mentor
      and profile.organization_id = 'mentor-test-b'
      and profile.is_active
  ) then
    raise exception 'Deleting one tenant deactivated another tenant profile';
  end if;

  perform set_config('request.jwt.claim.sub', v_mentor::text, true);
  perform app_api_v1.delete_mentor_profile('mentor-test-a');
  perform set_config('request.jwt.claim.sub', v_requester::text, true);
  begin
    perform app_api_v1.create_mentor_request(
      'mentor-test-a',
      v_mentor,
      'python',
      'week',
      'Inactive mentor'
    );
    raise exception 'Inactive mentor received a new request';
  exception
    when insufficient_privilege then null;
  end;
end;
$$;

rollback;
