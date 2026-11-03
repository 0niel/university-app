create table internal.rating_write_audit (
  id uuid primary key default extensions.gen_random_uuid(),
  user_id uuid not null,
  source_table text not null check (source_table in (
    'core.teacher_reviews', 'core.lesson_reviews', 'core.mini_app_ratings'
  )),
  target_key jsonb not null check (jsonb_typeof(target_key) = 'array'),
  session_id uuid,
  ip_address inet,
  operation text not null check (operation in ('INSERT', 'UPDATE')),
  created_at timestamptz not null default clock_timestamp()
);

create index rating_write_audit_network_target_idx
on internal.rating_write_audit(source_table, target_key, ip_address, created_at desc)
include (user_id);
create index rating_write_audit_retention_idx
on internal.rating_write_audit(created_at);

alter table internal.rating_write_audit enable row level security;
revoke all on internal.rating_write_audit from public, anon, authenticated, service_role;

create function internal.protect_rating_network()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_role text := coalesce((select auth.role()), '');
  v_session_claim text := nullif((select auth.jwt()) ->> 'session_id', '');
  v_session_id uuid;
  v_ip inet;
  v_target jsonb;
  v_source text := tg_table_schema || '.' || tg_table_name;
  v_ignored text[] := array['updated_at', 'created_at', 'like_count'];
  v_sql_actor boolean := session_user in ('postgres', 'supabase_admin');
  v_existing boolean;
  v_accounts bigint;
  v_changes bigint;
  v_seen boolean;
  v_now timestamptz;
begin
  if v_user_id is null and v_role <> 'service_role' then
    if v_role = 'authenticated' then
      raise exception 'Требуется вход в аккаунт'
        using errcode = '42501', hint = 'rating_session_unavailable';
    end if;
    return new;
  end if;
  if v_role = 'service_role' then
    v_user_id := new.user_id;
  elsif v_user_id is distinct from new.user_id then
    raise exception 'Нельзя изменять чужую оценку'
      using errcode = '42501', hint = 'rating_actor_mismatch';
  end if;

  if tg_op = 'UPDATE' and to_jsonb(new) - v_ignored = to_jsonb(old) - v_ignored then
    return new;
  end if;
  perform internal.require_content_actor(v_user_id, true);

  if v_session_claim is not null then
    begin
      v_session_id := v_session_claim::uuid;
    exception when invalid_text_representation then
      raise exception 'Требуется повторный вход в аккаунт'
        using errcode = '42501', hint = 'rating_session_unavailable';
    end;
    select s.ip into v_ip from auth.sessions s
    where s.id = v_session_id and s.user_id = v_user_id
      and (s.not_after is null or s.not_after > clock_timestamp());
    if not found then
      raise exception 'Требуется повторный вход в аккаунт'
        using errcode = '42501', hint = 'rating_session_unavailable';
    end if;
  elsif v_role = 'service_role' then
    select s.id, s.ip into v_session_id, v_ip
    from auth.sessions s
    where s.user_id = v_user_id
      and (s.not_after is null or s.not_after > clock_timestamp())
    order by coalesce(s.refreshed_at::timestamptz, s.updated_at, s.created_at) desc nulls last,
      s.created_at desc nulls last, s.id
    limit 1;
    if not found and not v_sql_actor then
      raise exception 'Требуется повторный вход в аккаунт'
        using errcode = '42501', hint = 'rating_session_unavailable';
    end if;
  elsif not v_sql_actor then
    raise exception 'Требуется повторный вход в аккаунт'
      using errcode = '42501', hint = 'rating_session_unavailable';
  end if;
  if v_ip is null and not v_sql_actor then
    raise exception 'Требуется повторный вход в аккаунт'
      using errcode = '42501', hint = 'rating_session_unavailable';
  end if;
  if v_ip is not null then
    v_ip := host(v_ip)::inet;
  end if;

  if tg_table_name = 'teacher_reviews' then
    v_target := jsonb_build_array(new.organization_id, new.teacher_name);
  elsif tg_table_name = 'lesson_reviews' then
    v_target := jsonb_build_array(
      new.organization_id, new.subject_name, new.lesson_date, new.lesson_bells_number
    );
  elsif tg_table_name = 'mini_app_ratings' then
    v_target := jsonb_build_array(new.app_id);
  else
    raise exception 'Unsupported rating table' using errcode = '22023';
  end if;

  perform pg_advisory_xact_lock(hashtextextended(
    'rating-actor:' || v_source || ':' || v_target::text || ':' || v_user_id::text, 0
  ));
  if tg_op = 'INSERT' then
    if tg_table_name = 'teacher_reviews' then
      select exists (select 1 from core.teacher_reviews r
        where r.user_id = new.user_id and r.teacher_name = new.teacher_name)
      into v_existing;
    elsif tg_table_name = 'lesson_reviews' then
      select exists (select 1 from core.lesson_reviews r
        where r.user_id = new.user_id and r.organization_id = new.organization_id
          and r.subject_name = new.subject_name and r.lesson_date = new.lesson_date
          and r.lesson_bells_number = new.lesson_bells_number)
      into v_existing;
    else
      select exists (select 1 from core.mini_app_ratings r
        where r.user_id = new.user_id and r.app_id = new.app_id)
      into v_existing;
    end if;
    if v_existing then
      return new;
    end if;
  end if;

  if v_ip is not null then
    perform pg_advisory_xact_lock(hashtextextended(
      'rating-network:' || v_source || ':' || v_target::text || ':' || host(v_ip), 0
    ));
    v_now := clock_timestamp();
    select count(distinct a.user_id),
      count(*) filter (where a.created_at > v_now - interval '1 hour'),
      coalesce(bool_or(a.user_id = v_user_id), false)
    into v_accounts, v_changes, v_seen
    from internal.rating_write_audit a
    where a.source_table = v_source and a.target_key = v_target and a.ip_address = v_ip
      and a.created_at > v_now - interval '1 day';
    if not v_seen and v_accounts >= 10 then
      raise exception 'Слишком много оценок с одной сети, попробуйте позже'
        using errcode = 'P0001', hint = 'rating_network_account_limit';
    end if;
    if v_changes >= 60 then
      raise exception 'Слишком много изменений оценок, попробуйте позже'
        using errcode = 'P0001', hint = 'rating_network_write_limit';
    end if;
  end if;

  insert into internal.rating_write_audit(
    user_id, source_table, target_key, session_id, ip_address, operation
  ) values (v_user_id, v_source, v_target, v_session_id, v_ip, tg_op);
  return new;
end;
$$;

revoke all on function internal.protect_rating_network()
from public, anon, authenticated, service_role;

create trigger rating_network_protection before insert or update on core.teacher_reviews
for each row execute function internal.protect_rating_network();
create trigger rating_network_protection before insert or update on core.lesson_reviews
for each row execute function internal.protect_rating_network();
create trigger rating_network_protection before insert or update on core.mini_app_ratings
for each row execute function internal.protect_rating_network();

create function public.miniapp_teacher_reviews_session_dispatch(
  p_user_id uuid,
  p_session_id uuid,
  p_action text,
  p_payload jsonb default '{}'::jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_claims text := current_setting('request.jwt.claims', true);
  v_sub text := current_setting('request.jwt.claim.sub', true);
  v_role text := current_setting('request.jwt.claim.role', true);
  v_result jsonb;
begin
  perform internal.require_content_actor(p_user_id, false);
  if not exists (select 1 from auth.sessions s
      where s.id = p_session_id and s.user_id = p_user_id
        and (s.not_after is null or s.not_after > clock_timestamp())) then
    raise exception 'Требуется повторный вход в аккаунт'
      using errcode = '42501', hint = 'rating_session_unavailable';
  end if;

  perform set_config('request.jwt.claims', jsonb_build_object(
    'role', 'service_role', 'sub', p_user_id, 'session_id', p_session_id
  )::text, true);
  perform set_config('request.jwt.claim.sub', p_user_id::text, true);
  perform set_config('request.jwt.claim.role', 'service_role', true);
  begin
    execute 'select public.miniapp_teacher_reviews_dispatch($1, $2, $3)'
      into v_result using p_user_id, p_action, p_payload;
  exception when others then
    perform set_config('request.jwt.claims', coalesce(v_claims, ''), true);
    perform set_config('request.jwt.claim.sub', coalesce(v_sub, ''), true);
    perform set_config('request.jwt.claim.role', coalesce(v_role, ''), true);
    raise;
  end;
  perform set_config('request.jwt.claims', coalesce(v_claims, ''), true);
  perform set_config('request.jwt.claim.sub', coalesce(v_sub, ''), true);
  perform set_config('request.jwt.claim.role', coalesce(v_role, ''), true);
  return v_result;
end;
$$;

revoke all on function public.miniapp_teacher_reviews_session_dispatch(uuid, uuid, text, jsonb)
from public, anon, authenticated;
grant execute on function public.miniapp_teacher_reviews_session_dispatch(uuid, uuid, text, jsonb)
to service_role;

select cron.schedule('purge-rating-write-audit', '51 3 * * *',
  $cron$delete from internal.rating_write_audit
    where created_at < clock_timestamp() - interval '30 days'$cron$);
