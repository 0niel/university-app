import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class MiniAppCardSkeleton extends StatelessWidget {
  const MiniAppCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final titleHeight = (12 * textScale).clamp(12.0, 22.0);
    final detailHeight = (11 * textScale).clamp(11.0, 18.0);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Padding(
        padding: const .all(16),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.tint,
                borderRadius: .circular(AppRadius.full),
              ),
              child: const SizedBox.square(
                dimension: AppControlSize.touchTarget,
                child: Center(
                  child: NinjaSkeleton.avatar(size: AppIconSize.md),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sectionGap),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  NinjaSkeleton.bar(
                    height: titleHeight,
                    widthFactor: 0.5,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  NinjaSkeleton.bar(height: detailHeight),
                  const SizedBox(height: 5),
                  NinjaSkeleton.bar(
                    height: detailHeight,
                    widthFactor: 0.6,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Column(
              crossAxisAlignment: .end,
              spacing: 6,
              children: [
                NinjaSkeleton(width: 28, height: 11),
                NinjaSkeleton(width: 44, height: 11),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
