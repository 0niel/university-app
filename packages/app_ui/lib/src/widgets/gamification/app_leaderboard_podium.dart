import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

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
            avatarSize: 42,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppLeaderboardPodiumColumn(
            entry: first,
            height: 92,
            medal: '🥇',
            avatarSize: 52,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppLeaderboardPodiumColumn(
            entry: third,
            height: 56,
            medal: '🥉',
            avatarSize: 42,
          ),
        ),
      ],
    );
  }
}
