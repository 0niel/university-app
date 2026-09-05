begin;

delete from internal.app_config
where key in ('app_push_url', 'app_push_secret');

do $$
declare
  v_owner uuid := extensions.gen_random_uuid();
  v_member uuid := extensions.gen_random_uuid();
  v_applicant uuid := extensions.gen_random_uuid();
  v_group uuid := extensions.gen_random_uuid();
  v_invite uuid := extensions.gen_random_uuid();
  v_request uuid := extensions.gen_random_uuid();
  v_decline uuid := extensions.gen_random_uuid();
  v_revoke uuid := extensions.gen_random_uuid();
begin
  insert into core.organizations (id, name)
  values ('group-notifications-a', 'Group notifications A'), ('group-notifications-b', 'Group notifications B');
  insert into auth.users (id) values (v_owner), (v_member), (v_applicant);
  insert into core.user_academic_profiles (user_id, organization_id, full_name, academic_group)
  values (v_owner, 'group-notifications-a', 'Owner', 'GROUP-01'),
    (v_member, 'group-notifications-a', 'Member', 'GROUP-01'),
    (v_applicant, 'group-notifications-a', 'Applicant', 'GROUP-01');
  insert into core.study_groups (id, organization_id, owner_id, name, join_code)
  values (v_group, 'group-notifications-a', v_owner, 'Test study group', 'NOTIFY01');
  insert into core.study_group_members (group_id, user_id, role)
  values (v_group, v_owner, 'owner'), (v_group, v_member, 'member');

  insert into core.study_group_invites (id, group_id, target_user_id, created_by, kind)
  values (v_invite, v_group, v_applicant, v_owner, 'invite');
  update core.study_group_invites set created_at = now(), status = 'pending' where id = v_invite;
  if (select count(*) from core.notification_inbox where user_id = v_applicant and kind = 'study_group_invite') <> 1
    or not exists (
      select 1 from core.notification_inbox where user_id = v_applicant
        and kind = 'study_group_invite' and route = '/services/people?tab=group'
    )
  then
    raise exception 'Study group invite was missing, misrouted or duplicated on refresh';
  end if;
  update core.study_group_invites set status = 'accepted' where id = v_invite;
  update core.study_group_invites set status = 'accepted' where id = v_invite;
  if (select count(*) from core.notification_inbox where user_id = v_owner and kind = 'study_group_invite_result') <> 1 then
    raise exception 'Invite acceptance was not sent once to the owner';
  end if;

  insert into core.study_group_invites (id, group_id, target_user_id, created_by, kind)
  values (v_request, v_group, v_applicant, v_applicant, 'request');
  update core.study_group_invites set created_at = now(), status = 'pending' where id = v_request;
  if (select count(*) from core.notification_inbox where user_id = v_owner and kind = 'study_group_join_request') <> 1
    or not exists (
      select 1 from core.notification_inbox where user_id = v_owner
        and kind = 'study_group_join_request' and route = '/services/people?tab=group&manageGroup=1'
    )
  then
    raise exception 'Join request was missing, misrouted or duplicated';
  end if;
  update core.study_group_invites set status = 'declined' where id = v_request;
  update core.study_group_invites set status = 'declined' where id = v_request;
  if (select count(*) from core.notification_inbox where user_id = v_applicant and kind = 'study_group_join_result') <> 1
    or not exists (
      select 1 from core.notification_inbox where user_id = v_applicant
        and kind = 'study_group_join_result' and body like '%отклонена'
    )
  then
    raise exception 'Join request rejection was not delivered once to applicant';
  end if;

  insert into core.study_group_invites (id, group_id, target_user_id, created_by, kind)
  values (v_decline, v_group, v_applicant, v_owner, 'invite');
  update core.study_group_invites set status = 'declined' where id = v_decline;
  if (select count(*) from core.notification_inbox where user_id = v_owner and kind = 'study_group_invite_result') <> 2 then
    raise exception 'Invite rejection did not notify the owner';
  end if;

  insert into core.study_group_invites (id, group_id, target_user_id, created_by, kind)
  values (v_revoke, v_group, v_applicant, v_applicant, 'request');
  update core.study_group_invites set status = 'revoked' where id = v_revoke;
  if (select count(*) from core.notification_inbox where user_id = v_applicant and kind = 'study_group_join_result') <> 1 then
    raise exception 'Automatic revocation generated a misleading decision notification';
  end if;
  if exists (select 1 from core.notification_inbox where user_id = v_member) then
    raise exception 'Study group events were broadcast to unrelated members';
  end if;

  v_request := extensions.gen_random_uuid();
  insert into core.study_group_invites (id, group_id, target_user_id, created_by, kind)
  values (v_request, v_group, v_applicant, v_applicant, 'request');
  update core.study_group_invites set status = 'accepted' where id = v_request;
  if (select count(*) from core.notification_inbox where user_id = v_applicant and kind = 'study_group_join_result') <> 2
    or not exists (
      select 1 from core.notification_inbox where user_id = v_applicant
        and kind = 'study_group_join_result' and title = 'Вас приняли в учебную группу'
    )
  then
    raise exception 'Accepted join request did not notify the applicant';
  end if;

  v_request := extensions.gen_random_uuid();
  insert into core.study_group_invites (id, group_id, target_user_id, created_by, kind)
  values (v_request, v_group, v_applicant, v_applicant, 'request');
  update core.user_academic_profiles set organization_id = 'group-notifications-b' where user_id = v_applicant;
  update core.study_group_invites set status = 'declined' where id = v_request;
  if (select count(*) from core.notification_inbox where user_id = v_applicant and kind = 'study_group_join_result') <> 2 then
    raise exception 'Stale join request leaked a previous organization result';
  end if;
end;
$$;

rollback;
