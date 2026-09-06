begin;

do $$
declare
  v_table text;
  v_fn text;
begin
  foreach v_table in array array['map_campuses','map_moderators','map_proposals','map_revisions','map_bookmarks','map_room_confirmations'] loop
    if not (select relrowsecurity from pg_class where oid = ('core.' || v_table)::regclass)
      or has_table_privilege('authenticated', 'core.' || v_table, 'SELECT,INSERT,UPDATE,DELETE')
      or has_table_privilege('anon', 'core.' || v_table, 'SELECT,INSERT,UPDATE,DELETE') then
      raise exception 'Map table is exposed: %', v_table;
    end if;
  end loop;
  foreach v_fn in array array[
    'app_api_v1.submit_map_proposal(text,bigint,text,text,jsonb,text)',
    'app_api_v1.review_map_proposal(uuid,text,text)',
    'app_api_v1.get_map_proposals(text,text,integer)',
    'app_api_v1.get_map_proposal(uuid)',
    'app_api_v1.get_map_bookmarks()',
    'app_api_v1.set_map_bookmark(text,text,boolean)',
    'app_api_v1.confirm_map_room(text,text,bigint,boolean)'
  ] loop
    if has_function_privilege('anon', v_fn, 'EXECUTE')
      or not has_function_privilege('authenticated', v_fn, 'EXECUTE')
      or (select prosecdef from pg_proc where oid = v_fn::regprocedure) then
      raise exception 'Invalid map API privileges: %', v_fn;
    end if;
  end loop;
  if has_function_privilege('authenticated','app_api_v1.publish_map_campus(text,text,jsonb,bigint)','EXECUTE') then
    raise exception 'Users can publish a campus without moderation';
  end if;
end;
$$;

do $$
declare
  v_author uuid := extensions.gen_random_uuid();
  v_moderator uuid := extensions.gen_random_uuid();
  v_other uuid := extensions.gen_random_uuid();
  v_outsider uuid := extensions.gen_random_uuid();
  v_guest uuid := extensions.gen_random_uuid();
  v_schedule_campus uuid := extensions.gen_random_uuid();
  v_other_campus uuid := extensions.gen_random_uuid();
  v_schedule_room uuid := extensions.gen_random_uuid();
  v_duplicate_room uuid := extensions.gen_random_uuid();
  v_lesson uuid := extensions.gen_random_uuid();
  v_proposal uuid;
  v_stale uuid;
  v_report uuid;
  v_new_place uuid;
  v_move uuid;
  v_document jsonb := '{"title":"Contract campus","latitude":55.7,"longitude":37.6,"source_url":"https://pulse.mirea.ru/services/maps","source_label":"Пульс РТУ МИРЭА","floors":[{"id":"f1","label":"1","level":1,"width":100,"height":100}],"rooms":[{"id":"r1","floor_id":"f1","label":"101","kind":"classroom","x":10,"y":20,"equipment":[],"menu":[]}],"graph":{"nodes":[{"id":"n1","floor_id":"f1","x":10,"y":20,"room_id":"r1"},{"id":"n2","floor_id":"f1","x":20,"y":20}],"edges":[{"id":"e1","from_node_id":"n1","to_node_id":"n2","distance_meters":10,"kind":"corridor","bidirectional":true}]}}';
  v_result jsonb;
  v_portal_document jsonb;
begin
  v_document := jsonb_set(v_document, '{rooms,0,legacy_ids}', '["legacy-room-a"]'::jsonb);
  v_result := core.map_patch_document(v_document, 'room', 'r1', '{"x":10,"y":20}'::jsonb);
  if v_result is distinct from v_document then raise exception 'Unchanged coordinates detached room navigation'; end if;
  v_result := core.map_patch_document(jsonb_set(v_document, '{graph,nodes,0,label}', '"101"'::jsonb),
    'room', 'r1', '{"x":30}'::jsonb);
  if (v_result#>'{graph,nodes,0}') ? 'room_id' or (v_result#>'{graph,nodes,0}') ? 'label'
    or v_result#>>'{rooms,0,navigation_needs_review}' is distinct from 'true'
    or v_result#>'{graph,edges}' is distinct from v_document#>'{graph,edges}' then
    raise exception 'Relocation left obsolete room anchor or changed corridor geometry';
  end if;
  v_result := core.map_patch_document(jsonb_set(v_document, '{graph,nodes,0,label}', '"Hall junction"'::jsonb),
    'room', 'r1', '{"y":35}'::jsonb);
  if v_result#>>'{graph,nodes,0,label}' is distinct from 'Hall junction'
    or v_result#>>'{graph,nodes,0,kind}' is distinct from 'junction' then
    raise exception 'Relocation lost an independent waypoint label or left it selectable as a room';
  end if;
  v_result := core.map_patch_document(v_result, 'graph', 'map-contract-campus', v_document->'graph');
  if (v_result#>'{rooms,0}') ? 'navigation_needs_review' then
    raise exception 'Reviewed graph reconnection left obsolete navigation review flag';
  end if;
  begin
    perform core.map_patch_document(v_document, 'room', 'r1', '{"navigation_needs_review":false}'::jsonb);
    raise exception 'Room patch bypassed navigation review';
  exception when invalid_parameter_value then null; end;
  insert into core.organizations(id,name) values ('map-contract-a','Map Contract A'),('map-contract-b','Map Contract B');
  insert into auth.users(id) values (v_author),(v_moderator),(v_other),(v_outsider);
  insert into auth.users(id,is_anonymous) values (v_guest,true);
  insert into core.user_academic_profiles(user_id,organization_id) values
    (v_author,'map-contract-a'),(v_moderator,'map-contract-a'),(v_other,'map-contract-a'),(v_outsider,'map-contract-b'),(v_guest,'map-contract-a');
  insert into core.map_moderators(organization_id,user_id) values ('map-contract-a',v_moderator),('map-contract-a',v_author);
  perform core.map_validate_document(v_document - array['latitude','longitude']);
  perform core.map_validate_document(v_document || '{"latitude":null,"longitude":null}'::jsonb);
  perform core.map_validate_document(jsonb_set(v_document, '{graph,edges,0}',
    (v_document#>'{graph,edges,0}') || '{"distance_meters":0,"duration_seconds":0}'::jsonb));
  v_portal_document := jsonb_set(v_document, '{floors}', (v_document->'floors') ||
    jsonb_build_array((v_document#>'{floors,0}') || '{"id":"f2","level":2}'::jsonb));
  v_portal_document := jsonb_set(v_portal_document, '{graph,nodes,1,floor_id}', '"f2"'::jsonb);
  v_portal_document := jsonb_set(v_portal_document, '{graph,edges,0}',
    ((v_portal_document#>'{graph,edges,0}') - 'distance_meters') || '{"kind":"stairs","traversal_cost":25}'::jsonb);
  perform core.map_validate_document(v_portal_document);
  perform core.map_validate_document(jsonb_set(v_portal_document, '{graph,edges,0,distance_meters}', 'null'::jsonb));
  begin
    perform core.map_validate_document(jsonb_set(v_portal_document, '{graph,edges,0,traversal_cost}', '0'::jsonb));
    raise exception 'Zero traversal cost accepted for unknown physical distance';
  exception when invalid_parameter_value then null; end;
  begin
    perform core.map_validate_document(jsonb_set(v_portal_document, '{graph,edges,0}',
      (v_portal_document#>'{graph,edges,0}') - 'traversal_cost'));
    raise exception 'Edge without any routing cost accepted';
  exception when invalid_parameter_value then null; end;
  begin
    perform core.map_validate_document(jsonb_set(v_document, '{graph,edges,0,distance_meters}', '-1'::jsonb));
    raise exception 'Negative physical distance accepted';
  exception when invalid_parameter_value then null; end;
  begin
    perform core.map_validate_document(v_document - 'longitude');
    raise exception 'Incomplete geographic coordinate pair accepted';
  exception when invalid_parameter_value then null; end;
  begin
    perform core.map_validate_document(v_document || '{"latitude":91}'::jsonb);
    raise exception 'Invalid geographic latitude accepted';
  exception when invalid_parameter_value then null; end;
  begin
    perform core.map_validate_document(jsonb_set(v_document, '{rooms}', (v_document->'rooms') ||
      jsonb_build_array((v_document#>'{rooms,0}') || '{"id":"another-room"}'::jsonb)));
    raise exception 'Ambiguous legacy room alias accepted';
  exception when invalid_parameter_value then null; end;
  execute 'set local role service_role';
  perform app_api_v1.publish_map_campus('map-contract-campus','map-contract-a',v_document,0);
  execute 'reset role';
  perform set_config('request.jwt.claim.sub','',true);
  execute 'set local role anon';
  v_result := app_api_v1.get_map_catalog('map-contract-a');
  if jsonb_array_length(v_result->'campuses') <> 1 or (v_result#>'{campuses,0}') ? 'floors' then
    raise exception 'Catalog missing campus or includes large floor payload';
  end if;
  if (app_api_v1.get_map_room('map-contract-campus','r1',current_date)->>'schedule_linked')::boolean then
    raise exception 'Unlinked room claims to have an authoritative schedule';
  end if;
  execute 'reset role';
  insert into core.schedule_campuses(id,organization_id,name,short_name,normalized_name,identity_key) values
    (v_schedule_campus,'map-contract-a','Contract Campus','Т-78','т-78','map-contract-c'),
    (v_other_campus,'map-contract-a','Another Campus','Т-86','т-86','map-contract-other');
  insert into core.schedule_classrooms(id,organization_id,campus_id,name,normalized_name,identity_key) values
    (v_schedule_room,'map-contract-a',v_schedule_campus,'101','101','map-contract-room'),
    (extensions.gen_random_uuid(),'map-contract-a',v_other_campus,'101','101','map-contract-other-room');
  insert into core.term(id,organization_id,code,title,starts_on,ends_on)
    values (79991,'map-contract-a','map-contract-term','Map Contract Term',current_date - 1,current_date + 1);
  insert into core.schedule_item(id,organization_id,term_id,source_uid,title,kind,lesson_type,start_time,end_time,dates,content_hash)
    values (v_lesson,'map-contract-a',79991,'map-contract-item','Exact room lesson','lesson','lecture','09:00','10:30',array[current_date],'map-contract-hash');
  insert into core.schedule_item_classroom(item_id,classroom_id) values (v_lesson,v_schedule_room);
  update core.map_campuses set document = document || '{"short_title":"Т-78"}'::jsonb where id = 'map-contract-campus';
  execute 'set local role anon';
  v_result := app_api_v1.get_map_room('map-contract-campus','r1',current_date);
  if v_result->>'schedule_linked' is distinct from 'true' or v_result#>>'{schedule,0,title}' is distinct from 'Exact room lesson' then
    raise exception 'Unique campus and classroom did not resolve canonical timetable';
  end if;
  execute 'reset role';
  insert into core.schedule_classrooms(id,organization_id,campus_id,name,normalized_name,identity_key)
    values (v_duplicate_room,'map-contract-a',v_schedule_campus,'101','101','map-contract-duplicate');
  execute 'set local role anon';
  if (app_api_v1.get_map_room('map-contract-campus','r1',current_date)->>'schedule_linked')::boolean then
    raise exception 'Ambiguous classroom was linked to a timetable';
  end if;
  execute 'reset role';
  delete from core.schedule_classrooms where id = v_duplicate_room;
  insert into core.map_bookmarks(user_id,campus_id,room_id) values
    (v_author,'map-contract-campus','legacy-room-a'),(v_author,'map-contract-campus','r1');
  perform set_config('request.jwt.claim.sub',v_author::text,true);
  execute 'set local role authenticated';
  if app_api_v1.get_map_room('map-contract-campus','legacy-room-a',current_date)#>>'{room,id}' is distinct from 'r1' then
    raise exception 'Legacy room link does not resolve its canonical room';
  end if;
  if jsonb_array_length(app_api_v1.get_map_bookmarks()->'bookmarks') <> 1
    or app_api_v1.get_map_bookmarks()#>>'{bookmarks,0,room_id}' is distinct from 'r1' then
    raise exception 'Legacy and canonical bookmarks were not resolved and deduplicated';
  end if;
  perform app_api_v1.set_map_bookmark('map-contract-campus','r1',false);
  if jsonb_array_length(app_api_v1.get_map_bookmarks()->'bookmarks') <> 0 then
    raise exception 'Removing a canonical bookmark left its legacy alias saved';
  end if;
  perform app_api_v1.set_map_bookmark('map-contract-campus','legacy-room-a',true);
  perform app_api_v1.set_map_bookmark('map-contract-campus','r1',true);
  perform app_api_v1.set_map_bookmark('map-contract-campus','r1',true);
  if jsonb_array_length(app_api_v1.get_map_bookmarks()->'bookmarks') <> 1 then
    raise exception 'Saved place was lost or duplicated';
  end if;
  perform app_api_v1.confirm_map_room('map-contract-campus','legacy-room-a',1,true);
  perform app_api_v1.confirm_map_room('map-contract-campus','r1',1,true);
  if app_api_v1.get_map_room('map-contract-campus','r1',current_date)#>>'{verification,confirmation_count}' <> '1' then
    raise exception 'One user confirmation was counted more than once';
  end if;
  v_proposal := (app_api_v1.submit_map_proposal('map-contract-campus',1,'room','r1','{"label":"102"}','Correct room number')->>'id')::uuid;
  v_stale := (app_api_v1.submit_map_proposal('map-contract-campus',1,'room','r1','{"label":"103"}','Another correction')->>'id')::uuid;
  v_result := app_api_v1.get_map_proposals('map-contract-campus');
  if exists(select 1 from jsonb_array_elements(v_result->'proposals') p
    where p ? 'patch' or p->>'has_full_patch' is distinct from 'false'
      or p->'patch_keys' is distinct from '["label"]'::jsonb) then
    raise exception 'Proposal queue must contain compact summaries only';
  end if;
  v_result := app_api_v1.get_map_proposal(v_proposal);
  if v_result->'patch' is distinct from '{"label":"102"}'::jsonb
    or v_result->>'has_full_patch' is distinct from 'true' then
    raise exception 'Author cannot retrieve complete proposal details';
  end if;
  if app_api_v1.get_map_campus('map-contract-campus')#>>'{rooms,0,label}' <> '101' then
    raise exception 'Pending proposal leaked into published map';
  end if;
  begin
    perform app_api_v1.review_map_proposal(v_proposal,'approved',null);
    raise exception 'Self approval succeeded';
  exception when insufficient_privilege then null; end;
  begin
    perform app_api_v1.submit_map_proposal('map-contract-campus',1,'room','r1','{"id":"hijacked"}','Change stable identity');
    raise exception 'Stable map identity was mutable';
  exception when invalid_parameter_value then null; end;
  begin
    perform app_api_v1.submit_map_proposal('map-contract-campus',1,'campus','map-contract-campus','{"short_title":123}','Invalid display title');
    raise exception 'Numeric campus title accepted';
  exception when invalid_parameter_value then null; end;
  begin
    perform app_api_v1.submit_map_proposal('map-contract-campus',1,'room','r1','{"menu":[{"name":"Lunch","description":123}]}','Invalid menu description');
    raise exception 'Numeric menu description accepted';
  exception when invalid_parameter_value then null; end;
  begin
    perform app_api_v1.submit_map_proposal('map-contract-campus',1,'graph','map-contract-campus',
      '{"edges":[{"id":"bad","from_node_id":"n1","to_node_id":"missing","distance_meters":1,"kind":"corridor"}]}','Invalid graph reference');
    raise exception 'Dangling navigation edge accepted';
  exception when invalid_parameter_value then null; end;
  begin
    perform app_api_v1.submit_map_proposal('map-contract-campus',1,'floor','f1',
      '{"svg":"<svg onload=\"alert(1)\"></svg>"}','Unsafe floor markup');
    raise exception 'Active SVG accepted';
  exception when invalid_parameter_value then null; end;
  execute 'reset role';
  perform set_config('request.jwt.claim.sub',v_other::text,true);
  execute 'set local role authenticated';
  if jsonb_array_length(app_api_v1.get_map_bookmarks()->'bookmarks') <> 0 then
    raise exception 'Private saved places leaked to another user';
  end if;
  if (app_api_v1.get_map_room('map-contract-campus','r1',current_date)#>>'{verification,confirmed_by_me}')::boolean then
    raise exception 'Room confirmation incorrectly attributed to another user';
  end if;
  if jsonb_array_length(app_api_v1.get_map_proposals('map-contract-campus')->'proposals') <> 0 then
    raise exception 'Private proposals leaked to another student';
  end if;
  begin
    perform app_api_v1.get_map_proposal(v_proposal);
    raise exception 'Private proposal details leaked to another student';
  exception when insufficient_privilege then null; end;
  begin
    perform app_api_v1.review_map_proposal(v_proposal,'approved',null);
    raise exception 'Non-moderator approved a proposal';
  exception when insufficient_privilege then null; end;
  execute 'reset role';
  perform set_config('request.jwt.claim.sub',v_guest::text,true);
  execute 'set local role authenticated';
  begin
    perform app_api_v1.submit_map_proposal('map-contract-campus',1,'room','r1','{"label":"Guest"}','Anonymous correction');
    raise exception 'Anonymous auth account submitted a proposal';
  exception when insufficient_privilege then null; end;
  execute 'reset role';
  perform set_config('request.jwt.claim.sub',v_outsider::text,true);
  execute 'set local role authenticated';
  begin
    perform app_api_v1.get_map_proposal(v_proposal);
    raise exception 'Private proposal details leaked across organizations';
  exception when insufficient_privilege then null; end;
  begin
    perform app_api_v1.submit_map_proposal('map-contract-campus',1,'room','r1','{"label":"999"}','Cross campus edit');
    raise exception 'Cross organization proposal accepted';
  exception when insufficient_privilege then null; end;
  execute 'reset role';
  perform set_config('request.jwt.claim.sub',v_moderator::text,true);
  execute 'set local role authenticated';
  if jsonb_array_length(app_api_v1.get_map_proposals('map-contract-campus')->'proposals') <> 2 then
    raise exception 'Moderator queue lost pending proposals';
  end if;
  if app_api_v1.get_map_proposal(v_proposal)->'patch' is distinct from '{"label":"102"}'::jsonb then
    raise exception 'Moderator cannot retrieve complete proposal details';
  end if;
  perform app_api_v1.review_map_proposal(v_proposal,'approved','Verified against source');
  if app_api_v1.get_map_room('map-contract-campus','r1',current_date)#>>'{verification,confirmation_count}' <> '0' then
    raise exception 'Old confirmation incorrectly verifies a new revision';
  end if;
  begin
    perform app_api_v1.confirm_map_room('map-contract-campus','r1',1,true);
    raise exception 'Stale room confirmation accepted';
  exception when serialization_failure then null; end;
  if app_api_v1.get_map_campus('map-contract-campus')#>>'{rooms,0,label}' <> '102'
    or (app_api_v1.get_map_campus('map-contract-campus')->>'revision')::bigint <> 2 then
    raise exception 'Approval failed to publish a new revision';
  end if;
  begin
    perform app_api_v1.review_map_proposal(v_stale,'approved',null);
    raise exception 'Stale proposal overwrote a newer revision';
  exception when serialization_failure then null; end;
  perform app_api_v1.review_map_proposal(v_stale,'rejected','Superseded by newer revision');
  execute 'reset role';
  if (select count(*) from core.map_revisions where campus_id = 'map-contract-campus') <> 2 then
    raise exception 'Revision audit was not retained';
  end if;
  perform set_config('request.jwt.claim.sub',v_author::text,true);
  execute 'set local role authenticated';
  v_report := (app_api_v1.submit_map_proposal('map-contract-campus',2,'report','f1',
    '{"category":"plan","details":"The stairs may have moved"}','Please inspect floor plan')->>'id')::uuid;
  execute 'reset role';
  perform set_config('request.jwt.claim.sub',v_moderator::text,true);
  execute 'set local role authenticated';
  perform app_api_v1.review_map_proposal(v_report,'approved','Inspection acknowledged; geometry unchanged');
  if (app_api_v1.get_map_campus('map-contract-campus')->>'revision')::bigint <> 2 then
    raise exception 'Report acknowledgement changed published geometry';
  end if;
  execute 'reset role';
  perform set_config('request.jwt.claim.sub',v_author::text,true);
  execute 'set local role authenticated';
  v_new_place := (app_api_v1.submit_map_proposal('map-contract-campus',2,'place_create','new-atm',
    '{"floor_id":"f1","x":30,"y":40,"label":"ATM","kind":"atm"}','New ATM observed on this floor')->>'id')::uuid;
  if app_api_v1.get_map_room('map-contract-campus','new-atm',current_date) is not null
    or jsonb_array_length(app_api_v1.get_map_campus('map-contract-campus')->'rooms') <> 1 then
    raise exception 'Pending new place was published before moderation';
  end if;
  begin
    perform app_api_v1.submit_map_proposal('map-contract-campus',2,'place_create','r1',
      '{"floor_id":"f1","x":30,"y":40,"label":"Overwrite","kind":"atm"}','Attempt to replace existing place');
    raise exception 'Place creation overwrote existing room identity';
  exception when invalid_parameter_value then null; end;
  begin
    perform app_api_v1.submit_map_proposal('map-contract-campus',2,'place_create','wrong-floor',
      '{"floor_id":"another-campus-floor","x":30,"y":40,"label":"ATM","kind":"atm"}','Incorrect floor reference');
    raise exception 'Place creation accepted a floor outside the campus';
  exception when invalid_parameter_value then null; end;
  begin
    perform app_api_v1.submit_map_proposal('map-contract-campus',2,'place_create','out-of-bounds',
      '{"floor_id":"f1","x":101,"y":40,"label":"ATM","kind":"atm"}','Incorrect place coordinates');
    raise exception 'Place creation accepted coordinates outside the floor';
  exception when invalid_parameter_value then null; end;
  execute 'reset role';
  perform set_config('request.jwt.claim.sub',v_moderator::text,true);
  execute 'set local role authenticated';
  perform app_api_v1.review_map_proposal(v_new_place,'approved','Confirmed the location and service');
  if app_api_v1.get_map_room('map-contract-campus','new-atm',current_date)#>>'{room,kind}' is distinct from 'atm'
    or app_api_v1.get_map_campus('map-contract-campus')->>'revision' is distinct from '3'
    or app_api_v1.get_map_campus('map-contract-campus')#>>'{rooms,0,label}' is distinct from '102' then
    raise exception 'Place creation did not preserve existing rooms and publish exactly once';
  end if;
  begin
    perform app_api_v1.submit_map_proposal('map-contract-campus',3,'place_create','new-atm',
      '{"floor_id":"f1","x":30,"y":40,"label":"Duplicate","kind":"atm"}','Duplicate new place identity');
    raise exception 'Place creation accepted a duplicate published identity';
  exception when invalid_parameter_value then null; end;
  execute 'reset role';
  perform set_config('request.jwt.claim.sub',v_author::text,true);
  execute 'set local role authenticated';
  v_move := (app_api_v1.submit_map_proposal('map-contract-campus',3,'room','r1',
    '{"x":35,"y":45}','Moved service location verified on site')->>'id')::uuid;
  if app_api_v1.get_map_campus('map-contract-campus')#>>'{graph,nodes,0,room_id}' is distinct from 'r1' then
    raise exception 'Pending relocation changed the public navigation graph';
  end if;
  execute 'reset role';
  perform set_config('request.jwt.claim.sub',v_moderator::text,true);
  execute 'set local role authenticated';
  perform app_api_v1.review_map_proposal(v_move,'approved','Confirmed relocation; route needs reconnecting');
  v_result := app_api_v1.get_map_campus('map-contract-campus');
  if v_result->>'revision' is distinct from '4'
    or v_result#>>'{rooms,0,x}' is distinct from '35'
    or (v_result#>'{graph,nodes,0}') ? 'room_id'
    or v_result#>>'{rooms,0,navigation_needs_review}' is distinct from 'true' then
    raise exception 'Approved relocation did not atomically detach the obsolete routing anchor';
  end if;
  execute 'reset role';
  update core.map_campuses set published = false where id = 'map-contract-campus';
  execute 'set local role anon';
  if app_api_v1.get_map_campus('map-contract-campus') is not null
    or jsonb_array_length(app_api_v1.get_map_catalog('map-contract-a')->'campuses') <> 0 then
    raise exception 'Unpublished campus leaked';
  end if;
  execute 'reset role';
end;
$$;

rollback;
