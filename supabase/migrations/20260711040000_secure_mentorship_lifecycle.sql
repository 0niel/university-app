alter table core.mentor_requests
  add column if not exists status text not null default 'pending',
  add column if not exists price integer not null default 0,
  add column if not exists responded_at timestamptz,
  add column if not exists escrowed_at timestamptz,
  add column if not exists refunded_at timestamptz,
  add column if not exists mentor_confirmed_at timestamptz,
  add column if not exists requester_confirmed_at timestamptz,
  add column if not exists completed_at timestamptz,
  add column if not exists updated_at timestamptz not null default now();

alter table core.mentor_requests
  drop constraint if exists mentor_requests_status_valid;
alter table core.mentor_requests
  add constraint mentor_requests_status_valid check (
    status in (
      'pending',
      'accepted',
      'declined',
      'cancelled',
      'completion_pending',
      'completed'
    )
  );

alter table core.mentor_requests
  drop constraint if exists mentor_requests_price_nonnegative;
alter table core.mentor_requests
  add constraint mentor_requests_price_nonnegative check (price >= 0);

alter table core.mentor_profiles
  drop constraint if exists mentor_profiles_pkey;
alter table core.mentor_profiles
  add constraint mentor_profiles_pkey
  primary key (organization_id, user_id);

with ranked as (
  select
    request.id,
    row_number() over (
      partition by
        request.organization_id,
        request.mentor_user_id,
        request.requester_id
      order by request.created_at desc, request.id desc
    ) as row_number
  from core.mentor_requests request
  where request.status in ('pending', 'accepted', 'completion_pending')
)
update core.mentor_requests request
set status = 'cancelled', updated_at = clock_timestamp()
from ranked
where request.id = ranked.id and ranked.row_number > 1;

create unique index if not exists mentor_requests_active_pair_idx
on core.mentor_requests (organization_id, mentor_user_id, requester_id)
where status in ('pending', 'accepted', 'completion_pending');

drop policy if exists "mentors readable by org users" on core.mentor_profiles;
drop policy if exists "users manage own mentor profile" on core.mentor_profiles;
drop policy if exists "mentors update own profile" on core.mentor_profiles;
drop policy if exists "mentors delete own profile" on core.mentor_profiles;
drop policy if exists "organization members read mentor profiles"
  on core.mentor_profiles;

create policy "organization members read mentor profiles"
on core.mentor_profiles for select to authenticated
using (
  exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = (select auth.uid())
      and profile.organization_id = mentor_profiles.organization_id
  )
);

drop policy if exists "mentor and requester read requests"
  on core.mentor_requests;
drop policy if exists "users send own mentor requests"
  on core.mentor_requests;
drop policy if exists "participants delete requests"
  on core.mentor_requests;
drop policy if exists "participants read organization mentor requests"
  on core.mentor_requests;

create policy "participants read organization mentor requests"
on core.mentor_requests for select to authenticated
using (
  (select auth.uid()) in (mentor_user_id, requester_id)
  and exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = (select auth.uid())
      and profile.organization_id = mentor_requests.organization_id
  )
);

revoke insert, update, delete on core.mentor_profiles from authenticated;
revoke insert, update, delete on core.mentor_requests from authenticated;

create or replace function app_api_v1.get_mentors(
  p_organization_id text
)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
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
          'handle', profile.handle
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
$$;

create or replace function app_api_v1.upsert_mentor_profile(
  p_organization_id text,
  p_topics text[],
  p_bio text default ''::text,
  p_level text default ''::text,
  p_formats text[] default '{}'::text[],
  p_price integer default 0
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_topics text[] := coalesce(p_topics, '{}');
  v_formats text[] := coalesce(p_formats, '{}');
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

  perform core.enforce_rate_limit(
    'upsert_mentor_profile',
    20,
    interval '1 hour'
  );
  insert into core.mentor_profiles (
    user_id,
    organization_id,
    topics,
    bio,
    level,
    formats,
    price
  )
  values (
    v_user_id,
    p_organization_id,
    v_topics,
    core.validate_text(p_bio, 'Bio', 2000, false),
    core.validate_text(p_level, 'Level', 60, false),
    v_formats,
    least(greatest(coalesce(p_price, 0), 0), 1000000)
  )
  on conflict (organization_id, user_id) do update set
    topics = excluded.topics,
    bio = excluded.bio,
    level = excluded.level,
    formats = excluded.formats,
    price = excluded.price,
    is_active = true;
end;
$$;

drop function if exists public.delete_mentor_profile();
drop function if exists app_api_v1.delete_mentor_profile();

create function app_api_v1.delete_mentor_profile(p_organization_id text)
returns void
language plpgsql
security definer
set search_path = ''
as $$
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
  update core.mentor_profiles
  set is_active = false
  where user_id = v_user_id
    and organization_id = p_organization_id;
  if not found then
    raise exception 'Mentor profile is unavailable' using errcode = '42501';
  end if;
end;
$$;

create function public.delete_mentor_profile(p_organization_id text)
returns void
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.delete_mentor_profile(p_organization_id);
$$;

create function app_api_v1.delete_mentor_profile()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_organization_id text;
begin
  select profile.organization_id
  into v_organization_id
  from core.user_academic_profiles profile
  where profile.user_id = v_user_id;
  if v_user_id is null or v_organization_id is null then
    raise exception 'Mentor profile is unavailable' using errcode = '42501';
  end if;
  perform app_api_v1.delete_mentor_profile(v_organization_id);
end;
$$;

create function public.delete_mentor_profile()
returns void
language sql
security invoker
set search_path = ''
as $$ select app_api_v1.delete_mentor_profile(); $$;

create or replace function app_api_v1.create_mentor_request(
  p_organization_id text,
  p_mentor_user_id uuid,
  p_topic text default ''::text,
  p_when_slot text default 'week'::text,
  p_message text default ''::text
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_mentor core.mentor_profiles%rowtype;
  v_id uuid;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if v_user_id = p_mentor_user_id then
    raise exception 'Cannot request yourself' using errcode = '22023';
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

  select mentor.*
  into v_mentor
  from core.mentor_profiles mentor
  join core.user_academic_profiles profile
    on profile.user_id = mentor.user_id
    and profile.organization_id = mentor.organization_id
  where mentor.user_id = p_mentor_user_id
    and mentor.organization_id = p_organization_id
    and mentor.is_active;
  if not found then
    raise exception 'Mentor is unavailable' using errcode = '42501';
  end if;
  if btrim(coalesce(p_topic, '')) = ''
    or not (btrim(p_topic) = any(v_mentor.topics))
  then
    raise exception 'Unsupported mentor topic' using errcode = '22023';
  end if;
  if p_when_slot not in ('tonight', 'tomorrow', 'week') then
    raise exception 'Unsupported mentor time slot' using errcode = '22023';
  end if;

  perform core.enforce_rate_limit(
    'create_mentor_request',
    20,
    interval '1 hour'
  );
  insert into core.mentor_requests (
    organization_id,
    mentor_user_id,
    requester_id,
    topic,
    when_slot,
    message,
    price
  )
  values (
    p_organization_id,
    p_mentor_user_id,
    v_user_id,
    btrim(p_topic),
    p_when_slot,
    core.validate_text(p_message, 'Message', 2000, false),
    v_mentor.price
  )
  returning id into v_id;
  return v_id;
exception
  when unique_violation then
    raise exception 'An active mentor request already exists'
      using errcode = '23505';
end;
$$;

create or replace function app_api_v1.get_my_mentor_requests(
  p_organization_id text
)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
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
          'mentorHandle', mentor.handle
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
      where request.organization_id = p_organization_id
        and v_user_id in (request.mentor_user_id, request.requester_id)
    ),
    '[]'::jsonb
  );
end;
$$;

create or replace function core.apply_organization_shuriken_delta(
  p_user_id uuid,
  p_organization_id text,
  p_emoji text,
  p_title text,
  p_amount integer
)
returns void
language plpgsql
set search_path = ''
as $$
declare
  v_organization_id text;
begin
  if p_amount = 0 then
    raise exception 'Shuriken delta must not be zero' using errcode = '22023';
  end if;

  insert into core.user_gamification_profiles (user_id, organization_id)
  values (p_user_id, p_organization_id)
  on conflict (user_id) do nothing;

  update core.user_gamification_profiles profile
  set shurikens = profile.shurikens + p_amount
  where profile.user_id = p_user_id
    and profile.organization_id = p_organization_id
    and profile.shurikens + p_amount >= 0
  returning profile.organization_id into v_organization_id;

  if v_organization_id is null then
    if exists (
      select 1
      from core.user_gamification_profiles profile
      where profile.user_id = p_user_id
        and profile.organization_id <> p_organization_id
    ) then
      raise exception 'Gamification profile belongs to another organization'
        using errcode = '42501';
    end if;
    raise exception 'Not enough shurikens' using errcode = '22023';
  end if;

  insert into core.shuriken_ledger (
    organization_id,
    user_id,
    emoji,
    title,
    amount
  )
  values (
    p_organization_id,
    p_user_id,
    coalesce(p_emoji, '✨'),
    p_title,
    p_amount
  );
end;
$$;

revoke all on function core.apply_organization_shuriken_delta(
  uuid,
  text,
  text,
  text,
  integer
) from public, anon, authenticated;

create or replace function app_api_v1.act_on_mentor_request(
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
  v_request core.mentor_requests%rowtype;
  v_reward constant integer := 80;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  select request.*
  into v_request
  from core.mentor_requests request
  where request.id = p_id
  for update;
  if not found
    or v_user_id not in (v_request.mentor_user_id, v_request.requester_id)
    or not exists (
      select 1
      from core.user_academic_profiles profile
      where profile.user_id = v_user_id
        and profile.organization_id = v_request.organization_id
    )
  then
    raise exception 'Mentor request is unavailable' using errcode = '42501';
  end if;
  if p_action = 'accept' then
    if v_user_id <> v_request.mentor_user_id
      or v_request.status <> 'pending'
    then
      raise exception 'Request cannot be accepted' using errcode = '22023';
    end if;
    if not exists (
      select 1
      from core.user_academic_profiles profile
      where profile.user_id = v_request.mentor_user_id
        and profile.organization_id = v_request.organization_id
    ) or not exists (
      select 1
      from core.user_academic_profiles profile
      where profile.user_id = v_request.requester_id
        and profile.organization_id = v_request.organization_id
    ) then
      raise exception 'Mentor request participants changed organization'
        using errcode = '42501';
    end if;
    if v_request.price > 0 then
      perform core.apply_organization_shuriken_delta(
        v_request.requester_id,
        v_request.organization_id,
        '🔒',
        'Mentorship session reserved',
        -v_request.price
      );
    end if;
    update core.mentor_requests
    set status = 'accepted',
        responded_at = clock_timestamp(),
        escrowed_at = case
          when price > 0 then clock_timestamp()
          else null
        end,
        updated_at = clock_timestamp()
    where id = p_id;
    return;
  end if;

  if p_action = 'decline' then
    if v_user_id <> v_request.mentor_user_id
      or v_request.status <> 'pending'
    then
      raise exception 'Request cannot be declined' using errcode = '22023';
    end if;
    update core.mentor_requests
    set status = 'declined',
        responded_at = clock_timestamp(),
        updated_at = clock_timestamp()
    where id = p_id;
    return;
  end if;

  if p_action = 'cancel' then
    if not (
      (
        v_request.status = 'pending'
        and v_user_id = v_request.requester_id
      )
      or v_request.status = 'accepted'
      or (
        v_request.status = 'completion_pending'
        and (
          (
            v_user_id = v_request.mentor_user_id
            and v_request.mentor_confirmed_at is not null
            and v_request.requester_confirmed_at is null
          )
          or (
            v_user_id = v_request.requester_id
            and v_request.requester_confirmed_at is not null
            and v_request.mentor_confirmed_at is null
          )
        )
      )
    )
    then
      raise exception 'Request cannot be cancelled' using errcode = '22023';
    end if;
    if v_request.escrowed_at is not null
      and v_request.refunded_at is null
      and v_request.price > 0
    then
      perform core.apply_organization_shuriken_delta(
        v_request.requester_id,
        v_request.organization_id,
        '↩️',
        'Mentorship session refund',
        v_request.price
      );
    end if;
    update core.mentor_requests
    set status = 'cancelled',
        refunded_at = case
          when escrowed_at is not null and price > 0
            then clock_timestamp()
          else refunded_at
        end,
        updated_at = clock_timestamp()
    where id = p_id;
    return;
  end if;

  if p_action <> 'confirm_complete'
    or v_request.status not in ('accepted', 'completion_pending')
    or (v_request.price > 0 and v_request.escrowed_at is null)
  then
    raise exception 'Unsupported mentor request action'
      using errcode = '22023';
  end if;
  if not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = v_request.mentor_user_id
      and profile.organization_id = v_request.organization_id
  ) or not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = v_request.requester_id
      and profile.organization_id = v_request.organization_id
  ) then
    raise exception 'Mentor request participants changed organization'
      using errcode = '42501';
  end if;

  if v_user_id = v_request.mentor_user_id then
    if v_request.mentor_confirmed_at is not null then return; end if;
    update core.mentor_requests
    set mentor_confirmed_at = clock_timestamp(),
        status = 'completion_pending',
        updated_at = clock_timestamp()
    where id = p_id
    returning * into v_request;
  else
    if v_request.requester_confirmed_at is not null then return; end if;
    update core.mentor_requests
    set requester_confirmed_at = clock_timestamp(),
        status = 'completion_pending',
        updated_at = clock_timestamp()
    where id = p_id
    returning * into v_request;
  end if;

  if v_request.mentor_confirmed_at is null
    or v_request.requester_confirmed_at is null
  then
    return;
  end if;

  if v_request.price > 0 then
    perform core.apply_organization_shuriken_delta(
      v_request.mentor_user_id,
      v_request.organization_id,
      '🎓',
      'Mentorship session payment',
      v_request.price
    );
  end if;
  perform core.apply_organization_shuriken_delta(
    v_request.mentor_user_id,
    v_request.organization_id,
    '🥷',
    'Mentorship session reward',
    v_reward
  );

  update core.mentor_profiles
  set sessions_count = sessions_count + 1
  where user_id = v_request.mentor_user_id
    and organization_id = v_request.organization_id;

  insert into core.badge_definitions (
    id,
    category,
    name,
    description,
    emoji,
    rarity,
    sort_order
  )
  values (
    'mentor',
    'community',
    'Mentor',
    'Completed a mentorship session',
    '🥷',
    'rare',
    50
  )
  on conflict (id) do nothing;

  insert into core.user_badges (
    user_id,
    badge_id,
    progress,
    is_earned
  )
  values (v_request.mentor_user_id, 'mentor', 1, true)
  on conflict (user_id, badge_id) do update set
    progress = 1,
    is_earned = true;

  update core.mentor_requests
  set status = 'completed',
      completed_at = clock_timestamp(),
      updated_at = clock_timestamp()
  where id = p_id;
end;
$$;

create or replace function app_api_v1.delete_mentor_request(p_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_mentor_user_id uuid;
  v_status text;
begin
  select request.mentor_user_id, request.status
  into v_mentor_user_id, v_status
  from core.mentor_requests request
  where request.id = p_id
    and v_user_id in (request.mentor_user_id, request.requester_id);
  if not found then
    raise exception 'Mentor request is unavailable' using errcode = '42501';
  end if;
  if v_user_id = v_mentor_user_id and v_status = 'pending' then
    perform app_api_v1.act_on_mentor_request(p_id, 'decline');
  else
    perform app_api_v1.act_on_mentor_request(p_id, 'cancel');
  end if;
end;
$$;

create or replace function public.delete_mentor_request(p_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$ select app_api_v1.delete_mentor_request(p_id); $$;

create or replace function public.act_on_mentor_request(
  p_id uuid,
  p_action text
)
returns void
language sql
security invoker
set search_path = ''
as $$ select app_api_v1.act_on_mentor_request(p_id, p_action); $$;

revoke all on function app_api_v1.get_mentors(text) from public, anon;
revoke all on function app_api_v1.upsert_mentor_profile(
  text,
  text[],
  text,
  text,
  text[],
  integer
) from public, anon;
revoke all on function app_api_v1.delete_mentor_profile(text)
  from public, anon;
revoke all on function app_api_v1.delete_mentor_profile()
  from public, anon;
revoke all on function app_api_v1.create_mentor_request(
  text,
  uuid,
  text,
  text,
  text
) from public, anon;
revoke all on function app_api_v1.get_my_mentor_requests(text)
  from public, anon;
revoke all on function app_api_v1.act_on_mentor_request(uuid, text)
  from public, anon;

grant execute on function app_api_v1.get_mentors(text)
  to authenticated, service_role;
grant execute on function app_api_v1.upsert_mentor_profile(
  text,
  text[],
  text,
  text,
  text[],
  integer
) to authenticated, service_role;
grant execute on function app_api_v1.delete_mentor_profile(text)
  to authenticated, service_role;
grant execute on function app_api_v1.delete_mentor_profile()
  to authenticated, service_role;
grant execute on function app_api_v1.create_mentor_request(
  text,
  uuid,
  text,
  text,
  text
) to authenticated, service_role;
grant execute on function app_api_v1.get_my_mentor_requests(text)
  to authenticated, service_role;
grant execute on function app_api_v1.act_on_mentor_request(uuid, text)
  to authenticated, service_role;

revoke all on function public.act_on_mentor_request(uuid, text)
  from public, anon;
grant execute on function public.act_on_mentor_request(uuid, text)
  to authenticated, service_role;

revoke all on function public.delete_mentor_profile(text)
  from public, anon;
grant execute on function public.delete_mentor_profile(text)
  to authenticated, service_role;
revoke all on function public.delete_mentor_profile()
  from public, anon;
grant execute on function public.delete_mentor_profile()
  to authenticated, service_role;

revoke all on function app_api_v1.delete_mentor_request(uuid)
  from public, anon;
grant execute on function app_api_v1.delete_mentor_request(uuid)
  to authenticated, service_role;
revoke all on function public.delete_mentor_request(uuid)
  from public, anon;
grant execute on function public.delete_mentor_request(uuid)
  to authenticated, service_role;
