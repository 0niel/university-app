create or replace function core.map_patch_document(p_document jsonb, p_entity_type text, p_entity_id text, p_patch jsonb)
returns jsonb language plpgsql immutable set search_path = '' as $$
declare
  v_result jsonb := p_document;
  v_collection text;
  v_allowed text[];
  v_index integer;
  v_previous jsonb;
  v_nodes jsonb;
  v_rooms jsonb;
  v_floor jsonb;
  v_plan_changed boolean;
  v_anchors_changed boolean;
begin
  if jsonb_typeof(p_patch) is distinct from 'object' or p_patch = '{}'::jsonb
    or octet_length(p_patch::text) > 16777216 then
    raise exception 'Invalid or empty map patch' using errcode = '22023';
  end if;
  case p_entity_type
    when 'room' then
      v_collection := 'rooms';
      v_allowed := array['label','kind','description','x','y','polygon','equipment','opening_hours','menu','menu_date','expires_at','capacity','accessibility','accessible','schedule_classroom_id'];
    when 'place_create' then
      v_allowed := array['floor_id','label','kind','description','x','y','polygon','equipment','opening_hours','menu','menu_date','expires_at','capacity','accessibility','accessible','schedule_classroom_id'];
    when 'floor' then
      v_collection := 'floors';
      v_allowed := array['label','level','svg','image_url','width','height','meters_per_unit','anchors'];
    when 'campus' then
      v_allowed := array['title','short_title','address','latitude','longitude','description','opening_hours'];
    when 'graph' then
      v_allowed := array['nodes','edges'];
    when 'report' then
      v_allowed := array['category','details','source_url'];
      if coalesce(length(p_patch->>'details'), 0) not between 5 and 3000
        or coalesce(p_patch->>'category','') not in ('plan','route','accessibility','other')
        or (p_patch ? 'source_url' and coalesce(p_patch->>'source_url','') !~ '^https://[^[:space:]]+$') then
        raise exception 'Invalid map report' using errcode = '22023';
      end if;
    else raise exception 'Unsupported map entity' using errcode = '22023';
  end case;
  if exists (select 1 from jsonb_object_keys(p_patch) k where not k = any(v_allowed)) then
    raise exception 'Unsupported map patch field' using errcode = '22023';
  end if;
  if p_entity_type = 'place_create' then
    if exists (select 1 from jsonb_array_elements(p_document->'rooms') where value->>'id' = p_entity_id) then
      raise exception 'Map place id already exists' using errcode = '22023';
    end if;
    v_result := jsonb_set(p_document, '{rooms}', (p_document->'rooms') || jsonb_build_array(
      jsonb_build_object('id', p_entity_id, 'equipment', '[]'::jsonb, 'menu', '[]'::jsonb) || p_patch));
  elsif v_collection is not null then
    select (ordinality - 1)::integer into v_index
    from jsonb_array_elements(p_document->v_collection) with ordinality where value->>'id' = p_entity_id;
    if v_index is null then raise exception 'Map entity not found' using errcode = '22023'; end if;
    v_previous := p_document#>array[v_collection, v_index::text];
    v_result := jsonb_set(p_document, array[v_collection, v_index::text],
      v_previous || p_patch);
    if p_entity_type = 'floor' then
      v_plan_changed := exists (
        select 1 from unnest(array['svg','image_url','width','height']) k
        where p_patch ? k and p_patch->k is distinct from v_previous->k);
      v_anchors_changed := p_patch ? 'anchors'
        and p_patch->'anchors' is distinct from v_previous->'anchors';
      if v_plan_changed or v_anchors_changed then
        v_floor := v_previous || p_patch;
        if v_plan_changed and not p_patch ? 'anchors' then
          v_floor := jsonb_set(v_floor, '{anchors}', '[]'::jsonb);
        end if;
        v_floor := jsonb_set(v_floor, '{georeference}', jsonb_build_object(
          'status', 'community', 'method', 'community_alignment',
          'summary', 'Привязка изменена сообществом. Точность не измерена.',
          'limitations', jsonb_build_array('Опорные точки изменены вручную. Расхождения с внешними источниками не проверены.'),
          'excluded_regions', case when not v_plan_changed
            and jsonb_typeof(v_previous#>'{georeference,excluded_regions}') = 'array'
            then v_previous#>'{georeference,excluded_regions}' else '[]'::jsonb end));
        v_result := jsonb_set(v_result, array['floors',v_index::text], v_floor);
      end if;
    end if;
    if p_entity_type = 'room' and (
      (p_patch ? 'x' and p_patch->'x' is distinct from v_previous->'x')
      or (p_patch ? 'y' and p_patch->'y' is distinct from v_previous->'y')) then
      select coalesce(jsonb_agg(case when value->>'room_id' = p_entity_id then
        (case when value->>'label' = v_previous->>'label' then value - array['room_id','label']
          else value - 'room_id' end) || '{"kind":"junction"}'::jsonb
          else value end order by ordinality), '[]'::jsonb)
        into v_nodes from jsonb_array_elements(v_result#>'{graph,nodes}') with ordinality;
      v_result := jsonb_set(v_result, '{graph,nodes}', v_nodes);
      v_result := jsonb_set(v_result, array['rooms',v_index::text,'navigation_needs_review'], 'true'::jsonb);
    end if;
  elsif p_entity_type = 'campus' then
    v_result := p_document || p_patch;
  elsif p_entity_type = 'graph' then
    v_result := jsonb_set(p_document, '{graph}', (p_document->'graph') || p_patch);
    select coalesce(jsonb_agg(case when r.value->>'navigation_needs_review' = 'true'
      and exists(select 1 from jsonb_array_elements(v_result#>'{graph,nodes}') n
        where n->>'room_id' = r.value->>'id') then r.value - 'navigation_needs_review'
      else r.value end order by r.ordinality), '[]'::jsonb)
      into v_rooms from jsonb_array_elements(v_result->'rooms') with ordinality as r(value,ordinality);
    v_result := jsonb_set(v_result, '{rooms}', v_rooms);
  end if;
  perform core.map_validate_document(v_result);
  return v_result;
end;
$$;

revoke all on function core.map_patch_document(jsonb,text,text,jsonb) from public, anon, authenticated;
