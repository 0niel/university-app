create table core.search_query_events (
  id bigint generated always as identity primary key,
  organization_id text not null references core.organizations(id)
    on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  query text not null,
  searched_on date not null default current_date,
  created_at timestamptz not null default now(),
  constraint search_query_events_query_valid check (
    char_length(query) between 2 and 100
  ),
  constraint search_query_events_daily_unique unique (
    organization_id,
    user_id,
    query,
    searched_on
  )
);

create index search_query_events_trending_idx
on core.search_query_events (organization_id, searched_on desc, query);

create index search_query_events_user_idx
on core.search_query_events (user_id);

create index search_query_events_retention_idx
on core.search_query_events (searched_on);

alter table core.search_query_events enable row level security;
revoke all on core.search_query_events from public, anon, authenticated;
grant all on core.search_query_events to service_role;

create or replace function app_api_v1.get_group_space(
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
  v_group_id uuid;
  v_group_name text;
  v_group_emoji text;
  v_is_owner boolean := false;
  v_academic_group text;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;

  select p.academic_group
  into v_academic_group
  from core.user_academic_profiles p
  where p.user_id = v_user_id
    and p.organization_id = p_organization_id;

  if not found then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;

  select g.id, g.name, g.emoji, g.owner_id = v_user_id
  into v_group_id, v_group_name, v_group_emoji, v_is_owner
  from core.study_group_members membership
  join core.study_groups g on g.id = membership.group_id
  where membership.user_id = v_user_id
    and g.organization_id = p_organization_id;

  if v_group_id is null then
    return jsonb_build_object(
      'group', null,
      'emoji', '🎓',
      'hasGroup', false,
      'isOwner', false,
      'memberCount', 0,
      'memberNames', '[]'::jsonb,
      'links', '[]'::jsonb,
      'announcement', null,
      'notes', '[]'::jsonb,
      'birthdays', '[]'::jsonb
    );
  end if;

  return (
    with members as (
      select
        membership.user_id,
        membership.role,
        membership.joined_at,
        coalesce(profile.full_name, 'Студент') as full_name,
        profile.birth_date
      from core.study_group_members membership
      left join core.user_academic_profiles profile
        on profile.user_id = membership.user_id
      where membership.group_id = v_group_id
    )
    select jsonb_build_object(
      'group', v_group_name,
      'emoji', v_group_emoji,
      'hasGroup', true,
      'isOwner', v_is_owner,
      'memberCount', (select count(*) from members),
      'memberNames', (
        select coalesce(jsonb_agg(member.full_name), '[]'::jsonb)
        from (
          select full_name
          from members
          order by (role = 'owner') desc, joined_at, user_id
          limit 5
        ) member
      ),
      'links', (
        select coalesce(
          jsonb_agg(
            jsonb_build_object(
              'id', link.id,
              'kind', link.kind,
              'emoji', link.emoji,
              'title', link.title,
              'url', link.url,
              'addedBy', coalesce(
                (
                  select split_part(member.full_name, ' ', 1)
                  from members member
                  where member.user_id = link.created_by
                ),
                'аноним'
              ),
              'isMine', link.created_by = v_user_id
            )
            order by link.created_at
          ),
          '[]'::jsonb
        )
        from core.group_links link
        where link.organization_id = p_organization_id
          and (
            link.group_id = v_group_id
            or (
              link.group_id is null
              and link.academic_group = v_academic_group
            )
          )
      ),
      'announcement', (
        select jsonb_build_object(
          'id', post.id,
          'title', post.title,
          'body', post.body,
          'authorName', coalesce(
            (
              select split_part(member.full_name, ' ', 1)
              from members member
              where member.user_id = post.author_id
            ),
            'аноним'
          ),
          'createdAt', post.created_at,
          'isMine', post.author_id = v_user_id
        )
        from core.group_posts post
        where post.organization_id = p_organization_id
          and post.kind = 'announcement'
          and (
            post.group_id = v_group_id
            or (
              post.group_id is null
              and post.academic_group = v_academic_group
            )
          )
        order by post.created_at desc
        limit 1
      ),
      'notes', (
        select coalesce(
          jsonb_agg(
            jsonb_build_object(
              'id', post.id,
              'title', post.title,
              'body', post.body,
              'authorName', coalesce(
                (
                  select split_part(member.full_name, ' ', 1)
                  from members member
                  where member.user_id = post.author_id
                ),
                'аноним'
              ),
              'createdAt', post.created_at,
              'isPinned', post.is_pinned,
              'isMine', post.author_id = v_user_id,
              'likes', (
                select count(*)
                from core.group_post_likes reaction
                where reaction.post_id = post.id
              ),
              'likedByMe', exists (
                select 1
                from core.group_post_likes reaction
                where reaction.post_id = post.id
                  and reaction.user_id = v_user_id
              )
            )
            order by post.is_pinned desc, post.created_at desc
          ),
          '[]'::jsonb
        )
        from core.group_posts post
        where post.organization_id = p_organization_id
          and post.kind = 'note'
          and (
            post.group_id = v_group_id
            or (
              post.group_id is null
              and post.academic_group = v_academic_group
            )
          )
      ),
      'birthdays', (
        select coalesce(
          jsonb_agg(
            jsonb_build_object(
              'name', birthday.full_name,
              'date', birthday.next_birthday,
              'isMe', birthday.user_id = v_user_id
            )
            order by birthday.next_birthday
          ),
          '[]'::jsonb
        )
        from (
          select
            member.user_id,
            member.full_name,
            (
              member.birth_date
              + make_interval(
                years => extract(
                  year from age(now(), member.birth_date)
                )::integer
                + case
                    when (
                      member.birth_date
                      + make_interval(
                        years => extract(
                          year from age(now(), member.birth_date)
                        )::integer
                      )
                    )::date < current_date then 1
                    else 0
                  end
              )
            )::date as next_birthday
          from members member
          where member.birth_date is not null
        ) birthday
        where birthday.next_birthday <= current_date + 60
      )
    )
  );
end;
$$;

create or replace function app_api_v1.get_group_notes(
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
  v_group_id uuid;
  v_academic_group text;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;

  select profile.academic_group
  into v_academic_group
  from core.user_academic_profiles profile
  where profile.user_id = v_user_id
    and profile.organization_id = p_organization_id;

  if not found then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;

  select group_row.id
  into v_group_id
  from core.study_group_members membership
  join core.study_groups group_row on group_row.id = membership.group_id
  where membership.user_id = v_user_id
    and group_row.organization_id = p_organization_id;

  return coalesce(
    (
      select jsonb_agg(
        jsonb_build_object(
          'id', note.id,
          'title', note.title,
          'content', note.content,
          'createdAt', note.created_at,
          'updatedAt', note.updated_at,
          'isMine', note.owner_id = v_user_id,
          'isPersonal', note.visibility = 'personal',
          'updatedByName', coalesce(
            (
              select split_part(profile.full_name, ' ', 1)
              from core.user_academic_profiles profile
              where profile.user_id = note.updated_by
            ),
            ''
          )
        )
        order by note.updated_at desc
      )
      from core.group_notes note
      where note.organization_id = p_organization_id
        and (
          (note.visibility = 'personal' and note.owner_id = v_user_id)
          or (
            note.visibility = 'group'
            and (
              note.group_id = v_group_id
              or (
                note.group_id is null
                and note.academic_group = v_academic_group
              )
            )
          )
        )
    ),
    '[]'::jsonb
  );
end;
$$;

create or replace function app_api_v1.search_group_posts(p_query text)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group_id uuid := core.current_study_group_id();
  v_academic_group text := core.current_academic_group();
  v_organization_id text;
  v_query text := left(btrim(coalesce(p_query, '')), 100);
  v_pattern text;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;

  select profile.organization_id
  into v_organization_id
  from core.user_academic_profiles profile
  where profile.user_id = v_user_id;

  if v_organization_id is null then
    raise exception 'User does not belong to an organization'
      using errcode = '42501';
  end if;
  if char_length(v_query) < 2 then return '[]'::jsonb; end if;

  v_pattern := '%' || replace(
    replace(replace(v_query, '\', '\\'), '%', '\%'),
    '_',
    '\_'
  ) || '%';

  return coalesce(
    (
      select jsonb_agg(
        jsonb_build_object(
          'id', result.id,
          'title', result.title,
          'body', result.body,
          'kind', result.kind,
          'isPinned', result.is_pinned,
          'createdAt', result.created_at,
          'authorName', coalesce(profile.full_name, 'Студент')
        )
        order by result.is_pinned desc, result.created_at desc
      )
      from (
        select post.*
        from core.group_posts post
        where post.organization_id = v_organization_id
          and (
            post.group_id = v_group_id
            or (
              post.group_id is null
              and post.academic_group = v_academic_group
            )
          )
          and (
            post.title ilike v_pattern escape '\'
            or post.body ilike v_pattern escape '\'
          )
        order by post.is_pinned desc, post.created_at desc
        limit 20
      ) result
      left join core.user_academic_profiles profile
        on profile.user_id = result.author_id
    ),
    '[]'::jsonb
  );
end;
$$;

create or replace function app_api_v1.log_search_query(p_query text)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_organization_id text;
  v_query text := left(
    lower(regexp_replace(btrim(coalesce(p_query, '')), '\s+', ' ', 'g')),
    100
  );
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if char_length(v_query) < 2 then return; end if;

  select profile.organization_id
  into v_organization_id
  from core.user_academic_profiles profile
  where profile.user_id = v_user_id;

  if v_organization_id is null then
    raise exception 'User does not belong to an organization'
      using errcode = '42501';
  end if;

  perform core.enforce_rate_limit('log_search_query', 100, interval '1 hour');
  delete from core.search_query_events
  where searched_on < current_date - 90;

  insert into core.search_query_events (organization_id, user_id, query)
  values (v_organization_id, v_user_id, v_query)
  on conflict (organization_id, user_id, query, searched_on) do nothing;
end;
$$;

create or replace function app_api_v1.trending_searches()
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_organization_id text;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;

  select profile.organization_id
  into v_organization_id
  from core.user_academic_profiles profile
  where profile.user_id = v_user_id;

  if v_organization_id is null then
    raise exception 'User does not belong to an organization'
      using errcode = '42501';
  end if;

  return coalesce(
    (
      select jsonb_agg(
        jsonb_build_object('query', trend.query, 'count', trend.query_count)
        order by trend.query_count desc, trend.last_used_at desc, trend.query
      )
      from (
        select
          event.query,
          count(*)::integer as query_count,
          max(event.created_at) as last_used_at
        from core.search_query_events event
        where event.organization_id = v_organization_id
          and event.searched_on >= current_date - 30
        group by event.query
        having count(distinct event.user_id) >= 3
        order by query_count desc, last_used_at desc, event.query
        limit 10
      ) trend
    ),
    '[]'::jsonb
  );
end;
$$;

drop function if exists public.create_group_note(text, text);
drop function if exists app_api_v1.create_group_note(text, text);

create or replace function public.get_group_space(p_organization_id text)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$ select app_api_v1.get_group_space(p_organization_id); $$;

create or replace function public.get_group_notes(p_organization_id text)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$ select app_api_v1.get_group_notes(p_organization_id); $$;

create or replace function public.create_group_note(
  p_organization_id text,
  p_title text,
  p_visibility text default 'group'::text
)
returns uuid
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.create_group_note(
    p_organization_id,
    p_title,
    p_visibility
  );
$$;

create or replace function public.search_group_posts(p_query text)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$ select app_api_v1.search_group_posts(p_query); $$;

create or replace function public.log_search_query(p_query text)
returns void
language sql
security invoker
set search_path = ''
as $$ select app_api_v1.log_search_query(p_query); $$;

create or replace function public.trending_searches()
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$ select app_api_v1.trending_searches(); $$;

revoke all on function app_api_v1.get_group_space(text)
from public, anon;
revoke all on function app_api_v1.get_group_notes(text)
from public, anon;
revoke all on function app_api_v1.create_group_note(text, text, text)
from public, anon;
revoke all on function app_api_v1.search_group_posts(text)
from public, anon;
revoke all on function app_api_v1.log_search_query(text)
from public, anon;
revoke all on function app_api_v1.trending_searches()
from public, anon;

grant execute on function app_api_v1.get_group_space(text)
to authenticated, service_role;
grant execute on function app_api_v1.get_group_notes(text)
to authenticated, service_role;
grant execute on function app_api_v1.create_group_note(text, text, text)
to authenticated, service_role;
grant execute on function app_api_v1.search_group_posts(text)
to authenticated, service_role;
grant execute on function app_api_v1.log_search_query(text)
to authenticated, service_role;
grant execute on function app_api_v1.trending_searches()
to authenticated, service_role;

revoke all on function public.get_group_space(text) from public, anon;
revoke all on function public.get_group_notes(text) from public, anon;
revoke all on function public.create_group_note(text, text, text)
from public, anon;
revoke all on function public.search_group_posts(text) from public, anon;
revoke all on function public.log_search_query(text) from public, anon;
revoke all on function public.trending_searches() from public, anon;

grant execute on function public.get_group_space(text)
to authenticated, service_role;
grant execute on function public.get_group_notes(text)
to authenticated, service_role;
grant execute on function public.create_group_note(text, text, text)
to authenticated, service_role;
grant execute on function public.search_group_posts(text)
to authenticated, service_role;
grant execute on function public.log_search_query(text)
to authenticated, service_role;
grant execute on function public.trending_searches()
to authenticated, service_role;

drop policy if exists "teams readable by org users" on core.teams;
drop policy if exists "users create own teams" on core.teams;
drop policy if exists "owners update own teams" on core.teams;
drop policy if exists "owners delete own teams" on core.teams;

create policy "teams readable by org users"
on core.teams for select to authenticated
using (
  exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = (select auth.uid())
      and profile.organization_id = teams.organization_id
  )
);

create policy "users create own teams"
on core.teams for insert to authenticated
with check (
  (select auth.uid()) = owner_id
  and exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = (select auth.uid())
      and profile.organization_id = teams.organization_id
  )
);

create policy "owners update own teams"
on core.teams for update to authenticated
using (
  (select auth.uid()) = owner_id
  and exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = (select auth.uid())
      and profile.organization_id = teams.organization_id
  )
)
with check (
  (select auth.uid()) = owner_id
  and exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = (select auth.uid())
      and profile.organization_id = teams.organization_id
  )
);

create policy "owners delete own teams"
on core.teams for delete to authenticated
using (
  (select auth.uid()) = owner_id
  and exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = (select auth.uid())
      and profile.organization_id = teams.organization_id
  )
);

drop policy if exists "team members readable by org users"
on core.team_members;
drop policy if exists "users join teams" on core.team_members;
drop policy if exists "users leave teams" on core.team_members;

create policy "team members readable by org users"
on core.team_members for select to authenticated
using (
  exists (
    select 1
    from core.teams team
    join core.user_academic_profiles profile
      on profile.organization_id = team.organization_id
    where team.id = team_members.team_id
      and profile.user_id = (select auth.uid())
  )
);

create policy "users join teams"
on core.team_members for insert to authenticated
with check (
  (select auth.uid()) = user_id
  and exists (
    select 1
    from core.teams team
    join core.user_academic_profiles profile
      on profile.organization_id = team.organization_id
    where team.id = team_members.team_id
      and profile.user_id = (select auth.uid())
  )
);

create policy "users leave teams"
on core.team_members for delete to authenticated
using (
  (select auth.uid()) = user_id
  and exists (
    select 1
    from core.teams team
    join core.user_academic_profiles profile
      on profile.organization_id = team.organization_id
    where team.id = team_members.team_id
      and profile.user_id = (select auth.uid())
  )
);

drop policy if exists "owner and applicant read applications"
on core.team_applications;
drop policy if exists "users apply themselves" on core.team_applications;
drop policy if exists "owner and applicant delete applications"
on core.team_applications;

create policy "owner and applicant read applications"
on core.team_applications for select to authenticated
using (
  (select auth.uid()) = applicant_id
  or exists (
    select 1 from core.teams team
    where team.id = team_applications.team_id
      and team.owner_id = (select auth.uid())
  )
);

create policy "users apply themselves"
on core.team_applications for insert to authenticated
with check (
  (select auth.uid()) = applicant_id
  and exists (
    select 1
    from core.teams team
    join core.user_academic_profiles profile
      on profile.organization_id = team.organization_id
    where team.id = team_applications.team_id
      and profile.user_id = (select auth.uid())
  )
);

create policy "owner and applicant delete applications"
on core.team_applications for delete to authenticated
using (
  (select auth.uid()) = applicant_id
  or exists (
    select 1 from core.teams team
    where team.id = team_applications.team_id
      and team.owner_id = (select auth.uid())
  )
);

create or replace function public.get_teams(p_organization_id text)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null or not exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;
  return app_api_v1.get_teams(p_organization_id);
end;
$$;

create or replace function public.create_team(
  p_organization_id text,
  p_title text,
  p_event_name text default '',
  p_description text default '',
  p_needed_roles text[] default '{}',
  p_capacity integer default 5,
  p_kind text default 'hackathon',
  p_deadline_at timestamptz default null,
  p_boost boolean default false
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null or not exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;
  return app_api_v1.create_team(
    p_organization_id, p_title, p_event_name, p_description,
    p_needed_roles, p_capacity, p_kind, p_deadline_at, p_boost
  );
end;
$$;

create or replace function public.apply_to_team(
  p_team_id uuid,
  p_role text default '',
  p_message text default '',
  p_attach_profile boolean default true
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null or not exists (
    select 1
    from core.teams team
    join core.user_academic_profiles profile
      on profile.organization_id = team.organization_id
    where team.id = p_team_id and profile.user_id = v_user_id
  ) then
    raise exception 'Team not found in the current organization'
      using errcode = '42501';
  end if;
  return app_api_v1.apply_to_team(
    p_team_id, p_role, p_message, p_attach_profile
  );
end;
$$;

create or replace function public.set_team_membership(
  p_team_id uuid,
  p_join boolean
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null or not exists (
    select 1
    from core.teams team
    join core.user_academic_profiles profile
      on profile.organization_id = team.organization_id
    where team.id = p_team_id and profile.user_id = v_user_id
  ) then
    raise exception 'Team not found in the current organization'
      using errcode = '42501';
  end if;
  perform app_api_v1.set_team_membership(p_team_id, p_join);
end;
$$;

create or replace function public.delete_team(p_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null or not exists (
    select 1 from core.teams team
    where team.id = p_id and team.owner_id = v_user_id
  ) then
    raise exception 'Team not found or not owned by the current user'
      using errcode = '42501';
  end if;
  perform app_api_v1.delete_team(p_id);
end;
$$;

create or replace function public.delete_team_application(p_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null or not exists (
    select 1
    from core.team_applications application
    join core.teams team on team.id = application.team_id
    where application.id = p_id
      and (
        application.applicant_id = v_user_id
        or team.owner_id = v_user_id
      )
  ) then
    raise exception 'Team application not found for the current user'
      using errcode = '42501';
  end if;
  perform app_api_v1.delete_team_application(p_id);
end;
$$;

revoke insert, update, delete on core.teams from authenticated;
revoke insert, delete on core.team_members from authenticated;
revoke insert, delete on core.team_applications from authenticated;

revoke all on function app_api_v1.get_teams(text)
from public, anon, authenticated;
revoke all on function app_api_v1.create_team(
  text, text, text, text, text[], integer, text, timestamptz, boolean
) from public, anon, authenticated;
revoke all on function app_api_v1.apply_to_team(uuid, text, text, boolean)
from public, anon, authenticated;
revoke all on function app_api_v1.set_team_membership(uuid, boolean)
from public, anon, authenticated;
revoke all on function app_api_v1.delete_team(uuid)
from public, anon, authenticated;
revoke all on function app_api_v1.delete_team_application(uuid)
from public, anon, authenticated;

grant execute on function app_api_v1.get_teams(text) to service_role;
grant execute on function app_api_v1.create_team(
  text, text, text, text, text[], integer, text, timestamptz, boolean
) to service_role;
grant execute on function app_api_v1.apply_to_team(uuid, text, text, boolean)
to service_role;
grant execute on function app_api_v1.set_team_membership(uuid, boolean)
to service_role;
grant execute on function app_api_v1.delete_team(uuid) to service_role;
grant execute on function app_api_v1.delete_team_application(uuid)
to service_role;
