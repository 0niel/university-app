import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class FeedHeroSkeleton extends StatelessWidget {
  const FeedHeroSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.hero),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NinjaSkeletonMedia(height: 190, radius: AppRadius.hero),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.fieldGap,
              AppSpacing.lg,
              AppSpacing.fieldGap,
              AppSpacing.fieldGap,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NinjaSkeleton.bar(height: 10, widthFactor: .3),
                SizedBox(height: AppSpacing.md),
                NinjaSkeleton.bar(height: 18, widthFactor: .9),
                SizedBox(height: AppSpacing.sm),
                NinjaSkeleton.bar(height: 18, widthFactor: .6),
                SizedBox(height: AppSpacing.md),
                NinjaSkeleton.bar(height: 11, widthFactor: .8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FeedRowSkeleton extends StatelessWidget {
  const FeedRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sectionGap,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NinjaSkeleton.bar(height: 10, widthFactor: .35),
                SizedBox(height: AppSpacing.gap),
                NinjaSkeleton.bar(height: 13, widthFactor: .95),
                SizedBox(height: AppSpacing.xsm),
                NinjaSkeleton.bar(height: 13, widthFactor: .7),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sectionGap),
          NinjaSkeleton(height: 72, width: 72, radius: AppRadius.banner),
        ],
      ),
    );
  }
}

class FeedListSkeleton extends StatelessWidget {
  const FeedListSkeleton({super.key, this.rows = 3, this.hero = true});

  final int rows;
  final bool hero;

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      child: Column(
        children: [
          if (hero) ...[
            const FeedHeroSkeleton(),
            const SizedBox(height: AppSpacing.gap),
          ],
          AppListGroup(
            children: [for (var i = 0; i < rows; i++) const FeedRowSkeleton()],
          ),
        ],
      ),
    );
  }
}
