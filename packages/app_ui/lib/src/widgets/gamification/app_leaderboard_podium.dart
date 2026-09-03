import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/widgets/gamification/app_leaderboard_entry.dart';
import 'package:app_ui/src/widgets/gamification/app_leaderboard_podium_column.dart';
import 'package:flutter/widgets.dart';

class AppLeaderboardPodium extends StatelessWidget {
  const AppLeaderboardPodium({
    required this.first,
    required this.second,
    required this.third,
    super.key,
  });

  final AppLeaderboardEntry first;
  final AppLeaderboardEntry second;
  final AppLeaderboardEntry third;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: AppLeaderboardPodiumColumn(
            entry: second,
            height: 70,
            medal: '🥈',
            avatarSize: 44,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: AppLeaderboardPodiumColumn(
            entry: first,
            height: 92,
            medal: '🥇',
            avatarSize: 56,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: AppLeaderboardPodiumColumn(
            entry: third,
            height: 56,
            medal: '🥉',
            avatarSize: 44,
          ),
        ),
      ],
    );
  }
}
