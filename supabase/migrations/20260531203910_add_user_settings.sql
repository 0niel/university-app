-- user_private schema + user_settings table + get/upsert RPCs.

create schema if not exists user_private;

create table user_private.user_settings (
  user_id                uuid primary key references auth.users(id) on delete cascade,
  notifications_enabled  boolean not null default true,
  schedule_change_alerts boolean not null default true,
  quest_reminders        boolean not null default true,
  achievement_alerts     boolean not null default true,
  leaderboard_updates    boolean not null default false,
  theme_mode             text not null default 'system',
  accent_color           text not null default 'blue',
  density                text not null default 'default',
  show_mascot            boolean not null default true,
  created_at             timestamptz not null default now(),
  updated_at             timestamptz not null default now(),
  constraint theme_mode_valid   check (theme_mode in ('system','light','dark')),
  constraint accent_color_valid check (accent_color in ('blue','violet','green','red','yellow')),
  constraint density_valid      check (density in ('default','compact'))
);
create trigger set_user_settings_updated_at before update on user_private.user_settings
  for each row execute function core.set_updated_at();
alter table user_private.user_settings enable row level security;
create policy "users can read own settings" on user_private.user_settings for select to authenticated using ((select auth.uid())=user_id);
create policy "users can insert own settings" on user_private.user_settings for insert to authenticated with check ((select auth.uid())=user_id);
create policy "users can update own settings" on user_private.user_settings for update to authenticated using ((select auth.uid())=user_id) with check ((select auth.uid())=user_id);
grant select,insert,update on user_private.user_settings to authenticated;
grant all on user_private.user_settings to service_role;
grant usage on schema user_private to authenticated;

create or replace function app_api_v1.get_user_settings()
returns jsonb language sql stable security invoker set search_path = ''
as $$
  select coalesce(
    (select jsonb_build_object('notificationsEnabled',s.notifications_enabled,
      'scheduleChangeAlerts',s.schedule_change_alerts,'questReminders',s.quest_reminders,
      'achievementAlerts',s.achievement_alerts,'leaderboardUpdates',s.leaderboard_updates,
      'themeMode',s.theme_mode,'accentColor',s.accent_color,'density',s.density,'showMascot',s.show_mascot)
    from user_private.user_settings s where s.user_id=(select auth.uid())),
    jsonb_build_object('notificationsEnabled',true,'scheduleChangeAlerts',true,'questReminders',true,
      'achievementAlerts',true,'leaderboardUpdates',false,'themeMode','system',
      'accentColor','blue','density','default','showMascot',true));
$$;

create or replace function app_api_v1.upsert_user_settings(
  p_notifications_enabled boolean default null, p_schedule_change_alerts boolean default null,
  p_quest_reminders boolean default null, p_achievement_alerts boolean default null,
  p_leaderboard_updates boolean default null, p_theme_mode text default null,
  p_accent_color text default null, p_density text default null, p_show_mascot boolean default null)
returns jsonb language plpgsql security invoker set search_path = ''
as $$
declare v_uid uuid := (select auth.uid());
begin
  if v_uid is null then raise exception 'Unauthorized'; end if;
  insert into user_private.user_settings (user_id) values (v_uid) on conflict (user_id) do nothing;
  update user_private.user_settings set
    notifications_enabled=coalesce(p_notifications_enabled,notifications_enabled),
    schedule_change_alerts=coalesce(p_schedule_change_alerts,schedule_change_alerts),
    quest_reminders=coalesce(p_quest_reminders,quest_reminders),
    achievement_alerts=coalesce(p_achievement_alerts,achievement_alerts),
    leaderboard_updates=coalesce(p_leaderboard_updates,leaderboard_updates),
    theme_mode=coalesce(p_theme_mode,theme_mode),accent_color=coalesce(p_accent_color,accent_color),
    density=coalesce(p_density,density),show_mascot=coalesce(p_show_mascot,show_mascot)
  where user_id=v_uid;
  return app_api_v1.get_user_settings();
end;
$$;

create or replace function public.get_user_settings() returns jsonb language sql stable security invoker set search_path = '' as $$ select app_api_v1.get_user_settings(); $$;
create or replace function public.upsert_user_settings(
  p_notifications_enabled boolean default null, p_schedule_change_alerts boolean default null,
  p_quest_reminders boolean default null, p_achievement_alerts boolean default null,
  p_leaderboard_updates boolean default null, p_theme_mode text default null,
  p_accent_color text default null, p_density text default null, p_show_mascot boolean default null)
returns jsonb language sql security invoker set search_path = ''
as $$ select app_api_v1.upsert_user_settings(p_notifications_enabled,p_schedule_change_alerts,p_quest_reminders,p_achievement_alerts,p_leaderboard_updates,p_theme_mode,p_accent_color,p_density,p_show_mascot); $$;

revoke all on function public.get_user_settings() from public; grant execute on function public.get_user_settings() to authenticated;
revoke all on function public.upsert_user_settings(boolean,boolean,boolean,boolean,boolean,text,text,text,boolean) from public;
grant execute on function public.upsert_user_settings(boolean,boolean,boolean,boolean,boolean,text,text,text,boolean) to authenticated;
