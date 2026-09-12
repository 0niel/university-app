create or replace function public.mini_app_deploy(
  p_token_hash text, p_organization_id text, p_slug text, p_screens jsonb,
  p_submit boolean default true
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_user_id uuid;
  v_app core.mini_apps;
  v_screen jsonb;
  v_bytes bigint;
begin
  select user_id into v_user_id from core.mini_app_deploy_tokens
  where token_hash = p_token_hash;
  if v_user_id is null then
    return jsonb_build_object('ok', false, 'reason', 'invalid_token');
  end if;

  select * into v_app from core.mini_apps
  where organization_id = p_organization_id
    and slug = lower(trim(p_slug))
    and owner_id = v_user_id
  for update;
  if not found then
    return jsonb_build_object('ok', false, 'reason', 'app_not_found');
  end if;
  if v_app.status = 'suspended' then
    return jsonb_build_object('ok', false, 'reason', 'suspended');
  end if;
  if v_app.source_kind <> 'hosted' then
    return jsonb_build_object('ok', false, 'reason', 'not_hosted');
  end if;
  if jsonb_typeof(p_screens) is distinct from 'array' then
    return jsonb_build_object('ok', false, 'reason', 'bad_screens');
  end if;
  v_bytes := octet_length(p_screens::text);
  if jsonb_array_length(p_screens) not between 1 and 50
    or v_bytes > 1048576
    or exists (
      select 1 from jsonb_array_elements(p_screens) s
      where jsonb_typeof(s.value) is distinct from 'object'
    )
  then
    return jsonb_build_object('ok', false, 'reason', 'bad_screens');
  end if;

  perform core.enforce_content_write_limit(
    'mini_app_deploy', 10, 60, 200, v_bytes, 67108864, v_user_id
  );

  update core.mini_app_deploy_tokens
  set last_used_at = now() where token_hash = p_token_hash;

  delete from core.mini_app_screens where app_id = v_app.id;
  for v_screen in select value from jsonb_array_elements(p_screens)
  loop
    insert into core.mini_app_screens (app_id, path, title, json)
    values (
      v_app.id,
      coalesce(v_screen ->> 'path', '/'),
      v_screen ->> 'title',
      coalesce(v_screen -> 'json', '{}'::jsonb)
    );
  end loop;

  update core.mini_apps
  set version = version + 1,
      status = case when p_submit then 'pending_review' else 'draft' end
  where id = v_app.id;

  perform core.snapshot_mini_app_screens(v_app.id, v_app.version + 1);

  return jsonb_build_object(
    'ok', true,
    'version', v_app.version + 1,
    'status', case when p_submit then 'pending_review' else 'draft' end,
    'validation', app_api_v1.validate_mini_app_screens(p_screens)
  );
end;
$function$;

revoke all on function public.mini_app_deploy(text, text, text, jsonb, boolean)
  from public, anon, authenticated;
grant execute on function public.mini_app_deploy(text, text, text, jsonb, boolean)
  to service_role;
