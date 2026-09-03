begin;

create temporary table release_fixture (
  owner_id uuid, member_id uuid, outsider_id uuid, foreign_id uuid,
  group_id uuid, post_id uuid, note_id uuid, material_id uuid, room_photo_id uuid,
  poll_id uuid, second_poll_id uuid, quiz_poll_id uuid
);
insert into release_fixture (owner_id, member_id, outsider_id, foreign_id, group_id)
values (extensions.gen_random_uuid(), extensions.gen_random_uuid(),
  extensions.gen_random_uuid(), extensions.gen_random_uuid(), extensions.gen_random_uuid());
grant select, update on release_fixture to authenticated;

create function pg_temp.expect_release_error(p_sql text, p_state text)
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
declare f release_fixture; v_signature text;
begin
  select * into f from release_fixture;
  foreach v_signature in array array[
    'public.save_group_note_document(uuid,jsonb,bigint)',
    'public.rename_group_note(uuid,text)',
    'public.set_group_note_visibility(uuid,text)',
    'public.upsert_mentor_profile(text,text[],text,text,text,text[],integer)',
    'public.upsert_mentor_profile(text,text[],text,text,text[],integer)',
    'public.delete_room_photo_v2(uuid)'
  ] loop
    if to_regprocedure(v_signature) is null
      or has_function_privilege('anon', v_signature, 'EXECUTE')
      or not has_function_privilege('authenticated', v_signature, 'EXECUTE') then
      raise exception 'Invalid RPC grant: %', v_signature;
    end if;
  end loop;
  if exists (
    select 1 from core.poll_votes vote
    join core.poll_options option on option.id = vote.option_id
    where option.question_id is not null and not exists (
      select 1 from core.poll_answers answer
      where answer.poll_id = vote.poll_id and answer.option_id = vote.option_id
        and answer.user_id = vote.user_id
    )
  ) then
    raise exception 'Historical votes are missing from the new model';
  end if;
  insert into core.organizations (id, name) values
    ('september-release-contract', 'Release Contract'),
    ('september-release-foreign', 'Foreign Contract');
  insert into auth.users (id) values
    (f.owner_id), (f.member_id), (f.outsider_id), (f.foreign_id);
  insert into core.user_academic_profiles (user_id, organization_id, academic_group)
  select id, case when id = f.foreign_id then 'september-release-foreign'
    else 'september-release-contract' end, 'TEST-01'
  from unnest(array[f.owner_id, f.member_id, f.outsider_id, f.foreign_id]) id;
  insert into core.study_groups (id, organization_id, owner_id, name, join_code)
  values (f.group_id, 'september-release-contract', f.owner_id, 'Test', 'SEPTEST1');
  insert into core.study_group_members (group_id, user_id, role) values
    (f.group_id, f.owner_id, 'owner'), (f.group_id, f.member_id, 'member');
  insert into core.group_posts (organization_id, group_id, author_id, title, body, kind)
  values ('september-release-contract', f.group_id, f.owner_id, 'Test', 'Body', 'note')
  returning id into f.post_id;
  update release_fixture set post_id = f.post_id;
  insert into storage.objects (bucket_id, name, owner_id, metadata) values
    ('lesson-materials', f.owner_id || '/bank/large', f.owner_id::text,
      '{"size":62914560,"mimetype":"application/pdf"}'),
    ('lesson-materials', f.owner_id || '/bank/previews/test.jpg', f.owner_id::text,
      '{"size":3,"mimetype":"image/jpeg"}'),
    ('room-photos', f.owner_id || '/test.jpg', f.owner_id::text,
      '{"size":3,"mimetype":"image/jpeg"}');
  insert into core.room_photos (organization_id, campus, room_key, path, created_by)
  values ('september-release-contract', 'V78', '101', f.owner_id || '/test.jpg', f.owner_id)
  returning id into f.room_photo_id;
  update release_fixture set room_photo_id = f.room_photo_id;
end;
$$;

set local role authenticated;
select set_config('request.jwt.claim.sub', owner_id::text, true) from release_fixture;

do $$
declare f release_fixture; v_result jsonb; v_question uuid; v_option uuid;
begin
  select * into f from release_fixture;
  f.note_id := public.create_group_note('september-release-contract', 'Note', 'group');
  perform public.rename_group_note(f.note_id, 'Renamed');
  v_result := public.save_group_note_document(f.note_id, '[{"insert":"Text\n"}]', 0);
  if (v_result ->> 'conflict')::boolean or (v_result ->> 'revision')::bigint <> 1 then
    raise exception 'Document save did not persist revision';
  end if;
  v_result := public.save_group_note_document(f.note_id, '[{"insert":"Stale\n"}]', 0);
  if (v_result ->> 'conflict')::boolean is not true then
    raise exception 'Stale document revision was accepted';
  end if;
  perform public.upsert_mentor_profile('september-release-contract', array['Math'],
    'Bio', '', '{}'::text[], 0);
  perform public.upsert_mentor_profile('september-release-contract', array['Math'],
    'release_test', 'Bio', '', '{}'::text[], 0);
  perform public.upsert_mentor_profile('september-release-contract', array['Math'],
    'Legacy edit', '', '{}'::text[], 0);
  f.material_id := public.create_public_material_v3(
    'september-release-contract', 'Paid notes', array['Math'], 'note', 30, 0,
    false, 'large.pdf', f.owner_id || '/bank/large', 'application/pdf', 62914560,
    f.owner_id || '/bank/previews/test.jpg');
  perform pg_temp.expect_release_error(format(
    'select public.create_public_material_v3(%L,%L,array[%L],%L,0,0,false,%L,%L,%L,104857601)',
    'september-release-contract', 'Too large', 'Math', 'note', 'large.pdf',
    f.owner_id || '/bank/large', 'application/pdf'), '22023');
  f.poll_id := public.create_poll('september-release-contract', 'Legacy poll',
    array['One', 'Two'], 'multi', false, true, null, null);
  select id into v_question from core.poll_questions where poll_id = f.poll_id;
  select id into v_option from core.poll_options where poll_id = f.poll_id order by position limit 1;
  perform public.vote_poll(f.poll_id, array[v_option]);
  if not exists (select 1 from core.poll_answers
    where poll_id = f.poll_id and user_id = f.owner_id and option_id = v_option) then
    raise exception 'Legacy vote did not reach new results';
  end if;
  select id into v_option from core.poll_options where poll_id = f.poll_id order by position desc limit 1;
  perform public.submit_poll_answers(f.poll_id, jsonb_build_array(jsonb_build_object(
    'questionId', v_question, 'optionIds', jsonb_build_array(v_option))));
  if (select count(*) from core.poll_votes where poll_id = f.poll_id and user_id = f.owner_id) <> 1
    or not exists (select 1 from core.poll_votes where poll_id = f.poll_id and option_id = v_option) then
    raise exception 'New vote did not replace legacy results';
  end if;
  perform public.vote_poll(f.poll_id, '{}'::uuid[]);
  if exists (select 1 from core.poll_votes where poll_id = f.poll_id and user_id = f.owner_id)
    or exists (select 1 from core.poll_answers where poll_id = f.poll_id and user_id = f.owner_id) then
    raise exception 'Legacy vote withdrawal did not update both models';
  end if;
  perform public.vote_poll(f.poll_id, array[v_option]);
  v_result := public.create_poll_v2('september-release-contract', 'Text poll', '', null,
    false, 'after_close', null, false,
    '[{"text":"Why?","kind":"text","isRequired":true}]');
  f.second_poll_id := (v_result ->> 'id')::uuid;
  perform public.submit_poll_answers(f.second_poll_id,
    jsonb_build_array(jsonb_build_object(
      'questionId', v_result #>> '{questions,0,id}', 'text', 'Answer')));
  if not exists (select 1 from core.poll_participations
    where poll_id = f.second_poll_id and user_id = f.owner_id) then
    raise exception 'Text participation missing from gamification';
  end if;
  perform pg_temp.expect_release_error(format(
    'select public.submit_poll_answers(%L,%L::jsonb)', f.second_poll_id,
    jsonb_build_array(jsonb_build_object(
      'questionId', v_result #>> '{questions,0,id}', 'text', 'Changed'))::text), '22023');
  v_result := public.create_poll_v2('september-release-contract', 'Quiz', '', null,
    false, 'after_close', null, false,
    '[{"text":"Which?","kind":"quiz","isRequired":true,"options":["Yes","No"],"correctIndex":0}]');
  f.quiz_poll_id := (v_result ->> 'id')::uuid;
  if v_result #>> '{questions,0,kind}' <> 'quiz'
    or (v_result #>> '{questions,0,options,0,isCorrect}')::boolean is not true then
    raise exception 'Quiz contract lost correct option';
  end if;
  perform pg_temp.expect_release_error(
    'select public.create_poll_v2(''september-release-contract'',''Invalid quiz'','''',null,false,''always'',null,false,''[{"text":"Which?","kind":"quiz","options":["Yes","No"],"correctIndex":2}]''::jsonb)',
    '22023');
  update release_fixture set note_id = f.note_id, material_id = f.material_id,
    poll_id = f.poll_id, second_poll_id = f.second_poll_id, quiz_poll_id = f.quiz_poll_id;
end;
$$;

select set_config('request.jwt.claim.sub', outsider_id::text, true) from release_fixture;
do $$
declare f release_fixture; v_poll jsonb;
begin
  select * into f from release_fixture;
  perform pg_temp.expect_release_error(format('select public.get_group_post_comments(%L)', f.post_id), '42501');
  perform pg_temp.expect_release_error(format('select public.add_group_post_comment(%L,%L)', f.post_id, 'No'), '42501');
  perform pg_temp.expect_release_error(format('select public.save_group_note_document(%L,%L::jsonb,1)',
    f.note_id, '[{"insert":"No\n"}]'), '42501');
  perform pg_temp.expect_release_error(format('select public.delete_room_photo_v2(%L)', f.room_photo_id), '42501');
  if exists (select 1 from storage.objects where bucket_id = 'room-photos'
    and name = f.owner_id || '/test.jpg') then
    raise exception 'Outsider can enumerate owner room upload';
  end if;
  select value into v_poll from jsonb_array_elements(public.get_polls_v2('september-release-contract'))
  where value ->> 'id' = f.quiz_poll_id::text;
  if v_poll is null or jsonb_array_length(v_poll -> 'questions') <> 1
    or (v_poll ->> 'canSeeResults')::boolean is not false
    or (v_poll #>> '{questions,0,options,0,isCorrect}')::boolean is not false
    or (v_poll #>> '{questions,0,options,0,votes}')::integer <> 0 then
    raise exception 'Hidden quiz results leaked';
  end if;
  select value into v_poll from jsonb_array_elements(public.get_polls('september-release-contract'))
  where value ->> 'id' = f.quiz_poll_id::text;
  if v_poll is null or jsonb_array_length(v_poll -> 'options') <> 2
    or v_poll ->> 'pollType' <> 'quiz'
    or (v_poll #>> '{options,0,isCorrect}')::boolean is not false then
    raise exception 'Legacy quiz response leaked or lost quiz kind';
  end if;
  if not exists (select 1 from storage.objects where bucket_id = 'lesson-materials'
    and name = f.owner_id || '/bank/previews/test.jpg') then
    raise exception 'Organization peer cannot read public material preview';
  end if;
  if exists (select 1 from storage.objects where bucket_id = 'lesson-materials'
    and name = f.owner_id || '/bank/large') then
    raise exception 'Preview authorization exposed unpaid material';
  end if;
end;
$$;

select set_config('request.jwt.claim.sub', foreign_id::text, true) from release_fixture;
do $$
declare f release_fixture;
begin
  select * into f from release_fixture;
  if exists (select 1 from storage.objects where bucket_id = 'lesson-materials'
    and name = f.owner_id || '/bank/previews/test.jpg') then
    raise exception 'Foreign organization can read material preview';
  end if;
  perform pg_temp.expect_release_error(format(
    'select public.upsert_mentor_profile(%L,array[%L],%L,%L,%L,%L::text[],0)',
    'september-release-contract', 'Math', 'release_test', '', '', '{}'), '42501');
end;
$$;

select set_config('request.jwt.claim.sub', member_id::text, true) from release_fixture;
do $$
declare f release_fixture; v_result jsonb; v_option uuid; v_question uuid;
begin
  select * into f from release_fixture;
  v_result := public.add_group_post_comment(f.post_id, 'Allowed');
  if jsonb_array_length(public.get_group_post_comments(f.post_id)) <> 1 then
    raise exception 'Member comment is missing';
  end if;
  perform public.delete_group_post_comment((v_result ->> 'id')::uuid);
  v_result := public.save_group_note_document(f.note_id, '[{"insert":"Member\n"}]', 1);
  if (v_result ->> 'conflict')::boolean then raise exception 'Member save denied'; end if;
  perform pg_temp.expect_release_error(format('select public.rename_group_note(%L,%L)', f.note_id, 'No'), '42501');
  select id into v_option from core.poll_options where poll_id = f.poll_id order by position limit 1;
  perform public.vote_poll(f.poll_id, array[v_option]);
  if not exists (select 1 from core.poll_answers where poll_id = f.poll_id
    and user_id = f.member_id and option_id = v_option) then
    raise exception 'Non-author could not vote';
  end if;
  select id into v_question from core.poll_questions where poll_id = f.quiz_poll_id;
  select id into v_option from core.poll_options where poll_id = f.quiz_poll_id order by position limit 1;
  v_result := public.submit_poll_answers(f.quiz_poll_id, jsonb_build_array(jsonb_build_object(
    'questionId', v_question, 'optionIds', jsonb_build_array(v_option))));
  if (v_result ->> 'iParticipated')::boolean is not true
    or (v_result #>> '{questions,0,options,0,isCorrect}')::boolean is not false then
    raise exception 'Quiz vote ignored or after-close answers revealed early';
  end if;
end;
$$;

select set_config('request.jwt.claim.sub', owner_id::text, true) from release_fixture;
do $$
declare f release_fixture; v_path text; v_result jsonb;
begin
  select * into f from release_fixture;
  perform public.set_group_note_visibility(f.note_id, 'personal');
  v_result := public.close_poll(f.quiz_poll_id);
  if (v_result ->> 'isClosed')::boolean is not true then
    raise exception 'Quiz close failed';
  end if;
  v_path := public.delete_room_photo_v2(f.room_photo_id);
  if v_path is distinct from f.owner_id || '/test.jpg' then
    raise exception 'Room photo deletion returned wrong path';
  end if;
  if not exists (select 1 from storage.objects
    where bucket_id = 'room-photos' and name = v_path) then
    raise exception 'Owner cannot read orphan before Storage API deletion';
  end if;
  perform pg_temp.expect_release_error(format('select public.delete_room_photo_v2(%L)', f.room_photo_id), '42501');
end;
$$;

reset role;
do $$
declare f release_fixture;
begin
  select * into f from release_fixture;
  if not exists (select 1 from core.mentor_profiles
    where user_id = f.owner_id and telegram_handle = 'release_test') then
    raise exception 'Legacy mentor edit erased Telegram contact';
  end if;
  if not exists (select 1 from storage.objects
    where bucket_id = 'room-photos' and name = f.owner_id || '/test.jpg') then
    raise exception 'Room deletion removed Storage metadata without API';
  end if;
end;
$$;

set local role authenticated;
select set_config('request.jwt.claim.sub', member_id::text, true) from release_fixture;
do $$
declare f release_fixture; v_poll jsonb;
begin
  select * into f from release_fixture;
  perform pg_temp.expect_release_error(format('select public.save_group_note_document(%L,%L::jsonb,2)',
    f.note_id, '[{"insert":"No\n"}]'), '42501');
  select value into v_poll from jsonb_array_elements(public.get_polls_v2('september-release-contract'))
  where value ->> 'id' = f.quiz_poll_id::text;
  if v_poll is null or (v_poll ->> 'canSeeResults')::boolean is not true
    or (v_poll #>> '{questions,0,options,0,isCorrect}')::boolean is not true
    or (v_poll #>> '{questions,0,options,0,votes}')::integer <> 1 then
    raise exception 'Closed quiz results missing';
  end if;
  perform pg_temp.expect_release_error(format(
    'select public.submit_poll_answers(%L,%L::jsonb)', f.quiz_poll_id,
    jsonb_build_array(jsonb_build_object('questionId', v_poll #>> '{questions,0,id}',
      'optionIds', jsonb_build_array(v_poll #>> '{questions,0,options,0,id}')))::text), '22023');
end;
$$;

rollback;
