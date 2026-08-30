part of 'profile_cubit.dart';

const kStreakHistoryDays = 14;

const kClosestBadgesCount = 3;

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(ProfileStatus.initial) ProfileStatus status,
    @Default(User.anonymous) User user,
    @Default(UserGamificationProfile.empty)
    UserGamificationProfile gamificationProfile,
    @Default(ProfileOverview.empty) ProfileOverview overview,
    @Default(<GamificationQuest>[]) List<GamificationQuest> quests,
    @Default(<LeaderboardEntry>[]) List<LeaderboardEntry> leaderboard,
    @Default(<GamificationBadge>[]) List<GamificationBadge> badges,
    @Default(UserSettings()) UserSettings settings,
    @Default(<ProfileSection>{}) Set<ProfileSection> failedSections,
    @Default(<GamificationBadge>[]) List<GamificationBadge> newlyEarnedBadges,
  }) = _ProfileState;

  const ProfileState._();

  List<GamificationQuest> get dailyQuests =>
      quests.where((q) => q.isDaily).toList();

  int get dailyDone => dailyQuests.where((q) => q.isCompleted).length;

  int get dailyXpLeft => dailyQuests
      .where((q) => !q.isCompleted)
      .fold(0, (a, q) => a + q.xpReward);

  bool hasFailed(ProfileSection section) => failedSections.contains(section);

  List<GamificationBadge> get earnedBadges =>
      badges.where((badge) => badge.isEarned).toList()..sort(
        (a, b) =>
            (b.earnedAt ?? DateTime(0)).compareTo(a.earnedAt ?? DateTime(0)),
      );

  List<GamificationBadge> get closestBadges =>
      (badges.where((badge) => !badge.isEarned).toList()
            ..sort((a, b) => b.progress.compareTo(a.progress)))
          .take(kClosestBadgesCount)
          .toList();

  bool get hasStreakHistory =>
      overview.streakHistory.length == kStreakHistoryDays;
}

enum ProfileStatus { initial, loading, loaded, error }
