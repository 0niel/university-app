import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/post_overview_comment_skeleton.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/post_overview_metrics.dart';

class PostOverviewSkeleton extends StatelessWidget {
  const PostOverviewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.md,
          AppSpacing.screen,
          AppSpacing.xxlg,
        ),
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: const Padding(
              padding: EdgeInsets.all(AppSpacing.sectionGap),
              child: Row(
                children: [
                  NinjaSkeleton(
                    width: PostOverviewMetrics.authorAvatar,
                    height: PostOverviewMetrics.authorAvatar,
                    radius: AppRadius.avatarLarge,
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NinjaSkeleton.bar(height: 16, widthFactor: 0.42),
                        SizedBox(height: AppSpacing.sm),
                        NinjaSkeleton.bar(widthFactor: 0.3),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xlg),
          const NinjaSkeleton.bar(height: 16),
          const SizedBox(height: AppSpacing.gap),
          const NinjaSkeleton.bar(height: 16, widthFactor: 0.92),
          const SizedBox(height: AppSpacing.gap),
          const NinjaSkeleton.bar(height: 16, widthFactor: 0.76),
          const SizedBox(height: 32),
          const NinjaSkeleton(width: 140, height: 22),
          const SizedBox(height: AppSpacing.lg),
          const PostOverviewCommentSkeleton(),
          const SizedBox(height: AppSpacing.md),
          const PostOverviewCommentSkeleton(),
          const SizedBox(height: AppSpacing.md),
          const PostOverviewCommentSkeleton(),
        ],
      ),
    );
  }
}
