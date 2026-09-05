begin;

delete from internal.app_config where key in ('app_push_url', 'app_push_secret', 'friends_push_url', 'friends_push_secret');

do $$
declare
  sender uuid := extensions.gen_random_uuid();
  recipient uuid := extensions.gen_random_uuid();
  outsider uuid := extensions.gen_random_uuid();
  friendship uuid := extensions.gen_random_uuid();
  payload jsonb;
  signature text;
begin
  foreach signature in array array[
    'public.get_app_push_devices(uuid)',
    'public.set_app_push_endpoint(uuid,text,text)',
    'public.get_friend_push_context(uuid)'
  ] loop
    if has_function_privilege('anon', signature, 'execute')
      or has_function_privilege('authenticated', signature, 'execute')
      or not has_function_privilege('service_role', signature, 'execute')
    then raise exception 'Push delivery RPC privileges are invalid'; end if;
  end loop;
  insert into core.organizations(id, name) values ('push-rpc-a', 'Push A'), ('push-rpc-b', 'Push B');
  insert into auth.users(id) values (sender), (recipient), (outsider);
  insert into core.user_academic_profiles(user_id, organization_id, full_name, academic_group, handle)
  values
    (sender, 'push-rpc-a', 'Sender', 'TEST-01', 'push_rpc_sender'),
    (recipient, 'push-rpc-a', 'Recipient', 'TEST-01', 'push_rpc_recipient'),
    (outsider, 'push-rpc-b', 'Outsider', 'TEST-02', 'push_rpc_outsider');
  insert into core.user_devices(fcm_token,user_id,platform)
  values ('push-rpc-recipient-device',recipient,'ios'), ('push-rpc-outside-device',outsider,'android');
  insert into core.friendships(id, requester_id, addressee_id, organization_id)
  values (friendship, sender, recipient, 'push-rpc-a');
  execute 'set local role service_role';
  payload := public.get_app_push_devices(recipient);
  if jsonb_array_length(payload) <> 1 or payload->0->>'user_id' <> recipient::text
    or payload->0->>'platform' <> 'ios' then
    raise exception 'Push device lookup is not recipient scoped';
  end if;
  if public.set_app_push_endpoint(outsider,'push-rpc-recipient-device','arn:aws:sns:ru-central1:fixture:endpoint/GCM/test/1') then
    raise exception 'Endpoint cache crossed device ownership';
  end if;
  if not public.set_app_push_endpoint(recipient,'push-rpc-recipient-device','arn:aws:sns:ru-central1:fixture:endpoint/GCM/test/1') then
    raise exception 'Endpoint cache did not update matching device';
  end if;
  payload := public.get_friend_push_context(friendship);
  if payload->>'requester_id' <> sender::text or payload->>'addressee_id' <> recipient::text
    or payload->>'requester_name' <> 'Sender' or payload->>'addressee_name' <> 'Recipient' then
    raise exception 'Friend context lost event scope';
  end if;
  if public.get_friend_push_context(extensions.gen_random_uuid()) is not null then
    raise exception 'Missing friendship must not return a recipient';
  end if;
  if public.get_app_push_devices(null) <> '[]'::jsonb then
    raise exception 'Null recipient must not match all devices';
  end if;
  execute 'reset role';
  begin
    update core.friendships set organization_id='push-rpc-b' where id=friendship;
    raise exception 'Friendship must not cross participant organizations';
  exception when check_violation then
    null;
  end;
  execute 'set local role service_role';
  payload := public.get_friend_push_context(friendship);
  if payload->>'requester_name' is distinct from 'Sender'
    or payload->>'addressee_name' is distinct from 'Recipient' then
    raise exception 'Rejected organization change altered friend context';
  end if;
  execute 'reset role';
end;
$$;

rollback;
