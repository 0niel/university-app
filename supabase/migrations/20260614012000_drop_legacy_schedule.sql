-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║ Drop the legacy per-target / per-date schedule storage. Reads and writes   ║
-- ║ are fully on the canonical core.schedule_item model now, so these tables   ║
-- ║ + the digest-diff change machinery are dead weight.                        ║
-- ║ APPLY ONLY AFTER the full canonical re-ingest has completed and counts are ║
-- ║ verified (the canonical model is the sole source of truth afterwards).     ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- 1) stop the old digest-refresh cron (it scans schedule_parts).
do $$
begin
  perform cron.unschedule('schedule-change-log-refresh');
exception when others then
  raise notice 'cron unschedule skipped: %', sqlerrm;
end $$;

-- 2) drop the obsolete digest-diff change machinery + dead occurrence RPCs.
drop function if exists public.refresh_schedule_change_log();
drop function if exists core.refresh_schedule_change_log();
drop function if exists public.get_schedule_occurrences_for_entity(text, text, timestamptz, timestamptz, text);
drop function if exists app_api_v1.get_schedule_occurrences_for_entity(text, text, timestamptz, timestamptz, text);
drop function if exists public.search_schedule_entities(text, text, text, integer);
drop function if exists app_api_v1.search_schedule_entities(text, text, text, integer);

-- 3) drop the legacy storage tables (CASCADE clears their FK children/indexes).
drop table if exists core.schedule_change_log cascade;
drop table if exists core.schedule_target_digests cascade;
drop table if exists core.schedule_occurrences cascade;
drop table if exists core.schedule_part_dates cascade;
drop table if exists core.schedule_part_groups cascade;
drop table if exists core.schedule_part_teachers cascade;
drop table if exists core.schedule_part_classrooms cascade;
drop table if exists core.schedule_parts cascade;

-- Kept on purpose: core.schedule_targets (source pick-list for search_schedule_targets),
-- the canonical entities core.schedule_groups/teachers/classrooms/campuses/disciplines
-- (referenced by the schedule_item edges), and core.lesson_reactions.
