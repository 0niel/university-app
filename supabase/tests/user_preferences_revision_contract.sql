begin;

do $$
declare
  v_user_a uuid := extensions.gen_random_uuid();
  v_user_b uuid := extensions.gen_random_uuid();
  v_entry jsonb;
  v_revision bigint;
  v_function text;
begin
  foreach v_function in array array[
    'app_api_v1.get_user_preferences()',
    'app_api_v1.get_user_preference(text)',
    'app_api_v1.set_user_preference(text,jsonb,bigint)',
    'app_api_v1.delete_user_preference(text)',
    'public.get_user_preferences()',
    'public.get_user_preference(text)',
    'public.set_user_preference(text,jsonb,bigint)',
    'public.delete_user_preference(text)'
  ] loop
    if has_function_privilege('anon', v_function, 'EXECUTE')
      or not has_function_privilege('authenticated', v_function, 'EXECUTE')
    then
      raise exception 'Preference function privileges are invalid: %',
        v_function;
    end if;
  end loop;

  insert into auth.users (id) values (v_user_a), (v_user_b);
  perform set_config('request.jwt.claim.role', 'authenticated', true);
  perform set_config('request.jwt.claim.sub', v_user_a::text, true);

  execute 'set local role authenticated';
  select public.set_user_preference(
    'contract', '{"value":"first"}'::jsonb, 0
  ) into v_revision;
  execute 'reset role';
  if v_revision <> 1 then
    raise exception 'Initial preference revision is invalid';
  end if;

  execute 'set local role authenticated';
  select public.set_user_preference(
    'contract', '{"value":"second"}'::jsonb, 1
  ) into v_revision;
  select public.get_user_preference('contract') into v_entry;
  execute 'reset role';
  if v_revision <> 2
    or v_entry->>'revision' <> '2'
    or v_entry->'value'->>'value' <> 'second'
  then
    raise exception 'Versioned preference update is invalid';
  end if;

  begin
    execute 'set local role authenticated';
    perform public.set_user_preference(
      'contract', '{"value":"stale"}'::jsonb, 1
    );
    execute 'reset role';
    raise exception 'Stale preference update was accepted';
  exception
    when sqlstate 'PT409' then
      execute 'reset role';
  end;

  execute 'set local role authenticated';
  select public.set_user_preference(
    'contract', '{"value":"legacy-compatible"}'::jsonb
  ) into v_revision;
  execute 'reset role';
  if v_revision <> 3 then
    raise exception 'Unconditional preference update did not increment';
  end if;

  perform set_config('request.jwt.claim.sub', v_user_b::text, true);
  execute 'set local role authenticated';
  select public.get_user_preference('contract') into v_entry;
  execute 'reset role';
  if v_entry is not null then
    raise exception 'Preference owner isolation failed';
  end if;
  begin
    execute 'set local role authenticated';
    perform public.set_user_preference(
      'missing', '{"value":"invalid"}'::jsonb, 3
    );
    execute 'reset role';
    raise exception 'Missing preference accepted a nonzero revision';
  exception
    when sqlstate 'PT409' then
      execute 'reset role';
  end;
end;
$$;

rollback;
