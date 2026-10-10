create table user_private.account_personas (
  user_id uuid not null references auth.users(id) on delete cascade,
  organization_id text not null references core.organizations(id) on delete cascade,
  role text not null default 'student',
  teacher_target_id uuid references core.schedule_targets(id) on delete set null,
  teacher_external_id text,
  teacher_name text,
  revision bigint not null default 1,
  updated_at timestamptz not null default now(),
  primary key (user_id, organization_id),
  constraint account_personas_role_valid check (role in ('student', 'teacher')),
  constraint account_personas_revision_valid check (revision > 0),
  constraint account_personas_teacher_snapshot_valid check (
    (teacher_external_id is null and teacher_name is null and teacher_target_id is null)
    or (nullif(btrim(teacher_external_id), '') is not null
      and nullif(btrim(teacher_name), '') is not null)
  )
);

alter table user_private.account_personas enable row level security;

create policy "users read their organization account persona"
on user_private.account_personas for select to authenticated
using (
  user_id = (select auth.uid())
  and exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = (select auth.uid())
      and profile.organization_id = account_personas.organization_id
  )
);

revoke all on user_private.account_personas from public, anon, authenticated;
grant select on user_private.account_personas to authenticated;
grant all on user_private.account_personas to service_role;

create or replace function app_api_v1.get_account_persona(
  p_organization_id text,
  p_expected_user_id uuid
)
returns jsonb
language plpgsql
stable
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_result jsonb;
begin
  if v_user_id is null or p_expected_user_id is distinct from v_user_id then
    raise exception 'Account access denied' using errcode = '42501';
  end if;
  if not exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'Organization access denied' using errcode = '42501';
  end if;

  select jsonb_build_object(
    'role', persona.role,
    'teacherId', coalesce(target.external_id, persona.teacher_external_id),
    'teacherName', coalesce(target.full_title, persona.teacher_name),
    'teacherAvailable', coalesce(target.is_active, false),
    'revision', persona.revision
  ) into v_result
  from user_private.account_personas persona
  left join core.schedule_targets target
    on target.id = persona.teacher_target_id
      and target.organization_id = persona.organization_id
      and target.target_type = 'teacher'
  where persona.user_id = v_user_id
    and persona.organization_id = p_organization_id;

  return coalesce(v_result, jsonb_build_object(
    'role', 'student', 'teacherId', null, 'teacherName', null,
    'teacherAvailable', false, 'revision', 0
  ));
end;
$$;

create or replace function user_private.set_account_persona(
  p_organization_id text,
  p_expected_user_id uuid,
  p_role text,
  p_teacher_id text,
  p_expected_revision bigint
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_persona user_private.account_personas%rowtype;
  v_teacher_id text := nullif(btrim(p_teacher_id), '');
  v_target_id uuid;
  v_teacher_name text;
begin
  if v_user_id is null or p_expected_user_id is distinct from v_user_id then
    raise exception 'Account access denied' using errcode = '42501';
  end if;
  if p_role is null or p_role not in ('student', 'teacher')
    or p_expected_revision is null or p_expected_revision < 0
    or (p_teacher_id is not null and v_teacher_id is null) then
    raise exception 'Invalid account persona' using errcode = '22023';
  end if;

  perform 1 from core.user_academic_profiles profile
  where profile.user_id = v_user_id
    and profile.organization_id = p_organization_id
  for update;
  if not found then
    raise exception 'Organization access denied' using errcode = '42501';
  end if;

  select * into v_persona
  from user_private.account_personas persona
  where persona.user_id = v_user_id
    and persona.organization_id = p_organization_id
  for update;
  if coalesce(v_persona.revision, 0) <> p_expected_revision then
    raise exception 'Account persona changed' using errcode = 'PT409';
  end if;

  if v_teacher_id is not null then
    select target.id, target.full_title into v_target_id, v_teacher_name
    from core.schedule_targets target
    where target.organization_id = p_organization_id
      and target.target_type = 'teacher'
      and target.external_id = v_teacher_id
      and target.is_active;
    if not found then
      if p_role = 'student'
        and v_teacher_id = v_persona.teacher_external_id then
        v_target_id := v_persona.teacher_target_id;
        v_teacher_name := v_persona.teacher_name;
      else
        raise exception 'Teacher is unavailable' using errcode = '22023';
      end if;
    end if;
  end if;

  perform core.enforce_rate_limit('set_account_persona', 30, interval '1 hour');
  insert into user_private.account_personas (
    user_id, organization_id, role, teacher_target_id,
    teacher_external_id, teacher_name, revision
  ) values (
    v_user_id, p_organization_id, p_role, v_target_id,
    v_teacher_id, v_teacher_name, p_expected_revision + 1
  )
  on conflict (user_id, organization_id) do update set
    role = excluded.role,
    teacher_target_id = excluded.teacher_target_id,
    teacher_external_id = excluded.teacher_external_id,
    teacher_name = excluded.teacher_name,
    revision = excluded.revision,
    updated_at = now();

  return app_api_v1.get_account_persona(p_organization_id, p_expected_user_id);
end;
$$;

create or replace function app_api_v1.set_account_persona(
  p_organization_id text,
  p_expected_user_id uuid,
  p_role text,
  p_teacher_id text,
  p_expected_revision bigint
)
returns jsonb
language sql
security invoker
set search_path = ''
as $$
  select user_private.set_account_persona(
    p_organization_id, p_expected_user_id, p_role, p_teacher_id,
    p_expected_revision
  );
$$;

create or replace function public.get_account_persona(
  p_organization_id text,
  p_expected_user_id uuid
)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select app_api_v1.get_account_persona(p_organization_id, p_expected_user_id);
$$;

create or replace function public.set_account_persona(
  p_organization_id text,
  p_expected_user_id uuid,
  p_role text,
  p_teacher_id text,
  p_expected_revision bigint
)
returns jsonb
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.set_account_persona(
    p_organization_id, p_expected_user_id, p_role, p_teacher_id,
    p_expected_revision
  );
$$;

revoke all on function user_private.set_account_persona(text, uuid, text, text, bigint)
from public, anon, authenticated, service_role;
revoke all on function app_api_v1.get_account_persona(text, uuid)
from public, anon, authenticated, service_role;
revoke all on function app_api_v1.set_account_persona(text, uuid, text, text, bigint)
from public, anon, authenticated, service_role;
revoke all on function public.get_account_persona(text, uuid)
from public, anon, authenticated, service_role;
revoke all on function public.set_account_persona(text, uuid, text, text, bigint)
from public, anon, authenticated, service_role;

grant execute on function user_private.set_account_persona(text, uuid, text, text, bigint)
to authenticated, service_role;
grant execute on function app_api_v1.get_account_persona(text, uuid)
to authenticated, service_role;
grant execute on function app_api_v1.set_account_persona(text, uuid, text, text, bigint)
to authenticated, service_role;
grant execute on function public.get_account_persona(text, uuid)
to authenticated, service_role;
grant execute on function public.set_account_persona(text, uuid, text, text, bigint)
to authenticated, service_role;
