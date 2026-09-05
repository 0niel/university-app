begin;

delete from internal.app_config where key in ('app_push_url', 'app_push_secret');

do $$
declare
  v_mentor uuid := extensions.gen_random_uuid();
  v_requester uuid := extensions.gen_random_uuid();
  v_request uuid := extensions.gen_random_uuid();
  v_cancel uuid := extensions.gen_random_uuid();
  v_decline uuid := extensions.gen_random_uuid();
begin
  insert into core.organizations (id, name) values ('mentor-notifications', 'Mentor notifications');
  insert into auth.users (id) values (v_mentor), (v_requester);
  insert into core.user_academic_profiles (user_id, organization_id, full_name, academic_group)
  values (v_mentor, 'mentor-notifications', 'Mentor', 'MENTOR-01'),
    (v_requester, 'mentor-notifications', 'Requester', 'MENTOR-01');
  insert into core.mentor_requests (id, organization_id, mentor_user_id, requester_id, topic)
  values (v_request, 'mentor-notifications', v_mentor, v_requester, 'Math');
  if (select count(*) from core.notification_inbox where user_id = v_mentor and kind = 'mentor_request') <> 1 then
    raise exception 'Mentor did not receive initial request';
  end if;
  perform internal.notify_app_event_once(v_mentor, 'Duplicate backfill', '', '/services/mentorship',
    'mentor_request', 'mentor_request:' || v_request::text, now(), false);
  if (select count(*) from core.notification_inbox where user_id = v_mentor and kind = 'mentor_request') <> 1 then
    raise exception 'Backfill duplicated a live mentor request';
  end if;

  update core.mentor_requests set status = 'accepted' where id = v_request;
  update core.mentor_requests set status = 'accepted' where id = v_request;
  if (select count(*) from core.notification_inbox where user_id = v_requester and kind = 'mentor_request_result') <> 1 then
    raise exception 'Mentor acceptance missing or duplicated';
  end if;
  update core.mentor_requests set status = 'completion_pending', mentor_confirmed_at = now() where id = v_request;
  if (select count(*) from core.notification_inbox where user_id = v_requester and kind = 'mentor_completion_request') <> 1
    or exists (select 1 from core.notification_inbox where user_id = v_mentor and kind = 'mentor_completion_request') then
    raise exception 'Completion confirmation was not sent to the unconfirmed participant';
  end if;
  update core.mentor_requests set status = 'completion_pending', requester_confirmed_at = now() where id = v_request;
  update core.mentor_requests set status = 'completed' where id = v_request;
  if (select count(*) from core.notification_inbox where kind = 'mentor_request_result'
      and user_id in (v_mentor, v_requester) and title = 'Встреча с ментором завершена') <> 2 then
    raise exception 'Completed session result was not delivered to both participants';
  end if;

  insert into core.mentor_requests (id, organization_id, mentor_user_id, requester_id)
  values (v_decline, 'mentor-notifications', v_mentor, v_requester);
  update core.mentor_requests set status = 'declined' where id = v_decline;
  if not exists (select 1 from core.notification_inbox where user_id = v_requester
      and title = 'Ментор отклонил запрос' and route = '/services/mentorship') then
    raise exception 'Mentor rejection notification is missing or misrouted';
  end if;

  insert into core.mentor_requests (id, organization_id, mentor_user_id, requester_id)
  values (v_cancel, 'mentor-notifications', v_mentor, v_requester);
  perform set_config('request.jwt.claim.sub', v_requester::text, true);
  update core.mentor_requests set status = 'cancelled' where id = v_cancel;
  if not exists (select 1 from core.notification_inbox where user_id = v_mentor and title = 'Встреча с ментором отменена')
    or exists (select 1 from core.notification_inbox where user_id = v_requester and title = 'Встреча с ментором отменена') then
    raise exception 'Cancellation did not target the other participant';
  end if;
end;
$$;

rollback;
