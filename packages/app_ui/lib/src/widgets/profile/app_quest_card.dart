import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

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
    final accent = isDone ? colors.success : colors.primary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDone ? colors.success.withValues(alpha: 0.12) : colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            height: 34,
            child: isDone
                ? Container(
                    decoration: BoxDecoration(
                      color: colors.success,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: colors.onAccent,
                    ),
                  )
                : AppProgressRing(value: fraction, size: 34, strokeWidth: 3),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body.copyWith(
                    color: isDone ? colors.success : colors.active,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$progress / $target',
                  style: AppText.tabular(AppText.captionSmall).copyWith(
                    color: colors.deactiveDarker,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '+$xpReward XP',
            style: AppText.tabular(AppText.caption).copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
