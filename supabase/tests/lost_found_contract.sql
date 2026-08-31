begin;

do $$
declare
  v_function text;
begin
  foreach v_function in array array[
    'app_api_v1.get_lost_found_items(text,text,text,uuid,integer,integer)',
    'app_api_v1.get_lost_found_item(uuid)',
    'app_api_v1.count_lost_found_items(text,text,text,uuid)',
    'app_api_v1.create_lost_found_item(text,text,text,text,text,text,text,text,text,jsonb)',
    'app_api_v1.create_lost_found_item(text,text,text,text,text,text,text,text,text,jsonb,boolean)',
    'app_api_v1.create_lost_found_item(text,text,text,text,text,text,text,text,text,jsonb,boolean,uuid)',
    'app_api_v1.update_lost_found_item(uuid,text,text,text,text,text,text,text)',
    'app_api_v1.delete_lost_found_item(uuid)',
    'app_api_v1.cancel_lost_found_item(uuid)',
    'app_api_v1.reserve_lost_found_image_uploads(text,jsonb)',
    'app_api_v1.release_lost_found_image_uploads(jsonb)',
    'app_api_v1.get_lost_found_image_cleanup_paths()',
    'app_api_v1.ack_lost_found_image_cleanup(jsonb)'
  ] loop
    if has_function_privilege('anon', v_function, 'EXECUTE')
      or has_function_privilege('authenticated', v_function, 'EXECUTE')
      or not has_function_privilege('service_role', v_function, 'EXECUTE')
    then
      raise exception 'Internal lost and found privileges are invalid: %',
        v_function;
    end if;
  end loop;

  foreach v_function in array array[
    'public.get_lost_found_items(text,text,text,uuid,integer,integer)',
    'public.get_lost_found_item(uuid)',
    'public.count_lost_found_items(text,text,text,uuid)',
    'public.create_lost_found_item(text,text,text,text,text,text,text,text,text,jsonb)',
    'public.create_lost_found_item(text,text,text,text,text,text,text,text,text,jsonb,boolean)',
    'public.create_lost_found_item(text,text,text,text,text,text,text,text,text,jsonb,boolean,uuid)',
    'public.update_lost_found_item(uuid,text,text,text,text,text,text,text)',
    'public.delete_lost_found_item(uuid)',
    'public.cancel_lost_found_item(uuid)',
    'public.reserve_lost_found_image_uploads(text,jsonb)',
    'public.release_lost_found_image_uploads(jsonb)',
    'public.get_lost_found_image_cleanup_paths()',
    'public.ack_lost_found_image_cleanup(jsonb)'
  ] loop
    if has_function_privilege('anon', v_function, 'EXECUTE')
      or not has_function_privilege('authenticated', v_function, 'EXECUTE')
      or not (
        select function.prosecdef
        from pg_proc function
        where function.oid = v_function::regprocedure
      )
    then
      raise exception 'Public lost and found privileges are invalid: %',
        v_function;
    end if;
  end loop;

  if has_table_privilege(
    'authenticated', 'core.lost_found_items', 'SELECT'
  ) or has_table_privilege(
    'authenticated', 'core.lost_found_items', 'INSERT'
  ) or has_table_privilege(
    'authenticated', 'core.lost_found_items', 'UPDATE'
  ) or has_table_privilege(
    'authenticated', 'core.lost_found_items', 'DELETE'
  ) then
    raise exception 'Direct lost and found table access is still available';
  end if;

  if has_table_privilege(
    'authenticated', 'core.lost_found_upload_tickets', 'SELECT,INSERT,UPDATE,DELETE'
  ) or has_table_privilege(
    'authenticated',
    'core.lost_found_image_cleanup_queue',
    'SELECT,INSERT,UPDATE,DELETE'
  ) then
    raise exception 'Direct lost and found lifecycle access is available';
  end if;

  if not exists (
    select 1
    from storage.buckets bucket
    where bucket.id = 'lost-found-images'
      and not bucket.public
      and bucket.file_size_limit = 8388608
      and bucket.allowed_mime_types =
        array['image/jpeg', 'image/png', 'image/webp']
  ) then
    raise exception 'Private lost and found bucket is not reproducible';
  end if;
end;
$$;

do $$
declare
  v_author uuid := extensions.gen_random_uuid();
  v_viewer uuid := extensions.gen_random_uuid();
  v_outsider uuid := extensions.gen_random_uuid();
  v_public_id uuid;
  v_private_id uuid;
  v_idempotent_id uuid := extensions.gen_random_uuid();
  v_public_path text;
  v_private_path text;
  v_rows jsonb;
  v_row jsonb;
  v_deleted_paths jsonb;
begin
  insert into core.organizations (id, name)
  values
    ('lost-found-test-a', 'Lost Found Test A'),
    ('lost-found-test-b', 'Lost Found Test B');

  insert into auth.users (id)
  values (v_author), (v_viewer), (v_outsider);

  insert into core.user_academic_profiles (
    user_id,
    organization_id,
    full_name,
    academic_group,
    handle
  ) values
    (v_author, 'lost-found-test-a', 'Author User', 'A-01', 'author_user'),
    (v_viewer, 'lost-found-test-a', 'Viewer User', 'A-02', 'viewer_user'),
    (v_outsider, 'lost-found-test-b', 'Outside User', 'B-01', 'outside_user');

  perform set_config('request.jwt.claim.role', 'authenticated', true);
  perform set_config('request.jwt.claim.sub', v_outsider::text, true);
  begin
    perform app_api_v1.get_lost_found_items('lost-found-test-a');
    raise exception 'Foreign lost and found board was enumerable';
  exception
    when insufficient_privilege then null;
  end;
  begin
    perform app_api_v1.create_lost_found_item(
      'lost-found-test-a',
      'Cross tenant',
      'lost',
      '',
      '@outside_user',
      null,
      'spoofed@example.test',
      'other',
      '',
      '[]'::jsonb,
      true
    );
    raise exception 'Cross-organization lost item was created';
  exception
    when insufficient_privilege then null;
  end;

  perform set_config('request.jwt.claim.sub', v_author::text, true);
  v_public_path := v_author::text || '/100_0.jpg';
  v_private_path := v_author::text || '/101_0.png';

  if internal.can_upload_lost_found_image(v_public_path) then
    raise exception 'Unreserved lost and found upload was allowed';
  end if;
  if internal.can_delete_lost_found_image(v_public_path) then
    raise exception 'Untracked lost and found image was deletable';
  end if;

  perform app_api_v1.create_lost_found_item(
    'lost-found-test-a',
    'Idempotent item',
    'lost',
    '',
    '@author_user',
    null,
    '',
    'other',
    '',
    '[]'::jsonb,
    false,
    v_idempotent_id
  );
  perform app_api_v1.create_lost_found_item(
    'lost-found-test-a',
    'Idempotent item',
    'lost',
    '',
    '@author_user',
    null,
    '',
    'other',
    '',
    '[]'::jsonb,
    false,
    v_idempotent_id
  );
  if (
    select count(*) from core.lost_found_items item
    where item.id = v_idempotent_id
  ) <> 1 then
    raise exception 'Idempotent lost and found create duplicated a row';
  end if;
  perform app_api_v1.cancel_lost_found_item(v_idempotent_id);
  perform app_api_v1.reserve_lost_found_image_uploads(
    'lost-found-test-a', jsonb_build_array(v_public_path, v_private_path)
  );
  if not internal.can_upload_lost_found_image(v_public_path) then
    raise exception 'Reserved lost and found upload was rejected';
  end if;
  if not internal.can_delete_lost_found_image(v_public_path) then
    raise exception 'Reserved lost and found upload was not removable';
  end if;

  begin
    perform app_api_v1.create_lost_found_item(
      'lost-found-test-a',
      'Tracking image',
      'found',
      '',
      '@author_user',
      null,
      '',
      'other',
      '',
      '["https://tracker.invalid/pixel.jpg"]'::jsonb,
      true
    );
    raise exception 'External image URL was accepted';
  exception
    when invalid_parameter_value then null;
  end;

  select (result->>'id')::uuid into v_public_id
  from (
    select app_api_v1.create_lost_found_item(
      'lost-found-test-a',
      'Keys',
      'found',
      'Near the library',
      '@author_user',
      '+7 999 123-45-67',
      'spoofed@example.test',
      'keys',
      'Library',
      jsonb_build_array(v_public_path),
      true
    ) result
  ) created;

  select (result->>'id')::uuid into v_private_id
  from (
    select app_api_v1.create_lost_found_item(
      'lost-found-test-a',
      'Notebook',
      'lost',
      '',
      '@author_user',
      null,
      'spoofed@example.test',
      'custom_category',
      '',
      jsonb_build_array(v_private_path)
    ) result
  ) created;

  if exists (
    select 1
    from core.lost_found_items item
    where item.id in (v_public_id, v_private_id)
      and item.author_email <> ''
  ) then
    raise exception 'Client-supplied author email was persisted';
  end if;
  if internal.can_upload_lost_found_image(v_public_path) then
    raise exception 'Consumed lost and found upload ticket remained active';
  end if;
  if internal.can_delete_lost_found_image(v_public_path) then
    raise exception 'Active lost and found image was directly deletable';
  end if;

  perform set_config('request.jwt.claim.sub', v_viewer::text, true);
  select app_api_v1.get_lost_found_items('lost-found-test-a') into v_rows;
  if jsonb_array_length(v_rows) <> 2
    or not exists (
      select 1
      from jsonb_array_elements(v_rows) item
      where item->>'id' = v_public_id::text
        and item->>'authorName' = 'Author U.'
        and item->>'telegramContactInfo' = '@author_user'
        and item->>'phoneNumberContactInfo' = '+7 999 123-45-67'
        and (item->>'showContact')::boolean
        and not item ? 'authorEmail'
    )
    or not exists (
      select 1
      from jsonb_array_elements(v_rows) item
      where item->>'id' = v_private_id::text
        and item->>'telegramContactInfo' is null
        and item->>'phoneNumberContactInfo' is null
        and not (item->>'showContact')::boolean
        and not item ? 'authorEmail'
    )
  then
    raise exception 'Lost and found contact privacy contract is invalid';
  end if;

  select app_api_v1.get_lost_found_item(v_public_id) into v_row;
  if v_row->>'id' <> v_public_id::text
    or app_api_v1.count_lost_found_items(
      'lost-found-test-a', 'found', 'key', null
    ) <> 1
  then
    raise exception 'Exact get or count contract is invalid';
  end if;

  if not internal.can_read_lost_found_image(v_public_path)
    or internal.can_read_lost_found_image(v_private_path) is not true
  then
    raise exception 'Same-organization image access is unavailable';
  end if;

  begin
    perform app_api_v1.update_lost_found_item(
      v_public_id, null, null, 'lost'
    );
    raise exception 'Viewer updated another author item';
  exception
    when insufficient_privilege then null;
  end;
  begin
    perform app_api_v1.delete_lost_found_item(v_public_id);
    raise exception 'Viewer deleted another author item';
  exception
    when insufficient_privilege then null;
  end;

  perform set_config('request.jwt.claim.sub', v_outsider::text, true);
  if internal.can_read_lost_found_image(v_public_path) then
    raise exception 'Foreign organization image was readable';
  end if;

  perform set_config('request.jwt.claim.sub', v_author::text, true);
  perform app_api_v1.update_lost_found_item(
    v_public_id, null, null, 'lost'
  );
  begin
    perform app_api_v1.update_lost_found_item(
      v_public_id, null, null, null, '', ''
    );
    raise exception 'Public contact item lost every contact';
  exception
    when invalid_parameter_value then null;
  end;
  begin
    perform app_api_v1.update_lost_found_item(
      v_public_id, null, null, null, 'https://tracker.invalid'
    );
    raise exception 'Unsafe Telegram contact was accepted';
  exception
    when invalid_parameter_value then null;
  end;
  select app_api_v1.delete_lost_found_item(v_public_id)
  into v_deleted_paths;
  if v_deleted_paths <> jsonb_build_array(v_public_path)
    or exists (
      select 1 from core.lost_found_items item
      where item.id = v_public_id
    )
  then
    raise exception 'Author lifecycle or cleanup paths are invalid';
  end if;
  if not internal.can_delete_lost_found_image(v_public_path) then
    raise exception 'Queued lost and found image was not removable';
  end if;

  update core.user_academic_profiles profile
  set organization_id = 'lost-found-test-b'
  where profile.user_id = v_author;
  if (
    select item.archived_at
    from core.lost_found_items item
    where item.id = v_private_id
  ) is null then
    raise exception 'Organization change left an active lost item';
  end if;
  if app_api_v1.get_lost_found_image_cleanup_paths()
    <> jsonb_build_array(v_public_path, v_private_path)
  then
    raise exception 'Lost and found cleanup queue lost lifecycle paths';
  end if;
  begin
    perform app_api_v1.get_lost_found_items('lost-found-test-a');
    raise exception 'Former organization author enumerated old items';
  exception
    when insufficient_privilege then null;
  end;
end;
$$;

rollback;
