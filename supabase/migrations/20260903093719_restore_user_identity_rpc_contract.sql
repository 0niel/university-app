create or replace function public.set_user_identity(
  p_organization_id text,
  p_full_name text,
  p_handle text
)
returns jsonb
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.set_user_identity(
    p_organization_id, p_full_name, p_handle
  );
$$;

revoke all on function public.set_user_identity(text, text, text)
from public, anon;
revoke all on function app_api_v1.set_user_identity(text, text, text)
from public, anon;
grant execute on function public.set_user_identity(text, text, text)
to authenticated, service_role;
grant execute on function app_api_v1.set_user_identity(text, text, text)
to authenticated, service_role;
