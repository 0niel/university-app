begin;

do $$
declare
  v_signature text;
  v_public pg_proc;
  v_api pg_proc;
  v_read boolean;
begin
  foreach v_signature in array array[
    'get_map_catalog(text)', 'get_map_campus(text)', 'get_map_room(text,text,date)',
    'submit_map_proposal(text,bigint,text,text,jsonb,text)', 'get_map_proposals(text,text,integer)',
    'get_map_proposal(uuid)', 'review_map_proposal(uuid,text,text)', 'get_map_bookmarks()',
    'set_map_bookmark(text,text,boolean)', 'confirm_map_room(text,text,bigint,boolean)'
  ] loop
    select * into strict v_public from pg_proc where oid = ('public.' || v_signature)::regprocedure;
    select * into strict v_api from pg_proc where oid = ('app_api_v1.' || v_signature)::regprocedure;
    v_read := v_public.proname in ('get_map_catalog','get_map_campus','get_map_room');
    if v_public.prosecdef or v_public.proretset is distinct from v_api.proretset
      or v_public.prorettype is distinct from v_api.prorettype
      or v_public.provolatile is distinct from v_api.provolatile
      or v_public.proargnames is distinct from v_api.proargnames
      or v_public.pronargdefaults is distinct from v_api.pronargdefaults
      or pg_get_expr(v_public.proargdefaults, 0) is distinct from pg_get_expr(v_api.proargdefaults, 0)
      or (v_public.proconfig @> array['search_path=""']) is distinct from true then
      raise exception 'Public RPC changed the canonical function contract: %', v_signature;
    end if;
    if not has_function_privilege('authenticated',v_public.oid,'EXECUTE')
      or has_function_privilege('anon',v_public.oid,'EXECUTE') is distinct from v_read
      or has_function_privilege('service_role',v_public.oid,'EXECUTE') is distinct from v_read
      or exists(select 1 from aclexplode(coalesce(v_public.proacl,acldefault('f',v_public.proowner)))
        where grantee = 0 and privilege_type = 'EXECUTE') then
      raise exception 'Public RPC has unintended execute privileges: %', v_signature;
    end if;
  end loop;
  if to_regprocedure('public.publish_map_campus(text,text,jsonb,bigint)') is not null then
    raise exception 'Service-only campus publisher must not gain a public gateway wrapper';
  end if;
end;
$$;

do $$
declare
  v_author uuid := extensions.gen_random_uuid();
  v_other uuid := extensions.gen_random_uuid();
  v_moderator uuid := extensions.gen_random_uuid();
  v_proposal uuid;
  v_document jsonb := '{"title":"Public RPC contract","source_url":"https://pulse.mirea.ru/services/maps","floors":[{"id":"f1","label":"1","level":1,"width":100,"height":100}],"rooms":[{"id":"r1","floor_id":"f1","label":"101","kind":"classroom","x":10,"y":20,"equipment":[],"menu":[]}],"graph":{"nodes":[],"edges":[]}}';
  v_result jsonb;
begin
  insert into core.organizations(id,name) values ('map-public-contract','Map public contract');
  insert into auth.users(id) values (v_author),(v_other),(v_moderator);
  insert into core.user_academic_profiles(user_id,organization_id) values
    (v_author,'map-public-contract'),(v_other,'map-public-contract'),(v_moderator,'map-public-contract');
  insert into core.map_moderators(organization_id,user_id) values ('map-public-contract',v_moderator);
  execute 'set local role service_role';
  perform app_api_v1.publish_map_campus('map-public-campus','map-public-contract',v_document,0);
  execute 'reset role';
  perform set_config('request.jwt.claim.sub','',true);
  execute 'set local role anon';
  if public.get_map_catalog() is distinct from app_api_v1.get_map_catalog()
    or public.get_map_catalog('map-public-contract') is distinct from app_api_v1.get_map_catalog('map-public-contract')
    or public.get_map_campus('map-public-campus') is distinct from app_api_v1.get_map_campus('map-public-campus')
    or public.get_map_room('map-public-campus','r1') is distinct from app_api_v1.get_map_room('map-public-campus','r1') then
    raise exception 'Anonymous public reads or defaults differ from the canonical API';
  end if;
  begin
    perform public.get_map_proposals('map-public-campus');
    raise exception 'Anonymous public gateway exposed community proposals';
  exception when insufficient_privilege then null; end;
  execute 'reset role';
  perform set_config('request.jwt.claim.sub',v_author::text,true);
  execute 'set local role authenticated';
  perform public.set_map_bookmark('map-public-campus','r1',true);
  if jsonb_array_length(public.get_map_bookmarks()->'bookmarks') <> 1 then
    raise exception 'Public saved-place RPC did not forward the current user';
  end if;
  v_result := public.confirm_map_room('map-public-campus','r1',1);
  if v_result->>'confirmed_by_me' is distinct from 'true'
    or public.get_map_room('map-public-campus','r1')#>>'{verification,confirmation_count}' is distinct from '1' then
    raise exception 'Public room confirmation lost its default argument or caller';
  end if;
  v_proposal := (public.submit_map_proposal('map-public-campus',1,'room','r1','{"label":"102"}',
    'Room number checked on site')->>'id')::uuid;
  if jsonb_array_length(public.get_map_proposals('map-public-campus')->'proposals') <> 1
    or public.get_map_proposal(v_proposal)->'patch' is distinct from '{"label":"102"}'::jsonb
    or public.get_map_campus('map-public-campus')#>>'{rooms,0,label}' is distinct from '101' then
    raise exception 'Public proposal gateway lost author details or exposed a pending edit';
  end if;
  begin
    perform public.review_map_proposal(v_proposal,'approved');
    raise exception 'Public gateway bypassed moderator authorization';
  exception when insufficient_privilege then null; end;
  execute 'reset role';
  perform set_config('request.jwt.claim.sub',v_other::text,true);
  execute 'set local role authenticated';
  if public.get_map_proposals('map-public-campus')->'proposals' is distinct from '[]'::jsonb
    or public.get_map_bookmarks()->'bookmarks' is distinct from '[]'::jsonb then
    raise exception 'Public gateway leaked another account private state';
  end if;
  begin
    perform public.get_map_proposal(v_proposal);
    raise exception 'Public gateway leaked another author proposal details';
  exception when insufficient_privilege then null; end;
  execute 'reset role';
  perform set_config('request.jwt.claim.sub',v_moderator::text,true);
  execute 'set local role authenticated';
  perform public.review_map_proposal(v_proposal,'approved');
  v_result := public.get_map_campus('map-public-campus');
  if v_result#>>'{rooms,0,label}' is distinct from '102' or v_result->>'revision' is distinct from '2' then
    raise exception 'Public approval did not publish the canonical revision';
  end if;
  begin
    perform public.submit_map_proposal('map-public-campus',1,'room','r1','{"label":"103"}','Stale edit must fail');
    raise exception 'Public gateway bypassed revision concurrency checks';
  exception when serialization_failure then null; end;
  execute 'reset role';
  perform set_config('request.jwt.claim.sub',v_author::text,true);
  execute 'set local role authenticated';
  perform public.set_map_bookmark('map-public-campus','r1',false);
  perform public.confirm_map_room('map-public-campus','r1',2,false);
  if public.get_map_bookmarks()->'bookmarks' is distinct from '[]'::jsonb then
    raise exception 'Public saved-place removal failed';
  end if;
  execute 'reset role';
end;
$$;

rollback;
