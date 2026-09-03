begin;

do $$
declare
  v_definition text;
begin
  if to_regprocedure(
    'app_api_v1.increment_quest_progress(text,integer,date)'
  ) is not null then
    v_definition := pg_get_functiondef(
      'app_api_v1.increment_quest_progress(text,integer,date)'::regprocedure
    );
    if position('core.refresh_quest_progress(v_uid)' in v_definition) = 0
      or position('pg_advisory_xact_lock' in v_definition) = 0
      or position('progress+p_amount' in replace(v_definition, ' ', '')) > 0
      or position('then p_date' in v_definition) > 0 then
      raise exception 'Quest compatibility RPC trusts client progress';
    end if;
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
    where oid = 'app_api_v1.create_public_material_v3(text,text,text[],text,integer,integer,boolean,text,text,text,bigint,text,integer,integer,integer,uuid)'::regprocedure
  ) then
    raise exception 'Material publishing cannot apply its server reward';
  end if;

  v_definition := pg_get_functiondef(
    'app_api_v1.create_public_material_v2(text,text,text[],text,integer,integer,boolean,text,text,text,bigint)'::regprocedure
  );
  if position('app_api_v1.create_public_material_v3(' in v_definition) = 0
    or (
      select prosecdef from pg_proc
      where oid = 'app_api_v1.create_public_material_v2(text,text,text[],text,integer,integer,boolean,text,text,text,bigint)'::regprocedure
    ) then
    raise exception 'Legacy material publishing does not delegate safely';
  end if;

  v_definition := pg_get_functiondef(
    'core.require_material_upload(text,text,bigint,text)'::regprocedure
  );
  if position('storage.objects' in v_definition) = 0
    or position('auth.uid()' in v_definition) = 0
    or position('for update' in lower(v_definition)) = 0 then
    raise exception 'Material upload verification is incomplete';
  end if;

  v_definition := pg_get_functiondef(
    'app_api_v1.list_public_materials_v2(text,integer)'::regprocedure
  );
  if has_function_privilege(
      'anon',
      'app_api_v1.list_public_materials_v2(text,integer)',
      'EXECUTE'
    )
    or not has_function_privilege(
      'authenticated',
      'app_api_v1.list_public_materials_v2(text,integer)',
      'EXECUTE'
    )
    or not (
      select function_row.prosecdef
      from pg_proc function_row
      where function_row.oid =
        'app_api_v1.list_public_materials_v2(text,integer)'::regprocedure
    )
    or position('auth.uid()' in v_definition) = 0
    or position('core.user_academic_profiles' in v_definition) = 0
    or position('profile.organization_id = p_organization_id' in v_definition) = 0
    or position('core.material_file_is_valid' in v_definition) = 0
    or position('requiresRepublish' in v_definition) = 0
    or position('''filePath''' in v_definition) > 0 then
    raise exception 'Material listing tenant or privacy checks are incomplete';
  end if;

  v_definition := pg_get_functiondef(
    'app_api_v1.access_public_material(uuid)'::regprocedure
  );
  if position('core.material_entitlements' in v_definition) = 0
    or position('apply_shuriken_delta' in v_definition) > 0
    or position('core.material_file_is_valid' in v_definition) = 0 then
    raise exception 'Material access is not read-only and protected';
  end if;
  v_definition := pg_get_functiondef(
    'app_api_v1.purchase_public_material(uuid,integer)'::regprocedure
  );
  if position('for update of material' in lower(v_definition)) = 0
    or position('for update;' in lower(v_definition)) = 0
    or position('core.material_entitlements' in v_definition) = 0
    or position('core.apply_shuriken_delta' in v_definition) = 0
    or position('p_expected_price is distinct from v_price' in v_definition) = 0 then
    raise exception 'Material purchase is not atomic';
  end if;

  select policy.qual
  into v_definition
  from pg_policies policy
  where policy.schemaname = 'storage'
    and policy.tablename = 'objects'
    and policy.policyname =
      'users read accessible lesson material files';

  if v_definition is null
    or position('can_read_lesson_material_file' in v_definition) = 0 then
    raise exception 'Material storage policy does not enforce access';
  end if;
  v_definition := pg_get_functiondef('core.can_read_lesson_material_file(text)'::regprocedure);
  if position('core.user_academic_profiles' in v_definition) = 0
    or position('material.organization_id' in v_definition) = 0
    or position('core.material_entitlements' in v_definition) = 0
    or position('core.material_file_is_valid' in v_definition) = 0 then
    raise exception 'Material storage policy is not tenant-safe';
  end if;

  foreach v_definition in array array[
    pg_get_functiondef(
      'app_api_v1.create_lesson_material(text,text,date,integer,text,text,text,text,text,text,bigint,boolean,boolean)'::regprocedure
    ),
    pg_get_functiondef(
      'app_api_v1.create_public_material_v3(text,text,text[],text,integer,integer,boolean,text,text,text,bigint,text,integer,integer,integer,uuid)'::regprocedure
    ),
    pg_get_functiondef(
      'app_api_v1.create_lesson_material_v2(text,text,date,integer,text,text,text,text,text,text,bigint,boolean,boolean,text,integer,integer,integer,uuid)'::regprocedure
    )
  ]
  loop
    if position('core.require_material_upload' in v_definition) = 0
      or position('core.reward_material_upload' in v_definition) = 0 then
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
    or has_function_privilege(
      'authenticated',
      'public.finalize_mini_app_push(uuid,uuid,uuid[])',
      'EXECUTE'
    )
    or has_function_privilege(
      'anon',
      'public.finalize_mini_app_push(uuid,uuid,uuid[])',
      'EXECUTE'
    ) then
    raise exception 'Mini-app notification finalizer has unsafe privileges';
  end if;

  v_definition := pg_get_functiondef(
    'public.log_mini_app_push(uuid,uuid[])'::regprocedure
  );
  if has_function_privilege('anon', 'public.log_mini_app_push(uuid,uuid[])', 'EXECUTE')
    or has_function_privilege('authenticated', 'public.log_mini_app_push(uuid,uuid[])', 'EXECUTE')
    or not has_function_privilege('service_role', 'public.log_mini_app_push(uuid,uuid[])', 'EXECUTE')
    or position('pg_advisory_xact_lock' in v_definition) = 0
    or position('sent_at' in v_definition) = 0
    or position('now()' in v_definition) = 0 then
    raise exception 'Legacy mini-app notification bridge is unsafe';
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
