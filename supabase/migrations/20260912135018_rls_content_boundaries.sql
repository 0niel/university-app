drop policy if exists lost_found_images_insert on storage.objects;
drop policy if exists lost_found_images_delete on storage.objects;

alter table core.study_group_invites
add column if not exists responded_at timestamptz;

drop policy if exists "public read note media" on storage.objects;
create policy "users read own note media"
on storage.objects for select to authenticated
using (
  bucket_id = 'note-media'
  and split_part(name, '/', 1) = (select auth.uid())::text
);

revoke all on schema ingest_v1 from public, anon, authenticated;
grant usage on schema ingest_v1 to service_role;
revoke execute on all functions in schema ingest_v1
from public, anon, authenticated;
grant execute on all functions in schema ingest_v1 to service_role;

revoke all on public.friend_locations from anon;

do $$
declare
  v_table regclass;
begin
  for v_table in
    select relation.oid::regclass
    from pg_catalog.pg_class relation
    join pg_catalog.pg_namespace namespace on namespace.oid = relation.relnamespace
    where namespace.nspname = 'core'
      and relation.relkind in ('r', 'p')
      and not relation.relrowsecurity
      and not has_table_privilege('anon', relation.oid, 'SELECT,INSERT,UPDATE,DELETE')
      and not has_table_privilege('authenticated', relation.oid, 'SELECT,INSERT,UPDATE,DELETE')
  loop
    execute format('alter table %s enable row level security', v_table);
  end loop;
end;
$$;

create or replace function core.study_group_in_current_organization(p_group_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from core.study_groups study_group
    join core.user_academic_profiles profile
      on profile.organization_id = study_group.organization_id
    where study_group.id = p_group_id
      and profile.user_id = (select auth.uid())
  );
$$;

revoke all on function core.study_group_in_current_organization(uuid)
from public, anon, authenticated;
grant execute on function core.study_group_in_current_organization(uuid)
to authenticated, service_role;

create policy "study group organization read boundary"
on core.study_groups as restrictive for select to authenticated
using (core.study_group_in_current_organization(id));

create policy "study group member organization read boundary"
on core.study_group_members as restrictive for select to authenticated
using (core.study_group_in_current_organization(group_id));

create policy "study group invite organization read boundary"
on core.study_group_invites as restrictive for select to authenticated
using (core.study_group_in_current_organization(group_id));

create or replace function internal.can_admin_content_object(
  p_bucket_id text,
  p_name text
)
returns boolean
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_allowed boolean;
  v_organizations text[];
  v_organization_id text;
  v_admin_function regprocedure := to_regprocedure('core.is_app_admin(text)');
begin
  if (select auth.uid()) is null
    or v_admin_function is null
    or p_bucket_id not in (
      'lost-found-images', 'marketplace-media', 'note-media', 'room-photos',
      'lesson-materials', 'mini-app-icons', 'mini-app-uploads'
    ) then
    return false;
  end if;

  case p_bucket_id
    when 'lesson-materials' then
      select array_agg(distinct material.organization_id)
      into v_organizations
      from core.lesson_materials material
      where material.file_path = p_name or material.preview_path = p_name;
    when 'lost-found-images' then
      select array_agg(distinct item.organization_id)
      into v_organizations
      from core.lost_found_items item
      where item.images ? p_name;
    when 'marketplace-media' then
      select array_agg(distinct listing.organization_id)
      into v_organizations
      from core.marketplace_listings listing
      where listing.media @> jsonb_build_array(jsonb_build_object('path', p_name));
    when 'room-photos' then
      select array_agg(distinct photo.organization_id)
      into v_organizations
      from core.room_photos photo
      where photo.path = p_name;
    else
      null;
  end case;

  if v_organizations is not null then
    foreach v_organization_id in array v_organizations loop
      execute format('select %s($1)', v_admin_function::oid::regproc) into v_allowed
      using v_organization_id;
      if v_allowed then
        return true;
      end if;
    end loop;
    return false;
  end if;

  select profile.organization_id into v_organization_id
  from core.user_academic_profiles profile
  where profile.user_id::text = split_part(p_name, '/', 1);

  if v_organization_id is null then
    return false;
  end if;
  execute format('select %s($1)', v_admin_function::oid::regproc) into v_allowed
  using v_organization_id;
  return coalesce(v_allowed, false);
end;
$$;

revoke all on function internal.can_admin_content_object(text, text)
from public, anon, authenticated;
grant execute on function internal.can_admin_content_object(text, text)
to authenticated, service_role;

do $$
begin
  if exists (
    select 1 from pg_catalog.pg_policy
    where polrelid = 'storage.objects'::regclass
      and polname = 'app admins read content objects'
  ) then
    alter policy "app admins read content objects" on storage.objects
    using (internal.can_admin_content_object(bucket_id, name));
  end if;
  if exists (
    select 1 from pg_catalog.pg_policy
    where polrelid = 'storage.objects'::regclass
      and polname = 'app admins delete content objects'
  ) then
    alter policy "app admins delete content objects" on storage.objects
    using (internal.can_admin_content_object(bucket_id, name));
  end if;
end;
$$;

create or replace function core.require_admin_target_organization(
  p_organization_id text,
  p_user_id uuid
)
returns void
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_admin_function regprocedure := to_regprocedure('core.require_app_admin(text,text)');
begin
  if v_admin_function is null then
    raise exception 'Admin access required' using errcode = '42501';
  end if;
  execute format('select %s($1)', v_admin_function::oid::regproc)
  using p_organization_id;
  if exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = p_user_id
      and profile.organization_id is distinct from p_organization_id
  ) then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;
end;
$$;

revoke all on function core.require_admin_target_organization(text, uuid)
from public, anon, authenticated;
grant execute on function core.require_admin_target_organization(text, uuid)
to service_role;

do $$
declare
  v_signature text;
  v_oid regprocedure;
  v_definition text;
  v_replacement text;
begin
  foreach v_signature in array array[
    'app_api_v1.admin_get_user(text,uuid)',
    'app_api_v1.admin_ban_user(text,uuid,text,timestamptz)',
    'app_api_v1.admin_unban_user(text,uuid)'
  ] loop
    v_oid := to_regprocedure(v_signature);
    if v_oid is null then
      continue;
    end if;
    v_definition := pg_get_functiondef(v_oid);
    if position('core.require_app_admin(p_organization_id' in v_definition) = 0 then
      raise exception 'Unexpected admin function definition: %', v_signature;
    end if;
    v_replacement := regexp_replace(
      v_definition,
      E'(?in)^[[:space:]]*begin[[:space:]]*$',
      E'begin\n  perform core.require_admin_target_organization(p_organization_id, p_user_id);'
    );
    if v_replacement = v_definition then
      raise exception 'Admin function entry point not found: %', v_signature;
    end if;
    execute v_replacement;
  end loop;
end;
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

drop trigger if exists validate_study_group_scope on core.study_groups;
create trigger validate_study_group_scope
before insert or update of organization_id, owner_id, name, emoji, description, join_code
on core.study_groups
for each row execute function core.validate_study_group_scope();

revoke all on function core.validate_study_group_scope() from public, anon, authenticated;

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

drop trigger if exists validate_study_group_member_scope on core.study_group_members;
create trigger validate_study_group_member_scope
before insert or update of group_id, user_id, role
on core.study_group_members
for each row execute function core.validate_study_group_member_scope();

revoke all on function core.validate_study_group_member_scope() from public, anon, authenticated;

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

drop trigger if exists validate_study_group_invite_scope on core.study_group_invites;
create trigger validate_study_group_invite_scope
before insert or update of group_id, target_user_id, created_by, kind
on core.study_group_invites
for each row execute function core.validate_study_group_invite_scope();

revoke all on function core.validate_study_group_invite_scope() from public, anon, authenticated;

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
  if v_user_id is null or not exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;

  perform pg_advisory_xact_lock(hashtextextended(v_user_id::text, 583216));
  if core.current_study_group_id() is not null then
    raise exception 'Already a member of a group';
  end if;
  select study_group.id into v_group_id
  from core.study_groups study_group
  where study_group.organization_id = p_organization_id
    and upper(study_group.join_code) = upper(btrim(coalesce(p_code, '')))
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

revoke all on function app_api_v1.join_group_by_code(text, text)
from public, anon;
grant execute on function app_api_v1.join_group_by_code(text, text)
to authenticated, service_role;

do $$
declare
  v_definition text;
  v_replacement text;
begin
  v_definition := pg_get_functiondef(
    'app_api_v1.request_to_join_group(uuid)'::regprocedure
  );
  if position('p_group_id uuid' in v_definition) = 0
    or position('core.study_group_invites' in v_definition) = 0 then
    raise exception 'Unexpected join request function definition';
  end if;
  v_replacement := regexp_replace(
    v_definition,
    E'(?in)^[[:space:]]*begin[[:space:]]*$',
    E'begin\n  if not core.study_group_in_current_organization(p_group_id) then\n    raise exception ''User does not belong to this organization'' using errcode = ''42501'';\n  end if;'
  );
  if v_replacement = v_definition then
    raise exception 'Join request function entry point not found';
  end if;
  execute v_replacement;
end;
$$;
