begin;

create temporary table mini_content_fixture (
  owner_id uuid, other_owner_id uuid, app_id uuid, second_app_id uuid,
  other_app_id uuid, organization_id text, token_hash text,
  second_token_hash text, other_token_hash text
);
insert into mini_content_fixture values (
  extensions.gen_random_uuid(), extensions.gen_random_uuid(),
  extensions.gen_random_uuid(), extensions.gen_random_uuid(),
  extensions.gen_random_uuid(),
  'mini-content-contract-' || extensions.gen_random_uuid()::text,
  extensions.gen_random_uuid()::text, extensions.gen_random_uuid()::text,
  extensions.gen_random_uuid()::text
);
grant select on mini_content_fixture to service_role, authenticated, anon;

create function pg_temp.expect_deploy_role_denied()
returns void language plpgsql security invoker set search_path = '' as $$
begin
  begin
    perform public.mini_app_deploy('invalid', 'invalid', 'invalid', '[]');
  exception when insufficient_privilege then
    return;
  end;
  raise exception 'Mini-app deployment accepted an unauthorized role';
end;
$$;

do $$
declare f mini_content_fixture;
begin
  select * into f from mini_content_fixture;
  insert into core.organizations (id, name)
  values (f.organization_id, 'Mini Content Contract');
  insert into auth.users (id, is_anonymous)
  values (f.owner_id, false), (f.other_owner_id, false);
  insert into core.mini_apps (id, organization_id, owner_id, slug, name)
  values
    (f.app_id, f.organization_id, f.owner_id, 'content-contract', 'Content Contract'),
    (f.second_app_id, f.organization_id, f.owner_id, 'second-contract', 'Second Contract'),
    (f.other_app_id, f.organization_id, f.other_owner_id, 'other-contract', 'Other Contract');
  insert into core.mini_app_screens (app_id, path, json)
  values (f.app_id, '/', '{"type":"text","data":"original"}');
  insert into core.mini_app_deploy_tokens (user_id, token_hash)
  values (f.owner_id, f.token_hash), (f.owner_id, f.second_token_hash),
    (f.other_owner_id, f.other_token_hash);
end;
$$;

set local role anon;
select pg_temp.expect_deploy_role_denied();
set local role authenticated;
select pg_temp.expect_deploy_role_denied();

set local role service_role;
select set_config('request.jwt.claim.sub', '', true),
  set_config('request.jwt.claims', '{"role":"service_role"}', true);

do $$
declare
  f mini_content_fixture;
  v_result jsonb;
  v_screens jsonb := '[{"path":"/","json":{"type":"text","data":"updated"}}]';
  v_invalid jsonb;
  v_index integer;
  v_hint text;
begin
  select * into f from mini_content_fixture;
  if auth.uid() is not null then
    raise exception 'Service-role fixture unexpectedly has a user identity';
  end if;
  v_result := public.mini_app_deploy('invalid', f.organization_id, 'content-contract', v_screens);
  if v_result ->> 'reason' is distinct from 'invalid_token' then
    raise exception 'Invalid token was accepted';
  end if;
  v_result := public.mini_app_deploy(f.other_token_hash, f.organization_id, 'content-contract', v_screens);
  if v_result ->> 'reason' is distinct from 'app_not_found' then
    raise exception 'Token crossed the application ownership boundary';
  end if;
  v_result := public.mini_app_deploy(f.token_hash, 'wrong-organization', 'content-contract', v_screens);
  if v_result ->> 'reason' is distinct from 'app_not_found' then
    raise exception 'Token crossed the organization boundary';
  end if;

  foreach v_invalid in array array[
    null::jsonb, 'null'::jsonb, '{}'::jsonb, '[]'::jsonb, '[null]'::jsonb,
    jsonb_build_array(jsonb_build_object('path', '/', 'json',
      jsonb_build_object('type', 'text', 'data', repeat('я', 524288)))),
    (select jsonb_agg(jsonb_build_object('path', '/' || n, 'json', '{}'))
      from generate_series(1, 51) n)
  ] loop
    v_result := public.mini_app_deploy(f.token_hash, f.organization_id, 'content-contract', v_invalid);
    if v_result ->> 'reason' is distinct from 'bad_screens' then
      raise exception 'Invalid or oversized screen payload was accepted';
    end if;
  end loop;
  if (select version from core.mini_apps where id = f.app_id) <> 1
    or (select count(*) from core.mini_app_screens where app_id = f.app_id) <> 1
    or not exists(select 1 from core.mini_app_screens where app_id = f.app_id
      and json ->> 'data' = 'original')
    or exists(select 1 from core.mini_app_screen_revisions where app_id = f.app_id)
    or exists(select 1 from core.mini_app_deploy_tokens where user_id = f.owner_id
      and last_used_at is not null) then
    raise exception 'Rejected deployment changed persisted content';
  end if;

  v_result := public.mini_app_deploy(f.token_hash, f.organization_id, 'content-contract',
    (select jsonb_agg(jsonb_build_object('path', '/' || n, 'json',
      jsonb_build_object('type', 'text', 'data', 'Screen ' || n)))
      from generate_series(1, 50) n), false);
  if v_result ->> 'ok' is distinct from 'true'
    or v_result ->> 'status' is distinct from 'draft'
    or (select count(*) from core.mini_app_screens where app_id = f.app_id) <> 50 then
    raise exception 'Valid 50-screen draft deployment failed';
  end if;

  for v_index in 2..10 loop
    v_result := public.mini_app_deploy(
      case when v_index % 2 = 0 then f.second_token_hash else f.token_hash end,
      f.organization_id,
      case when v_index % 2 = 0 then 'second-contract' else 'content-contract' end,
      v_screens, true);
    if v_result ->> 'ok' is distinct from 'true'
      or v_result ->> 'status' is distinct from 'pending_review' then
      raise exception 'Valid deployment failed below the limit';
    end if;
  end loop;
  begin
    perform public.mini_app_deploy(f.second_token_hash, f.organization_id,
      'second-contract', v_screens);
    raise exception 'Deployment quota was bypassed through a second token or application';
  exception when raise_exception then
    get stacked diagnostics v_hint = pg_exception_hint;
    if v_hint is distinct from 'rate_limited:mini_app_deploy' then
      raise;
    end if;
  end;
  if (select sum(version - 1) from core.mini_apps where owner_id = f.owner_id) <> 10
    or (select count(*) from core.mini_app_screen_revisions
      where app_id in (f.app_id, f.second_app_id)) <> 10 then
    raise exception 'Rate-limited deployment changed versions or revisions';
  end if;
  v_result := public.mini_app_deploy(f.other_token_hash, f.organization_id,
    'other-contract', v_screens, false);
  if v_result ->> 'ok' is distinct from 'true' then
    raise exception 'One developer consumed another developer quota';
  end if;
end;
$$;

reset role;
rollback;
