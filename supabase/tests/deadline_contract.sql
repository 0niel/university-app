begin;

do $$
declare
  v_definition text;
  v_policy text;
begin
  if to_regprocedure(
    'public.create_deadline(text,text,text,timestamptz,text,text,boolean)'
  ) is null then
    raise exception 'Public deadline creation RPC is missing';
  end if;

  if has_function_privilege(
    'anon',
    'public.create_deadline(text,text,text,timestamptz,text,text,boolean)',
    'EXECUTE'
  ) then
    raise exception 'Anonymous role can create deadlines';
  end if;

  if not has_function_privilege(
    'authenticated',
    'public.create_deadline(text,text,text,timestamptz,text,text,boolean)',
    'EXECUTE'
  ) then
    raise exception 'Authenticated deadline creation contract is missing';
  end if;

  v_definition := pg_get_functiondef(
    'app_api_v1.create_deadline(text,text,text,timestamptz,text,text,boolean)'
      ::regprocedure
  );

  if position('v_source not in (''me'', ''group'')' in v_definition) = 0 then
    raise exception 'Client deadline source allowlist is missing';
  end if;
  if position('profile.organization_id = p_organization_id' in v_definition) = 0
  then
    raise exception 'Shared deadlines are not organization scoped';
  end if;
  if position('p_due_at <= now()' in v_definition) = 0 then
    raise exception 'Past deadlines are not rejected';
  end if;
  if position('core.enforce_rate_limit' in v_definition) = 0 then
    raise exception 'Deadline creation rate limit is missing';
  end if;
  if position('core.scheduled_reminders' in v_definition) = 0 then
    raise exception 'Deadline reminder scheduling is missing';
  end if;

  v_definition := pg_get_functiondef(
    'app_api_v1.get_deadlines(text)'::regprocedure
  );
  if position(
    'core.current_academic_group(p_organization_id)' in v_definition
  ) = 0 then
    raise exception 'Deadline reads are not organization scoped';
  end if;

  select policy.qual
  into v_policy
  from pg_policies policy
  where policy.schemaname = 'core'
    and policy.tablename = 'user_deadlines'
    and policy.policyname = 'own or group deadlines are readable';

  if v_policy is null
    or position('current_academic_group(organization_id)' in v_policy) = 0
  then
    raise exception 'Deadline read policy is not organization scoped';
  end if;
end;
$$;

do $$
declare
  v_user_a uuid := extensions.gen_random_uuid();
  v_user_b uuid := extensions.gen_random_uuid();
  v_rows jsonb;
begin
  insert into core.organizations (id, name)
  values
    ('deadline-test-a', 'Deadline Test A'),
    ('deadline-test-b', 'Deadline Test B');

  insert into auth.users (id)
  values (v_user_a), (v_user_b);

  insert into core.user_academic_profiles (
    user_id,
    organization_id,
    academic_group
  )
  values
    (v_user_a, 'deadline-test-a', 'IKBO-01'),
    (v_user_b, 'deadline-test-b', 'IKBO-01');

  perform set_config('request.jwt.claim.sub', v_user_a::text, true);
  perform set_config('request.jwt.claim.role', 'authenticated', true);
  perform app_api_v1.create_deadline(
    'deadline-test-a',
    'Shared deadline',
    '',
    now() + interval '7 days',
    'group',
    'medium',
    false
  );

  perform set_config('request.jwt.claim.sub', v_user_b::text, true);
  select app_api_v1.get_deadlines('deadline-test-a') into v_rows;
  if jsonb_array_length(v_rows) <> 0 then
    raise exception 'Cross-organization group deadline leaked';
  end if;

  begin
    perform app_api_v1.create_deadline(
      'deadline-test-b',
      'Forged professor deadline',
      '',
      now() + interval '7 days',
      'prof',
      'medium',
      false
    );
    raise exception 'Professor source was accepted from a student client';
  exception
    when others then
      if sqlerrm not like '%Unsupported client deadline source%' then
        raise;
      end if;
  end;
end;
$$;

rollback;
