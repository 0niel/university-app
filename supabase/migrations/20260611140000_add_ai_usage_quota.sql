-- Daily request quota for the Mirea AI assistant (design: 50 free/day).
-- The `mirea-ai` edge function calls public.consume_ai_request() before each
-- LLM call; the function increments today's counter atomically and tells the
-- caller whether the request is allowed and how much is left.

create table core.ai_usage (
  user_id uuid not null references auth.users(id) on delete cascade,
  day date not null default (now() at time zone 'utc')::date,
  used integer not null default 0,
  primary key (user_id, day)
);

alter table core.ai_usage enable row level security;

create policy "users can read own ai usage"
on core.ai_usage
for select
to authenticated
using ((select auth.uid()) = user_id);

grant select on core.ai_usage to authenticated;
grant all on core.ai_usage to service_role;

create or replace function app_api_v1.consume_ai_request(p_limit integer)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_used integer;
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;

  insert into core.ai_usage (user_id, day, used)
  values (v_user_id, (now() at time zone 'utc')::date, 1)
  on conflict (user_id, day) do update
    set used = core.ai_usage.used + 1
    where core.ai_usage.used < p_limit
  returning used into v_used;

  if v_used is null then
    -- conflict branch refused the update: limit reached
    select used into v_used
    from core.ai_usage
    where user_id = v_user_id
      and day = (now() at time zone 'utc')::date;
    return jsonb_build_object(
      'allowed', false, 'used', coalesce(v_used, p_limit), 'limit', p_limit
    );
  end if;

  return jsonb_build_object(
    'allowed', true, 'used', v_used, 'limit', p_limit
  );
end;
$$;

create or replace function app_api_v1.get_ai_usage(p_limit integer)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select jsonb_build_object(
    'used', coalesce((
      select used from core.ai_usage
      where user_id = (select auth.uid())
        and day = (now() at time zone 'utc')::date
    ), 0),
    'limit', p_limit
  );
$$;

-- public wrappers

create or replace function public.consume_ai_request(p_limit integer)
returns jsonb
language sql
security definer
set search_path = ''
as $$
  select app_api_v1.consume_ai_request(p_limit);
$$;

create or replace function public.get_ai_usage(p_limit integer)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select app_api_v1.get_ai_usage(p_limit);
$$;

revoke all on function public.consume_ai_request(integer) from public, anon;
revoke all on function public.get_ai_usage(integer) from public, anon;
grant execute on function public.consume_ai_request(integer) to authenticated;
grant execute on function public.get_ai_usage(integer) to authenticated;
