alter table core.organization_communities
  add column verification_status text not null default 'unverified'
    check (verification_status in ('unverified', 'verified', 'not_found', 'unavailable')),
  add column metadata_checked_at timestamptz,
  add column verification_evidence text,
  add column verification_http_status integer,
  add column hidden_by_verification boolean not null default false;

update core.organization_communities
set member_count = null
where organization_id = 'mirea'
  and member_count_updated_at is null;

update core.organization_communities
set logo_url = null
where organization_id = 'mirea'
  and member_count_updated_at is null
  and (
    logo_url like 'https://sun9-65.userapi.com/impg/bvdpBQYk7glRfRkmsR-GRMMWwK2Rw3lDIuGjzQ/%'
    or logo_url like 'https://sun9-1.userapi.com/impg/JSVkx8BMQSKU2IR27bnX_yajk4Bvb_HMf530gg/%'
    or logo_url like 'https://sun9-21.userapi.com/impg/Sk3d5lpXhoaiHj3QZz1tt8HQKPcEaoE27WgZAw/%'
    or logo_url like 'https://sun9-55.userapi.com/impg/J-OyvW6fp0ZtQ3mJKhI-OxDwPgQbCLhz_PA7bQ/%'
  );

create function app_api_v1.get_community_sync_targets(p_organization_id text)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(jsonb_agg(jsonb_build_object(
    'id', c.id,
    'slug', c.slug,
    'url', c.destination_url,
    'platform', c.platform
  ) order by c.slug), '[]'::jsonb)
  from core.organization_communities c
  where c.organization_id = p_organization_id;
$$;

create function app_api_v1.apply_community_observations(
  p_organization_id text,
  p_observations jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_item jsonb;
  v_id uuid;
  v_status text;
  v_checked_at timestamptz;
  v_http_status integer;
  v_count integer;
  v_updated integer := 0;
  v_rows integer;
begin
  if jsonb_typeof(p_observations) is distinct from 'array'
    or jsonb_array_length(p_observations) > 500 then
    raise exception 'Expected at most 500 community observations' using errcode = '22023';
  end if;
  for v_item in select value from jsonb_array_elements(p_observations)
  loop
    v_id := (v_item ->> 'id')::uuid;
    v_status := v_item ->> 'status';
    v_checked_at := (v_item ->> 'checked_at')::timestamptz;
    v_http_status := (v_item ->> 'http_status')::integer;
    v_count := (v_item ->> 'member_count')::integer;
    if v_status is null or v_status not in ('verified', 'not_found', 'unavailable')
      or v_checked_at is null or v_checked_at > now() + interval '5 minutes'
      or v_count < 0
      or coalesce(char_length(v_item ->> 'evidence'), 0) not between 1 and 500
      or char_length(v_item ->> 'title') > 160
      or char_length(v_item ->> 'description') > 1000
      or (nullif(btrim(v_item ->> 'logo_url'), '') is not null
        and (v_item ->> 'logo_url') !~* '^https://')
      or (v_http_status is not null and v_http_status not between 100 and 599) then
      raise exception 'Invalid community observation' using errcode = '22023';
    end if;
    if v_status = 'not_found'
      and not coalesce(v_http_status in (404, 410)
        or (v_http_status = 200 and (v_item ->> 'evidence') in ('Сообщество удалено', 'Страница удалена')), false) then
      raise exception 'Deletion requires explicit missing evidence' using errcode = '22023';
    end if;
    if not exists (
      select 1 from core.organization_communities c
      where c.id = v_id and c.organization_id = p_organization_id
        and c.destination_url = v_item ->> 'url'
    ) then
      raise exception 'Community observation does not match its tenant and URL' using errcode = '22023';
    end if;
    update core.organization_communities c
    set verification_status = v_status,
        metadata_checked_at = v_checked_at,
        verification_evidence = v_item ->> 'evidence',
        verification_http_status = v_http_status,
        member_count = case when v_status = 'verified' and v_count is not null
          then v_count else c.member_count end,
        member_count_updated_at = case when v_status = 'verified' and v_count is not null
          then v_checked_at else c.member_count_updated_at end,
        title = case when v_status = 'verified'
          then coalesce(nullif(btrim(v_item ->> 'title'), ''), c.title) else c.title end,
        description = case when v_status = 'verified'
          then coalesce(nullif(btrim(v_item ->> 'description'), ''), c.description) else c.description end,
        logo_url = case when v_status = 'verified'
          then coalesce(nullif(btrim(v_item ->> 'logo_url'), ''), c.logo_url) else c.logo_url end,
        is_active = case when v_status = 'not_found' then false
          when v_status = 'verified' and c.hidden_by_verification then true
          else c.is_active end,
        hidden_by_verification = case when v_status = 'not_found'
          then c.is_active or c.hidden_by_verification
          when v_status = 'verified' then false
          else c.hidden_by_verification end
    where c.id = v_id and c.organization_id = p_organization_id
      and c.destination_url = v_item ->> 'url'
      and (c.metadata_checked_at is null or c.metadata_checked_at <= v_checked_at);
    get diagnostics v_rows = row_count;
    v_updated := v_updated + v_rows;
  end loop;
  return jsonb_build_object('received', jsonb_array_length(p_observations), 'updated', v_updated);
end;
$$;

create function public.get_community_sync_targets(p_organization_id text)
returns jsonb
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.get_community_sync_targets(p_organization_id);
$$;

create function public.apply_community_observations(p_organization_id text, p_observations jsonb)
returns jsonb
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.apply_community_observations(p_organization_id, p_observations);
$$;

revoke all on function app_api_v1.get_community_sync_targets(text) from public, anon, authenticated;
revoke all on function app_api_v1.apply_community_observations(text, jsonb) from public, anon, authenticated;
revoke all on function public.get_community_sync_targets(text) from public, anon, authenticated;
revoke all on function public.apply_community_observations(text, jsonb) from public, anon, authenticated;
grant execute on function app_api_v1.get_community_sync_targets(text) to service_role;
grant execute on function app_api_v1.apply_community_observations(text, jsonb) to service_role;
grant execute on function public.get_community_sync_targets(text) to service_role;
grant execute on function public.apply_community_observations(text, jsonb) to service_role;
