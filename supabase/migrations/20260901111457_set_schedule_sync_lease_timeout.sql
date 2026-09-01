do $$
declare
  v_definition text;
  v_updated text;
begin
  select pg_get_functiondef(
    'ingest_v1.begin_content_sync(text,text,text,jsonb)'::regprocedure
  )
  into v_definition;

  v_updated := replace(
    v_definition,
    'and started_at < now() - interval ''1 hour'';',
    'and started_at < now() - case when v_source_type = ''schedule'' then interval ''40 minutes'' else interval ''1 hour'' end;'
  );

  if v_updated = v_definition then
    raise exception 'Schedule sync lease definition was not updated';
  end if;

  execute v_updated;
end;
$$;
