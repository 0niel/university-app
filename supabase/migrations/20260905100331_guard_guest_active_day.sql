create or replace function public.record_active_day()
returns void
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if current_user = 'anon' then
    return;
  end if;
  perform app_api_v1.record_active_day();
end;
$$;

revoke all on function public.record_active_day() from public;
grant execute on function public.record_active_day()
  to anon, authenticated, service_role;

notify pgrst, 'reload schema';
