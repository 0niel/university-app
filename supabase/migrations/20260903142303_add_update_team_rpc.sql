create or replace function app_api_v1.update_team(
  p_id uuid,
  p_title text,
  p_event_name text default '',
  p_description text default '',
  p_needed_roles text[] default '{}',
  p_capacity integer default 5,
  p_kind text default 'hackathon',
  p_deadline_at timestamptz default null,
  p_status text default null
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_team core.teams%rowtype;
  v_roles text[] := array(
    select distinct btrim(value)
    from unnest(coalesce(p_needed_roles, '{}')) value
    where btrim(value) <> ''
  );
begin
  select team.* into v_team
  from core.teams team
  where team.id = p_id
  for update;
  if v_user_id is null or not found or v_team.owner_id <> v_user_id then
    raise exception 'Team is unavailable' using errcode = '42501';
  end if;
  if cardinality(v_roles) > 20
    or exists (
      select 1 from unnest(v_roles) value
      where char_length(value) > 60
    )
    or p_capacity not between 2 and 20
    or char_length(btrim(coalesce(p_kind, ''))) not between 1 and 60
    or p_deadline_at < now()
    or p_deadline_at > now() + interval '2 years'
    or p_status not in ('open', 'closed')
    or (p_status is not null and v_team.status not in ('open', 'closed'))
  then
    raise exception 'Invalid team options' using errcode = '22023';
  end if;
  perform core.enforce_rate_limit('update_team', 30, interval '1 hour');
  update core.teams team
  set
    title = core.validate_text(p_title, 'Title', 160, true),
    event_name = core.validate_text(p_event_name, 'Event name', 160, false),
    description = core.validate_text(p_description, 'Description', 4000, false),
    needed_roles = v_roles,
    capacity = p_capacity,
    kind = btrim(p_kind),
    deadline_at = p_deadline_at,
    status = coalesce(p_status, team.status),
    updated_at = clock_timestamp()
  where team.id = p_id;
end;
$$;

create or replace function public.update_team(
  p_id uuid,
  p_title text,
  p_event_name text default '',
  p_description text default '',
  p_needed_roles text[] default '{}',
  p_capacity integer default 5,
  p_kind text default 'hackathon',
  p_deadline_at timestamptz default null,
  p_status text default null
)
returns void language sql security definer set search_path = ''
as $$
  select app_api_v1.update_team(
    p_id,
    p_title,
    p_event_name,
    p_description,
    p_needed_roles,
    p_capacity,
    p_kind,
    p_deadline_at,
    p_status
  );
$$;

revoke all on function app_api_v1.update_team(
  uuid, text, text, text, text[], integer, text, timestamptz, text
) from public, anon, authenticated;
grant execute on function app_api_v1.update_team(
  uuid, text, text, text, text[], integer, text, timestamptz, text
) to service_role;

revoke all on function public.update_team(
  uuid, text, text, text, text[], integer, text, timestamptz, text
) from public, anon;
grant execute on function public.update_team(
  uuid, text, text, text, text[], integer, text, timestamptz, text
) to authenticated, service_role;
