-- Команды по макету: тип (хакатон/проект/учёба), дедлайн, буст за шурикены,
-- отклики «Откликнуться» + универсальные пуши (app-push) для откликов и
-- запросов менторам.

-- ── teams: kind / deadline / boost ───────────────────────────────────────────

alter table core.teams
  add column if not exists kind text not null default 'hackathon',
  add column if not exists deadline_at timestamptz,
  add column if not exists boosted_until timestamptz;

do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conrelid = 'core.teams'::regclass
      and conname = 'teams_kind_valid'
  ) then
    alter table core.teams add constraint teams_kind_valid
      check (kind in ('hackathon', 'project', 'study'));
  end if;
end;
$$;

-- ── team applications ────────────────────────────────────────────────────────

create table if not exists core.team_applications (
  id uuid primary key default extensions.gen_random_uuid(),
  team_id uuid not null references core.teams(id) on delete cascade,
  applicant_id uuid not null references auth.users(id) on delete cascade,
  role text not null default '',
  message text not null default '',
  attach_profile boolean not null default true,
  created_at timestamptz not null default now(),
  unique (team_id, applicant_id)
);

create index if not exists team_applications_team_idx
on core.team_applications (team_id, created_at desc);

create index if not exists team_applications_applicant_idx
on core.team_applications (applicant_id);

alter table core.team_applications enable row level security;

drop policy if exists "owner and applicant read applications"
on core.team_applications;
create policy "owner and applicant read applications"
on core.team_applications for select to authenticated
using (
  (select auth.uid()) = applicant_id
  or exists (
    select 1 from core.teams t
    where t.id = team_id and t.owner_id = (select auth.uid())
  )
);

drop policy if exists "users apply themselves" on core.team_applications;
create policy "users apply themselves"
on core.team_applications for insert to authenticated
with check ((select auth.uid()) = applicant_id);

drop policy if exists "owner and applicant delete applications"
on core.team_applications;
create policy "owner and applicant delete applications"
on core.team_applications for delete to authenticated
using (
  (select auth.uid()) = applicant_id
  or exists (
    select 1 from core.teams t
    where t.id = team_id and t.owner_id = (select auth.uid())
  )
);

grant select, insert, delete on core.team_applications to authenticated;
grant all on core.team_applications to service_role;

-- ── generic push helper ──────────────────────────────────────────────────────

create or replace function internal.notify_app_push(
  p_recipient uuid,
  p_title text,
  p_body text,
  p_route text default '',
  p_type text default 'app_event'
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_url text;
  v_secret text;
begin
  select value into v_url
  from internal.app_config where key = 'app_push_url';
  select value into v_secret
  from internal.app_config where key = 'app_push_secret';
  if v_url is null or v_secret is null then
    return; -- push delivery not configured yet
  end if;

  perform net.http_post(
    url := v_url,
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'x-push-secret', v_secret
    ),
    body := jsonb_build_object(
      'recipient_id', p_recipient,
      'title', p_title,
      'body', p_body,
      'route', p_route,
      'type', p_type
    )
  );
end;
$$;

-- ── push triggers: mentor requests + team applications ──────────────────────

create or replace function internal.notify_mentor_request()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_name text;
begin
  select split_part(full_name, ' ', 1) into v_name
  from core.user_academic_profiles where user_id = new.requester_id;
  perform internal.notify_app_push(
    new.mentor_user_id,
    'Запрос на менторство 🥷',
    coalesce(v_name, 'Студент')
      || case when new.topic <> '' then ' · ' || new.topic else '' end,
    '/services/mentorship',
    'mentor_request'
  );
  return new;
end;
$$;

drop trigger if exists mentor_requests_push_on_insert on core.mentor_requests;
create trigger mentor_requests_push_on_insert
after insert on core.mentor_requests
for each row execute function internal.notify_mentor_request();

create or replace function internal.notify_team_application()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_owner uuid;
  v_team text;
  v_name text;
begin
  select owner_id, title into v_owner, v_team
  from core.teams where id = new.team_id;
  select split_part(full_name, ' ', 1) into v_name
  from core.user_academic_profiles where user_id = new.applicant_id;
  perform internal.notify_app_push(
    v_owner,
    'Отклик в команду 🤝',
    coalesce(v_name, 'Студент')
      || case when new.role <> '' then ' · ' || new.role else '' end
      || ' → «' || coalesce(v_team, 'команда') || '»',
    '/services/team-finder',
    'team_application'
  );
  return new;
end;
$$;

drop trigger if exists team_applications_push_on_insert
on core.team_applications;
create trigger team_applications_push_on_insert
after insert on core.team_applications
for each row execute function internal.notify_team_application();

-- ── RPCs ─────────────────────────────────────────────────────────────────────

create or replace function app_api_v1.get_teams(p_organization_id text)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', t.id,
        'title', t.title,
        'eventName', t.event_name,
        'description', t.description,
        'neededRoles', to_jsonb(t.needed_roles),
        'capacity', t.capacity,
        'kind', t.kind,
        'deadlineAt', t.deadline_at,
        'isBoosted', t.boosted_until is not null
          and t.boosted_until > now(),
        'createdAt', t.created_at,
        'isMine', t.owner_id = (select auth.uid()),
        'isMember', exists (
          select 1 from core.team_members tm
          where tm.team_id = t.id
            and tm.user_id = (select auth.uid())
        ),
        'hasApplied', exists (
          select 1 from core.team_applications ta
          where ta.team_id = t.id
            and ta.applicant_id = (select auth.uid())
        ),
        'applicationsCount', case
          when t.owner_id = (select auth.uid()) then (
            select count(*) from core.team_applications ta
            where ta.team_id = t.id
          )
          else 0
        end,
        'memberCount', (
          select count(*) + 1 from core.team_members tm
          where tm.team_id = t.id
        ),
        'memberNames', (
          select coalesce(jsonb_agg(n.first_name), '[]'::jsonb)
          from (
            select split_part(p.full_name, ' ', 1) as first_name
            from core.user_academic_profiles p
            where p.user_id = t.owner_id
            union all
            select split_part(p.full_name, ' ', 1)
            from core.team_members tm
            join core.user_academic_profiles p on p.user_id = tm.user_id
            where tm.team_id = t.id
            limit 4
          ) n
        )
      )
      order by
        (t.boosted_until is not null and t.boosted_until > now()) desc,
        t.created_at desc
    ),
    '[]'::jsonb
  )
  from core.teams t
  where t.organization_id = p_organization_id;
$$;

drop function if exists public.create_team(
  text, text, text, text, text[], integer
);
drop function if exists app_api_v1.create_team(
  text, text, text, text, text[], integer
);

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
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_id uuid;
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;
  insert into core.teams (
    organization_id, owner_id, title, event_name, description,
    needed_roles, capacity, kind, deadline_at, boosted_until
  )
  values (
    p_organization_id, v_user_id, p_title, coalesce(p_event_name, ''),
    coalesce(p_description, ''), coalesce(p_needed_roles, '{}'),
    least(greatest(coalesce(p_capacity, 5), 2), 20),
    coalesce(p_kind, 'hackathon'), p_deadline_at,
    case when p_boost then now() + interval '1 day' end
  )
  returning id into v_id;

  if p_boost then
    perform core.apply_shuriken_delta(
      v_user_id, '🚀', 'Буст команды «' || p_title || '»', -50
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
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_id uuid;
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;
  insert into core.team_applications (
    team_id, applicant_id, role, message, attach_profile
  )
  values (
    p_team_id, v_user_id, coalesce(p_role, ''), coalesce(p_message, ''),
    coalesce(p_attach_profile, true)
  )
  on conflict (team_id, applicant_id) do update
    set role = excluded.role,
        message = excluded.message,
        attach_profile = excluded.attach_profile
  returning id into v_id;
  return v_id;
end;
$$;

create or replace function app_api_v1.get_team_applications(
  p_team_id uuid
)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', a.id,
        'role', a.role,
        'message', a.message,
        'createdAt', a.created_at,
        'applicantName', coalesce(
          (select split_part(p.full_name, ' ', 1) || ' '
              || left(split_part(p.full_name, ' ', 2), 1) || '.'
           from core.user_academic_profiles p
           where p.user_id = a.applicant_id),
          'студент'
        ),
        'applicantHandle', (
          select p.handle from core.user_academic_profiles p
          where p.user_id = a.applicant_id
        ),
        'applicantGroup', case when a.attach_profile then (
          select p.academic_group from core.user_academic_profiles p
          where p.user_id = a.applicant_id
        ) end
      )
      order by a.created_at desc
    ),
    '[]'::jsonb
  )
  from core.team_applications a
  where a.team_id = p_team_id
    and exists (
      select 1 from core.teams t
      where t.id = p_team_id and t.owner_id = (select auth.uid())
    );
$$;

create or replace function app_api_v1.delete_team_application(p_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$
  delete from core.team_applications where id = p_id;
$$;

-- ── public wrappers ──────────────────────────────────────────────────────────

create or replace function public.create_team(
  p_organization_id text, p_title text, p_event_name text default '',
  p_description text default '', p_needed_roles text[] default '{}',
  p_capacity integer default 5, p_kind text default 'hackathon',
  p_deadline_at timestamptz default null, p_boost boolean default false
)
returns uuid language sql security invoker set search_path = ''
as $$
  select app_api_v1.create_team(
    p_organization_id, p_title, p_event_name, p_description,
    p_needed_roles, p_capacity, p_kind, p_deadline_at, p_boost
  );
$$;

create or replace function public.apply_to_team(
  p_team_id uuid, p_role text default '', p_message text default '',
  p_attach_profile boolean default true
)
returns uuid language sql security invoker set search_path = ''
as $$
  select app_api_v1.apply_to_team(
    p_team_id, p_role, p_message, p_attach_profile
  );
$$;

create or replace function public.get_team_applications(p_team_id uuid)
returns jsonb language sql stable security definer set search_path = ''
as $$ select app_api_v1.get_team_applications(p_team_id); $$;

create or replace function public.delete_team_application(p_id uuid)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.delete_team_application(p_id); $$;

revoke all on function public.create_team(
  text, text, text, text, text[], integer, text, timestamptz, boolean
) from public, anon;
revoke all on function public.apply_to_team(uuid, text, text, boolean)
  from public, anon;
revoke all on function public.get_team_applications(uuid)
  from public, anon;
revoke all on function public.delete_team_application(uuid)
  from public, anon;

grant execute on function public.create_team(
  text, text, text, text, text[], integer, text, timestamptz, boolean
) to authenticated;
grant execute on function public.apply_to_team(uuid, text, text, boolean)
  to authenticated;
grant execute on function public.get_team_applications(uuid)
  to authenticated;
grant execute on function public.delete_team_application(uuid)
  to authenticated;
