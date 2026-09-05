create or replace function public.get_app_push_devices(p_user_id uuid)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select coalesce(jsonb_agg(jsonb_build_object(
    'user_id', d.user_id,
    'fcm_token', d.fcm_token,
    'platform', d.platform,
    'cns_endpoint_arn', d.cns_endpoint_arn
  )), '[]'::jsonb)
  from core.user_devices d
  where d.user_id = p_user_id;
$$;

create or replace function public.set_app_push_endpoint(
  p_user_id uuid, p_fcm_token text, p_endpoint_arn text
)
returns boolean
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if p_user_id is null or nullif(trim(p_fcm_token), '') is null
    or p_endpoint_arn is null or p_endpoint_arn !~ '^arn:aws:sns:[^:]*:[^:]+:endpoint/'
  then
    raise exception 'Invalid endpoint update' using errcode = '22023';
  end if;
  update core.user_devices
  set cns_endpoint_arn = p_endpoint_arn
  where user_id = p_user_id and fcm_token = p_fcm_token;
  return found;
end;
$$;

create or replace function public.get_friend_push_context(p_friendship_id uuid)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select jsonb_build_object(
    'requester_id', f.requester_id,
    'addressee_id', f.addressee_id,
    'status', f.status,
    'requester_name', r.full_name,
    'addressee_name', a.full_name
  )
  from core.friendships f
  left join core.user_academic_profiles r
    on r.user_id = f.requester_id and r.organization_id = f.organization_id
  left join core.user_academic_profiles a
    on a.user_id = f.addressee_id and a.organization_id = f.organization_id
  where f.id = p_friendship_id;
$$;

revoke all on function public.get_app_push_devices(uuid) from public, anon, authenticated;
revoke all on function public.set_app_push_endpoint(uuid, text, text) from public, anon, authenticated;
revoke all on function public.get_friend_push_context(uuid) from public, anon, authenticated;
grant execute on function public.get_app_push_devices(uuid) to service_role;
grant execute on function public.set_app_push_endpoint(uuid, text, text) to service_role;
grant execute on function public.get_friend_push_context(uuid) to service_role;
