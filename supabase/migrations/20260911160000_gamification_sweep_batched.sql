drop procedure if exists internal.run_gamification_sweep_batch(integer, integer, interval);

create or replace function internal.run_gamification_sweep_batch(
  p_slices integer default 240,
  p_slice integer default null,
  p_active_within interval default interval '14 days'
)
returns void
language plpgsql
security definer
set search_path = ''
set lock_timeout = '1s'
set statement_timeout = '10s'
as $$
declare
  v_slice integer := coalesce(
    p_slice,
    (floor(extract(epoch from now()) / (3600.0 / p_slices))::bigint % p_slices)::integer
  );
  v_user uuid;
  v_processed integer := 0;
  v_skipped integer := 0;
  v_failed integer := 0;
  v_started timestamptz := clock_timestamp();
  v_elapsed_ms integer;
begin
  for v_user in
    select wallet.user_id
    from core.user_gamification_profiles wallet
    join core.user_academic_profiles academic
      on academic.user_id = wallet.user_id
     and academic.organization_id = wallet.organization_id
    where (pg_catalog.hashtext(wallet.user_id::text) & 2147483647) % p_slices = v_slice
      and exists (
        select 1
        from core.user_active_days active
        where active.user_id = wallet.user_id
          and active.active_on >= ((now() at time zone 'UTC')::date - p_active_within)
      )
    order by wallet.user_id
  loop
    if not pg_catalog.pg_try_advisory_xact_lock(
      pg_catalog.hashtextextended(v_user::text, 182741)
    ) then
      v_skipped := v_skipped + 1;
      continue;
    end if;

    begin
      perform core.refresh_quest_progress(v_user);
      perform core.evaluate_achievements(v_user);
      v_processed := v_processed + 1;
    exception when others then
      v_failed := v_failed + 1;
      raise warning 'gamification sweep: user % failed: %', v_user, sqlerrm;
    end;
  end loop;

  v_elapsed_ms := round(extract(epoch from clock_timestamp() - v_started) * 1000);
  if v_failed > 0 or v_elapsed_ms > 3000 then
    raise log 'gamification sweep slice %/%: processed=% skipped=% failed=% in % ms',
      v_slice, p_slices, v_processed, v_skipped, v_failed, v_elapsed_ms;
  end if;
end;
$$;

revoke all on function internal.run_gamification_sweep_batch(integer, integer, interval)
  from public, anon, authenticated;

drop function if exists internal.run_gamification_sweep();

select cron.alter_job(
  job_id := jobid,
  schedule := '15 seconds',
  command := 'select internal.run_gamification_sweep_batch()',
  active := true
)
from cron.job
where jobname = 'gamification-sweep';

select cron.schedule(
  'prune-cron-run-details',
  '5 3 * * *',
  $$delete from cron.job_run_details where end_time < now() - interval '3 days'$$
);
