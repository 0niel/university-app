begin;

create temporary table poll_org_fixture (
  owner_id uuid, anonymous_id uuid, foreign_id uuid, unprofiled_id uuid,
  organization_id text, foreign_organization_id text,
  legacy_poll_id uuid, modern_poll_id uuid, foreign_poll_id uuid,
  legacy_option_id uuid, modern_question_id uuid, modern_option_id uuid
);
insert into poll_org_fixture (
  owner_id, anonymous_id, foreign_id, unprofiled_id,
  organization_id, foreign_organization_id
) values (
  extensions.gen_random_uuid(), extensions.gen_random_uuid(),
  extensions.gen_random_uuid(), extensions.gen_random_uuid(),
  'poll-contract-' || extensions.gen_random_uuid()::text,
  'poll-foreign-' || extensions.gen_random_uuid()::text
);
grant select, update on poll_org_fixture to authenticated;

create function pg_temp.expect_poll_org_error(p_sql text, p_state text)
returns void language plpgsql security invoker set search_path = '' as $$
declare v_state text;
begin
  begin execute p_sql;
  exception when others then
    get stacked diagnostics v_state = returned_sqlstate;
    if v_state = p_state then return; end if;
    raise exception 'Unexpected SQL state: %', v_state;
  end;
  raise exception 'Expected SQL state: %', p_state;
end;
$$;

do $$
declare f poll_org_fixture;
begin
  select * into f from poll_org_fixture;
  insert into core.organizations (id, name) values
    (f.organization_id, 'Poll Contract'),
    (f.foreign_organization_id, 'Foreign Poll Contract');
  insert into auth.users (id, is_anonymous) values
    (f.owner_id, false), (f.anonymous_id, true),
    (f.foreign_id, false), (f.unprofiled_id, true);
  insert into core.user_academic_profiles (user_id, organization_id) values
    (f.owner_id, f.organization_id),
    (f.foreign_id, f.foreign_organization_id);
end;
$$;

set local role authenticated;
select set_config('request.jwt.claim.sub', owner_id::text, true),
  set_config('request.jwt.claims', jsonb_build_object(
    'sub', owner_id, 'role', 'authenticated', 'is_anonymous', false)::text, true)
from poll_org_fixture;

do $$
declare f poll_org_fixture; v_poll jsonb;
begin
  select * into f from poll_org_fixture;
  f.legacy_poll_id := public.create_poll(f.organization_id, 'Legacy same organization',
    array['One', 'Two'], 'single', false, true, null, null);
  select id into strict f.legacy_option_id from core.poll_options
  where poll_id = f.legacy_poll_id and position = 0;
  v_poll := public.create_poll_v2(f.organization_id, 'Modern same organization', '', null,
    false, 'after_vote', null, true,
    '[{"text":"Choose","kind":"single","options":["Yes","No"]}]');
  if v_poll is null or v_poll ->> 'id' is null then
    raise exception 'Same-organization creation returned no poll';
  end if;
  f.modern_poll_id := (v_poll ->> 'id')::uuid;
  f.modern_question_id := (v_poll #>> '{questions,0,id}')::uuid;
  f.modern_option_id := (v_poll #>> '{questions,0,options,0,id}')::uuid;
  if f.modern_question_id is null or f.modern_option_id is null then
    raise exception 'Modern poll lost question or option';
  end if;
  update poll_org_fixture set legacy_poll_id = f.legacy_poll_id,
    modern_poll_id = f.modern_poll_id, legacy_option_id = f.legacy_option_id,
    modern_question_id = f.modern_question_id, modern_option_id = f.modern_option_id;
end;
$$;

select set_config('request.jwt.claim.sub', foreign_id::text, true),
  set_config('request.jwt.claims', jsonb_build_object(
    'sub', foreign_id, 'role', 'authenticated', 'is_anonymous', false)::text, true)
from poll_org_fixture;

do $$
declare f poll_org_fixture; v_poll_id uuid;
begin
  select * into f from poll_org_fixture;
  if public.get_polls(f.organization_id) is distinct from '[]'::jsonb
    or public.get_polls_v2(f.organization_id) is distinct from '[]'::jsonb then
    raise exception 'Foreign organization list leaked polls';
  end if;
  if core.poll_to_json(f.modern_poll_id, f.foreign_id) is not null
    or exists (select 1 from core.polls where organization_id = f.organization_id) then
    raise exception 'Foreign organization poll detail leaked';
  end if;
  perform pg_temp.expect_poll_org_error(format(
    'select core.poll_to_json(%L,%L)', f.modern_poll_id, f.owner_id), '42501');
  perform pg_temp.expect_poll_org_error(format(
    'select public.create_poll(%L,%L,array[%L,%L])',
    f.organization_id, 'Foreign create', 'One', 'Two'), '42501');
  perform pg_temp.expect_poll_org_error(format(
    'select public.create_poll_v2(%L,%L,p_questions := %L::jsonb)',
    f.organization_id, 'Foreign modern create',
    '[{"text":"Choose","kind":"single","options":["One","Two"]}]'), '42501');
  perform pg_temp.expect_poll_org_error(format(
    'select public.vote_poll(%L,array[%L]::uuid[])',
    f.legacy_poll_id, f.legacy_option_id), '22023');
  perform pg_temp.expect_poll_org_error(format(
    'select public.submit_poll_answers(%L,%L::jsonb)', f.modern_poll_id,
    jsonb_build_array(jsonb_build_object('questionId', f.modern_question_id,
      'optionIds', jsonb_build_array(f.modern_option_id)))::text), 'P0001');
  perform pg_temp.expect_poll_org_error(format(
    'insert into core.polls (organization_id,author_id,question,title) values (%L,%L,%L,%L)',
    f.organization_id, f.foreign_id, 'Direct foreign', 'Direct foreign'), '42501');
  v_poll_id := public.create_poll(f.foreign_organization_id, 'Foreign own poll', array['A', 'B']);
  update poll_org_fixture set foreign_poll_id = v_poll_id;
  if jsonb_array_length(public.get_polls(f.foreign_organization_id)) <> 1
    or jsonb_array_length(public.get_polls_v2(f.foreign_organization_id)) <> 1 then
    raise exception 'Foreign user lost access to own organization';
  end if;
end;
$$;

select set_config('request.jwt.claim.sub', unprofiled_id::text, true),
  set_config('request.jwt.claims', jsonb_build_object(
    'sub', unprofiled_id, 'role', 'authenticated', 'is_anonymous', true)::text, true)
from poll_org_fixture;

do $$
declare f poll_org_fixture;
begin
  select * into f from poll_org_fixture;
  if public.get_polls(f.organization_id) is distinct from '[]'::jsonb
    or public.get_polls_v2(f.organization_id) is distinct from '[]'::jsonb
    or core.poll_to_json(f.modern_poll_id, f.unprofiled_id) is not null then
    raise exception 'Unprofiled user read organization polls';
  end if;
  perform pg_temp.expect_poll_org_error(format(
    'select public.create_poll(%L,%L,array[%L,%L])',
    f.organization_id, 'Unprofiled create', 'One', 'Two'), '42501');
  perform pg_temp.expect_poll_org_error(format(
    'select public.create_poll_v2(%L,%L,p_questions := %L::jsonb)',
    f.organization_id, 'Unprofiled modern create',
    '[{"text":"Choose","kind":"single","options":["One","Two"]}]'), '42501');
  perform pg_temp.expect_poll_org_error(format(
    'select public.vote_poll(%L,array[%L]::uuid[])',
    f.legacy_poll_id, f.legacy_option_id), '22023');
  perform pg_temp.expect_poll_org_error(format(
    'select public.submit_poll_answers(%L,%L::jsonb)', f.modern_poll_id,
    jsonb_build_array(jsonb_build_object('questionId', f.modern_question_id,
      'optionIds', jsonb_build_array(f.modern_option_id)))::text), 'P0001');
end;
$$;

select set_config('request.jwt.claim.sub', anonymous_id::text, true),
  set_config('request.jwt.claims', jsonb_build_object(
    'sub', anonymous_id, 'role', 'authenticated', 'is_anonymous', true)::text, true)
from poll_org_fixture;

do $$
declare f poll_org_fixture; v_legacy jsonb; v_modern jsonb; v_poll jsonb; v_poll_id uuid;
begin
  select * into f from poll_org_fixture;
  perform public.ensure_academic_profile(f.organization_id, null);
  if not exists (select 1 from core.user_academic_profiles
    where user_id = f.anonymous_id and organization_id = f.organization_id
      and academic_group is null) then
    raise exception 'Anonymous profile bootstrap failed';
  end if;
  v_legacy := public.get_polls(f.organization_id);
  v_modern := public.get_polls_v2(f.organization_id);
  if v_legacy is null or jsonb_array_length(v_legacy) <> 2
    or v_modern is null or jsonb_array_length(v_modern) <> 2 then
    raise exception 'Anonymous same-organization lists lost polls';
  end if;
  if public.get_polls(f.foreign_organization_id) is distinct from '[]'::jsonb
    or public.get_polls_v2(f.foreign_organization_id) is distinct from '[]'::jsonb
    or core.poll_to_json(f.foreign_poll_id, f.anonymous_id) is not null then
    raise exception 'Anonymous user read foreign organization';
  end if;
  perform public.vote_poll(f.legacy_poll_id, array[f.legacy_option_id]);
  v_poll := public.submit_poll_answers(f.modern_poll_id,
    jsonb_build_array(jsonb_build_object('questionId', f.modern_question_id,
      'optionIds', jsonb_build_array(f.modern_option_id))));
  if v_poll is null or (v_poll ->> 'iParticipated')::boolean is not true then
    raise exception 'Anonymous modern participation failed';
  end if;
  if not exists (select 1 from core.poll_votes
      where poll_id = f.legacy_poll_id and user_id = f.anonymous_id)
    or not exists (select 1 from core.poll_answers
      where poll_id = f.modern_poll_id and user_id = f.anonymous_id) then
    raise exception 'Anonymous votes did not persist in both models';
  end if;
  v_poll_id := public.create_poll(f.organization_id, 'Anonymous legacy create', array['A', 'B']);
  if v_poll_id is null then raise exception 'Anonymous legacy creation failed'; end if;
  v_poll := public.create_poll_v2(f.organization_id, 'Anonymous modern create',
    p_questions := '[{"text":"Explain","kind":"text"}]');
  if v_poll is null or v_poll ->> 'id' is null then
    raise exception 'Anonymous modern creation failed';
  end if;
end;
$$;

reset role;
do $$
declare f poll_org_fixture;
begin
  select * into f from poll_org_fixture;
  if exists (select 1 from core.polls
      where author_id in (f.foreign_id, f.unprofiled_id) and organization_id = f.organization_id)
    or exists (select 1 from core.poll_votes
      where poll_id in (f.legacy_poll_id, f.modern_poll_id)
        and user_id in (f.foreign_id, f.unprofiled_id))
    or exists (select 1 from core.poll_answers
      where poll_id in (f.legacy_poll_id, f.modern_poll_id)
        and user_id in (f.foreign_id, f.unprofiled_id)) then
    raise exception 'Rejected cross-organization operation persisted data';
  end if;
end;
$$;

rollback;
