-- Gamification tables: badge/quest definitions, user profiles, badges, quest
-- progress and squad challenges.

create table core.badge_definitions (
  id text primary key,
  category text not null,
  name text not null,
  description text not null,
  emoji text not null,
  rarity text not null default 'common',
  xp_reward int not null default 0,
  shuriken_reward int not null default 0,
  sort_order int not null default 0,
  constraint badge_rarity_valid check (rarity in ('common','rare','epic','legendary'))
);
alter table core.badge_definitions enable row level security;
create policy "public can read badge_definitions" on core.badge_definitions for select using (true);
grant select on core.badge_definitions to anon, authenticated;
grant all on core.badge_definitions to service_role;

create table core.quest_definitions (
  id text primary key,
  period text not null,
  emoji text not null,
  title text not null,
  target int not null default 1,
  xp_reward int not null default 10,
  sort_order int not null default 0,
  constraint quest_period_valid check (period in ('daily','weekly'))
);
alter table core.quest_definitions enable row level security;
create policy "public can read quest_definitions" on core.quest_definitions for select using (true);
grant select on core.quest_definitions to anon, authenticated;
grant all on core.quest_definitions to service_role;

create table core.user_gamification_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  organization_id text not null references core.organizations(id) on delete cascade,
  xp int not null default 0,
  level int not null default 1,
  shurikens int not null default 0,
  streak_days int not null default 0,
  last_active_date date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint xp_non_negative check (xp >= 0),
  constraint level_positive check (level >= 1),
  constraint shurikens_non_negative check (shurikens >= 0),
  constraint streak_non_negative check (streak_days >= 0)
);
create index user_gamification_org_xp_idx on core.user_gamification_profiles (organization_id, xp desc);
create trigger set_user_gamification_updated_at before update on core.user_gamification_profiles
  for each row execute function core.set_updated_at();
alter table core.user_gamification_profiles enable row level security;
create policy "users can read own gamification profile" on core.user_gamification_profiles for select
  to authenticated using ((select auth.uid()) = user_id);
create policy "users can insert own profile" on core.user_gamification_profiles for insert
  to authenticated with check ((select auth.uid()) = user_id);
create policy "users can update own profile" on core.user_gamification_profiles for update
  to authenticated using ((select auth.uid())=user_id) with check ((select auth.uid())=user_id);
grant select,insert,update on core.user_gamification_profiles to authenticated;
grant all on core.user_gamification_profiles to service_role;

create table core.user_badges (
  id uuid primary key default extensions.gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  badge_id text not null references core.badge_definitions(id) on delete cascade,
  earned_at timestamptz not null default now(),
  progress numeric(4,3) not null default 0 check (progress between 0 and 1),
  is_earned boolean not null default false,
  unique (user_id, badge_id)
);
create index user_badges_user_idx on core.user_badges (user_id);
alter table core.user_badges enable row level security;
create policy "users can read own badges" on core.user_badges for select to authenticated using ((select auth.uid())=user_id);
create policy "users can insert own badges" on core.user_badges for insert to authenticated with check ((select auth.uid())=user_id);
create policy "users can update own badges" on core.user_badges for update to authenticated using ((select auth.uid())=user_id) with check ((select auth.uid())=user_id);
grant select,insert,update on core.user_badges to authenticated;
grant all on core.user_badges to service_role;

create table core.user_quest_progress (
  id uuid primary key default extensions.gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  quest_id text not null references core.quest_definitions(id) on delete cascade,
  period_start date not null,
  progress int not null default 0,
  is_completed boolean not null default false,
  completed_at timestamptz,
  unique (user_id, quest_id, period_start)
);
create index user_quest_progress_user_period_idx on core.user_quest_progress (user_id, period_start);
alter table core.user_quest_progress enable row level security;
create policy "users can read own quest progress" on core.user_quest_progress for select to authenticated using ((select auth.uid())=user_id);
create policy "users can insert own quest progress" on core.user_quest_progress for insert to authenticated with check ((select auth.uid())=user_id);
create policy "users can update own quest progress" on core.user_quest_progress for update to authenticated using ((select auth.uid())=user_id) with check ((select auth.uid())=user_id);
grant select,insert,update on core.user_quest_progress to authenticated;
grant all on core.user_quest_progress to service_role;

create table core.squad_challenges (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id) on delete cascade,
  group_id text,
  title text not null,
  description text not null,
  reward_shurikens int not null default 500,
  target int not null default 100,
  progress int not null default 0,
  ends_at timestamptz not null,
  created_at timestamptz not null default now()
);
create index squad_challenges_org_ends_idx on core.squad_challenges (organization_id, ends_at);
alter table core.squad_challenges enable row level security;
create policy "authenticated users can read squad challenges" on core.squad_challenges for select to authenticated using (true);
grant select on core.squad_challenges to authenticated;
grant all on core.squad_challenges to service_role;
