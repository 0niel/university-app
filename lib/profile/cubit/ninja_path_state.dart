part of 'ninja_path_cubit.dart';

@freezed
abstract class NinjaPathState with _$NinjaPathState {
  const factory NinjaPathState({
    @Default(NinjaPathLoadStatus.initial) NinjaPathLoadStatus badgesStatus,
    @Default(NinjaPathLoadStatus.initial) NinjaPathLoadStatus questsStatus,
    @Default(NinjaPathLoadStatus.initial) NinjaPathLoadStatus leaderboardStatus,
    @Default(<GamificationBadge>[]) List<GamificationBadge> badges,
    @Default(<GamificationQuest>[]) List<GamificationQuest> quests,
    @Default(<LeaderboardEntry>[]) List<LeaderboardEntry> leaderboard,
    GamificationBadge? recentlyUnlocked,
    @Default(LeaderboardScope.group) LeaderboardScope leaderboardScope,
  }) = _NinjaPathState;
}
