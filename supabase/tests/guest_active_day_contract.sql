begin;
set local statement_timeout = '10s';
set local lock_timeout = '3s';

do $$
declare
  v_uid uuid := extensions.gen_random_uuid();
  v_org text := 'guest-activity-' || v_uid::text;
  v_balance integer := 37;
  v_balance_after integer;
begin
  if (select prosecdef from pg_proc
      where oid = 'public.record_active_day()'::regprocedure) then
    raise exception 'Guest wrapper must run with caller privileges';
  end if;
  if not has_function_privilege('anon', 'public.record_active_day()', 'EXECUTE')
    or has_function_privilege('anon', 'app_api_v1.record_active_day()', 'EXECUTE')
    or has_function_privilege('anon', 'public.sync_gamification()', 'EXECUTE')
    or has_table_privilege('anon', 'core.user_active_days', 'INSERT,UPDATE,DELETE')
    or has_table_privilege('anon', 'core.user_gamification_profiles', 'INSERT,UPDATE,DELETE') then
    raise exception 'Guest activity privilege boundary is incorrect';
  end if;

  insert into core.organizations (id, name)
  values (v_org, 'Guest activity contract');
  insert into auth.users (id) values (v_uid);
  insert into core.user_academic_profiles (
    user_id, organization_id, full_name, academic_group
  ) values (v_uid, v_org, 'Activity User', 'ACT-01');
  insert into core.user_gamification_profiles (
    user_id, organization_id, shurikens
  ) values (v_uid, v_org, v_balance);

  perform set_config('request.jwt.claim.sub', '', true);
  perform set_config('request.jwt.claims', '{}', true);
  execute 'set local role anon';
  perform public.record_active_day();
  perform public.record_active_day();
  perform set_config('request.jwt.claim.sub', v_uid::text, true);
  perform public.record_active_day();
  begin
    perform app_api_v1.record_active_day();
    raise exception 'Guest called the internal activity writer';
  exception when insufficient_privilege then null;
  end;
  execute 'reset role';

  if exists (select 1 from core.user_active_days where user_id = v_uid) then
    raise exception 'Guest recording created authenticated activity';
  end if;

  execute 'set local role authenticated';
  perform public.record_active_day();
  perform public.record_active_day();
  perform set_config('request.jwt.claim.sub', '', true);
  begin
    perform public.record_active_day();
    raise exception 'Authenticated role without identity was accepted';
  exception when insufficient_privilege then null;
  end;
  execute 'reset role';

  select shurikens into v_balance_after from core.user_gamification_profiles
  where user_id = v_uid;
  if v_balance_after is distinct from v_balance then
    raise exception 'Recording activity changed the wallet balance';
  end if;
  if (select count(*) from core.user_active_days
      where user_id = v_uid
        and active_on = (now() at time zone 'UTC')::date) <> 1 then
    raise exception 'Recording activity is not idempotent';
  end if;
end;
$$;

rollback;
