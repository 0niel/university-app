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

create or replace function app_api_v1.get_my_study_group(p_organization_id text)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group_id uuid;
  v_is_owner boolean := false;
  v_membership_organization_id text;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if not exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;

  v_membership_organization_id := core.current_study_group_organization_id();
  if v_membership_organization_id is not null
    and v_membership_organization_id <> p_organization_id then
    raise exception 'study_group_organization_mismatch'
      using errcode = 'P0001';
  end if;
  select study_group.id, study_group.owner_id = v_user_id
  into v_group_id, v_is_owner
  from core.study_group_members membership
  join core.study_groups study_group on study_group.id = membership.group_id
  where membership.user_id = v_user_id
    and study_group.organization_id = p_organization_id;

  return jsonb_build_object(
    'hasGroup', v_group_id is not null,
    'isOwner', coalesce(v_is_owner, false),
    'group', (
      select jsonb_build_object(
        'id', study_group.id,
        'name', study_group.name,
        'emoji', study_group.emoji,
        'description', study_group.description,
        'joinCode', study_group.join_code,
        'isDiscoverable', study_group.is_discoverable,
        'memberCount', (
          select count(*)
          from core.study_group_members membership
          join core.user_academic_profiles profile
            on profile.user_id = membership.user_id
            and profile.organization_id = p_organization_id
          where membership.group_id = v_group_id
        ),
        'createdAt', study_group.created_at
      )
      from core.study_groups study_group
      where study_group.id = v_group_id
        and study_group.organization_id = p_organization_id
    ),
    'members', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'userId', membership.user_id,
          'fullName', coalesce(profile.full_name, 'Студент'),
          'handle', profile.handle,
          'role', membership.role,
          'isOwner', membership.role = 'owner',
          'isMe', membership.user_id = v_user_id,
          'isFriend', coalesce(friendship.status = 'accepted', false),
          'friendshipStatus', friendship.status
        ) order by (membership.role = 'owner') desc,
          coalesce(profile.full_name, 'Студент'), membership.user_id
      )
      from core.study_group_members membership
      join core.user_academic_profiles profile
        on profile.user_id = membership.user_id
        and profile.organization_id = p_organization_id
      left join core.friendships friendship
        on friendship.organization_id = p_organization_id
        and least(friendship.requester_id, friendship.addressee_id)
          = least(v_user_id, membership.user_id)
        and greatest(friendship.requester_id, friendship.addressee_id)
          = greatest(v_user_id, membership.user_id)
      where membership.group_id = v_group_id
    ), '[]'::jsonb),
    'incomingInvites', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'id', invite.id,
          'groupId', study_group.id,
          'groupName', study_group.name,
          'groupEmoji', study_group.emoji,
          'memberCount', (
            select count(*)
            from core.study_group_members membership
            join core.user_academic_profiles profile
              on profile.user_id = membership.user_id
              and profile.organization_id = p_organization_id
            where membership.group_id = study_group.id
          ),
          'invitedByName', coalesce(split_part(inviter.full_name, ' ', 1), '')
        ) order by invite.created_at desc, invite.id
      )
      from core.study_group_invites invite
      join core.study_groups study_group
        on study_group.id = invite.group_id
        and study_group.organization_id = p_organization_id
      join core.user_academic_profiles inviter
        on inviter.user_id = invite.created_by
        and inviter.organization_id = p_organization_id
      where invite.target_user_id = v_user_id
        and invite.kind = 'invite' and invite.status = 'pending'
    ), '[]'::jsonb),
    'pendingRequests', case when coalesce(v_is_owner, false) then coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'id', invite.id,
          'userId', invite.target_user_id,
          'fullName', coalesce(profile.full_name, 'Студент'),
          'handle', profile.handle,
          'createdAt', invite.created_at
        ) order by invite.created_at, invite.id
      )
      from core.study_group_invites invite
      join core.user_academic_profiles profile
        on profile.user_id = invite.target_user_id
        and profile.organization_id = p_organization_id
      where invite.group_id = v_group_id
        and invite.kind = 'request' and invite.status = 'pending'
    ), '[]'::jsonb) else '[]'::jsonb end
  );
end;
$$;

create or replace function public.get_my_study_group(p_organization_id text)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_membership_organization_id text;
begin
  if (select auth.uid()) is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  v_membership_organization_id := core.current_study_group_organization_id();
  if v_membership_organization_id is not null
    and v_membership_organization_id <> p_organization_id then
    raise exception 'study_group_organization_mismatch'
      using errcode = 'P0001';
  end if;
  return app_api_v1.get_my_study_group(p_organization_id);
end;
$$;

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
    select 1 from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;
  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended('create_study_group:' || v_user_id::text, 0)
  );
  v_membership_organization_id := core.current_study_group_organization_id();
  if v_membership_organization_id is not null then
    if v_membership_organization_id <> p_organization_id then
      raise exception 'study_group_organization_mismatch'
        using errcode = 'P0001';
    end if;
    return app_api_v1.get_my_study_group(p_organization_id);
  end if;

  perform core.enforce_rate_limit('create_study_group', 5, interval '1 day');
  insert into core.study_groups (
    organization_id, owner_id, name, emoji, description,
    join_code, is_discoverable
  ) values (
    p_organization_id,
    v_user_id,
    core.validate_text(p_name, 'Название', 100, true),
    left(coalesce(nullif(p_emoji, ''), '🎓'), 16),
    core.validate_text(p_description, 'Описание', 2000, false),
    core.gen_group_join_code(),
    coalesce(p_discoverable, true)
  ) returning id into v_group_id;
  insert into core.study_group_members (group_id, user_id, role)
  values (v_group_id, v_user_id, 'owner');
  update core.study_group_invites
  set status = 'revoked'
  where target_user_id = v_user_id and status = 'pending';
  return app_api_v1.get_my_study_group(p_organization_id);
end;
$$;

create or replace function app_api_v1.search_study_groups(
  p_organization_id text,
  p_query text
)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_query text := left(btrim(coalesce(p_query, '')), 100);
  v_pattern text;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if not exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;
  v_pattern := '%' || replace(replace(replace(
    v_query, '\', '\\'
  ), '%', '\%'), '_', '\_') || '%';
  return coalesce((
    select jsonb_agg(
      jsonb_build_object(
        'id', candidate.id,
        'name', candidate.name,
        'emoji', candidate.emoji,
        'description', candidate.description,
        'memberCount', (
          select count(*)
          from core.study_group_members membership
          join core.user_academic_profiles profile
            on profile.user_id = membership.user_id
            and profile.organization_id = p_organization_id
          where membership.group_id = candidate.id
        ),
        'ownerName', coalesce(candidate.owner_name, 'Студент'),
        'hasRequested', exists (
          select 1 from core.study_group_invites invite
          where invite.group_id = candidate.id
            and invite.target_user_id = v_user_id
            and invite.kind = 'request' and invite.status = 'pending'
        )
      ) order by candidate.name, candidate.id
    )
    from (
      select study_group.*, owner_profile.full_name as owner_name
      from core.study_groups study_group
      join core.user_academic_profiles owner_profile
        on owner_profile.user_id = study_group.owner_id
        and owner_profile.organization_id = p_organization_id
      where study_group.organization_id = p_organization_id
        and study_group.is_discoverable
        and (
          v_query = ''
          or study_group.name ilike v_pattern escape '\'
          or study_group.join_code = upper(v_query)
        )
      order by study_group.name, study_group.id
      limit 30
    ) candidate
  ), '[]'::jsonb);
end;
$$;

create or replace function app_api_v1.respond_group_invite(
  p_invite_id uuid,
  p_accept boolean
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group_id uuid;
  v_organization_id text;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  select invite.group_id, study_group.organization_id
  into v_group_id, v_organization_id
  from core.study_group_invites invite
  join core.study_groups study_group on study_group.id = invite.group_id
  where invite.id = p_invite_id
    and invite.target_user_id = v_user_id
    and invite.kind = 'invite' and invite.status = 'pending'
  for update of invite;
  if v_group_id is null then
    raise exception 'Pending invite not found';
  end if;
  if not exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = v_organization_id
  ) then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;
  perform core.enforce_rate_limit('respond_group_invite', 30, interval '1 hour');
  if coalesce(p_accept, false) then
    if core.current_study_group_id() is not null then
      raise exception 'Already a member of a group';
    end if;
    insert into core.study_group_members (group_id, user_id, role)
    values (v_group_id, v_user_id, 'member');
    update core.study_group_invites
    set status = 'accepted'
    where id = p_invite_id;
    update core.study_group_invites
    set status = 'revoked'
    where target_user_id = v_user_id and status = 'pending'
      and id <> p_invite_id;
  else
    update core.study_group_invites
    set status = 'declined'
    where id = p_invite_id;
  end if;
  return app_api_v1.get_my_study_group(v_organization_id);
end;
$$;

create or replace function app_api_v1.respond_join_request(
  p_invite_id uuid,
  p_accept boolean
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group_id uuid;
  v_target_user_id uuid;
  v_organization_id text;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  select invite.group_id, invite.target_user_id, study_group.organization_id
  into v_group_id, v_target_user_id, v_organization_id
  from core.study_group_invites invite
  join core.study_groups study_group on study_group.id = invite.group_id
  where invite.id = p_invite_id
    and study_group.owner_id = v_user_id
    and invite.kind = 'request' and invite.status = 'pending'
  for update of invite;
  if v_group_id is null then
    raise exception 'Pending join request not found';
  end if;
  if not exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = v_organization_id
  ) or (coalesce(p_accept, false) and not exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = v_target_user_id
      and profile.organization_id = v_organization_id
  )) then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;
  perform core.enforce_rate_limit('respond_join_request', 60, interval '1 hour');
  if coalesce(p_accept, false) then
    if exists (
      select 1 from core.study_group_members membership
      where membership.user_id = v_target_user_id
    ) then
      raise exception 'User is already a member of a group';
    end if;
    insert into core.study_group_members (group_id, user_id, role)
    values (v_group_id, v_target_user_id, 'member');
    update core.study_group_invites
    set status = 'accepted'
    where id = p_invite_id;
    update core.study_group_invites
    set status = 'revoked'
    where target_user_id = v_target_user_id and status = 'pending'
      and id <> p_invite_id;
  else
    update core.study_group_invites
    set status = 'declined'
    where id = p_invite_id;
  end if;
  return app_api_v1.get_my_study_group(v_organization_id);
end;
$$;

do $$
declare
  v_signature text;
  v_schema text;
begin
  foreach v_signature in array array[
    'get_my_study_group(text)',
    'create_study_group(text,text,text,text,boolean)',
    'update_study_group(text,text,text,text,boolean)',
    'delete_study_group(text)',
    'leave_study_group()',
    'invite_to_study_group(uuid)',
    'invite_to_study_group_by_handle(text)',
    'respond_group_invite(uuid,boolean)',
    'join_group_by_code(text,text)',
    'request_to_join_group(uuid)',
    'respond_join_request(uuid,boolean)',
    'remove_group_member(uuid)',
    'get_my_group_invites()',
    'search_study_groups(text,text)'
  ] loop
    foreach v_schema in array array['public', 'app_api_v1'] loop
      execute format(
        'revoke all on function %I.%s from public, anon',
        v_schema, v_signature
      );
      execute format(
        'grant execute on function %I.%s to authenticated, service_role',
        v_schema, v_signature
      );
    end loop;
  end loop;
end;
$$;

revoke execute on function app_api_v1.get_my_study_group(text)
from authenticated;

revoke select on core.study_groups from public, anon, authenticated;
revoke select (join_code) on core.study_groups from public, anon, authenticated;
grant select (
  id, organization_id, owner_id, name, emoji, description,
  is_discoverable, created_at, updated_at
) on core.study_groups to authenticated;
