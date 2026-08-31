-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║ Canonical ingest: ingest_v1.upsert_schedule_payload now writes the         ║
-- ║ schedule_item model (one row per physical item, edges, skinny occurrences) ║
-- ║ instead of schedule_parts / part_dates / schedule_occurrences. The same    ║
-- ║ public.ingest_schedule_payload wrapper + /ingest edge function keep        ║
-- ║ feeding it. content_hash folds in teachers/rooms/groups so the change      ║
-- ║ trigger detects room/teacher/поток changes (not just subject/time).        ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

create or replace function ingest_v1.upsert_schedule_payload(
  p_organization_id text, p_source jsonb, p_targets jsonb, p_sync_run_id uuid default null
) returns jsonb language plpgsql set search_path = '' as $$
declare
  v_target jsonb; v_part jsonb; v_el jsonb;
  v_target_type text; v_external_id text; v_target_title text; v_full_title text;
  v_target_source_links jsonb; v_target_id uuid;
  v_kind text; v_dates date[]; v_date date; v_date_value jsonb;
  v_lesson_bells jsonb; v_teachers jsonb; v_classrooms jsonb; v_group_entities jsonb;
  v_source_uid text; v_subject text; v_discipline_id uuid; v_term_id int;
  v_item_id uuid; v_content_hash text; v_eid uuid; v_grp text;
  v_start time; v_end time;
  v_received int := 0; v_targets_up int := 0; v_items int := 0; v_skipped int := 0; v_occ int := 0;
begin
  if jsonb_typeof(p_targets) is distinct from 'array' then
    return jsonb_build_object('error', 'targets must be an array');
  end if;

  for v_target in select value from jsonb_array_elements(p_targets) loop
    v_received := v_received + 1;
    v_target_type := ingest_v1.normalize_schedule_target_type(v_target);
    v_external_id := coalesce(nullif(trim(v_target ->> 'external_id'), ''), nullif(trim(v_target ->> 'id'), ''), nullif(trim(v_target ->> 'uid'), ''));
    v_target_title := coalesce(nullif(trim(v_target ->> 'target_title'), ''), nullif(trim(v_target ->> 'full_title'), ''), nullif(trim(v_target ->> 'title'), ''));
    v_full_title := coalesce(nullif(trim(v_target ->> 'full_title'), ''), v_target_title);
    if v_target_type is null or v_external_id is null or v_target_title is null then
      v_skipped := v_skipped + 1; continue;
    end if;

    v_target_source_links := coalesce(v_target -> 'source_links', '{}'::jsonb);
    if jsonb_typeof(v_target_source_links) is distinct from 'object' then v_target_source_links := '{}'::jsonb; end if;

    insert into core.schedule_targets (organization_id, target_type, external_id, target_title, full_title, source_links, is_active, last_synced_at, metadata)
    values (p_organization_id, v_target_type, v_external_id, v_target_title, v_full_title, v_target_source_links, true, now(), coalesce(v_target -> 'metadata', '{}'::jsonb))
    on conflict (organization_id, target_type, external_id) do update
      set target_title = excluded.target_title, full_title = excluded.full_title,
          source_links = core.schedule_targets.source_links || excluded.source_links,
          is_active = true, last_synced_at = now(),
          metadata = core.schedule_targets.metadata || excluded.metadata
    returning id into v_target_id;
    v_targets_up := v_targets_up + 1;

    if jsonb_typeof(v_target -> 'parts') is distinct from 'array' then continue; end if;

    for v_part in select value from jsonb_array_elements(v_target -> 'parts') loop
      v_kind := case
        when coalesce(v_part ->> 'part_type', v_part ->> 'type') in ('lesson', '__lesson_schedule__') then 'lesson'
        when coalesce(v_part ->> 'part_type', v_part ->> 'type') in ('holiday', '__holiday__') then 'holiday'
        when coalesce(v_part ->> 'part_type', v_part ->> 'type') in ('event', 'exam', 'deadline', 'note', 'custom') then coalesce(v_part ->> 'part_type', v_part ->> 'type')
        when coalesce(v_part ->> 'part_type', v_part ->> 'type') = '__calendar_event__' then coalesce(v_part ->> 'kind', 'event')
        else 'unknown'
      end;

      v_dates := array[]::date[];
      if jsonb_typeof(v_part -> 'dates') = 'array' then
        for v_date_value in select value from jsonb_array_elements(v_part -> 'dates') loop
          v_date := ingest_v1.parse_schedule_date(trim(both '"' from v_date_value::text));
          if v_date is not null then v_dates := array_append(v_dates, v_date); end if;
        end loop;
      end if;
      if coalesce(array_length(v_dates, 1), 0) = 0 then v_skipped := v_skipped + 1; continue; end if;
      v_dates := (select array_agg(distinct d order by d) from unnest(v_dates) d);

      v_term_id := core.term_for_date(p_organization_id, v_dates[1]);
      if v_term_id is null then v_skipped := v_skipped + 1; continue; end if;

      v_lesson_bells := coalesce(v_part -> 'lesson_bells', v_part -> 'lessonBells', '{}'::jsonb);
      v_teachers := coalesce(v_part -> 'teachers', '[]'::jsonb);       if jsonb_typeof(v_teachers) <> 'array' then v_teachers := '[]'::jsonb; end if;
      v_classrooms := coalesce(v_part -> 'classrooms', '[]'::jsonb);   if jsonb_typeof(v_classrooms) <> 'array' then v_classrooms := '[]'::jsonb; end if;
      v_group_entities := coalesce(v_part -> 'group_entities', v_part -> 'groupEntities', '[]'::jsonb);
      if jsonb_typeof(v_group_entities) <> 'array' then v_group_entities := '[]'::jsonb; end if;

      v_source_uid := nullif(trim(coalesce(v_part ->> 'uid', v_part ->> 'external_id', '')), '');
      if v_source_uid is null then
        v_source_uid := md5(v_target_id::text || ':' || coalesce(v_part ->> 'type', '') || ':' ||
          coalesce(v_part ->> 'subject', v_part ->> 'title', '') || ':' || array_to_string(v_dates, ','));
      end if;
      v_subject := coalesce(nullif(trim(v_part ->> 'subject'), ''), nullif(trim(v_part ->> 'title'), ''), '—');
      v_discipline_id := case when v_kind = 'lesson' then ingest_v1.upsert_schedule_discipline(p_organization_id, v_subject, null, '{}'::jsonb) else null end;
      v_start := nullif(coalesce(v_lesson_bells ->> 'start_time', v_lesson_bells ->> 'startTime'), '')::time;
      v_end   := nullif(coalesce(v_lesson_bells ->> 'end_time', v_lesson_bells ->> 'endTime'), '')::time;

      v_content_hash := md5(
        v_kind || '|' || v_subject || '|' || coalesce(v_lesson_bells ->> 'number', '') || '|' ||
        coalesce(v_start::text, '') || '|' || coalesce(v_end::text, '') || '|' || array_to_string(v_dates, ',') || '|' ||
        coalesce((select string_agg(e ->> 'uid', ',' order by e ->> 'uid') from jsonb_array_elements(v_teachers) e), '') || '|' ||
        coalesce((select string_agg(e ->> 'uid', ',' order by e ->> 'uid') from jsonb_array_elements(v_classrooms) e), '') || '|' ||
        coalesce((select string_agg(e ->> 'name', ',' order by e ->> 'name') from jsonb_array_elements(v_group_entities) e), '')
      );

      insert into core.schedule_item (
        organization_id, term_id, source_uid, kind, title, lesson_type, lesson_number,
        discipline_id, start_time, end_time, is_all_day, attributes, dates, content_hash, updated_at)
      values (
        p_organization_id, v_term_id, v_source_uid, v_kind, v_subject,
        case when v_kind = 'lesson' then nullif(trim(coalesce(v_part ->> 'lesson_type', v_part ->> 'lessonType')), '') end,
        nullif(v_lesson_bells ->> 'number', '')::int, v_discipline_id, v_start, v_end,
        coalesce((v_part ->> 'is_all_day')::boolean, false),
        case when v_kind not in ('lesson', 'holiday') then jsonb_strip_nulls(jsonb_build_object(
          'description', v_part ->> 'description', 'location', v_part ->> 'location',
          'starts_at', v_part ->> 'starts_at', 'ends_at', v_part ->> 'ends_at', 'source_links', v_part -> 'source_links')) end,
        v_dates, v_content_hash, now())
      on conflict (organization_id, term_id, source_uid) do update
        set kind = excluded.kind, title = excluded.title, lesson_type = excluded.lesson_type,
            lesson_number = excluded.lesson_number, discipline_id = excluded.discipline_id,
            start_time = excluded.start_time, end_time = excluded.end_time, is_all_day = excluded.is_all_day,
            attributes = excluded.attributes, dates = excluded.dates, content_hash = excluded.content_hash, updated_at = now()
        where core.schedule_item.content_hash is distinct from excluded.content_hash
      returning id into v_item_id;

      if v_item_id is null then
        select id into v_item_id from core.schedule_item
        where organization_id = p_organization_id and term_id = v_term_id and source_uid = v_source_uid;
      end if;
      v_items := v_items + 1;

      delete from core.schedule_item_teacher where item_id = v_item_id;
      delete from core.schedule_item_classroom where item_id = v_item_id;
      delete from core.schedule_item_group where item_id = v_item_id;

      for v_el in select value from jsonb_array_elements(v_teachers) loop
        v_eid := ingest_v1.upsert_schedule_teacher(p_organization_id, nullif(trim(v_el ->> 'name'), ''), nullif(trim(v_el ->> 'uid'), ''), v_el);
        if v_eid is not null then insert into core.schedule_item_teacher(item_id, teacher_id) values (v_item_id, v_eid) on conflict do nothing; end if;
      end loop;
      for v_el in select value from jsonb_array_elements(v_classrooms) loop
        v_eid := ingest_v1.upsert_schedule_classroom(p_organization_id, nullif(trim(v_el ->> 'name'), ''), nullif(trim(v_el ->> 'uid'), ''),
                   v_el -> 'campus' ->> 'name', v_el -> 'campus' ->> 'short_name', nullif(trim(v_el -> 'campus' ->> 'uid'), ''), v_el);
        if v_eid is not null then insert into core.schedule_item_classroom(item_id, classroom_id) values (v_item_id, v_eid) on conflict do nothing; end if;
      end loop;
      for v_el in select value from jsonb_array_elements(v_group_entities) loop
        v_eid := ingest_v1.upsert_schedule_group(p_organization_id, nullif(trim(v_el ->> 'name'), ''), nullif(trim(v_el ->> 'uid'), ''), v_el);
        if v_eid is not null then insert into core.schedule_item_group(item_id, group_id) values (v_item_id, v_eid) on conflict do nothing; end if;
      end loop;
      if jsonb_array_length(v_group_entities) = 0 and jsonb_typeof(v_part -> 'groups') = 'array' then
        for v_grp in select value from jsonb_array_elements_text(v_part -> 'groups') loop
          v_eid := ingest_v1.upsert_schedule_group(p_organization_id, nullif(trim(v_grp), ''), null, jsonb_build_object('name', trim(v_grp)));
          if v_eid is not null then insert into core.schedule_item_group(item_id, group_id) values (v_item_id, v_eid) on conflict do nothing; end if;
        end loop;
      end if;

      delete from core.schedule_item_occurrence where item_id = v_item_id;
      if v_start is not null then
        insert into core.schedule_item_occurrence (item_id, term_id, lesson_date, start_time, end_time)
        select v_item_id, v_term_id, d, v_start, v_end from unnest(v_dates) d
        on conflict do nothing;
        v_occ := v_occ + array_length(v_dates, 1);
      end if;
    end loop;
  end loop;

  return jsonb_build_object('organization_id', p_organization_id, 'targets_received', v_received,
    'targets_upserted', v_targets_up, 'items_upserted', v_items, 'items_skipped', v_skipped, 'occurrences_upserted', v_occ);
end; $$;
