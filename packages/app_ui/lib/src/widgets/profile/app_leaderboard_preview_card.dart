import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_icon_tile.dart';
import 'package:app_ui/src/widgets/app_list_group.dart';
import 'package:app_ui/src/widgets/gamification/app_leaderboard_entry.dart';
import 'package:app_ui/src/widgets/profile/profile_xp.dart';
import 'package:flutter/widgets.dart';

class AppLeaderboardPreviewCard extends StatelessWidget {
  const AppLeaderboardPreviewCard({required this.entries, super.key});

  final List<AppLeaderboardEntry> entries;

  @override
  Widget build(BuildContext context) {
    return AppListGroup(
      children: [
        for (final entry in entries) _PreviewRow(entry: entry),
      ],
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({required this.entry});

  final AppLeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isCurrentUser = entry.isCurrentUser;

    return ColoredBox(
      color: isCurrentUser ? colors.tint : colors.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '#${entry.position}',
                style: AppText.tabular(AppText.captionBold).copyWith(
                  color: isCurrentUser ? colors.accent : colors.muted2,
                ),
              ),
            ),
            AppIconTile(
              size: 32,
              radius: AppRadius.banner,
              background: colors.tint2,
              child: Text(
                entry.initials,
                style: AppText.sans(11, FontWeight.w800).copyWith(
                  color: colors.accent,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                entry.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: isCurrentUser
                    ? AppText.bodyBold.copyWith(color: colors.accent)
                    : AppText.body.copyWith(color: colors.ink),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: formatThousands(entry.xp),
                    style: AppText.tabular(AppText.bodyStrong).copyWith(
                      color: colors.ink,
                    ),
                  ),
                  TextSpan(
                    text: ' XP',
                    style: AppText.captionSmall.copyWith(color: colors.muted2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
