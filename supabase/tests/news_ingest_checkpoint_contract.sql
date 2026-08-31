begin;

do $$
begin
  if has_function_privilege(
    'anon',
    'public.begin_content_sync(text,text,text,jsonb)',
    'EXECUTE'
  ) or has_function_privilege(
    'authenticated',
    'public.finish_content_sync(text,uuid,text,jsonb,text,jsonb)',
    'EXECUTE'
  ) then
    raise exception 'Content sync lifecycle is exposed to application roles';
  end if;
  if not has_function_privilege(
    'service_role',
    'public.begin_content_sync(text,text,text,jsonb)',
    'EXECUTE'
  ) or not has_function_privilege(
    'service_role',
    'public.finish_content_sync(text,uuid,text,jsonb,text,jsonb)',
    'EXECUTE'
  ) then
    raise exception 'Service role content sync grants are missing';
  end if;
end;
$$;

do $$
declare
  v_source jsonb := jsonb_build_object(
    'source_type', 'telegram',
    'source_external_id', 'news',
    'source_name', '@news',
    'source_url', 'https://t.me/news'
  );
  v_item jsonb := jsonb_build_array(jsonb_build_object(
    'external_id', '101',
    'title', 'First title',
    'published_at', '2026-07-11T10:00:00Z',
    'original_url', 'https://t.me/news/101',
    'raw_data', jsonb_build_object('id', 101)
  ));
  v_started jsonb;
  v_finished jsonb;
  v_run_id uuid;
  v_other_run_id uuid;
begin
  insert into core.organizations (id, name)
  values
    ('news-sync-test-a', 'News Sync Test A'),
    ('news-sync-test-b', 'News Sync Test B');

  v_started := ingest_v1.begin_content_sync(
    'news-sync-test-a',
    'telegram:news',
    'telegram',
    '{}'::jsonb
  );
  v_run_id := (v_started ->> 'sync_run_id')::uuid;
  if v_started -> 'checkpoint' <> '{}'::jsonb then
    raise exception 'A new source returned a non-empty checkpoint';
  end if;

  begin
    perform ingest_v1.begin_content_sync(
      'news-sync-test-a',
      'telegram:news',
      'telegram',
      '{}'::jsonb
    );
    raise exception 'Concurrent source synchronization was accepted';
  exception
    when object_not_in_prerequisite_state then null;
  end;

  perform public.ingest_news_items(
    'news-sync-test-a',
    v_source,
    v_item,
    v_run_id
  );
  if (
    select status
    from internal.sync_runs
    where id = v_run_id
  ) <> 'running' then
    raise exception 'Ingest finalized a run before checkpoint completion';
  end if;
  if (
    select name
    from core.organizations
    where id = 'news-sync-test-a'
  ) <> 'News Sync Test A' then
    raise exception 'Content ingest overwrote organization identity';
  end if;
  v_finished := ingest_v1.finish_content_sync(
    'news-sync-test-a',
    v_run_id,
    'succeeded',
    '{"version":1,"cursor_type":"telegram_message_id","last_message_id":101}',
    null,
    '{}'::jsonb
  );
  if not (v_finished ->> 'checkpoint_advanced')::boolean then
    raise exception 'Successful sync did not advance its checkpoint';
  end if;

  v_finished := ingest_v1.finish_content_sync(
    'news-sync-test-a',
    v_run_id,
    'failed',
    null,
    'lost response',
    '{}'::jsonb
  );
  if v_finished ->> 'status' <> 'succeeded' then
    raise exception 'A failed callback overwrote a committed sync';
  end if;

  v_started := ingest_v1.begin_content_sync(
    'news-sync-test-a',
    'telegram:news',
    'telegram',
    '{}'::jsonb
  );
  v_run_id := (v_started ->> 'sync_run_id')::uuid;
  if (v_started #>> '{checkpoint,last_message_id}')::integer <> 101 then
    raise exception 'The persisted checkpoint was not returned';
  end if;
  perform public.ingest_news_items(
    'news-sync-test-a',
    v_source,
    v_item,
    v_run_id
  );
  perform ingest_v1.finish_content_sync(
    'news-sync-test-a',
    v_run_id,
    'succeeded',
    v_started -> 'checkpoint',
    null,
    '{}'::jsonb
  );
  if (
    select count(*)
    from internal.raw_payloads
    where organization_id = 'news-sync-test-a'
      and source_type = 'telegram'
      and source_external_id = 'news'
      and external_id = '101'
  ) <> 1 then
    raise exception 'An exact raw payload retry was duplicated';
  end if;

  v_started := ingest_v1.begin_content_sync(
    'news-sync-test-a',
    'telegram:news',
    'telegram',
    '{}'::jsonb
  );
  v_run_id := (v_started ->> 'sync_run_id')::uuid;
  perform public.ingest_news_items(
    'news-sync-test-a',
    v_source,
    jsonb_set(v_item, '{0,title}', '"Edited title"'::jsonb),
    v_run_id
  );
  perform ingest_v1.finish_content_sync(
    'news-sync-test-a',
    v_run_id,
    'succeeded',
    v_started -> 'checkpoint',
    null,
    '{}'::jsonb
  );
  if (
    select count(*)
    from internal.raw_payloads
    where organization_id = 'news-sync-test-a'
      and source_type = 'telegram'
      and source_external_id = 'news'
      and external_id = '101'
  ) <> 2 then
    raise exception 'A changed raw payload version was not retained';
  end if;

  v_started := ingest_v1.begin_content_sync(
    'news-sync-test-a',
    'telegram:other',
    'telegram',
    '{}'::jsonb
  );
  v_other_run_id := (v_started ->> 'sync_run_id')::uuid;
  begin
    perform public.ingest_news_items(
      'news-sync-test-a',
      v_source,
      v_item,
      v_other_run_id
    );
    raise exception 'A cross-source sync run was accepted';
  exception
    when insufficient_privilege then null;
  end;
  perform ingest_v1.finish_content_sync(
    'news-sync-test-a',
    v_other_run_id,
    'failed',
    null,
    'test cleanup',
    '{}'::jsonb
  );

  v_started := ingest_v1.begin_content_sync(
    'news-sync-test-b',
    'telegram:news',
    'telegram',
    '{}'::jsonb
  );
  v_other_run_id := (v_started ->> 'sync_run_id')::uuid;
  begin
    perform public.ingest_news_items(
      'news-sync-test-a',
      v_source,
      v_item,
      v_other_run_id
    );
    raise exception 'A cross-tenant sync run was accepted';
  exception
    when insufficient_privilege then null;
  end;
  perform ingest_v1.finish_content_sync(
    'news-sync-test-b',
    v_other_run_id,
    'failed',
    null,
    'test cleanup',
    '{}'::jsonb
  );

  v_started := ingest_v1.begin_content_sync(
    'news-sync-test-a',
    'telegram:news',
    'telegram',
    '{}'::jsonb
  );
  v_run_id := (v_started ->> 'sync_run_id')::uuid;
  perform ingest_v1.finish_content_sync(
    'news-sync-test-a',
    v_run_id,
    'failed',
    '{"version":1,"last_message_id":999}',
    'telegram unavailable',
    '{}'::jsonb
  );
  if (
    select checkpoint #>> '{last_message_id}'
    from internal.checkpoints
    where organization_id = 'news-sync-test-a'
      and source = 'telegram:news'
  ) <> '101' then
    raise exception 'A failed sync advanced its checkpoint';
  end if;

  v_started := ingest_v1.begin_content_sync(
    'news-sync-test-a',
    'telegram:news',
    'telegram',
    '{}'::jsonb
  );
  v_run_id := (v_started ->> 'sync_run_id')::uuid;
  perform public.ingest_news_items(
    'news-sync-test-a',
    v_source,
    '[{"title":"Missing external id"}]'::jsonb,
    v_run_id
  );
  begin
    perform ingest_v1.finish_content_sync(
      'news-sync-test-a',
      v_run_id,
      'succeeded',
      '{"version":1,"last_message_id":999}',
      null,
      '{}'::jsonb
    );
    raise exception 'A partial sync advanced its checkpoint';
  exception
    when object_not_in_prerequisite_state then null;
  end;
  perform ingest_v1.finish_content_sync(
    'news-sync-test-a',
    v_run_id,
    'failed',
    null,
    'batch was partial',
    '{}'::jsonb
  );

  v_finished := internal.prune_content_sync_history(
    now() + interval '1 minute',
    now() + interval '1 minute'
  );
  if (v_finished ->> 'raw_payloads_deleted')::integer < 2
    or (v_finished ->> 'sync_runs_deleted')::integer < 1 then
    raise exception 'Content sync history retention did not prune old rows';
  end if;
end;
$$;

rollback;
