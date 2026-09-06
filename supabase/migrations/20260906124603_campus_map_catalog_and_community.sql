create table core.map_campuses (
  id text primary key check (length(id) between 1 and 120),
  organization_id text not null references core.organizations(id),
  document jsonb not null,
  revision bigint not null default 1 check (revision > 0),
  published boolean not null default true,
  updated_at timestamptz not null default now()
);

create index map_campuses_organization_idx on core.map_campuses (organization_id) where published;

create table core.map_moderators (
  organization_id text not null references core.organizations(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (organization_id, user_id)
);

create table core.map_proposals (
  id uuid primary key default extensions.gen_random_uuid(),
  campus_id text not null references core.map_campuses(id),
  base_revision bigint not null check (base_revision > 0),
  entity_type text not null check (entity_type in ('campus', 'floor', 'room', 'place_create', 'graph', 'report')),
  entity_id text not null check (length(entity_id) between 1 and 120),
  patch jsonb not null check (jsonb_typeof(patch) = 'object' and octet_length(patch::text) <= 16777216),
  patch_bytes integer generated always as (octet_length(patch::text)) stored,
  reason text not null check (length(reason) between 5 and 3000),
  author_id uuid references auth.users(id) on delete set null,
  status text not null default 'pending' check (status in ('pending', 'approved', 'rejected')),
  created_at timestamptz not null default now(),
  reviewed_by uuid references auth.users(id) on delete set null,
  reviewed_at timestamptz,
  review_note text check (length(review_note) <= 3000),
  check ((status = 'pending' and reviewed_at is null) or (status <> 'pending' and reviewed_at is not null))
);

create index map_proposals_queue_idx on core.map_proposals (campus_id, status, created_at desc);
create index map_proposals_author_idx on core.map_proposals (author_id, created_at desc);

create table core.map_revisions (
  campus_id text not null references core.map_campuses(id),
  revision bigint not null,
  document jsonb not null,
  proposal_id uuid references core.map_proposals(id),
  published_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  primary key (campus_id, revision)
);

create table core.map_bookmarks (
  user_id uuid not null references auth.users(id) on delete cascade,
  campus_id text not null references core.map_campuses(id),
  room_id text not null check (length(room_id) between 1 and 120),
  saved_at timestamptz not null default now(),
  primary key (user_id, campus_id, room_id)
);

create table core.map_room_confirmations (
  user_id uuid not null references auth.users(id) on delete cascade,
  campus_id text not null references core.map_campuses(id),
  room_id text not null check (length(room_id) between 1 and 120),
  revision bigint not null,
  confirmed_at timestamptz not null default now(),
  primary key (user_id, campus_id, room_id),
  foreign key (campus_id, revision) references core.map_revisions(campus_id, revision)
);
create index map_room_confirmations_room_idx on core.map_room_confirmations(campus_id, room_id, revision);
create index map_schedule_classroom_lookup_idx on core.schedule_classrooms(organization_id, campus_id, normalized_name);

alter table core.map_campuses enable row level security;
alter table core.map_moderators enable row level security;
alter table core.map_proposals enable row level security;
alter table core.map_revisions enable row level security;
alter table core.map_bookmarks enable row level security;
alter table core.map_room_confirmations enable row level security;
revoke all on core.map_campuses, core.map_moderators, core.map_proposals, core.map_revisions from public, anon, authenticated;
revoke all on core.map_bookmarks, core.map_room_confirmations from public, anon, authenticated;
grant select on core.map_campuses, core.map_revisions, core.map_proposals to service_role;
grant select, insert, update, delete on core.map_moderators to service_role;

create function core.map_is_moderator(p_organization_id text)
returns boolean language sql stable security definer set search_path = '' as $$
  select auth.uid() is not null and exists (
    select 1 from core.map_moderators m
    join auth.users u on u.id = m.user_id
    where m.organization_id = p_organization_id and m.user_id = auth.uid() and not coalesce(u.is_anonymous, false)
  );
$$;

create function core.map_number(p_value jsonb, p_min numeric, p_max numeric)
returns boolean language sql immutable set search_path = '' as $$
  select case when jsonb_typeof(p_value) = 'number'
    then (p_value #>> '{}')::numeric between p_min and p_max else false end;
$$;

create function core.map_strings(p_value jsonb, p_keys text[])
returns boolean language sql immutable set search_path = '' as $$
  select not exists (select 1 from unnest(p_keys) k where p_value ? k
    and (jsonb_typeof(p_value->k) is distinct from 'string' or length(p_value->>k) > 3000));
$$;

create function core.map_validate_document(p_document jsonb)
returns void language plpgsql immutable set search_path = '' as $$
declare
  v_floor jsonb;
  v_room jsonb;
  v_node jsonb;
  v_edge jsonb;
  v_item jsonb;
  v_floors jsonb;
  v_nodes jsonb;
  v_floor_ids text[];
  v_room_ids text[];
  v_node_ids text[];
  v_floor_lookup jsonb;
  v_room_lookup jsonb;
  v_node_lookup jsonb;
begin
  if jsonb_typeof(p_document) is distinct from 'object'
    or octet_length(p_document::text) > 33554432
    or coalesce(length(p_document->>'title'), 0) not between 1 and 240
    or not core.map_strings(p_document, array['title','short_title','address','source_url','source_label','description','opening_hours'])
    or coalesce(p_document->>'source_url', '') !~ '^https://[^[:space:]]+$'
    or not (
      (coalesce(p_document->'latitude', 'null'::jsonb) = 'null'::jsonb and coalesce(p_document->'longitude', 'null'::jsonb) = 'null'::jsonb)
      or (core.map_number(p_document->'latitude', -90, 90) and core.map_number(p_document->'longitude', -180, 180))
    )
    or jsonb_typeof(p_document->'floors') is distinct from 'array'
    or jsonb_typeof(p_document->'rooms') is distinct from 'array'
    or jsonb_typeof(p_document->'graph') is distinct from 'object'
    or jsonb_typeof(p_document#>'{graph,nodes}') is distinct from 'array'
    or jsonb_typeof(p_document#>'{graph,edges}') is distinct from 'array' then
    raise exception 'Invalid campus document' using errcode = '22023';
  end if;
  v_floors := p_document->'floors';
  v_nodes := p_document#>'{graph,nodes}';
  if jsonb_array_length(v_floors) > 100 or jsonb_array_length(p_document->'rooms') > 30000
    or jsonb_array_length(v_nodes) > 50000 or jsonb_array_length(p_document#>'{graph,edges}') > 100000 then
    raise exception 'Campus document exceeds supported limits' using errcode = '22023';
  end if;
  select coalesce(array_agg(value->>'id'), '{}'::text[]) into v_floor_ids from jsonb_array_elements(v_floors);
  select coalesce(array_agg(value->>'id'), '{}'::text[]) into v_room_ids from jsonb_array_elements(p_document->'rooms');
  select coalesce(array_agg(value->>'id'), '{}'::text[]) into v_node_ids from jsonb_array_elements(v_nodes);
  if exists (select 1 from unnest(v_floor_ids) id group by id having count(*) > 1)
    or exists (select 1 from unnest(v_room_ids) id group by id having count(*) > 1)
    or exists (select 1 from unnest(v_node_ids) id group by id having count(*) > 1)
    or exists (select 1 from jsonb_array_elements(p_document#>'{graph,edges}') e group by e->>'id' having count(*) > 1) then
    raise exception 'Duplicate map entity id' using errcode = '22023';
  end if;
  for v_floor in select value from jsonb_array_elements(v_floors) loop
    if coalesce(length(v_floor->>'id'), 0) not between 1 and 120
      or not core.map_strings(v_floor, array['id','label','image_url'])
      or coalesce(length(v_floor->>'label'), 0) not between 1 and 240
      or not core.map_number(v_floor->'level', -20, 200)
      or not core.map_number(v_floor->'width', 1, 10000000)
      or not core.map_number(v_floor->'height', 1, 10000000)
      or (v_floor ? 'meters_per_unit' and not core.map_number(v_floor->'meters_per_unit', 0.000001, 10000))
      or (v_floor ? 'image_url' and coalesce(v_floor->>'image_url', '') !~ '^https://[^[:space:]]+$') then
      raise exception 'Invalid floor dimensions or metadata' using errcode = '22023';
    end if;
    if v_floor ? 'svg' and (jsonb_typeof(v_floor->'svg') <> 'string'
      or length(v_floor->>'svg') > 8388608
      or (v_floor->>'svg') !~* '<svg[[:space:]>]'
      or (v_floor->>'svg') ~* '<[[:space:]]*([a-z0-9_-]+:)?(script|foreignObject|iframe|object|embed|audio|video)([[:space:]>])|<!DOCTYPE|<!ENTITY|[[:space:]]on[a-z]+[[:space:]]*=|javascript:|@import|url\([[:space:]]*[''"]?https?:|[[:space:]](xlink:)?href[[:space:]]*=[[:space:]]*[''"][^#]') then
      raise exception 'Unsafe or invalid floor SVG' using errcode = '22023';
    end if;
    if v_floor ? 'anchors' then
      if jsonb_typeof(v_floor->'anchors') <> 'array' then
        raise exception 'Invalid floor anchors' using errcode = '22023';
      end if;
      if jsonb_array_length(v_floor->'anchors') > 20 then
        raise exception 'Too many floor anchors' using errcode = '22023';
      end if;
      for v_item in select value from jsonb_array_elements(v_floor->'anchors') loop
        if not core.map_number(v_item->'x', 0, (v_floor->>'width')::numeric)
          or not core.map_number(v_item->'y', 0, (v_floor->>'height')::numeric)
          or not core.map_number(v_item->'latitude', -90, 90)
          or not core.map_number(v_item->'longitude', -180, 180) then
          raise exception 'Invalid floor anchor coordinates' using errcode = '22023';
        end if;
      end loop;
    end if;
  end loop;
  select coalesce(jsonb_object_agg(value->>'id', jsonb_build_object('width',value->'width','height',value->'height')), '{}'::jsonb)
    into v_floor_lookup from jsonb_array_elements(v_floors);
  for v_room in select value from jsonb_array_elements(p_document->'rooms') loop
    v_floor := v_floor_lookup->(v_room->>'floor_id');
    if coalesce(length(v_room->>'id'), 0) not between 1 and 120
      or not core.map_strings(v_room, array['id','floor_id','label','kind','description','opening_hours','accessibility','source_url','schedule_classroom_id','menu_date','expires_at','verified_at','updated_at'])
      or coalesce(length(v_room->>'label'), 0) not between 1 and 240 or v_floor is null
      or coalesce(length(v_room->>'kind'), 0) not between 1 and 80
      or not core.map_number(v_room->'x', 0, (v_floor->>'width')::numeric)
      or not core.map_number(v_room->'y', 0, (v_floor->>'height')::numeric)
      or (v_room ? 'equipment' and jsonb_typeof(v_room->'equipment') <> 'array')
      or (v_room ? 'legacy_ids' and jsonb_typeof(v_room->'legacy_ids') <> 'array')
      or (v_room ? 'menu' and jsonb_typeof(v_room->'menu') <> 'array')
      or (v_room ? 'description' and (jsonb_typeof(v_room->'description') <> 'string' or length(v_room->>'description') > 3000))
      or (v_room ? 'opening_hours' and (jsonb_typeof(v_room->'opening_hours') <> 'string' or length(v_room->>'opening_hours') > 2000))
      or (v_room ? 'accessibility' and (jsonb_typeof(v_room->'accessibility') <> 'string' or length(v_room->>'accessibility') > 2000))
      or (v_room ? 'accessible' and jsonb_typeof(v_room->'accessible') <> 'boolean')
      or (v_room ? 'navigation_needs_review' and jsonb_typeof(v_room->'navigation_needs_review') <> 'boolean')
      or (v_room ? 'source_url' and coalesce(v_room->>'source_url','') !~ '^https://[^[:space:]]+$')
      or (v_room ? 'capacity' and not core.map_number(v_room->'capacity', 0, 100000))
      or (v_room ? 'schedule_classroom_id' and coalesce(v_room->>'schedule_classroom_id','') !~ '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$') then
      raise exception 'Invalid room metadata or coordinates' using errcode = '22023';
    end if;
    if jsonb_array_length(coalesce(v_room->'equipment', '[]'::jsonb)) > 100
      or jsonb_array_length(coalesce(v_room->'legacy_ids', '[]'::jsonb)) > 100
      or jsonb_array_length(coalesce(v_room->'menu', '[]'::jsonb)) > 500 then
      raise exception 'Too many room equipment or menu entries' using errcode = '22023';
    end if;
    for v_item in select value from jsonb_array_elements(coalesce(v_room->'equipment', '[]'::jsonb)) loop
      if jsonb_typeof(v_item) <> 'string' or length(v_item#>>'{}') not between 1 and 240 then
        raise exception 'Invalid equipment item' using errcode = '22023';
      end if;
    end loop;
    for v_item in select value from jsonb_array_elements(coalesce(v_room->'legacy_ids', '[]'::jsonb)) loop
      if jsonb_typeof(v_item) <> 'string' or length(v_item#>>'{}') not between 1 and 120 then
        raise exception 'Invalid legacy room identifier' using errcode = '22023';
      end if;
    end loop;
    if v_room ? 'menu_date' then
      if coalesce(v_room->>'menu_date', '') !~ '^\d{4}-\d{2}-\d{2}$' then
        raise exception 'Invalid menu date' using errcode = '22023';
      end if;
      perform (v_room->>'menu_date')::date;
    end if;
    if v_room ? 'expires_at' then
      if coalesce(v_room->>'expires_at', '') !~ '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?(Z|[+-]\d{2}:\d{2})$' then
        raise exception 'Invalid menu expiry' using errcode = '22023';
      end if;
      perform (v_room->>'expires_at')::timestamptz;
    end if;
    for v_item in select value from jsonb_array_elements(coalesce(v_room->'menu', '[]'::jsonb)) loop
      if jsonb_typeof(v_item) <> 'object' or coalesce(length(v_item->>'name'), 0) not between 1 and 240
        or not core.map_strings(v_item, array['name','currency','description','category'])
        or (v_item ? 'price' and not core.map_number(v_item->'price', 0, 1000000))
        or (v_item ? 'available' and jsonb_typeof(v_item->'available') <> 'boolean')
        or (v_item ? 'currency' and coalesce(v_item->>'currency', '') !~ '^[A-Z]{3}$') then
        raise exception 'Invalid menu item' using errcode = '22023';
      end if;
    end loop;
  end loop;
  select coalesce(jsonb_object_agg(value->>'id', jsonb_build_object('floor_id',value->'floor_id')), '{}'::jsonb)
    into v_room_lookup from jsonb_array_elements(p_document->'rooms');
  if exists (
    select 1 from jsonb_array_elements(p_document->'rooms') r
    cross join lateral jsonb_array_elements_text(coalesce(r->'legacy_ids','[]'::jsonb)) a(value)
    where a.value <> r->>'id' and v_room_lookup ? a.value
  ) or exists (
    select 1 from jsonb_array_elements(p_document->'rooms') r
    cross join lateral jsonb_array_elements_text(coalesce(r->'legacy_ids','[]'::jsonb)) a(value)
    group by a.value having count(distinct r->>'id') > 1
  ) then
    raise exception 'Ambiguous legacy room identifier' using errcode = '22023';
  end if;
  for v_node in select value from jsonb_array_elements(v_nodes) loop
    v_floor := v_floor_lookup->(v_node->>'floor_id');
    if coalesce(length(v_node->>'id'), 0) not between 1 and 120 or v_floor is null
      or not core.map_strings(v_node, array['id','floor_id','room_id','label','kind'])
      or not core.map_number(v_node->'x', 0, (v_floor->>'width')::numeric)
      or not core.map_number(v_node->'y', 0, (v_floor->>'height')::numeric)
      or (v_node ? 'room_id' and not coalesce(v_room_lookup ? (v_node->>'room_id'), false))
      or (v_node ? 'room_id' and (v_room_lookup#>>array[v_node->>'room_id','floor_id']) is distinct from v_node->>'floor_id')
      or (v_node ? 'wheelchair_accessible' and jsonb_typeof(v_node->'wheelchair_accessible') <> 'boolean')
      or (v_node ? 'closed' and jsonb_typeof(v_node->'closed') <> 'boolean') then
      raise exception 'Invalid navigation node' using errcode = '22023';
    end if;
  end loop;
  select coalesce(jsonb_object_agg(value->>'id', jsonb_build_object('floor_id',value->'floor_id')), '{}'::jsonb)
    into v_node_lookup from jsonb_array_elements(v_nodes);
  for v_edge in select value from jsonb_array_elements(p_document#>'{graph,edges}') loop
    if coalesce(length(v_edge->>'id'), 0) not between 1 and 120
      or not core.map_strings(v_edge, array['id','from_node_id','to_node_id','kind','label'])
      or not coalesce(v_node_lookup ? (v_edge->>'from_node_id'), false)
      or not coalesce(v_node_lookup ? (v_edge->>'to_node_id'), false)
      or v_edge->>'from_node_id' = v_edge->>'to_node_id'
      or (coalesce(v_edge->'distance_meters', 'null'::jsonb) <> 'null'::jsonb
        and not core.map_number(v_edge->'distance_meters', 0, 100000))
      or (coalesce(v_edge->'traversal_cost', 'null'::jsonb) <> 'null'::jsonb
        and (not core.map_number(v_edge->'traversal_cost', 0, 1000000000000) or v_edge->'traversal_cost' = '0'::jsonb))
      or (coalesce(v_edge->'distance_meters', 'null'::jsonb) = 'null'::jsonb
        and coalesce(v_edge->'traversal_cost', 'null'::jsonb) = 'null'::jsonb)
      or (coalesce(v_edge->'duration_seconds', 'null'::jsonb) <> 'null'::jsonb
        and not core.map_number(v_edge->'duration_seconds', 0, 86400))
      or coalesce(v_edge->>'kind', '') not in ('corridor', 'stairs', 'elevator', 'ramp', 'escalator', 'door', 'outdoor')
      or (v_edge ? 'wheelchair_accessible' and jsonb_typeof(v_edge->'wheelchair_accessible') <> 'boolean')
      or (v_edge ? 'closed' and jsonb_typeof(v_edge->'closed') <> 'boolean')
      or (v_edge ? 'bidirectional' and jsonb_typeof(v_edge->'bidirectional') <> 'boolean') then
      raise exception 'Invalid navigation edge' using errcode = '22023';
    end if;
    if v_edge->>'kind' not in ('stairs','elevator','ramp','escalator','outdoor')
      and (v_node_lookup#>>array[v_edge->>'from_node_id','floor_id'])
        is distinct from (v_node_lookup#>>array[v_edge->>'to_node_id','floor_id']) then
      raise exception 'Cross-floor edge requires a vertical connector' using errcode = '22023';
    end if;
  end loop;
end;
$$;

create function core.map_patch_document(p_document jsonb, p_entity_type text, p_entity_id text, p_patch jsonb)
returns jsonb language plpgsql immutable set search_path = '' as $$
declare
  v_result jsonb := p_document;
  v_collection text;
  v_allowed text[];
  v_index integer;
  v_previous jsonb;
  v_nodes jsonb;
  v_rooms jsonb;
begin
  if jsonb_typeof(p_patch) is distinct from 'object' or p_patch = '{}'::jsonb
    or octet_length(p_patch::text) > 16777216 then
    raise exception 'Invalid or empty map patch' using errcode = '22023';
  end if;
  case p_entity_type
    when 'room' then
      v_collection := 'rooms';
      v_allowed := array['label','kind','description','x','y','polygon','equipment','opening_hours','menu','menu_date','expires_at','capacity','accessibility','accessible','schedule_classroom_id'];
    when 'place_create' then
      v_allowed := array['floor_id','label','kind','description','x','y','polygon','equipment','opening_hours','menu','menu_date','expires_at','capacity','accessibility','accessible','schedule_classroom_id'];
    when 'floor' then
      v_collection := 'floors';
      v_allowed := array['label','level','svg','image_url','width','height','meters_per_unit','anchors'];
    when 'campus' then
      v_allowed := array['title','short_title','address','latitude','longitude','description','opening_hours'];
    when 'graph' then
      v_allowed := array['nodes','edges'];
    when 'report' then
      v_allowed := array['category','details','source_url'];
      if coalesce(length(p_patch->>'details'), 0) not between 5 and 3000
        or coalesce(p_patch->>'category','') not in ('plan','route','accessibility','other')
        or (p_patch ? 'source_url' and coalesce(p_patch->>'source_url','') !~ '^https://[^[:space:]]+$') then
        raise exception 'Invalid map report' using errcode = '22023';
      end if;
    else raise exception 'Unsupported map entity' using errcode = '22023';
  end case;
  if exists (select 1 from jsonb_object_keys(p_patch) k where not k = any(v_allowed)) then
    raise exception 'Unsupported map patch field' using errcode = '22023';
  end if;
  if p_entity_type = 'place_create' then
    if exists (select 1 from jsonb_array_elements(p_document->'rooms') where value->>'id' = p_entity_id) then
      raise exception 'Map place id already exists' using errcode = '22023';
    end if;
    v_result := jsonb_set(p_document, '{rooms}', (p_document->'rooms') || jsonb_build_array(
      jsonb_build_object('id', p_entity_id, 'equipment', '[]'::jsonb, 'menu', '[]'::jsonb) || p_patch));
  elsif v_collection is not null then
    select (ordinality - 1)::integer into v_index
    from jsonb_array_elements(p_document->v_collection) with ordinality where value->>'id' = p_entity_id;
    if v_index is null then raise exception 'Map entity not found' using errcode = '22023'; end if;
    v_previous := p_document#>array[v_collection, v_index::text];
    v_result := jsonb_set(p_document, array[v_collection, v_index::text],
      v_previous || p_patch);
    if p_entity_type = 'room' and (
      (p_patch ? 'x' and p_patch->'x' is distinct from v_previous->'x')
      or (p_patch ? 'y' and p_patch->'y' is distinct from v_previous->'y')) then
      select coalesce(jsonb_agg(case when value->>'room_id' = p_entity_id then
        (case when value->>'label' = v_previous->>'label' then value - array['room_id','label']
          else value - 'room_id' end) || '{"kind":"junction"}'::jsonb
          else value end order by ordinality), '[]'::jsonb)
        into v_nodes from jsonb_array_elements(v_result#>'{graph,nodes}') with ordinality;
      v_result := jsonb_set(v_result, '{graph,nodes}', v_nodes);
      v_result := jsonb_set(v_result, array['rooms',v_index::text,'navigation_needs_review'], 'true'::jsonb);
    end if;
  elsif p_entity_type = 'campus' then
    v_result := p_document || p_patch;
  elsif p_entity_type = 'graph' then
    v_result := jsonb_set(p_document, '{graph}', (p_document->'graph') || p_patch);
    select coalesce(jsonb_agg(case when r.value->>'navigation_needs_review' = 'true'
      and exists(select 1 from jsonb_array_elements(v_result#>'{graph,nodes}') n
        where n->>'room_id' = r.value->>'id') then r.value - 'navigation_needs_review'
      else r.value end order by r.ordinality), '[]'::jsonb)
      into v_rooms from jsonb_array_elements(v_result->'rooms') with ordinality as r(value,ordinality);
    v_result := jsonb_set(v_result, '{rooms}', v_rooms);
  end if;
  perform core.map_validate_document(v_result);
  return v_result;
end;
$$;

create function core.map_proposal_json(p_proposal core.map_proposals, p_moderator boolean, p_include_patch boolean default false)
returns jsonb language sql stable set search_path = '' as $$
  select jsonb_build_object(
    'id', p_proposal.id, 'campus_id', p_proposal.campus_id,
    'base_revision', p_proposal.base_revision, 'entity_type', p_proposal.entity_type,
    'entity_id', p_proposal.entity_id, 'reason', p_proposal.reason,
    'patch_keys', (select coalesce(jsonb_agg(k order by k), '[]'::jsonb) from jsonb_object_keys(p_proposal.patch) k),
    'patch_bytes', p_proposal.patch_bytes, 'has_full_patch', p_include_patch,
    'status', p_proposal.status, 'created_at', p_proposal.created_at,
    'reviewed_at', p_proposal.reviewed_at, 'review_note', p_proposal.review_note,
    'is_mine', coalesce(p_proposal.author_id = auth.uid(), false),
    'can_review', p_moderator and p_proposal.status = 'pending' and p_proposal.author_id is distinct from auth.uid()
  ) || case when p_include_patch then jsonb_build_object('patch', p_proposal.patch) else '{}'::jsonb end;
$$;

create function core.map_get_catalog(p_organization_id text)
returns jsonb language sql stable security definer set search_path = '' as $$
  select jsonb_build_object('schema_version', 1, 'campuses', coalesce(jsonb_agg(
    jsonb_build_object('id', c.id, 'organization_id', c.organization_id,
      'title', c.document->'title', 'short_title', c.document->'short_title', 'address', c.document->'address',
      'latitude', c.document->'latitude', 'longitude', c.document->'longitude',
      'source_url', c.document->'source_url', 'source_label', c.document->'source_label',
      'revision', c.revision, 'updated_at', c.updated_at,
      'floor_count', jsonb_array_length(c.document->'floors'), 'room_count', jsonb_array_length(c.document->'rooms'),
      'can_moderate', core.map_is_moderator(c.organization_id)) order by c.document->>'title'), '[]'::jsonb))
  from core.map_campuses c where c.organization_id = p_organization_id and c.published;
$$;

create function core.map_get_campus(p_campus_id text)
returns jsonb language sql stable security definer set search_path = '' as $$
  select c.document || jsonb_build_object('schema_version', 1, 'id', c.id, 'organization_id', c.organization_id,
    'revision', c.revision, 'updated_at', c.updated_at, 'can_moderate', core.map_is_moderator(c.organization_id))
  from core.map_campuses c where c.id = p_campus_id and c.published;
$$;

create function core.map_room_verification(p_campus_id text, p_room_id text, p_revision bigint)
returns jsonb language sql stable set search_path = '' as $$
  select jsonb_build_object('confirmation_count', count(*), 'last_confirmed_at', max(confirmed_at),
    'confirmed_by_me', coalesce(bool_or(user_id = auth.uid()), false))
  from core.map_room_confirmations
  where campus_id = p_campus_id and room_id = p_room_id and revision = p_revision;
$$;

create function core.map_find_room(p_document jsonb, p_room_id text)
returns jsonb language sql immutable set search_path = '' as $$
  with rooms as (select value from jsonb_array_elements(p_document->'rooms'))
  select coalesce(
    (select value from rooms where value->>'id' = p_room_id),
    (select jsonb_agg(value)->0 from rooms where (value->'legacy_ids') ? p_room_id having count(*) = 1)
  );
$$;

create function core.map_get_room(p_campus_id text, p_room_id text, p_date date)
returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare
  v_campus core.map_campuses;
  v_room jsonb;
  v_classroom uuid;
  v_schedule_campus uuid;
  v_schedule jsonb := '[]'::jsonb;
begin
  if p_date is null or p_date not between current_date - 366 and current_date + 366 then
    raise exception 'Date outside supported range' using errcode = '22023';
  end if;
  select * into v_campus from core.map_campuses where id = p_campus_id and published;
  if not found then return null; end if;
  v_room := core.map_find_room(v_campus.document, p_room_id);
  if v_room is null then return null; end if;
  select id into v_classroom from core.schedule_classrooms
  where id = (v_room->>'schedule_classroom_id')::uuid and organization_id = v_campus.organization_id;
  if v_classroom is null and not (v_room ? 'schedule_classroom_id') then
    select (array_agg(id))[1] into v_schedule_campus from core.schedule_campuses
    where organization_id = v_campus.organization_id
      and normalized_name = lower(regexp_replace(btrim(v_campus.document->>'short_title'), '\s+', ' ', 'g'))
    having count(*) = 1;
    if v_schedule_campus is not null then
      select (array_agg(id))[1] into v_classroom from core.schedule_classrooms
      where organization_id = v_campus.organization_id and campus_id = v_schedule_campus
        and normalized_name = lower(regexp_replace(btrim(v_room->>'label'), '\s+', ' ', 'g'))
      having count(*) = 1;
    end if;
  end if;
  if v_classroom is not null then
    select coalesce(jsonb_agg(payload order by start_time, title), '[]'::jsonb) into v_schedule
    from (
      select item.start_time, item.title,
        jsonb_build_object('id', item.id, 'title', item.title, 'kind', item.kind,
          'lesson_type', item.lesson_type, 'start_time', item.start_time, 'end_time', item.end_time,
          'groups', (select coalesce(jsonb_agg(g.name order by g.name), '[]'::jsonb)
            from core.schedule_item_group l join core.schedule_groups g on g.id = l.group_id
            where l.item_id = item.id and g.organization_id = v_campus.organization_id),
          'teachers', (select coalesce(jsonb_agg(t.full_name order by t.full_name), '[]'::jsonb)
            from core.schedule_item_teacher l join core.schedule_teachers t on t.id = l.teacher_id
            where l.item_id = item.id and t.organization_id = v_campus.organization_id)) payload
      from core.schedule_item item
      join core.schedule_item_classroom link on link.item_id = item.id and link.classroom_id = v_classroom
      where item.organization_id = v_campus.organization_id and p_date = any(item.dates)
      order by item.start_time, item.id limit 100
    ) events;
  end if;
  return jsonb_build_object('room', v_room, 'date', p_date, 'timezone', 'Europe/Moscow',
    'schedule_linked', v_classroom is not null, 'schedule', v_schedule,
    'verification', core.map_room_verification(p_campus_id, v_room->>'id', v_campus.revision),
    'revision', v_campus.revision, 'can_moderate', core.map_is_moderator(v_campus.organization_id));
end;
$$;

create function core.map_submit_proposal(p_campus_id text, p_base_revision bigint, p_entity_type text,
  p_entity_id text, p_patch jsonb, p_reason text)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare
  v_uid uuid := auth.uid();
  v_campus core.map_campuses;
  v_proposal core.map_proposals;
begin
  if v_uid is null or not exists (select 1 from auth.users where id = v_uid and not coalesce(is_anonymous, false)) then
    raise exception 'Authentication required' using errcode = '42501';
  end if;
  perform pg_advisory_xact_lock(hashtextextended('map-proposal:' || v_uid::text, 0));
  select * into v_campus from core.map_campuses where id = p_campus_id and published for share;
  if not found then raise exception 'Campus unavailable' using errcode = '22023'; end if;
  if not exists (select 1 from core.user_academic_profiles where user_id = v_uid and organization_id = v_campus.organization_id)
    and not core.map_is_moderator(v_campus.organization_id) then
    raise exception 'Campus organization membership required' using errcode = '42501';
  end if;
  if p_base_revision is distinct from v_campus.revision then
    raise exception 'Map changed; reload before submitting' using errcode = '40001';
  end if;
  if coalesce(length(btrim(p_reason)), 0) not between 5 and 3000 then
    raise exception 'Explain the proposed change' using errcode = '22023';
  end if;
  if (select count(*) from core.map_proposals where author_id = v_uid and created_at > now() - interval '1 hour') >= 20
    or (select count(*) from core.map_proposals where author_id = v_uid and status = 'pending') >= 100 then
    raise exception 'Too many map proposals; try later' using errcode = 'P0001';
  end if;
  if p_entity_type in ('campus','graph') and p_entity_id is distinct from p_campus_id then
    raise exception 'Invalid map entity' using errcode = '22023';
  end if;
  if p_entity_type = 'report' and p_entity_id is distinct from p_campus_id
    and not exists (select 1 from jsonb_array_elements(v_campus.document->'floors') where value->>'id' = p_entity_id)
    and not exists (select 1 from jsonb_array_elements(v_campus.document->'rooms') where value->>'id' = p_entity_id) then
    raise exception 'Report target not found' using errcode = '22023';
  end if;
  perform core.map_patch_document(v_campus.document, p_entity_type, p_entity_id, p_patch);
  insert into core.map_proposals (campus_id, base_revision, entity_type, entity_id, patch, reason, author_id)
  values (p_campus_id, p_base_revision, p_entity_type, p_entity_id, p_patch, btrim(p_reason), v_uid)
  returning * into v_proposal;
  return core.map_proposal_json(v_proposal, core.map_is_moderator(v_campus.organization_id));
end;
$$;

create function core.map_get_proposals(p_campus_id text, p_status text, p_limit integer)
returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare
  v_org text;
  v_mod boolean;
  v_proposals jsonb;
begin
  if auth.uid() is null or not exists (select 1 from auth.users where id = auth.uid() and not coalesce(is_anonymous, false)) then
    raise exception 'Authentication required' using errcode = '42501';
  end if;
  if p_status is not null and p_status not in ('pending','approved','rejected','all') then
    raise exception 'Invalid proposal status' using errcode = '22023';
  end if;
  select organization_id into v_org from core.map_campuses where id = p_campus_id and published;
  v_mod := core.map_is_moderator(v_org);
  select coalesce(jsonb_agg(core.map_proposal_json(p::core.map_proposals, v_mod) order by p.created_at desc, p.id), '[]'::jsonb)
  into v_proposals from (
    select proposal.* from core.map_proposals proposal
    where proposal.campus_id = p_campus_id and v_org is not null
      and (v_mod or proposal.author_id = auth.uid())
      and (p_status is null or p_status = 'all' or proposal.status = p_status)
    order by proposal.created_at desc, proposal.id limit greatest(1, least(coalesce(p_limit, 50), 100))) p;
  return jsonb_build_object('can_moderate', v_mod, 'proposals', v_proposals);
end;
$$;

create function core.map_get_proposal(p_proposal_id uuid)
returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare
  v_proposal core.map_proposals;
  v_org text;
  v_mod boolean;
begin
  if auth.uid() is null or not exists(select 1 from auth.users where id = auth.uid() and not coalesce(is_anonymous, false)) then
    raise exception 'Authentication required' using errcode = '42501';
  end if;
  select p.* into v_proposal from core.map_proposals p
    join core.map_campuses c on c.id = p.campus_id and c.published where p.id = p_proposal_id;
  if not found then raise exception 'Proposal unavailable' using errcode = '42501'; end if;
  select organization_id into v_org from core.map_campuses where id = v_proposal.campus_id;
  v_mod := core.map_is_moderator(v_org);
  if not v_mod and v_proposal.author_id is distinct from auth.uid() then
    raise exception 'Proposal unavailable' using errcode = '42501';
  end if;
  return core.map_proposal_json(v_proposal, v_mod, true);
end;
$$;

create function core.map_review_proposal(p_proposal_id uuid, p_decision text, p_note text)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare
  v_campus core.map_campuses;
  v_proposal core.map_proposals;
  v_document jsonb;
begin
  if auth.uid() is null or not exists (select 1 from auth.users where id = auth.uid() and not coalesce(is_anonymous, false)) then
    raise exception 'Authentication required' using errcode = '42501';
  end if;
  if p_decision is null or p_decision not in ('approved','rejected') or coalesce(length(p_note), 0) > 3000 then
    raise exception 'Invalid moderation decision' using errcode = '22023';
  end if;
  select * into v_proposal from core.map_proposals where id = p_proposal_id for update;
  if not found then raise exception 'Proposal unavailable' using errcode = '42501'; end if;
  select * into v_campus from core.map_campuses where id = v_proposal.campus_id and published for update;
  if not found or not core.map_is_moderator(v_campus.organization_id) then
    raise exception 'Map moderator permission required' using errcode = '42501';
  end if;
  if v_proposal.author_id = auth.uid() then
    raise exception 'A second moderator must review your proposal' using errcode = '42501';
  end if;
  if v_proposal.status <> 'pending' then
    raise exception 'Proposal already reviewed' using errcode = '40001';
  end if;
  if p_decision = 'rejected' and coalesce(length(btrim(p_note)), 0) < 5 then
    raise exception 'Explain why the proposal was rejected' using errcode = '22023';
  end if;
  if p_decision = 'approved' and v_proposal.entity_type <> 'report' then
    if v_proposal.base_revision <> v_campus.revision then
      raise exception 'Map changed; request a proposal against the latest revision' using errcode = '40001';
    end if;
    v_document := core.map_patch_document(v_campus.document, v_proposal.entity_type, v_proposal.entity_id, v_proposal.patch);
    update core.map_campuses set document = v_document, revision = revision + 1, updated_at = now()
      where id = v_campus.id returning * into v_campus;
    insert into core.map_revisions (campus_id, revision, document, proposal_id, published_by)
      values (v_campus.id, v_campus.revision, v_document, v_proposal.id, auth.uid());
  end if;
  update core.map_proposals set status = p_decision, reviewed_by = auth.uid(), reviewed_at = now(), review_note = nullif(btrim(p_note), '')
  where id = p_proposal_id returning * into v_proposal;
  return core.map_proposal_json(v_proposal, true);
end;
$$;

create function core.map_publish_campus(p_campus_id text, p_organization_id text, p_document jsonb, p_expected_revision bigint)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare
  v_campus core.map_campuses;
  v_document jsonb := p_document - array['id','organization_id','revision','updated_at','can_moderate'];
begin
  if coalesce(length(p_campus_id), 0) not between 1 and 120 or p_expected_revision is null or p_expected_revision < 0 then
    raise exception 'Invalid campus identity or revision' using errcode = '22023';
  end if;
  perform core.map_validate_document(v_document);
  perform pg_advisory_xact_lock(hashtextextended('map-publish:' || p_campus_id, 0));
  select * into v_campus from core.map_campuses where id = p_campus_id for update;
  if found then
    if v_campus.organization_id <> p_organization_id or v_campus.revision <> p_expected_revision then
      raise exception 'Campus identity or revision conflict' using errcode = '40001';
    end if;
    update core.map_campuses set document = v_document, revision = revision + 1, updated_at = now(), published = true
      where id = p_campus_id returning * into v_campus;
  else
    if p_expected_revision <> 0 then raise exception 'Campus revision conflict' using errcode = '40001'; end if;
    insert into core.map_campuses(id, organization_id, document) values (p_campus_id, p_organization_id, v_document)
      returning * into v_campus;
  end if;
  insert into core.map_revisions(campus_id, revision, document) values (v_campus.id, v_campus.revision, v_document);
  return jsonb_build_object('id', v_campus.id, 'revision', v_campus.revision, 'updated_at', v_campus.updated_at);
end;
$$;

create function core.map_get_bookmarks()
returns jsonb language plpgsql stable security definer set search_path = '' as $$
begin
  if auth.uid() is null or not exists (select 1 from auth.users where id = auth.uid() and not coalesce(is_anonymous, false)) then
    raise exception 'Authentication required' using errcode = '42501';
  end if;
  return jsonb_build_object('bookmarks', (
    select coalesce(jsonb_agg(jsonb_build_object('campus_id', saved.campus_id, 'room_id', saved.room_id,
      'saved_at', saved.saved_at, 'room_label', saved.room_label, 'campus_title', saved.campus_title)
      order by saved.saved_at desc, saved.campus_id, saved.room_id), '[]'::jsonb)
    from (
      select distinct on (b.campus_id, r.value->>'id') b.campus_id, r.value->>'id' as room_id,
        b.saved_at, r.value->'label' as room_label, c.document->'title' as campus_title
      from core.map_bookmarks b join core.map_campuses c on c.id = b.campus_id and c.published
      cross join lateral jsonb_array_elements(c.document->'rooms') r
      where b.user_id = auth.uid() and (r.value->>'id' = b.room_id or (r.value->'legacy_ids') ? b.room_id)
      order by b.campus_id, r.value->>'id', b.saved_at desc
    ) saved
  ));
end;
$$;

create function core.map_set_bookmark(p_campus_id text, p_room_id text, p_saved boolean)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare
  v_room jsonb;
  v_room_id text;
begin
  if auth.uid() is null or not exists (select 1 from auth.users where id = auth.uid() and not coalesce(is_anonymous, false)) then
    raise exception 'Authentication required' using errcode = '42501';
  end if;
  if p_saved is null then raise exception 'Saved state required' using errcode = '22023'; end if;
  perform pg_advisory_xact_lock(hashtextextended('map-bookmark:' || auth.uid()::text, 0));
  select core.map_find_room(document, p_room_id) into v_room from core.map_campuses where id = p_campus_id and published;
  v_room_id := coalesce(v_room->>'id',p_room_id);
  if p_saved then
    if v_room is null then
      raise exception 'Map room unavailable' using errcode = '22023';
    end if;
    delete from core.map_bookmarks where user_id = auth.uid() and campus_id = p_campus_id
      and room_id <> v_room_id and (v_room->'legacy_ids') ? room_id;
    if not exists (select 1 from core.map_bookmarks where user_id = auth.uid() and campus_id = p_campus_id and room_id = v_room_id)
      and (select count(*) from core.map_bookmarks where user_id = auth.uid()) >= 500 then
      raise exception 'Saved places limit reached' using errcode = 'P0001';
    end if;
    insert into core.map_bookmarks(user_id,campus_id,room_id) values (auth.uid(),p_campus_id,v_room_id)
      on conflict (user_id,campus_id,room_id) do nothing;
  else
    delete from core.map_bookmarks where user_id = auth.uid() and campus_id = p_campus_id
      and (room_id = p_room_id or room_id = v_room_id or (v_room->'legacy_ids') ? room_id);
  end if;
  return jsonb_build_object('saved', p_saved);
end;
$$;

create function core.map_confirm_room(p_campus_id text, p_room_id text, p_base_revision bigint, p_confirmed boolean)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare
  v_campus core.map_campuses;
  v_room jsonb;
begin
  if auth.uid() is null or not exists (select 1 from auth.users where id = auth.uid() and not coalesce(is_anonymous, false)) then
    raise exception 'Authentication required' using errcode = '42501';
  end if;
  if p_confirmed is null then raise exception 'Confirmation state required' using errcode = '22023'; end if;
  select * into v_campus from core.map_campuses where id = p_campus_id and published for share;
  v_room := core.map_find_room(v_campus.document, p_room_id);
  if v_room is null then
    raise exception 'Map room unavailable' using errcode = '22023';
  end if;
  if not exists (select 1 from core.user_academic_profiles where user_id = auth.uid() and organization_id = v_campus.organization_id)
    and not core.map_is_moderator(v_campus.organization_id) then
    raise exception 'Campus organization membership required' using errcode = '42501';
  end if;
  if p_confirmed then
    if p_base_revision is distinct from v_campus.revision then
      raise exception 'Map changed; reload before confirming' using errcode = '40001';
    end if;
    insert into core.map_room_confirmations(user_id,campus_id,room_id,revision)
      values (auth.uid(),p_campus_id,v_room->>'id',v_campus.revision)
    on conflict (user_id,campus_id,room_id) do update set revision = excluded.revision, confirmed_at = now();
  else
    delete from core.map_room_confirmations where user_id = auth.uid() and campus_id = p_campus_id and room_id = v_room->>'id';
  end if;
  return core.map_room_verification(p_campus_id,v_room->>'id',v_campus.revision);
end;
$$;

create function app_api_v1.get_map_bookmarks()
returns jsonb language sql stable security invoker set search_path = '' as $$ select core.map_get_bookmarks(); $$;
create function app_api_v1.set_map_bookmark(p_campus_id text, p_room_id text, p_saved boolean)
returns jsonb language sql security invoker set search_path = '' as $$ select core.map_set_bookmark(p_campus_id,p_room_id,p_saved); $$;
create function app_api_v1.confirm_map_room(p_campus_id text, p_room_id text, p_base_revision bigint, p_confirmed boolean default true)
returns jsonb language sql security invoker set search_path = '' as $$ select core.map_confirm_room(p_campus_id,p_room_id,p_base_revision,p_confirmed); $$;
create function app_api_v1.get_map_catalog(p_organization_id text default 'mirea')
returns jsonb language sql stable security invoker set search_path = '' as $$ select core.map_get_catalog(p_organization_id); $$;
create function app_api_v1.get_map_campus(p_campus_id text)
returns jsonb language sql stable security invoker set search_path = '' as $$ select core.map_get_campus(p_campus_id); $$;
create function app_api_v1.get_map_room(p_campus_id text, p_room_id text, p_date date default current_date)
returns jsonb language sql stable security invoker set search_path = '' as $$ select core.map_get_room(p_campus_id, p_room_id, p_date); $$;
create function app_api_v1.submit_map_proposal(p_campus_id text, p_base_revision bigint, p_entity_type text, p_entity_id text, p_patch jsonb, p_reason text)
returns jsonb language sql security invoker set search_path = '' as $$ select core.map_submit_proposal(p_campus_id, p_base_revision, p_entity_type, p_entity_id, p_patch, p_reason); $$;
create function app_api_v1.get_map_proposals(p_campus_id text, p_status text default 'pending', p_limit integer default 50)
returns jsonb language sql stable security invoker set search_path = '' as $$ select core.map_get_proposals(p_campus_id, p_status, p_limit); $$;
create function app_api_v1.get_map_proposal(p_proposal_id uuid)
returns jsonb language sql stable security invoker set search_path = '' as $$ select core.map_get_proposal(p_proposal_id); $$;
create function app_api_v1.review_map_proposal(p_proposal_id uuid, p_decision text, p_note text default null)
returns jsonb language sql security invoker set search_path = '' as $$ select core.map_review_proposal(p_proposal_id, p_decision, p_note); $$;
create function app_api_v1.publish_map_campus(p_campus_id text, p_organization_id text, p_document jsonb, p_expected_revision bigint default 0)
returns jsonb language sql security invoker set search_path = '' as $$ select core.map_publish_campus(p_campus_id, p_organization_id, p_document, p_expected_revision); $$;

revoke all on function core.map_is_moderator(text), core.map_number(jsonb,numeric,numeric),
  core.map_strings(jsonb,text[]),
  core.map_find_room(jsonb,text),
  core.map_validate_document(jsonb), core.map_patch_document(jsonb,text,text,jsonb),
  core.map_proposal_json(core.map_proposals,boolean,boolean), core.map_get_catalog(text), core.map_get_campus(text),
  core.map_get_room(text,text,date), core.map_submit_proposal(text,bigint,text,text,jsonb,text),
  core.map_get_proposals(text,text,integer), core.map_get_proposal(uuid), core.map_review_proposal(uuid,text,text),
  core.map_publish_campus(text,text,jsonb,bigint) from public, anon, authenticated;
revoke all on function core.map_room_verification(text,text,bigint), core.map_get_bookmarks(), core.map_set_bookmark(text,text,boolean),
  core.map_confirm_room(text,text,bigint,boolean), app_api_v1.get_map_bookmarks(), app_api_v1.set_map_bookmark(text,text,boolean),
  app_api_v1.confirm_map_room(text,text,bigint,boolean) from public, anon, authenticated;
revoke all on function app_api_v1.get_map_catalog(text), app_api_v1.get_map_campus(text),
  app_api_v1.get_map_room(text,text,date), app_api_v1.submit_map_proposal(text,bigint,text,text,jsonb,text),
  app_api_v1.get_map_proposals(text,text,integer), app_api_v1.get_map_proposal(uuid), app_api_v1.review_map_proposal(uuid,text,text),
  app_api_v1.publish_map_campus(text,text,jsonb,bigint) from public, anon, authenticated;
grant execute on function core.map_get_catalog(text), core.map_get_campus(text), core.map_get_room(text,text,date),
  app_api_v1.get_map_catalog(text), app_api_v1.get_map_campus(text), app_api_v1.get_map_room(text,text,date) to anon, authenticated, service_role;
grant execute on function core.map_submit_proposal(text,bigint,text,text,jsonb,text), core.map_get_proposals(text,text,integer),
  core.map_get_proposal(uuid), app_api_v1.get_map_proposal(uuid),
  core.map_review_proposal(uuid,text,text), app_api_v1.submit_map_proposal(text,bigint,text,text,jsonb,text),
  app_api_v1.get_map_proposals(text,text,integer), app_api_v1.review_map_proposal(uuid,text,text) to authenticated;
grant execute on function core.map_publish_campus(text,text,jsonb,bigint), app_api_v1.publish_map_campus(text,text,jsonb,bigint) to service_role;
grant execute on function core.map_get_bookmarks(), core.map_set_bookmark(text,text,boolean), core.map_confirm_room(text,text,bigint,boolean),
  app_api_v1.get_map_bookmarks(), app_api_v1.set_map_bookmark(text,text,boolean), app_api_v1.confirm_map_room(text,text,bigint,boolean) to authenticated;

notify pgrst, 'reload schema';
