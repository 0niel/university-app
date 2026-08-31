create table core.study_groups (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id) on delete cascade,
  owner_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  emoji text not null default '🎓',
  description text not null default '',
  join_code text not null,
  is_discoverable boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint study_groups_owner_unique unique (owner_id),
  constraint study_groups_join_code_unique unique (organization_id, join_code),
  constraint study_groups_name_valid check (
    char_length(btrim(name)) between 1 and 100
  ),
  constraint study_groups_emoji_valid check (
    char_length(emoji) between 1 and 16
  ),
  constraint study_groups_description_valid check (
    char_length(description) <= 2000
  ),
  constraint study_groups_join_code_valid check (
    join_code ~ '^[A-Z0-9]{8}$'
  )
);

create index study_groups_discovery_idx
on core.study_groups (organization_id, is_discoverable, created_at desc);

create index study_groups_name_search_idx
on core.study_groups using gin (name extensions.gin_trgm_ops);

create trigger set_study_groups_updated_at
before update on core.study_groups
for each row execute function core.set_updated_at();

create table core.study_group_members (
  group_id uuid not null references core.study_groups(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null default 'member',
  joined_at timestamptz not null default now(),
  primary key (group_id, user_id),
  constraint study_group_members_user_unique unique (user_id),
  constraint study_group_members_role_valid check (role in ('owner', 'member'))
);

create index study_group_members_group_joined_idx
on core.study_group_members (group_id, joined_at);

create table core.study_group_invites (
  id uuid primary key default extensions.gen_random_uuid(),
  group_id uuid not null references core.study_groups(id) on delete cascade,
  target_user_id uuid not null references auth.users(id) on delete cascade,
  created_by uuid not null references auth.users(id) on delete cascade,
  kind text not null default 'invite',
  status text not null default 'pending',
  created_at timestamptz not null default now(),
  responded_at timestamptz,
  constraint study_group_invites_kind_valid check (kind in ('invite', 'request')),
  constraint study_group_invites_status_valid check (
    status in ('pending', 'accepted', 'declined', 'revoked')
  ),
  constraint study_group_invites_no_self_invite check (
    kind = 'request' or target_user_id <> created_by
  )
);

create unique index study_group_invites_pending_unique
on core.study_group_invites (group_id, target_user_id, kind)
where status = 'pending';

create index study_group_invites_target_idx
on core.study_group_invites (target_user_id, status, created_at desc);

create index study_group_invites_group_idx
on core.study_group_invites (group_id, kind, status, created_at);

create or replace function core.gen_group_join_code()
returns text
language plpgsql
volatile
set search_path = ''
as $$
declare
  v_code text;
begin
  loop
    v_code := upper(substr(replace(extensions.gen_random_uuid()::text, '-', ''), 1, 8));
    exit when not exists (
      select 1 from core.study_groups where join_code = v_code
    );
  end loop;
  return v_code;
end;
$$;

create or replace function core.current_study_group_id()
returns uuid
language sql
stable
security definer
set search_path = ''
as $$
  select m.group_id
  from core.study_group_members m
  where m.user_id = (select auth.uid())
  limit 1;
$$;

create or replace function core.is_study_group_member(
  p_group_id uuid,
  p_user_id uuid
)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select p_user_id = (select auth.uid()) and exists (
    select 1
    from core.study_group_members m
    where m.group_id = p_group_id
      and m.user_id = p_user_id
  );
$$;

create or replace function core.validate_study_group_scope()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not exists (
    select 1
    from core.user_academic_profiles p
    where p.user_id = new.owner_id
      and p.organization_id = new.organization_id
  ) then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;

  new.name := btrim(new.name);
  new.emoji := coalesce(nullif(new.emoji, ''), '🎓');
  new.description := btrim(coalesce(new.description, ''));
  new.join_code := upper(btrim(new.join_code));
  return new;
end;
$$;

create trigger validate_study_group_scope
before insert or update of organization_id, owner_id, name, emoji, description, join_code
on core.study_groups
for each row execute function core.validate_study_group_scope();

create or replace function core.validate_study_group_member_scope()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_organization_id text;
  v_owner_id uuid;
begin
  select g.organization_id, g.owner_id
  into v_organization_id, v_owner_id
  from core.study_groups g
  where g.id = new.group_id;

  if v_organization_id is null then
    raise exception 'Study group not found';
  end if;

  if not exists (
    select 1
    from core.user_academic_profiles p
    where p.user_id = new.user_id
      and p.organization_id = v_organization_id
  ) then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;

  if (new.user_id = v_owner_id) <> (new.role = 'owner') then
    raise exception 'Study group owner membership is invalid'
      using errcode = '23514';
  end if;

  return new;
end;
$$;

create trigger validate_study_group_member_scope
before insert or update of group_id, user_id, role
on core.study_group_members
for each row execute function core.validate_study_group_member_scope();

create or replace function core.validate_study_group_invite_scope()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_organization_id text;
  v_owner_id uuid;
begin
  select g.organization_id, g.owner_id
  into v_organization_id, v_owner_id
  from core.study_groups g
  where g.id = new.group_id;

  if v_organization_id is null then
    raise exception 'Study group not found';
  end if;

  if not exists (
    select 1
    from core.user_academic_profiles p
    where p.user_id = new.target_user_id
      and p.organization_id = v_organization_id
  ) then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;

  if new.kind = 'invite' and new.created_by <> v_owner_id then
    raise exception 'Only the owner can invite group members'
      using errcode = '42501';
  end if;

  if new.kind = 'request' and new.created_by <> new.target_user_id then
    raise exception 'Join requests must be created by their target user'
      using errcode = '42501';
  end if;

  return new;
end;
$$;

create trigger validate_study_group_invite_scope
before insert or update of group_id, target_user_id, created_by, kind
on core.study_group_invites
for each row execute function core.validate_study_group_invite_scope();

alter table core.study_groups enable row level security;
alter table core.study_group_members enable row level security;
alter table core.study_group_invites enable row level security;

create policy "members read their study group"
on core.study_groups for select to authenticated
using (
  core.is_study_group_member(id, (select auth.uid()))
  or (
    is_discoverable
    and exists (
      select 1
      from core.user_academic_profiles p
      where p.user_id = (select auth.uid())
        and p.organization_id = study_groups.organization_id
    )
  )
);

create policy "owners update their study group"
on core.study_groups for update to authenticated
using (owner_id = (select auth.uid()))
with check (owner_id = (select auth.uid()));

create policy "owners delete their study group"
on core.study_groups for delete to authenticated
using (owner_id = (select auth.uid()));

create policy "members read their roster"
on core.study_group_members for select to authenticated
using (core.is_study_group_member(group_id, (select auth.uid())));

create policy "owners add study group members"
on core.study_group_members for insert to authenticated
with check (
  exists (
    select 1
    from core.study_groups g
    where g.id = study_group_members.group_id
      and g.owner_id = (select auth.uid())
  )
);

create policy "members leave or owners remove members"
on core.study_group_members for delete to authenticated
using (
  role = 'member'
  and (
    user_id = (select auth.uid())
    or exists (
    select 1
    from core.study_groups g
    where g.id = study_group_members.group_id
      and g.owner_id = (select auth.uid())
    )
  )
);

create policy "participants read study group invites"
on core.study_group_invites for select to authenticated
using (
  target_user_id = (select auth.uid())
  or exists (
    select 1
    from core.study_groups g
    where g.id = study_group_invites.group_id
      and g.owner_id = (select auth.uid())
  )
);

create policy "owners create study group invites"
on core.study_group_invites for insert to authenticated
with check (
  (kind = 'request' and target_user_id = (select auth.uid()))
  or exists (
    select 1
    from core.study_groups g
    where g.id = study_group_invites.group_id
      and g.owner_id = (select auth.uid())
      and kind = 'invite'
  )
);

create policy "participants respond to study group invites"
on core.study_group_invites for update to authenticated
using (
  target_user_id = (select auth.uid())
  or exists (
    select 1
    from core.study_groups g
    where g.id = study_group_invites.group_id
      and g.owner_id = (select auth.uid())
  )
)
with check (
  target_user_id = (select auth.uid())
  or exists (
    select 1
    from core.study_groups g
    where g.id = study_group_invites.group_id
      and g.owner_id = (select auth.uid())
  )
);

revoke all on core.study_groups from anon, authenticated;
revoke all on core.study_group_members from anon, authenticated;
revoke all on core.study_group_invites from anon, authenticated;
grant select (
  id,
  organization_id,
  owner_id,
  name,
  emoji,
  description,
  is_discoverable,
  created_at,
  updated_at
) on core.study_groups to authenticated;
grant all on core.study_groups to service_role;
grant all on core.study_group_members to service_role;
grant all on core.study_group_invites to service_role;

revoke all on function core.gen_group_join_code() from public, anon, authenticated;
revoke all on function core.current_study_group_id() from public, anon;
revoke all on function core.is_study_group_member(uuid, uuid) from public, anon;
revoke all on function core.validate_study_group_scope() from public, anon, authenticated;
revoke all on function core.validate_study_group_member_scope() from public, anon, authenticated;
revoke all on function core.validate_study_group_invite_scope() from public, anon, authenticated;
grant execute on function core.current_study_group_id() to authenticated, service_role;
grant execute on function core.is_study_group_member(uuid, uuid) to authenticated, service_role;
grant execute on function core.gen_group_join_code() to service_role;

-- The hardened community RPCs in the next migration use stable group ids.
-- Keep legacy academic-group rows readable while routing all new rows through
-- membership-backed group ids.
alter table core.group_posts
  add column group_id uuid references core.study_groups(id) on delete cascade;
alter table core.group_posts alter column academic_group drop not null;
create index group_posts_study_group_idx
  on core.group_posts (group_id, is_pinned desc, created_at desc);

alter table core.group_links
  add column group_id uuid references core.study_groups(id) on delete cascade;
alter table core.group_links alter column academic_group drop not null;
create index group_links_study_group_idx
  on core.group_links (group_id, created_at desc);

alter table core.group_notes
  add column group_id uuid references core.study_groups(id) on delete cascade,
  add column owner_id uuid references auth.users(id) on delete cascade,
  add column visibility text not null default 'group';
update core.group_notes set owner_id = created_by where owner_id is null;
alter table core.group_notes alter column owner_id set not null;
alter table core.group_notes alter column academic_group drop not null;
alter table core.group_notes
  add constraint group_notes_visibility_valid
  check (visibility in ('group', 'personal'));
create index group_notes_study_group_idx
  on core.group_notes (group_id, updated_at desc);
create index group_notes_owner_idx
  on core.group_notes (owner_id, updated_at desc);

drop policy if exists "group posts readable by groupmates" on core.group_posts;
drop policy if exists "groupmates insert posts" on core.group_posts;
drop policy if exists "authors update own posts" on core.group_posts;
drop policy if exists "authors delete own posts" on core.group_posts;

create policy "study group members read posts"
on core.group_posts for select to authenticated
using (
  (group_id is not null and core.is_study_group_member(group_id, (select auth.uid())))
  or (group_id is null and academic_group = core.current_academic_group())
);

create policy "study group members create posts"
on core.group_posts for insert to authenticated
with check (
  author_id = (select auth.uid())
  and group_id is not null
  and core.is_study_group_member(group_id, (select auth.uid()))
  and exists (
    select 1 from core.study_groups g
    where g.id = group_posts.group_id
      and g.organization_id = group_posts.organization_id
  )
);

create policy "study group authors update posts"
on core.group_posts for update to authenticated
using (
  author_id = (select auth.uid())
  and (
    (group_id is not null and core.is_study_group_member(group_id, (select auth.uid())))
    or (group_id is null and academic_group = core.current_academic_group())
  )
)
with check (
  author_id = (select auth.uid())
  and (
    (group_id is not null and core.is_study_group_member(group_id, (select auth.uid())))
    or (group_id is null and academic_group = core.current_academic_group())
  )
);

create policy "study group authors delete posts"
on core.group_posts for delete to authenticated
using (author_id = (select auth.uid()));

drop policy if exists "group links readable by groupmates" on core.group_links;
drop policy if exists "groupmates insert links" on core.group_links;
drop policy if exists "authors delete own links" on core.group_links;

create policy "study group members read links"
on core.group_links for select to authenticated
using (
  (group_id is not null and core.is_study_group_member(group_id, (select auth.uid())))
  or (group_id is null and academic_group = core.current_academic_group())
);

create policy "study group members create links"
on core.group_links for insert to authenticated
with check (
  created_by = (select auth.uid())
  and group_id is not null
  and core.is_study_group_member(group_id, (select auth.uid()))
  and exists (
    select 1 from core.study_groups g
    where g.id = group_links.group_id
      and g.organization_id = group_links.organization_id
  )
);

create policy "study group authors delete links"
on core.group_links for delete to authenticated
using (created_by = (select auth.uid()));

drop policy if exists "group notes readable by groupmates" on core.group_notes;
drop policy if exists "groupmates create notes" on core.group_notes;
drop policy if exists "groupmates edit notes" on core.group_notes;
drop policy if exists "creators delete own notes" on core.group_notes;

create policy "study group members read notes"
on core.group_notes for select to authenticated
using (
  (visibility = 'personal' and owner_id = (select auth.uid()))
  or (
    visibility = 'group'
    and (
      (group_id is not null and core.is_study_group_member(group_id, (select auth.uid())))
      or (group_id is null and academic_group = core.current_academic_group())
    )
  )
);

create policy "study group members create notes"
on core.group_notes for insert to authenticated
with check (
  created_by = (select auth.uid())
  and owner_id = (select auth.uid())
  and (
    (visibility = 'personal' and group_id is null)
    or (
      visibility = 'group'
      and group_id is not null
      and core.is_study_group_member(group_id, (select auth.uid()))
      and exists (
        select 1 from core.study_groups g
        where g.id = group_notes.group_id
          and g.organization_id = group_notes.organization_id
      )
    )
  )
);

create policy "study group members edit notes"
on core.group_notes for update to authenticated
using (
  (visibility = 'personal' and owner_id = (select auth.uid()))
  or (
    visibility = 'group'
    and group_id is not null
    and core.is_study_group_member(group_id, (select auth.uid()))
  )
)
with check (
  (visibility = 'personal' and owner_id = (select auth.uid()))
  or (
    visibility = 'group'
    and group_id is not null
    and core.is_study_group_member(group_id, (select auth.uid()))
  )
);

create policy "study group note owners delete notes"
on core.group_notes for delete to authenticated
using (owner_id = (select auth.uid()));

create or replace function app_api_v1.get_my_group_invites()
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;

  return coalesce(
    (
      select jsonb_agg(
        jsonb_build_object(
          'id', i.id,
          'groupId', g.id,
          'groupName', g.name,
          'groupEmoji', g.emoji,
          'memberCount', (
            select count(*)
            from core.study_group_members m
            where m.group_id = g.id
          ),
          'invitedByName', coalesce(p.full_name, 'Студент')
        )
        order by i.created_at desc
      )
      from core.study_group_invites i
      join core.study_groups g on g.id = i.group_id
      left join core.user_academic_profiles p on p.user_id = i.created_by
      where i.target_user_id = v_user_id
        and i.kind = 'invite'
        and i.status = 'pending'
    ),
    '[]'::jsonb
  );
end;
$$;

create or replace function app_api_v1.get_my_study_group(
  p_organization_id text
)
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
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;

  if not exists (
    select 1
    from core.user_academic_profiles p
    where p.user_id = v_user_id
      and p.organization_id = p_organization_id
  ) then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;

  select g.id, g.owner_id = v_user_id
  into v_group_id, v_is_owner
  from core.study_group_members m
  join core.study_groups g on g.id = m.group_id
  where m.user_id = v_user_id
    and g.organization_id = p_organization_id;

  if v_group_id is null then
    return jsonb_build_object(
      'hasGroup', false,
      'isOwner', false,
      'group', null,
      'members', '[]'::jsonb,
      'incomingInvites', coalesce(
        (
          select jsonb_agg(invite order by invite ->> 'id')
          from jsonb_array_elements(app_api_v1.get_my_group_invites()) invite
          where exists (
            select 1
            from core.study_group_invites i
            join core.study_groups g on g.id = i.group_id
            where i.id = (invite ->> 'id')::uuid
              and g.organization_id = p_organization_id
          )
        ),
        '[]'::jsonb
      ),
      'pendingRequests', '[]'::jsonb
    );
  end if;

  return jsonb_build_object(
    'hasGroup', true,
    'isOwner', v_is_owner,
    'group', (
      select jsonb_build_object(
        'id', g.id,
        'name', g.name,
        'emoji', g.emoji,
        'description', g.description,
        'joinCode', g.join_code,
        'isDiscoverable', g.is_discoverable,
        'memberCount', (
          select count(*) from core.study_group_members m where m.group_id = g.id
        ),
        'createdAt', g.created_at
      )
      from core.study_groups g
      where g.id = v_group_id
    ),
    'members', coalesce(
      (
        select jsonb_agg(
          jsonb_build_object(
            'userId', m.user_id,
            'fullName', coalesce(p.full_name, 'Студент'),
            'handle', p.handle,
            'role', m.role,
            'isOwner', m.role = 'owner',
            'isMe', m.user_id = v_user_id,
            'isFriend', coalesce(f.status = 'accepted', false),
            'friendshipStatus', f.status
          )
          order by (m.role = 'owner') desc, coalesce(p.full_name, 'Студент')
        )
        from core.study_group_members m
        left join core.user_academic_profiles p on p.user_id = m.user_id
        left join core.friendships f
          on least(f.requester_id, f.addressee_id) = least(v_user_id, m.user_id)
         and greatest(f.requester_id, f.addressee_id) = greatest(v_user_id, m.user_id)
        where m.group_id = v_group_id
      ),
      '[]'::jsonb
    ),
    'incomingInvites', coalesce(
      (
        select jsonb_agg(invite order by invite ->> 'id')
        from jsonb_array_elements(app_api_v1.get_my_group_invites()) invite
        where exists (
          select 1
          from core.study_group_invites i
          join core.study_groups g on g.id = i.group_id
          where i.id = (invite ->> 'id')::uuid
            and g.organization_id = p_organization_id
        )
      ),
      '[]'::jsonb
    ),
    'pendingRequests', case when v_is_owner then coalesce(
      (
        select jsonb_agg(
          jsonb_build_object(
            'id', i.id,
            'userId', i.target_user_id,
            'fullName', coalesce(p.full_name, 'Студент'),
            'handle', p.handle,
            'createdAt', i.created_at
          )
          order by i.created_at
        )
        from core.study_group_invites i
        left join core.user_academic_profiles p on p.user_id = i.target_user_id
        where i.group_id = v_group_id
          and i.kind = 'request'
          and i.status = 'pending'
      ),
      '[]'::jsonb
    ) else '[]'::jsonb end
  );
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
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if core.current_study_group_id() is not null then
    raise exception 'Already a member of a group';
  end if;

  perform core.enforce_rate_limit('create_study_group', 5, interval '1 day');

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
  where target_user_id = v_user_id and status = 'pending';

  return app_api_v1.get_my_study_group(p_organization_id);
end;
$$;

create or replace function app_api_v1.update_study_group(
  p_organization_id text,
  p_name text default null::text,
  p_emoji text default null::text,
  p_description text default null::text,
  p_discoverable boolean default null::boolean
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;

  perform core.enforce_rate_limit('update_study_group', 30, interval '1 hour');

  update core.study_groups
  set
    name = case
      when p_name is null then name
      else core.validate_text(p_name, 'Название', 100, true)
    end,
    emoji = case
      when p_emoji is null then emoji
      else left(coalesce(nullif(p_emoji, ''), '🎓'), 16)
    end,
    description = case
      when p_description is null then description
      else core.validate_text(p_description, 'Описание', 2000, false)
    end,
    is_discoverable = coalesce(p_discoverable, is_discoverable)
  where owner_id = v_user_id
    and organization_id = p_organization_id;

  if not found then
    raise exception 'Only the owner can edit the group' using errcode = '42501';
  end if;

  return app_api_v1.get_my_study_group(p_organization_id);
end;
$$;

create or replace function app_api_v1.delete_study_group(
  p_organization_id text
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  perform core.enforce_rate_limit('delete_study_group', 5, interval '1 day');

  delete from core.study_groups
  where owner_id = v_user_id
    and organization_id = p_organization_id;

  if not found then
    raise exception 'Only the owner can delete the group' using errcode = '42501';
  end if;
end;
$$;

create or replace function app_api_v1.leave_study_group()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group_id uuid;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  select m.group_id into v_group_id
  from core.study_group_members m
  join core.study_groups g on g.id = m.group_id
  where m.user_id = v_user_id
    and g.owner_id <> v_user_id;

  if v_group_id is null then
    raise exception 'Owners must delete their group';
  end if;

  delete from core.study_group_members
  where group_id = v_group_id and user_id = v_user_id;
end;
$$;

create or replace function app_api_v1.invite_to_study_group(
  p_user_id uuid
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group_id uuid;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if p_user_id = v_user_id then
    raise exception 'Cannot invite yourself' using errcode = '22023';
  end if;

  select g.id into v_group_id
  from core.study_groups g
  where g.owner_id = v_user_id;

  if v_group_id is null then
    raise exception 'Only the owner can invite members' using errcode = '42501';
  end if;
  if exists (
    select 1 from core.study_group_members m where m.user_id = p_user_id
  ) then
    raise exception 'User is already a member of a group';
  end if;

  perform core.enforce_rate_limit('invite_to_study_group', 30, interval '1 hour');

  insert into core.study_group_invites (
    group_id,
    target_user_id,
    created_by,
    kind
  )
  values (v_group_id, p_user_id, v_user_id, 'invite')
  on conflict (group_id, target_user_id, kind) where status = 'pending'
  do update set created_by = excluded.created_by, created_at = now();
end;
$$;

create or replace function app_api_v1.invite_to_study_group_by_handle(
  p_handle text
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group_id uuid;
  v_organization_id text;
  v_target_user_id uuid;
  v_handle text := lower(btrim(regexp_replace(coalesce(p_handle, ''), '^@+', '')));
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if v_handle = '' then
    raise exception 'Handle is required' using errcode = '22023';
  end if;

  select g.id, g.organization_id
  into v_group_id, v_organization_id
  from core.study_groups g
  where g.owner_id = v_user_id;

  if v_group_id is null then
    raise exception 'Only the owner can invite members' using errcode = '42501';
  end if;

  select p.user_id into v_target_user_id
  from core.user_academic_profiles p
  where p.organization_id = v_organization_id
    and lower(btrim(p.handle)) = v_handle
  order by p.user_id
  limit 1;

  if v_target_user_id is null then
    raise exception 'User not found';
  end if;

  perform app_api_v1.invite_to_study_group(v_target_user_id);
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

  select i.group_id, g.organization_id
  into v_group_id, v_organization_id
  from core.study_group_invites i
  join core.study_groups g on g.id = i.group_id
  where i.id = p_invite_id
    and i.target_user_id = v_user_id
    and i.kind = 'invite'
    and i.status = 'pending'
  for update of i;

  if v_group_id is null then
    raise exception 'Pending invite not found';
  end if;

  perform core.enforce_rate_limit('respond_group_invite', 30, interval '1 hour');

  if coalesce(p_accept, false) then
    if core.current_study_group_id() is not null then
      raise exception 'Already a member of a group';
    end if;
    insert into core.study_group_members (group_id, user_id, role)
    values (v_group_id, v_user_id, 'member');
    update core.study_group_invites
    set status = 'accepted', responded_at = now()
    where id = p_invite_id;
    update core.study_group_invites
    set status = 'revoked', responded_at = now()
    where target_user_id = v_user_id
      and status = 'pending'
      and id <> p_invite_id;
  else
    update core.study_group_invites
    set status = 'declined', responded_at = now()
    where id = p_invite_id;
  end if;

  return app_api_v1.get_my_study_group(v_organization_id);
end;
$$;

create or replace function app_api_v1.join_group_by_code(
  p_organization_id text,
  p_code text
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group_id uuid;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if core.current_study_group_id() is not null then
    raise exception 'Already a member of a group';
  end if;

  select g.id into v_group_id
  from core.study_groups g
  where g.organization_id = p_organization_id
    and g.join_code = upper(btrim(coalesce(p_code, '')))
  for update;

  if v_group_id is null then
    raise exception 'Study group not found';
  end if;

  perform core.enforce_rate_limit('join_group_by_code', 15, interval '1 hour');
  insert into core.study_group_members (group_id, user_id, role)
  values (v_group_id, v_user_id, 'member');
  update core.study_group_invites
  set status = 'revoked', responded_at = now()
  where target_user_id = v_user_id and status = 'pending';

  return app_api_v1.get_my_study_group(p_organization_id);
end;
$$;

create or replace function app_api_v1.request_to_join_group(
  p_group_id uuid
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_owner_id uuid;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if core.current_study_group_id() is not null then
    raise exception 'Already a member of a group';
  end if;

  select g.owner_id into v_owner_id
  from core.study_groups g
  join core.user_academic_profiles p
    on p.user_id = v_user_id
   and p.organization_id = g.organization_id
  where g.id = p_group_id
    and g.is_discoverable;

  if v_owner_id is null then
    raise exception 'Discoverable study group not found';
  end if;

  perform core.enforce_rate_limit('request_to_join_group', 20, interval '1 day');
  insert into core.study_group_invites (
    group_id,
    target_user_id,
    created_by,
    kind
  )
  values (p_group_id, v_user_id, v_user_id, 'request')
  on conflict (group_id, target_user_id, kind) where status = 'pending'
  do update set created_at = now();
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

  select i.group_id, i.target_user_id, g.organization_id
  into v_group_id, v_target_user_id, v_organization_id
  from core.study_group_invites i
  join core.study_groups g on g.id = i.group_id
  where i.id = p_invite_id
    and i.kind = 'request'
    and i.status = 'pending'
    and g.owner_id = v_user_id
  for update of i;

  if v_group_id is null then
    raise exception 'Pending join request not found';
  end if;

  perform core.enforce_rate_limit('respond_join_request', 60, interval '1 hour');

  if coalesce(p_accept, false) then
    if exists (
      select 1 from core.study_group_members m where m.user_id = v_target_user_id
    ) then
      raise exception 'User is already a member of a group';
    end if;
    insert into core.study_group_members (group_id, user_id, role)
    values (v_group_id, v_target_user_id, 'member');
    update core.study_group_invites
    set status = 'accepted', responded_at = now()
    where id = p_invite_id;
    update core.study_group_invites
    set status = 'revoked', responded_at = now()
    where target_user_id = v_target_user_id
      and status = 'pending'
      and id <> p_invite_id;
  else
    update core.study_group_invites
    set status = 'declined', responded_at = now()
    where id = p_invite_id;
  end if;

  return app_api_v1.get_my_study_group(v_organization_id);
end;
$$;

create or replace function app_api_v1.remove_group_member(
  p_user_id uuid
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group_id uuid;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if p_user_id = v_user_id then
    raise exception 'Owners cannot remove themselves';
  end if;

  select g.id into v_group_id
  from core.study_groups g
  where g.owner_id = v_user_id;

  if v_group_id is null then
    raise exception 'Only the owner can remove members' using errcode = '42501';
  end if;

  perform core.enforce_rate_limit('remove_group_member', 60, interval '1 hour');
  delete from core.study_group_members
  where group_id = v_group_id
    and user_id = p_user_id
    and role = 'member';

  if not found then
    raise exception 'Study group member not found';
  end if;
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
    select 1
    from core.user_academic_profiles p
    where p.user_id = v_user_id
      and p.organization_id = p_organization_id
  ) then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;

  v_pattern := '%' || replace(replace(replace(v_query, '\', '\\'), '%', '\%'), '_', '\_') || '%';

  return coalesce(
    (
      select jsonb_agg(
        jsonb_build_object(
          'id', g.id,
          'name', g.name,
          'emoji', g.emoji,
          'description', g.description,
          'memberCount', (
            select count(*) from core.study_group_members m where m.group_id = g.id
          ),
          'ownerName', coalesce(p.full_name, 'Студент'),
          'hasRequested', exists (
            select 1
            from core.study_group_invites i
            where i.group_id = g.id
              and i.target_user_id = v_user_id
              and i.kind = 'request'
              and i.status = 'pending'
          )
        )
        order by g.name, g.id
      )
      from (
        select candidate.*
        from core.study_groups candidate
        where candidate.organization_id = p_organization_id
          and candidate.is_discoverable
          and (
            v_query = ''
            or candidate.name ilike v_pattern escape '\'
            or candidate.join_code = upper(v_query)
          )
        order by candidate.name, candidate.id
        limit 30
      ) g
      left join core.user_academic_profiles p on p.user_id = g.owner_id
    ),
    '[]'::jsonb
  );
end;
$$;

create or replace function public.get_my_study_group(p_organization_id text)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$ select app_api_v1.get_my_study_group(p_organization_id); $$;

create or replace function public.create_study_group(
  p_organization_id text,
  p_name text,
  p_emoji text default '🎓'::text,
  p_description text default ''::text,
  p_discoverable boolean default true
)
returns jsonb
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.create_study_group(
    p_organization_id,
    p_name,
    p_emoji,
    p_description,
    p_discoverable
  );
$$;

create or replace function public.update_study_group(
  p_organization_id text,
  p_name text default null::text,
  p_emoji text default null::text,
  p_description text default null::text,
  p_discoverable boolean default null::boolean
)
returns jsonb
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.update_study_group(
    p_organization_id,
    p_name,
    p_emoji,
    p_description,
    p_discoverable
  );
$$;

create or replace function public.delete_study_group(p_organization_id text)
returns void
language sql
security invoker
set search_path = ''
as $$ select app_api_v1.delete_study_group(p_organization_id); $$;

create or replace function public.leave_study_group()
returns void
language sql
security invoker
set search_path = ''
as $$ select app_api_v1.leave_study_group(); $$;

create or replace function public.invite_to_study_group(p_user_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$ select app_api_v1.invite_to_study_group(p_user_id); $$;

create or replace function public.invite_to_study_group_by_handle(p_handle text)
returns void
language sql
security invoker
set search_path = ''
as $$ select app_api_v1.invite_to_study_group_by_handle(p_handle); $$;

create or replace function public.respond_group_invite(
  p_invite_id uuid,
  p_accept boolean
)
returns jsonb
language sql
security invoker
set search_path = ''
as $$ select app_api_v1.respond_group_invite(p_invite_id, p_accept); $$;

create or replace function public.join_group_by_code(
  p_organization_id text,
  p_code text
)
returns jsonb
language sql
security invoker
set search_path = ''
as $$ select app_api_v1.join_group_by_code(p_organization_id, p_code); $$;

create or replace function public.request_to_join_group(p_group_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$ select app_api_v1.request_to_join_group(p_group_id); $$;

create or replace function public.respond_join_request(
  p_invite_id uuid,
  p_accept boolean
)
returns jsonb
language sql
security invoker
set search_path = ''
as $$ select app_api_v1.respond_join_request(p_invite_id, p_accept); $$;

create or replace function public.remove_group_member(p_user_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$ select app_api_v1.remove_group_member(p_user_id); $$;

create or replace function public.get_my_group_invites()
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$ select app_api_v1.get_my_group_invites(); $$;

create or replace function public.search_study_groups(
  p_organization_id text,
  p_query text
)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$ select app_api_v1.search_study_groups(p_organization_id, p_query); $$;

revoke all on function app_api_v1.get_my_study_group(text) from public, anon;
revoke all on function app_api_v1.create_study_group(text, text, text, text, boolean) from public, anon;
revoke all on function app_api_v1.update_study_group(text, text, text, text, boolean) from public, anon;
revoke all on function app_api_v1.delete_study_group(text) from public, anon;
revoke all on function app_api_v1.leave_study_group() from public, anon;
revoke all on function app_api_v1.invite_to_study_group(uuid) from public, anon;
revoke all on function app_api_v1.invite_to_study_group_by_handle(text) from public, anon;
revoke all on function app_api_v1.respond_group_invite(uuid, boolean) from public, anon;
revoke all on function app_api_v1.join_group_by_code(text, text) from public, anon;
revoke all on function app_api_v1.request_to_join_group(uuid) from public, anon;
revoke all on function app_api_v1.respond_join_request(uuid, boolean) from public, anon;
revoke all on function app_api_v1.remove_group_member(uuid) from public, anon;
revoke all on function app_api_v1.get_my_group_invites() from public, anon;
revoke all on function app_api_v1.search_study_groups(text, text) from public, anon;

grant execute on function app_api_v1.get_my_study_group(text) to authenticated, service_role;
grant execute on function app_api_v1.create_study_group(text, text, text, text, boolean) to authenticated, service_role;
grant execute on function app_api_v1.update_study_group(text, text, text, text, boolean) to authenticated, service_role;
grant execute on function app_api_v1.delete_study_group(text) to authenticated, service_role;
grant execute on function app_api_v1.leave_study_group() to authenticated, service_role;
grant execute on function app_api_v1.invite_to_study_group(uuid) to authenticated, service_role;
grant execute on function app_api_v1.invite_to_study_group_by_handle(text) to authenticated, service_role;
grant execute on function app_api_v1.respond_group_invite(uuid, boolean) to authenticated, service_role;
grant execute on function app_api_v1.join_group_by_code(text, text) to authenticated, service_role;
grant execute on function app_api_v1.request_to_join_group(uuid) to authenticated, service_role;
grant execute on function app_api_v1.respond_join_request(uuid, boolean) to authenticated, service_role;
grant execute on function app_api_v1.remove_group_member(uuid) to authenticated, service_role;
grant execute on function app_api_v1.get_my_group_invites() to authenticated, service_role;
grant execute on function app_api_v1.search_study_groups(text, text) to authenticated, service_role;

revoke all on function public.get_my_study_group(text) from public, anon;
revoke all on function public.create_study_group(text, text, text, text, boolean) from public, anon;
revoke all on function public.update_study_group(text, text, text, text, boolean) from public, anon;
revoke all on function public.delete_study_group(text) from public, anon;
revoke all on function public.leave_study_group() from public, anon;
revoke all on function public.invite_to_study_group(uuid) from public, anon;
revoke all on function public.invite_to_study_group_by_handle(text) from public, anon;
revoke all on function public.respond_group_invite(uuid, boolean) from public, anon;
revoke all on function public.join_group_by_code(text, text) from public, anon;
revoke all on function public.request_to_join_group(uuid) from public, anon;
revoke all on function public.respond_join_request(uuid, boolean) from public, anon;
revoke all on function public.remove_group_member(uuid) from public, anon;
revoke all on function public.get_my_group_invites() from public, anon;
revoke all on function public.search_study_groups(text, text) from public, anon;

grant execute on function public.get_my_study_group(text) to authenticated, service_role;
grant execute on function public.create_study_group(text, text, text, text, boolean) to authenticated, service_role;
grant execute on function public.update_study_group(text, text, text, text, boolean) to authenticated, service_role;
grant execute on function public.delete_study_group(text) to authenticated, service_role;
grant execute on function public.leave_study_group() to authenticated, service_role;
grant execute on function public.invite_to_study_group(uuid) to authenticated, service_role;
grant execute on function public.invite_to_study_group_by_handle(text) to authenticated, service_role;
grant execute on function public.respond_group_invite(uuid, boolean) to authenticated, service_role;
grant execute on function public.join_group_by_code(text, text) to authenticated, service_role;
grant execute on function public.request_to_join_group(uuid) to authenticated, service_role;
grant execute on function public.respond_join_request(uuid, boolean) to authenticated, service_role;
grant execute on function public.remove_group_member(uuid) to authenticated, service_role;
grant execute on function public.get_my_group_invites() to authenticated, service_role;
grant execute on function public.search_study_groups(text, text) to authenticated, service_role;
