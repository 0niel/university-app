create or replace function app_api_v1.create_listing(
  p_organization_id text, p_title text, p_price integer,
  p_category text default 'other'::text, p_emoji text default '📦'::text,
  p_description text default ''::text)
  returns uuid language plpgsql set search_path to ''
as $function$
declare v_user_id uuid := (select auth.uid()); v_id uuid;
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('create_listing', 15, interval '1 hour');
  insert into core.marketplace_listings (
    organization_id, seller_id, title, description, price, category, emoji)
  values (
    p_organization_id, v_user_id,
    core.validate_text(p_title, 'Название', 200, true),
    core.validate_text(p_description, 'Описание', 4000, false),
    least(greatest(coalesce(p_price, 0), 0), 100000000),
    core.validate_text(coalesce(p_category, 'other'), 'Категория', 40, false),
    left(coalesce(p_emoji, '📦'), 16))
  returning id into v_id;
  return v_id;
end;
$function$;

create or replace function app_api_v1.create_event(
  p_organization_id text, p_title text, p_starts_at timestamptz,
  p_place text default ''::text, p_emoji text default '🎉'::text,
  p_category text default 'other'::text, p_description text default ''::text)
  returns uuid language plpgsql set search_path to ''
as $function$
declare v_user_id uuid := (select auth.uid()); v_id uuid;
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('create_event', 10, interval '1 hour');
  insert into core.campus_events (
    organization_id, title, description, emoji, category, place,
    starts_at, created_by)
  values (
    p_organization_id, core.validate_text(p_title, 'Название', 200, true),
    core.validate_text(p_description, 'Описание', 4000, false),
    left(coalesce(p_emoji, '🎉'), 16),
    core.validate_text(coalesce(p_category, 'other'), 'Категория', 40, false),
    core.validate_text(p_place, 'Место', 200, false), p_starts_at, v_user_id)
  returning id into v_id;
  return v_id;
end;
$function$;

create or replace function app_api_v1.create_team(
  p_organization_id text, p_title text, p_event_name text default ''::text,
  p_description text default ''::text, p_needed_roles text[] default '{}'::text[],
  p_capacity integer default 5, p_kind text default 'hackathon'::text,
  p_deadline_at timestamptz default null, p_boost boolean default false)
  returns uuid language plpgsql set search_path to ''
as $function$
declare v_user_id uuid := (select auth.uid()); v_id uuid; v_title text;
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('create_team', 10, interval '1 hour');
  if array_length(p_needed_roles, 1) > 12
     or exists (select 1 from unnest(coalesce(p_needed_roles, '{}')) r
                where char_length(r) > 60) then
    raise exception 'Некорректный список ролей' using errcode = '22023';
  end if;
  v_title := core.validate_text(p_title, 'Название', 200, true);
  insert into core.teams (
    organization_id, owner_id, title, event_name, description,
    needed_roles, capacity, kind, deadline_at, boosted_until)
  values (
    p_organization_id, v_user_id, v_title,
    core.validate_text(p_event_name, 'Событие', 200, false),
    core.validate_text(p_description, 'Описание', 4000, false),
    coalesce(p_needed_roles, '{}'),
    least(greatest(coalesce(p_capacity, 5), 2), 20),
    core.validate_text(coalesce(p_kind, 'hackathon'), 'Тип', 40, false),
    p_deadline_at, case when p_boost then now() + interval '1 day' end)
  returning id into v_id;
  if p_boost then
    perform core.apply_shuriken_delta(
      v_user_id, '🚀', 'Буст команды «' || v_title || '»', -50);
  end if;
  return v_id;
end;
$function$;

create or replace function app_api_v1.apply_to_team(
  p_team_id uuid, p_role text default ''::text, p_message text default ''::text,
  p_attach_profile boolean default true)
  returns uuid language plpgsql set search_path to ''
as $function$
declare v_user_id uuid := (select auth.uid()); v_id uuid;
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('apply_to_team', 30, interval '1 hour');
  insert into core.team_applications (team_id, applicant_id, role, message, attach_profile)
  values (p_team_id, v_user_id,
          core.validate_text(p_role, 'Роль', 60, false),
          core.validate_text(p_message, 'Сообщение', 2000, false),
          coalesce(p_attach_profile, true))
  on conflict (team_id, applicant_id) do update
    set role = excluded.role, message = excluded.message,
        attach_profile = excluded.attach_profile
  returning id into v_id;
  return v_id;
end;
$function$;

create or replace function app_api_v1.create_mentor_request(
  p_organization_id text, p_mentor_user_id uuid, p_topic text default ''::text,
  p_when_slot text default 'week'::text, p_message text default ''::text)
  returns uuid language plpgsql set search_path to ''
as $function$
declare v_user_id uuid := (select auth.uid()); v_id uuid;
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('create_mentor_request', 20, interval '1 hour');
  insert into core.mentor_requests (
    organization_id, mentor_user_id, requester_id, topic, when_slot, message)
  values (
    p_organization_id, p_mentor_user_id, v_user_id,
    core.validate_text(p_topic, 'Тема', 200, false),
    core.validate_text(coalesce(p_when_slot, 'week'), 'Слот', 40, false),
    core.validate_text(p_message, 'Сообщение', 2000, false))
  returning id into v_id;
  return v_id;
end;
$function$;

-- upsert_mentor_profile: was SQL with no auth check. Add auth gate, rate
-- limit, length caps, and array bounds.
create or replace function app_api_v1.upsert_mentor_profile(
  p_organization_id text, p_topics text[], p_bio text default ''::text,
  p_level text default ''::text, p_formats text[] default '{}'::text[],
  p_price integer default 0)
  returns void language plpgsql set search_path to ''
as $function$
declare v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('upsert_mentor_profile', 20, interval '1 hour');
  if array_length(p_topics, 1) > 20 or array_length(p_formats, 1) > 10
     or exists (select 1 from unnest(coalesce(p_topics, '{}') || coalesce(p_formats, '{}')) x
                where char_length(x) > 60) then
    raise exception 'Некорректные теги' using errcode = '22023';
  end if;
  insert into core.mentor_profiles (
    user_id, organization_id, topics, bio, level, formats, price)
  values (
    v_user_id, p_organization_id, coalesce(p_topics, '{}'),
    core.validate_text(p_bio, 'О себе', 2000, false),
    core.validate_text(p_level, 'Уровень', 60, false),
    coalesce(p_formats, '{}'),
    least(greatest(coalesce(p_price, 0), 0), 1000000))
  on conflict (user_id) do update set
    topics = excluded.topics, bio = excluded.bio, level = excluded.level,
    formats = excluded.formats, price = excluded.price, is_active = true;
end;
$function$;

create or replace function app_api_v1.send_friend_request(p_user_id uuid)
  returns void language plpgsql set search_path to ''
as $function$
declare v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  if p_user_id = v_user_id then raise exception 'Cannot befriend yourself'; end if;
  perform core.enforce_rate_limit('send_friend_request', 30, interval '1 hour');
  insert into core.friendships (requester_id, addressee_id)
  values (v_user_id, p_user_id)
  on conflict (least(requester_id, addressee_id), greatest(requester_id, addressee_id))
  do nothing;
end;
$function$;

create or replace function app_api_v1.create_deadline(
  p_organization_id text, p_title text, p_subject_name text,
  p_due_at timestamptz, p_source text default 'me'::text,
  p_priority text default 'medium'::text, p_remind boolean default true)
  returns uuid language plpgsql set search_path to ''
as $function$
declare v_user_id uuid := (select auth.uid()); v_id uuid; v_title text;
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('create_deadline', 60, interval '1 hour');
  v_title := core.validate_text(p_title, 'Название', 200, true);
  insert into core.user_deadlines (
    user_id, organization_id, title, subject_name, due_at, source,
    academic_group, priority, remind)
  values (
    v_user_id, p_organization_id, v_title,
    core.validate_text(p_subject_name, 'Предмет', 300, false),
    p_due_at, core.validate_text(p_source, 'Источник', 40, false),
    case when p_source in ('group', 'prof') then core.current_academic_group() end,
    core.validate_text(coalesce(p_priority, 'medium'), 'Приоритет', 40, false),
    coalesce(p_remind, true))
  returning id into v_id;

  if coalesce(p_remind, true) then
    insert into core.scheduled_reminders (user_id, fire_at, title, body, route)
    select v_user_id, t, '⏰ Дедлайн: ' || v_title,
      case when t = p_due_at - interval '1 day' then 'остался день'
           else 'осталось 2 часа' end,
      '/services/deadlines'
    from unnest(array[p_due_at - interval '1 day', p_due_at - interval '2 hours']) as t
    where t > now();
  end if;
  return v_id;
end;
$function$;

create or replace function app_api_v1.create_reminder(
  p_fire_at timestamptz, p_title text, p_body text default ''::text,
  p_route text default ''::text)
  returns uuid language plpgsql set search_path to ''
as $function$
declare v_user_id uuid := (select auth.uid()); v_id uuid;
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  if p_fire_at <= now() then raise exception 'Reminder must be in the future'; end if;
  perform core.enforce_rate_limit('create_reminder', 60, interval '1 hour');
  insert into core.scheduled_reminders (user_id, fire_at, title, body, route)
  values (
    v_user_id, p_fire_at, core.validate_text(p_title, 'Заголовок', 200, true),
    core.validate_text(p_body, 'Текст', 2000, false),
    core.validate_text(p_route, 'Маршрут', 300, false))
  returning id into v_id;
  return v_id;
end;
$function$;

create or replace function app_api_v1.upsert_user_activity(
  p_organization_id text, p_id uuid, p_activity_type text, p_title text,
  p_place text, p_subtitle text, p_lesson_uid text,
  p_starts_at timestamptz, p_ends_at timestamptz)
  returns jsonb language plpgsql set search_path to ''
as $function$
declare v_user_id uuid := (select auth.uid()); v_row core.user_activities;
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('upsert_user_activity', 120, interval '1 hour');
  if p_id is null then
    insert into core.user_activities (organization_id,user_id,activity_type,title,place,subtitle,lesson_uid,starts_at,ends_at)
    values (p_organization_id,v_user_id,
      core.validate_text(p_activity_type,'Тип',40,false),
      core.validate_text(p_title,'Название',300,true),
      nullif(trim(coalesce(p_place,'')),''),nullif(trim(coalesce(p_subtitle,'')),''),
      nullif(trim(coalesce(p_lesson_uid,'')),''),p_starts_at,p_ends_at)
    returning * into v_row;
  else
    update core.user_activities set
      activity_type=core.validate_text(p_activity_type,'Тип',40,false),
      title=core.validate_text(p_title,'Название',300,true),
      place=nullif(trim(coalesce(p_place,'')),''),subtitle=nullif(trim(coalesce(p_subtitle,'')),''),
      lesson_uid=nullif(trim(coalesce(p_lesson_uid,'')),''),starts_at=p_starts_at,ends_at=p_ends_at
    where id=p_id and user_id=v_user_id returning * into v_row;
    if v_row.id is null then raise exception 'Activity not found'; end if;
  end if;
  return jsonb_build_array(jsonb_build_object('id',v_row.id,'activityType',v_row.activity_type,
    'title',v_row.title,'place',v_row.place,'subtitle',v_row.subtitle,'lessonUid',v_row.lesson_uid,
    'startsAt',v_row.starts_at,'endsAt',v_row.ends_at));
end;
$function$;
