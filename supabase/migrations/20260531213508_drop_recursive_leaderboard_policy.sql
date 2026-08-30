-- Drop the remaining "leaderboard read" policy that was still causing
-- infinite recursion (the earlier migration used the wrong policy name).

drop policy if exists "leaderboard read" on core.user_gamification_profiles;
