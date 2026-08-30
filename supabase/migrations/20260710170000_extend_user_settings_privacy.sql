alter table user_private.user_settings
  add column if not exists profile_visibility text not null default 'everyone',
  add column if not exists anonymous_reactions boolean not null default true;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'user_settings_profile_visibility_valid'
      and conrelid = 'user_private.user_settings'::regclass
  ) then
    alter table user_private.user_settings
      add constraint user_settings_profile_visibility_valid
      check (profile_visibility in ('everyone', 'group', 'nobody'));
  end if;
end
$$;

drop function if exists public.upsert_user_settings(
  boolean, boolean, boolean, boolean, boolean, text, text, text, boolean
);
drop function if exists app_api_v1.upsert_user_settings(
  boolean, boolean, boolean, boolean, boolean, text, text, text, boolean
);

create or replace function app_api_v1.get_user_settings()
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select coalesce(
    (
      select jsonb_build_object(
        'notificationsEnabled', s.notifications_enabled,
        'scheduleChangeAlerts', s.schedule_change_alerts,
        'questReminders', s.quest_reminders,
        'achievementAlerts', s.achievement_alerts,
        'leaderboardUpdates', s.leaderboard_updates,
        'themeMode', s.theme_mode,
        'accentColor', s.accent_color,
        'density', s.density,
        'showMascot', s.show_mascot,
        'profileVisibility', s.profile_visibility,
        'anonymousReactions', s.anonymous_reactions
      )
      from user_private.user_settings s
      where s.user_id = (select auth.uid())
    ),
    jsonb_build_object(
      'notificationsEnabled', true,
      'scheduleChangeAlerts', true,
      'questReminders', true,
      'achievementAlerts', true,
      'leaderboardUpdates', false,
      'themeMode', 'system',
      'accentColor', 'blue',
      'density', 'default',
      'showMascot', true,
      'profileVisibility', 'everyone',
      'anonymousReactions', true
    )
  );
$$;

create or replace function app_api_v1.upsert_user_settings(
  p_notifications_enabled boolean default null,
  p_schedule_change_alerts boolean default null,
  p_quest_reminders boolean default null,
  p_achievement_alerts boolean default null,
  p_leaderboard_updates boolean default null,
  p_theme_mode text default null,
  p_accent_color text default null,
  p_density text default null,
  p_show_mascot boolean default null,
  p_profile_visibility text default null,
  p_anonymous_reactions boolean default null
)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
begin
  if v_uid is null then
    raise exception 'Unauthorized';
  end if;

  insert into user_private.user_settings (user_id)
  values (v_uid)
  on conflict (user_id) do nothing;

  update user_private.user_settings
  set notifications_enabled = coalesce(
        p_notifications_enabled,
        notifications_enabled
      ),
      schedule_change_alerts = coalesce(
        p_schedule_change_alerts,
        schedule_change_alerts
      ),
      quest_reminders = coalesce(p_quest_reminders, quest_reminders),
      achievement_alerts = coalesce(
        p_achievement_alerts,
        achievement_alerts
      ),
      leaderboard_updates = coalesce(
        p_leaderboard_updates,
        leaderboard_updates
      ),
      theme_mode = coalesce(p_theme_mode, theme_mode),
      accent_color = coalesce(p_accent_color, accent_color),
      density = coalesce(p_density, density),
      show_mascot = coalesce(p_show_mascot, show_mascot),
      profile_visibility = coalesce(
        p_profile_visibility,
        profile_visibility
      ),
      anonymous_reactions = coalesce(
        p_anonymous_reactions,
        anonymous_reactions
      )
  where user_id = v_uid;

  return app_api_v1.get_user_settings();
end;
$$;

create or replace function public.upsert_user_settings(
  p_notifications_enabled boolean default null,
  p_schedule_change_alerts boolean default null,
  p_quest_reminders boolean default null,
  p_achievement_alerts boolean default null,
  p_leaderboard_updates boolean default null,
  p_theme_mode text default null,
  p_accent_color text default null,
  p_density text default null,
  p_show_mascot boolean default null,
  p_profile_visibility text default null,
  p_anonymous_reactions boolean default null
)
returns jsonb
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.upsert_user_settings(
    p_notifications_enabled,
    p_schedule_change_alerts,
    p_quest_reminders,
    p_achievement_alerts,
    p_leaderboard_updates,
    p_theme_mode,
    p_accent_color,
    p_density,
    p_show_mascot,
    p_profile_visibility,
    p_anonymous_reactions
  );
$$;

revoke all on function public.upsert_user_settings(
  boolean, boolean, boolean, boolean, boolean, text, text, text, boolean,
  text, boolean
) from public;
revoke all on function app_api_v1.upsert_user_settings(
  boolean, boolean, boolean, boolean, boolean, text, text, text, boolean,
  text, boolean
) from public;
grant execute on function app_api_v1.upsert_user_settings(
  boolean, boolean, boolean, boolean, boolean, text, text, text, boolean,
  text, boolean
) to authenticated;
grant execute on function public.upsert_user_settings(
  boolean, boolean, boolean, boolean, boolean, text, text, text, boolean,
  text, boolean
) to authenticated;
