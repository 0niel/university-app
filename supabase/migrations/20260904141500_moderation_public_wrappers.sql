-- Only public is exposed through PostgREST, so the moderation RPCs get the
-- same public wrappers as the rest of app_api_v1.

create or replace function public.moderation_begin(p_job_id uuid)
returns jsonb language sql security definer set search_path = ''
as $$ select app_api_v1.moderation_begin(p_job_id); $$;

create or replace function public.moderation_finish(
  p_job_id uuid,
  p_decision jsonb
)
returns jsonb language sql security definer set search_path = ''
as $$ select app_api_v1.moderation_finish(p_job_id, p_decision); $$;

create or replace function public.moderation_fail(p_job_id uuid, p_error text)
returns void language sql security definer set search_path = ''
as $$ select app_api_v1.moderation_fail(p_job_id, p_error); $$;

revoke all on function public.moderation_begin(uuid)
from public, anon, authenticated;
revoke all on function public.moderation_finish(uuid, jsonb)
from public, anon, authenticated;
revoke all on function public.moderation_fail(uuid, text)
from public, anon, authenticated;

grant execute on function public.moderation_begin(uuid) to service_role;
grant execute on function public.moderation_finish(uuid, jsonb)
to service_role;
grant execute on function public.moderation_fail(uuid, text) to service_role;
