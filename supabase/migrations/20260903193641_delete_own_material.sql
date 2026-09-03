create or replace function app_api_v1.delete_own_material(p_material_id uuid)
returns jsonb
language plpgsql security definer set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_material core.lesson_materials;
begin
  if v_uid is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  perform core.enforce_rate_limit('delete_material', 30, interval '1 hour');
  select * into v_material from core.lesson_materials
  where id = p_material_id and user_id = v_uid
  for update;
  if not found then
    raise exception 'Material not found' using errcode = '42501';
  end if;
  delete from core.lesson_materials where id = p_material_id;
  return jsonb_build_object(
    'filePath', v_material.file_path, 'previewPath', v_material.preview_path
  );
end;
$$;

create or replace function public.delete_own_material(p_material_id uuid)
returns jsonb
language sql security invoker set search_path = ''
as $$ select app_api_v1.delete_own_material(p_material_id); $$;

do $$
declare v_signature text;
begin
  foreach v_signature in array array[
    'app_api_v1.delete_own_material(uuid)',
    'public.delete_own_material(uuid)'
  ] loop
    execute format('revoke all on function %s from public, anon', v_signature);
    execute format('grant execute on function %s to authenticated, service_role', v_signature);
  end loop;
end;
$$;

notify pgrst, 'reload schema';
