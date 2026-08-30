import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

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
      child: SizedBox(
        width: kBadgeRailCardWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 54,
              height: 54,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (!isEarned && progress != null)
                    AppProgressRing(value: progress, size: 54, strokeWidth: 3),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isEarned
                          ? colors.primary.withValues(alpha: 0.12)
                          : colors.surfaceHigh,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: isEarned ? 1 : 0.45,
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppText.captionSmall.copyWith(
                color: isEarned ? colors.active : colors.deactive,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
            if (!isEarned && progressLabel != null) ...[
              const SizedBox(height: 2),
              Text(
                progressLabel,
                maxLines: 1,
                style: AppText.tabular(AppText.captionSmall).copyWith(
                  color: colors.deactiveDarker,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
