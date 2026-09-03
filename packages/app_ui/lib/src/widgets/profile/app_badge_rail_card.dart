import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:app_ui/src/widgets/app_progress_ring.dart';
import 'package:flutter/widgets.dart';

const kBadgeRailCardWidth = 78.0;

const kBadgeRailCardHeight = 122.0;

class AppBadgeRailCard extends StatelessWidget {
  const AppBadgeRailCard({
    required this.emoji,
    required this.name,
    required this.isEarned,
    super.key,
    this.progress,
    this.progressLabel,
    this.onTap,
  });

  final String emoji;
  final String name;
  final bool isEarned;
  final double? progress;
  final String? progressLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final progress = this.progress;
    final progressLabel = this.progressLabel;

    return AppPressable(
      onTap: onTap,
      semanticsLabel: name,
      child: SizedBox(
        width: kBadgeRailCardWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: 54,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (!isEarned && progress != null)
                    AppProgressRing(value: progress, size: 54, strokeWidth: 3),
                  Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isEarned ? colors.tint : colors.surface2,
                      shape: BoxShape.circle,
                    ),
                    child: Opacity(
                      opacity: isEarned ? 1 : .45,
                      child: Text(
                        emoji,
                        style: AppText.sans(20, FontWeight.w400, height: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppText.captionSmall.copyWith(
                color: isEarned ? colors.ink : colors.muted,
                height: 1.2,
              ),
            ),
            if (!isEarned && progressLabel != null) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(
                progressLabel,
                maxLines: 1,
                style: AppText.tabular(AppText.captionSmall).copyWith(
                  color: colors.muted2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
