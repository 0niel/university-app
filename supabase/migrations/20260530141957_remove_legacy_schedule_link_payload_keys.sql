do $$
declare
  v_definition text;
begin
  select pg_get_functiondef(
    'ingest_v1.upsert_schedule_payload(text,jsonb,jsonb,uuid)'::regprocedure
  )
  into v_definition;

  v_definition := replace(
    v_definition,
    '''calendar_feed'', coalesce(v_target ->> ''calendar_feed_url'', v_target ->> ''source_feed_url'', v_target ->> ''ical_url'', v_target ->> ''iCalLink'')',
    '''calendar_feed'', coalesce(v_target ->> ''calendar_feed_url'', v_target ->> ''source_feed_url'')'
  );

  v_definition := replace(
    v_definition,
    '''preview_image'', coalesce(v_target ->> ''preview_image_url'', v_target ->> ''schedule_image_url'', v_target ->> ''scheduleImageLink'')',
    '''preview_image'', v_target ->> ''preview_image_url'''
  );

  v_definition := replace(
    v_definition,
    '''update_preview_image'', coalesce(v_target ->> ''update_preview_image_url'', v_target ->> ''schedule_update_image_url'', v_target ->> ''scheduleUpdateImageLink'')',
    '''update_preview_image'', v_target ->> ''update_preview_image_url'''
  );

  v_definition := replace(
    v_definition,
    '''web'', coalesce(v_target ->> ''web_url'', v_target ->> ''ui_url'', v_target ->> ''scheduleUIAddToCalendarLink'')',
    '''web'', v_target ->> ''web_url'''
  );

  execute v_definition;
end;
$$;
