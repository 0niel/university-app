create function public.get_map_catalog(p_organization_id text default 'mirea')
returns jsonb language sql stable security invoker set search_path = '' as $$
  select app_api_v1.get_map_catalog(p_organization_id);
$$;

create function public.get_map_campus(p_campus_id text)
returns jsonb language sql stable security invoker set search_path = '' as $$
  select app_api_v1.get_map_campus(p_campus_id);
$$;

create function public.get_map_room(p_campus_id text, p_room_id text, p_date date default current_date)
returns jsonb language sql stable security invoker set search_path = '' as $$
  select app_api_v1.get_map_room(p_campus_id,p_room_id,p_date);
$$;

create function public.submit_map_proposal(p_campus_id text, p_base_revision bigint, p_entity_type text,
  p_entity_id text, p_patch jsonb, p_reason text)
returns jsonb language sql security invoker set search_path = '' as $$
  select app_api_v1.submit_map_proposal(p_campus_id,p_base_revision,p_entity_type,p_entity_id,p_patch,p_reason);
$$;

create function public.get_map_proposals(p_campus_id text, p_status text default 'pending', p_limit integer default 50)
returns jsonb language sql stable security invoker set search_path = '' as $$
  select app_api_v1.get_map_proposals(p_campus_id,p_status,p_limit);
$$;

create function public.get_map_proposal(p_proposal_id uuid)
returns jsonb language sql stable security invoker set search_path = '' as $$
  select app_api_v1.get_map_proposal(p_proposal_id);
$$;

create function public.review_map_proposal(p_proposal_id uuid, p_decision text, p_note text default null)
returns jsonb language sql security invoker set search_path = '' as $$
  select app_api_v1.review_map_proposal(p_proposal_id,p_decision,p_note);
$$;

create function public.get_map_bookmarks()
returns jsonb language sql stable security invoker set search_path = '' as $$
  select app_api_v1.get_map_bookmarks();
$$;

create function public.set_map_bookmark(p_campus_id text, p_room_id text, p_saved boolean)
returns jsonb language sql security invoker set search_path = '' as $$
  select app_api_v1.set_map_bookmark(p_campus_id,p_room_id,p_saved);
$$;

create function public.confirm_map_room(p_campus_id text, p_room_id text, p_base_revision bigint,
  p_confirmed boolean default true)
returns jsonb language sql security invoker set search_path = '' as $$
  select app_api_v1.confirm_map_room(p_campus_id,p_room_id,p_base_revision,p_confirmed);
$$;

revoke all on function public.get_map_catalog(text), public.get_map_campus(text), public.get_map_room(text,text,date),
  public.submit_map_proposal(text,bigint,text,text,jsonb,text), public.get_map_proposals(text,text,integer),
  public.get_map_proposal(uuid), public.review_map_proposal(uuid,text,text), public.get_map_bookmarks(),
  public.set_map_bookmark(text,text,boolean), public.confirm_map_room(text,text,bigint,boolean)
  from public, anon, authenticated, service_role;

grant execute on function public.get_map_catalog(text), public.get_map_campus(text), public.get_map_room(text,text,date)
  to anon, authenticated, service_role;
grant execute on function public.submit_map_proposal(text,bigint,text,text,jsonb,text),
  public.get_map_proposals(text,text,integer), public.get_map_proposal(uuid), public.review_map_proposal(uuid,text,text),
  public.get_map_bookmarks(), public.set_map_bookmark(text,text,boolean), public.confirm_map_room(text,text,bigint,boolean)
  to authenticated;

notify pgrst, 'reload schema';
