begin;

create function pg_temp.expect_content_write_limit(p_sql text, p_action text)
returns void language plpgsql as $$
declare
  v_hint text;
begin
  begin
    execute p_sql;
  exception when sqlstate 'P0001' then
    get stacked diagnostics v_hint = pg_exception_hint;
    if v_hint = 'rate_limited:' || p_action then
      return;
    end if;
    raise;
  end;
  raise exception 'Content write limit was bypassed for %', p_action;
end;
$$;

create function pg_temp.expect_content_payload_limit(p_sql text)
returns void language plpgsql as $$
declare
  v_hint text;
begin
  begin
    execute p_sql;
  exception when sqlstate '22001' then
    get stacked diagnostics v_hint = pg_exception_hint;
    if v_hint = 'content_too_large:core.user_semester_stats' then
      return;
    end if;
    raise;
  end;
  raise exception 'Content payload limit was bypassed';
end;
$$;

do $$
declare
  v_owner uuid := extensions.gen_random_uuid();
  v_other uuid := extensions.gen_random_uuid();
  v_guest uuid := extensions.gen_random_uuid();
  v_transfer uuid := extensions.gen_random_uuid();
  v_group uuid := extensions.gen_random_uuid();
  v_post uuid := extensions.gen_random_uuid();
  v_app uuid := extensions.gen_random_uuid();
  v_inviter uuid;
  v_inviting_group uuid;
  v_listing uuid;
  v_listing_ids uuid[] := '{}';
  v_notification_ids uuid[];
  v_note uuid;
  v_poll jsonb;
  v_questions jsonb;
  v_answers jsonb;
  v_result jsonb;
  v_i integer;
  v_count bigint;
  v_revision bigint := 0;
begin
  if has_function_privilege('authenticated', 'internal.limit_user_content_write()', 'EXECUTE')
    or has_function_privilege('anon', 'internal.limit_user_content_write()', 'EXECUTE') then
    raise exception 'Content trigger function is directly executable';
  end if;

  perform set_config('request.jwt.claim.sub', '', true);
  perform set_config('request.jwt.claims', '{}', true);

  insert into core.organizations (id, name)
  values ('content-write-contract', 'Content Write Contract'),
    ('content-write-contract-next', 'Next Organization');
  insert into auth.users (id, is_anonymous)
  values (v_owner, false), (v_other, false), (v_guest, true), (v_transfer, false);
  insert into core.user_academic_profiles (user_id, organization_id)
  values
    (v_owner, 'content-write-contract'),
    (v_other, 'content-write-contract'),
    (v_guest, 'content-write-contract'),
    (v_transfer, 'content-write-contract');
  insert into core.user_semester_stats (user_id, semester_label)
  values (v_owner, repeat('x', 2200000));
  insert into core.marketplace_listings (organization_id, seller_id, title, price, category)
  select 'content-write-contract', v_transfer, 'Transfer ' || item, 100, 'other'
  from generate_series(1, 11) item;
  insert into core.notification_inbox (user_id, kind, title, body)
  select v_owner, 'contract_bulk', 'Notification ' || item, 'Body'
  from generate_series(1, 1205) item;
  insert into core.study_groups (id, organization_id, owner_id, name, join_code)
  values (v_group, 'content-write-contract', v_owner, 'Contract Group', 'CONT1234');
  insert into core.study_group_members (group_id, user_id, role)
  values (v_group, v_owner, 'owner'), (v_group, v_other, 'member'), (v_group, v_guest, 'member');
  delete from core.study_group_members where user_id = v_other;
  for v_i in 1..121 loop
    v_inviter := extensions.gen_random_uuid();
    v_inviting_group := extensions.gen_random_uuid();
    insert into auth.users (id, is_anonymous) values (v_inviter, false);
    insert into core.user_academic_profiles (user_id, organization_id)
    values (v_inviter, 'content-write-contract');
    insert into core.study_groups (id, organization_id, owner_id, name, join_code)
    values (
      v_inviting_group, 'content-write-contract', v_inviter, 'Invitation group ' || v_i,
      upper(left(v_inviting_group::text, 8))
    );
    insert into core.study_group_invites (group_id, target_user_id, created_by, kind)
    values (v_inviting_group, v_other, v_inviter, 'invite');
  end loop;
  insert into core.group_posts (
    id, organization_id, author_id, group_id, academic_group, title, body, kind
  ) values (
    v_post, 'content-write-contract', v_owner, v_group, '', 'Post', 'Body', 'note'
  );
  insert into core.mini_apps (
    id, organization_id, owner_id, slug, name, source_kind, status
  ) values (
    v_app, 'content-write-contract', v_owner, 'content-write-contract',
    'Contract app', 'hosted', 'published'
  );

  if exists (select 1 from core.content_write_events where user_id = v_owner) then
    raise exception 'Maintenance fixtures consumed a user quota';
  end if;

  perform set_config('request.jwt.claim.sub', v_owner::text, true);
  perform set_config('request.jwt.claims', jsonb_build_object(
    'sub', v_owner, 'role', 'authenticated', 'is_anonymous', false
  )::text, true);

  for v_i in 1..20 loop
    insert into core.group_post_comments (post_id, author_id, body)
    values (v_post, v_owner, 'Comment ' || v_i);
  end loop;
  perform pg_temp.expect_content_write_limit(format(
    'insert into core.group_post_comments (post_id,author_id,body) values (%L,%L,%L)',
    v_post, v_owner, 'Blocked direct insert'
  ), 'create:core.group_post_comments');
  if (select count(*) from core.group_post_comments where author_id = v_owner) <> 20 then
    raise exception 'Rejected direct insert changed the table';
  end if;
  delete from core.group_post_comments where author_id = v_owner;
  perform pg_temp.expect_content_write_limit(format(
    'select app_api_v1.add_group_post_comment(%L,%L)', v_post, 'Blocked RPC insert'
  ), 'create:core.group_post_comments');

  perform set_config('request.jwt.claim.sub', v_other::text, true);
  perform set_config('request.jwt.claims', jsonb_build_object(
    'sub', v_other, 'role', 'authenticated', 'is_anonymous', false
  )::text, true);
  perform app_api_v1.join_group_by_code('content-write-contract', 'CONT1234');
  if (select count(*) from core.study_group_invites
      where target_user_id = v_other and status = 'revoked') <> 121
    or exists (select 1 from core.content_write_events
      where user_id = v_other and action = 'edit:core.study_group_invites') then
    raise exception 'Pending invitation cleanup prevents joining a group';
  end if;
  perform app_api_v1.add_group_post_comment(v_post, 'Independent user');

  perform set_config('request.jwt.claim.sub', v_guest::text, true);
  perform set_config('request.jwt.claims', jsonb_build_object(
    'sub', v_guest, 'role', 'authenticated', 'is_anonymous', false
  )::text, true);
  for v_i in 1..6 loop
    insert into core.group_post_comments (post_id, author_id, body)
    values (v_post, v_guest, 'Guest comment ' || v_i);
  end loop;
  perform pg_temp.expect_content_write_limit(format(
    'insert into core.group_post_comments (post_id,author_id,body) values (%L,%L,%L)',
    v_post, v_guest, 'Guest forged claim'
  ), 'create:core.group_post_comments');

  perform set_config('request.jwt.claim.sub', v_owner::text, true);
  perform set_config('request.jwt.claims', jsonb_build_object(
    'sub', v_owner, 'role', 'authenticated', 'is_anonymous', false
  )::text, true);

  for v_i in 1..5 loop
    perform app_api_v1.track_mini_app_launch(v_app);
  end loop;
  update core.mini_apps set rating_avg = 4, rating_count = 1 where id = v_app;
  update core.mini_apps set name = 'Edited contract app' where id = v_app;
  if (select count(*) from core.content_write_events
      where user_id = v_owner and action = 'interact:core.mini_apps') <> 5
    or (select count(*) from core.content_write_events
      where user_id = v_owner and action = 'edit:core.mini_apps') <> 1 then
    raise exception 'Derived mini-app counters consumed content edit quota';
  end if;

  v_note := app_api_v1.create_group_note('content-write-contract', 'Autosave', 'personal');
  for v_i in 1..12 loop
    v_result := app_api_v1.save_group_note_document(
      v_note, jsonb_build_array(jsonb_build_object('insert', 'Revision ' || v_i)), v_revision
    );
    if (v_result ->> 'conflict')::boolean then
      raise exception 'Normal note autosave conflicted';
    end if;
    v_revision := (v_result ->> 'revision')::bigint;
  end loop;
  select count(*) into v_count from core.content_write_events
  where user_id = v_owner and action = 'edit:core.group_notes';
  update core.group_notes
  set updated_at = clock_timestamp(), revision = revision + 1
  where id = v_note;
  if v_count <> 12 or (select count(*) from core.content_write_events
      where user_id = v_owner and action = 'edit:core.group_notes') <> 12 then
    raise exception 'Unchanged note metadata consumed autosave quota';
  end if;

  select jsonb_agg(jsonb_build_object(
    'text', 'Question ' || question_number,
    'kind', 'multiple', 'isRequired', true,
    'options', (select jsonb_agg('Option ' || option_number) from generate_series(1, 10) option_number)
  )) into v_questions from generate_series(1, 10) question_number;
  v_poll := app_api_v1.create_poll_v2(
    'content-write-contract', 'Maximum poll', '', null, false, 'always', null, true, v_questions
  );
  if (select count(*) from core.poll_questions where poll_id = (v_poll ->> 'id')::uuid) <> 10
    or (select count(*) from core.poll_options where poll_id = (v_poll ->> 'id')::uuid) <> 100 then
    raise exception 'Valid maximum-size poll was truncated';
  end if;
  select jsonb_agg(jsonb_build_object(
    'questionId', question.id,
    'optionIds', (select jsonb_agg(option.id) from core.poll_options option where option.question_id = question.id)
  )) into v_answers from core.poll_questions question
  where question.poll_id = (v_poll ->> 'id')::uuid;
  perform app_api_v1.submit_poll_answers((v_poll ->> 'id')::uuid, v_answers);
  if (select count(*) from core.poll_answers where poll_id = (v_poll ->> 'id')::uuid) <> 100
    or (select count(*) from core.content_write_events
      where user_id = v_owner and action in ('create:core.poll_answers', 'create:core.poll_votes')) <> 100 then
    raise exception 'Poll answer mirroring consumed the write budget twice';
  end if;

  perform app_api_v1.set_user_preference('content-write-contract', '{"enabled":true}'::jsonb, null);
  perform app_api_v1.upsert_user_settings(p_theme_mode := 'dark');
  if not exists (select 1 from core.content_write_events
      where user_id = v_owner and action = 'create:user_private.user_preferences')
    or not exists (select 1 from core.content_write_events
      where user_id = v_owner and action = 'edit:user_private.user_settings') then
    raise exception 'Private user writes bypassed content limits';
  end if;

  select count(*) into v_count from core.content_write_events where user_id = v_owner;
  insert into core.notification_inbox (user_id, kind, title, body)
  values (v_other, 'contract', 'Generated notification', 'Body');
  if (select count(*) from core.content_write_events where user_id = v_owner) <> v_count then
    raise exception 'Generated notifications consumed the sender quota';
  end if;

  update core.user_semester_stats set updated_at = clock_timestamp() where user_id = v_owner;
  update core.user_semester_stats set semester_label = repeat('x', 2100000) where user_id = v_owner;
  perform pg_temp.expect_content_payload_limit(format(
    'update core.user_semester_stats set semester_label = repeat(''x'',2100001) where user_id = %L',
    v_owner
  ));
  update core.user_semester_stats set semester_label = 'Fall 2026' where user_id = v_owner;
  delete from core.user_semester_stats where user_id = v_owner;
  perform pg_temp.expect_content_payload_limit(format(
    'insert into core.user_semester_stats (user_id,semester_label) values (%L,repeat(''x'',2100000))',
    v_owner
  ));

  if to_regprocedure('public.admin_bulk_set_content_archived(text,text,uuid[],boolean)') is not null then
    perform set_config('request.jwt.claim.sub', '', true);
    perform set_config('request.jwt.claims', '{}', true);
    for v_i in 1..20 loop
      v_listing := extensions.gen_random_uuid();
      insert into core.marketplace_listings (
        id, organization_id, seller_id, title, price, category
      ) values (
        v_listing, 'content-write-contract', v_other, 'Moderation ' || v_i, 100, 'other'
      );
      v_listing_ids := v_listing_ids || v_listing;
    end loop;
    execute 'insert into core.app_admins (organization_id,user_id,role) values ($1,$2,$3)'
      using 'content-write-contract', v_owner, 'moderator';
    perform set_config('request.jwt.claim.sub', v_owner::text, true);
    perform set_config('request.jwt.claims', jsonb_build_object(
      'sub', v_owner, 'role', 'authenticated', 'is_anonymous', false
    )::text, true);
    execute 'select public.admin_bulk_set_content_archived($1,$2,$3,$4)' into v_result
      using 'content-write-contract', 'marketplace', v_listing_ids, true;
    if (v_result ->> 'updated')::integer <> 20
      or jsonb_array_length(v_result -> 'failed') <> 0
      or (select count(*) from core.content_write_events where user_id = v_owner
        and action = 'moderate:core.marketplace_listings') <> 20 then
      raise exception 'Authorized bulk moderation was partially rate limited: %', v_result;
    end if;
    execute 'delete from core.app_admins where organization_id = $1 and user_id = $2'
      using 'content-write-contract', v_owner;
    for v_i in 1..10 loop
      update core.marketplace_listings set archived_at = null where id = v_listing_ids[v_i];
    end loop;
    perform pg_temp.expect_content_write_limit(format(
      'update core.marketplace_listings set archived_at = null where id = %L', v_listing_ids[11]
    ), 'edit:core.marketplace_listings');
  end if;

  select array_agg(id) into v_notification_ids from core.notification_inbox
  where user_id = v_owner and kind = 'contract_bulk';
  perform public.mark_notification_inbox_read(v_notification_ids);
  if (select count(*) from core.notification_inbox where user_id = v_owner
      and kind = 'contract_bulk' and read_at is not null) <> 1205 then
    raise exception 'Notification backlog cannot be marked as read';
  end if;

  perform set_config('request.jwt.claim.sub', v_transfer::text, true);
  perform set_config('request.jwt.claims', jsonb_build_object(
    'sub', v_transfer, 'role', 'authenticated', 'is_anonymous', false
  )::text, true);
  update core.user_academic_profiles set organization_id = 'content-write-contract-next'
  where user_id = v_transfer;
  if (select count(*) from core.marketplace_listings
      where seller_id = v_transfer and archived_at is not null) <> 11
    or exists (select 1 from core.content_write_events
      where user_id = v_transfer and action = 'edit:core.marketplace_listings') then
    raise exception 'Organization change was blocked by dependent archival limits';
  end if;
end;
$$;

rollback;
