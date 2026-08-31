-- Remove the "Подслушано" (confessions) feature entirely: tables + RPCs.
-- The feature was dropped from the app; this clears all backend traces.
-- Applied remotely as: remove_confessions.

do $$
declare
  r record;
begin
  for r in
    select n.nspname, p.proname,
           pg_get_function_identity_arguments(p.oid) as args
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where p.proname like '%confession%'
      and n.nspname in ('public', 'app_api_v1')
  loop
    execute format(
      'drop function if exists %I.%I(%s) cascade',
      r.nspname, r.proname, r.args
    );
  end loop;
end
$$;

drop table if exists core.confession_likes cascade;
drop table if exists core.confessions cascade;
