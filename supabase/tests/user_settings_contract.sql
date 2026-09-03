begin;

do $$
declare
  v_rpc text;
  v_upsert_args constant text :=
    '(boolean,boolean,boolean,boolean,boolean,' ||
    'text,text,text,boolean,text,boolean)';
begin
  if not exists (
    select 1
    from pg_attribute
    where attrelid = 'user_private.user_settings'::regclass
      and attname = 'profile_visibility'
      and not attisdropped
  ) or not exists (
    select 1
    from pg_attribute
    where attrelid = 'user_private.user_settings'::regclass
      and attname = 'anonymous_reactions'
      and not attisdropped
  ) then
    raise exception 'Missing user privacy settings columns';
  end if;

  foreach v_rpc in array array[
    'public.get_user_settings()',
    'app_api_v1.get_user_settings()',
    'public.upsert_user_settings' || v_upsert_args,
    'app_api_v1.upsert_user_settings' || v_upsert_args
  ] loop
    if to_regprocedure(v_rpc) is null then
      raise exception 'Missing privacy-aware settings RPC: %', v_rpc;
    end if;
    if has_function_privilege('anon', v_rpc, 'EXECUTE') then
      raise exception 'Anonymous role can execute user settings RPC: %', v_rpc;
    end if;
    if not has_function_privilege('authenticated', v_rpc, 'EXECUTE')
      or not has_function_privilege('service_role', v_rpc, 'EXECUTE') then
      raise exception 'Authorized role cannot execute settings RPC: %', v_rpc;
    end if;
    if (select prosecdef from pg_proc where oid = to_regprocedure(v_rpc)) then
      raise exception 'Settings RPC bypasses caller privileges: %', v_rpc;
    end if;
  end loop;
end
$$;

do $$
declare
  v_user_a uuid := extensions.gen_random_uuid();
  v_user_b uuid := extensions.gen_random_uuid();
begin
  insert into auth.users (id) values (v_user_a), (v_user_b);
  perform set_config('test.settings_user_a', v_user_a::text, true);
  perform set_config('test.settings_user_b', v_user_b::text, true);
end;
$$;

set local role authenticated;

do $$
declare
  v_settings jsonb;
begin
  perform set_config('request.jwt.claim.role', 'authenticated', true);
  perform set_config(
    'request.jwt.claim.sub', current_setting('test.settings_user_a'), true
  );
  v_settings := public.upsert_user_settings(
    p_theme_mode => 'dark',
    p_profile_visibility => 'nobody',
    p_anonymous_reactions => false
  );
  if v_settings->>'themeMode' is distinct from 'dark'
    or v_settings->>'profileVisibility' is distinct from 'nobody'
    or (v_settings->>'anonymousReactions')::boolean is distinct from false then
    raise exception 'Own privacy settings were not persisted';
  end if;

  perform set_config(
    'request.jwt.claim.sub', current_setting('test.settings_user_b'), true
  );
  v_settings := public.get_user_settings();
  if v_settings->>'themeMode' is distinct from 'system'
    or v_settings->>'profileVisibility' is distinct from 'everyone' then
    raise exception 'Settings from another account leaked';
  end if;
  perform public.upsert_user_settings(p_theme_mode => 'light');
  if exists (
    select 1 from user_private.user_settings
    where user_id = current_setting('test.settings_user_a')::uuid
  ) then
    raise exception 'RLS exposes settings from another account';
  end if;

  perform set_config(
    'request.jwt.claim.sub', current_setting('test.settings_user_a'), true
  );
  v_settings := public.get_user_settings();
  if v_settings->>'themeMode' is distinct from 'dark'
    or v_settings->>'profileVisibility' is distinct from 'nobody' then
    raise exception 'Updating one account changed another account settings';
  end if;
end;
$$;

reset role;

set local role anon;

do $$
begin
  begin
    perform public.get_user_settings();
    raise exception 'Anonymous role read settings through the public RPC';
  exception when insufficient_privilege then
    null;
  end;
  begin
    perform public.upsert_user_settings(p_theme_mode => 'light');
    raise exception 'Anonymous role updated settings through the public RPC';
  exception when insufficient_privilege then
    null;
  end;
end;
$$;

reset role;

rollback;
