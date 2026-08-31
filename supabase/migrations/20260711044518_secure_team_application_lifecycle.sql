alter table core.teams
  add column if not exists status text not null default 'open',
  add column if not exists updated_at timestamptz not null default now();

alter table core.teams drop constraint if exists teams_status_valid;
alter table core.teams add constraint teams_status_valid check (
  status in ('open', 'closed', 'completed', 'archived')
);

alter table core.team_applications
  add column if not exists status text not null default 'pending',
  add column if not exists responded_at timestamptz,
  add column if not exists updated_at timestamptz not null default now();

alter table core.team_applications
  drop constraint if exists team_applications_status_valid;
alter table core.team_applications
  add constraint team_applications_status_valid check (
    status in ('pending', 'accepted', 'rejected', 'withdrawn')
  );

delete from core.team_members member
using core.teams team
where member.team_id = team.id and member.user_id = team.owner_id;

delete from core.team_members member
using core.teams team
where member.team_id = team.id
  and not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = member.user_id
      and profile.organization_id = team.organization_id
  );

update core.team_applications application
set status = 'withdrawn', updated_at = clock_timestamp()
from core.teams team
where application.team_id = team.id
  and application.status = 'pending'
  and not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = application.applicant_id
      and profile.organization_id = team.organization_id
  );

update core.teams team
set status = 'archived', updated_at = clock_timestamp()
where not exists (
  select 1
  from core.user_academic_profiles profile
  where profile.user_id = team.owner_id
    and profile.organization_id = team.organization_id
);

update core.team_applications application
set status = 'withdrawn', updated_at = clock_timestamp()
from core.teams team
where application.team_id = team.id
  and application.status = 'pending'
  and team.status = 'archived';

create index if not exists teams_open_organization_idx
on core.teams (organization_id, created_at desc)
where status = 'open';

create index if not exists team_applications_pending_team_idx
on core.team_applications (team_id, created_at desc)
where status = 'pending';

create or replace function internal.guard_team_member_insert()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_team core.teams%rowtype;
  v_member_count integer;
begin
  select team.* into v_team
  from core.teams team
  where team.id = new.team_id
  for update;
  if not found
    or v_team.status <> 'open'
    or (v_team.deadline_at is not null and v_team.deadline_at < now())
    or new.user_id = v_team.owner_id
    or not exists (
      select 1 from core.user_academic_profiles profile
      where profile.user_id = new.user_id
        and profile.organization_id = v_team.organization_id
    )
  then
    raise exception 'Team membership is unavailable' using errcode = '42501';
  end if;
  delete from core.team_members member
  where member.team_id = new.team_id
    and not exists (
      select 1
      from core.user_academic_profiles profile
      where profile.user_id = member.user_id
        and profile.organization_id = v_team.organization_id
    );
  select count(*) + 1 into v_member_count
  from core.team_members member
  where member.team_id = new.team_id;
  if v_member_count >= v_team.capacity then
    raise exception 'Team is full' using errcode = '22023';
  end if;
  return new;
end;
$$;

drop trigger if exists guard_team_member_insert on core.team_members;
create trigger guard_team_member_insert
before insert on core.team_members
for each row execute function internal.guard_team_member_insert();

create or replace function app_api_v1.get_teams(p_organization_id text)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null or not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'Teams are unavailable' using errcode = '42501';
  end if;
  return (
    select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', team.id,
        'title', team.title,
        'eventName', team.event_name,
        'description', team.description,
        'neededRoles', to_jsonb(team.needed_roles),
        'capacity', team.capacity,
        'kind', team.kind,
        'deadlineAt', team.deadline_at,
        'isBoosted', team.boosted_until is not null
          and team.boosted_until > now(),
        'createdAt', team.created_at,
        'status', team.status,
        'isMine', team.owner_id = (select auth.uid()),
        'isMember', exists (
          select 1 from core.team_members member
          where member.team_id = team.id
            and member.user_id = (select auth.uid())
        ),
        'hasApplied', exists (
          select 1 from core.team_applications application
          where application.team_id = team.id
            and application.applicant_id = (select auth.uid())
            and application.status = 'pending'
        ),
        'myApplicationId', (
          select application.id
          from core.team_applications application
          where application.team_id = team.id
            and application.applicant_id = (select auth.uid())
            and application.status = 'pending'
        ),
        'applicationsCount', case
          when team.owner_id = (select auth.uid()) then (
            select count(*) from core.team_applications application
            where application.team_id = team.id
              and application.status = 'pending'
          ) else 0
        end,
        'memberCount', 1 + (
          select count(*)
          from core.team_members member
          join core.user_academic_profiles profile
            on profile.user_id = member.user_id
            and profile.organization_id = team.organization_id
          where member.team_id = team.id
        ),
        'memberNames', (
          select coalesce(jsonb_agg(names.first_name), '[]'::jsonb)
          from (
            select split_part(owner.full_name, ' ', 1) as first_name
            from core.user_academic_profiles owner
            where owner.user_id = team.owner_id
              and owner.organization_id = team.organization_id
            union all
            select split_part(profile.full_name, ' ', 1)
            from core.team_members member
            join core.user_academic_profiles profile
              on profile.user_id = member.user_id
              and profile.organization_id = team.organization_id
            where member.team_id = team.id
            limit 4
          ) names
        )
      )
      order by
        (team.boosted_until is not null and team.boosted_until > now()) desc,
        team.created_at desc
    ),
    '[]'::jsonb
  )
  from core.teams team
  join core.user_academic_profiles owner
    on owner.user_id = team.owner_id
    and owner.organization_id = team.organization_id
  where team.organization_id = p_organization_id
    and team.status = 'open'
  );
end;
$$;

create or replace function app_api_v1.create_team(
  p_organization_id text,
  p_title text,
  p_event_name text default '',
  p_description text default '',
  p_needed_roles text[] default '{}',
  p_capacity integer default 5,
  p_kind text default 'hackathon',
  p_deadline_at timestamptz default null,
  p_boost boolean default false
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_id uuid;
  v_roles text[] := array(
    select distinct btrim(value)
    from unnest(coalesce(p_needed_roles, '{}')) value
    where btrim(value) <> ''
  );
begin
  if v_user_id is null or not exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;
  if cardinality(v_roles) > 20
    or exists (
      select 1 from unnest(v_roles) value
      where char_length(value) > 60
    )
    or p_capacity not between 2 and 20
    or char_length(btrim(coalesce(p_kind, ''))) not between 1 and 60
    or p_deadline_at < now()
    or p_deadline_at > now() + interval '2 years'
  then
    raise exception 'Invalid team options' using errcode = '22023';
  end if;
  perform core.enforce_rate_limit('create_team', 10, interval '1 hour');
  insert into core.teams (
    organization_id,
    owner_id,
    title,
    event_name,
    description,
    needed_roles,
    capacity,
    kind,
    deadline_at,
    boosted_until
  ) values (
    p_organization_id,
    v_user_id,
    core.validate_text(p_title, 'Title', 160, true),
    core.validate_text(p_event_name, 'Event name', 160, false),
    core.validate_text(p_description, 'Description', 4000, false),
    v_roles,
    p_capacity,
    btrim(p_kind),
    p_deadline_at,
    case when p_boost then now() + interval '1 day' end
  ) returning id into v_id;
  if p_boost then
    perform core.apply_organization_shuriken_delta(
      v_user_id,
      p_organization_id,
      '🚀',
      'Team boost',
      -50
    );
  end if;
  return v_id;
end;
$$;

create or replace function app_api_v1.apply_to_team(
  p_team_id uuid,
  p_role text default '',
  p_message text default '',
  p_attach_profile boolean default true
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_team core.teams%rowtype;
  v_id uuid;
  v_member_count integer;
  v_role text := btrim(coalesce(p_role, ''));
begin
  select team.* into v_team
  from core.teams team
  where team.id = p_team_id
  for update;
  if v_user_id is null
    or not found
    or v_team.status <> 'open'
    or v_team.owner_id = v_user_id
    or (v_team.deadline_at is not null and v_team.deadline_at < now())
    or not exists (
      select 1 from core.user_academic_profiles profile
      where profile.user_id = v_user_id
        and profile.organization_id = v_team.organization_id
    )
    or exists (
      select 1 from core.team_members member
      where member.team_id = p_team_id and member.user_id = v_user_id
    )
  then
    raise exception 'Team application is unavailable' using errcode = '42501';
  end if;
  delete from core.team_members member
  where member.team_id = p_team_id
    and not exists (
      select 1
      from core.user_academic_profiles profile
      where profile.user_id = member.user_id
        and profile.organization_id = v_team.organization_id
    );
  select count(*) + 1 into v_member_count
  from core.team_members member where member.team_id = p_team_id;
  if v_member_count >= v_team.capacity then
    raise exception 'Team is full' using errcode = '22023';
  end if;
  if cardinality(v_team.needed_roles) > 0
    and not (v_role = any(v_team.needed_roles))
  then
    raise exception 'Unsupported team role' using errcode = '22023';
  end if;
  perform core.enforce_rate_limit('apply_to_team', 20, interval '1 hour');
  insert into core.team_applications (
    team_id,
    applicant_id,
    role,
    message,
    attach_profile,
    status,
    responded_at,
    updated_at
  ) values (
    p_team_id,
    v_user_id,
    core.validate_text(v_role, 'Role', 60, false),
    core.validate_text(p_message, 'Message', 2000, false),
    coalesce(p_attach_profile, true),
    'pending',
    null,
    clock_timestamp()
  )
  on conflict (team_id, applicant_id) do update set
    role = excluded.role,
    message = excluded.message,
    attach_profile = excluded.attach_profile,
    status = 'pending',
    responded_at = null,
    updated_at = clock_timestamp()
  where team_applications.status in ('rejected', 'withdrawn')
  returning id into v_id;
  if v_id is null then
    raise exception 'A pending team application already exists'
      using errcode = '23505';
  end if;
  return v_id;
end;
$$;

create or replace function app_api_v1.get_team_applications(p_team_id uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null or not exists (
    select 1 from core.teams team
    join core.user_academic_profiles owner
      on owner.user_id = team.owner_id
      and owner.organization_id = team.organization_id
    where team.id = p_team_id and team.owner_id = v_user_id
  ) then
    raise exception 'Team applications are unavailable' using errcode = '42501';
  end if;
  return coalesce(
    (
      select jsonb_agg(
        jsonb_build_object(
          'id', application.id,
          'teamId', application.team_id,
          'applicantId', application.applicant_id,
          'role', application.role,
          'message', application.message,
          'createdAt', application.created_at,
          'status', application.status,
          'attachProfile', application.attach_profile,
          'applicantName', coalesce(profile.full_name, 'Student'),
          'applicantHandle', case
            when application.attach_profile then profile.handle
          end,
          'applicantGroup', case
            when application.attach_profile then profile.academic_group
          end
        ) order by application.created_at desc
      )
      from core.team_applications application
      join core.teams team on team.id = application.team_id
      join core.user_academic_profiles profile
        on profile.user_id = application.applicant_id
        and profile.organization_id = team.organization_id
      where application.team_id = p_team_id
        and application.status = 'pending'
    ),
    '[]'::jsonb
  );
end;
$$;

create or replace function app_api_v1.act_on_team_application(
  p_id uuid,
  p_action text
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_application core.team_applications%rowtype;
  v_team core.teams%rowtype;
  v_member_count integer;
begin
  select application.* into v_application
  from core.team_applications application
  where application.id = p_id
  for update;
  if not found or v_application.status <> 'pending' then
    raise exception 'Team application is unavailable' using errcode = '22023';
  end if;
  select team.* into v_team
  from core.teams team
  where team.id = v_application.team_id
  for update;

  if p_action = 'withdraw' then
    if v_user_id <> v_application.applicant_id then
      raise exception 'Application cannot be withdrawn' using errcode = '42501';
    end if;
    update core.team_applications
    set status = 'withdrawn', responded_at = clock_timestamp(),
        updated_at = clock_timestamp()
    where id = p_id;
    return;
  end if;

  if v_user_id <> v_team.owner_id
    or p_action not in ('accept', 'reject')
    or not exists (
      select 1
      from core.user_academic_profiles owner
      where owner.user_id = v_team.owner_id
        and owner.organization_id = v_team.organization_id
    )
  then
    raise exception 'Application cannot be resolved' using errcode = '42501';
  end if;
  if p_action = 'reject' then
    update core.team_applications
    set status = 'rejected', responded_at = clock_timestamp(),
        updated_at = clock_timestamp()
    where id = p_id;
    return;
  end if;

  if v_team.status <> 'open'
    or (v_team.deadline_at is not null and v_team.deadline_at < now())
    or v_application.applicant_id = v_team.owner_id
    or not exists (
      select 1 from core.user_academic_profiles profile
      where profile.user_id = v_application.applicant_id
        and profile.organization_id = v_team.organization_id
    )
  then
    raise exception 'Applicant cannot join this team' using errcode = '42501';
  end if;
  delete from core.team_members member
  where member.team_id = v_team.id
    and not exists (
      select 1
      from core.user_academic_profiles profile
      where profile.user_id = member.user_id
        and profile.organization_id = v_team.organization_id
    );
  select count(*) + 1 into v_member_count
  from core.team_members member where member.team_id = v_team.id;
  if v_member_count >= v_team.capacity then
    raise exception 'Team is full' using errcode = '22023';
  end if;
  insert into core.team_members (team_id, user_id)
  values (v_team.id, v_application.applicant_id);
  update core.team_applications
  set status = 'accepted', responded_at = clock_timestamp(),
      updated_at = clock_timestamp()
  where id = p_id;
end;
$$;

create or replace function app_api_v1.leave_team(p_team_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  delete from core.team_members member
  using core.teams team
  where member.team_id = p_team_id
    and member.user_id = v_user_id
    and team.id = member.team_id
    and team.owner_id <> v_user_id;
  if not found then
    raise exception 'Team membership is unavailable' using errcode = '42501';
  end if;
  update core.team_applications application
  set status = 'withdrawn', responded_at = clock_timestamp(),
      updated_at = clock_timestamp()
  where application.team_id = p_team_id
    and application.applicant_id = v_user_id
    and application.status = 'accepted';
end;
$$;

create or replace function app_api_v1.delete_team(p_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  delete from core.teams team
  where team.id = p_id
    and team.owner_id = v_user_id
    and exists (
      select 1
      from core.user_academic_profiles owner
      where owner.user_id = team.owner_id
        and owner.organization_id = team.organization_id
    );
  if not found then
    raise exception 'Team is unavailable' using errcode = '42501';
  end if;
end;
$$;

create or replace function app_api_v1.set_team_membership(
  p_team_id uuid,
  p_join boolean
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if not p_join then
    perform app_api_v1.leave_team(p_team_id);
    return;
  end if;
  if exists (
    select 1 from core.team_members member
    where member.team_id = p_team_id and member.user_id = v_user_id
  ) then
    return;
  end if;
  raise exception 'Membership requires the application lifecycle'
    using errcode = '42501';
end;
$$;

create or replace function app_api_v1.delete_team_application(p_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_owner_id uuid;
  v_applicant_id uuid;
begin
  select team.owner_id, application.applicant_id
  into v_owner_id, v_applicant_id
  from core.team_applications application
  join core.teams team on team.id = application.team_id
  where application.id = p_id;
  if v_user_id = v_owner_id then
    perform app_api_v1.act_on_team_application(p_id, 'reject');
  elsif v_user_id = v_applicant_id then
    perform app_api_v1.act_on_team_application(p_id, 'withdraw');
  else
    raise exception 'Team application is unavailable' using errcode = '42501';
  end if;
end;
$$;

create or replace function internal.notify_team_application_result()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_team_title text;
begin
  if old.status = new.status or new.status not in ('accepted', 'rejected') then
    return new;
  end if;
  select team.title into v_team_title
  from core.teams team
  where team.id = new.team_id;
  perform internal.notify_app_push(
    new.applicant_id,
    case new.status
      when 'accepted' then 'Вас приняли в команду 🤝'
      else 'Ответ по отклику'
    end,
    case new.status
      when 'accepted' then 'Теперь вы в команде «' || v_team_title || '»'
      else 'Ваш отклик в команду «' || v_team_title || '» отклонён'
    end,
    '/services/team-finder',
    'team_application_result'
  );
  return new;
end;
$$;

drop trigger if exists team_application_result_push
on core.team_applications;
create trigger team_application_result_push
after update of status on core.team_applications
for each row execute function internal.notify_team_application_result();

create or replace function internal.reconcile_team_organization_change()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if old.organization_id = new.organization_id then
    return new;
  end if;
  update core.team_applications application
  set status = 'withdrawn', updated_at = clock_timestamp()
  from core.teams team
  where application.team_id = team.id
    and team.owner_id = new.user_id
    and team.organization_id = old.organization_id
    and application.status = 'pending';
  update core.teams team
  set status = 'archived', updated_at = clock_timestamp()
  where team.owner_id = new.user_id
    and team.organization_id = old.organization_id
    and team.status = 'open';
  delete from core.team_members member
  using core.teams team
  where member.team_id = team.id
    and member.user_id = new.user_id
    and team.organization_id = old.organization_id;
  return new;
end;
$$;

drop trigger if exists reconcile_team_organization_change
on core.user_academic_profiles;
create trigger reconcile_team_organization_change
after update of organization_id on core.user_academic_profiles
for each row execute function internal.reconcile_team_organization_change();

create or replace function public.act_on_team_application(
  p_id uuid,
  p_action text
)
returns void language sql security definer set search_path = ''
as $$ select app_api_v1.act_on_team_application(p_id, p_action); $$;

create or replace function public.create_team(
  p_organization_id text,
  p_title text,
  p_event_name text default '',
  p_description text default '',
  p_needed_roles text[] default '{}',
  p_capacity integer default 5,
  p_kind text default 'hackathon',
  p_deadline_at timestamptz default null,
  p_boost boolean default false
)
returns uuid language sql security definer set search_path = ''
as $$
  select app_api_v1.create_team(
    p_organization_id,
    p_title,
    p_event_name,
    p_description,
    p_needed_roles,
    p_capacity,
    p_kind,
    p_deadline_at,
    p_boost
  );
$$;

create or replace function public.apply_to_team(
  p_team_id uuid,
  p_role text default '',
  p_message text default '',
  p_attach_profile boolean default true
)
returns uuid language sql security definer set search_path = ''
as $$
  select app_api_v1.apply_to_team(
    p_team_id,
    p_role,
    p_message,
    p_attach_profile
  );
$$;

create or replace function public.set_team_membership(
  p_team_id uuid,
  p_join boolean
)
returns void language sql security definer set search_path = ''
as $$ select app_api_v1.set_team_membership(p_team_id, p_join); $$;

create or replace function public.delete_team_application(p_id uuid)
returns void language sql security definer set search_path = ''
as $$ select app_api_v1.delete_team_application(p_id); $$;

create or replace function public.leave_team(p_team_id uuid)
returns void language sql security definer set search_path = ''
as $$ select app_api_v1.leave_team(p_team_id); $$;

create or replace function public.delete_team(p_id uuid)
returns void language sql security definer set search_path = ''
as $$ select app_api_v1.delete_team(p_id); $$;

create or replace function public.get_team_applications(p_team_id uuid)
returns jsonb language sql stable security definer set search_path = ''
as $$ select app_api_v1.get_team_applications(p_team_id); $$;

revoke insert, update, delete on core.teams from authenticated;
revoke insert, delete on core.team_members from authenticated;
revoke insert, update, delete on core.team_applications from authenticated;

revoke all on function app_api_v1.get_teams(text)
  from public, anon, authenticated;
revoke all on function app_api_v1.create_team(
  text, text, text, text, text[], integer, text, timestamptz, boolean
) from public, anon, authenticated;
revoke all on function app_api_v1.apply_to_team(uuid, text, text, boolean)
  from public, anon, authenticated;
revoke all on function app_api_v1.get_team_applications(uuid)
  from public, anon, authenticated;
revoke all on function app_api_v1.act_on_team_application(uuid, text)
  from public, anon, authenticated;
revoke all on function app_api_v1.leave_team(uuid)
  from public, anon, authenticated;
revoke all on function app_api_v1.delete_team(uuid)
  from public, anon, authenticated;
revoke all on function app_api_v1.set_team_membership(uuid, boolean)
  from public, anon, authenticated;
revoke all on function app_api_v1.delete_team_application(uuid)
  from public, anon, authenticated;

grant execute on function app_api_v1.get_teams(text) to service_role;
grant execute on function app_api_v1.create_team(
  text, text, text, text, text[], integer, text, timestamptz, boolean
) to service_role;
grant execute on function app_api_v1.apply_to_team(uuid, text, text, boolean)
  to service_role;
grant execute on function app_api_v1.get_team_applications(uuid)
  to service_role;
grant execute on function app_api_v1.act_on_team_application(uuid, text)
  to service_role;
grant execute on function app_api_v1.leave_team(uuid) to service_role;
grant execute on function app_api_v1.delete_team(uuid) to service_role;
grant execute on function app_api_v1.set_team_membership(uuid, boolean)
  to service_role;
grant execute on function app_api_v1.delete_team_application(uuid)
  to service_role;

revoke all on function public.act_on_team_application(uuid, text)
  from public, anon;
grant execute on function public.act_on_team_application(uuid, text)
  to authenticated, service_role;
revoke all on function public.leave_team(uuid) from public, anon;
grant execute on function public.leave_team(uuid)
  to authenticated, service_role;
revoke all on function public.delete_team(uuid) from public, anon;
grant execute on function public.delete_team(uuid)
  to authenticated, service_role;
revoke all on function public.get_team_applications(uuid) from public, anon;
grant execute on function public.get_team_applications(uuid)
  to authenticated, service_role;
