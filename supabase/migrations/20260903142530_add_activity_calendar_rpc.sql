create or replace function app_api_v1.get_activity_calendar(p_days int default 140)
returns table(day date, count int)
language sql stable security invoker set search_path = ''
as $$
  with bounds as (
    select
      ((now() at time zone 'UTC')::date) - (greatest(p_days, 1) - 1) as first_day,
      ((now() at time zone 'UTC')::date) as last_day
  ),
  days as (
    select generate_series(
      (select first_day from bounds),
      (select last_day from bounds),
      interval '1 day'
    )::date as day
  ),
  events as (
    select (l.created_at at time zone 'UTC')::date as day, count(*) as cnt
    from core.shuriken_ledger l
    where l.user_id = (select auth.uid())
      and l.created_at >= (select first_day from bounds)
    group by 1
    union all
    select (q.completed_at at time zone 'UTC')::date as day, count(*) as cnt
    from core.user_quest_progress q
    where q.user_id = (select auth.uid())
      and q.completed_at is not null
      and q.completed_at >= (select first_day from bounds)
    group by 1
  ),
  merged as (
    select day, sum(cnt)::int as cnt from events group by day
  )
  select
    d.day,
    case
      when exists (
        select 1 from core.user_active_days a
        where a.user_id = (select auth.uid()) and a.active_on = d.day
      )
      then greatest(coalesce(m.cnt, 0), 1)
      else coalesce(m.cnt, 0)
    end as count
  from days d
  left join merged m on m.day = d.day
  order by d.day;
$$;

revoke all on function app_api_v1.get_activity_calendar(int) from public, anon;
grant execute on function app_api_v1.get_activity_calendar(int) to authenticated;

create or replace function public.get_activity_calendar(p_days int default 140)
returns table(day date, count int)
language sql stable security invoker set search_path = ''
as $$ select * from app_api_v1.get_activity_calendar(p_days); $$;

revoke all on function public.get_activity_calendar(int) from public;
grant execute on function public.get_activity_calendar(int) to authenticated;
