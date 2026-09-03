import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_card.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_progress_ring.dart';
import 'package:flutter/widgets.dart';

class AppQuestCard extends StatelessWidget {
  const AppQuestCard({
    required this.title,
    required this.progress,
    required this.target,
    required this.xpReward,
    super.key,
    this.isDone = false,
  });

  final String title;
  final int progress;
  final int target;
  final int xpReward;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fraction = target > 0 ? (progress / target).clamp(0.0, 1.0) : 0.0;
    final tone = isDone ? colors.success : colors.accent;

    return AppCard(
      color: isDone ? colors.successTint : colors.surface,
      padding: const EdgeInsets.all(AppSpacing.sectionGap),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: isDone
                ? DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.success,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: AppLineIconWidget(
                        AppLineIcon.check,
                        size: AppIconSize.compact,
                        color: colors.onAccent,
                        strokeWidth: 2.4,
                      ),
                    ),
                  )
                : AppProgressRing(value: fraction, size: 36, strokeWidth: 3),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodyStrong.copyWith(
                    color: isDone ? colors.success : colors.ink,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '$progress / $target',
                  style: AppText.tabular(AppText.caption).copyWith(
                    color: colors.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            '+$xpReward XP',
            style: AppText.tabular(AppText.captionBold).copyWith(color: tone),
          ),
        ],
      ),
    );
  }
}
