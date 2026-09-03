create or replace function app_api_v1.ensure_academic_profile(
  p_organization_id text,
  p_group text default null
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_existing_organization text;
  v_group text := nullif(btrim(p_group), '');
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if nullif(btrim(p_organization_id), '') is null then
    raise exception 'Organization is required' using errcode = '22023';
  end if;
  if char_length(v_group) > 60 then
    raise exception 'Academic group is too long' using errcode = '22023';
  end if;
  select profile.organization_id into v_existing_organization
  from core.user_academic_profiles profile
  where profile.user_id = v_user_id
  for update;
  if v_existing_organization is not null
    and v_existing_organization <> p_organization_id then
    raise exception 'Organization access denied' using errcode = '42501';
  end if;
  if v_group is null then
    select nullif(btrim(preference.value->>'name'), '') into v_group
    from user_private.user_preferences preference
    where preference.user_id = v_user_id
      and preference.key = 'selected_schedule'
      and preference.value->>'type' = 'group'
      and char_length(preference.value->>'name') <= 60;
  end if;
  insert into core.user_academic_profiles (
    user_id, organization_id, academic_group
  ) values (v_user_id, p_organization_id, v_group)
  on conflict (user_id) do update
  set academic_group = excluded.academic_group
  where core.user_academic_profiles.organization_id = excluded.organization_id
    and nullif(btrim(core.user_academic_profiles.academic_group), '') is null
    and excluded.academic_group is not null;
  if not exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'Organization access denied' using errcode = '42501';
  end if;
end;
$$;

create or replace function public.ensure_academic_profile(
  p_organization_id text,
  p_group text default null
)
returns void
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.ensure_academic_profile(p_organization_id, p_group);
$$;

revoke all on function app_api_v1.ensure_academic_profile(text, text)
from public, anon;
revoke all on function public.ensure_academic_profile(text, text)
from public, anon;
grant execute on function app_api_v1.ensure_academic_profile(text, text)
to authenticated, service_role;
grant execute on function public.ensure_academic_profile(text, text)
to authenticated, service_role;
