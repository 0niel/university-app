begin;

do $$
begin
  if has_function_privilege(
    'anon',
    'public.create_group_post(text,text,text,text,boolean)',
    'EXECUTE'
  ) or has_function_privilege(
    'anon',
    'public.add_group_link(text,text,text,text,text)',
    'EXECUTE'
  ) then
    raise exception 'Anonymous group-space mutations are exposed';
  end if;
  if not has_function_privilege(
    'authenticated',
    'public.create_group_post(text,text,text,text,boolean)',
    'EXECUTE'
  ) or not has_function_privilege(
    'authenticated',
    'public.add_group_link(text,text,text,text,text)',
    'EXECUTE'
  ) then
    raise exception 'Authenticated group-space mutation grants are missing';
  end if;
  if has_function_privilege(
    'anon',
    'public.toggle_group_post_like(uuid)',
    'EXECUTE'
  ) then
    raise exception 'Anonymous users can toggle group post likes';
  end if;
  if not has_function_privilege(
    'authenticated',
    'public.toggle_group_post_like(uuid)',
    'EXECUTE'
  ) then
    raise exception 'Authenticated like RPC grant is missing';
  end if;
  if has_function_privilege(
    'anon',
    'public.delete_group_link(uuid)',
    'EXECUTE'
  ) or not has_function_privilege(
    'authenticated',
    'public.delete_group_link(uuid)',
    'EXECUTE'
  ) then
    raise exception 'Group link delete grants are invalid';
  end if;
  if to_regclass('core.group_posts_one_announcement_idx') is null
    or to_regclass('core.group_links_one_telegram_idx') is null then
    raise exception 'Group-space singleton indexes are missing';
  end if;
end;
$$;

do $$
declare
  v_owner uuid := extensions.gen_random_uuid();
  v_member uuid := extensions.gen_random_uuid();
  v_outsider uuid := extensions.gen_random_uuid();
  v_group_id uuid := extensions.gen_random_uuid();
  v_other_group_id uuid := extensions.gen_random_uuid();
  v_post_id uuid;
  v_first_announcement uuid;
  v_second_announcement uuid;
  v_first_telegram uuid;
  v_second_telegram uuid;
  v_member_link uuid;
  v_legacy_member_link uuid;
  v_legacy_moderated_link uuid;
  v_moderated_link uuid;
  v_liked boolean;
begin
  insert into core.organizations (id, name)
  values
    ('group-space-test-a', 'Group Space Test A'),
    ('group-space-test-b', 'Group Space Test B');

  insert into auth.users (id)
  values (v_owner), (v_member), (v_outsider);

  insert into core.user_academic_profiles (
    user_id,
    organization_id,
    academic_group
  )
  values
    (v_owner, 'group-space-test-a', 'GROUP-A'),
    (v_member, 'group-space-test-a', 'GROUP-A'),
    (v_outsider, 'group-space-test-b', 'GROUP-B');

  insert into core.study_groups (
    id,
    organization_id,
    owner_id,
    name,
    join_code
  )
  values
    (
      v_group_id,
      'group-space-test-a',
      v_owner,
      'Primary group',
      'SPACEA01'
    ),
    (
      v_other_group_id,
      'group-space-test-b',
      v_outsider,
      'Other group',
      'SPACEB01'
    );

  insert into core.study_group_members (group_id, user_id, role)
  values
    (v_group_id, v_owner, 'owner'),
    (v_group_id, v_member, 'member'),
    (v_other_group_id, v_outsider, 'owner');

  perform set_config('request.jwt.claim.role', 'authenticated', true);
  perform set_config('request.jwt.claim.sub', v_owner::text, true);

  v_post_id := app_api_v1.create_group_post(
    'group-space-test-a',
    'Shared note',
    'Body',
    'note',
    false
  );

  v_first_announcement := app_api_v1.create_group_post(
    'group-space-test-a',
    'First announcement',
    '',
    'announcement',
    true
  );
  v_second_announcement := app_api_v1.create_group_post(
    'group-space-test-a',
    'Second announcement',
    '',
    'announcement',
    true
  );
  if v_first_announcement <> v_second_announcement
    or (
      select count(*)
      from core.group_posts
      where group_id = v_group_id and kind = 'announcement'
    ) <> 1 then
    raise exception 'Announcements are not updated atomically';
  end if;

  v_first_telegram := app_api_v1.add_group_link(
    'group-space-test-a',
    'Chat',
    'https://t.me/group_a',
    '✈️',
    'telegram'
  );
  v_second_telegram := app_api_v1.add_group_link(
    'group-space-test-a',
    'Updated chat',
    'https://telegram.me/group_a',
    '✈️',
    'telegram'
  );
  if v_first_telegram <> v_second_telegram
    or (
      select count(*)
      from core.group_links
      where group_id = v_group_id and kind = 'telegram'
    ) <> 1 then
    raise exception 'Telegram link is not a singleton';
  end if;

  begin
    perform app_api_v1.add_group_link(
      'group-space-test-a',
      'Spoofed chat',
      'https://example.com/?next=t.me/group_a',
      '✈️',
      'telegram'
    );
    raise exception 'Spoofed Telegram link was accepted';
  exception
    when invalid_parameter_value then null;
  end;

  perform set_config('request.jwt.claim.sub', v_member::text, true);
  begin
    perform app_api_v1.create_group_post(
      'group-space-test-a',
      'Pinned by member',
      '',
      'note',
      true
    );
    raise exception 'A member created pinned content';
  exception
    when insufficient_privilege then null;
  end;
  begin
    perform app_api_v1.add_group_link(
      'group-space-test-a',
      'Member chat',
      'https://t.me/member_chat',
      '✈️',
      'telegram'
    );
    raise exception 'A member replaced the primary Telegram link';
  exception
    when insufficient_privilege then null;
  end;

  v_member_link := app_api_v1.add_group_link(
    'group-space-test-a',
    'Shared resource',
    'https://example.com/resource',
    '🔗',
    'link'
  );
  execute 'set local role authenticated';
  begin
    perform public.delete_group_link(v_first_telegram);
    raise exception 'A member deleted the owner Telegram link';
  exception
    when insufficient_privilege then null;
  end;
  perform public.delete_group_link(v_member_link);
  execute 'reset role';
  if exists (
    select 1 from core.group_links where id = v_member_link
  ) then
    raise exception 'A member could not delete their own link';
  end if;

  insert into core.group_links (
    organization_id,
    academic_group,
    kind,
    title,
    url,
    created_by
  )
  values (
    'group-space-test-a',
    'GROUP-A',
    'link',
    'Legacy member resource',
    'https://example.com/legacy-member',
    v_member
  )
  returning id into v_legacy_member_link;
  execute 'set local role authenticated';
  perform public.delete_group_link(v_legacy_member_link);
  execute 'reset role';
  if exists (
    select 1 from core.group_links where id = v_legacy_member_link
  ) then
    raise exception 'A member could not delete their own legacy link';
  end if;

  v_moderated_link := app_api_v1.add_group_link(
    'group-space-test-a',
    'Moderated resource',
    'https://example.com/moderated',
    '🔗',
    'link'
  );
  perform set_config('request.jwt.claim.sub', v_owner::text, true);
  execute 'set local role authenticated';
  perform public.delete_group_link(v_moderated_link);
  execute 'reset role';
  if exists (
    select 1 from core.group_links where id = v_moderated_link
  ) then
    raise exception 'The group owner could not moderate a member link';
  end if;

  insert into core.group_links (
    organization_id,
    academic_group,
    kind,
    title,
    url,
    created_by
  )
  values (
    'group-space-test-a',
    'GROUP-A',
    'link',
    'Legacy moderated resource',
    'https://example.com/legacy-moderated',
    v_member
  )
  returning id into v_legacy_moderated_link;
  execute 'set local role authenticated';
  perform public.delete_group_link(v_legacy_moderated_link);
  execute 'reset role';
  if exists (
    select 1 from core.group_links where id = v_legacy_moderated_link
  ) then
    raise exception 'The group owner could not moderate a legacy link';
  end if;

  perform set_config('request.jwt.claim.sub', v_member::text, true);

  execute 'set local role authenticated';
  select public.toggle_group_post_like(v_post_id) into v_liked;
  execute 'reset role';
  if not v_liked or not exists (
    select 1
    from core.group_post_likes
    where post_id = v_post_id and user_id = v_member
  ) then
    raise exception 'A group member could not like a group-id post';
  end if;

  perform set_config('request.jwt.claim.sub', v_outsider::text, true);
  begin
    execute 'set local role authenticated';
    perform public.toggle_group_post_like(v_post_id);
    execute 'reset role';
    raise exception 'An outsider liked another group post';
  exception
    when insufficient_privilege then
      execute 'reset role';
  end;

  begin
    perform app_api_v1.add_group_link(
      'group-space-test-a',
      'Cross-tenant link',
      'https://example.com/resource',
      '🔗',
      'link'
    );
    raise exception 'Cross-tenant group link was created';
  exception
    when insufficient_privilege then null;
  end;
end;
$$;

rollback;
