begin;

do $$
declare
  v_user_id uuid := extensions.gen_random_uuid();
  v_material_id uuid;
  v_material core.lesson_materials%rowtype;
  v_listing jsonb;
  v_subjects jsonb;
  v_rpc text;
  v_file_path text;
begin
  foreach v_rpc in array array[
    'public.search_material_subjects(text,text,integer)',
    'public.create_public_material_v2(text,text,text[],text,integer,integer,boolean,text,text,text,bigint)',
    'public.list_public_materials_v2(text,integer)'
  ] loop
    if has_function_privilege('anon', v_rpc, 'EXECUTE') then
      raise exception 'Anonymous execution granted for %', v_rpc;
    end if;
    if not has_function_privilege('authenticated', v_rpc, 'EXECUTE') then
      raise exception 'Authenticated execution missing for %', v_rpc;
    end if;
  end loop;

  insert into core.organizations (id, name)
  values ('material-subjects-contract', 'Material Subjects Contract');
  insert into auth.users (id) values (v_user_id);
  insert into core.user_academic_profiles (
    user_id, organization_id, academic_group
  ) values (v_user_id, 'material-subjects-contract', 'Test Group');
  v_file_path := v_user_id::text || '/bank/material-subjects-contract';
  insert into core.user_gamification_profiles (user_id, organization_id)
  values (v_user_id, 'material-subjects-contract');
  insert into storage.objects (bucket_id, name, owner_id, metadata)
  values (
    'lesson-materials', v_file_path,
    v_user_id::text, '{"size":3,"mimetype":"application/pdf"}'::jsonb
  );
  perform set_config('request.jwt.claim.sub', v_user_id::text, true);
  perform set_config('request.jwt.claim.role', 'authenticated', true);

  v_material_id := public.create_public_material_v2(
    'material-subjects-contract', 'Exam tickets',
    array['Дискретная математика', 'Программирование', 'Дискретная математика'],
    'exam', 0, 0, true, 'exam.pdf', v_file_path,
    'application/pdf', 3
  );
  select * into v_material from core.lesson_materials where id = v_material_id;
  if v_material.id is distinct from v_material_id
    or v_material.lesson_bells_number is distinct from 0
    or v_material.material_type is distinct from 'exam'
    or v_material.subject_name is distinct from 'Дискретная математика'
    or v_material.metadata -> 'subjectNames' is distinct from
      '["Дискретная математика","Программирование"]'::jsonb then
    raise exception 'Material subject assignment did not persist';
  end if;

  v_listing := public.list_public_materials_v2('material-subjects-contract', 50);
  if jsonb_array_length(v_listing) is distinct from 1
    or v_listing -> 0 -> 'subjectNames' is distinct from
      '["Дискретная математика","Программирование"]'::jsonb
    or (v_listing -> 0 ->> 'hasFile')::boolean is not true then
    raise exception 'Material listing did not preserve uploaded subject data';
  end if;

  v_subjects := public.search_material_subjects(
    'material-subjects-contract', 'дискретнаяматематика', 40
  );
  if v_subjects is distinct from '["Дискретная математика"]'::jsonb then
    raise exception 'Subject search is not normalized';
  end if;

  begin
    perform public.create_public_material_v2(
      'material-subjects-contract', 'Missing subject', '{}'::text[],
      'note', 0, 0, false, 'exam.pdf', v_file_path, 'application/pdf', 3
    );
    raise exception 'Empty subjects were accepted';
  exception when sqlstate '22023' then null;
  end;

  begin
    perform public.search_material_subjects('another-organization', '', 40);
    raise exception 'Cross-organization subject access succeeded';
  exception when sqlstate '42501' then null;
  end;
end;
$$;

rollback;
