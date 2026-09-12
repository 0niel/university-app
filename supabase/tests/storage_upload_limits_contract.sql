begin;
set local statement_timeout = '20s';
set local lock_timeout = '3s';

create temporary table storage_upload_fixture
(like storage.objects including defaults);
create trigger enforce_storage_upload_limits
after insert or update on storage_upload_fixture
for each row execute function core.enforce_storage_upload_limits();
grant select, insert, update, delete on storage_upload_fixture
to authenticated, service_role;

do $$
declare
  v_user uuid := extensions.gen_random_uuid();
  v_bytes_user uuid := extensions.gen_random_uuid();
  v_guest uuid := extensions.gen_random_uuid();
  v_markers_user uuid := extensions.gen_random_uuid();
  v_file uuid;
  v_count bigint;
  v_bytes bigint;
  v_hint text;
  v_size bigint := 104857600;
begin
  if not exists (
    select 1 from pg_trigger
    where tgrelid = 'storage.objects'::regclass
      and tgname = 'enforce_storage_upload_limits'
      and tgfoid = 'core.enforce_storage_upload_limits()'::regprocedure
      and tgenabled = 'O' and tgtype = 21
  ) then
    raise exception 'Storage upload trigger is not enabled for inserts and updates';
  end if;
  if has_function_privilege('anon', 'core.enforce_storage_upload_limits()', 'EXECUTE')
    or has_function_privilege('authenticated', 'core.enforce_storage_upload_limits()', 'EXECUTE')
    or has_function_privilege('service_role', 'core.enforce_storage_upload_limits()', 'EXECUTE') then
    raise exception 'Storage limiter is directly callable';
  end if;

  insert into auth.users (id, is_anonymous)
  values (v_user, false), (v_bytes_user, false), (v_guest, true),
    (v_markers_user, false);

  perform set_config('request.jwt.claim.sub', v_user::text, true);
  perform set_config('request.jwt.claim.role', 'authenticated', true);
  perform set_config('request.jwt.claims', jsonb_build_object(
    'sub', v_user, 'role', 'authenticated'
  )::text, true);
  execute 'set local role authenticated';
  begin
    insert into pg_temp.storage_upload_fixture (bucket_id, name, owner_id, version, metadata)
    values ('lesson-materials', v_user || '/preflight', v_user::text, '1',
      jsonb_build_object('contentLength', v_size, 'mimetype', 'application/pdf'));
    raise exception 'Rollback permission probe' using errcode = 'PT001';
  exception when sqlstate 'PT001' then null;
  end;
  begin
    insert into pg_temp.storage_upload_fixture (bucket_id, name, owner_id, metadata)
    values ('lesson-materials', v_user || '/forged-owner', v_bytes_user::text,
      jsonb_build_object('size', 1));
    raise exception 'A caller forged another upload owner';
  exception when insufficient_privilege then null;
  end;
  begin
    insert into pg_temp.storage_upload_fixture (bucket_id, name, metadata)
    values ('lesson-materials', v_user || '/missing-owner', jsonb_build_object('size', 1));
    raise exception 'A caller bypassed the quota with an empty owner';
  exception when insufficient_privilege then null;
  end;
  execute 'reset role';
  if exists (select 1 from core.content_write_events where user_id = v_user) then
    raise exception 'A rollback permission probe consumed quota';
  end if;

  perform set_config('request.jwt.claim.sub', '', true);
  perform set_config('request.jwt.claim.role', 'service_role', true);
  perform set_config('request.jwt.claims', '{"role":"service_role"}', true);
  execute 'set local role service_role';
  insert into pg_temp.storage_upload_fixture (bucket_id, name, owner_id, version, metadata)
  values ('lesson-materials', v_user || '/final', v_user::text, 'final-1',
    jsonb_build_object('size', v_size, 'contentLength', v_size, 'eTag', 'one'))
  returning id into v_file;
  update pg_temp.storage_upload_fixture
  set version = 'final-2', metadata = jsonb_build_object(
    'size', v_size, 'contentLength', v_size, 'eTag', 'two'
  ) where id = v_file;
  update pg_temp.storage_upload_fixture
  set name = v_user || '/renamed', version = 'moved-3', last_accessed_at = now(),
    user_metadata = '{"caption":"changed"}'
  where id = v_file;
  insert into pg_temp.storage_upload_fixture (bucket_id, name, metadata)
  values ('story-media', 'trusted-ingestion', jsonb_build_object('size', v_size));
  execute 'reset role';
  select count(*), sum(byte_count) into v_count, v_bytes
  from core.content_write_events where user_id = v_user and action = 'upload_file';
  if v_count <> 2 or v_bytes <> 2 * v_size then
    raise exception 'Final service upload and overwrite were not counted exactly once: %, %',
      v_count, v_bytes;
  end if;

  execute 'set local role service_role';
  for i in 1..18 loop
    insert into pg_temp.storage_upload_fixture (bucket_id, name, owner_id, metadata)
    values (case when i % 2 = 0 then 'mini-app-uploads' else 'note-media' end,
      v_user || '/file-' || i, v_user::text, jsonb_build_object('size', 1));
  end loop;
  begin
    insert into pg_temp.storage_upload_fixture (bucket_id, name, owner_id, metadata)
    values ('room-photos', v_user || '/over-count', v_user::text, jsonb_build_object('size', 1));
    raise exception 'Final service upload bypassed the shared bucket quota';
  exception when insufficient_privilege then
    get stacked diagnostics v_hint = pg_exception_hint;
    if v_hint not like 'rate_limited:%' then raise; end if;
  end;
  execute 'reset role';
  if (select count(*) from core.content_write_events
      where user_id = v_user and action = 'upload_file') <> 20 then
    raise exception 'Rejected upload changed the successful upload count';
  end if;

  perform set_config('request.jwt.claim.sub', v_user::text, true);
  perform set_config('request.jwt.claim.role', 'authenticated', true);
  perform set_config('request.jwt.claims', jsonb_build_object(
    'sub', v_user, 'role', 'authenticated'
  )::text, true);
  execute 'set local role authenticated';
  begin
    insert into pg_temp.storage_upload_fixture (bucket_id, name, owner_id, version)
    values ('mini-app-uploads', v_user || '/signed-preflight', v_user::text, '1');
    raise exception 'Upload permission probe ignored the exhausted quota';
  exception when insufficient_privilege then
    get stacked diagnostics v_hint = pg_exception_hint;
    if v_hint not like 'rate_limited:%' then raise; end if;
  end;
  execute 'reset role';

  perform set_config('request.jwt.claim.sub', '', true);
  perform set_config('request.jwt.claim.role', 'service_role', true);
  perform set_config('request.jwt.claims', '{"role":"service_role"}', true);
  execute 'set local role service_role';
  for i in 1..10 loop
    insert into pg_temp.storage_upload_fixture (bucket_id, name, owner_id, metadata)
    values ('lesson-materials', v_bytes_user || '/full-size-' || i,
      v_bytes_user::text, jsonb_build_object('size', v_size));
  end loop;
  begin
    insert into pg_temp.storage_upload_fixture (bucket_id, name, owner_id, metadata)
    values ('lesson-materials', v_bytes_user || '/over-bytes', v_bytes_user::text,
      jsonb_build_object('size', v_size));
    raise exception 'Upload byte quota was not enforced';
  exception when insufficient_privilege then
    get stacked diagnostics v_hint = pg_exception_hint;
    if v_hint not like 'rate_limited:%' then raise; end if;
  end;
  for i in 1..3 loop
    insert into pg_temp.storage_upload_fixture (bucket_id, name, owner_id, metadata)
    values ('lesson-materials', v_guest || '/guest-' || i,
      v_guest::text, jsonb_build_object('size', v_size));
  end loop;
  begin
    insert into pg_temp.storage_upload_fixture (bucket_id, name, owner_id, metadata)
    values ('lesson-materials', v_guest || '/guest-over-bytes', v_guest::text,
      jsonb_build_object('size', v_size));
    raise exception 'Final service upload lost the anonymous account limit';
  exception when insufficient_privilege then
    get stacked diagnostics v_hint = pg_exception_hint;
    if v_hint not like 'rate_limited:%' then raise; end if;
  end;
  begin
    insert into pg_temp.storage_upload_fixture (bucket_id, name, owner_id, metadata)
    values ('lesson-materials', v_bytes_user || '/invalid-size', v_bytes_user::text,
      '{"size":-1}');
    raise exception 'Invalid upload size was accepted';
  exception when invalid_parameter_value then null;
  end;
  execute 'reset role';

  insert into pg_temp.storage_upload_fixture (
    bucket_id, name, owner_id, metadata, archived_at
  ) values ('note-media', v_markers_user || '/archived', v_markers_user::text,
    '{"size":1}', now());
  insert into pg_temp.storage_upload_fixture (
    bucket_id, name, owner_id, metadata, is_delete_marker
  ) values ('note-media', v_markers_user || '/delete-marker', v_markers_user::text,
    '{"size":1}', true);
  insert into pg_temp.storage_upload_fixture (bucket_id, name, owner, metadata)
  values ('note-media', v_markers_user || '/legacy-owner', v_markers_user,
    '{"size":1}');
  update pg_temp.storage_upload_fixture set archived_at = now(), is_delete_marker = true
  where owner = v_markers_user;
  if (select count(*) from core.content_write_events
      where user_id = v_markers_user and action = 'upload_file') <> 3 then
    raise exception 'Object flags bypassed inserts or housekeeping consumed quota';
  end if;
end;
$$;

rollback;
