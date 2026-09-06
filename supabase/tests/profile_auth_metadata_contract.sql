begin;

do $$
declare
  v_user_a uuid := gen_random_uuid();
  v_user_b uuid := gen_random_uuid();
  v_organization text;
  v_account jsonb;
  v_metadata jsonb;
  v_tuple tid;
begin
  if has_function_privilege('anon', 'internal.sync_academic_profile_auth_metadata()', 'EXECUTE')
    or has_function_privilege('authenticated', 'internal.sync_academic_profile_auth_metadata()', 'EXECUTE')
    or has_function_privilege('service_role', 'internal.sync_academic_profile_auth_metadata()', 'EXECUTE')
  then
    raise exception 'Internal metadata trigger is callable';
  end if;

  select id into strict v_organization from core.organizations limit 1;
  insert into auth.users (id, email, encrypted_password, raw_app_meta_data, raw_user_meta_data)
  values
    (v_user_a, 'profile-contract-a@example.invalid', 'unchanged-contract-password',
      '{"provider":"email","providers":["email"],"role":"unchanged"}',
      '{"avatar_url":"https://example.invalid/avatar.png","email_verified":true,"custom":{"keep":1}}'),
    (v_user_b, 'profile-contract-b@example.invalid', null, '{}',
      '{"name":"Provider Name","picture":"https://example.invalid/picture.png"}');
  select to_jsonb(account) - 'raw_user_meta_data' into v_account
  from auth.users account where id = v_user_a;

  perform set_config('request.jwt.claim.sub', v_user_a::text, true);
  execute 'set local role authenticated';
  insert into core.user_academic_profiles (user_id, organization_id, full_name)
  values (v_user_a, v_organization, '  Initial Name  ');
  execute 'reset role';
  select raw_user_meta_data into v_metadata from auth.users where id = v_user_a;
  if v_metadata is distinct from '{"avatar_url":"https://example.invalid/avatar.png","email_verified":true,"custom":{"keep":1},"display_name":"Initial Name","full_name":"Initial Name","name":"Initial Name"}'::jsonb then
    raise exception 'Profile insert did not synchronize aliases or changed unrelated metadata';
  end if;

  select ctid into v_tuple from auth.users where id = v_user_a;
  execute 'set local role authenticated';
  update core.user_academic_profiles set full_name = full_name where user_id = v_user_a;
  execute 'reset role';
  if (select ctid from auth.users where id = v_user_a) is distinct from v_tuple then
    raise exception 'Unchanged profile identity rewrote Auth';
  end if;

  perform set_config('request.jwt.claim.sub', v_user_b::text, true);
  execute 'set local role authenticated';
  insert into core.user_academic_profiles (user_id, organization_id)
  values (v_user_b, v_organization);
  perform public.upsert_user_academic_profile(v_organization, p_group => 'Contract Group');
  update core.user_academic_profiles set full_name = 'Wrong Account' where user_id = v_user_a;
  execute 'reset role';
  if (select raw_user_meta_data->>'full_name' from auth.users where id = v_user_a) <> 'Initial Name'
    or (select raw_user_meta_data->>'name' from auth.users where id = v_user_b) <> 'Provider Name'
  then
    raise exception 'Account isolation or initial provider metadata was lost';
  end if;

  perform set_config('request.jwt.claim.sub', v_user_a::text, true);
  execute 'set local role authenticated';
  update core.user_academic_profiles set full_name = 'Updated Name' where user_id = v_user_a;
  execute 'reset role';
  if not (select raw_user_meta_data @> '{"display_name":"Updated Name","full_name":"Updated Name","name":"Updated Name"}'::jsonb from auth.users where id = v_user_a) then
    raise exception 'Profile update left stale Auth names';
  end if;

  execute 'set local role authenticated';
  update core.user_academic_profiles set full_name = '  ' where user_id = v_user_a;
  execute 'reset role';
  if (select raw_user_meta_data from auth.users where id = v_user_a)
    is distinct from '{"avatar_url":"https://example.invalid/avatar.png","email_verified":true,"custom":{"keep":1}}'::jsonb
  then
    raise exception 'Clearing a profile name left aliases or deleted other metadata';
  end if;
  if (select to_jsonb(account) - 'raw_user_meta_data' from auth.users account where id = v_user_a)
    is distinct from v_account
  then
    raise exception 'Identity sync changed credentials, account state or authorization metadata';
  end if;

  execute 'set local role anon';
  begin
    update core.user_academic_profiles set full_name = 'Anonymous Edit' where user_id = v_user_a;
    if found then
      raise exception 'Anonymous profile edit succeeded';
    end if;
  exception when insufficient_privilege then
    null;
  end;
  execute 'reset role';
end;
$$;

rollback;
