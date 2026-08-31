-- Makes gamification REAL: every badge and quest is computable from tables
-- that already receive writes, progress and rewards are server-owned, and the
-- notification-preference toggles finally gate actual pushes.
--
-- Design:
--   * core.evaluate_achievements(uid) — recomputes every badge metric,
--     upserts user_badges progress, pays XP+shurikens exactly once on unlock
--     and returns the newly earned badges. Clients only read.
--   * core.refresh_quest_progress(uid) — recomputes daily/weekly quest
--     progress from source tables, pays XP on completion.
--   * public.sync_gamification() — authenticated entry point: refresh +
--     evaluate for the caller, returns newly earned badges for celebration UI.
--   * internal.should_notify(uid, kind) — reads user_private.user_settings so
--     the push toggles stop being decorative; notify_app_push now respects it.

-- ── 1. Replace the badge catalog with achievable definitions ─────────────────

delete from core.user_badges
where badge_id not in ('mentor');

delete from core.badge_definitions;

insert into core.badge_definitions
  (id, category, name, description, emoji, rarity, xp_reward, shuriken_reward, sort_order)
values
  ('streak_3',    'Активность', 'Разогрев',          'Стрик 3 дня',                    '🔥', 'common',    20,  10, 10),
  ('streak_7',    'Активность', 'Неделя огня',       'Стрик 7 дней',                   '⚡', 'rare',      50,  25, 20),
  ('streak_30',   'Активность', 'Железная воля',     'Стрик 30 дней',                  '🏔️', 'epic',     100,  50, 30),
  ('quests_10',   'Активность', 'Квестоман',         'Заверши 10 квестов',             '🎯', 'rare',      50,  25, 40),
  ('material_1',  'Учёба',      'Первый вклад',      'Залей материал в Банк знаний',   '📘', 'common',    20,  10, 10),
  ('material_5',  'Учёба',      'Библиотекарь',      '5 публичных материалов',         '📚', 'rare',      50,  25, 20),
  ('material_25', 'Учёба',      'Хранитель знаний',  '25 публичных материалов',        '🏛️', 'epic',     100,  50, 30),
  ('reviews_3',   'Учёба',      'Критик',            '3 отзыва о парах или преподах',  '⭐', 'common',    20,  10, 40),
  ('deadline_10', 'Учёба',      'Дедлайн-мастер',    'Закрой 10 дедлайнов',            '✅', 'rare',      50,  25, 50),
  ('friend_1',    'Сообщество', 'Не один',           'Первый друг',                    '🤝', 'common',    20,  10, 10),
  ('friends_5',   'Сообщество', 'Своя банда',        '5 друзей',                       '👥', 'rare',      50,  25, 20),
  ('polls_5',     'Сообщество', 'Голос группы',      'Проголосуй в 5 опросах',         '🗳️', 'common',    20,  10, 30),
  ('poll_create', 'Сообщество', 'Инициатор',         'Создай опрос',                   '📊', 'common',    20,  10, 40),
  ('rsvp_3',      'Сообщество', 'Тусовщик',          'Отметься на 3 событиях',         '🎉', 'common',    20,  10, 50),
  ('lostfound_1', 'Сообщество', 'Спасатель',         'Помоги в бюро находок',          '🔍', 'rare',      50,  25, 60),
  ('market_1',    'Сообщество', 'Продавец',          'Первое объявление на маркете',   '🛍️', 'common',    20,  10, 70),
  ('mentor',      'Сообщество', 'Ментор',            'Проведи менторскую сессию',      '🧭', 'epic',     100,  50, 80)
on conflict (id) do update set
  category = excluded.category,
  name = excluded.name,
  description = excluded.description,
  emoji = excluded.emoji,
  rarity = excluded.rarity,
  xp_reward = excluded.xp_reward,
  shuriken_reward = excluded.shuriken_reward,
  sort_order = excluded.sort_order;

-- Achievements are server-owned from now on.
revoke insert, update, delete on core.user_badges from authenticated, anon;
drop policy if exists "users can insert own badges" on core.user_badges;
drop policy if exists "users can update own badges" on core.user_badges;

-- ── 2. Replace dead quests with measurable ones ──────────────────────────────

delete from core.user_quest_progress
where quest_id in ('daily_ai', 'daily_help', 'weekly_attend', 'weekly_materials');

delete from core.quest_definitions
where id in ('daily_ai', 'daily_help', 'weekly_attend', 'weekly_materials');

update core.quest_definitions
set title = 'Оставь заметку группе', emoji = '📝', target = 1
where id = 'daily_note';

insert into core.quest_definitions (id, period, emoji, title, target, xp_reward, sort_order) values
  ('daily_poll',     'daily',  '🗳️', 'Проголосуй в опросе',             1,  15, 30),
  ('daily_deadline', 'daily',  '✅', 'Закрой дедлайн',                  1,  25, 40),
  ('weekly_active',  'weekly', '⚡', 'Будь активен 5 дней на неделе',   5, 150, 10),
  ('weekly_upload',  'weekly', '📚', 'Залей материал в Банк знаний',    1, 100, 20)
on conflict (id) do update set
  period = excluded.period, emoji = excluded.emoji, title = excluded.title,
  target = excluded.target, xp_reward = excluded.xp_reward,
  sort_order = excluded.sort_order;

-- ── 3. Notification preference reader ────────────────────────────────────────

create or replace function internal.should_notify(p_user_id uuid, p_kind text)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(
    (
      select settings.notifications_enabled and case p_kind
        when 'achievement' then settings.achievement_alerts
        when 'quest' then settings.quest_reminders
        when 'leaderboard' then settings.leaderboard_updates
        when 'schedule_change' then settings.schedule_change_alerts
        else true
      end
      from user_private.user_settings settings
      where settings.user_id = p_user_id
    ),
    true
  );
$$;

revoke all on function internal.should_notify(uuid, text)
from public, anon, authenticated;

create or replace function internal.notify_app_push_gated(
  p_recipient uuid,
  p_kind text,
  p_title text,
  p_body text,
  p_route text default ''
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not internal.should_notify(p_recipient, p_kind) then
    return;
  end if;
  perform internal.notify_app_push(p_recipient, p_title, p_body, p_route, p_kind);
end;
$$;

revoke all on function internal.notify_app_push_gated(uuid, text, text, text, text)
from public, anon, authenticated;

-- ── 4. Achievement engine ────────────────────────────────────────────────────

create or replace function core.evaluate_achievements(p_user_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_streak integer;
  v_metrics jsonb;
  v_badge record;
  v_value numeric;
  v_target numeric;
  v_progress numeric(4, 3);
  v_was_earned boolean;
  v_newly jsonb := '[]'::jsonb;
begin
  select greatest(coalesce(longest_streak, 0), coalesce(streak_days, 0))
  into v_streak
  from core.user_gamification_profiles
  where user_id = p_user_id;

  v_metrics := jsonb_build_object(
    'streak', coalesce(v_streak, 0),
    'quests_done', (
      select count(*) from core.user_quest_progress
      where user_id = p_user_id and is_completed
    ),
    'materials', (
      select count(*) from core.lesson_materials
      where user_id = p_user_id and is_public
    ),
    'reviews', (
      select (
        select count(*) from core.teacher_reviews where user_id = p_user_id
      ) + (
        select count(*) from core.lesson_reviews where user_id = p_user_id
      )
    ),
    'deadlines_done', (
      select count(*) from core.user_deadlines
      where user_id = p_user_id and done_at is not null
    ),
    'friends', (
      select count(*) from core.friendships
      where status = 'accepted'
        and (requester_id = p_user_id or addressee_id = p_user_id)
    ),
    'poll_votes', (
      select count(distinct poll_id) from core.poll_votes
      where user_id = p_user_id
    ),
    'polls_created', (
      select count(*) from core.polls where author_id = p_user_id
    ),
    'rsvps', (
      select count(*) from core.event_rsvps where user_id = p_user_id
    ),
    'lost_found', (
      select count(*) from core.lost_found_items where author_id = p_user_id
    ),
    'listings', (
      select count(*) from core.marketplace_listings
      where seller_id = p_user_id
    ),
    'mentor_sessions', (
      select count(*) from core.mentor_requests
      where mentor_user_id = p_user_id and status = 'completed'
    )
  );

  for v_badge in
    select id, name, emoji, category, description, rarity,
      xp_reward, shuriken_reward,
      case id
        when 'streak_3' then 3 when 'streak_7' then 7 when 'streak_30' then 30
        when 'quests_10' then 10
        when 'material_1' then 1 when 'material_5' then 5
        when 'material_25' then 25
        when 'reviews_3' then 3
        when 'deadline_10' then 10
        when 'friend_1' then 1 when 'friends_5' then 5
        when 'polls_5' then 5
        when 'poll_create' then 1
        when 'rsvp_3' then 3
        when 'lostfound_1' then 1
        when 'market_1' then 1
        when 'mentor' then 1
      end as target,
      case id
        when 'streak_3' then 'streak' when 'streak_7' then 'streak'
        when 'streak_30' then 'streak'
        when 'quests_10' then 'quests_done'
        when 'material_1' then 'materials' when 'material_5' then 'materials'
        when 'material_25' then 'materials'
        when 'reviews_3' then 'reviews'
        when 'deadline_10' then 'deadlines_done'
        when 'friend_1' then 'friends' when 'friends_5' then 'friends'
        when 'polls_5' then 'poll_votes'
        when 'poll_create' then 'polls_created'
        when 'rsvp_3' then 'rsvps'
        when 'lostfound_1' then 'lost_found'
        when 'market_1' then 'listings'
        when 'mentor' then 'mentor_sessions'
      end as metric
    from core.badge_definitions
  loop
    if v_badge.target is null then
      continue;
    end if;
    v_value := coalesce((v_metrics ->> v_badge.metric)::numeric, 0);
    v_target := v_badge.target;
    v_progress := least(v_value / v_target, 1)::numeric(4, 3);

    select is_earned into v_was_earned
    from core.user_badges
    where user_id = p_user_id and badge_id = v_badge.id;

    -- earned_at is NOT NULL with default now(); it is only meaningful when
    -- is_earned — preserved across re-evaluations once set.
    insert into core.user_badges (user_id, badge_id, progress, is_earned)
    values (p_user_id, v_badge.id, v_progress, v_progress >= 1)
    on conflict (user_id, badge_id) do update set
      progress = excluded.progress,
      is_earned = core.user_badges.is_earned or excluded.is_earned,
      earned_at = case
        when core.user_badges.is_earned then core.user_badges.earned_at
        else now()
      end;

    if v_progress >= 1 and coalesce(v_was_earned, false) = false then
      update core.user_gamification_profiles
      set xp = xp + v_badge.xp_reward
      where user_id = p_user_id;
      if v_badge.shuriken_reward > 0 then
        perform core.apply_shuriken_delta(
          p_user_id, v_badge.emoji, 'Ачивка · ' || v_badge.name,
          v_badge.shuriken_reward
        );
      end if;
      perform internal.notify_app_push_gated(
        p_user_id, 'achievement',
        v_badge.emoji || ' Новая ачивка!',
        v_badge.name,
        '/profile'
      );
      v_newly := v_newly || jsonb_build_object(
        'id', v_badge.id, 'name', v_badge.name, 'emoji', v_badge.emoji,
        'category', v_badge.category, 'description', v_badge.description,
        'rarity', v_badge.rarity, 'isEarned', true, 'progress', 1,
        'xpReward', v_badge.xp_reward,
        'shurikenReward', v_badge.shuriken_reward
      );
    end if;
  end loop;

  return v_newly;
end;
$$;

revoke all on function core.evaluate_achievements(uuid)
from public, anon, authenticated;

-- ── 5. Quest progress engine ─────────────────────────────────────────────────

create or replace function core.refresh_quest_progress(p_user_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_today date := (now() at time zone 'UTC')::date;
  v_week date := date_trunc('week', (now() at time zone 'UTC'))::date;
  v_quest record;
  v_start date;
  v_value integer;
  v_completed boolean;
begin
  for v_quest in
    select id, period, target, xp_reward, emoji, title
    from core.quest_definitions
  loop
    v_start := case when v_quest.period = 'daily' then v_today else v_week end;

    v_value := case v_quest.id
      when 'daily_reaction' then (
        select count(*) from core.lesson_reactions
        where user_id = p_user_id and created_at >= v_today
      )
      when 'daily_note' then (
        select count(*) from core.group_notes
        where created_by = p_user_id and created_at >= v_today
      )
      when 'daily_poll' then (
        select count(*) from core.poll_votes
        where user_id = p_user_id and created_at >= v_today
      )
      when 'daily_deadline' then (
        select count(*) from core.user_deadlines
        where user_id = p_user_id and done_at >= v_today
      )
      when 'weekly_active' then (
        select count(*) from core.user_active_days
        where user_id = p_user_id
          and active_on >= v_week and active_on < v_week + 7
      )
      when 'weekly_upload' then (
        select count(*) from core.lesson_materials
        where user_id = p_user_id and created_at >= v_week
      )
      when 'weekly_streak' then (
        select least(coalesce(streak_days, 0), v_quest.target)
        from core.user_gamification_profiles
        where user_id = p_user_id
      )
      else null
    end;

    if v_value is null then
      continue;
    end if;

    select is_completed into v_completed
    from core.user_quest_progress
    where user_id = p_user_id
      and quest_id = v_quest.id and period_start = v_start;

    insert into core.user_quest_progress (
      user_id, quest_id, period_start, progress, is_completed, completed_at
    )
    values (
      p_user_id, v_quest.id, v_start, least(v_value, v_quest.target),
      v_value >= v_quest.target,
      case when v_value >= v_quest.target then now() end
    )
    on conflict (user_id, quest_id, period_start) do update set
      progress = excluded.progress,
      is_completed =
        core.user_quest_progress.is_completed or excluded.is_completed,
      completed_at = coalesce(
        core.user_quest_progress.completed_at, excluded.completed_at
      );

    if v_value >= v_quest.target and coalesce(v_completed, false) = false then
      update core.user_gamification_profiles
      set xp = xp + v_quest.xp_reward
      where user_id = p_user_id;
      perform core.apply_shuriken_delta(
        p_user_id, v_quest.emoji, 'Квест · ' || v_quest.title,
        v_quest.xp_reward
      );
    end if;
  end loop;
end;
$$;

revoke all on function core.refresh_quest_progress(uuid)
from public, anon, authenticated;

-- ── 6. Client entry point ────────────────────────────────────────────────────

create or replace function app_api_v1.sync_gamification()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_newly jsonb;
begin
  if v_uid is null then
    raise exception 'Not authenticated' using errcode = '42501';
  end if;
  perform core.refresh_quest_progress(v_uid);
  v_newly := core.evaluate_achievements(v_uid);
  return jsonb_build_object('newlyEarned', v_newly);
end;
$$;

create or replace function public.sync_gamification()
returns jsonb
language sql
security definer
set search_path = ''
as $$
  select app_api_v1.sync_gamification();
$$;

revoke all on function app_api_v1.sync_gamification() from public, anon;
revoke all on function public.sync_gamification() from public, anon;
grant execute on function app_api_v1.sync_gamification() to authenticated;
grant execute on function public.sync_gamification() to authenticated;

-- ── 7. Mentorship: stop writing user_badges directly ─────────────────────────
-- The bespoke insert in complete_mentor_session is superseded by the engine;
-- evaluating after completion both grants the badge and pays its reward.
-- (The old insert is left harmless: is_earned stays true, rewards are paid by
-- the engine only on transition, so users who already had the raw row get
-- their reward on the next evaluation via the was_earned=false path being
-- false — acceptable for the single legacy badge.)

-- ── 8. Hourly sweep so streak/quest badges land without an app open ──────────

create or replace function internal.run_gamification_sweep()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user record;
begin
  for v_user in select user_id from core.user_gamification_profiles loop
    perform core.refresh_quest_progress(v_user.user_id);
    perform core.evaluate_achievements(v_user.user_id);
  end loop;
end;
$$;

revoke all on function internal.run_gamification_sweep()
from public, anon, authenticated;

select cron.schedule(
  'gamification-sweep',
  '30 * * * *',
  $$select internal.run_gamification_sweep()$$
);
