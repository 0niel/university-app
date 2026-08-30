import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/post_overview_comment_skeleton.dart';

class PostOverviewSkeleton extends StatelessWidget {
  const PostOverviewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          NinjaMetrics.screenPadding,
          12,
          NinjaMetrics.screenPadding,
          40,
        ),
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.ninja.surfaceAlt,
              borderRadius: BorderRadius.circular(NinjaRadius.card),
            ),
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Row(
                children: [
                  NinjaSkeleton(width: 46, height: 46, radius: 23),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NinjaSkeleton.bar(height: 16, widthFactor: 0.42),
                        SizedBox(height: 8),
                        NinjaSkeleton.bar(widthFactor: 0.3),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const NinjaSkeleton.bar(height: 16),
          const SizedBox(height: 10),
          const NinjaSkeleton.bar(height: 16, widthFactor: 0.92),
          const SizedBox(height: 10),
          const NinjaSkeleton.bar(height: 16, widthFactor: 0.76),
          const SizedBox(height: 32),
          const NinjaSkeleton(width: 140, height: 22),
          const SizedBox(height: 16),
          const PostOverviewCommentSkeleton(),
          const SizedBox(height: 12),
          const PostOverviewCommentSkeleton(),
          const SizedBox(height: 12),
          const PostOverviewCommentSkeleton(),
        ],
      ),
    );
  }
}
