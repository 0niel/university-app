begin;

do $$
declare
  v_definition text;
begin
  if to_regprocedure(
    'public.increment_quest_progress(text,integer,date)'
  ) is not null or to_regprocedure(
    'app_api_v1.increment_quest_progress(text,integer,date)'
  ) is not null then
    raise exception 'Client-controlled quest progress RPC still exists';
  end if;

  if has_table_privilege('authenticated', 'core.user_quest_progress', 'INSERT')
    or has_table_privilege('authenticated', 'core.user_quest_progress', 'UPDATE')
    or has_table_privilege('authenticated', 'core.user_quest_progress', 'DELETE') then
    raise exception 'Quest progress is client-writable';
  end if;

  if has_table_privilege(
      'authenticated',
      'core.user_gamification_profiles',
      'INSERT'
    )
    or has_table_privilege(
      'authenticated',
      'core.user_gamification_profiles',
      'UPDATE'
    )
    or has_table_privilege(
      'authenticated',
      'core.user_gamification_profiles',
      'DELETE'
    ) then
    raise exception 'Gamification balance is client-writable';
  end if;

  if not (
    select prosecdef
    from pg_proc
    where oid = 'app_api_v1.create_public_material(text,text,text,text,integer,integer,boolean,text,text,text,bigint)'::regprocedure
  ) then
    raise exception 'Material publishing cannot apply its server reward';
  end if;

  v_definition := pg_get_functiondef(
    'core.require_lesson_material_upload(uuid,text,bigint)'::regprocedure
  );
  if position('storage.objects' in v_definition) = 0
    or position('auth.uid()' in v_definition) = 0
    or position('for update' in lower(v_definition)) = 0 then
    raise exception 'Material upload verification is incomplete';
  end if;

  v_definition := pg_get_functiondef(
    'app_api_v1.list_public_materials_v1(text,integer)'::regprocedure
  );
  if has_function_privilege(
      'anon',
      'app_api_v1.list_public_materials_v1(text,integer)',
      'EXECUTE'
    )
    or not has_function_privilege(
      'authenticated',
      'app_api_v1.list_public_materials_v1(text,integer)',
      'EXECUTE'
    )
    or not (
      select function_row.prosecdef
      from pg_proc function_row
      where function_row.oid =
        'app_api_v1.list_public_materials_v1(text,integer)'::regprocedure
    )
    or position('auth.uid()' in v_definition) = 0
    or position('core.user_academic_profiles' in v_definition) = 0
    or position('profile.organization_id = p_organization_id' in v_definition) = 0
    or position('storage.objects' in v_definition) = 0
    or position('requiresRepublish' in v_definition) = 0
    or position('''filePath''' in v_definition) > 0 then
    raise exception 'Material listing tenant or privacy checks are incomplete';
  end if;

  v_definition := pg_get_functiondef(
    'app_api_v1.access_public_material(uuid)'::regprocedure
  );
  if position('for update' in lower(v_definition)) = 0
    or position('core.material_entitlements' in v_definition) = 0
    or position('apply_organization_shuriken_delta' in v_definition) = 0
    or position('storage.objects' in v_definition) = 0
    or position('split_part(v_material.file_path' in v_definition) = 0 then
    raise exception 'Material purchase or anonymous access is not atomic';
  end if;

  select policy.qual
  into v_definition
  from pg_policies policy
  where policy.schemaname = 'storage'
    and policy.tablename = 'objects'
    and policy.policyname =
      'authorized users can read linked lesson material files';

  if v_definition is null
    or position('core.user_academic_profiles' in v_definition) = 0
    or position('material.organization_id' in v_definition) = 0
    or position('core.material_entitlements' in v_definition) = 0
    or position('split_part(material.file_path' in v_definition) = 0 then
    raise exception 'Material storage policy is not tenant-safe';
  end if;

  foreach v_definition in array array[
    pg_get_functiondef(
      'app_api_v1.create_lesson_material(text,text,date,integer,text,text,text,text,text,text,bigint,boolean,boolean)'::regprocedure
    ),
    pg_get_functiondef(
      'app_api_v1.create_public_material(text,text,text,text,integer,integer,boolean,text,text,text,bigint)'::regprocedure
    )
  ]
  loop
    if position('require_lesson_material_upload' in v_definition) = 0
      or position('apply_shuriken_delta' in v_definition) > 0 then
      raise exception 'Material RPC bypasses upload verification';
    end if;
  end loop;

  v_definition := pg_get_functiondef(
    'public.mini_app_notify_context(text,text,text,integer)'::regprocedure
  );
  if position('pg_advisory_xact_lock' in v_definition) = 0
    or position('reservation_id' in v_definition) = 0 then
    raise exception 'Mini-app notification quota is not reserved atomically';
  end if;

  if to_regprocedure('public.finalize_mini_app_push(uuid,uuid,uuid[])')
      is null
    or to_regprocedure('public.log_mini_app_push(uuid,uuid[])') is not null
    or has_function_privilege(
      'authenticated',
      'public.finalize_mini_app_push(uuid,uuid,uuid[])',
      'EXECUTE'
    ) then
    raise exception 'Mini-app notification finalizer has unsafe privileges';
  end if;

  v_definition := pg_get_functiondef(
    'app_api_v1.sync_gamification()'::regprocedure
  );
  if position('pg_advisory_xact_lock' in v_definition) = 0 then
    raise exception 'Gamification sync is not serialized';
  end if;

  v_definition := pg_get_functiondef(
    'internal.run_gamification_sweep()'::regprocedure
  );
  if position('pg_advisory_xact_lock' in v_definition) = 0 then
    raise exception 'Gamification sweep is not serialized';
  end if;
end;
$$;

rollback;
