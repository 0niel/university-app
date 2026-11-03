begin;
set local statement_timeout = '30s';
set local lock_timeout = '3s';

create function pg_temp.expect_actor_denied(p_sql text, p_hint text default null)
returns void language plpgsql as $$
declare
  v_hint text;
begin
  begin
    execute p_sql;
  exception when insufficient_privilege then
    get stacked diagnostics v_hint = pg_exception_hint;
    if p_hint is not null and v_hint is distinct from p_hint then
      raise exception 'Unexpected actor protection hint: %', v_hint;
    end if;
    return;
  end;
  raise exception 'Content actor protection was bypassed';
end;
$$;

create temporary table content_actor_storage_fixture
(like storage.objects including defaults);
create trigger guard_shared_storage_write before insert or update
on content_actor_storage_fixture
for each row execute function internal.guard_shared_storage_write();
create trigger enforce_storage_upload_limits after insert or update
on content_actor_storage_fixture
for each row execute function core.enforce_storage_upload_limits();

do $$
declare
  v_member uuid := extensions.gen_random_uuid();
  v_guest uuid := extensions.gen_random_uuid();
  v_new uuid := extensions.gen_random_uuid();
  v_converted uuid := extensions.gen_random_uuid();
  v_unverified uuid := extensions.gen_random_uuid();
  v_oauth uuid := extensions.gen_random_uuid();
  v_phone uuid := extensions.gen_random_uuid();
  v_review uuid;
  v_guest_review uuid := extensions.gen_random_uuid();
  v_guest_note uuid := extensions.gen_random_uuid();
  v_guest_deadline uuid := extensions.gen_random_uuid();
  v_count bigint;
  v_created_at timestamptz;
  v_action text;
begin
  if has_function_privilege('anon', 'internal.require_content_actor(uuid,boolean)', 'EXECUTE')
    or has_function_privilege('authenticated', 'internal.require_content_actor(uuid,boolean)', 'EXECUTE')
    or has_function_privilege('service_role', 'internal.require_content_actor(uuid,boolean)', 'EXECUTE')
    or has_function_privilege('authenticated', 'internal.require_permanent_content_actor(uuid,boolean)', 'EXECUTE')
    or has_function_privilege('service_role', 'internal.require_permanent_content_actor(uuid,boolean)', 'EXECUTE')
    or has_function_privilege('authenticated', 'internal.content_action_requires_trust(text)', 'EXECUTE')
    or has_function_privilege('authenticated', 'internal.content_action_requires_member(text)', 'EXECUTE') then
    raise exception 'Content actor helpers are directly executable';
  end if;
  perform set_config('request.jwt.claim.sub', '', true);
  perform set_config('request.jwt.claim.role', '', true);
  perform set_config('request.jwt.claims', '{}', true);
  insert into core.organizations(id, name)
  values ('content-actor-contract', 'Content Actor Contract'),
    ('content-actor-other', 'Other Content Organization');
  insert into auth.users(id, is_anonymous, created_at, email_confirmed_at, raw_user_meta_data)
  values
    (v_member, false, now() - interval '3 days', now() - interval '2 days', '{}'),
    (v_guest, true, now() - interval '30 days', null, '{"email_verified":true}'),
    (v_new, false, now() - interval '1 hour', now() - interval '1 hour', '{}'),
    (v_converted, false, now() - interval '30 days', now() - interval '1 hour', '{}'),
    (v_unverified, false, now() - interval '30 days', null, '{"email_verified":true}'),
    (v_oauth, false, now() - interval '3 days', null, '{}'),
    (v_phone, false, now() - interval '3 days', null, '{}');
  update auth.users set phone_confirmed_at = now() - interval '2 days' where id = v_phone;
  insert into auth.identities(id, user_id, provider_id, provider, identity_data, created_at, updated_at)
  values (extensions.gen_random_uuid(), v_oauth, v_oauth::text, 'google',
    jsonb_build_object('sub', v_oauth, 'email_verified', true),
    now() - interval '2 days', now() - interval '2 days');
  insert into core.user_academic_profiles(user_id, organization_id)
  values (v_member, 'content-actor-contract'), (v_guest, 'content-actor-contract'),
    (v_new, 'content-actor-contract');

  perform internal.require_content_actor(v_member, true);
  perform internal.require_content_actor(v_phone, true);
  perform internal.require_content_actor(v_oauth, true);
  perform internal.require_content_actor(v_guest, false);
  perform internal.require_permanent_content_actor(v_new, false);
  perform internal.require_permanent_content_actor(v_unverified, false);
  if not internal.content_write_is_removal('core.marketplace_listings',
    jsonb_build_object('seller_id',v_guest,'archived_at',null,'title','Existing item'),
    jsonb_build_object('seller_id',v_guest,'archived_at',clock_timestamp(),'title','Existing item'),v_guest)
    or internal.content_write_is_removal('core.marketplace_listings',
    jsonb_build_object('seller_id',v_guest,'archived_at',null,'title','Existing item'),
    jsonb_build_object('seller_id',v_guest,'archived_at',clock_timestamp(),'title','Changed item'),v_guest) then
    raise exception 'Content removal exception permits edits or blocks own archive';
  end if;
  perform pg_temp.expect_actor_denied(format(
    'select internal.require_permanent_content_actor(%L,false)', v_guest
  ), 'content_account_unverified');
  perform pg_temp.expect_actor_denied(format(
    'select internal.require_content_actor(%L,true)', v_guest
  ), 'content_account_unverified');
  perform pg_temp.expect_actor_denied(format(
    'select internal.require_content_actor(%L,true)', v_unverified
  ), 'content_account_unverified');
  perform pg_temp.expect_actor_denied(format(
    'select internal.require_content_actor(%L,true)', v_new
  ), 'content_account_cooldown');
  perform pg_temp.expect_actor_denied(format(
    'select internal.require_content_actor(%L,true)', v_converted
  ), 'content_account_cooldown');
  update auth.identities set created_at = now() - interval '1 hour' where user_id = v_oauth;
  perform pg_temp.expect_actor_denied(format(
    'select internal.require_content_actor(%L,true)', v_oauth
  ), 'content_account_cooldown');

  foreach v_action in array array[
    'create:core.teacher_reviews', 'edit:core.lesson_reviews',
    'create:core.poll_answers', 'create:core.mini_app_reports',
    'create:core.group_post_comments', 'mini_app_deploy'
  ] loop
    if not internal.content_action_requires_trust(v_action) then
      raise exception 'Shared content action is not protected: %', v_action;
    end if;
    perform pg_temp.expect_actor_denied(format(
      'select core.enforce_content_write_limit(%L,10,20,30,p_user_id => %L)',
      v_action, v_guest
    ), 'content_account_unverified');
  end loop;
  foreach v_action in array array[
    'create:core.user_deadlines', 'edit:core.group_notes',
    'create:core.study_groups', 'create:core.study_group_invites',
    'create:core.study_group_members', 'create:core.team_members',
    'create:core.team_applications', 'create:core.mentor_requests',
    'create:core.mini_app_user_storage', 'create:core.user_activities',
    'create:core.scheduled_reminders', 'create:core.friendships',
    'create:core.event_rsvps', 'create:core.exam_readiness', 'upload_file'
  ] loop
    if internal.content_action_requires_trust(v_action) then
      raise exception 'Private content unexpectedly requires confirmation cooldown: %', v_action;
    end if;
    if not internal.content_action_requires_member(v_action) then
      raise exception 'Guest content action is not protected: %', v_action;
    end if;
    perform pg_temp.expect_actor_denied(format(
      'select core.enforce_content_write_limit(%L,10,20,30,p_user_id => %L)', v_action, v_guest
    ), 'content_account_unverified');
    perform core.enforce_content_write_limit(v_action, 10, 20, 30, p_user_id => v_new);
  end loop;
  foreach v_action in array array[
    'create:core.user_devices', 'edit:core.user_academic_profiles',
    'edit:user_private.user_preferences', 'edit:user_private.user_settings',
    'create:core.mini_app_consents', 'create:core.map_bookmarks',
    'create:core.search_query_events', 'interact:core.lesson_materials',
    'interact:core.mini_apps'
  ] loop
    if internal.content_action_requires_member(v_action) then
      raise exception 'Guest read bootstrap or settings unexpectedly requires membership: %', v_action;
    end if;
    perform core.enforce_content_write_limit(v_action, 10, 20, 30, p_user_id => v_guest);
  end loop;
  if exists (select 1 from core.content_write_events
    where user_id = v_guest and action like '%teacher_reviews%') then
    raise exception 'Rejected shared writes consumed quota';
  end if;

  insert into core.teacher_reviews(id, organization_id, user_id, teacher_name, clarity, loyalty, usefulness)
  values (v_guest_review, 'content-actor-contract', v_guest, 'Existing Guest Review', 3, 3, 3);
  insert into core.group_notes(id,organization_id,academic_group,title,created_by,owner_id,visibility)
  values (v_guest_note, 'content-actor-contract', '', 'Existing guest note', v_guest, v_guest, 'personal');
  insert into core.user_deadlines(id,organization_id,user_id,title,due_at)
  values (v_guest_deadline, 'content-actor-contract', v_guest, 'Existing guest deadline', now());
  perform set_config('request.jwt.claim.sub', v_guest::text, true);
  perform set_config('request.jwt.claim.role', 'authenticated', true);
  perform set_config('request.jwt.claims', jsonb_build_object(
    'sub', v_guest, 'role', 'authenticated', 'is_anonymous', false
  )::text, true);
  perform pg_temp.expect_actor_denied(format(
    'insert into core.teacher_reviews(organization_id,user_id,teacher_name,clarity,loyalty,usefulness) values (%L,%L,%L,1,1,1)',
    'content-actor-contract', v_guest, 'Guest Target'
  ), 'content_account_unverified');
  perform pg_temp.expect_actor_denied(format(
    'update core.group_notes set title=%L where id=%L', 'Guest changed note', v_guest_note
  ), 'content_account_unverified');
  update core.group_notes set updated_at=clock_timestamp() where id=v_guest_note;
  perform pg_temp.expect_actor_denied(format(
    'update core.user_deadlines set title=%L where id=%L', 'Guest changed deadline', v_guest_deadline
  ), 'content_account_unverified');
  perform pg_temp.expect_actor_denied(format(
    'insert into core.user_deadlines(organization_id,user_id,title,due_at) values(%L,%L,%L,now())',
    'content-actor-contract', v_guest, 'Guest new deadline'
  ), 'content_account_unverified');
  execute 'set local role authenticated';
  delete from core.teacher_reviews where id = v_guest_review;
  get diagnostics v_count = row_count;
  perform app_api_v1.delete_group_note(v_guest_note);
  perform app_api_v1.delete_deadline(v_guest_deadline);
  execute 'reset role';
  if v_count <> 1
    or exists(select 1 from core.group_notes where id=v_guest_note)
    or exists(select 1 from core.user_deadlines where id=v_guest_deadline) then
    raise exception 'Guest could not remove their existing content';
  end if;

  perform set_config('request.jwt.claim.sub', v_member::text, true);
  perform set_config('request.jwt.claims', jsonb_build_object(
    'sub', v_member, 'role', 'authenticated', 'is_anonymous', false
  )::text, true);
  insert into core.teacher_reviews(organization_id,user_id,teacher_name,clarity,loyalty,usefulness,created_at)
  values ('content-actor-contract', v_member, 'Member Target', 4, 4, 4, now() - interval '30 days')
  returning id, created_at into v_review, v_created_at;
  if v_created_at < clock_timestamp() - interval '1 minute' then
    raise exception 'Client backdated a review';
  end if;
  perform pg_temp.expect_actor_denied(format(
    'insert into core.teacher_reviews(organization_id,user_id,teacher_name,clarity,loyalty,usefulness) values(%L,%L,%L,1,1,1)',
    'content-actor-other', v_member, 'Cross Organization Target'
  ), 'content_organization_denied');
  perform pg_temp.expect_actor_denied(format(
    'update core.teacher_reviews set created_at=now()-interval ''30 days'' where id=%L', v_review
  ), 'content_identity_immutable');
  perform pg_temp.expect_actor_denied(format(
    'update core.teacher_reviews set teacher_name=''Another Teacher'' where id=%L', v_review
  ), 'content_identity_immutable');
  perform pg_temp.expect_actor_denied(format(
    'update core.teacher_reviews set user_id=%L where id=%L', v_guest, v_review
  ), 'content_identity_immutable');
  update core.teacher_reviews set body = 'A normal edit', is_anonymous = true where id = v_review;
  if (select body from core.teacher_reviews where id = v_review) <> 'A normal edit' then
    raise exception 'Established member could not edit their review anonymously';
  end if;

  insert into core.group_notes(organization_id,academic_group,title,created_by,owner_id,visibility)
  values ('content-actor-contract', '', 'Private note', v_member, v_member, 'personal');
  perform set_config('request.jwt.claim.sub', v_guest::text, true);
  perform set_config('request.jwt.claims', jsonb_build_object('sub', v_guest, 'role', 'authenticated')::text, true);
  perform pg_temp.expect_actor_denied(format(
    'insert into core.group_notes(organization_id,academic_group,title,created_by,owner_id,visibility) values(%L,%L,%L,%L,%L,%L)',
    'content-actor-contract', '', 'Guest private note', v_guest, v_guest, 'personal'
  ), 'content_account_unverified');
  perform pg_temp.expect_actor_denied(format(
    'insert into core.group_notes(organization_id,academic_group,title,created_by,owner_id,visibility) values(%L,%L,%L,%L,%L,%L)',
    'content-actor-contract', '', 'Guest shared note', v_guest, v_guest, 'group'
  ), 'content_account_unverified');
  perform set_config('request.jwt.claim.sub', v_new::text, true);
  perform set_config('request.jwt.claims', jsonb_build_object('sub', v_new, 'role', 'authenticated')::text, true);
  insert into core.group_notes(organization_id,academic_group,title,created_by,owner_id,visibility)
  values ('content-actor-contract', '', 'New permanent private note', v_new, v_new, 'personal');

  perform set_config('request.jwt.claim.sub', '', true);
  perform set_config('request.jwt.claim.role', 'service_role', true);
  perform set_config('request.jwt.claims', '{"role":"service_role"}', true);
  perform pg_temp.expect_actor_denied(format(
    'insert into core.teacher_reviews(organization_id,user_id,teacher_name,clarity,loyalty,usefulness) values(%L,%L,%L,1,1,1)',
    'content-actor-contract', v_guest, 'Service Guest Target'
  ), 'content_account_unverified');
  select count(*) into v_count from core.content_write_events
  where user_id = v_member and action = 'create:core.teacher_reviews';
  insert into core.teacher_reviews(organization_id,user_id,teacher_name,clarity,loyalty,usefulness)
  values ('content-actor-contract', v_member, 'Service Member Target', 4, 4, 4);
  if (select count(*) from core.content_write_events
    where user_id = v_member and action = 'create:core.teacher_reviews') <> v_count + 1 then
    raise exception 'Service review did not consume exactly one actor quota';
  end if;
  perform pg_temp.expect_actor_denied(format(
    'insert into pg_temp.content_actor_storage_fixture(bucket_id,name,owner_id,metadata) values(%L,%L,%L,''{"size":1}'')',
    'mini-app-uploads', v_guest || '/shared', v_guest
  ), 'content_account_unverified');
  foreach v_action in array array['note-media', 'story-media', 'iskra-photos'] loop
    perform pg_temp.expect_actor_denied(format(
      'insert into pg_temp.content_actor_storage_fixture(bucket_id,name,owner_id,metadata) values(%L,%L,%L,''{"size":1}'')',
      v_action, v_guest || '/personal-' || v_action, v_guest
    ), 'content_account_unverified');
  end loop;
  insert into pg_temp.content_actor_storage_fixture(bucket_id,name,owner_id,metadata)
  values ('mini-app-uploads', v_member || '/shared', v_member::text, '{"size":1}'),
    ('note-media', v_new || '/personal', v_new::text, '{"size":1}'),
    ('story-media', 'trusted-ingestion', null, '{"size":1}');

  update auth.users set banned_until = clock_timestamp() + interval '1 hour' where id = v_member;
  perform pg_temp.expect_actor_denied(format(
    'select core.enforce_content_write_limit(%L,10,20,30,p_user_id => %L)',
    'edit:user_private.user_preferences', v_member
  ));
  perform pg_temp.expect_actor_denied(format(
    'insert into core.teacher_reviews(organization_id,user_id,teacher_name,clarity,loyalty,usefulness) values(%L,%L,%L,1,1,1)',
    'content-actor-contract', v_member, 'Banned Service Target'
  ));
  update auth.users set banned_until = null, deleted_at = clock_timestamp() where id = v_member;
  perform pg_temp.expect_actor_denied(format(
    'select internal.require_content_actor(%L,false)', v_member
  ));
end;
$$;

rollback;
