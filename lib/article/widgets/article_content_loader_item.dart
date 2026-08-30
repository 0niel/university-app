import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class ArticleContentLoaderItem extends StatelessWidget {
  const ArticleContentLoaderItem({super.key});

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final titleHeight = (28 * textScale).clamp(28.0, 48.0);
    final lineHeight = (14 * textScale).clamp(14.0, 24.0);
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.xlg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NinjaSkeleton(height: titleHeight, widthFactor: .82),
            const SizedBox(height: AppSpacing.md),
            NinjaSkeleton(height: titleHeight, widthFactor: .58),
            const SizedBox(height: AppSpacing.xl),
            const NinjaSkeletonMedia(height: 220, radius: NinjaRadius.card),
            const SizedBox(height: AppSpacing.xl),
            NinjaSkeleton.bar(height: lineHeight),
            const SizedBox(height: AppSpacing.sm),
            NinjaSkeleton.bar(height: lineHeight, widthFactor: .9),
            const SizedBox(height: AppSpacing.sm),
            NinjaSkeleton.bar(height: lineHeight, widthFactor: .7),
          ],
        ),
      ),
    );
  }
}
