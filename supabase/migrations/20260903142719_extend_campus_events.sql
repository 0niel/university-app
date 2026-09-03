alter table core.campus_events add column if not exists ends_at timestamptz;

alter table core.campus_events drop constraint if exists campus_events_ends_after_starts;
alter table core.campus_events add constraint campus_events_ends_after_starts
check (ends_at is null or ends_at > starts_at);

drop function if exists app_api_v1.get_events(text);
drop function if exists public.get_events(text);

create function app_api_v1.get_events(
  p_organization_id text,
  p_include_past boolean default false,
  p_from timestamptz default null,
  p_to timestamptz default null
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
        'id', e.id,
        'title', e.title,
        'description', e.description,
        'emoji', e.emoji,
        'category', e.category,
        'place', e.place,
        'startsAt', e.starts_at,
        'endsAt', e.ends_at,
        'goingCount', (
          select count(*) from core.event_rsvps r where r.event_id = e.id
        ),
        'rsvpCount', (
          select count(*) from core.event_rsvps r where r.event_id = e.id
        ),
        'isGoing', exists (
          select 1 from core.event_rsvps r
          where r.event_id = e.id and r.user_id = (select auth.uid())
        ),
        'isMine', e.created_by = (select auth.uid()),
        'goingNames', (
          select coalesce(jsonb_agg(g.first_name), '[]'::jsonb)
          from (
            select split_part(p.full_name, ' ', 1) as first_name
            from core.event_rsvps r
            join core.user_academic_profiles p on p.user_id = r.user_id
            where r.event_id = e.id
            order by r.created_at
            limit 3
          ) g
        )
      )
      order by e.starts_at
    ),
    '[]'::jsonb
  )
  from core.campus_events e
  where e.organization_id = p_organization_id
    and (p_include_past or e.starts_at > now() - interval '12 hours')
    and (p_from is null or e.starts_at >= p_from)
    and (p_to is null or e.starts_at <= p_to);
$$;

create function public.get_events(
  p_organization_id text,
  p_include_past boolean default false,
  p_from timestamptz default null,
  p_to timestamptz default null
)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select app_api_v1.get_events(p_organization_id, p_include_past, p_from, p_to);
$$;

revoke all on function app_api_v1.get_events(text, boolean, timestamptz, timestamptz)
from public, anon;
grant execute on function app_api_v1.get_events(text, boolean, timestamptz, timestamptz)
to authenticated, service_role;
revoke all on function public.get_events(text, boolean, timestamptz, timestamptz)
from public, anon;
grant execute on function public.get_events(text, boolean, timestamptz, timestamptz)
to authenticated, service_role;

drop function if exists app_api_v1.create_event(text, text, timestamptz, text, text, text, text);
drop function if exists public.create_event(text, text, timestamptz, text, text, text, text);

create function app_api_v1.create_event(
  p_organization_id text,
  p_title text,
  p_starts_at timestamptz,
  p_place text default '',
  p_emoji text default '🎉',
  p_category text default 'other',
  p_description text default '',
  p_ends_at timestamptz default null
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
  if p_ends_at is not null and p_ends_at <= p_starts_at then
    raise exception 'Событие не может закончиться раньше начала';
  end if;
  perform core.enforce_rate_limit('create_event', 10, interval '1 hour');
  insert into core.campus_events (
    organization_id, title, description, emoji, category, place,
    starts_at, ends_at, created_by
  )
  values (
    p_organization_id, core.validate_text(p_title, 'Название', 200, true),
    core.validate_text(p_description, 'Описание', 4000, false),
    left(coalesce(p_emoji, '🎉'), 16),
    core.validate_text(coalesce(p_category, 'other'), 'Категория', 40, false),
    core.validate_text(p_place, 'Место', 200, false), p_starts_at, p_ends_at,
    v_user_id
  )
  returning id into v_id;
  return v_id;
end;
$$;

create function public.create_event(
  p_organization_id text,
  p_title text,
  p_starts_at timestamptz,
  p_place text default '',
  p_emoji text default '🎉',
  p_category text default 'other',
  p_description text default '',
  p_ends_at timestamptz default null
)
returns uuid
language sql
set search_path = ''
as $$
  select app_api_v1.create_event(
    p_organization_id, p_title, p_starts_at, p_place, p_emoji,
    p_category, p_description, p_ends_at
  );
$$;

revoke all on function app_api_v1.create_event(
  text, text, timestamptz, text, text, text, text, timestamptz
) from public, anon;
grant execute on function app_api_v1.create_event(
  text, text, timestamptz, text, text, text, text, timestamptz
) to authenticated, service_role;
revoke all on function public.create_event(
  text, text, timestamptz, text, text, text, text, timestamptz
) from public, anon;
grant execute on function public.create_event(
  text, text, timestamptz, text, text, text, text, timestamptz
) to authenticated, service_role;

create or replace function app_api_v1.update_event(
  p_id uuid,
  p_title text default null,
  p_starts_at timestamptz default null,
  p_ends_at timestamptz default null,
  p_place text default null,
  p_emoji text default null,
  p_category text default null,
  p_description text default null
)
returns void
language plpgsql
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_row core.campus_events;
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;
  perform core.enforce_rate_limit('update_event', 20, interval '1 hour');
  select * into v_row from core.campus_events
  where id = p_id and created_by = v_user_id;
  if v_row.id is null then
    raise exception 'Event not found';
  end if;
  if coalesce(p_ends_at, v_row.ends_at) is not null
    and coalesce(p_ends_at, v_row.ends_at) <= coalesce(p_starts_at, v_row.starts_at)
  then
    raise exception 'Событие не может закончиться раньше начала';
  end if;
  update core.campus_events set
    title = coalesce(core.validate_text(p_title, 'Название', 200, false), title),
    starts_at = coalesce(p_starts_at, starts_at),
    ends_at = case when p_ends_at is not null then p_ends_at else ends_at end,
    place = coalesce(core.validate_text(p_place, 'Место', 200, false), place),
    emoji = coalesce(left(p_emoji, 16), emoji),
    category = coalesce(core.validate_text(p_category, 'Категория', 40, false), category),
    description = coalesce(core.validate_text(p_description, 'Описание', 4000, false), description)
  where id = p_id and created_by = v_user_id;
end;
$$;

create or replace function public.update_event(
  p_id uuid,
  p_title text default null,
  p_starts_at timestamptz default null,
  p_ends_at timestamptz default null,
  p_place text default null,
  p_emoji text default null,
  p_category text default null,
  p_description text default null
)
returns void
language sql
set search_path = ''
as $$
  select app_api_v1.update_event(
    p_id, p_title, p_starts_at, p_ends_at, p_place, p_emoji, p_category, p_description
  );
$$;

revoke all on function app_api_v1.update_event(
  uuid, text, timestamptz, timestamptz, text, text, text, text
) from public, anon;
grant execute on function app_api_v1.update_event(
  uuid, text, timestamptz, timestamptz, text, text, text, text
) to authenticated, service_role;
revoke all on function public.update_event(
  uuid, text, timestamptz, timestamptz, text, text, text, text
) from public, anon;
grant execute on function public.update_event(
  uuid, text, timestamptz, timestamptz, text, text, text, text
) to authenticated, service_role;
