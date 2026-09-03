import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_divider.dart';
import 'package:app_ui/src/widgets/app_icon_tile.dart';
import 'package:app_ui/src/widgets/gamification/app_leaderboard_entry.dart';
import 'package:app_ui/src/widgets/gamification/xp_text_formatter.dart';
import 'package:flutter/widgets.dart';

class AppLeaderboardRow extends StatelessWidget {
  const AppLeaderboardRow({
    required this.entry,
    required this.isFirst,
    super.key,
  });

  final AppLeaderboardEntry entry;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isCurrentUser = entry.isCurrentUser;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isFirst) const AppDivider(indent: AppSpacing.lg),
        ColoredBox(
          color: isCurrentUser ? colors.tint : colors.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.actionInset,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 26,
                  child: Text(
                    '#${entry.position}',
                    style: AppText.tabular(AppText.captionBold).copyWith(
                      color: isCurrentUser ? colors.accent : colors.muted2,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                AppIconTile(
                  radius: AppRadius.field,
                  background: colors.tint2,
                  child: Text(
                    entry.initials,
                    style: AppText.captionBold.copyWith(color: colors.accent),
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
                Text(
                  formatXp(entry.xp),
                  style: AppText.tabular(AppText.bodyStrong).copyWith(
                    color: colors.ink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
