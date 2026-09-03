revoke insert, update, delete, truncate, references, trigger
on core.user_gamification_profiles, core.shuriken_ledger,
  core.user_quest_progress, core.user_active_days, core.user_badges
from public, anon, authenticated;

do $$
declare
  v_table text;
  v_columns text;
begin
  foreach v_table in array array[
    'user_gamification_profiles', 'shuriken_ledger',
    'user_quest_progress', 'user_active_days', 'user_badges'
  ] loop
    select string_agg(quote_ident(attribute.attname), ', ')
    into v_columns
    from pg_catalog.pg_attribute attribute
    where attribute.attrelid = ('core.' || v_table)::regclass
      and attribute.attnum > 0 and not attribute.attisdropped;
    execute format(
      'revoke insert (%s), update (%s), references (%s) on core.%I from public, anon, authenticated',
      v_columns, v_columns, v_columns, v_table
    );
  end loop;
end;
$$;

drop policy if exists "users can insert own profile"
on core.user_gamification_profiles;
drop policy if exists "users can update own profile"
on core.user_gamification_profiles;
drop policy if exists "users append own shuriken ledger"
on core.shuriken_ledger;
drop policy if exists "users can insert own quest progress"
on core.user_quest_progress;
drop policy if exists "users can update own quest progress"
on core.user_quest_progress;
drop policy if exists "users insert own active days"
on core.user_active_days;
drop policy if exists "users can insert own badges" on core.user_badges;
drop policy if exists "users can update own badges" on core.user_badges;

revoke all on function core.apply_shuriken_delta(uuid, text, text, integer)
from public, anon, authenticated;
grant execute on function core.apply_shuriken_delta(uuid, text, text, integer)
to service_role;
revoke all on function core.apply_organization_shuriken_delta(
  uuid, text, text, text, integer
) from public, anon, authenticated;

create or replace function app_api_v1.ensure_gamification_profile(
  p_organization_id text
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
begin
  if v_uid is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if not exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = v_uid
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'Organization access denied' using errcode = '42501';
  end if;

  insert into core.user_gamification_profiles (user_id, organization_id)
  values (v_uid, p_organization_id)
  on conflict (user_id) do nothing;

  if not exists (
    select 1 from core.user_gamification_profiles profile
    where profile.user_id = v_uid
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'Gamification profile belongs to another organization'
      using errcode = '42501';
  end if;
  return app_api_v1.get_gamification_profile();
end;
$$;

create or replace function app_api_v1.record_active_day()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_today date := (now() at time zone 'UTC')::date;
  v_org text;
  v_day date;
  v_streak integer := 0;
begin
  if v_uid is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(v_uid::text, 182741)
  );
  select profile.organization_id into v_org
  from core.user_academic_profiles profile where profile.user_id = v_uid;
  perform app_api_v1.ensure_gamification_profile(v_org);

  insert into core.user_active_days (user_id, active_on)
  values (v_uid, v_today)
  on conflict do nothing;

  v_day := v_today;
  while exists (
    select 1 from core.user_active_days
    where user_id = v_uid and active_on = v_day
  ) loop
    v_streak := v_streak + 1;
    v_day := v_day - 1;
  end loop;

  update core.user_gamification_profiles
  set streak_days = v_streak,
      longest_streak = greatest(longest_streak, v_streak),
      last_active_date = v_today,
      updated_at = now()
  where user_id = v_uid and organization_id = v_org;
end;
$$;

create or replace function app_api_v1.spend_shurikens(
  p_title text,
  p_amount integer,
  p_emoji text default '🎁'
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_org text;
begin
  if v_uid is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if p_amount is null or p_amount <= 0 then
    raise exception 'Amount must be positive' using errcode = '22023';
  end if;
  if p_title is null or length(btrim(p_title)) not between 1 and 160
    or length(coalesce(p_emoji, '🎁')) not between 1 and 16 then
    raise exception 'Invalid transaction description' using errcode = '22023';
  end if;
  select academic.organization_id into v_org
  from core.user_academic_profiles academic
  join core.user_gamification_profiles wallet
    on wallet.user_id = academic.user_id
    and wallet.organization_id = academic.organization_id
  where academic.user_id = v_uid;
  if v_org is null then
    raise exception 'Organization access denied' using errcode = '42501';
  end if;
  perform core.apply_organization_shuriken_delta(
    v_uid, v_org, coalesce(p_emoji, '🎁'), btrim(p_title), -p_amount
  );
end;
$$;

create or replace function app_api_v1.increment_quest_progress(
  p_quest_id text,
  p_amount integer default 1,
  p_date date default (now() at time zone 'UTC')::date
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_today date := (now() at time zone 'UTC')::date;
  v_quest core.quest_definitions;
  v_start date;
  v_before boolean;
  v_progress core.user_quest_progress;
begin
  if v_uid is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  select * into v_quest from core.quest_definitions where id = p_quest_id;
  if not found then
    raise exception 'Quest not found' using errcode = '22023';
  end if;
  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(v_uid::text, 182741)
  );
  perform app_api_v1.record_active_day();
  v_start := case when v_quest.period = 'daily' then v_today
    else date_trunc('week', v_today::timestamp)::date end;

  select is_completed into v_before from core.user_quest_progress
  where user_id = v_uid and quest_id = p_quest_id and period_start = v_start;
  perform core.refresh_quest_progress(v_uid);
  select * into v_progress from core.user_quest_progress
  where user_id = v_uid and quest_id = p_quest_id and period_start = v_start;

  return jsonb_build_object(
    'questId', p_quest_id,
    'progress', coalesce(v_progress.progress, 0),
    'target', v_quest.target,
    'isCompleted', coalesce(v_progress.is_completed, false),
    'xpAwarded', case when v_progress.is_completed
      and not coalesce(v_before, false) then v_quest.xp_reward else 0 end
  );
end;
$$;

create or replace function core.refresh_quest_progress(p_user_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_today date := (now() at time zone 'UTC')::date;
  v_week date := date_trunc('week', now() at time zone 'UTC')::date;
  v_quest record;
  v_start date;
  v_since timestamptz;
  v_value integer;
  v_completed boolean;
  v_day date;
  v_streak integer := 0;
begin
  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(p_user_id::text, 182741)
  );
  if not exists (
    select 1 from core.user_gamification_profiles wallet
    join core.user_academic_profiles academic
      on academic.user_id = wallet.user_id
      and academic.organization_id = wallet.organization_id
    where wallet.user_id = p_user_id
  ) then
    return;
  end if;
  v_day := v_today;
  if not exists (
    select 1 from core.user_active_days
    where user_id = p_user_id and active_on = v_day
  ) then
    v_day := v_today - 1;
  end if;
  while exists (
    select 1 from core.user_active_days
    where user_id = p_user_id and active_on = v_day
  ) loop
    v_streak := v_streak + 1;
    v_day := v_day - 1;
  end loop;

  for v_quest in
    select id, period, target, xp_reward, emoji, title
    from core.quest_definitions order by id
  loop
    v_start := case when v_quest.period = 'daily' then v_today else v_week end;
    v_since := v_start::timestamp at time zone 'UTC';
    v_value := case v_quest.id
      when 'daily_reaction' then (
        select count(*) from core.lesson_reactions
        where user_id = p_user_id and created_at >= v_since
          and created_at <= now()
      )
      when 'daily_note' then (
        select count(*) from core.group_notes
        where created_by = p_user_id and created_at >= v_since
          and created_at <= now()
      )
      when 'daily_poll' then (
        select count(*) from core.poll_votes
        where user_id = p_user_id and created_at >= v_since
          and created_at <= now()
      )
      when 'daily_deadline' then (
        select count(*) from core.user_deadlines
        where user_id = p_user_id and done_at >= v_since
          and done_at <= now()
      )
      when 'weekly_active' then (
        select count(*) from core.user_active_days
        where user_id = p_user_id
          and active_on >= v_week and active_on <= v_today
      )
      when 'weekly_upload' then (
        select count(*) from core.lesson_materials
        where user_id = p_user_id and created_at >= v_since
          and created_at <= now()
      )
      when 'weekly_streak' then least(v_streak, v_quest.target)
      else null
    end;
    if v_value is null then
      continue;
    end if;
    select is_completed into v_completed from core.user_quest_progress
    where user_id = p_user_id
      and quest_id = v_quest.id and period_start = v_start;
    insert into core.user_quest_progress (
      user_id, quest_id, period_start, progress, is_completed, completed_at
    ) values (
      p_user_id, v_quest.id, v_start, least(v_value, v_quest.target),
      v_value >= v_quest.target,
      case when v_value >= v_quest.target then now() end
    )
    on conflict (user_id, quest_id, period_start) do update set
      progress = case when core.user_quest_progress.is_completed
        then v_quest.target else excluded.progress end,
      is_completed = core.user_quest_progress.is_completed or excluded.is_completed,
      completed_at = coalesce(
        core.user_quest_progress.completed_at, excluded.completed_at
      );
    if v_value >= v_quest.target and not coalesce(v_completed, false) then
      update core.user_gamification_profiles set xp = xp + v_quest.xp_reward
      where user_id = p_user_id;
      if v_quest.xp_reward > 0 then
        perform core.apply_shuriken_delta(
          p_user_id, v_quest.emoji, 'Квест · ' || v_quest.title, v_quest.xp_reward
        );
      end if;
    end if;
  end loop;
end;
$$;

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
  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(v_uid::text, 182741)
  );
  perform app_api_v1.record_active_day();
  perform core.refresh_quest_progress(v_uid);
  v_newly := core.evaluate_achievements(v_uid);
  return jsonb_build_object('newlyEarned', v_newly);
end;
$$;

create or replace function internal.run_gamification_sweep()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user record;
begin
  for v_user in
    select wallet.user_id from core.user_gamification_profiles wallet
    join core.user_academic_profiles academic
      on academic.user_id = wallet.user_id
      and academic.organization_id = wallet.organization_id
    order by wallet.user_id
  loop
    perform pg_catalog.pg_advisory_xact_lock(
      pg_catalog.hashtextextended(v_user.user_id::text, 182741)
    );
    perform core.refresh_quest_progress(v_user.user_id);
    perform core.evaluate_achievements(v_user.user_id);
  end loop;
end;
$$;

create or replace function public.increment_quest_progress(
  p_quest_id text, p_amount integer default 1, p_date date default null
)
returns jsonb
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.increment_quest_progress(p_quest_id, p_amount, p_date);
$$;

revoke all on function app_api_v1.ensure_gamification_profile(text),
  app_api_v1.record_active_day(),
  app_api_v1.spend_shurikens(text, integer, text),
  app_api_v1.increment_quest_progress(text, integer, date),
  app_api_v1.sync_gamification(),
  public.ensure_gamification_profile(text),
  public.record_active_day(),
  public.spend_shurikens(text, integer, text),
  public.increment_quest_progress(text, integer, date),
  public.sync_gamification()
from public, anon;

grant execute on function app_api_v1.ensure_gamification_profile(text),
  app_api_v1.record_active_day(),
  app_api_v1.spend_shurikens(text, integer, text),
  app_api_v1.increment_quest_progress(text, integer, date),
  app_api_v1.sync_gamification(),
  public.ensure_gamification_profile(text),
  public.record_active_day(),
  public.spend_shurikens(text, integer, text),
  public.increment_quest_progress(text, integer, date),
  public.sync_gamification()
to authenticated, service_role;

revoke all on function core.refresh_quest_progress(uuid),
  core.evaluate_achievements(uuid), internal.run_gamification_sweep()
from public, anon, authenticated;
