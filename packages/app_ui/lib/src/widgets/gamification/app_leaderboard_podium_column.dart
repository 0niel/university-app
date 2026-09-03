import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_icon_tile.dart';
import 'package:app_ui/src/widgets/gamification/app_leaderboard_entry.dart';
import 'package:app_ui/src/widgets/gamification/xp_text_formatter.dart';
import 'package:flutter/widgets.dart';

class AppLeaderboardPodiumColumn extends StatelessWidget {
  const AppLeaderboardPodiumColumn({
    required this.entry,
    required this.height,
    required this.medal,
    required this.avatarSize,
    super.key,
  });

  final AppLeaderboardEntry entry;
  final double height;
  final String medal;
  final double avatarSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLeader = entry.position == 1;

    return Column(
      children: [
        AppIconTile(
          size: avatarSize,
          radius: avatarSize / 2,
          background: colors.tint,
          child: Text(
            entry.initials,
            style: AppText.sans(avatarSize * .32, FontWeight.w700).copyWith(
              color: colors.accent,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          entry.displayName,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.subtextStrong.copyWith(color: colors.ink),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          formatXp(entry.xp),
          style: AppText.tabular(AppText.caption).copyWith(color: colors.muted),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          height: height,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          decoration: BoxDecoration(
            color: isLeader ? colors.tint : colors.surface2,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.banner),
            ),
          ),
          child: Text(medal, style: const TextStyle(fontSize: 24, height: 1)),
        ),
      ],
    );
  }
}
