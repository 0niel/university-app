insert into core.badge_definitions
  (id, category, name, description, emoji, rarity, xp_reward, shuriken_reward, sort_order)
values
  ('review_1',   'Учёба', 'Первый отзыв', 'Оцени первую пару или преподавателя', '📝', 'common', 20,  10, 38),
  ('reviews_10', 'Учёба', 'Рецензент',    '10 отзывов о парах и преподах',       '🎓', 'rare',   50,  25, 42),
  ('reviews_25', 'Учёба', 'Голос курса',  '25 отзывов о парах и преподах',       '🏅', 'epic',   100, 50, 44)
on conflict (id) do update set
  category = excluded.category,
  name = excluded.name,
  description = excluded.description,
  emoji = excluded.emoji,
  rarity = excluded.rarity,
  xp_reward = excluded.xp_reward,
  shuriken_reward = excluded.shuriken_reward,
  sort_order = excluded.sort_order;

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
      select count(distinct poll_id) from core.poll_participations
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
        when 'review_1' then 1 when 'reviews_10' then 10
        when 'reviews_25' then 25
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
        when 'review_1' then 'reviews' when 'reviews_10' then 'reviews'
        when 'reviews_25' then 'reviews'
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
