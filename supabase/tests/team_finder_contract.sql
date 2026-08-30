begin;

do $$
declare
  v_function text;
begin
  foreach v_function in array array[
    'app_api_v1.get_teams(text)',
    'app_api_v1.create_team(text,text,text,text,text[],integer,text,timestamptz,boolean)',
    'app_api_v1.apply_to_team(uuid,text,text,boolean)',
    'app_api_v1.get_team_applications(uuid)',
    'app_api_v1.act_on_team_application(uuid,text)',
    'app_api_v1.leave_team(uuid)',
    'app_api_v1.delete_team(uuid)',
    'app_api_v1.set_team_membership(uuid,boolean)',
    'app_api_v1.delete_team_application(uuid)'
  ] loop
    if has_function_privilege('anon', v_function, 'EXECUTE')
      or has_function_privilege('authenticated', v_function, 'EXECUTE')
      or not has_function_privilege('service_role', v_function, 'EXECUTE')
    then
      raise exception 'Internal team function privileges are invalid: %',
        v_function;
    end if;
  end loop;

  foreach v_function in array array[
    'public.get_teams(text)',
    'public.create_team(text,text,text,text,text[],integer,text,timestamptz,boolean)',
    'public.apply_to_team(uuid,text,text,boolean)',
    'public.get_team_applications(uuid)',
    'public.act_on_team_application(uuid,text)',
    'public.leave_team(uuid)',
    'public.delete_team(uuid)',
    'public.set_team_membership(uuid,boolean)',
    'public.delete_team_application(uuid)'
  ] loop
    if has_function_privilege('anon', v_function, 'EXECUTE')
      or not has_function_privilege('authenticated', v_function, 'EXECUTE')
      or not (
        select function.prosecdef
        from pg_proc function
        where function.oid = v_function::regprocedure
      )
    then
      raise exception 'Public team function privileges are invalid: %',
        v_function;
    end if;
  end loop;

  if has_table_privilege('authenticated', 'core.teams', 'INSERT')
    or has_table_privilege('authenticated', 'core.team_members', 'INSERT')
    or has_table_privilege(
      'authenticated',
      'core.team_applications',
      'UPDATE'
    )
  then
    raise exception 'Direct team mutation privileges are still available';
  end if;
  if position(
    'отклонён' in pg_get_functiondef(
      'internal.notify_team_application_result()'::regprocedure
    )
  ) = 0 or position(
    'выбрала другого' in pg_get_functiondef(
      'internal.notify_team_application_result()'::regprocedure
    )
  ) > 0 then
    raise exception 'Team rejection push copy is not truthful';
  end if;
end;
$$;

do $$
declare
  v_owner uuid := extensions.gen_random_uuid();
  v_applicant uuid := extensions.gen_random_uuid();
  v_second_applicant uuid := extensions.gen_random_uuid();
  v_outsider uuid := extensions.gen_random_uuid();
  v_poor_owner uuid := extensions.gen_random_uuid();
  v_team_id uuid;
  v_full_team_id uuid;
  v_lifecycle_team_id uuid;
  v_expired_team_id uuid;
  v_application_id uuid;
  v_second_application_id uuid;
  v_rows jsonb;
  v_balance integer;
  v_team_count integer;
begin
  insert into core.organizations (id, name)
  values
    ('team-test-a', 'Team Test A'),
    ('team-test-b', 'Team Test B');

  insert into auth.users (id)
  values
    (v_owner),
    (v_applicant),
    (v_second_applicant),
    (v_outsider),
    (v_poor_owner);

  insert into core.user_academic_profiles (
    user_id,
    organization_id,
    full_name,
    academic_group,
    handle
  )
  values
    (v_owner, 'team-test-a', 'Owner User', 'A-01', 'owner_user'),
    (v_applicant, 'team-test-a', 'Applicant User', 'A-02', 'applicant_user'),
    (
      v_second_applicant,
      'team-test-a',
      'Second User',
      'A-03',
      'second_user'
    ),
    (v_outsider, 'team-test-b', 'Outside User', 'B-01', 'outside_user'),
    (v_poor_owner, 'team-test-a', 'Poor Owner', 'A-04', 'poor_owner');

  insert into core.user_gamification_profiles (
    user_id,
    organization_id,
    shurikens
  )
  values
    (v_owner, 'team-test-a', 100),
    (v_poor_owner, 'team-test-a', 10);

  perform set_config('request.jwt.claim.role', 'authenticated', true);
  perform set_config('request.jwt.claim.sub', v_owner::text, true);
  v_team_id := app_api_v1.create_team(
    'team-test-a',
    'Campus Crew',
    '',
    'Build together',
    array['backend'],
    3,
    'project',
    now() + interval '7 days',
    false
  );

  if exists (
    select 1 from core.team_members member
    where member.team_id = v_team_id and member.user_id = v_owner
  ) then
    raise exception 'Team owner was duplicated as a member';
  end if;

  begin
    perform app_api_v1.apply_to_team(
      v_team_id,
      'backend',
      'Owner application',
      true
    );
    raise exception 'Owner applied to their own team';
  exception
    when insufficient_privilege then null;
  end;

  perform set_config('request.jwt.claim.sub', v_outsider::text, true);
  begin
    perform app_api_v1.get_teams('team-test-a');
    raise exception 'Foreign organization teams were enumerable';
  exception
    when insufficient_privilege then null;
  end;
  begin
    perform app_api_v1.create_team(
      'team-test-a',
      'Foreign Team',
      '',
      '',
      '{}',
      5,
      'project',
      null,
      false
    );
    raise exception 'A foreign organization team was created';
  exception
    when insufficient_privilege then null;
  end;
  begin
    perform app_api_v1.apply_to_team(
      v_team_id,
      'backend',
      'Cross tenant',
      true
    );
    raise exception 'A cross-organization application was created';
  exception
    when insufficient_privilege then null;
  end;

  perform set_config('request.jwt.claim.sub', v_applicant::text, true);
  v_application_id := app_api_v1.apply_to_team(
    v_team_id,
    'backend',
    'I can help',
    false
  );
  select app_api_v1.get_teams('team-test-a') into v_rows;
  if not (v_rows->0->>'hasApplied')::boolean
    or v_rows->0->>'myApplicationId' <> v_application_id::text
  then
    raise exception 'Applicant lifecycle state is missing from team rows';
  end if;
  begin
    perform app_api_v1.get_team_applications(v_team_id);
    raise exception 'Applicant listed owner-only applications';
  exception
    when insufficient_privilege then null;
  end;
  begin
    perform app_api_v1.act_on_team_application(v_application_id, 'accept');
    raise exception 'Applicant accepted their own application';
  exception
    when insufficient_privilege then null;
  end;

  perform set_config('request.jwt.claim.sub', v_owner::text, true);
  select app_api_v1.get_team_applications(v_team_id) into v_rows;
  if jsonb_array_length(v_rows) <> 1
    or v_rows->0->>'applicantId' <> v_applicant::text
    or v_rows->0->>'applicantName' <> 'Applicant User'
    or v_rows->0->>'applicantHandle' is not null
    or v_rows->0->>'applicantGroup' is not null
    or (v_rows->0->>'attachProfile')::boolean
  then
    raise exception 'Application privacy contract is invalid';
  end if;

  perform app_api_v1.act_on_team_application(v_application_id, 'accept');
  if not exists (
    select 1 from core.team_members member
    where member.team_id = v_team_id and member.user_id = v_applicant
  ) or (
    select application.status
    from core.team_applications application
    where application.id = v_application_id
  ) <> 'accepted' then
    raise exception 'Application acceptance was not atomic';
  end if;

  perform set_config('request.jwt.claim.sub', v_second_applicant::text, true);
  begin
    perform app_api_v1.set_team_membership(v_team_id, true);
    raise exception 'Membership bypass succeeded without acceptance';
  exception
    when insufficient_privilege then null;
  end;

  perform set_config('request.jwt.claim.sub', v_applicant::text, true);
  perform app_api_v1.leave_team(v_team_id);
  if exists (
    select 1 from core.team_members member
    where member.team_id = v_team_id and member.user_id = v_applicant
  ) then
    raise exception 'A member could not leave the team';
  end if;
  if (
    select application.status
    from core.team_applications application
    where application.id = v_application_id
  ) <> 'withdrawn' then
    raise exception 'Leaving did not close the accepted application';
  end if;
  begin
    perform app_api_v1.set_team_membership(v_team_id, true);
    raise exception 'Legacy membership restored a departed member';
  exception
    when insufficient_privilege then null;
  end;
  v_application_id := app_api_v1.apply_to_team(
    v_team_id,
    'backend',
    'Apply after leaving',
    true
  );
  if (
    select application.status
    from core.team_applications application
    where application.id = v_application_id
  ) <> 'pending' then
    raise exception 'A departed member could not apply again';
  end if;

  perform set_config('request.jwt.claim.sub', v_owner::text, true);
  v_full_team_id := app_api_v1.create_team(
    'team-test-a',
    'One Slot',
    '',
    '',
    array['backend'],
    2,
    'hackathon',
    null,
    false
  );
  perform set_config('request.jwt.claim.sub', v_applicant::text, true);
  v_application_id := app_api_v1.apply_to_team(
    v_full_team_id,
    'backend',
    '',
    true
  );
  perform set_config('request.jwt.claim.sub', v_owner::text, true);
  perform app_api_v1.act_on_team_application(v_application_id, 'accept');
  perform set_config('request.jwt.claim.sub', v_second_applicant::text, true);
  begin
    perform app_api_v1.apply_to_team(
      v_full_team_id,
      'backend',
      '',
      true
    );
    raise exception 'A full team accepted another application';
  exception
    when invalid_parameter_value then null;
  end;
  update core.user_academic_profiles profile
  set organization_id = 'team-test-b'
  where profile.user_id = v_applicant;
  if exists (
    select 1 from core.team_members member
    where member.team_id = v_full_team_id
      and member.user_id = v_applicant
  ) then
    raise exception 'Stale organization member still occupies a team slot';
  end if;
  v_second_application_id := app_api_v1.apply_to_team(
    v_full_team_id,
    'backend',
    'Freed slot',
    true
  );
  update core.user_academic_profiles profile
  set organization_id = 'team-test-a'
  where profile.user_id = v_applicant;

  perform set_config('request.jwt.claim.sub', v_owner::text, true);
  v_lifecycle_team_id := app_api_v1.create_team(
    'team-test-a',
    'Lifecycle Team',
    '',
    '',
    '{}',
    3,
    'study',
    null,
    false
  );
  perform set_config('request.jwt.claim.sub', v_second_applicant::text, true);
  v_second_application_id := app_api_v1.apply_to_team(
    v_lifecycle_team_id,
    '',
    'First try',
    true
  );
  perform set_config('request.jwt.claim.sub', v_owner::text, true);
  perform app_api_v1.delete_team_application(v_second_application_id);
  if (
    select application.status
    from core.team_applications application
    where application.id = v_second_application_id
  ) <> 'rejected' then
    raise exception 'Legacy owner delete did not preserve rejected history';
  end if;

  perform set_config('request.jwt.claim.sub', v_second_applicant::text, true);
  v_second_application_id := app_api_v1.apply_to_team(
    v_lifecycle_team_id,
    '',
    'Second try',
    true
  );
  perform app_api_v1.delete_team_application(v_second_application_id);
  if (
    select application.status
    from core.team_applications application
    where application.id = v_second_application_id
  ) <> 'withdrawn' then
    raise exception 'Legacy applicant delete did not preserve withdrawn history';
  end if;

  insert into core.teams (
    organization_id,
    owner_id,
    title,
    capacity,
    deadline_at
  ) values (
    'team-test-a',
    v_owner,
    'Expired Team',
    3,
    now() - interval '1 day'
  ) returning id into v_expired_team_id;
  perform set_config('request.jwt.claim.sub', v_applicant::text, true);
  begin
    perform app_api_v1.apply_to_team(v_expired_team_id, '', '', true);
    raise exception 'An expired team accepted an application';
  exception
    when insufficient_privilege then null;
  end;

  perform set_config('request.jwt.claim.sub', v_owner::text, true);
  perform app_api_v1.create_team(
    'team-test-a',
    'Boosted Team',
    '',
    '',
    '{}',
    5,
    'project',
    null,
    true
  );
  select profile.shurikens into v_balance
  from core.user_gamification_profiles profile
  where profile.user_id = v_owner
    and profile.organization_id = 'team-test-a';
  if v_balance <> 50 then
    raise exception 'Team boost did not charge exactly 50 shurikens';
  end if;

  select count(*) into v_team_count
  from core.teams team
  where team.owner_id = v_poor_owner;
  perform set_config('request.jwt.claim.sub', v_poor_owner::text, true);
  begin
    perform app_api_v1.create_team(
      'team-test-a',
      'Unaffordable Boost',
      '',
      '',
      '{}',
      5,
      'project',
      null,
      true
    );
    raise exception 'An unaffordable boost succeeded';
  exception
    when invalid_parameter_value then null;
  end;
  if (
    select count(*) from core.teams team
    where team.owner_id = v_poor_owner
  ) <> v_team_count then
    raise exception 'Failed boost left a partially created team';
  end if;

  perform set_config('request.jwt.claim.sub', v_owner::text, true);
  v_team_id := app_api_v1.create_team(
    'team-test-a',
    'Owner Migration Team',
    '',
    '',
    '{}',
    3,
    'project',
    null,
    false
  );
  perform set_config('request.jwt.claim.sub', v_second_applicant::text, true);
  v_application_id := app_api_v1.apply_to_team(
    v_team_id,
    '',
    'Pending before owner move',
    true
  );
  update core.user_academic_profiles profile
  set organization_id = 'team-test-b'
  where profile.user_id = v_owner;
  if (
    select team.status from core.teams team where team.id = v_team_id
  ) <> 'archived' or (
    select application.status
    from core.team_applications application
    where application.id = v_application_id
  ) <> 'withdrawn' then
    raise exception 'Owner organization change left an active team lifecycle';
  end if;
  perform set_config('request.jwt.claim.sub', v_owner::text, true);
  begin
    perform app_api_v1.get_team_applications(v_team_id);
    raise exception 'Former organization owner enumerated applications';
  exception
    when insufficient_privilege then null;
  end;
end;
$$;

rollback;
