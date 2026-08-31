-- This legacy event trigger helper should not be callable through PostgREST RPC.
-- Event triggers do not need public EXECUTE grants to run.

do $$
begin
  if to_regprocedure('public.rls_auto_enable()') is not null then
    execute 'revoke all on function public.rls_auto_enable() '
      'from public, anon, authenticated';
    execute 'grant execute on function public.rls_auto_enable() '
      'to service_role';
  end if;
end;
$$;
