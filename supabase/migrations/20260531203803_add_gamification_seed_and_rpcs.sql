-- Badge and quest seed data + app_api_v1 read/write RPCs.

insert into core.badge_definitions (id, category, name, description, emoji, rarity, xp_reward, shuriken_reward, sort_order) values
  ('attendance_early_bird',   'Посещаемость', 'Ранняя пташка',  '5 пар к 9:00',       '🌅', 'common',    20,  10, 10),
  ('attendance_streak14',     'Посещаемость', 'Стрик 14',       '14 дней подряд',     '🔥', 'rare',      50,  25, 20),
  ('attendance_perfect_month','Посещаемость', 'Без прогулов',   'Месяц 100%',         '💯', 'epic',     100,  50, 30),
  ('attendance_sharpshooter', 'Посещаемость', 'Снайпер',        'Никогда не опоздал', '🎯', 'rare',      50,  25, 40),
  ('attendance_owl',          'Посещаемость', 'Сова',           '10 вечерних пар',    '🌙', 'common',    20,  10, 50),
  ('attendance_perfect_sem',  'Посещаемость', 'Идеал',          'Семестр 100%',       '👑', 'legendary', 250, 150, 60),
  ('study_excellent',         'Учёба',        'Отличник',       '5 пятёрок подряд',   '🧠', 'rare',      50,  25, 10),
  ('study_bookworm',          'Учёба',        'Книжный червь',  '50 материалов',      '📚', 'common',    20,  10, 20),
  ('study_ai_ninja',          'Учёба',        'AI-ниндзя',      '100 запросов AI',    '✨', 'rare',      50,  25, 30),
  ('study_top3',              'Учёба',        'Топ-3 группы',   'В тройке месяц',     '🏆', 'epic',     100,  50, 40),
  ('study_gpa50',             'Учёба',        'GPA 5.0',        'Идеальный балл',     '🚀', 'legendary', 250, 150, 50),
  ('community_activist',      'Сообщество',   'Активист',       '100 сообщений',      '💬', 'common',    20,  10, 10),
  ('community_helper',        'Сообщество',   'Помощник',       'Помог 10 раз',       '🤝', 'rare',      50,  25, 20),
  ('community_contributor',   'Сообщество',   'Контрибьютор',   'PR в проект',        '🥷', 'epic',     100,  50, 30),
  ('community_rescuer',       'Сообщество',   'Спасатель',      'Вернул находку',     '🔍', 'rare',      50,  25, 40);

insert into core.quest_definitions (id, period, emoji, title, target, xp_reward, sort_order) values
  ('daily_reaction',   'daily',  '✋', 'Поставь реакцию на паре',    1,  10, 10),
  ('daily_note',       'daily',  '📝', 'Сделай заметку на лекции',   2,  20, 20),
  ('daily_ai',         'daily',  '🧠', 'Спроси AI 3 вопроса',        3,  15, 30),
  ('daily_help',       'daily',  '👥', 'Помоги однокурснику в чате', 1,  25, 40),
  ('weekly_attend',    'weekly', '🎯', 'Посети 90% пар',             12, 150, 10),
  ('weekly_materials', 'weekly', '📚', 'Открой 10 материалов',       10, 100, 20),
  ('weekly_streak',    'weekly', '🔥', 'Удержи стрик 7 дней',        7,  150, 30);

create or replace function app_api_v1.get_gamification_profile()
returns jsonb language sql stable security invoker set search_path = ''
as $$
  select coalesce(
    (select jsonb_build_object('userId',p.user_id,'xp',p.xp,'level',p.level,
        'shurikens',p.shurikens,'streakDays',p.streak_days,'lastActiveDate',p.last_active_date,
        'recentBadge',(select jsonb_build_object('id',bd.id,'name',bd.name,'emoji',bd.emoji,'rarity',bd.rarity)
          from core.user_badges ub join core.badge_definitions bd on bd.id=ub.badge_id
          where ub.user_id=(select auth.uid()) and ub.is_earned=true order by ub.earned_at desc limit 1))
      from core.user_gamification_profiles p where p.user_id=(select auth.uid())),
    '{}'::jsonb);
$$;

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

create or replace function app_api_v1.get_quests_for_user(p_date date default (now() at time zone 'UTC')::date)
returns jsonb language sql stable security invoker set search_path = ''
as $$
  with wk as (select date_trunc('week',p_date::timestamp)::date as ws)
  select coalesce(jsonb_agg(jsonb_build_object(
    'id',qd.id,'period',qd.period,'emoji',qd.emoji,'title',qd.title,'target',qd.target,
    'xpReward',qd.xp_reward,'progress',coalesce(qp.progress,0),
    'isCompleted',coalesce(qp.is_completed,false),'completedAt',qp.completed_at)
    order by qd.period,qd.sort_order),'[]'::jsonb)
  from core.quest_definitions qd
  left join core.user_quest_progress qp on qp.quest_id=qd.id and qp.user_id=(select auth.uid())
    and qp.period_start=case when qd.period='daily' then p_date when qd.period='weekly' then (select ws from wk) end;
$$;

create or replace function app_api_v1.get_squad_challenge(p_organization_id text)
returns jsonb language sql stable security invoker set search_path = ''
as $$
  select coalesce((select jsonb_build_object('id',sc.id,'title',sc.title,'description',sc.description,
    'rewardShurikens',sc.reward_shurikens,'target',sc.target,'progress',sc.progress,'endsAt',sc.ends_at)
    from core.squad_challenges sc where sc.organization_id=p_organization_id and sc.ends_at>now()
    order by sc.ends_at asc limit 1),'{}'::jsonb);
$$;

create or replace function app_api_v1.ensure_gamification_profile(p_organization_id text)
returns jsonb language plpgsql security invoker set search_path = ''
as $$
declare v_uid uuid := (select auth.uid());
begin
  if v_uid is null then raise exception 'Unauthorized'; end if;
  insert into core.user_gamification_profiles (user_id,organization_id)
  values (v_uid,p_organization_id) on conflict (user_id) do nothing;
  return app_api_v1.get_gamification_profile();
end;
$$;

create or replace function app_api_v1.increment_quest_progress(p_quest_id text, p_amount int default 1, p_date date default (now() at time zone 'UTC')::date)
returns jsonb language plpgsql security invoker set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid()); v_quest core.quest_definitions;
  v_period_start date; v_progress int; v_completed boolean;
begin
  if v_uid is null then raise exception 'Unauthorized'; end if;
  select * into v_quest from core.quest_definitions where id=p_quest_id;
  if not found then raise exception 'Quest not found'; end if;
  v_period_start := case when v_quest.period='daily' then p_date
    when v_quest.period='weekly' then date_trunc('week',p_date::timestamp)::date end;
  insert into core.user_quest_progress (user_id,quest_id,period_start,progress)
  values (v_uid,p_quest_id,v_period_start,p_amount)
  on conflict (user_id,quest_id,period_start) do update
    set progress=least(user_quest_progress.progress+p_amount,v_quest.target)
  returning progress into v_progress;
  v_completed := v_progress >= v_quest.target;
  if v_completed then
    update core.user_quest_progress set is_completed=true,completed_at=now()
    where user_id=v_uid and quest_id=p_quest_id and period_start=v_period_start and is_completed=false;
    if found then update core.user_gamification_profiles set xp=xp+v_quest.xp_reward where user_id=v_uid; end if;
  end if;
  return jsonb_build_object('questId',p_quest_id,'progress',v_progress,'target',v_quest.target,
    'isCompleted',v_completed,'xpAwarded',case when v_completed then v_quest.xp_reward else 0 end);
end;
$$;

-- Leaderboard uses SECURITY DEFINER (see 20260531213336 for rationale).
create or replace function app_api_v1.get_leaderboard(p_organization_id text, p_scope text default 'group', p_limit int default 50)
returns jsonb language plpgsql security definer set search_path = ''
as $$
declare v_uid uuid := (select auth.uid());
begin
  if v_uid is null then raise exception 'Unauthorized'; end if;
  return coalesce(
    (select jsonb_agg(r) from (
      select jsonb_build_object('userId',p.user_id,
        'displayName',coalesce(au.raw_user_meta_data->>'full_name','Студент'),
        'xp',p.xp,'level',p.level,'streakDays',p.streak_days,'isCurrentUser',p.user_id=v_uid) as r
      from core.user_gamification_profiles p
      join auth.users au on au.id=p.user_id
      where p.organization_id=p_organization_id
      order by p.xp desc limit p_limit) sub),
    '[]'::jsonb);
end;
$$;

create or replace function public.get_gamification_profile() returns jsonb language sql stable security invoker set search_path = '' as $$ select app_api_v1.get_gamification_profile(); $$;
create or replace function public.get_badges_for_user() returns jsonb language sql stable security invoker set search_path = '' as $$ select app_api_v1.get_badges_for_user(); $$;
create or replace function public.get_quests_for_user(p_date date default null) returns jsonb language sql stable security invoker set search_path = '' as $$ select app_api_v1.get_quests_for_user(coalesce(p_date,(now() at time zone 'UTC')::date)); $$;
create or replace function public.get_leaderboard(p_organization_id text, p_scope text default 'group', p_limit int default 50) returns jsonb language sql stable security invoker set search_path = '' as $$ select app_api_v1.get_leaderboard(p_organization_id,p_scope,p_limit); $$;
create or replace function public.get_squad_challenge(p_organization_id text) returns jsonb language sql stable security invoker set search_path = '' as $$ select app_api_v1.get_squad_challenge(p_organization_id); $$;
create or replace function public.ensure_gamification_profile(p_organization_id text) returns jsonb language sql security invoker set search_path = '' as $$ select app_api_v1.ensure_gamification_profile(p_organization_id); $$;
create or replace function public.increment_quest_progress(p_quest_id text, p_amount int default 1, p_date date default null) returns jsonb language sql security invoker set search_path = '' as $$ select app_api_v1.increment_quest_progress(p_quest_id,p_amount,coalesce(p_date,(now() at time zone 'UTC')::date)); $$;

revoke all on function public.get_gamification_profile() from public; grant execute on function public.get_gamification_profile() to authenticated;
revoke all on function public.get_badges_for_user() from public; grant execute on function public.get_badges_for_user() to authenticated;
revoke all on function public.get_quests_for_user(date) from public; grant execute on function public.get_quests_for_user(date) to authenticated;
revoke all on function public.get_leaderboard(text,text,int) from public; grant execute on function public.get_leaderboard(text,text,int) to authenticated;
revoke all on function public.get_squad_challenge(text) from public; grant execute on function public.get_squad_challenge(text) to authenticated;
revoke all on function public.ensure_gamification_profile(text) from public; grant execute on function public.ensure_gamification_profile(text) to authenticated;
revoke all on function public.increment_quest_progress(text,int,date) from public; grant execute on function public.increment_quest_progress(text,int,date) to authenticated;
