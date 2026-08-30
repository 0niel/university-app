create or replace function core.current_academic_group(
  p_organization_id text
)
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select profile.academic_group
  from core.user_academic_profiles profile
  where profile.user_id = (select auth.uid())
    and profile.organization_id = p_organization_id
  limit 1;
$$;

revoke all on function core.current_academic_group(text)
  from public, anon;
grant execute on function core.current_academic_group(text)
  to authenticated;

drop policy if exists "own or group deadlines are readable"
  on core.user_deadlines;
create policy "own or group deadlines are readable"
on core.user_deadlines
for select
to authenticated
using (
  (select auth.uid()) = user_id
  or (
    source in ('group', 'prof')
    and academic_group is not null
    and academic_group = core.current_academic_group(organization_id)
  )
);

create or replace function app_api_v1.get_deadlines(
  p_organization_id text
)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', deadline.id,
        'title', deadline.title,
        'subjectName', deadline.subject_name,
        'dueAt', deadline.due_at,
        'source', deadline.source,
        'priority', deadline.priority,
        'remind', deadline.remind,
        'progress', deadline.progress,
        'isDone', deadline.done_at is not null,
        'isMine', deadline.user_id = (select auth.uid())
      )
      order by deadline.done_at nulls first, deadline.due_at
    ),
    '[]'::jsonb
  )
  from core.user_deadlines deadline
  where deadline.organization_id = p_organization_id
    and (
      deadline.user_id = (select auth.uid())
      or (
        deadline.source in ('group', 'prof')
        and deadline.academic_group =
          core.current_academic_group(p_organization_id)
      )
    );
$$;

create or replace function app_api_v1.create_deadline(
  p_organization_id text,
  p_title text,
  p_subject_name text,
  p_due_at timestamptz,
  p_source text default 'me'::text,
  p_priority text default 'medium'::text,
  p_remind boolean default true
)
returns uuid
language plpgsql
set search_path to ''
as $function$
declare
  v_user_id uuid := (select auth.uid());
  v_id uuid;
  v_title text;
  v_source text := coalesce(p_source, 'me');
  v_priority text := coalesce(p_priority, 'medium');
  v_academic_group text;
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;
  if v_source not in ('me', 'group') then
    raise exception 'Unsupported client deadline source';
  end if;
  if v_priority not in ('low', 'medium', 'urgent') then
    raise exception 'Unsupported deadline priority';
  end if;
  if p_due_at is null or p_due_at <= now() then
    raise exception 'Deadline must be in the future';
  end if;

  if v_source = 'group' then
    select profile.academic_group
    into v_academic_group
    from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id;

    if v_academic_group is null then
      raise exception 'Academic group is required for a shared deadline';
    end if;
  end if;

  perform core.enforce_rate_limit('create_deadline', 60, interval '1 hour');
  v_title := core.validate_text(p_title, 'Название', 200, true);

  insert into core.user_deadlines (
    user_id,
    organization_id,
    title,
    subject_name,
    due_at,
    source,
    academic_group,
    priority,
    remind
  )
  values (
    v_user_id,
    p_organization_id,
    v_title,
    core.validate_text(p_subject_name, 'Предмет', 300, false),
    p_due_at,
    v_source,
    v_academic_group,
    v_priority,
    coalesce(p_remind, true)
  )
  returning id into v_id;

  if coalesce(p_remind, true) then
    insert into core.scheduled_reminders (user_id, fire_at, title, body, route)
    select
      v_user_id,
      reminder.fire_at,
      '⏰ Дедлайн: ' || v_title,
      case
        when reminder.fire_at = p_due_at - interval '1 day'
          then 'остался день'
        else 'осталось 2 часа'
      end,
      '/services/deadlines'
    from unnest(
      array[
        p_due_at - interval '1 day',
        p_due_at - interval '2 hours'
      ]
    ) as reminder(fire_at)
    where reminder.fire_at > now();
  end if;

  return v_id;
end;
$function$;
