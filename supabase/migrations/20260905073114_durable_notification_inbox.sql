create table core.notification_inbox (
  id uuid primary key default extensions.gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  organization_id text references core.organizations(id) on delete cascade,
  title text not null,
  body text not null default '',
  route text not null default '',
  kind text not null default 'app_event',
  created_at timestamptz not null default now(),
  read_at timestamptz
);

create index notification_inbox_user_created_idx
on core.notification_inbox (user_id, created_at desc, id desc);

alter table core.notification_inbox enable row level security;

create policy notification_inbox_owner_read
on core.notification_inbox for select to authenticated
using (
  user_id = (select auth.uid())
  and (
    organization_id is null
    or organization_id = (
      select profile.organization_id
      from core.user_academic_profiles profile
      where profile.user_id = (select auth.uid())
    )
  )
);

revoke all on core.notification_inbox from public, anon, authenticated;
grant all on core.notification_inbox to service_role;

create or replace function internal.record_notification(
  p_recipient uuid,
  p_title text,
  p_body text,
  p_route text default '',
  p_kind text default 'app_event',
  p_id uuid default extensions.gen_random_uuid(),
  p_created_at timestamptz default now()
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into core.notification_inbox (
    id, user_id, organization_id, title, body, route, kind, created_at
  )
  select p_id, recipient.id, profile.organization_id,
    coalesce(p_title, ''), coalesce(p_body, ''), coalesce(p_route, ''),
    coalesce(p_kind, 'app_event'), p_created_at
  from auth.users recipient
  left join core.user_academic_profiles profile on profile.user_id = recipient.id
  where recipient.id = p_recipient
  on conflict (id) do nothing
  returning id into p_id;
  return p_id;
end;
$$;

revoke all on function internal.record_notification(uuid, text, text, text, text, uuid, timestamptz)
from public, anon, authenticated;
grant execute on function internal.record_notification(uuid, text, text, text, text, uuid, timestamptz)
to service_role;

create or replace function public.get_notification_inbox()
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(jsonb_agg(jsonb_build_object(
    'id', inbox.id,
    'title', inbox.title,
    'body', inbox.body,
    'route', inbox.route,
    'kind', inbox.kind,
    'createdAt', inbox.created_at,
    'readAt', inbox.read_at
  ) order by inbox.created_at desc, inbox.id desc), '[]'::jsonb)
  from (
    select notification.*
    from core.notification_inbox notification
    where notification.user_id = (select auth.uid())
      and (
        notification.organization_id is null
        or notification.organization_id = (
          select profile.organization_id
          from core.user_academic_profiles profile
          where profile.user_id = (select auth.uid())
        )
      )
    order by notification.created_at desc, notification.id desc
    limit 100
  ) inbox;
$$;

create or replace function public.mark_notification_inbox_read(p_ids uuid[])
returns void
language sql
security definer
set search_path = ''
as $$
  update core.notification_inbox notification
  set read_at = now()
  where notification.user_id = (select auth.uid())
    and notification.id = any(p_ids)
    and notification.read_at is null
    and (
      notification.organization_id is null
      or notification.organization_id = (
        select profile.organization_id
        from core.user_academic_profiles profile
        where profile.user_id = (select auth.uid())
      )
    );
$$;

revoke all on function public.get_notification_inbox() from public, anon;
revoke all on function public.mark_notification_inbox_read(uuid[]) from public, anon;
grant execute on function public.get_notification_inbox() to authenticated, service_role;
grant execute on function public.mark_notification_inbox_read(uuid[]) to authenticated, service_role;

create or replace function internal.deliver_inbox_push(p_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_url text;
  v_secret text;
  v_notification core.notification_inbox%rowtype;
begin
  select * into v_notification from core.notification_inbox where id = p_id;
  if not found then
    return;
  end if;
  select value into v_url from internal.app_config where key = 'app_push_url';
  select value into v_secret from internal.app_config where key = 'app_push_secret';
  if v_url is null or v_secret is null then
    return;
  end if;
  begin
    perform net.http_post(
      url := v_url,
      headers := jsonb_build_object(
        'Content-Type', 'application/json', 'x-push-secret', v_secret
      ),
      body := jsonb_build_object(
        'recipient_id', v_notification.user_id, 'title', v_notification.title, 'body', v_notification.body,
        'route', v_notification.route, 'type', v_notification.kind,
        'notification_id', v_notification.id
      )
    );
  exception when others then
    null;
  end;
end;
$$;

revoke all on function internal.deliver_inbox_push(uuid) from public, anon, authenticated;

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
begin
  perform internal.deliver_inbox_push(internal.record_notification(
    p_recipient, p_title, p_body, p_route, p_type
  ));
end;
$$;

create or replace function internal.notify_app_event_once(
  p_recipient uuid,
  p_title text,
  p_body text,
  p_route text,
  p_kind text,
  p_event_key text,
  p_created_at timestamptz default now(),
  p_push boolean default true
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_id uuid := md5(p_event_key || ':' || p_recipient::text)::uuid;
begin
  v_id := internal.record_notification(p_recipient, p_title, p_body, p_route, p_kind, v_id, p_created_at);
  if v_id is null then
    return;
  end if;
  if p_push and internal.should_notify(p_recipient, p_kind) then
    perform internal.deliver_inbox_push(v_id);
  end if;
end;
$$;

revoke all on function internal.notify_app_event_once(uuid,text,text,text,text,text,timestamptz,boolean)
from public, anon, authenticated;

revoke all on function internal.notify_app_push(uuid, text, text, text, text)
from public, anon, authenticated;
grant execute on function internal.notify_app_push(uuid, text, text, text, text)
to service_role;

create or replace function internal.notify_app_push_gated(
  p_recipient uuid,
  p_kind text,
  p_title text,
  p_body text,
  p_route text default ''
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not internal.should_notify(p_recipient, p_kind) then
    perform internal.record_notification(p_recipient, p_title, p_body, p_route, p_kind);
    return;
  end if;
  perform internal.notify_app_push(p_recipient, p_title, p_body, p_route, p_kind);
end;
$$;

revoke all on function internal.notify_app_push_gated(uuid, text, text, text, text)
from public, anon, authenticated;

create or replace function internal.notify_friend_event()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_url text;
  v_secret text;
  v_event text;
  v_recipient uuid;
  v_actor uuid;
  v_name text;
  v_title text;
  v_body text;
  v_notification_id uuid;
begin
  if tg_op = 'INSERT' and new.status = 'pending' then
    v_event := 'friend_request';
    v_recipient := new.addressee_id;
    v_actor := new.requester_id;
    v_title := 'Новая заявка в друзья 🥷';
  elsif tg_op = 'UPDATE' and new.status = 'accepted' and old.status = 'pending' then
    v_event := 'friend_accepted';
    v_recipient := new.requester_id;
    v_actor := new.addressee_id;
    v_title := 'Заявка принята 🎉';
  else
    return new;
  end if;

  select coalesce(nullif(profile.full_name, ''), 'Кто-то') into v_name
  from core.user_academic_profiles profile where profile.user_id = v_actor;
  v_name := coalesce(v_name, 'Кто-то');
  v_body := v_name || case v_event
    when 'friend_request' then ' хочет добавить тебя'
    else ' теперь у тебя в друзьях'
  end;
  v_notification_id := internal.record_notification(
    v_recipient, v_title, v_body, '/services/people?tab=friends', v_event,
    md5(v_event || ':' || new.id::text)::uuid
  );
  if v_notification_id is null then
    return new;
  end if;

  select value into v_url from internal.app_config where key = 'friends_push_url';
  select value into v_secret from internal.app_config where key = 'friends_push_secret';
  if v_url is null or v_secret is null then
    return new;
  end if;
  begin
    perform net.http_post(
      url := v_url,
      headers := jsonb_build_object(
        'Content-Type', 'application/json', 'x-push-secret', v_secret
      ),
      body := jsonb_build_object(
        'event', v_event, 'friendship_id', new.id,
        'requester_id', new.requester_id, 'addressee_id', new.addressee_id,
        'notification_id', v_notification_id
      )
    );
  exception when others then
    null;
  end;
  return new;
end;
$$;

revoke all on function internal.notify_friend_event() from public, anon, authenticated;

insert into core.notification_inbox (
  id, user_id, organization_id, title, body, route, kind, created_at
)
select md5(event.kind || ':' || friendship.id::text)::uuid,
  case when event.kind = 'friend_request' then friendship.addressee_id else friendship.requester_id end,
  friendship.organization_id,
  case when event.kind = 'friend_request' then 'Новая заявка в друзья 🥷' else 'Заявка принята 🎉' end,
  coalesce(nullif(actor.full_name, ''), 'Кто-то') ||
    case when event.kind = 'friend_request' then ' хочет добавить тебя' else ' теперь у тебя в друзьях' end,
  '/services/people?tab=friends', event.kind,
  case when event.kind = 'friend_request' then friendship.created_at else friendship.updated_at end
from core.friendships friendship
cross join lateral (
  select case friendship.status when 'pending' then 'friend_request' else 'friend_accepted' end as kind
) event
join core.user_academic_profiles actor
  on actor.user_id = case when event.kind = 'friend_request' then friendship.requester_id else friendship.addressee_id end
  and actor.organization_id = friendship.organization_id
join core.user_academic_profiles recipient
  on recipient.user_id = case when event.kind = 'friend_request' then friendship.addressee_id else friendship.requester_id end
  and recipient.organization_id = friendship.organization_id
where (friendship.status = 'pending' and friendship.created_at >= now() - interval '30 days')
  or (friendship.status = 'accepted' and friendship.updated_at >= now() - interval '30 days')
on conflict (id) do nothing;

create or replace function internal.notify_study_group_event()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_group core.study_groups%rowtype;
  v_recipient uuid;
  v_actor uuid;
  v_name text;
  v_kind text;
  v_title text;
  v_body text;
begin
  select * into v_group from core.study_groups where id = new.group_id;
  if not found then
    return new;
  end if;

  if tg_op = 'INSERT' and new.status = 'pending' then
    if new.kind = 'invite' then
      v_recipient := new.target_user_id;
      v_actor := new.created_by;
      v_kind := 'study_group_invite';
      v_title := 'Приглашение в учебную группу';
    else
      v_recipient := v_group.owner_id;
      v_actor := new.target_user_id;
      v_kind := 'study_group_join_request';
      v_title := 'Заявка в учебную группу';
    end if;
  elsif tg_op = 'UPDATE' and old.status = 'pending'
    and new.status in ('accepted', 'declined') then
    if new.kind = 'invite' then
      v_recipient := v_group.owner_id;
      v_actor := new.target_user_id;
      v_kind := 'study_group_invite_result';
      v_title := case new.status when 'accepted' then 'Приглашение принято' else 'Приглашение отклонено' end;
    else
      v_recipient := new.target_user_id;
      v_actor := v_group.owner_id;
      v_kind := 'study_group_join_result';
      v_title := case new.status when 'accepted' then 'Вас приняли в учебную группу' else 'Ответ на заявку в группу' end;
    end if;
  else
    return new;
  end if;

  if v_recipient = v_actor or not exists (
    select 1 from core.user_academic_profiles recipient
    join core.user_academic_profiles actor on actor.user_id = v_actor
    where recipient.user_id = v_recipient
      and recipient.organization_id = v_group.organization_id
      and actor.organization_id = v_group.organization_id
  ) then
    return new;
  end if;

  select coalesce(nullif(full_name, ''), 'Студент') into v_name
  from core.user_academic_profiles where user_id = v_actor;
  v_body := case v_kind
    when 'study_group_invite' then v_name || ' приглашает вас в «' || v_group.name || '»'
    when 'study_group_join_request' then v_name || ' хочет вступить в «' || v_group.name || '»'
    when 'study_group_invite_result' then v_name || case new.status
      when 'accepted' then ' вступил(а) в «' else ' отклонил(а) приглашение в «' end || v_group.name || '»'
    else case new.status when 'accepted' then 'Вы теперь в группе «' else 'Ваша заявка в группу «' end || v_group.name || '»' ||
      case new.status when 'declined' then ' отклонена' else '' end
  end;
  perform internal.notify_app_event_once(
    v_recipient, v_title, v_body,
    case v_kind when 'study_group_join_request'
      then '/services/people?tab=group&manageGroup=1'
      else '/services/people?tab=group'
    end,
    v_kind, v_kind || ':' || new.id::text || ':' || new.status
  );
  return new;
end;
$$;

revoke all on function internal.notify_study_group_event() from public, anon, authenticated;

create trigger study_group_notifications_on_insert
after insert on core.study_group_invites
for each row execute function internal.notify_study_group_event();

create trigger study_group_notifications_on_status
after update of status on core.study_group_invites
for each row execute function internal.notify_study_group_event();

create or replace function internal.notify_team_application()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_team core.teams%rowtype;
  v_name text;
begin
  select * into v_team from core.teams where id = new.team_id;
  select split_part(full_name, ' ', 1) into v_name
  from core.user_academic_profiles where user_id = new.applicant_id;
  perform internal.notify_app_event_once(
    v_team.owner_id, 'Отклик в команду 🤝',
    coalesce(v_name, 'Студент') || case when new.role <> '' then ' · ' || new.role else '' end ||
      ' → «' || coalesce(v_team.title, 'команда') || '»',
    '/services/team-finder', 'team_application', 'team_application:' || new.id::text
  );
  return new;
end;
$$;

revoke all on function internal.notify_team_application() from public, anon, authenticated;

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
  perform internal.notify_app_event_once(
    new.mentor_user_id, 'Запрос на менторство 🥷',
    coalesce(v_name, 'Студент') || case when new.topic <> '' then ' · ' || new.topic else '' end,
    '/services/mentorship', 'mentor_request', 'mentor_request:' || new.id::text
  );
  return new;
end;
$$;

revoke all on function internal.notify_mentor_request() from public, anon, authenticated;

create or replace function internal.notify_mentor_request_result()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_recipients uuid[];
  v_recipient uuid;
  v_title text;
  v_kind text := 'mentor_request_result';
begin
  if old.status = new.status or not exists (
    select 1 from core.user_academic_profiles mentor
    join core.user_academic_profiles requester on requester.user_id = new.requester_id
    where mentor.user_id = new.mentor_user_id
      and mentor.organization_id = new.organization_id
      and requester.organization_id = new.organization_id
  ) then
    return new;
  end if;

  if new.status in ('accepted', 'declined') then
    v_recipients := array[new.requester_id];
    v_title := case new.status when 'accepted' then 'Ментор принял ваш запрос' else 'Ментор отклонил запрос' end;
  elsif new.status = 'cancelled' and (select auth.uid()) in (new.mentor_user_id, new.requester_id) then
    v_recipients := array[case when (select auth.uid()) = new.mentor_user_id then new.requester_id else new.mentor_user_id end];
    v_title := 'Встреча с ментором отменена';
  elsif new.status = 'completion_pending' then
    if new.mentor_confirmed_at is not null and new.requester_confirmed_at is null then
      v_recipients := array[new.requester_id];
    elsif new.requester_confirmed_at is not null and new.mentor_confirmed_at is null then
      v_recipients := array[new.mentor_user_id];
    else
      return new;
    end if;
    v_kind := 'mentor_completion_request';
    v_title := 'Подтвердите завершение встречи';
  elsif new.status = 'completed' then
    v_recipients := array[new.mentor_user_id, new.requester_id];
    v_title := 'Встреча с ментором завершена';
  else
    return new;
  end if;

  foreach v_recipient in array v_recipients loop
    perform internal.notify_app_event_once(
      v_recipient, v_title, coalesce(nullif(new.topic, ''), 'Менторство'),
      '/services/mentorship', v_kind, v_kind || ':' || new.id::text || ':' || new.status
    );
  end loop;
  return new;
end;
$$;

revoke all on function internal.notify_mentor_request_result() from public, anon, authenticated;

create trigger mentor_request_result_notification
after update of status on core.mentor_requests
for each row execute function internal.notify_mentor_request_result();

do $$
declare
  v_event record;
begin
  for v_event in
    select
      case invite.kind when 'invite' then invite.target_user_id else study_group.owner_id end as recipient_id,
      case invite.kind when 'invite' then 'Приглашение в учебную группу' else 'Заявка в учебную группу' end as title,
      coalesce(nullif(actor.full_name, ''), 'Студент') ||
        case invite.kind when 'invite' then ' приглашает вас в «' else ' хочет вступить в «' end || study_group.name || '»' as body,
      case invite.kind when 'invite' then '/services/people?tab=group' else '/services/people?tab=group&manageGroup=1' end as route,
      case invite.kind when 'invite' then 'study_group_invite' else 'study_group_join_request' end as kind,
      case invite.kind when 'invite' then 'study_group_invite:' else 'study_group_join_request:' end || invite.id::text || ':pending' as event_key,
      invite.created_at
    from core.study_group_invites invite
    join core.study_groups study_group on study_group.id = invite.group_id
    join core.user_academic_profiles actor
      on actor.user_id = case invite.kind when 'invite' then invite.created_by else invite.target_user_id end
      and actor.organization_id = study_group.organization_id
    join core.user_academic_profiles recipient
      on recipient.user_id = case invite.kind when 'invite' then invite.target_user_id else study_group.owner_id end
      and recipient.organization_id = study_group.organization_id
    where invite.status = 'pending' and invite.created_at >= now() - interval '30 days'
      and actor.user_id <> recipient.user_id
    union all
    select team.owner_id, 'Отклик в команду 🤝',
      coalesce(split_part(actor.full_name, ' ', 1), 'Студент') ||
        case when application.role <> '' then ' · ' || application.role else '' end || ' → «' || team.title || '»',
      '/services/team-finder', 'team_application', 'team_application:' || application.id::text, application.created_at
    from core.team_applications application
    join core.teams team on team.id = application.team_id and team.status = 'open'
    join core.user_academic_profiles actor on actor.user_id = application.applicant_id and actor.organization_id = team.organization_id
    join core.user_academic_profiles recipient on recipient.user_id = team.owner_id and recipient.organization_id = team.organization_id
    where application.status = 'pending' and application.created_at >= now() - interval '30 days'
      and actor.user_id <> recipient.user_id
    union all
    select request.mentor_user_id, 'Запрос на менторство 🥷',
      coalesce(split_part(actor.full_name, ' ', 1), 'Студент') || case when request.topic <> '' then ' · ' || request.topic else '' end,
      '/services/mentorship', 'mentor_request', 'mentor_request:' || request.id::text, request.created_at
    from core.mentor_requests request
    join core.user_academic_profiles actor on actor.user_id = request.requester_id and actor.organization_id = request.organization_id
    join core.user_academic_profiles recipient on recipient.user_id = request.mentor_user_id and recipient.organization_id = request.organization_id
    where request.status = 'pending' and request.created_at >= now() - interval '30 days'
      and actor.user_id <> recipient.user_id
  loop
    perform internal.notify_app_event_once(
      v_event.recipient_id, v_event.title, v_event.body, v_event.route,
      v_event.kind, v_event.event_key, v_event.created_at, false
    );
  end loop;
end;
$$;
