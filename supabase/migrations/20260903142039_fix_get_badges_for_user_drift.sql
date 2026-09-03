create or replace function app_api_v1.get_badges_for_user()
returns jsonb language sql stable security invoker set search_path = ''
as $$
  select coalesce(jsonb_agg(jsonb_build_object(
    'id',bd.id,'category',bd.category,'name',bd.name,'description',bd.description,'emoji',bd.emoji,
    'rarity',bd.rarity,'xpReward',bd.xp_reward,'shurikenReward',bd.shuriken_reward,
    'isEarned',coalesce(ub.is_earned,false),'progress',coalesce(ub.progress,0),'earnedAt',ub.earned_at)
    order by bd.category,bd.sort_order),'[]'::jsonb)
  from core.badge_definitions bd
  left join core.user_badges ub on ub.badge_id=bd.id and ub.user_id=(select auth.uid());
$$;

revoke all on function app_api_v1.get_badges_for_user() from public, anon;
grant execute on function app_api_v1.get_badges_for_user() to authenticated;
