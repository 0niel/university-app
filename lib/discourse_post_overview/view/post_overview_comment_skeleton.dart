import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/post_overview_metrics.dart';

class PostOverviewCommentSkeleton extends StatelessWidget {
  const PostOverviewCommentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: const Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                NinjaSkeleton(
                  width: PostOverviewMetrics.commentAvatar,
                  height: PostOverviewMetrics.commentAvatar,
                  radius: AppRadius.avatarSmall,
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NinjaSkeleton.bar(
                        height: PostOverviewMetrics.skeletonLine,
                        widthFactor: 0.45,
                      ),
                      SizedBox(height: 7),
                      NinjaSkeleton.bar(height: 11, widthFactor: 0.32),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            NinjaSkeleton.bar(height: PostOverviewMetrics.skeletonLine),
            SizedBox(height: AppSpacing.sm),
            NinjaSkeleton.bar(
              height: PostOverviewMetrics.skeletonLine,
              widthFactor: 0.78,
            ),
          ],
        ),
      ),
    );
  }
}
