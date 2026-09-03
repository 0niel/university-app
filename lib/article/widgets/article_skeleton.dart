import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class ArticleSkeleton extends StatelessWidget {
  const ArticleSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NinjaSkeleton(height: 26, width: 96, radius: AppRadius.full),
          SizedBox(height: AppSpacing.sectionGap),
          NinjaSkeleton.bar(height: 28, widthFactor: .9),
          SizedBox(height: AppSpacing.sm),
          NinjaSkeleton.bar(height: 28, widthFactor: .6),
          SizedBox(height: AppSpacing.sectionGap),
          NinjaSkeleton.bar(height: 14, widthFactor: .95),
          SizedBox(height: AppSpacing.xsm),
          NinjaSkeleton.bar(height: 14, widthFactor: .7),
          SizedBox(height: AppSpacing.screen),
          NinjaSkeletonMedia(height: 220, radius: AppRadius.card),
          SizedBox(height: AppSpacing.screen),
          NinjaSkeleton.bar(height: 13),
          SizedBox(height: AppSpacing.sm),
          NinjaSkeleton.bar(height: 13, widthFactor: .92),
          SizedBox(height: AppSpacing.sm),
          NinjaSkeleton.bar(height: 13, widthFactor: .78),
        ],
      ),
    );
  }
}
