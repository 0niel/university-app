-- Remove the "Mirea AI" assistant feature entirely: usage table + RPCs.
-- The feature (in-app chat + daily request quota) was dropped from the app;
-- this clears all backend traces. The `mirea-ai` edge function is deleted
-- separately (functions are not migration-managed).
-- Applied remotely as: remove_mirea_ai.

drop function if exists public.consume_ai_request(integer) cascade;
drop function if exists public.get_ai_usage(integer) cascade;
drop function if exists app_api_v1.consume_ai_request(integer) cascade;
drop function if exists app_api_v1.get_ai_usage(integer) cascade;

drop table if exists core.ai_usage cascade;
