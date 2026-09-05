begin;

do $$
declare
  v_user_a uuid := extensions.gen_random_uuid();
  v_user_b uuid := extensions.gen_random_uuid();
  v_banner uuid;
  v_rows jsonb;
  v_until timestamptz := now() + interval '2 days';
begin
  if has_table_privilege('anon', 'core.promo_banner_dismissals', 'SELECT,INSERT,UPDATE,DELETE')
    or has_table_privilege('authenticated', 'core.promo_banner_dismissals', 'SELECT,INSERT,UPDATE,DELETE')
    or has_function_privilege('anon', 'public.get_promo_banner_dismissals(uuid)', 'EXECUTE')
    or has_function_privilege('anon', 'public.save_promo_banner_dismissal(uuid,uuid,integer,boolean,timestamptz)', 'EXECUTE')
    or has_function_privilege('anon', 'app_api_v1.get_promo_banner_dismissals(uuid)', 'EXECUTE')
    or has_function_privilege('anon', 'app_api_v1.save_promo_banner_dismissal(uuid,uuid,integer,boolean,timestamptz)', 'EXECUTE')
    or (select prosecdef from pg_proc where oid = 'public.get_promo_banner_dismissals(uuid)'::regprocedure)
    or (select prosecdef from pg_proc where oid = 'public.save_promo_banner_dismissal(uuid,uuid,integer,boolean,timestamptz)'::regprocedure)
  then
    raise exception 'Promo dismissal grants bypass ownership';
  end if;

  select id into v_banner from core.promo_banners limit 1;
  if v_banner is null then
    raise exception 'Promo seed required for contract';
  end if;
  update core.promo_banners set version = 2 where id = v_banner;
  insert into auth.users (id) values (v_user_a), (v_user_b);

  perform set_config('request.jwt.claim.sub', v_user_a::text, true);
  execute 'set local role authenticated';
  perform public.save_promo_banner_dismissal(v_user_a, v_banner, 1, false, v_until);
  perform public.save_promo_banner_dismissal(v_user_a, v_banner, 1, true, null);
  perform public.save_promo_banner_dismissal(v_user_a, v_banner, 1, false, now() + interval '1 day');
  v_rows := public.get_promo_banner_dismissals(v_user_a);
  execute 'reset role';
  if jsonb_array_length(v_rows) <> 1
    or (v_rows->0->>'bannerId')::uuid <> v_banner
    or (v_rows->0->>'version')::integer <> 1
    or (v_rows->0->>'hidden')::boolean is distinct from true
    or (v_rows->0->>'snoozedUntil')::timestamptz is distinct from v_until then
    raise exception 'Promo dismissal merge lost the hide or snooze';
  end if;

  execute 'set local role authenticated';
  perform public.save_promo_banner_dismissal(v_user_a, v_banner, 2, true, null);
  v_rows := public.get_promo_banner_dismissals(v_user_a);
  execute 'reset role';
  if jsonb_array_length(v_rows) <> 2 then
    raise exception 'Promo versions must keep independent dismissal identities';
  end if;

  perform set_config('request.jwt.claim.sub', v_user_b::text, true);
  execute 'set local role authenticated';
  v_rows := public.get_promo_banner_dismissals(v_user_b);
  execute 'reset role';
  if v_rows <> '[]'::jsonb then
    raise exception 'Promo dismissals leaked between accounts';
  end if;
  begin
    execute 'set local role authenticated';
    perform public.get_promo_banner_dismissals(v_user_a);
    execute 'reset role';
    raise exception 'Another account could read private promo dismissals';
  exception when insufficient_privilege then
    execute 'reset role';
  end;
  begin
    execute 'set local role authenticated';
    perform public.save_promo_banner_dismissal(v_user_a, v_banner, 1, true, null);
    execute 'reset role';
    raise exception 'An in-flight account switch could write to another account';
  exception when insufficient_privilege then
    execute 'reset role';
  end;
  begin
    execute 'set local role authenticated';
    perform public.save_promo_banner_dismissal(v_user_b, v_banner, 0, true, null);
    execute 'reset role';
    raise exception 'An invalid promo version was accepted';
  exception when invalid_parameter_value then
    execute 'reset role';
  end;
  begin
    execute 'set local role authenticated';
    perform public.save_promo_banner_dismissal(v_user_b, v_banner, 1, false, now() + interval '1 year');
    execute 'reset role';
    raise exception 'An unbounded snooze was accepted';
  exception when invalid_parameter_value then
    execute 'reset role';
  end;

  perform set_config('request.jwt.claim.sub', '', true);
  begin
    execute 'set local role authenticated';
    perform public.get_promo_banner_dismissals(v_user_a);
    execute 'reset role';
    raise exception 'Missing identity could read private promo dismissals';
  exception when insufficient_privilege then
    execute 'reset role';
  end;
  begin
    execute 'set local role anon';
    perform public.save_promo_banner_dismissal(v_user_a, v_banner, 1, true, null);
    execute 'reset role';
    raise exception 'An anonymous client could write private promo dismissals';
  exception when insufficient_privilege then
    execute 'reset role';
  end;
end;
$$;

rollback;
