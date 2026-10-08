begin;

set local statement_timeout = '20s';
set local lock_timeout = '5s';

do $$
declare
  v_user_a uuid := extensions.gen_random_uuid();
  v_user_b uuid := extensions.gen_random_uuid();
  v_guest uuid := extensions.gen_random_uuid();
  v_profileless uuid := extensions.gen_random_uuid();
  v_teacher_a uuid;
  v_teacher_b uuid;
  v_result jsonb;
  v_academic_before jsonb;
  v_metadata_before jsonb;
  v_function text;
  v_count integer;
begin
  foreach v_function in array array[
    'public.get_account_persona(text,uuid)',
    'app_api_v1.get_account_persona(text,uuid)',
    'public.set_account_persona(text,uuid,text,text,bigint)',
    'app_api_v1.set_account_persona(text,uuid,text,text,bigint)',
    'user_private.set_account_persona(text,uuid,text,text,bigint)'
  ] loop
    if has_function_privilege('anon', v_function, 'EXECUTE')
      or not has_function_privilege('authenticated', v_function, 'EXECUTE') then
      raise exception 'Account persona privileges are invalid: %', v_function;
    end if;
  end loop;
  if not (select relation.relrowsecurity from pg_catalog.pg_class relation
          where relation.oid = 'user_private.account_personas'::regclass)
    or has_table_privilege('anon', 'user_private.account_personas', 'SELECT,INSERT,UPDATE,DELETE')
    or has_table_privilege('authenticated', 'user_private.account_personas', 'INSERT,UPDATE,DELETE')
    or (select procedure.prosecdef from pg_catalog.pg_proc procedure
        where procedure.oid = 'public.set_account_persona(text,uuid,text,text,bigint)'::regprocedure)
    or (select procedure.prosecdef from pg_catalog.pg_proc procedure
        where procedure.oid = 'app_api_v1.set_account_persona(text,uuid,text,text,bigint)'::regprocedure)
  then
    raise exception 'Account persona storage and API boundary are invalid';
  end if;

  insert into core.organizations (id, name) values
    ('account-persona-a', 'Account Persona A'),
    ('account-persona-b', 'Account Persona B');
  insert into auth.users (id, is_anonymous, raw_user_meta_data) values
    (v_user_a, false, '{"role":"teacher","verified":true}'),
    (v_user_b, false, '{}'),
    (v_guest, true, '{}'),
    (v_profileless, false, '{}');
  insert into core.user_academic_profiles (
    user_id, organization_id, academic_group, course, student_card_number
  ) values
    (v_user_a, 'account-persona-a', 'STUDENT-01', 3, 'card-123'),
    (v_user_b, 'account-persona-a', 'STUDENT-02', 2, 'card-456'),
    (v_guest, 'account-persona-a', null, null, null);
  insert into core.schedule_targets (
    organization_id, target_type, external_id, target_title, full_title, is_active
  ) values
    ('account-persona-a', 'teacher', 'teacher-first', 'Иванов И. И.', 'Иванов Иван Иванович', true)
  returning id into v_teacher_a;
  insert into core.schedule_targets (
    organization_id, target_type, external_id, target_title, full_title, is_active
  ) values
    ('account-persona-a', 'teacher', 'teacher-second', 'Иванов И. И.', 'Иванов Иван Иванович', true)
  returning id into v_teacher_b;
  insert into core.schedule_targets (
    organization_id, target_type, external_id, target_title, full_title, is_active
  ) values
    ('account-persona-a', 'group', 'group-target', 'GROUP-01', 'GROUP-01', true),
    ('account-persona-a', 'teacher', 'inactive-teacher', 'Inactive', 'Inactive Teacher', false),
    ('account-persona-b', 'teacher', 'other-organization', 'Other', 'Other Teacher', true);
  select to_jsonb(profile) into v_academic_before
  from core.user_academic_profiles profile where profile.user_id = v_user_a;
  select account.raw_user_meta_data into v_metadata_before
  from auth.users account where account.id = v_user_a;

  perform set_config('request.jwt.claim.role', 'authenticated', true);
  perform set_config('request.jwt.claim.sub', v_user_a::text, true);
  perform set_config('request.jwt.claims', jsonb_build_object(
    'sub', v_user_a, 'role', 'authenticated', 'is_anonymous', false,
    'user_metadata', jsonb_build_object('role', 'teacher', 'verified', true)
  )::text, true);
  execute 'set local role authenticated';
  v_result := public.get_account_persona('account-persona-a', v_user_a);
  if v_result is distinct from '{"role":"student","teacherId":null,"teacherName":null,"teacherAvailable":false,"revision":0}'::jsonb then
    raise exception 'Editable metadata changed the default account persona';
  end if;
  v_result := public.set_account_persona('account-persona-a', v_user_a, 'teacher', null, 0);
  if v_result->>'role' <> 'teacher' or v_result->>'revision' <> '1'
    or v_result->>'teacherId' is not null
    or (v_result->>'teacherAvailable')::boolean then
    raise exception 'Teacher setup without a selection is invalid';
  end if;
  v_result := public.set_account_persona('account-persona-a', v_user_a, 'teacher', 'teacher-first', 1);
  if v_result->>'teacherId' <> 'teacher-first' or v_result->>'revision' <> '2'
    or v_result->>'teacherName' <> 'Иванов Иван Иванович'
    or not (v_result->>'teacherAvailable')::boolean then
    raise exception 'Teacher selection did not persist the catalog identity';
  end if;
  execute 'reset role';
  if (select persona.teacher_target_id from user_private.account_personas persona
      where persona.user_id = v_user_a and persona.organization_id = 'account-persona-a')
      is distinct from v_teacher_a then
    raise exception 'Teacher external identifier resolved incorrectly';
  end if;

  begin
    execute 'set local role authenticated';
    perform public.set_account_persona('account-persona-a', v_user_a, 'student', null, 1);
    raise exception 'Stale account persona update was accepted';
  exception when sqlstate 'PT409' then
    execute 'reset role';
  end;
  begin
    execute 'set local role authenticated';
    perform public.set_account_persona('account-persona-a', v_user_b, 'teacher', null, 0);
    raise exception 'An expected-account mismatch was accepted';
  exception when insufficient_privilege then
    execute 'reset role';
  end;
  begin
    execute 'set local role authenticated';
    perform public.get_account_persona('account-persona-a', v_user_b);
    raise exception 'Another expected account was readable';
  exception when insufficient_privilege then
    execute 'reset role';
  end;
  begin
    execute 'set local role authenticated';
    perform public.set_account_persona('account-persona-b', v_user_a, 'teacher', 'other-organization', 0);
    raise exception 'Another organization accepted an account persona';
  exception when insufficient_privilege then
    execute 'reset role';
  end;
  begin
    execute 'set local role authenticated';
    perform public.get_account_persona('account-persona-b', v_user_a);
    raise exception 'Another organization account persona was readable';
  exception when insufficient_privilege then
    execute 'reset role';
  end;

  foreach v_function in array array['group-target', 'inactive-teacher', 'other-organization', 'missing-teacher'] loop
    begin
      execute 'set local role authenticated';
      perform public.set_account_persona('account-persona-a', v_user_a, 'teacher', v_function, 2);
      raise exception 'An invalid teacher selection was accepted: %', v_function;
    exception when invalid_parameter_value then
      execute 'reset role';
    end;
  end loop;
  begin
    execute 'set local role authenticated';
    perform public.set_account_persona('account-persona-a', v_user_a, 'admin', null, 2);
    raise exception 'An unsupported account role was accepted';
  exception when invalid_parameter_value then
    execute 'reset role';
  end;
  execute 'set local role authenticated';
  v_result := public.set_account_persona('account-persona-a', v_user_a, 'teacher', 'teacher-second', 2);
  execute 'reset role';
  if v_result->>'teacherId' <> 'teacher-second' or v_result->>'revision' <> '3'
    or (select persona.teacher_target_id from user_private.account_personas persona
        where persona.user_id = v_user_a and persona.organization_id = 'account-persona-a')
        is distinct from v_teacher_b then
    raise exception 'Same-name teachers were merged instead of selected by identity';
  end if;

  update core.schedule_targets set is_active = false where id = v_teacher_b;
  execute 'set local role authenticated';
  v_result := public.get_account_persona('account-persona-a', v_user_a);
  if (v_result->>'teacherAvailable')::boolean
    or v_result->>'teacherId' <> 'teacher-second' then
    raise exception 'Inactive teacher selection lost its repairable snapshot';
  end if;
  v_result := public.set_account_persona('account-persona-a', v_user_a, 'student', 'teacher-second', 3);
  execute 'reset role';
  if v_result->>'role' <> 'student' or v_result->>'teacherId' <> 'teacher-second'
    or v_result->>'revision' <> '4' then
    raise exception 'Student switch lost its dormant teacher selection';
  end if;
  delete from core.schedule_targets where id = v_teacher_b;
  execute 'set local role authenticated';
  v_result := public.get_account_persona('account-persona-a', v_user_a);
  if (v_result->>'teacherAvailable')::boolean
    or v_result->>'teacherId' <> 'teacher-second'
    or v_result->>'teacherName' <> 'Иванов Иван Иванович' then
    raise exception 'Deleted teacher selection lost its repairable snapshot';
  end if;
  v_result := public.set_account_persona('account-persona-a', v_user_a, 'teacher', null, 4);
  execute 'reset role';
  if v_result->>'teacherId' is not null or v_result->>'teacherName' is not null
    or v_result->>'revision' <> '5' then
    raise exception 'Clearing a teacher selection retained stale data';
  end if;
  if (select to_jsonb(profile) from core.user_academic_profiles profile
      where profile.user_id = v_user_a) is distinct from v_academic_before
    or (select account.raw_user_meta_data from auth.users account
        where account.id = v_user_a) is distinct from v_metadata_before then
    raise exception 'Personalization modified academic identity or authentication metadata';
  end if;

  perform set_config('request.jwt.claim.sub', v_user_b::text, true);
  execute 'set local role authenticated';
  v_result := public.get_account_persona('account-persona-a', v_user_b);
  select count(*) into v_count from user_private.account_personas;
  execute 'reset role';
  if v_result->>'role' <> 'student' or v_result->>'revision' <> '0' or v_count <> 0 then
    raise exception 'Account persona owner isolation failed';
  end if;
  begin
    execute 'set local role authenticated';
    perform public.set_account_persona('account-persona-a', v_user_b, 'teacher', null, 1);
    raise exception 'A missing persona accepted a nonzero expected revision';
  exception when sqlstate 'PT409' then
    execute 'reset role';
  end;

  perform set_config('request.jwt.claim.sub', v_guest::text, true);
  perform set_config('request.jwt.claims', jsonb_build_object(
    'sub', v_guest, 'role', 'authenticated', 'is_anonymous', true
  )::text, true);
  execute 'set local role authenticated';
  v_result := public.set_account_persona('account-persona-a', v_guest, 'teacher', 'teacher-first', 0);
  if v_result->>'teacherId' <> 'teacher-first' or v_result->>'revision' <> '1' then
    raise exception 'Private guest personalization was unavailable';
  end if;
  execute 'reset role';

  perform set_config('request.jwt.claim.sub', v_profileless::text, true);
  begin
    execute 'set local role authenticated';
    perform public.set_account_persona('account-persona-a', v_profileless, 'teacher', null, 0);
    raise exception 'A profileless account bypassed organization bootstrap';
  exception when insufficient_privilege then
    execute 'reset role';
  end;
  perform set_config('request.jwt.claim.sub', '', true);
  perform set_config('request.jwt.claims', '{}', true);
  begin
    execute 'set local role authenticated';
    perform public.get_account_persona('account-persona-a', v_user_a);
    raise exception 'A missing authenticated owner was accepted';
  exception when insufficient_privilege then
    execute 'reset role';
  end;
end;
$$;

rollback;
