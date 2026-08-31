-- Кошелёк: реальная история шурикенов. Леджер + списание из кошелька;
-- завершение квеста начисляет шурикены (= xp_reward) и пишет запись.

create table core.shuriken_ledger (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id)
    on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  emoji text not null default '✨',
  title text not null,
  amount integer not null,
  created_at timestamptz not null default now(),
  constraint shuriken_ledger_amount_nonzero check (amount <> 0),
  constraint shuriken_ledger_title_not_empty check (length(trim(title)) > 0)
);

create index shuriken_ledger_user_idx
on core.shuriken_ledger (user_id, created_at desc);

alter table core.shuriken_ledger enable row level security;

create policy "users read own shuriken ledger"
on core.shuriken_ledger for select to authenticated
using ((select auth.uid()) = user_id);

create policy "users append own shuriken ledger"
on core.shuriken_ledger for insert to authenticated
with check ((select auth.uid()) = user_id);

grant select, insert on core.shuriken_ledger to authenticated;
grant all on core.shuriken_ledger to service_role;

-- Атомарное изменение баланса + запись в леджер. Отрицательный amount —
-- списание; баланс не может уйти в минус.
create or replace function core.apply_shuriken_delta(
  p_user_id uuid,
  p_emoji text,
  p_title text,
  p_amount integer
)
returns void
language plpgsql
set search_path = ''
as $$
declare
  v_org text;
begin
  update core.user_gamification_profiles
  set shurikens = shurikens + p_amount
  where user_id = p_user_id and shurikens + p_amount >= 0
  returning organization_id into v_org;
  if v_org is null then
    raise exception 'Not enough shurikens';
  end if;
  insert into core.shuriken_ledger (
    organization_id, user_id, emoji, title, amount
  )
  values (v_org, p_user_id, coalesce(p_emoji, '✨'), p_title, p_amount);
end;
$$;

create or replace function app_api_v1.get_shuriken_history(
  p_organization_id text,
  p_limit integer default 50
)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'emoji', l.emoji,
        'title', l.title,
        'amount', l.amount,
        'createdAt', l.created_at
      )
      order by l.created_at desc
    ),
    '[]'::jsonb
  )
  from (
    select * from core.shuriken_ledger
    where user_id = (select auth.uid())
      and organization_id = p_organization_id
    order by created_at desc
    limit least(coalesce(p_limit, 50), 100)
  ) l;
$$;

create or replace function app_api_v1.spend_shurikens(
  p_title text,
  p_amount integer,
  p_emoji text default '🎁'
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;
  if coalesce(p_amount, 0) <= 0 then
    raise exception 'Amount must be positive';
  end if;
  perform core.apply_shuriken_delta(v_user_id, p_emoji, p_title, -p_amount);
end;
$$;

-- Завершение квеста теперь даёт и шурикены (= xp_reward) с записью
-- в леджер.
create or replace function app_api_v1.increment_quest_progress(
  p_quest_id text,
  p_amount integer default 1,
  p_date date default ((now() at time zone 'UTC'))::date
)
returns jsonb
language plpgsql
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid()); v_quest core.quest_definitions;
  v_period_start date; v_progress int; v_completed boolean;
begin
  if v_uid is null then raise exception 'Unauthorized'; end if;
  select * into v_quest from core.quest_definitions where id=p_quest_id;
  if not found then raise exception 'Quest not found'; end if;
  v_period_start := case when v_quest.period='daily' then p_date
    when v_quest.period='weekly'
      then date_trunc('week',p_date::timestamp)::date end;
  insert into core.user_quest_progress (user_id,quest_id,period_start,progress)
  values (v_uid,p_quest_id,v_period_start,p_amount)
  on conflict (user_id,quest_id,period_start) do update
    set progress=least(user_quest_progress.progress+p_amount,v_quest.target)
  returning progress into v_progress;
  v_completed := v_progress >= v_quest.target;
  if v_completed then
    update core.user_quest_progress set is_completed=true,completed_at=now()
    where user_id=v_uid and quest_id=p_quest_id
      and period_start=v_period_start and is_completed=false;
    if found then
      update core.user_gamification_profiles set xp=xp+v_quest.xp_reward
      where user_id=v_uid;
      perform core.apply_shuriken_delta(
        v_uid, v_quest.emoji, 'Квест · ' || v_quest.title, v_quest.xp_reward
      );
    end if;
  end if;
  return jsonb_build_object('questId',p_quest_id,'progress',v_progress,
    'target',v_quest.target,'isCompleted',v_completed,
    'xpAwarded',case when v_completed then v_quest.xp_reward else 0 end);
end;
$$;

create or replace function public.get_shuriken_history(
  p_organization_id text, p_limit integer default 50
)
returns jsonb language sql stable security invoker set search_path = ''
as $$
  select app_api_v1.get_shuriken_history(p_organization_id, p_limit);
$$;

create or replace function public.spend_shurikens(
  p_title text, p_amount integer, p_emoji text default '🎁'
)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.spend_shurikens(p_title, p_amount, p_emoji); $$;

revoke all on function public.get_shuriken_history(text, integer)
  from public, anon;
revoke all on function public.spend_shurikens(text, integer, text)
  from public, anon;

grant execute on function public.get_shuriken_history(text, integer)
  to authenticated;
grant execute on function public.spend_shurikens(text, integer, text)
  to authenticated;
