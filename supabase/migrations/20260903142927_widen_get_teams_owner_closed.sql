create or replace function app_api_v1.get_teams(p_organization_id text)
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
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'Teams are unavailable' using errcode = '42501';
  end if;
  return (
    select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', team.id,
        'title', team.title,
        'eventName', team.event_name,
        'description', team.description,
        'neededRoles', to_jsonb(team.needed_roles),
        'capacity', team.capacity,
        'kind', team.kind,
        'deadlineAt', team.deadline_at,
        'isBoosted', team.boosted_until is not null
          and team.boosted_until > now(),
        'createdAt', team.created_at,
        'status', team.status,
        'isMine', team.owner_id = (select auth.uid()),
        'isMember', exists (
          select 1 from core.team_members member
          where member.team_id = team.id
            and member.user_id = (select auth.uid())
        ),
        'hasApplied', exists (
          select 1 from core.team_applications application
          where application.team_id = team.id
            and application.applicant_id = (select auth.uid())
            and application.status = 'pending'
        ),
        'myApplicationId', (
          select application.id
          from core.team_applications application
          where application.team_id = team.id
            and application.applicant_id = (select auth.uid())
            and application.status = 'pending'
        ),
        'applicationsCount', case
          when team.owner_id = (select auth.uid()) then (
            select count(*) from core.team_applications application
            where application.team_id = team.id
              and application.status = 'pending'
          ) else 0
        end,
        'memberCount', 1 + (
          select count(*)
          from core.team_members member
          join core.user_academic_profiles profile
            on profile.user_id = member.user_id
            and profile.organization_id = team.organization_id
          where member.team_id = team.id
        ),
        'memberNames', (
          select coalesce(jsonb_agg(names.first_name), '[]'::jsonb)
          from (
            select split_part(owner.full_name, ' ', 1) as first_name
            from core.user_academic_profiles owner
            where owner.user_id = team.owner_id
              and owner.organization_id = team.organization_id
            union all
            select split_part(profile.full_name, ' ', 1)
            from core.team_members member
            join core.user_academic_profiles profile
              on profile.user_id = member.user_id
              and profile.organization_id = team.organization_id
            where member.team_id = team.id
            limit 4
          ) names
        )
      )
      order by
        (team.boosted_until is not null and team.boosted_until > now()) desc,
        team.created_at desc
    ),
    '[]'::jsonb
  )
  from core.teams team
  join core.user_academic_profiles owner
    on owner.user_id = team.owner_id
    and owner.organization_id = team.organization_id
  where team.organization_id = p_organization_id
    and (team.status = 'open' or team.owner_id = (select auth.uid()))
  );
end;
$$;
