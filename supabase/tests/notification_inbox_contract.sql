begin;

delete from internal.app_config
where key in ('app_push_url', 'app_push_secret', 'friends_push_url', 'friends_push_secret');

do $$
declare
  v_sender uuid := extensions.gen_random_uuid();
  v_recipient uuid := extensions.gen_random_uuid();
  v_outsider uuid := extensions.gen_random_uuid();
  v_friendship uuid := extensions.gen_random_uuid();
  v_request uuid := md5('friend_request:' || v_friendship::text)::uuid;
  v_accepted uuid := md5('friend_accepted:' || v_friendship::text)::uuid;
  v_rows jsonb;
  v_read_at timestamptz;
begin
  if has_table_privilege('authenticated', 'core.notification_inbox', 'SELECT,INSERT,UPDATE,DELETE')
    or has_function_privilege('anon', 'public.get_notification_inbox()', 'EXECUTE')
    or has_function_privilege('anon', 'public.mark_notification_inbox_read(uuid[])', 'EXECUTE')
    or has_function_privilege('authenticated', 'internal.notify_app_push(uuid,text,text,text,text)', 'EXECUTE')
    or has_function_privilege('authenticated', 'internal.record_notification(uuid,text,text,text,text,uuid,timestamptz)', 'EXECUTE')
  then
    raise exception 'Notification inbox grants expose privileged data or writers';
  end if;

  insert into core.organizations (id, name)
  values ('notification-test-a', 'Notification A'), ('notification-test-b', 'Notification B');
  insert into auth.users (id) values (v_sender), (v_recipient), (v_outsider);
  insert into core.user_academic_profiles (user_id, organization_id, full_name, academic_group, handle)
  values
    (v_sender, 'notification-test-a', 'Sender', 'TEST-01', 'notification_sender'),
    (v_recipient, 'notification-test-a', 'Recipient', 'TEST-01', 'notification_recipient'),
    (v_outsider, 'notification-test-b', 'Outsider', 'TEST-02', 'notification_outsider');

  insert into core.friendships (id, requester_id, addressee_id, organization_id)
  values (v_friendship, v_sender, v_recipient, 'notification-test-a');
  update core.friendships set status = 'pending' where id = v_friendship;

  perform set_config('request.jwt.claim.sub', v_recipient::text, true);
  execute 'set local role authenticated';
  v_rows := public.get_notification_inbox();
  execute 'reset role';
  if jsonb_array_length(v_rows) <> 1
    or v_rows->0->>'id' <> v_request::text
    or v_rows->0->>'kind' <> 'friend_request'
    or v_rows->0->>'route' <> '/services/people?tab=friends'
    or v_rows->0->>'body' <> 'Sender хочет добавить тебя'
    or v_rows->0->>'createdAt' is null
    or v_rows->0->>'readAt' is not null
  then
    raise exception 'Friend request was missing or duplicated without push configuration: %', v_rows;
  end if;

  perform internal.record_notification(v_recipient, 'Duplicate', '', '/services/people?tab=friends', 'friend_request', v_request);
  if (select count(*) from core.notification_inbox where user_id = v_recipient) <> 1 then
    raise exception 'Stable notification id did not deduplicate a repeated event';
  end if;

  perform set_config('request.jwt.claim.sub', v_outsider::text, true);
  execute 'set local role authenticated';
  v_rows := public.get_notification_inbox();
  perform public.mark_notification_inbox_read(array[v_request]);
  execute 'reset role';
  if v_rows <> '[]'::jsonb or (select read_at from core.notification_inbox where id = v_request) is not null then
    raise exception 'Another user could see or mark a notification';
  end if;

  update core.friendships set status = 'accepted' where id = v_friendship;
  perform set_config('request.jwt.claim.sub', v_sender::text, true);
  execute 'set local role authenticated';
  v_rows := public.get_notification_inbox();
  perform public.mark_notification_inbox_read(array[v_accepted, v_request]);
  execute 'reset role';
  if jsonb_array_length(v_rows) <> 1 or v_rows->0->>'kind' <> 'friend_accepted'
    or v_rows->0->>'id' <> v_accepted::text
    or (select read_at from core.notification_inbox where id = v_accepted) is null
    or (select read_at from core.notification_inbox where id = v_request) is not null
  then
    raise exception 'Friend acceptance or recipient-scoped read state is invalid';
  end if;
  select read_at into v_read_at from core.notification_inbox where id = v_accepted;
  perform public.mark_notification_inbox_read(array[v_accepted]);
  if (select read_at from core.notification_inbox where id = v_accepted) <> v_read_at then
    raise exception 'Mark read changed the original read timestamp';
  end if;

  perform internal.notify_app_push(v_recipient, 'Отклик в команду', 'Team application', '/services/team-finder', 'team_application');
  perform internal.notify_app_push(v_recipient, 'Ответ по отклику', 'Accepted', '/services/team-finder', 'team_application_result');
  perform internal.notify_app_push(v_recipient, 'Запрос на менторство', 'Mentorship', '/services/mentorship', 'mentor_request');
  if (select count(*) from core.notification_inbox where user_id = v_recipient) <> 4 then
    raise exception 'Service events were lost when push was unavailable';
  end if;

  insert into user_private.user_settings (user_id, notifications_enabled)
  values (v_recipient, false)
  on conflict (user_id) do update set notifications_enabled = false;
  perform internal.notify_app_push_gated(v_recipient, 'achievement', 'Achievement', 'Earned', '/achievements');
  if (select count(*) from core.notification_inbox where user_id = v_recipient and kind = 'achievement') <> 1 then
    raise exception 'Push preference suppressed the durable inbox event';
  end if;

  update user_private.user_settings set notifications_enabled = true where user_id = v_recipient;
  perform internal.notify_app_push_gated(v_recipient, 'quest', 'Quest', 'Completed', '/quests');
  if (select count(*) from core.notification_inbox where user_id = v_recipient and kind = 'quest') <> 1 then
    raise exception 'Enabled push gate duplicated or dropped the inbox event';
  end if;

  insert into internal.app_config (key, value)
  values ('app_push_url', 'invalid-notification-test-url'), ('app_push_secret', 'notification-test');
  perform internal.notify_app_push(v_recipient, 'Transport failure', '', '', 'transport_test');
  if (select count(*) from core.notification_inbox where user_id = v_recipient and kind = 'transport_test') <> 1 then
    raise exception 'Push transport failure rolled back the inbox event';
  end if;

  perform set_config('request.jwt.claim.sub', v_recipient::text, true);
  update core.user_academic_profiles set organization_id = 'notification-test-b' where user_id = v_recipient;
  execute 'set local role authenticated';
  v_rows := public.get_notification_inbox();
  perform public.mark_notification_inbox_read(array[v_request]);
  execute 'reset role';
  if v_rows <> '[]'::jsonb or (select read_at from core.notification_inbox where id = v_request) is not null then
    raise exception 'Notifications from a previous organization remained accessible';
  end if;

  perform set_config('request.jwt.claim.sub', '', true);
  if public.get_notification_inbox() <> '[]'::jsonb then
    raise exception 'Missing user identity leaked the inbox';
  end if;
end;
$$;

rollback;
