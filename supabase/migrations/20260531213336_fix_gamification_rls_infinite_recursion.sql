-- Fix: the "leaderboard read" SELECT policy on user_gamification_profiles
-- queried the same table in its USING clause, causing infinite recursion.
-- Drop it and move leaderboard access to a SECURITY DEFINER function in the
-- non-exposed app_api_v1 schema (already done in 20260531203803).

drop policy if exists "users in same org can see leaderboard data"
  on core.user_gamification_profiles;

-- Refresh get_leaderboard to explicitly be SECURITY DEFINER (idempotent).
create or replace function app_api_v1.get_leaderboard(
  p_organization_id text,
  p_scope text default 'group',
  p_limit int default 50
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
begin
  if v_uid is null then raise exception 'Unauthorized'; end if;
  return coalesce(
    (select jsonb_agg(r) from (
      select jsonb_build_object(
        'userId', p.user_id,
        'displayName', coalesce(au.raw_user_meta_data->>'full_name', 'Студент'),
        'xp', p.xp, 'level', p.level, 'streakDays', p.streak_days,
        'isCurrentUser', p.user_id = v_uid
      ) as r
      from core.user_gamification_profiles p
      join auth.users au on au.id = p.user_id
      where p.organization_id = p_organization_id
      order by p.xp desc
      limit p_limit
    ) sub),
    '[]'::jsonb
  );
end;
$$;

create or replace function public.get_leaderboard(
  p_organization_id text,
  p_scope text default 'group',
  p_limit int default 50
)
returns jsonb language sql security invoker set search_path = ''
as $$ select app_api_v1.get_leaderboard(p_organization_id, p_scope, p_limit); $$;

revoke all on function public.get_leaderboard(text, text, int) from public;
grant execute on function public.get_leaderboard(text, text, int) to authenticated;
