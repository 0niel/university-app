revoke all on function public.get_user_settings() from public, anon;
revoke all on function app_api_v1.get_user_settings() from public, anon;
revoke all on function public.upsert_user_settings(
  boolean, boolean, boolean, boolean, boolean, text, text, text, boolean,
  text, boolean
) from public, anon;
revoke all on function app_api_v1.upsert_user_settings(
  boolean, boolean, boolean, boolean, boolean, text, text, text, boolean,
  text, boolean
) from public, anon;

grant execute on function public.get_user_settings()
  to authenticated, service_role;
grant execute on function app_api_v1.get_user_settings()
  to authenticated, service_role;
grant execute on function public.upsert_user_settings(
  boolean, boolean, boolean, boolean, boolean, text, text, text, boolean,
  text, boolean
) to authenticated, service_role;
grant execute on function app_api_v1.upsert_user_settings(
  boolean, boolean, boolean, boolean, boolean, text, text, text, boolean,
  text, boolean
) to authenticated, service_role;
