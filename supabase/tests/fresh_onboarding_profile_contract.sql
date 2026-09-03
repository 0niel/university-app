begin;

set local statement_timeout = '20s';
set local lock_timeout = '5s';

do $$
declare
  v_normal_cached uuid := extensions.gen_random_uuid();
  v_guest_cached uuid := extensions.gen_random_uuid();
  v_normal_selected uuid := extensions.gen_random_uuid();
  v_guest_selected uuid := extensions.gen_random_uuid();
  v_guest_empty uuid := extensions.gen_random_uuid();
  v_peer uuid := extensions.gen_random_uuid();
  v_outsider uuid := extensions.gen_random_uuid();
  v_user uuid;
  v_guest boolean;
  v_cached boolean;
  v_profile core.user_academic_profiles;
  v_rows jsonb;
  v_roster jsonb;
  v_snapshot jsonb;
  v_before_identity jsonb;
  v_denied integer;
begin
  insert into core.organizations (id, name) values
    ('fresh-onboarding-a', 'Fresh Onboarding A'),
    ('fresh-onboarding-b', 'Fresh Onboarding B');
  insert into auth.users (id, is_anonymous, raw_app_meta_data) values
    (v_normal_cached, false, '{"contract":"fresh_onboarding"}'),
    (v_guest_cached, true, '{"contract":"fresh_onboarding"}'),
    (v_normal_selected, false, '{"contract":"fresh_onboarding"}'),
    (v_guest_selected, true, '{"contract":"fresh_onboarding"}'),
    (v_guest_empty, true, '{"contract":"fresh_onboarding"}'),
    (v_peer, false, '{"contract":"fresh_onboarding"}'),
    (v_outsider, false, '{"contract":"fresh_onboarding"}');
  insert into core.user_academic_profiles (
    user_id, organization_id, academic_group, full_name
  ) values
    (v_peer, 'fresh-onboarding-a', 'GROUP-01', 'Bootstrap Contract Peer'),
    (v_outsider, 'fresh-onboarding-b', 'GROUP-01', 'Bootstrap Contract Outside');

  if has_function_privilege('anon', 'public.ensure_academic_profile(text,text)', 'execute')
    or has_function_privilege('anon', 'app_api_v1.ensure_academic_profile(text,text)', 'execute')
    or not has_function_privilege('authenticated', 'public.ensure_academic_profile(text,text)', 'execute') then
    raise exception 'Academic bootstrap privileges are invalid';
  end if;

  foreach v_user in array array[
    v_normal_cached, v_guest_cached, v_normal_selected, v_guest_selected
  ] loop
    v_guest := v_user in (v_guest_cached, v_guest_selected);
    v_cached := v_user in (v_normal_cached, v_guest_cached);
    perform set_config('request.jwt.claim.role', 'authenticated', true);
    perform set_config('request.jwt.claim.sub', v_user::text, true);
    perform set_config('request.jwt.claims', jsonb_build_object(
      'sub', v_user, 'role', 'authenticated', 'is_anonymous', v_guest
    )::text, true);
    execute 'set local role authenticated';
    if (select auth.uid()) is distinct from v_user
      or (select (auth.jwt()->>'is_anonymous')::boolean) is distinct from v_guest then
      raise exception 'Fresh authentication claims are invalid';
    end if;

    v_denied := 0;
    begin
      perform public.get_group_members();
    exception when insufficient_privilege then v_denied := v_denied + 1;
    end;
    begin
      perform public.ensure_gamification_profile('fresh-onboarding-a');
    exception when insufficient_privilege then v_denied := v_denied + 1;
    end;
    if v_denied <> 2 then
      raise exception 'Profile-missing access must remain denied before bootstrap';
    end if;

    if v_cached then
      perform public.set_user_preference(
        'selected_schedule', '{"type":"group","name":"GROUP-01"}'::jsonb
      );
      perform public.ensure_academic_profile('fresh-onboarding-a');
    else
      perform public.ensure_academic_profile('fresh-onboarding-a');
      perform public.ensure_academic_profile('fresh-onboarding-a', 'GROUP-01');
      perform public.set_user_preference(
        'selected_schedule', '{"type":"group","name":"GROUP-01"}'::jsonb
      );
    end if;

    execute 'reset role';
    select * into strict v_profile from core.user_academic_profiles
    where user_id = v_user;
    if v_profile.organization_id <> 'fresh-onboarding-a'
      or v_profile.academic_group is distinct from 'GROUP-01'
      or v_profile.full_name is not null or v_profile.handle is not null
      or exists (select 1 from auth.users where id = v_user and email is not null) then
      raise exception 'Bootstrap lost group or invented personal identity';
    end if;
    execute 'set local role authenticated';

    if not v_guest then
      perform public.set_user_identity(
        'fresh-onboarding-a', 'Bootstrap Contract Normal',
        'boot_' || left(replace(v_user::text, '-', ''), 15)
      );
    end if;
    perform public.ensure_gamification_profile('fresh-onboarding-a');
    perform public.record_active_day();
    v_roster := public.get_group_members();
    if v_roster->>'group' is distinct from 'GROUP-01'
      or not exists (
        select 1 from jsonb_array_elements(v_roster->'members') member
        where member->>'userId' = v_peer::text
      ) or exists (
        select 1 from jsonb_array_elements(v_roster->'members') member
        where member->>'userId' = v_outsider::text
      ) then
      raise exception 'Fresh onboarding roster lost its peer or crossed tenant';
    end if;
    v_rows := public.search_users('Bootstrap Contract');
    if not exists (
      select 1 from jsonb_array_elements(v_rows) person
      where person->>'userId' = v_peer::text
    ) or exists (
      select 1 from jsonb_array_elements(v_rows) person
      where person->>'userId' = v_outsider::text
    ) then
      raise exception 'Fresh onboarding people search lost peer or crossed tenant';
    end if;
    perform public.get_people_you_may_know(12);
    v_snapshot := public.get_my_study_group('fresh-onboarding-a');
    if (v_snapshot->>'hasGroup')::boolean is distinct from false
      or v_snapshot->'members' is distinct from '[]'::jsonb then
      raise exception 'Academic onboarding must not invent study-group membership';
    end if;

    v_before_identity := public.get_profile_overview('fresh-onboarding-a')->'academic';
    perform public.ensure_academic_profile('fresh-onboarding-a', 'OTHER-99');
    perform public.ensure_academic_profile('fresh-onboarding-a');
    if public.get_profile_overview('fresh-onboarding-a')->'academic'
      is distinct from v_before_identity then
      raise exception 'Idempotent bootstrap replaced an existing identity or group';
    end if;

    v_denied := 0;
    begin
      perform public.ensure_academic_profile('fresh-onboarding-b', 'OTHER-99');
    exception when insufficient_privilege then v_denied := v_denied + 1;
    end;
    begin
      perform public.search_study_groups('fresh-onboarding-b', 'Bootstrap');
    exception when insufficient_privilege then v_denied := v_denied + 1;
    end;
    if v_denied <> 2 then
      raise exception 'Academic bootstrap weakened tenant isolation';
    end if;
    execute 'reset role';
    if not exists (
      select 1 from core.user_academic_profiles
      where user_id = v_user and organization_id = 'fresh-onboarding-a'
        and academic_group = 'GROUP-01'
    ) then
      raise exception 'Denied bootstrap mutated existing membership';
    end if;
  end loop;

  perform set_config('request.jwt.claim.sub', v_guest_empty::text, true);
  perform set_config('request.jwt.claims', jsonb_build_object(
    'sub', v_guest_empty, 'role', 'authenticated', 'is_anonymous', true
  )::text, true);
  execute 'set local role authenticated';
  perform public.set_user_preference(
    'selected_schedule', '{"type":"teacher","name":"Not A Group"}'::jsonb
  );
  perform public.ensure_academic_profile('fresh-onboarding-a');
  perform public.ensure_gamification_profile('fresh-onboarding-a');
  v_roster := public.get_group_members();
  if coalesce(jsonb_array_length(v_roster->'members'), 0) <> 0 then
    raise exception 'Group-free guest must not receive an invented roster';
  end if;
  execute 'reset role';
  select * into strict v_profile from core.user_academic_profiles
  where user_id = v_guest_empty;
  if v_profile.academic_group is not null or v_profile.full_name is not null
    or v_profile.handle is not null then
    raise exception 'Anonymous skip must not require or invent a group or identity';
  end if;

  perform set_config('request.jwt.claim.sub', '', true);
  perform set_config('request.jwt.claims', '{"role":"authenticated"}', true);
  execute 'set local role authenticated';
  begin
    perform public.ensure_academic_profile('fresh-onboarding-a');
    raise exception 'Academic bootstrap accepted missing authentication';
  exception when insufficient_privilege then null;
  end;
  execute 'reset role';
  raise notice 'fresh_onboarding_profile_contract PASS: four normal/guest cached/selected flows, profile-missing denial, minimal identity, roster, people, wallet, tenant isolation, idempotence, anonymous skip, missing-auth denial';
end;
$$;

rollback;
