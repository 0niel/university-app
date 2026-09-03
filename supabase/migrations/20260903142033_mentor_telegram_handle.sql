alter table core.mentor_profiles
  add column if not exists telegram_handle text;

alter table core.mentor_profiles
  drop constraint if exists mentor_profiles_telegram_handle_format;

alter table core.mentor_profiles
  add constraint mentor_profiles_telegram_handle_format
  check (telegram_handle is null or telegram_handle ~ '^[a-zA-Z0-9_]{5,32}$');

drop function if exists app_api_v1.upsert_mentor_profile(text, text[], text, text, text[], integer);

create or replace function app_api_v1.upsert_mentor_profile(
  p_organization_id text,
  p_topics text[],
  p_telegram_handle text,
  p_bio text default '',
  p_level text default '',
  p_formats text[] default '{}',
  p_price integer default 0
)
returns void
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_user_id uuid := (select auth.uid());
  v_topics text[] := coalesce(p_topics, '{}');
  v_formats text[] := coalesce(p_formats, '{}');
  v_telegram_handle text := btrim(coalesce(p_telegram_handle, ''));
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;
  if cardinality(v_topics) not between 1 and 20
    or cardinality(v_formats) > 10
    or exists (
      select 1
      from unnest(v_topics || v_formats) value
      where char_length(btrim(value)) not between 1 and 60
    )
  then
    raise exception 'Invalid mentor profile options' using errcode = '22023';
  end if;
  if v_telegram_handle !~ '^[a-zA-Z0-9_]{5,32}$' then
    raise exception 'Invalid Telegram handle' using errcode = '22023';
  end if;

  perform core.enforce_rate_limit(
    'upsert_mentor_profile',
    20,
    interval '1 hour'
  );
  insert into core.mentor_profiles (
    user_id,
    organization_id,
    topics,
    telegram_handle,
    bio,
    level,
    formats,
    price
  )
  values (
    v_user_id,
    p_organization_id,
    v_topics,
    v_telegram_handle,
    core.validate_text(p_bio, 'Bio', 2000, false),
    core.validate_text(p_level, 'Level', 60, false),
    v_formats,
    least(greatest(coalesce(p_price, 0), 0), 1000000)
  )
  on conflict (organization_id, user_id) do update set
    topics = excluded.topics,
    telegram_handle = excluded.telegram_handle,
    bio = excluded.bio,
    level = excluded.level,
    formats = excluded.formats,
    price = excluded.price,
    is_active = true;
end;
$function$;

revoke all on function app_api_v1.upsert_mentor_profile(text, text[], text, text, text, text[], integer) from public;
grant execute on function app_api_v1.upsert_mentor_profile(text, text[], text, text, text, text[], integer) to authenticated;
grant execute on function app_api_v1.upsert_mentor_profile(text, text[], text, text, text, text[], integer) to service_role;

create or replace function app_api_v1.get_mentors(p_organization_id text)
 returns jsonb
 language plpgsql
 stable security definer
 set search_path to ''
as $function$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;

  return coalesce(
    (
      select jsonb_agg(
        jsonb_build_object(
          'userId', mentor.user_id,
          'topics', to_jsonb(mentor.topics),
          'bio', mentor.bio,
          'sessions', mentor.sessions_count,
          'level', mentor.level,
          'formats', to_jsonb(mentor.formats),
          'price', mentor.price,
          'isMe', mentor.user_id = v_user_id,
          'fullName', coalesce(profile.full_name, 'Student'),
          'course', profile.course,
          'group', profile.academic_group,
          'handle', profile.handle,
          'telegramHandle', mentor.telegram_handle
        )
        order by mentor.sessions_count desc, mentor.created_at
      )
      from core.mentor_profiles mentor
      join core.user_academic_profiles profile
        on profile.user_id = mentor.user_id
        and profile.organization_id = mentor.organization_id
      where mentor.organization_id = p_organization_id
        and mentor.is_active
    ),
    '[]'::jsonb
  );
end;
$function$;

create or replace function app_api_v1.get_my_mentor_requests(p_organization_id text)
 returns jsonb
 language plpgsql
 stable security definer
 set search_path to ''
as $function$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;

  return coalesce(
    (
      select jsonb_agg(
        jsonb_build_object(
          'id', request.id,
          'mentorUserId', request.mentor_user_id,
          'requesterId', request.requester_id,
          'topic', request.topic,
          'whenSlot', request.when_slot,
          'message', request.message,
          'price', request.price,
          'status', request.status,
          'createdAt', request.created_at,
          'isIncoming', request.mentor_user_id = v_user_id,
          'mentorConfirmed', request.mentor_confirmed_at is not null,
          'requesterConfirmed', request.requester_confirmed_at is not null,
          'requesterName', coalesce(requester.full_name, 'Student'),
          'requesterHandle', requester.handle,
          'mentorName', coalesce(mentor.full_name, 'Student'),
          'mentorHandle', mentor.handle,
          'mentorTelegramHandle', mentor_profile.telegram_handle
        )
        order by request.created_at desc
      )
      from core.mentor_requests request
      left join core.user_academic_profiles requester
        on requester.user_id = request.requester_id
        and requester.organization_id = request.organization_id
      left join core.user_academic_profiles mentor
        on mentor.user_id = request.mentor_user_id
        and mentor.organization_id = request.organization_id
      left join core.mentor_profiles mentor_profile
        on mentor_profile.user_id = request.mentor_user_id
        and mentor_profile.organization_id = request.organization_id
      where request.organization_id = p_organization_id
        and v_user_id in (request.mentor_user_id, request.requester_id)
    ),
    '[]'::jsonb
  );
end;
$function$;
