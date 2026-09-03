alter table core.user_deadlines
  add column if not exists remind_minutes integer not null default 60;

do $$
begin
  alter table core.user_deadlines
    add constraint user_deadlines_remind_minutes_valid
    check (remind_minutes > 0);
exception
  when duplicate_object then null;
end $$;

alter table core.scheduled_reminders
  add column if not exists deadline_id uuid
  references core.user_deadlines(id) on delete cascade;

create index if not exists scheduled_reminders_deadline_idx
on core.scheduled_reminders (deadline_id)
where deadline_id is not null;

create or replace function core.reschedule_deadline_reminder(
  p_deadline_id uuid,
  p_user_id uuid,
  p_title text,
  p_due_at timestamptz,
  p_remind boolean,
  p_remind_minutes integer
)
returns void
language plpgsql
set search_path = ''
as $function$
declare
  v_lead integer := coalesce(p_remind_minutes, 60);
  v_fire_at timestamptz := p_due_at - (v_lead || ' minutes')::interval;
begin
  delete from core.scheduled_reminders
  where deadline_id = p_deadline_id and fire_at > now();

  if p_remind and v_fire_at > now() then
    insert into core.scheduled_reminders (
      user_id, fire_at, title, body, route, deadline_id
    )
    values (
      p_user_id,
      v_fire_at,
      '⏰ Дедлайн: ' || p_title,
      case
        when v_lead >= 1440 then 'остался день'
        when v_lead >= 60 then 'остался час'
        else 'скоро дедлайн'
      end,
      '/services/deadlines',
      p_deadline_id
    );
  end if;
end;
$function$;

revoke all on function core.reschedule_deadline_reminder(
  uuid, uuid, text, timestamptz, boolean, integer
) from public, anon;
grant execute on function core.reschedule_deadline_reminder(
  uuid, uuid, text, timestamptz, boolean, integer
) to authenticated;

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
        'remindMinutes', deadline.remind_minutes,
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

create or replace function public.get_deadlines(p_organization_id text)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select app_api_v1.get_deadlines(p_organization_id);
$$;

drop function if exists app_api_v1.create_deadline(
  text, text, text, timestamptz, text, text, boolean
);
drop function if exists public.create_deadline(
  text, text, text, timestamptz, text, text, boolean
);

create or replace function app_api_v1.create_deadline(
  p_organization_id text,
  p_title text,
  p_subject_name text,
  p_due_at timestamptz,
  p_source text default 'me'::text,
  p_priority text default 'medium'::text,
  p_remind boolean default true,
  p_remind_minutes integer default 60
)
returns uuid
language plpgsql
set search_path = ''
as $function$
declare
  v_user_id uuid := (select auth.uid());
  v_id uuid;
  v_title text;
  v_source text := coalesce(p_source, 'me');
  v_priority text := coalesce(p_priority, 'medium');
  v_remind_minutes integer := coalesce(p_remind_minutes, 60);
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
  if v_remind_minutes <= 0 then
    raise exception 'Reminder lead time must be positive';
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
    remind,
    remind_minutes
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
    coalesce(p_remind, true),
    v_remind_minutes
  )
  returning id into v_id;

  if coalesce(p_remind, true) then
    insert into core.scheduled_reminders (
      user_id, fire_at, title, body, route, deadline_id
    )
    select
      v_user_id,
      p_due_at - (v_remind_minutes || ' minutes')::interval,
      '⏰ Дедлайн: ' || v_title,
      case
        when v_remind_minutes >= 1440 then 'остался день'
        when v_remind_minutes >= 60 then 'остался час'
        else 'скоро дедлайн'
      end,
      '/services/deadlines',
      v_id
    where p_due_at - (v_remind_minutes || ' minutes')::interval > now();
  end if;

  return v_id;
end;
$function$;

create or replace function public.create_deadline(
  p_organization_id text,
  p_title text,
  p_subject_name text,
  p_due_at timestamptz,
  p_source text default 'me',
  p_priority text default 'medium',
  p_remind boolean default true,
  p_remind_minutes integer default 60
)
returns uuid
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.create_deadline(
    p_organization_id, p_title, p_subject_name, p_due_at, p_source,
    p_priority, p_remind, p_remind_minutes
  );
$$;

revoke all on function public.create_deadline(
  text, text, text, timestamptz, text, text, boolean, integer
)
  from public, anon;
grant execute on function
  public.create_deadline(
    text, text, text, timestamptz, text, text, boolean, integer
  ) to authenticated;

create or replace function app_api_v1.update_deadline(
  p_id uuid,
  p_title text default null,
  p_subject_name text default null,
  p_due_at timestamptz default null,
  p_priority text default null,
  p_progress integer default null,
  p_remind boolean default null,
  p_remind_minutes integer default null
)
returns void
language plpgsql
set search_path = ''
as $function$
declare
  v_user_id uuid := (select auth.uid());
  v_row core.user_deadlines;
  v_title text;
  v_subject text;
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;

  select * into v_row
  from core.user_deadlines
  where id = p_id and user_id = v_user_id
  for update;

  if not found then
    raise exception 'Deadline not found';
  end if;

  if p_priority is not null and p_priority not in ('low', 'medium', 'urgent')
  then
    raise exception 'Unsupported deadline priority';
  end if;
  if p_due_at is not null and p_due_at <= now() then
    raise exception 'Deadline must be in the future';
  end if;
  if p_progress is not null and (p_progress < 0 or p_progress > 100) then
    raise exception 'Progress must be between 0 and 100';
  end if;
  if p_remind_minutes is not null and p_remind_minutes <= 0 then
    raise exception 'Reminder lead time must be positive';
  end if;

  perform core.enforce_rate_limit('update_deadline', 120, interval '1 hour');

  v_title := case
    when p_title is not null
      then core.validate_text(p_title, 'Название', 200, true)
    else v_row.title
  end;
  v_subject := case
    when p_subject_name is not null
      then core.validate_text(p_subject_name, 'Предмет', 300, false)
    else v_row.subject_name
  end;

  update core.user_deadlines
  set
    title = v_title,
    subject_name = v_subject,
    due_at = coalesce(p_due_at, due_at),
    priority = coalesce(p_priority, priority),
    progress = coalesce(p_progress, progress),
    remind = coalesce(p_remind, remind),
    remind_minutes = coalesce(p_remind_minutes, remind_minutes)
  where id = p_id and user_id = v_user_id
  returning * into v_row;

  perform core.reschedule_deadline_reminder(
    v_row.id, v_row.user_id, v_row.title, v_row.due_at,
    v_row.remind, v_row.remind_minutes
  );
end;
$function$;

create or replace function public.update_deadline(
  p_id uuid,
  p_title text default null,
  p_subject_name text default null,
  p_due_at timestamptz default null,
  p_priority text default null,
  p_progress integer default null,
  p_remind boolean default null,
  p_remind_minutes integer default null
)
returns void
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.update_deadline(
    p_id, p_title, p_subject_name, p_due_at, p_priority, p_progress,
    p_remind, p_remind_minutes
  );
$$;

revoke all on function public.update_deadline(
  uuid, text, text, timestamptz, text, integer, boolean, integer
)
  from public, anon;
grant execute on function
  public.update_deadline(
    uuid, text, text, timestamptz, text, integer, boolean, integer
  ) to authenticated;

create or replace function app_api_v1.postpone_deadlines(
  p_ids uuid[],
  p_until timestamptz
)
returns integer
language plpgsql
set search_path = ''
as $function$
declare
  v_user_id uuid := (select auth.uid());
  v_row core.user_deadlines;
  v_count integer := 0;
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;
  if p_until is null or p_until <= now() then
    raise exception 'Postponed date must be in the future';
  end if;
  if p_ids is null or array_length(p_ids, 1) is null then
    return 0;
  end if;

  perform core.enforce_rate_limit(
    'postpone_deadlines', 60, interval '1 hour'
  );

  for v_row in
    update core.user_deadlines
    set due_at = p_until
    where id = any(p_ids)
      and user_id = v_user_id
      and done_at is null
    returning *
  loop
    v_count := v_count + 1;
    perform core.reschedule_deadline_reminder(
      v_row.id, v_row.user_id, v_row.title, v_row.due_at,
      v_row.remind, v_row.remind_minutes
    );
  end loop;

  return v_count;
end;
$function$;

create or replace function public.postpone_deadlines(
  p_ids uuid[],
  p_until timestamptz
)
returns integer
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.postpone_deadlines(p_ids, p_until);
$$;

revoke all on function public.postpone_deadlines(uuid[], timestamptz)
  from public, anon;
grant execute on function public.postpone_deadlines(uuid[], timestamptz)
  to authenticated;
