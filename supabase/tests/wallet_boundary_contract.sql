begin;

do $$
declare
  v_role text;
  v_table text;
  v_function text;
  v_signature regprocedure;
begin
  foreach v_role in array array['anon', 'authenticated'] loop
    foreach v_table in array array[
      'core.user_gamification_profiles', 'core.shuriken_ledger',
      'core.user_quest_progress', 'core.user_active_days', 'core.user_badges'
    ] loop
      if has_table_privilege(v_role, v_table, 'INSERT,UPDATE,DELETE,TRUNCATE')
        or has_any_column_privilege(v_role, v_table, 'INSERT,UPDATE') then
        raise exception 'Client role % can mutate %', v_role, v_table;
      end if;
      if not has_table_privilege('authenticated', v_table, 'SELECT') then
        raise exception 'Authenticated read access was removed from %', v_table;
      end if;
    end loop;
    foreach v_function in array array[
      'core.apply_shuriken_delta(uuid,text,text,integer)',
      'core.apply_organization_shuriken_delta(uuid,text,text,text,integer)',
      'core.refresh_quest_progress(uuid)', 'core.evaluate_achievements(uuid)',
      'internal.run_gamification_sweep()'
    ] loop
      if has_function_privilege(v_role, v_function, 'EXECUTE') then
        raise exception 'Client role % can execute %', v_role, v_function;
      end if;
    end loop;
  end loop;

  if not has_function_privilege(
    'service_role', 'core.apply_shuriken_delta(uuid,text,text,integer)', 'EXECUTE'
  ) then
    raise exception 'Trusted wallet service access was removed';
  end if;

  foreach v_function in array array[
    'ensure_gamification_profile(text)', 'record_active_day()',
    'spend_shurikens(text,integer,text)',
    'increment_quest_progress(text,integer,date)', 'sync_gamification()'
  ] loop
    v_signature := ('app_api_v1.' || v_function)::regprocedure;
    if not (select prosecdef from pg_proc where oid = v_signature)
      or not exists (
        select 1 from pg_proc function_row,
          unnest(function_row.proconfig) setting
        where function_row.oid = v_signature
          and setting in ('search_path=', 'search_path=""')
      ) then
      raise exception 'Trusted RPC has unsafe execution context: %', v_function;
    end if;
    if has_function_privilege('anon', v_signature, 'EXECUTE')
      or (v_function <> 'record_active_day()' and
        has_function_privilege('anon', 'public.' || v_function, 'EXECUTE'))
      or not has_function_privilege('authenticated', v_signature, 'EXECUTE')
      or not has_function_privilege(
        'authenticated', 'public.' || v_function, 'EXECUTE'
      ) then
      raise exception 'RPC role contract is incorrect: %', v_function;
    end if;
  end loop;

  foreach v_function in array array[
    'app_api_v1.sync_gamification()',
    'app_api_v1.increment_quest_progress(text,integer,date)',
    'core.refresh_quest_progress(uuid)', 'internal.run_gamification_sweep()'
  ] loop
    if position('pg_advisory_xact_lock' in pg_get_functiondef(
      v_function::regprocedure
    )) = 0 then
      raise exception 'Reward computation is not serialized: %', v_function;
    end if;
  end loop;
end;
$$;

do $$
declare
  v_uid uuid := extensions.gen_random_uuid();
  v_other uuid := extensions.gen_random_uuid();
  v_new uuid := extensions.gen_random_uuid();
  v_org text := 'wallet-a-' || extensions.gen_random_uuid()::text;
  v_other_org text := 'wallet-b-' || extensions.gen_random_uuid()::text;
  v_today date := (now() at time zone 'UTC')::date;
  v_week date := date_trunc('week', now() at time zone 'UTC')::date;
  v_response jsonb;
  v_balance integer;
  v_reward integer;
  v_count integer;
  v_amount integer;
begin
  insert into core.organizations (id, name)
  values (v_org, 'Wallet Contract A'), (v_other_org, 'Wallet Contract B');
  insert into auth.users (id) values (v_uid), (v_other), (v_new);
  insert into core.user_academic_profiles (user_id, organization_id)
  values (v_uid, v_org), (v_other, v_other_org), (v_new, v_org);
  insert into core.user_gamification_profiles (
    user_id, organization_id, shurikens
  ) values (v_uid, v_org, 40), (v_other, v_org, 90);
  insert into core.lesson_reactions (
    user_id, subject_name, lesson_date, lesson_bells_number,
    reaction_type, created_at
  ) values (v_uid, 'Future reaction', v_today, 1, 'useful', now() + interval '1 day');
  select xp_reward into v_reward from core.quest_definitions
  where id = 'daily_reaction';
  if v_reward is null or v_reward <= 0 then
    raise exception 'Daily reaction reward fixture is unavailable';
  end if;

  perform set_config('request.jwt.claim.role', 'authenticated', true);
  perform set_config('request.jwt.claim.sub', v_uid::text, true);
  execute 'set local role authenticated';

  begin
    insert into core.user_gamification_profiles (user_id, organization_id, shurikens)
    values (v_uid, v_org, 1000000);
    raise exception 'Direct wallet creation was accepted';
  exception when insufficient_privilege then null;
  end;
  begin
    update core.user_gamification_profiles set shurikens = 1000000
    where user_id = v_uid;
    raise exception 'Direct wallet update was accepted';
  exception when insufficient_privilege then null;
  end;
  begin
    insert into core.shuriken_ledger (user_id, organization_id, title, amount)
    values (v_uid, v_org, 'Forged reward', 1000000);
    raise exception 'Direct ledger insertion was accepted';
  exception when insufficient_privilege then null;
  end;
  begin
    insert into core.user_active_days (user_id, active_on)
    values (v_uid, v_today - 20);
    raise exception 'Backdated activity was accepted';
  exception when insufficient_privilege then null;
  end;
  begin
    insert into core.user_quest_progress (
      user_id, quest_id, period_start, progress, is_completed
    ) values (v_uid, 'daily_reaction', v_today - 20, 1000000, true);
    raise exception 'Forged quest completion was accepted';
  exception when insufficient_privilege then null;
  end;
  begin
    perform core.apply_shuriken_delta(v_uid, '✨', 'Forged reward', 1000000);
    raise exception 'Direct generic delta was accepted';
  exception when insufficient_privilege then null;
  end;
  begin
    perform core.apply_organization_shuriken_delta(
      v_uid, v_org, '✨', 'Forged reward', 1000000
    );
    raise exception 'Direct organization delta was accepted';
  exception when insufficient_privilege then null;
  end;

  perform public.ensure_gamification_profile(v_org);
  perform public.ensure_gamification_profile(v_org);
  begin
    perform public.ensure_gamification_profile(v_other_org);
    raise exception 'Foreign organization profile was accepted';
  exception when insufficient_privilege then null;
  end;
  perform public.record_active_day();
  perform app_api_v1.record_active_day();
  select count(*) into v_count from core.user_active_days where user_id = v_uid;
  if v_count <> 1 then
    raise exception 'Activity recording is not idempotent';
  end if;

  v_response := public.increment_quest_progress(
    'daily_reaction', 2147483647, date '2000-01-01'
  );
  if (v_response ->> 'progress')::integer <> 0
    or (v_response ->> 'xpAwarded')::integer <> 0 then
    raise exception 'Client amount, date or future source fabricated progress';
  end if;
  perform app_api_v1.increment_quest_progress(
    'daily_reaction', -2147483648, v_today + 100
  );
  perform public.sync_gamification();
  select shurikens into v_balance from core.user_gamification_profiles
  where user_id = v_uid;
  if v_balance <> 40 then
    raise exception 'Unsupported progress request minted currency';
  end if;

  foreach v_amount in array array[0, -1, -2147483648, null::integer] loop
    begin
      perform public.spend_shurikens('Invalid debit', v_amount, '🎁');
      raise exception 'Invalid debit was accepted';
    exception when invalid_parameter_value then null;
    end;
  end loop;
  begin
    perform public.spend_shurikens('Insufficient debit', 1000, '🎁');
    raise exception 'Overdraft was accepted';
  exception when invalid_parameter_value then null;
  end;
  perform public.spend_shurikens('Authorized debit', 7, '🎁');
  select shurikens into v_balance from core.user_gamification_profiles
  where user_id = v_uid;
  select count(*) into v_count from core.shuriken_ledger where user_id = v_uid;
  if v_balance <> 33 or v_count <> 1 then
    raise exception 'Authorized debit did not atomically update wallet and ledger';
  end if;

  execute 'reset role';
  insert into core.lesson_reactions (
    user_id, subject_name, lesson_date, lesson_bells_number, reaction_type
  ) values (v_uid, 'Actual reaction', v_today, 2, 'useful');
  execute 'set local role authenticated';

  v_response := app_api_v1.increment_quest_progress(
    'daily_reaction', 2147483647, v_today + 100
  );
  if (v_response ->> 'progress')::integer <> 1
    or (v_response ->> 'xpAwarded')::integer <> v_reward
    or not (v_response ->> 'isCompleted')::boolean then
    raise exception 'Actual reaction did not earn its bounded reward';
  end if;
  v_response := public.increment_quest_progress('daily_reaction', null, null);
  if (v_response ->> 'xpAwarded')::integer <> 0 then
    raise exception 'Repeated quest synchronization repaid its reward';
  end if;
  perform public.sync_gamification();
  perform app_api_v1.sync_gamification();
  select shurikens into v_balance from core.user_gamification_profiles
  where user_id = v_uid;
  select count(*) into v_count from core.shuriken_ledger where user_id = v_uid;
  if v_balance <> 33 + v_reward or v_count <> 2 then
    raise exception 'Reward or ledger was duplicated during repeated sync';
  end if;
  if exists (
    select 1 from core.user_quest_progress progress
    join core.quest_definitions quest on quest.id = progress.quest_id
    where progress.user_id = v_uid and progress.period_start <>
      case when quest.period = 'daily' then v_today else v_week end
  ) then
    raise exception 'Client date created out-of-period progress';
  end if;
  begin
    delete from core.user_quest_progress where user_id = v_uid;
    raise exception 'Quest reward could be reset for replay';
  exception when insufficient_privilege then null;
  end;

  perform set_config('request.jwt.claim.sub', v_other::text, true);
  begin
    perform public.ensure_gamification_profile(v_other_org);
    raise exception 'Mismatched wallet organization was accepted';
  exception when insufficient_privilege then null;
  end;
  begin
    perform public.spend_shurikens('Foreign wallet debit', 1, '🎁');
    raise exception 'Mismatched wallet organization was debited';
  exception when insufficient_privilege then null;
  end;

  perform set_config('request.jwt.claim.sub', v_new::text, true);
  perform public.record_active_day();
  perform public.ensure_gamification_profile(v_org);
  select shurikens into v_balance from core.user_gamification_profiles
  where user_id = v_new;
  if v_balance <> 0 then
    raise exception 'New profile did not start with zero wallet balance';
  end if;
  perform set_config('request.jwt.claim.sub', '', true);
  begin
    perform public.record_active_day();
    raise exception 'Missing authentication was accepted';
  exception when insufficient_privilege then null;
  end;
  execute 'reset role';
  execute 'set local role anon';
  begin
    perform public.sync_gamification();
    raise exception 'Anonymous reward synchronization was accepted';
  exception when insufficient_privilege then null;
  end;
  execute 'reset role';

  update core.user_gamification_profiles
  set streak_days = 999, longest_streak = 0, last_active_date = v_today - 30
  where user_id = v_new;
  insert into core.user_active_days (user_id, active_on)
  values (v_new, v_today + 1);
  perform core.refresh_quest_progress(v_new);
  if exists (
    select 1 from core.user_quest_progress where user_id = v_new
      and quest_id = 'weekly_streak' and progress <> 1
  ) then
    raise exception 'Stale stored streak minted a weekly reward';
  end if;
  insert into core.user_active_days (user_id, active_on)
  select v_new, v_today - day_number from generate_series(1, 6) day_number;
  perform set_config('request.jwt.claim.sub', v_new::text, true);
  execute 'set local role authenticated';
  perform public.sync_gamification();
  if not exists (
    select 1 from core.user_quest_progress where user_id = v_new
      and quest_id = 'weekly_streak' and is_completed and progress = 7
  ) or not exists (
    select 1 from core.user_badges where user_id = v_new
      and badge_id = 'streak_7' and is_earned
  ) then
    raise exception 'Actual seven-day streak did not retain quest and badge rewards';
  end if;
  select shurikens into v_balance from core.user_gamification_profiles
  where user_id = v_new;
  perform public.sync_gamification();
  if (select shurikens from core.user_gamification_profiles
      where user_id = v_new) <> v_balance then
    raise exception 'Streak or badge reward was replayed';
  end if;
  execute 'reset role';
  execute 'set local role service_role';
  perform core.apply_shuriken_delta(v_uid, '✨', 'Trusted reward', 3);
  execute 'reset role';
  if (select shurikens from core.user_gamification_profiles
      where user_id = v_uid) <> 36 + v_reward then
    raise exception 'Trusted wallet delta compatibility was broken';
  end if;
end;
$$;

rollback;
