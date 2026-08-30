-- Отложенные напоминания («Напомнить» у пары, «напомнить заранее» у
-- дедлайнов): строки в core.scheduled_reminders раз в минуту рассылает
-- pg_cron через app-push (FCM).

create table core.scheduled_reminders (
  id uuid primary key default extensions.gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  fire_at timestamptz not null,
  title text not null,
  body text not null default '',
  route text not null default '',
  created_at timestamptz not null default now(),
  constraint scheduled_reminders_title_not_empty
    check (length(trim(title)) > 0)
);

create index scheduled_reminders_fire_idx
on core.scheduled_reminders (fire_at);

create index scheduled_reminders_user_idx
on core.scheduled_reminders (user_id, fire_at);

alter table core.scheduled_reminders enable row level security;

create policy "users manage own reminders"
on core.scheduled_reminders for all to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

grant select, insert, delete on core.scheduled_reminders to authenticated;
grant all on core.scheduled_reminders to service_role;

create or replace function app_api_v1.create_reminder(
  p_fire_at timestamptz,
  p_title text,
  p_body text default '',
  p_route text default ''
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
  if p_fire_at <= now() then
    raise exception 'Reminder must be in the future';
  end if;
  insert into core.scheduled_reminders (user_id, fire_at, title, body, route)
  values (
    v_user_id, p_fire_at, p_title, coalesce(p_body, ''),
    coalesce(p_route, '')
  )
  returning id into v_id;
  return v_id;
end;
$$;

create or replace function public.create_reminder(
  p_fire_at timestamptz, p_title text, p_body text default '',
  p_route text default ''
)
returns uuid language sql security invoker set search_path = ''
as $$
  select app_api_v1.create_reminder(p_fire_at, p_title, p_body, p_route);
$$;

revoke all on function public.create_reminder(timestamptz, text, text, text)
  from public, anon;
grant execute on function
  public.create_reminder(timestamptz, text, text, text) to authenticated;

-- Дедлайны с «напомнить заранее»: при создании ставим напоминания
-- за день и за 2 часа.
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
    coalesce(p_priority, 'medium'), coalesce(p_remind, true)
  )
  returning id into v_id;

  if coalesce(p_remind, true) then
    insert into core.scheduled_reminders (
      user_id, fire_at, title, body, route
    )
    select v_user_id, t, '⏰ Дедлайн: ' || p_title,
      case
        when t = p_due_at - interval '1 day' then 'остался день'
        else 'осталось 2 часа'
      end,
      '/services/deadlines'
    from unnest(array[
      p_due_at - interval '1 day',
      p_due_at - interval '2 hours'
    ]) as t
    where t > now();
  end if;

  return v_id;
end;
$$;

-- Рассылка раз в минуту.
create or replace function internal.process_due_reminders()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  r record;
begin
  for r in
    delete from core.scheduled_reminders
    where fire_at <= now()
    returning user_id, title, body, route
  loop
    perform internal.notify_app_push(
      r.user_id, r.title, r.body, r.route, 'reminder'
    );
  end loop;
end;
$$;

select cron.schedule(
  'process-due-reminders',
  '* * * * *',
  $$select internal.process_due_reminders()$$
);
