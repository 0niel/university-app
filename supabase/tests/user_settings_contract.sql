begin;

do $$
declare
  v_rpc constant text :=
    'public.upsert_user_settings(boolean,boolean,boolean,boolean,boolean,' ||
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

  if to_regprocedure(v_rpc) is null then
    raise exception 'Missing privacy-aware settings RPC';
  end if;

  if has_function_privilege('anon', v_rpc, 'EXECUTE') then
    raise exception 'Anonymous role can update user settings';
  end if;

  if not has_function_privilege('authenticated', v_rpc, 'EXECUTE') then
    raise exception 'Authenticated role cannot update user settings';
  end if;
end
$$;

rollback;
