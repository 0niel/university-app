begin;

do $$
declare
  v_signature text;
  v_policy record;
  v_relation record;
  v_table text;
begin
  if not exists (
    select 1 from pg_attribute
    where attrelid = 'core.study_group_invites'::regclass
      and attname = 'responded_at'
      and atttypid = 'timestamptz'::regtype
      and not attisdropped
  ) then
    raise exception 'Study group invite response timestamp is missing';
  end if;

  for v_relation in
    select relation.oid, relation.relkind, relation.relrowsecurity,
      relation.reloptions, namespace.nspname, relation.relname
    from pg_class relation
    join pg_namespace namespace on namespace.oid = relation.relnamespace
    where namespace.nspname in ('core', 'public', 'app_api_v1', 'ingest_v1', 'user_private')
      and relation.relkind in ('r', 'p', 'v')
      and (
        has_table_privilege('anon', relation.oid, 'SELECT,INSERT,UPDATE,DELETE')
        or has_table_privilege('authenticated', relation.oid, 'SELECT,INSERT,UPDATE,DELETE')
        or has_any_column_privilege('anon', relation.oid, 'SELECT,INSERT,UPDATE')
        or has_any_column_privilege('authenticated', relation.oid, 'SELECT,INSERT,UPDATE')
      )
  loop
    if v_relation.relkind in ('r', 'p') and not v_relation.relrowsecurity then
      raise exception 'Client-accessible table has no RLS: %.%',
        v_relation.nspname, v_relation.relname;
    end if;
    if v_relation.relkind = 'v'
      and not coalesce(v_relation.reloptions @> array['security_invoker=true'], false) then
      raise exception 'Client-accessible view bypasses RLS: %.%',
        v_relation.nspname, v_relation.relname;
    end if;
  end loop;
  if exists (
    select 1 from pg_proc procedure
    join pg_namespace namespace on namespace.oid = procedure.pronamespace
    where namespace.nspname in ('core', 'public', 'app_api_v1', 'ingest_v1')
      and procedure.prosecdef
      and not coalesce(procedure.proconfig @> array['search_path=""'], false)
      and not coalesce(procedure.proconfig @> array['search_path=pg_catalog'], false)
  ) then
    raise exception 'Privileged application function has an unsafe search path';
  end if;

  if exists (
    select 1 from pg_policies
    where schemaname = 'storage' and tablename = 'objects'
      and policyname in (
        'lost_found_images_insert', 'lost_found_images_delete', 'public read note media'
      )
  ) then
    raise exception 'Legacy storage policies bypass content authorization';
  end if;
  if not exists (
    select 1 from storage.buckets where id = 'note-media' and public
  ) then
    raise exception 'Existing note image URLs lost public download compatibility';
  end if;
  if has_schema_privilege('anon', 'ingest_v1', 'USAGE')
    or has_schema_privilege('authenticated', 'ingest_v1', 'USAGE') then
    raise exception 'Ingest schema is client-accessible';
  end if;
  for v_signature in
    select procedure.oid::regprocedure::text
    from pg_proc procedure
    join pg_namespace namespace on namespace.oid = procedure.pronamespace
    where namespace.nspname = 'ingest_v1'
  loop
    if has_function_privilege('anon', v_signature, 'EXECUTE')
      or has_function_privilege('authenticated', v_signature, 'EXECUTE')
      or not has_function_privilege('service_role', v_signature, 'EXECUTE') then
      raise exception 'Ingest function privileges are unsafe: %', v_signature;
    end if;
  end loop;
  foreach v_table in array array[
    'study_groups', 'study_group_members', 'study_group_invites'
  ] loop
    if not exists (
      select 1 from pg_trigger
      where tgrelid = to_regclass('core.' || v_table)
        and tgname like 'validate_study_group%'
        and tgenabled <> 'D'
    ) then
      raise exception 'Study group scope trigger missing: %', v_table;
    end if;
  end loop;
  for v_policy in
    select * from pg_policies
    where schemaname = 'storage' and tablename = 'objects'
      and policyname in (
        'app admins read content objects', 'app admins delete content objects'
      )
  loop
    if position('can_admin_content_object' in v_policy.qual) = 0
      or position('is_any_app_admin' in v_policy.qual) > 0 then
      raise exception 'Storage administrator privilege is not scoped';
    end if;
  end loop;
  foreach v_signature in array array[
    'app_api_v1.admin_get_user(text,uuid)',
    'app_api_v1.admin_ban_user(text,uuid,text,timestamptz)',
    'app_api_v1.admin_unban_user(text,uuid)'
  ] loop
    if to_regprocedure(v_signature) is not null and position(
      'core.require_admin_target_organization(p_organization_id, p_user_id)'
      in pg_get_functiondef(to_regprocedure(v_signature))
    ) = 0 then
      raise exception 'Admin user target is not scoped: %', v_signature;
    end if;
  end loop;
end;
$$;

create temporary table rls_boundary_fixture (
  organization_id text,
  foreign_organization_id text,
  owner_id uuid,
  member_id uuid,
  foreign_id uuid,
  admin_id uuid,
  group_id uuid,
  foreign_group_id uuid,
  join_code text
);

insert into rls_boundary_fixture values (
  'boundary-' || extensions.gen_random_uuid()::text,
  'boundary-foreign-' || extensions.gen_random_uuid()::text,
  extensions.gen_random_uuid(), extensions.gen_random_uuid(),
  extensions.gen_random_uuid(), extensions.gen_random_uuid(),
  extensions.gen_random_uuid(), extensions.gen_random_uuid(),
  upper(left(replace(extensions.gen_random_uuid()::text, '-', ''), 8))
);
grant select on rls_boundary_fixture to authenticated, anon;

create function pg_temp.expect_boundary_error(p_sql text)
returns void language plpgsql security invoker set search_path = '' as $$
begin
  begin
    execute p_sql;
  exception when insufficient_privilege then
    return;
  end;
  raise exception 'Expected authorization rejection: %', p_sql;
end;
$$;

do $$
declare
  f rls_boundary_fixture;
begin
  select * into f from rls_boundary_fixture;
  insert into core.organizations (id, name) values
    (f.organization_id, 'Boundary'), (f.foreign_organization_id, 'Foreign boundary');
  insert into auth.users (id, is_anonymous) values
    (f.owner_id, false), (f.member_id, false), (f.foreign_id, false), (f.admin_id, false);
  insert into core.user_academic_profiles (user_id, organization_id, full_name) values
    (f.owner_id, f.organization_id, 'Boundary owner'),
    (f.member_id, f.organization_id, 'Boundary member'),
    (f.admin_id, f.organization_id, 'Boundary admin'),
    (f.foreign_id, f.foreign_organization_id, 'Foreign owner');
  insert into core.study_groups (id, organization_id, owner_id, name, join_code) values
    (f.group_id, f.organization_id, f.owner_id, 'Boundary group', f.join_code),
    (f.foreign_group_id, f.foreign_organization_id, f.foreign_id,
      'Foreign group', upper(left(replace(extensions.gen_random_uuid()::text, '-', ''), 8)));
  insert into core.study_group_members (group_id, user_id, role) values
    (f.group_id, f.owner_id, 'owner'), (f.foreign_group_id, f.foreign_id, 'owner');
  insert into core.study_group_invites (group_id, target_user_id, created_by, kind)
  values (f.group_id, f.member_id, f.owner_id, 'invite');
  insert into storage.objects (bucket_id, name, owner_id) values
    ('note-media', f.owner_id::text || '/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.jpg', f.owner_id::text),
    ('note-media', f.foreign_id::text || '/bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb.jpg', f.foreign_id::text);

  perform pg_temp.expect_boundary_error(format(
    'insert into core.study_group_members (group_id,user_id,role) values (%L,%L,''member'')',
    f.foreign_group_id, f.member_id
  ));
  perform pg_temp.expect_boundary_error(format(
    'insert into core.study_group_invites (group_id,target_user_id,created_by,kind) values (%L,%L,%L,''invite'')',
    f.foreign_group_id, f.member_id, f.foreign_id
  ));

  if to_regclass('core.app_admins') is not null then
    insert into core.app_admins (organization_id, user_id, role)
    values (f.organization_id, f.admin_id, 'admin');
  end if;
end;
$$;

set local role authenticated;
select set_config('request.jwt.claim.sub', member_id::text, true),
  set_config('request.jwt.claims', jsonb_build_object(
    'sub', member_id, 'role', 'authenticated', 'is_anonymous', false
  )::text, true)
from rls_boundary_fixture;

do $$
declare
  f rls_boundary_fixture;
  v_group jsonb;
begin
  select * into f from rls_boundary_fixture;
  perform pg_temp.expect_boundary_error(format(
    'select public.join_group_by_code(%L,%L)', f.foreign_organization_id, f.join_code
  ));
  perform pg_temp.expect_boundary_error(format(
    'select public.request_to_join_group(%L)', f.foreign_group_id
  ));
  if core.study_group_in_current_organization(f.foreign_group_id)
    or not core.study_group_in_current_organization(f.group_id) then
    raise exception 'Study group scope helper crossed organizations';
  end if;
  v_group := public.join_group_by_code(f.organization_id, f.join_code);
  if v_group is null or core.current_study_group_id() is distinct from f.group_id then
    raise exception 'Same-organization group join failed';
  end if;
  if exists (
    select 1 from storage.objects
    where bucket_id = 'note-media'
      and split_part(name, '/', 1) in (f.owner_id::text, f.foreign_id::text)
  ) then
    raise exception 'Note media listing exposed another owner';
  end if;
end;
$$;

select set_config('request.jwt.claim.sub', owner_id::text, true),
  set_config('request.jwt.claims', jsonb_build_object(
    'sub', owner_id, 'role', 'authenticated', 'is_anonymous', false
  )::text, true)
from rls_boundary_fixture;

do $$
declare f rls_boundary_fixture;
begin
  select * into f from rls_boundary_fixture;
  if not exists (
    select 1 from storage.objects where bucket_id = 'note-media'
      and name = f.owner_id::text || '/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.jpg'
  ) then
    raise exception 'Owner cannot list an uploaded note image';
  end if;
  perform public.transfer_study_group_ownership(f.member_id);
end;
$$;

select set_config('request.jwt.claim.sub', admin_id::text, true),
  set_config('request.jwt.claims', jsonb_build_object(
    'sub', admin_id, 'role', 'authenticated', 'is_anonymous', false
  )::text, true)
from rls_boundary_fixture;

do $$
declare f rls_boundary_fixture;
begin
  select * into f from rls_boundary_fixture;
  if to_regprocedure('public.admin_get_user(text,uuid)') is not null then
    perform public.admin_get_user(f.organization_id, f.owner_id);
    perform pg_temp.expect_boundary_error(format(
      'select public.admin_get_user(%L,%L)', f.organization_id, f.foreign_id
    ));
    perform pg_temp.expect_boundary_error(format(
      'select public.admin_ban_user(%L,%L)', f.organization_id, f.foreign_id
    ));
    perform pg_temp.expect_boundary_error(format(
      'select public.admin_unban_user(%L,%L)', f.organization_id, f.foreign_id
    ));
    if exists (
      select 1 from storage.objects where bucket_id = 'note-media'
        and name = f.foreign_id::text || '/bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb.jpg'
    ) then
      raise exception 'Organization admin listed another organization image';
    end if;
    if not exists (
      select 1 from storage.objects where bucket_id = 'note-media'
        and name = f.owner_id::text || '/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.jpg'
    ) then
      raise exception 'Organization admin lost same-organization image access';
    end if;
  end if;
end;
$$;

set local role anon;
select set_config('request.jwt.claim.sub', '', true),
  set_config('request.jwt.claims', '{}', true);

do $$
declare f rls_boundary_fixture;
begin
  select * into f from rls_boundary_fixture;
  if exists (
    select 1 from storage.objects where bucket_id = 'note-media'
      and split_part(name, '/', 1) in (f.owner_id::text, f.foreign_id::text)
  ) then
    raise exception 'Anonymous role enumerated note images';
  end if;
end;
$$;

reset role;

do $$
declare f rls_boundary_fixture;
begin
  select * into f from rls_boundary_fixture;
  if not exists (
    select 1 from core.study_group_invites
    where group_id = f.group_id and target_user_id = f.member_id
      and status = 'revoked' and responded_at is not null
  ) then
    raise exception 'Joining a group did not revoke the pending invitation';
  end if;
end;
$$;

rollback;
