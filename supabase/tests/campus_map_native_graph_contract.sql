begin;

do $$
declare
  v_campus core.map_campuses;
  v_author uuid := extensions.gen_random_uuid();
  v_moderator uuid := extensions.gen_random_uuid();
  v_proposal uuid;
  v_patch jsonb;
  v_result jsonb;
  v_bytes integer;
  v_expected_closed boolean;
begin
  select * into strict v_campus from core.map_campuses where id = 'v-78' and published;
  if jsonb_array_length(v_campus.document#>'{graph,nodes}') < 16000
    or jsonb_array_length(v_campus.document#>'{graph,edges}') < 40000 then
    raise exception 'Import the real native V-78 document before this contract';
  end if;
  v_patch := v_campus.document->'graph';
  v_expected_closed := not coalesce((v_patch#>>'{edges,0,closed}')::boolean, false);
  v_patch := jsonb_set(v_patch, '{edges,0,closed}', to_jsonb(v_expected_closed));
  v_bytes := octet_length(v_patch::text);
  if v_bytes <= 8388608 or v_bytes > 16777216 then
    raise exception 'Native V-78 patch must exercise the 8-16 MiB range, actual bytes: %', v_bytes;
  end if;
  perform core.map_patch_document(v_campus.document, 'graph', v_campus.id, v_patch);

  insert into auth.users(id) values (v_author), (v_moderator);
  insert into core.user_academic_profiles(user_id,organization_id) values
    (v_author,v_campus.organization_id), (v_moderator,v_campus.organization_id);
  insert into core.map_moderators(user_id,organization_id) values (v_moderator,v_campus.organization_id);
  perform set_config('request.jwt.claim.sub', v_author::text, true);
  execute 'set local role authenticated';
  v_result := app_api_v1.submit_map_proposal(v_campus.id,v_campus.revision,'graph',v_campus.id,
    v_patch,'Observed and checked a changed native corridor status');
  v_proposal := (v_result->>'id')::uuid;
  if v_result->>'status' is distinct from 'pending'
    or v_result ? 'patch' or v_result->>'has_full_patch' is distinct from 'false'
    or v_result->>'patch_bytes' is distinct from v_bytes::text
    or app_api_v1.get_map_campus(v_campus.id)->>'revision' is distinct from v_campus.revision::text then
    raise exception 'Large native graph proposal was truncated or prematurely published';
  end if;
  v_result := app_api_v1.get_map_proposals(v_campus.id);
  if octet_length(v_result::text) > 4096
    or (v_result#>'{proposals,0}') ? 'patch' then
    raise exception 'Native graph proposal queue includes the full graph payload';
  end if;
  v_result := app_api_v1.get_map_proposal(v_proposal);
  if v_result->'patch' is distinct from v_patch
    or v_result->>'has_full_patch' is distinct from 'true' then
    raise exception 'Lazy native graph detail was truncated';
  end if;
  execute 'reset role';
  perform set_config('request.jwt.claim.sub', v_moderator::text, true);
  execute 'set local role authenticated';
  perform app_api_v1.review_map_proposal(v_proposal,'approved','Confirmed the changed corridor status');
  v_result := app_api_v1.get_map_campus(v_campus.id);
  if v_result->>'revision' is distinct from (v_campus.revision + 1)::text
    or v_result->'graph' is distinct from v_patch then
    raise exception 'Approved large native graph did not preserve the exact patch and revision';
  end if;
  execute 'reset role';
  if not exists(select 1 from core.map_revisions where campus_id = v_campus.id
    and revision = v_campus.revision + 1 and document->'graph' = v_patch) then
    raise exception 'Approved large native graph is missing its immutable revision';
  end if;
  raise notice 'Native V-78 graph: % PostgreSQL JSONB-text bytes, complete submit/review/publish passed', v_bytes;
end;
$$;

rollback;
