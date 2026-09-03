begin;

create temporary table material_access_fixture (
  owner_id uuid, buyer_id uuid, poor_id uuid, foreign_id uuid, paid_id uuid, free_id uuid
);
insert into material_access_fixture (owner_id, buyer_id, poor_id, foreign_id)
values (extensions.gen_random_uuid(), extensions.gen_random_uuid(),
  extensions.gen_random_uuid(), extensions.gen_random_uuid());
grant select, update on material_access_fixture to authenticated;

create function pg_temp.expect_material_error(p_sql text, p_state text, p_message text default null)
returns void language plpgsql security invoker set search_path = '' as $$
declare v_state text; v_message text;
begin
  begin execute p_sql;
  exception when others then
    get stacked diagnostics v_state = returned_sqlstate, v_message = message_text;
    if v_state = p_state and (p_message is null or v_message = p_message) then return; end if;
    raise exception 'Unexpected error: % %', v_state, v_message;
  end;
  raise exception 'Expected error % for %', p_state, p_sql;
end;
$$;

do $$
declare f material_access_fixture;
begin
  select * into f from material_access_fixture;
  if has_table_privilege('authenticated', 'core.material_entitlements', 'INSERT')
    or has_table_privilege('authenticated', 'core.material_upload_rewards', 'INSERT')
    or has_table_privilege('authenticated', 'core.lesson_materials', 'INSERT')
    or has_table_privilege('authenticated', 'core.lesson_materials', 'UPDATE') then
    raise exception 'Authoritative material tables are client writable';
  end if;
  if exists (select 1 from storage.buckets where id = 'lesson-materials' and public) then
    raise exception 'Material bucket is public';
  end if;
  insert into core.organizations (id, name) values
    ('material-access-contract', 'Material Access Contract'),
    ('material-foreign-contract', 'Material Foreign Contract');
  insert into auth.users (id) values (f.owner_id), (f.buyer_id), (f.poor_id), (f.foreign_id);
  update auth.users set is_anonymous = true where id = f.poor_id;
  insert into core.user_academic_profiles (user_id, organization_id, academic_group)
  select uid, case when uid = f.foreign_id then 'material-foreign-contract'
    else 'material-access-contract' end, 'Test Group'
  from unnest(array[f.owner_id, f.buyer_id, f.poor_id, f.foreign_id]) uid;
  insert into core.user_gamification_profiles (user_id, organization_id, shurikens)
  select uid, case when uid = f.foreign_id then 'material-foreign-contract'
    else 'material-access-contract' end,
    case when uid = f.owner_id then 0 when uid = f.poor_id then 10 else 80 end
  from unnest(array[f.owner_id, f.buyer_id, f.poor_id, f.foreign_id]) uid;
  insert into storage.objects (bucket_id, name, owner_id, metadata)
  select 'lesson-materials', f.owner_id || '/' || path, f.owner_id::text,
    '{"size":3,"mimetype":"application/pdf"}'::jsonb
  from unnest(array['bank/paid','bank/free','bank/legacy','bank/current','lesson/one','lesson/private','bank/orphan']) path;
  insert into storage.objects (bucket_id, name, owner_id, metadata) values
    ('lesson-materials', f.owner_id || '/bank/wrong-owner', f.foreign_id::text,
      '{"size":3,"mimetype":"application/pdf"}'),
    ('lesson-materials', f.foreign_id || '/bank/foreign', f.foreign_id::text,
      '{"size":3,"mimetype":"application/pdf"}');
end;
$$;

set local role authenticated;
select set_config('request.jwt.claim.sub', owner_id::text, true) from material_access_fixture;

do $$
declare
  f material_access_fixture;
  v_path text;
  v_sql text;
  v_id uuid;
  v_delete_setting text := current_setting('storage.allow_delete_query', true);
begin
  select * into f from material_access_fixture;
  if core.lesson_material_file_is_linked(f.foreign_id || '/private/missing') is not true
    or core.lesson_material_file_is_linked(f.foreign_id || '/bank/foreign') is not true then
    raise exception 'Foreign material namespace existence leaked';
  end if;
  v_id := public.create_public_material_v2('material-access-contract', 'Paid notes', array['Math'],
    'exam', 40, 0, false, 'paid.pdf', f.owner_id || '/bank/paid', 'application/pdf', 3);
  update material_access_fixture set paid_id = v_id;
  v_id := public.create_public_material_v2('material-access-contract', 'Free notes', array['Math'],
    'note', 0, 0, false, 'free.pdf', f.owner_id || '/bank/free', 'application/pdf', 3);
  update material_access_fixture set free_id = v_id;
  select * into f from material_access_fixture;
  update storage.objects set metadata = metadata || '{"changed":true}'::jsonb
  where bucket_id = 'lesson-materials' and name = f.owner_id || '/bank/paid';
  if found then raise exception 'Owner replaced linked paid file'; end if;
  perform set_config('storage.allow_delete_query', 'true', true);
  delete from storage.objects where bucket_id = 'lesson-materials'
    and name = f.owner_id || '/bank/paid';
  if found then raise exception 'Owner deleted linked paid file'; end if;
  delete from storage.objects where bucket_id = 'lesson-materials'
    and name = f.owner_id || '/bank/orphan';
  if not found then raise exception 'Owner orphan cleanup denied'; end if;
  perform set_config('storage.allow_delete_query', coalesce(v_delete_setting, 'false'), true);
  if (select shurikens from core.user_gamification_profiles where user_id = f.owner_id) <> 60 then
    raise exception 'Upload reward mismatch';
  end if;
  perform public.access_public_material(f.paid_id);
  perform public.purchase_public_material(f.paid_id, 40);
  if (select shurikens from core.user_gamification_profiles where user_id = f.owner_id) <> 60 then
    raise exception 'Owner access charged balance';
  end if;
  perform pg_temp.expect_material_error(format(
    'select public.create_public_material_v2(%L,%L,array[%L],%L,0,0,false,%L,%L,%L,3)',
    'material-access-contract', 'Duplicate', 'Math', 'note', 'paid.pdf',
    f.owner_id || '/bank/paid', 'application/pdf'), '23505');
  foreach v_path in array array[f.owner_id || '/bank/missing', f.owner_id || '/bank/wrong-owner',
    f.foreign_id || '/bank/foreign'] loop
    perform pg_temp.expect_material_error(format(
      'select public.create_public_material_v2(%L,%L,array[%L],%L,0,0,false,%L,%L,%L,3)',
      'material-access-contract', 'Bad file', 'Math', 'note', 'paid.pdf', v_path, 'application/pdf'), '42501');
  end loop;
  perform pg_temp.expect_material_error(format(
    'select public.create_public_material_v2(%L,%L,array[%L],%L,0,0,false,%L,%L,%L,3)',
    'material-foreign-contract', 'Foreign tenant', 'Math', 'note', 'paid.pdf',
    f.owner_id || '/bank/paid', 'application/pdf'), '42501');
  foreach v_sql in array array[
    format('select public.create_public_material_v2(%L,%L,array[%L],%L,0,0,false,%L,%L,%L,3)',
      'material-access-contract', ' ', 'Math', 'note', 'paid.pdf', f.owner_id || '/bank/paid', 'application/pdf'),
    format('select public.create_public_material_v2(%L,%L,array[%L],%L,0,0,false,%L,%L,%L,3)',
      'material-access-contract', 'Blank subject', ' ', 'note', 'paid.pdf', f.owner_id || '/bank/paid', 'application/pdf'),
    format('select public.create_public_material_v2(%L,%L,array[%L],%L,0,0,false,%L,%L,%L,3)',
      'material-access-contract', 'Blank filename', 'Math', 'note', ' ', f.owner_id || '/bank/paid', 'application/pdf'),
    format('select public.create_public_material_v2(%L,%L,array[%L],%L,0,0,false,%L,%L,%L,3)',
      'material-access-contract', 'Bad type', 'Math', 'unsupported', 'paid.pdf', f.owner_id || '/bank/paid', 'application/pdf'),
    format('select public.create_public_material_v2(%L,%L,array[%L],%L,0,0,false,%L,%L,%L,2)',
      'material-access-contract', 'Wrong size', 'Math', 'note', 'paid.pdf', f.owner_id || '/bank/paid', 'application/pdf'),
    format('select public.create_public_material_v2(%L,%L,array[%L],%L,0,0,false,%L,%L,%L,3)',
      'material-access-contract', 'Wrong mime', 'Math', 'note', 'paid.pdf', f.owner_id || '/bank/paid', 'image/png')
  ] loop perform pg_temp.expect_material_error(v_sql, '22023'); end loop;
  perform public.create_public_material('material-access-contract', 'Legacy client', 'Math',
    'note', 0, 0, false, 'legacy.pdf', f.owner_id || '/bank/legacy', 'application/pdf', 3);
  perform public.create_lesson_material('material-access-contract', 'Math', current_date, 1, null,
    'note', 'Lesson', 'lesson.pdf', f.owner_id || '/lesson/one', 'application/pdf', 3, true, false);
  perform public.create_lesson_material('material-access-contract', 'Math', current_date, 2, null,
    'note', 'Private lesson', 'private.pdf', f.owner_id || '/lesson/private', 'application/pdf', 3, false, false);
  if not exists (select 1 from storage.objects where bucket_id = 'lesson-materials'
    and name = f.owner_id || '/lesson/private') then
    raise exception 'Private lesson owner download denied';
  end if;
  if (select shurikens from core.user_gamification_profiles where user_id = f.owner_id) <> 120
    or (select count(*) from core.shuriken_ledger where user_id = f.owner_id) <> 4 then
    raise exception 'Upload errors or legacy clients changed reward accounting';
  end if;
end;
$$;

select set_config('request.jwt.claim.sub', buyer_id::text, true) from material_access_fixture;
do $$
declare f material_access_fixture; v_access jsonb;
begin
  select * into f from material_access_fixture;
  v_access := public.access_public_material(f.paid_id);
  if (v_access ->> 'canDownload')::boolean or v_access ->> 'filePath' is not null
    or exists (select 1 from storage.objects where bucket_id = 'lesson-materials'
      and name = f.owner_id || '/bank/paid') then
    raise exception 'Unpurchased file exposed';
  end if;
  perform public.access_public_material(f.paid_id);
  perform public.purchase_public_material(f.free_id, 0);
  if (select shurikens from core.user_gamification_profiles where user_id = f.buyer_id) <> 80
    or not exists (select 1 from storage.objects where bucket_id = 'lesson-materials'
      and name = f.owner_id || '/bank/free') then
    raise exception 'Read/free download contract failed';
  end if;
  perform pg_temp.expect_material_error(format('select public.purchase_public_material(%L,39)', f.paid_id),
    '22023', 'MATERIAL_PRICE_CHANGED');
  perform pg_temp.expect_material_error(format('select public.increment_material_downloads(%L)', f.paid_id), '42501');
  perform public.purchase_public_material(f.paid_id, 40);
  perform public.purchase_public_material(f.paid_id, 40);
  perform public.purchase_public_material(f.paid_id, 39);
  if (select shurikens from core.user_gamification_profiles where user_id = f.buyer_id) <> 40
    or (select count(*) from core.shuriken_ledger where user_id = f.buyer_id) <> 1
    or (select count(*) from core.material_entitlements where user_id = f.buyer_id) <> 1
    or not exists (select 1 from storage.objects where bucket_id = 'lesson-materials'
      and name = f.owner_id || '/bank/paid') then
    raise exception 'Purchase idempotency or file entitlement failed';
  end if;
  perform public.increment_material_downloads(f.paid_id);
end;
$$;

select set_config('request.jwt.claim.sub', poor_id::text, true) from material_access_fixture;
do $$
declare f material_access_fixture;
begin
  select * into f from material_access_fixture;
  if not (public.access_public_material(f.free_id) ->> 'canDownload')::boolean then
    raise exception 'Authenticated guest with academic profile cannot read free material';
  end if;
  perform pg_temp.expect_material_error(format('select public.purchase_public_material(%L,40)', f.paid_id),
    '22023', 'MATERIAL_INSUFFICIENT_BALANCE');
  if exists (select 1 from core.material_entitlements)
    or (select shurikens from core.user_gamification_profiles where user_id = f.poor_id) <> 10 then
    raise exception 'Insufficient balance mutation or foreign entitlement visible';
  end if;
end;
$$;

select set_config('request.jwt.claim.sub', foreign_id::text, true) from material_access_fixture;
do $$
declare f material_access_fixture;
begin
  select * into f from material_access_fixture;
  perform pg_temp.expect_material_error(format('select public.purchase_public_material(%L,40)', f.paid_id), '42501');
  perform pg_temp.expect_material_error(format('select public.access_public_material(%L)', f.free_id), '42501');
  perform pg_temp.expect_material_error('select public.list_public_materials_v2(''material-access-contract'',50)', '42501');
  perform pg_temp.expect_material_error('select public.get_top_material_authors(''material-access-contract'')', '42501');
  perform pg_temp.expect_material_error('select public.search_material_subjects(''material-access-contract'','''',40)', '42501');
  if exists (select 1 from storage.objects where bucket_id = 'lesson-materials'
    and name in (f.owner_id || '/bank/free', f.owner_id || '/bank/paid', f.owner_id || '/lesson/private')) then
    raise exception 'Foreign organization reads file';
  end if;
end;
$$;

reset role;
delete from core.lesson_materials where id = (select free_id from material_access_fixture);
set local role authenticated;
select set_config('request.jwt.claim.sub', owner_id::text, true) from material_access_fixture;
do $$
declare f material_access_fixture;
begin
  select * into f from material_access_fixture;
  perform public.create_public_material_v2('material-access-contract', 'Republished', array['Math'],
    'note', 0, 0, false, 'free.pdf', f.owner_id || '/bank/free', 'application/pdf', 3);
  if (select shurikens from core.user_gamification_profiles where user_id = f.owner_id) <> 120 then
    raise exception 'Same object republish granted a second upload reward';
  end if;
  perform public.create_public_material_v3('material-access-contract', 'Current client', array['Math'],
    'note', 0, 0, false, 'current.pdf', f.owner_id || '/bank/current', 'application/pdf', 3);
  perform pg_temp.expect_material_error(format(
    'select public.create_public_material_v3(%L,%L,array[%L],%L,0,0,false,%L,%L,%L,3)',
    'material-access-contract', 'Missing upload', 'Math', 'note', 'missing.pdf',
    f.owner_id || '/bank/missing', 'application/pdf'), '42501');
  perform pg_temp.expect_material_error(format(
    'select public.create_public_material_v3(%L,%L,array[%L],%L,0,0,false,%L,%L,%L,3)',
    'material-foreign-contract', 'Foreign tenant', 'Math', 'note', 'current.pdf',
    f.owner_id || '/bank/current', 'application/pdf'), '42501');
  if (select shurikens from core.user_gamification_profiles where user_id = f.owner_id) <> 150
    or (select count(*) from core.shuriken_ledger where user_id = f.owner_id) <> 5 then
    raise exception 'Current material publishing reward or rejection accounting is invalid';
  end if;
end;
$$;

reset role;
select 'material access contract passed' as result;
rollback;
