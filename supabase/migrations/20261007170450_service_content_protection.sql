create function internal.enforce_miniapp_action(
  p_user_id uuid, p_slug text, p_action text, p_payload jsonb default '{}'::jsonb
) returns void
language plpgsql security definer set search_path = ''
as $$
declare
  v_read boolean;
  v_shared boolean := false;
  v_content boolean;
  v_limits integer[] := array[30, 180, 1000];
begin
  v_read := case p_slug
    when 'teacher-reviews' then p_action in ('state', 'search', 'top')
    when 'iskra' then p_action in ('state', 'candidate', 'matches', 'moderation_queue')
    when 'queue' then p_action in ('state', 'resolve')
    when 'student-discounts' then p_action in ('state', 'moderation_queue')
    when 'learning-roadmap' then p_action in ('home', 'catalog', 'plan', 'compare')
    else false
  end;
  v_shared := case p_slug
    when 'teacher-reviews' then p_action = 'review'
      or (p_action = 'vote' and p_payload ->> 'helpful' = 'true')
    when 'iskra' then p_action in ('save_profile', 'reserve_photo', 'set_photo', 'resume', 'decide', 'report', 'set_contact')
    when 'queue' then p_action not in ('state', 'resolve', 'leave', 'delete')
    when 'student-discounts' then p_action in ('suggest', 'report')
    else false
  end;
  v_content := not coalesce(v_read, false) and not coalesce(case p_slug
    when 'teacher-reviews' then p_action in ('settings', 'delete_review')
      or (p_action = 'vote' and p_payload ->> 'helpful' = 'false')
      or (p_action = 'follow' and p_payload ->> 'follow' = 'false')
    when 'iskra' then p_action in ('confirm_adult', 'cancel_photo', 'pause', 'revoke_contact', 'delete_profile')
    when 'queue' then p_action in ('leave', 'delete')
    when 'student-discounts' then p_action in ('withdraw', 'settings')
      or (p_action = 'favorite' and p_payload ->> 'saved' = 'false')
    when 'learning-roadmap' then p_action = 'save_filters'
    else false
  end, false);
  if v_content then
    perform internal.require_permanent_content_actor(p_user_id, coalesce(v_shared, false));
  else
    perform internal.require_content_actor(p_user_id, false);
  end if;
  if coalesce(v_read, false) then return; end if;
  if p_action is null or char_length(p_action) not between 1 and 64 then
    raise exception 'Invalid action' using errcode = '22023';
  end if;
  if p_slug = 'teacher-reviews' and p_action = 'review' then
    return;
  end if;
  if p_slug = 'iskra' and p_action = 'reserve_photo' then
    v_limits := array[5, 15, 30];
  elsif p_slug = 'teacher-reviews' and p_action = 'vote' then
    v_limits := array[10, 30, 100];
  elsif p_slug = 'queue' and p_action = 'create' then
    v_limits := array[3, 10, 20];
  elsif p_slug = 'student-discounts' and p_action in ('suggest', 'report') then
    v_limits := array[3, 10, 20];
  end if;
  perform core.enforce_content_write_limit(
    'miniapp:' || p_slug || ':' || p_action,
    v_limits[1], v_limits[2], v_limits[3], p_user_id => p_user_id
  );
end;
$$;

revoke all on function internal.enforce_miniapp_action(uuid, text, text, jsonb)
from public, anon, authenticated;
grant usage on schema internal to service_role;
grant execute on function internal.enforce_miniapp_action(uuid, text, text, jsonb)
to service_role;

do $$
declare
  v_target record;
  v_function regprocedure;
  v_definition text;
  v_marker text;
  v_guard text;
begin
  for v_target in select * from (values
    ('miniapp_teacher_reviews.dispatch(uuid,text,jsonb)', 'teacher-reviews', 'p_payload'),
    ('miniapp_iskra.dispatch(uuid,text,jsonb)', 'iskra', 'p_payload'),
    ('miniapp_queue.dispatch(uuid,text,jsonb)', 'queue', 'p_payload'),
    ('miniapp_student_discounts.dispatch(uuid,text,jsonb)', 'student-discounts', 'p_payload'),
    ('public.miniapp_learning_roadmap(uuid,text,jsonb)', 'learning-roadmap', 'p_params')
  ) as targets(signature, slug, payload_name)
  loop
    v_function := to_regprocedure(v_target.signature);
    if v_function is null then continue; end if;
    v_definition := pg_get_functiondef(v_function);
    if position('internal.enforce_miniapp_action' in v_definition) > 0 then
      raise exception 'Mini app guard already exists: %', v_target.signature;
    end if;
    v_marker := case v_target.slug
      when 'iskra' then E'  if p_action = ''enqueue_cleanup'' then'
      else E'begin\n'
    end;
    if position(v_marker in v_definition) = 0 then
      raise exception 'Mini app dispatch changed: %', v_target.signature;
    end if;
    v_guard := format(E'  perform internal.enforce_miniapp_action(p_user_id, %L, p_action, %s);\n',
      v_target.slug, v_target.payload_name);
    if v_target.slug = 'iskra' then
      v_definition := replace(v_definition, v_marker, v_guard || v_marker);
    else
      v_definition := overlay(v_definition placing v_marker || v_guard
        from position(v_marker in v_definition) for char_length(v_marker));
    end if;
    execute v_definition;
  end loop;
end;
$$;

create table internal.mini_app_request_audit (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default clock_timestamp(),
  user_id uuid not null,
  organization_id text not null,
  slug text not null,
  kind text not null check (kind in ('screen', 'api')),
  path text not null,
  method text not null,
  ip_address inet,
  user_agent text,
  allowed boolean not null,
  reason text
);
create index mini_app_request_audit_actor_idx
on internal.mini_app_request_audit(user_id, created_at desc);
create index mini_app_request_audit_ip_idx
on internal.mini_app_request_audit(ip_address, created_at desc) where ip_address is not null;
alter table internal.mini_app_request_audit enable row level security;
revoke all on internal.mini_app_request_audit from public, anon, authenticated, service_role;
revoke all on sequence internal.mini_app_request_audit_id_seq from public, anon, authenticated, service_role;

create function public.record_mini_app_request(
  p_user_id uuid, p_organization_id text, p_slug text, p_kind text,
  p_path text, p_method text, p_ip_address text default null,
  p_user_agent text default null
) returns jsonb
language plpgsql security definer set search_path = ''
as $$
declare
  v_ip inet;
  v_reason text;
  v_count bigint;
  v_store_audit boolean := true;
begin
  if p_user_id is null or p_kind not in ('screen', 'api') or p_kind is null
    or char_length(p_slug) not between 3 and 40 or p_slug is null
    or char_length(p_organization_id) not between 1 and 128 or p_organization_id is null
    or char_length(p_path) > 1024 or p_path is null
    or p_method not in ('GET', 'POST', 'PUT', 'PATCH', 'DELETE') or p_method is null then
    raise exception 'Invalid request context' using errcode = '22023';
  end if;
  begin
    v_ip := nullif(p_ip_address, '')::inet;
  exception when invalid_text_representation then v_ip := null;
  end;
  begin
    perform internal.require_content_actor(p_user_id, false);
  exception when insufficient_privilege then v_reason := 'account_unavailable';
  end;
  perform pg_advisory_xact_lock(hashtextextended('miniapp-audit-actor:' || p_user_id::text, 0));
  select count(*) into v_count from internal.mini_app_request_audit a
  where a.user_id = p_user_id and a.created_at > clock_timestamp() - interval '1 minute';
  if v_count >= 180 then
    return jsonb_build_object('allowed', false, 'reason', coalesce(v_reason, 'rate_limited'));
  end if;
  if v_ip is not null then
    perform pg_advisory_xact_lock(hashtextextended('miniapp-network:' || host(v_ip), 0));
    select count(*) into v_count from internal.mini_app_request_audit a
    where a.ip_address = v_ip
      and a.created_at > clock_timestamp() - interval '1 minute';
    if v_count >= 600 then
      v_store_audit := false;
      if p_kind = 'api' and v_reason is null then v_reason := 'rate_limited'; end if;
    elsif v_reason is null and p_kind = 'api' then
      select count(*) into v_count from internal.mini_app_request_audit a
      where a.ip_address = v_ip and a.kind = 'api' and a.allowed
        and a.created_at > clock_timestamp() - interval '1 minute';
      if v_count >= 300 then v_reason := 'rate_limited'; end if;
    end if;
  end if;
  if v_store_audit then
    insert into internal.mini_app_request_audit(
      user_id, organization_id, slug, kind, path, method, ip_address, user_agent, allowed, reason
    ) values (
      p_user_id, p_organization_id, p_slug, p_kind, p_path, p_method, v_ip,
      left(p_user_agent, 512), v_reason is null, v_reason
    );
  end if;
  return jsonb_build_object('allowed', v_reason is null, 'reason', v_reason);
end;
$$;
revoke all on function public.record_mini_app_request(uuid, text, text, text, text, text, text, text)
from public, anon, authenticated;
grant execute on function public.record_mini_app_request(uuid, text, text, text, text, text, text, text)
to service_role;

select cron.schedule('purge-mini-app-request-audit', '43 3 * * *',
  $cron$delete from internal.mini_app_request_audit where created_at < clock_timestamp() - interval '30 days'$cron$);
