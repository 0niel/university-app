-- Fix: app_api_v1.get_leaderboard had no EXECUTE grant for `authenticated`, so
-- the SECURITY INVOKER public.get_leaderboard wrapper failed with
-- "permission denied for function get_leaderboard" whenever a signed-in user
-- opened the leaderboard (and, now, the profile screen which loads it).
-- The function is SECURITY DEFINER and validates auth.uid() internally, so
-- granting EXECUTE is safe.
grant execute on function app_api_v1.get_leaderboard(text, text, int)
  to authenticated;
