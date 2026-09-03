begin;

create temporary table mini_push_fixture (
  owner_id uuid, first_id uuid, second_id uuid, unconsented_id uuid,
  app_id uuid, other_app_id uuid, organization_id text, token_hash text
);
insert into mini_push_fixture values (
  extensions.gen_random_uuid(), extensions.gen_random_uuid(),
  extensions.gen_random_uuid(), extensions.gen_random_uuid(),
  extensions.gen_random_uuid(), extensions.gen_random_uuid(),
  'push-contract-' || extensions.gen_random_uuid()::text,
  extensions.gen_random_uuid()::text
);
grant select on mini_push_fixture to service_role, authenticated, anon;

create function pg_temp.expect_push_denied(p_sql text)
returns void language plpgsql security invoker set search_path = '' as $$
begin
  begin
    execute p_sql;
  exception when insufficient_privilege then
    return;
  end;
  raise exception 'Mini-app push RPC accepted an unauthorized role';
end;
$$;

do $$
declare f mini_push_fixture;
begin
  select * into f from mini_push_fixture;
  insert into core.organizations (id, name)
  values (f.organization_id, 'Push Contract');
  insert into auth.users (id, is_anonymous) values
    (f.owner_id, false), (f.first_id, false),
    (f.second_id, true), (f.unconsented_id, false);
  insert into core.mini_apps (
    id, organization_id, owner_id, slug, name, status, requested_permissions
  ) values
    (f.app_id, f.organization_id, f.owner_id, 'push-contract',
      'Push Contract', 'published', array['notifications']),
    (f.other_app_id, f.organization_id, f.owner_id, 'other-contract',
      'Other Contract', 'published', array['notifications']);
  insert into core.mini_app_deploy_tokens (user_id, token_hash)
  values (f.owner_id, f.token_hash);
  insert into core.mini_app_consents (user_id, app_id, scopes) values
    (f.first_id, f.app_id, array['notifications']),
    (f.second_id, f.app_id, array['notifications']),
    (f.unconsented_id, f.app_id, array['identity']);
end;
$$;

set local role anon;
select pg_temp.expect_push_denied(
  'select public.mini_app_notify_context(''invalid'', ''invalid'', ''invalid'', 2)'
);
select pg_temp.expect_push_denied(
  'select public.finalize_mini_app_push(null, null, ''{}''::uuid[])'
);
select pg_temp.expect_push_denied('select public.log_mini_app_push(null, ''{}''::uuid[])');
select pg_temp.expect_push_denied('select public.mini_app_push_devices(null, null)');
select pg_temp.expect_push_denied(
  'select public.set_mini_app_push_endpoint(null, null, ''invalid'', ''invalid'')'
);
select pg_temp.expect_push_denied(
  'select public.delete_mini_app_push_devices(null, null, ''{}''::text[])'
);
set local role authenticated;
select pg_temp.expect_push_denied(
  'select public.mini_app_notify_context(''invalid'', ''invalid'', ''invalid'', 2)'
);
select pg_temp.expect_push_denied(
  'select public.finalize_mini_app_push(null, null, ''{}''::uuid[])'
);
select pg_temp.expect_push_denied('select public.log_mini_app_push(null, ''{}''::uuid[])');
select pg_temp.expect_push_denied('select public.mini_app_push_devices(null, null)');
select pg_temp.expect_push_denied(
  'select public.set_mini_app_push_endpoint(null, null, ''invalid'', ''invalid'')'
);
select pg_temp.expect_push_denied(
  'select public.delete_mini_app_push_devices(null, null, ''{}''::text[])'
);

set local role service_role;
select set_config('request.jwt.claim.sub', '', true),
  set_config('request.jwt.claims', '{"role":"service_role"}', true);
do $$
declare
  f mini_push_fixture;
  v_context jsonb;
  v_first uuid;
  v_second uuid;
  v_third uuid;
  v_sent_at timestamptz := now() - interval '5 minutes';
  v_index integer;
begin
  select * into f from mini_push_fixture;
  v_context := public.mini_app_notify_context('invalid', f.organization_id, 'push-contract');
  if v_context ->> 'reason' is distinct from 'invalid_token' then
    raise exception 'Invalid deploy token was accepted';
  end if;
  v_context := public.mini_app_notify_context(f.token_hash, 'wrong-organization', 'push-contract');
  if v_context ->> 'reason' is distinct from 'app_not_found' then
    raise exception 'Organization boundary was not enforced';
  end if;
  update core.mini_apps set status = 'draft' where id = f.app_id;
  v_context := public.mini_app_notify_context(f.token_hash, f.organization_id, 'push-contract');
  if v_context ->> 'reason' is distinct from 'not_published' then
    raise exception 'Unpublished app was allowed to send';
  end if;
  update core.mini_apps set status = 'published', requested_permissions = '{}'
  where id = f.app_id;
  v_context := public.mini_app_notify_context(f.token_hash, f.organization_id, 'push-contract');
  if v_context ->> 'reason' is distinct from 'scope_not_requested' then
    raise exception 'App without notification scope was allowed to send';
  end if;
  update core.mini_apps set requested_permissions = array['notifications']
  where id = f.app_id;

  v_context := public.mini_app_notify_context(f.token_hash, f.organization_id, ' PUSH-CONTRACT ');
  v_first := (v_context ->> 'reservationId')::uuid;
  if v_context ->> 'ok' is distinct from 'true' or v_first is null
    or jsonb_array_length(v_context -> 'recipients') <> 2
    or not (v_context -> 'recipients' @> jsonb_build_array(f.first_id, f.second_id))
    or (select count(*) from core.mini_app_push_log where reservation_id = v_first
      and sent_at is null and reserved_at is not null) <> 2 then
    raise exception 'Recipients were not reserved before delivery';
  end if;
  perform public.finalize_mini_app_push(f.other_app_id, v_first, '{}');
  if (select count(*) from core.mini_app_push_log where reservation_id = v_first) <> 2 then
    raise exception 'Finalization crossed the app boundary';
  end if;
  perform public.finalize_mini_app_push(f.app_id, v_first, array[f.first_id]);
  if (select count(*) from core.mini_app_push_log where reservation_id = v_first) <> 1
    or not exists(select 1 from core.mini_app_push_log where reservation_id = v_first
      and user_id = f.first_id and sent_at is not null) then
    raise exception 'Partial delivery did not finalize only reached recipients';
  end if;
  update core.mini_app_push_log set sent_at = v_sent_at where reservation_id = v_first;
  perform public.finalize_mini_app_push(f.app_id, v_first, array[f.first_id, f.second_id]);
  perform public.finalize_mini_app_push(f.app_id, v_first, '{}');
  perform public.finalize_mini_app_push(f.app_id, v_first, null);
  if (select count(*) from core.mini_app_push_log where reservation_id = v_first) <> 1
    or not exists(select 1 from core.mini_app_push_log where reservation_id = v_first
      and user_id = f.first_id and sent_at = v_sent_at) then
    raise exception 'Retried finalization changed confirmed delivery or its quota timestamp';
  end if;

  v_context := public.mini_app_notify_context(f.token_hash, f.organization_id, 'push-contract');
  v_second := (v_context ->> 'reservationId')::uuid;
  if jsonb_array_length(v_context -> 'recipients') <> 2 then
    raise exception 'Failed recipients did not regain quota';
  end if;
  v_context := public.mini_app_notify_context(f.token_hash, f.organization_id, 'push-contract');
  v_third := (v_context ->> 'reservationId')::uuid;
  if v_context -> 'recipients' is distinct from jsonb_build_array(f.second_id) then
    raise exception 'Pending reservations do not consume the per-user quota';
  end if;
  perform public.finalize_mini_app_push(f.app_id, v_second, '{}');
  if exists(select 1 from core.mini_app_push_log where reservation_id = v_second)
    or not exists(select 1 from core.mini_app_push_log where reservation_id = v_third) then
    raise exception 'Empty finalization did not release only its reservation';
  end if;
  update core.mini_app_push_log set reserved_at = now() - interval '16 minutes'
  where reservation_id = v_third;
  v_context := public.mini_app_notify_context(f.token_hash, f.organization_id, 'push-contract');
  if jsonb_array_length(v_context -> 'recipients') <> 2
    or exists(select 1 from core.mini_app_push_log where reservation_id = v_third)
    or not exists(select 1 from core.mini_app_push_log where reservation_id = v_first
      and sent_at = v_sent_at) then
    raise exception 'Expired reservation recovery removed confirmed delivery or held quota';
  end if;
  v_context := public.mini_app_notify_context(f.token_hash, f.organization_id, 'push-contract', 0);
  if jsonb_array_length(v_context -> 'recipients') <> 0 then
    raise exception 'Daily limit lower bound was not enforced';
  end if;

  delete from core.mini_app_push_log where app_id = f.app_id;
  for v_index in 1..5 loop
    v_context := public.mini_app_notify_context(f.token_hash, f.organization_id, 'push-contract', 99);
    if jsonb_array_length(v_context -> 'recipients') <> 2 then
      raise exception 'Clamped daily limit rejected an eligible reservation';
    end if;
  end loop;
  v_context := public.mini_app_notify_context(f.token_hash, f.organization_id, 'push-contract', 99);
  if jsonb_array_length(v_context -> 'recipients') <> 0 then
    raise exception 'Daily limit upper bound was not enforced';
  end if;
end;
$$;

do $$
declare
  f mini_push_fixture;
  v_context jsonb;
  v_first uuid;
  v_second uuid;
  v_devices jsonb;
  v_first_token text;
  v_second_token text;
  v_other_token text;
begin
  select * into f from mini_push_fixture;
  delete from core.mini_app_push_log where app_id = f.app_id;
  v_first_token := 'push-contract-first-' || f.first_id::text;
  v_second_token := 'push-contract-second-' || f.second_id::text;
  v_other_token := 'push-contract-other-' || f.unconsented_id::text;
  insert into core.user_devices (fcm_token, user_id, platform) values
    (v_first_token, f.first_id, 'android'),
    (v_second_token, f.second_id, 'ios'),
    (v_other_token, f.unconsented_id, 'web');
  v_context := public.mini_app_notify_context(f.token_hash, f.organization_id, 'push-contract');
  v_first := (v_context ->> 'reservationId')::uuid;
  v_devices := public.mini_app_push_devices(f.app_id, v_first);
  if jsonb_array_length(v_devices) is distinct from 2
    or not (v_devices @> jsonb_build_array(jsonb_build_object(
      'user_id', f.first_id, 'fcm_token', v_first_token,
      'platform', 'android', 'cns_endpoint_arn', null)))
    or not (v_devices @> jsonb_build_array(jsonb_build_object(
      'user_id', f.second_id, 'fcm_token', v_second_token, 'platform', 'ios')))
    or public.mini_app_push_devices(f.other_app_id, v_first) <> '[]'::jsonb
    or public.mini_app_push_devices(f.app_id, extensions.gen_random_uuid()) <> '[]'::jsonb
    or public.mini_app_push_devices(null, null) <> '[]'::jsonb then
    raise exception 'Device lookup crossed reservation or recipient boundaries';
  end if;

  perform public.set_mini_app_push_endpoint(f.other_app_id, v_first, v_first_token, 'wrong-app');
  perform public.set_mini_app_push_endpoint(f.app_id, extensions.gen_random_uuid(), v_first_token, 'wrong-reservation');
  perform public.set_mini_app_push_endpoint(f.app_id, v_first, v_other_token, 'wrong-user');
  perform public.delete_mini_app_push_devices(f.other_app_id, v_first, array[v_first_token]);
  perform public.delete_mini_app_push_devices(f.app_id, extensions.gen_random_uuid(), array[v_second_token]);
  perform public.delete_mini_app_push_devices(f.app_id, v_first, array[v_other_token]);
  if (select count(*) from core.user_devices where user_id = any(array[
    f.first_id, f.second_id, f.unconsented_id])) <> 3
    or exists(select 1 from core.user_devices where user_id = any(array[
      f.first_id, f.second_id, f.unconsented_id]) and cns_endpoint_arn is not null) then
    raise exception 'Device mutation crossed reservation or recipient boundaries';
  end if;

  perform public.set_mini_app_push_endpoint(f.app_id, v_first, v_first_token, 'contract-endpoint');
  if not (public.mini_app_push_devices(f.app_id, v_first) @>
    jsonb_build_array(jsonb_build_object('fcm_token', v_first_token,
      'cns_endpoint_arn', 'contract-endpoint'))) then
    raise exception 'Reserved device endpoint was not persisted';
  end if;
  update core.mini_app_push_log set reserved_at = now() - interval '16 minutes'
  where reservation_id = v_first;
  perform public.set_mini_app_push_endpoint(f.app_id, v_first, v_first_token, 'expired');
  perform public.delete_mini_app_push_devices(f.app_id, v_first, array[v_second_token]);
  if public.mini_app_push_devices(f.app_id, v_first) <> '[]'::jsonb
    or not exists(select 1 from core.user_devices where fcm_token = v_second_token)
    or not exists(select 1 from core.user_devices where fcm_token = v_first_token
      and cns_endpoint_arn = 'contract-endpoint') then
    raise exception 'Expired reservation retained device access';
  end if;
  update core.mini_app_push_log set reserved_at = now() where reservation_id = v_first;
  perform public.delete_mini_app_push_devices(f.app_id, v_first,
    array[v_second_token, v_other_token, null]);
  if exists(select 1 from core.user_devices where fcm_token = v_second_token)
    or not exists(select 1 from core.user_devices where fcm_token = v_other_token) then
    raise exception 'Stale device cleanup did not isolate reserved users';
  end if;
  perform public.finalize_mini_app_push(f.app_id, v_first, array[f.first_id]);
  perform public.set_mini_app_push_endpoint(f.app_id, v_first, v_first_token, 'finalized');
  perform public.delete_mini_app_push_devices(f.app_id, v_first, array[v_first_token]);
  if public.mini_app_push_devices(f.app_id, v_first) <> '[]'::jsonb
    or not exists(select 1 from core.user_devices where fcm_token = v_first_token
      and cns_endpoint_arn = 'contract-endpoint') then
    raise exception 'Finalized reservation retained device access';
  end if;

  delete from core.mini_app_push_log where app_id = f.app_id;
  perform public.log_mini_app_push(f.app_id, array[f.first_id, f.first_id, null]);
  perform public.log_mini_app_push(f.app_id, '{}');
  perform public.log_mini_app_push(f.app_id, null);
  if (select count(*) from core.mini_app_push_log where app_id = f.app_id) <> 1
    or not exists(select 1 from core.mini_app_push_log where app_id = f.app_id
      and user_id = f.first_id and sent_at is not null and reservation_id is not null) then
    raise exception 'Legacy in-flight delivery lost confirmation or duplicated recipients';
  end if;
  delete from core.mini_app_push_log where app_id = f.app_id;
  v_context := public.mini_app_notify_context(f.token_hash, f.organization_id, 'push-contract');
  v_first := (v_context ->> 'reservationId')::uuid;
  v_context := public.mini_app_notify_context(f.token_hash, f.organization_id, 'push-contract');
  v_second := (v_context ->> 'reservationId')::uuid;
  perform public.log_mini_app_push(f.app_id, array[f.first_id, f.first_id]);
  if (select count(*) from core.mini_app_push_log where reservation_id = v_first
      and sent_at is null) <> 2
    or (select count(*) from core.mini_app_push_log where reservation_id = v_second
      and sent_at is null) <> 2
    or (select count(*) from core.mini_app_push_log where app_id = f.app_id
      and user_id = f.first_id and sent_at is not null) <> 1 then
    raise exception 'Legacy bridge consumed a concurrent reservation';
  end if;
  perform public.finalize_mini_app_push(f.app_id, v_second, '{}');
  if (select count(*) from core.mini_app_push_log where reservation_id = v_first
      and sent_at is null) <> 2
    or (select count(*) from core.mini_app_push_log where app_id = f.app_id
      and user_id = f.first_id and sent_at is not null) <> 1 then
    raise exception 'New finalization changed legacy confirmed delivery';
  end if;
end;
$$;

reset role;
rollback;
