begin;

do $$
declare
  v_document jsonb := '{"title":"Alignment contract","source_url":"https://pulse.mirea.ru/services/maps","floors":[{"id":"f1","label":"1","level":1,"width":100,"height":100,"meters_per_unit":1,"svg":"<svg xmlns=\"http://www.w3.org/2000/svg\"></svg>","anchors":[{"x":0,"y":0,"latitude":55,"longitude":37},{"x":100,"y":0,"latitude":55,"longitude":37.001},{"x":0,"y":100,"latitude":55.001,"longitude":37}],"georeference":{"status":"approximate","method":"room_reference_robust_affine","checked_at":"2026-09-07T00:00:00Z","summary":"Old fitted accuracy","limitations":["Old fit limitation"],"sources":[{"label":"Old OSM control points","url":"https://www.openstreetmap.org/"}],"residuals":{"median_meters":1.2},"osm_sha256":"old-model-hash","anchor_kind":"affine_model_control_not_surveyed","future_accuracy_claim":true,"excluded_regions":[{"x":80,"y":80,"width":20,"height":20,"reason":"Detached source inset"}]}}],"rooms":[],"graph":{"nodes":[],"edges":[]}}';
  v_previous jsonb;
  v_patch jsonb;
  v_result jsonb;
  v_geo jsonb;
  v_author uuid := extensions.gen_random_uuid();
  v_moderator uuid := extensions.gen_random_uuid();
  v_proposal uuid;
begin
  v_previous := v_document#>'{floors,0}';
  v_patch := jsonb_build_object('anchors', jsonb_set(v_previous->'anchors', '{1,longitude}', '37.002'::jsonb));
  v_result := core.map_patch_document(v_document, 'floor', 'f1', v_patch);
  v_geo := v_result#>'{floors,0,georeference}';
  if v_geo->>'status' is distinct from 'community'
    or v_geo->>'method' is distinct from 'community_alignment'
    or v_geo->>'summary' is not distinct from v_previous#>>'{georeference,summary}'
    or v_geo ?| array['checked_at','sources','residuals','osm_sha256','anchor_kind','future_accuracy_claim']
    or v_geo->'excluded_regions' is distinct from v_previous#>'{georeference,excluded_regions}'
    or v_result#>'{floors,0,anchors}' is distinct from v_patch->'anchors'
    or v_result#>'{floors,0,meters_per_unit}' is distinct from v_previous->'meters_per_unit'
    or v_result - 'floors' is distinct from v_document - 'floors' then
    raise exception 'Changed anchors retained old claims or lost source-coordinate exclusions';
  end if;

  v_result := core.map_patch_document(v_document, 'floor', 'f1',
    jsonb_build_object('anchors', v_previous->'anchors', 'svg', v_previous->'svg', 'width', 100, 'height', 100));
  if v_result is distinct from v_document then
    raise exception 'An unchanged floor patch invalidated its alignment';
  end if;
  v_result := core.map_patch_document(v_document, 'floor', 'f1', '{"label":"Ground floor","level":0,"meters_per_unit":2}');
  if v_result#>'{floors,0,georeference}' is distinct from v_previous->'georeference'
    or v_result#>'{floors,0,anchors}' is distinct from v_previous->'anchors' then
    raise exception 'Floor presentation or navigation scale invalidated unrelated geographic evidence';
  end if;

  for v_patch in select value from jsonb_array_elements('[{"svg":"<svg xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M0 0L1 1\"/></svg>"},{"image_url":"https://example.org/replacement.svg"},{"width":200},{"height":200}]') loop
    v_result := core.map_patch_document(v_document, 'floor', 'f1', v_patch);
    if v_result#>'{floors,0,anchors}' is distinct from '[]'::jsonb
      or v_result#>'{floors,0,georeference,excluded_regions}' is distinct from '[]'::jsonb
      or (v_result#>'{floors,0,georeference}') ?| array['checked_at','sources','residuals','osm_sha256'] then
      raise exception 'Replacement floor retained coordinates or claims from the old source plan';
    end if;
  end loop;
  v_patch := jsonb_build_object('width', 200, 'anchors', jsonb_set(v_previous->'anchors', '{1,x}', '150'::jsonb));
  v_result := core.map_patch_document(v_document, 'floor', 'f1', v_patch);
  if v_result#>'{floors,0,anchors}' is distinct from v_patch->'anchors'
    or v_result#>'{floors,0,georeference,excluded_regions}' is distinct from '[]'::jsonb then
    raise exception 'Replacement floor lost explicitly supplied anchors or reused old exclusion coordinates';
  end if;
  v_result := core.map_patch_document(v_document, 'floor', 'f1', '{"anchors":[]}');
  if v_result#>'{floors,0,anchors}' is distinct from '[]'::jsonb
    or (v_result#>'{floors,0,georeference}') ? 'residuals' then
    raise exception 'Removing anchors retained stale alignment evidence';
  end if;
  begin
    perform core.map_patch_document(v_document, 'floor', 'f1', '{"georeference":{"status":"verified"}}');
    raise exception 'Community patch forged alignment verification metadata';
  exception when invalid_parameter_value then null; end;
  if has_function_privilege('authenticated', 'core.map_patch_document(jsonb,text,text,jsonb)', 'EXECUTE')
    or has_function_privilege('anon', 'core.map_patch_document(jsonb,text,text,jsonb)', 'EXECUTE') then
    raise exception 'Forward migration exposed the private document patch helper';
  end if;

  insert into core.organizations(id,name) values ('map-georeference-contract','Map georeference contract');
  insert into auth.users(id) values (v_author),(v_moderator);
  insert into core.user_academic_profiles(user_id,organization_id) values
    (v_author,'map-georeference-contract'),(v_moderator,'map-georeference-contract');
  insert into core.map_moderators(organization_id,user_id) values ('map-georeference-contract',v_moderator);
  execute 'set local role service_role';
  perform app_api_v1.publish_map_campus('map-georeference-campus','map-georeference-contract',v_document,0);
  execute 'reset role';
  perform set_config('request.jwt.claim.sub',v_author::text,true);
  execute 'set local role authenticated';
  v_patch := jsonb_build_object('anchors', jsonb_set(v_previous->'anchors', '{1,longitude}', '37.002'::jsonb));
  v_proposal := (app_api_v1.submit_map_proposal('map-georeference-campus',1,'floor','f1',v_patch,
    'Corrected control point against the building outline')->>'id')::uuid;
  if app_api_v1.get_map_campus('map-georeference-campus')#>'{floors,0,georeference}'
    is distinct from v_previous->'georeference' then
    raise exception 'Pending alignment proposal changed public evidence';
  end if;
  execute 'reset role';
  perform set_config('request.jwt.claim.sub',v_moderator::text,true);
  execute 'set local role authenticated';
  perform app_api_v1.review_map_proposal(v_proposal,'approved','Control point change reviewed');
  v_result := app_api_v1.get_map_campus('map-georeference-campus');
  if v_result->>'revision' is distinct from '2'
    or v_result#>>'{floors,0,georeference,status}' is distinct from 'community'
    or (v_result#>'{floors,0,georeference}') ? 'residuals' then
    raise exception 'Approved alignment did not atomically replace outdated evidence';
  end if;
  execute 'reset role';
  if (select document#>'{floors,0,georeference}' from core.map_revisions
      where campus_id = 'map-georeference-campus' and revision = 1) is distinct from v_previous->'georeference'
    or (select document#>>'{floors,0,georeference,status}' from core.map_revisions
      where campus_id = 'map-georeference-campus' and revision = 2) is distinct from 'community' then
    raise exception 'Alignment revision history lost either original evidence or the approved replacement';
  end if;
end;
$$;

rollback;
