begin;

delete from internal.app_config where key in ('app_push_url', 'app_push_secret');

do $$
declare
  v_mentor uuid := extensions.gen_random_uuid();
  v_requester uuid := extensions.gen_random_uuid();
  v_request uuid;
  v_legacy uuid := extensions.gen_random_uuid();
begin
  insert into core.organizations (id, name) values ('free-mentorship', 'Free mentorship');
  insert into auth.users (id) values (v_mentor), (v_requester);
  insert into core.user_academic_profiles (user_id, organization_id, full_name, academic_group)
  values (v_mentor, 'free-mentorship', 'Mentor', 'FREE-01'),
    (v_requester, 'free-mentorship', 'Requester', 'FREE-01');
  perform set_config('request.jwt.claim.sub', v_mentor::text, true);
  perform app_api_v1.upsert_mentor_profile(
    p_organization_id := 'free-mentorship', p_topics := array['Custom expertise'],
    p_bio := 'Bio', p_level := '', p_formats := array['Online'], p_price := 300
  );
  if not exists (select 1 from core.mentor_profiles where user_id = v_mentor
      and price = 0 and 'Custom expertise' = any(topics)) then
    raise exception 'Mentor profile did not preserve custom topic and ignore legacy price';
  end if;
  update core.mentor_profiles set price = 500 where user_id = v_mentor;
  if (select price from core.mentor_profiles where user_id = v_mentor) <> 0 then
    raise exception 'Profile update restored a paid session';
  end if;
  perform app_api_v1.upsert_mentor_profile(
    p_organization_id := 'free-mentorship', p_topics := array['Custom expertise'],
    p_bio := 'Bio', p_level := '', p_formats := array['Online'], p_price := -1
  );
  if (select price from core.mentor_profiles where user_id = v_mentor) <> 0 then
    raise exception 'Legacy negative price sentinel was not normalized';
  end if;
  perform set_config('request.jwt.claim.sub', v_requester::text, true);
  v_request := app_api_v1.create_mentor_request('free-mentorship', v_mentor, 'Custom expertise');
  if (select price from core.mentor_requests where id = v_request) <> 0 then
    raise exception 'New mentor request retained a session charge';
  end if;
  if has_function_privilege('authenticated', 'internal.enforce_free_mentorship()', 'EXECUTE') then
    raise exception 'Internal pricing trigger is directly exposed';
  end if;

  update core.mentor_requests set status = 'cancelled' where id = v_request;
  insert into core.mentor_requests (id, organization_id, mentor_user_id, requester_id, topic, price)
  values (v_legacy, 'free-mentorship', v_mentor, v_requester, 'Custom expertise', 500);
  if (select price from core.mentor_requests where id = v_legacy) <> 0 then
    raise exception 'New direct request bypassed free session pricing';
  end if;
  update core.mentor_requests set price = 250, status = 'accepted' where id = v_legacy;
  update core.mentor_requests set status = 'cancelled' where id = v_legacy;
  if (select price from core.mentor_requests where id = v_legacy) <> 250 then
    raise exception 'Historical request amount was rewritten during lifecycle update';
  end if;
end;
$$;

rollback;
