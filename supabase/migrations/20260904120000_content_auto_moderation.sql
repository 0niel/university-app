-- Content auto-moderation.
--
-- Every insert (and text edit) in the moderated tables enqueues a job in
-- core.moderation_jobs and POSTs it via pg_net to the `moderate-content`
-- edge function, which classifies the content with an LLM, records the
-- verdict in core.moderation_decisions and deletes destructive spam.
-- A pg_cron sweep re-dispatches jobs whose delivery stalled.
--
-- Runtime config lives in internal.app_config:
--   moderation_url    https://<ref>.supabase.co/functions/v1/moderate-content
--   moderation_secret same value as the MODERATION_WEBHOOK_SECRET function secret

-- ── tables ───────────────────────────────────────────────────────────────────

create table if not exists core.moderation_jobs (
  id uuid primary key default gen_random_uuid(),
  content_type text not null check (
    content_type in ('lost_found', 'marketplace', 'event', 'mentor', 'poll')
  ),
  content_id uuid not null,
  status text not null default 'pending'
    check (status in ('pending', 'done', 'failed')),
  attempts integer not null default 0,
  next_attempt_at timestamptz not null default clock_timestamp(),
  dispatched_at timestamptz,
  last_error text,
  created_at timestamptz not null default clock_timestamp(),
  updated_at timestamptz not null default clock_timestamp()
);

create unique index if not exists moderation_jobs_pending_content_idx
  on core.moderation_jobs (content_type, content_id)
  where status = 'pending';

create index if not exists moderation_jobs_due_idx
  on core.moderation_jobs (next_attempt_at)
  where status = 'pending';

create table if not exists core.moderation_decisions (
  id uuid primary key default gen_random_uuid(),
  content_type text not null,
  content_id uuid not null,
  author_id uuid,
  organization_id text,
  content_hash text not null,
  content_excerpt text not null,
  verdict text not null check (verdict in ('allow', 'remove', 'review')),
  category text not null,
  confidence numeric(4, 3) not null check (confidence between 0 and 1),
  reason text not null,
  model text,
  action text not null check (
    action in ('none', 'deleted', 'flagged', 'dry_run')
  ),
  latency_ms integer,
  created_at timestamptz not null default clock_timestamp()
);

create index if not exists moderation_decisions_content_idx
  on core.moderation_decisions (content_type, content_id, created_at desc);

create index if not exists moderation_decisions_flagged_idx
  on core.moderation_decisions (created_at desc)
  where verdict <> 'allow';

alter table core.moderation_jobs enable row level security;
alter table core.moderation_decisions enable row level security;
grant all on core.moderation_jobs to service_role;
grant all on core.moderation_decisions to service_role;

-- ── dispatch ─────────────────────────────────────────────────────────────────

create or replace function internal.dispatch_moderation_job(p_job_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_url text;
  v_secret text;
begin
  select value into v_url
  from internal.app_config where key = 'moderation_url';
  select value into v_secret
  from internal.app_config where key = 'moderation_secret';
  if v_url is null or v_secret is null then
    return; -- moderation not configured yet; the job stays pending
  end if;

  update core.moderation_jobs
  set dispatched_at = clock_timestamp(), updated_at = clock_timestamp()
  where id = p_job_id;

  perform net.http_post(
    url := v_url,
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'x-moderation-secret', v_secret
    ),
    body := jsonb_build_object('job_id', p_job_id),
    timeout_milliseconds := 60000
  );
end;
$$;

revoke all on function internal.dispatch_moderation_job(uuid)
from public, anon, authenticated;

create or replace function internal.enqueue_moderation(
  p_content_type text,
  p_content_id uuid
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_job_id uuid;
begin
  insert into core.moderation_jobs (content_type, content_id)
  values (p_content_type, p_content_id)
  on conflict (content_type, content_id) where status = 'pending' do nothing
  returning id into v_job_id;
  if v_job_id is null then
    return; -- a pending job already exists and will read the latest content
  end if;
  perform internal.dispatch_moderation_job(v_job_id);
end;
$$;

revoke all on function internal.enqueue_moderation(text, uuid)
from public, anon, authenticated;

create or replace function internal.moderation_trigger()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_content_type text := tg_argv[0];
  v_content_id uuid;
begin
  if v_content_type = 'mentor' then
    v_content_id := new.user_id;
  else
    v_content_id := new.id;
  end if;
  perform internal.enqueue_moderation(v_content_type, v_content_id);
  return null;
end;
$$;

revoke all on function internal.moderation_trigger()
from public, anon, authenticated;

-- Re-fires jobs whose webhook delivery was lost or whose processing failed.
create or replace function internal.redispatch_moderation_jobs()
returns integer
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_job record;
  v_count integer := 0;
begin
  update core.moderation_jobs
  set status = 'failed', updated_at = clock_timestamp()
  where status = 'pending' and attempts >= 6;

  for v_job in
    select id
    from core.moderation_jobs
    where status = 'pending'
      and next_attempt_at <= clock_timestamp()
      and (
        dispatched_at is null
        or dispatched_at < clock_timestamp() - interval '5 minutes'
      )
    order by next_attempt_at
    limit 25
  loop
    perform internal.dispatch_moderation_job(v_job.id);
    v_count := v_count + 1;
  end loop;
  return v_count;
end;
$$;

revoke all on function internal.redispatch_moderation_jobs()
from public, anon, authenticated;

create or replace function internal.prune_moderation_history()
returns void
language sql
security definer
set search_path = ''
as $$
  delete from core.moderation_jobs
  where status <> 'pending'
    and updated_at < clock_timestamp() - interval '7 days';
  delete from core.moderation_decisions
  where verdict = 'allow'
    and created_at < clock_timestamp() - interval '90 days';
$$;

revoke all on function internal.prune_moderation_history()
from public, anon, authenticated;

-- ── triggers ─────────────────────────────────────────────────────────────────

drop trigger if exists moderate_lost_found_items on core.lost_found_items;
create trigger moderate_lost_found_items
  after insert or update of item_name, description, location
  on core.lost_found_items
  for each row execute function internal.moderation_trigger('lost_found');

drop trigger if exists moderate_marketplace_listings
  on core.marketplace_listings;
create trigger moderate_marketplace_listings
  after insert or update of title, description
  on core.marketplace_listings
  for each row execute function internal.moderation_trigger('marketplace');

drop trigger if exists moderate_campus_events on core.campus_events;
create trigger moderate_campus_events
  after insert or update of title, description, place
  on core.campus_events
  for each row execute function internal.moderation_trigger('event');

drop trigger if exists moderate_mentor_profiles on core.mentor_profiles;
create trigger moderate_mentor_profiles
  after insert or update of bio, topics
  on core.mentor_profiles
  for each row execute function internal.moderation_trigger('mentor');

drop trigger if exists moderate_polls on core.polls;
create trigger moderate_polls
  after insert or update of title, question, description
  on core.polls
  for each row execute function internal.moderation_trigger('poll');

-- ── cron ─────────────────────────────────────────────────────────────────────

select cron.unschedule(jobid)
from cron.job
where jobname in ('redispatch-moderation-jobs', 'prune-moderation-history');

select cron.schedule(
  'redispatch-moderation-jobs',
  '*/2 * * * *',
  $$select internal.redispatch_moderation_jobs()$$
);

select cron.schedule(
  'prune-moderation-history',
  '13 4 * * *',
  $$select internal.prune_moderation_history()$$
);
