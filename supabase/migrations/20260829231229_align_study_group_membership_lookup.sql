create or replace function core.current_study_group_organization_id()
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select study_group.organization_id
  from core.study_group_members membership
  join core.study_groups study_group on study_group.id = membership.group_id
  where membership.user_id = (select auth.uid())
  limit 1;
$$;

revoke all on function core.current_study_group_organization_id()
from public, anon, authenticated, service_role;

create or replace function public.get_my_study_group(p_organization_id text)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_membership_organization_id text :=
    core.current_study_group_organization_id();
begin
  if (select auth.uid()) is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;

  if v_membership_organization_id is not null
    and v_membership_organization_id <> p_organization_id then
    raise exception 'study_group_organization_mismatch'
      using
        errcode = 'P0001',
        detail = 'Existing membership belongs to another organization';
  end if;

  return app_api_v1.get_my_study_group(p_organization_id);
end;
$$;

revoke all on function public.get_my_study_group(text) from public, anon;
grant execute on function public.get_my_study_group(text)
to authenticated, service_role;

revoke execute on function app_api_v1.get_my_study_group(text)
from authenticated;

create or replace function app_api_v1.create_study_group(
  p_organization_id text,
  p_name text,
  p_emoji text default '🎓'::text,
  p_description text default ''::text,
  p_discoverable boolean default true
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group_id uuid;
  v_membership_organization_id text;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;

  if not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;

  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(
      'create_study_group:' || v_user_id::text,
      0
    )
  );

  v_membership_organization_id :=
    core.current_study_group_organization_id();
  if v_membership_organization_id is not null then
    if v_membership_organization_id <> p_organization_id then
      raise exception 'study_group_organization_mismatch'
        using
          errcode = 'P0001',
          detail = 'Existing membership belongs to another organization';
    end if;

    return app_api_v1.get_my_study_group(p_organization_id);
  end if;

  perform core.enforce_rate_limit(
    'create_study_group',
    5,
    interval '1 day'
  );

  insert into core.study_groups (
    organization_id,
    owner_id,
    name,
    emoji,
    description,
    join_code,
    is_discoverable
  )
  values (
    p_organization_id,
    v_user_id,
    core.validate_text(p_name, 'Название', 100, true),
    left(coalesce(nullif(p_emoji, ''), '🎓'), 16),
    core.validate_text(p_description, 'Описание', 2000, false),
    core.gen_group_join_code(),
    coalesce(p_discoverable, true)
  )
  returning id into v_group_id;

  insert into core.study_group_members (group_id, user_id, role)
  values (v_group_id, v_user_id, 'owner');

  update core.study_group_invites
  set status = 'revoked', responded_at = now()
  where target_user_id = v_user_id
    and status = 'pending';

  return app_api_v1.get_my_study_group(p_organization_id);
end;
$$;
