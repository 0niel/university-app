-- User deadlines powering the Дедлайны page and the home-screen deadline
-- rings. Personal by default; "от группы" rows are visible to everyone in
-- the same academic group (created by старостой/одногруппниками).

create table core.user_deadlines (
  id uuid primary key default extensions.gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  organization_id text not null references core.organizations(id)
    on delete cascade,
  title text not null,
  subject_name text not null default '',
  due_at timestamptz not null,
  source text not null default 'me',
  academic_group text,
  priority text not null default 'medium',
  remind boolean not null default true,
  progress smallint not null default 0,
  done_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint user_deadlines_title_not_empty check (length(trim(title)) > 0),
  constraint user_deadlines_source_valid
    check (source in ('me', 'group', 'prof')),
  constraint user_deadlines_progress_valid
    check (progress between 0 and 100),
  constraint user_deadlines_group_required
    check (source = 'me' or academic_group is not null),
  constraint user_deadlines_priority_valid
    check (priority in ('low', 'medium', 'urgent'))
);

create index user_deadlines_user_idx on core.user_deadlines (user_id, due_at);
create index user_deadlines_group_idx
on core.user_deadlines (academic_group, due_at)
where academic_group is not null;

create trigger set_user_deadlines_updated_at
before update on core.user_deadlines
for each row execute function core.set_updated_at();

alter table core.user_deadlines enable row level security;

-- Helper: the caller's academic group (definer — profiles are owner-RLS'd).
create or replace function core.current_academic_group()
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select academic_group
  from core.user_academic_profiles
  where user_id = (select auth.uid())
  limit 1;
$$;

revoke all on function core.current_academic_group() from public, anon;
grant execute on function core.current_academic_group() to authenticated;

create policy "own or group deadlines are readable"
on core.user_deadlines
for select
to authenticated
using (
  (select auth.uid()) = user_id
  or (
    source in ('group', 'prof')
    and academic_group is not null
    and academic_group = core.current_academic_group()
  )
);

create policy "users insert own deadlines"
on core.user_deadlines
for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "users update own deadlines"
on core.user_deadlines
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "users delete own deadlines"
on core.user_deadlines
for delete
to authenticated
using ((select auth.uid()) = user_id);

grant select, insert, update, delete on core.user_deadlines to authenticated;
grant all on core.user_deadlines to service_role;

-- ── app_api_v1 ───────────────────────────────────────────────────────────────

create or replace function app_api_v1.get_deadlines(p_organization_id text)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', d.id,
        'title', d.title,
        'subjectName', d.subject_name,
        'dueAt', d.due_at,
        'source', d.source,
        'priority', d.priority,
        'remind', d.remind,
        'progress', d.progress,
        'isDone', d.done_at is not null,
        'isMine', d.user_id = (select auth.uid())
      )
      order by d.done_at nulls first, d.due_at
    ),
    '[]'::jsonb
  )
  from core.user_deadlines d
  where d.organization_id = p_organization_id
    and (
      d.user_id = (select auth.uid())
      or (
        d.source in ('group', 'prof')
        and d.academic_group = core.current_academic_group()
      )
    );
$$;

create or replace function app_api_v1.create_deadline(
  p_organization_id text,
  p_title text,
  p_subject_name text,
  p_due_at timestamptz,
  p_source text default 'me',
  p_priority text default 'medium',
  p_remind boolean default true
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

  insert into core.user_deadlines (
    user_id, organization_id, title, subject_name, due_at, source,
    academic_group, priority, remind
  )
  values (
    v_user_id, p_organization_id, p_title, coalesce(p_subject_name, ''),
    p_due_at, p_source,
    case
      when p_source in ('group', 'prof') then core.current_academic_group()
    end,
    coalesce(p_priority, 'medium'),
    coalesce(p_remind, true)
  )
  returning id into v_id;
  return v_id;
end;
$$;

create or replace function app_api_v1.set_deadline_state(
  p_id uuid,
  p_progress integer default null,
  p_done boolean default null
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
begin
  update core.user_deadlines
  set
    progress = coalesce(p_progress, progress),
    done_at = case
      when p_done is true then coalesce(done_at, now())
      when p_done is false then null
      else done_at
    end
  where id = p_id and user_id = (select auth.uid());
end;
$$;

create or replace function app_api_v1.delete_deadline(p_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$
  delete from core.user_deadlines
  where id = p_id and user_id = (select auth.uid());
$$;

-- ── public wrappers ──────────────────────────────────────────────────────────

create or replace function public.get_deadlines(p_organization_id text)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select app_api_v1.get_deadlines(p_organization_id);
$$;

create or replace function public.create_deadline(
  p_organization_id text,
  p_title text,
  p_subject_name text,
  p_due_at timestamptz,
  p_source text default 'me',
  p_priority text default 'medium',
  p_remind boolean default true
)
returns uuid
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.create_deadline(
    p_organization_id, p_title, p_subject_name, p_due_at, p_source,
    p_priority, p_remind
  );
$$;

create or replace function public.set_deadline_state(
  p_id uuid,
  p_progress integer default null,
  p_done boolean default null
)
returns void
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.set_deadline_state(p_id, p_progress, p_done);
$$;

create or replace function public.delete_deadline(p_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.delete_deadline(p_id);
$$;

revoke all on function public.get_deadlines(text) from public, anon;
revoke all on function public.create_deadline(
  text, text, text, timestamptz, text, text, boolean
)
  from public, anon;
revoke all on function public.set_deadline_state(uuid, integer, boolean)
  from public, anon;
revoke all on function public.delete_deadline(uuid) from public, anon;

grant execute on function public.get_deadlines(text) to authenticated;
grant execute on function
  public.create_deadline(
    text, text, text, timestamptz, text, text, boolean
  ) to authenticated;
grant execute on function public.set_deadline_state(uuid, integer, boolean)
  to authenticated;
grant execute on function public.delete_deadline(uuid) to authenticated;

-- ── group members (for the Люди hub) ─────────────────────────────────────────

create or replace function app_api_v1.get_group_members()
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'userId', p.user_id,
        'fullName', p.full_name,
        'handle', p.handle,
        'isMe', p.user_id = (select auth.uid()),
        'isFriend', f.id is not null,
        'friendshipStatus', f.status
      )
      order by p.full_name
    ),
    '[]'::jsonb
  )
  from core.user_academic_profiles p
  left join core.friendships f
    on least(f.requester_id, f.addressee_id)
         = least(p.user_id, (select auth.uid()))
   and greatest(f.requester_id, f.addressee_id)
         = greatest(p.user_id, (select auth.uid()))
  where p.academic_group is not null
    and p.academic_group = core.current_academic_group();
$$;

create or replace function public.get_group_members()
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select app_api_v1.get_group_members();
$$;

revoke all on function public.get_group_members() from public, anon;
grant execute on function public.get_group_members() to authenticated;
