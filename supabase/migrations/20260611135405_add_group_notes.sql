-- Совместные конспекты группы: документ, который может редактировать
-- любой одногруппник; presence и live-обновления идут через Realtime
-- broadcast-каналы, контент персистится здесь.

create or replace function core.current_academic_group()
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select profile.academic_group
  from core.user_academic_profiles profile
  where profile.user_id = (select auth.uid())
  limit 1;
$$;

revoke all on function core.current_academic_group() from public, anon;
grant execute on function core.current_academic_group() to authenticated;

create table core.group_notes (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id)
    on delete cascade,
  academic_group text not null,
  title text not null,
  content text not null default '',
  created_by uuid not null references auth.users(id) on delete cascade,
  updated_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint group_notes_title_not_empty check (length(trim(title)) > 0),
  constraint group_notes_content_max check (length(content) <= 100000)
);

create index group_notes_group_idx
on core.group_notes (academic_group, updated_at desc);

create index group_notes_updated_by_idx on core.group_notes (updated_by);

alter table core.group_notes enable row level security;

create policy "group notes readable by groupmates"
on core.group_notes for select to authenticated
using (academic_group = core.current_academic_group());

create policy "groupmates create notes"
on core.group_notes for insert to authenticated
with check (
  (select auth.uid()) = created_by
  and academic_group = core.current_academic_group()
);

create policy "groupmates edit notes"
on core.group_notes for update to authenticated
using (academic_group = core.current_academic_group())
with check (academic_group = core.current_academic_group());

create policy "creators delete own notes"
on core.group_notes for delete to authenticated
using ((select auth.uid()) = created_by);

grant select, insert, update, delete on core.group_notes to authenticated;
grant all on core.group_notes to service_role;

create or replace function app_api_v1.get_group_notes(
  p_organization_id text
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
        'id', n.id,
        'title', n.title,
        'content', n.content,
        'createdAt', n.created_at,
        'updatedAt', n.updated_at,
        'isMine', n.created_by = (select auth.uid()),
        'updatedByName', coalesce(
          (select split_part(p.full_name, ' ', 1)
           from core.user_academic_profiles p
           where p.user_id = n.updated_by),
          ''
        )
      )
      order by n.updated_at desc
    ),
    '[]'::jsonb
  )
  from core.group_notes n
  where n.academic_group = core.current_academic_group()
    and n.organization_id = p_organization_id;
$$;

create or replace function app_api_v1.create_group_note(
  p_organization_id text,
  p_title text
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group text := core.current_academic_group();
  v_id uuid;
begin
  if v_user_id is null or v_group is null then
    raise exception 'Unauthorized or no academic group';
  end if;
  insert into core.group_notes (
    organization_id, academic_group, title, created_by, updated_by
  )
  values (p_organization_id, v_group, p_title, v_user_id, v_user_id)
  returning id into v_id;
  return v_id;
end;
$$;

create or replace function app_api_v1.save_group_note(
  p_id uuid,
  p_title text,
  p_content text
)
returns void
language sql
security invoker
set search_path = ''
as $$
  update core.group_notes
  set title = p_title,
      content = p_content,
      updated_by = (select auth.uid()),
      updated_at = now()
  where id = p_id;
$$;

create or replace function app_api_v1.delete_group_note(p_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$
  delete from core.group_notes
  where id = p_id and created_by = (select auth.uid());
$$;

create or replace function public.get_group_notes(p_organization_id text)
returns jsonb language sql stable security definer set search_path = ''
as $$ select app_api_v1.get_group_notes(p_organization_id); $$;

create or replace function public.create_group_note(
  p_organization_id text, p_title text
)
returns uuid language sql security invoker set search_path = ''
as $$ select app_api_v1.create_group_note(p_organization_id, p_title); $$;

create or replace function public.save_group_note(
  p_id uuid, p_title text, p_content text
)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.save_group_note(p_id, p_title, p_content); $$;

create or replace function public.delete_group_note(p_id uuid)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.delete_group_note(p_id); $$;

revoke all on function public.get_group_notes(text) from public, anon;
revoke all on function public.create_group_note(text, text)
  from public, anon;
revoke all on function public.save_group_note(uuid, text, text)
  from public, anon;
revoke all on function public.delete_group_note(uuid) from public, anon;

grant execute on function public.get_group_notes(text) to authenticated;
grant execute on function public.create_group_note(text, text)
  to authenticated;
grant execute on function public.save_group_note(uuid, text, text)
  to authenticated;
grant execute on function public.delete_group_note(uuid) to authenticated;
