import 'package:app_ui/app_ui.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/post_overview_comment_tile.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class PostOverviewCommentsSection extends StatelessWidget {
  const PostOverviewCommentsSection({
    required this.comments,
    this.loadFailed = false,
    this.onRetry,
    super.key,
  });

  final List<DiscoursePostComment> comments;
  final bool loadFailed;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: .start,
      spacing: AppSpacing.lg,
      children: [
        Text(
          loadFailed && comments.isEmpty
              ? context.l10n.comments
              : context.l10n.postDetailComments(comments.length),
          style: AppText.section.copyWith(color: colors.ink),
        ),
        if (loadFailed)
          AppBanner(
            message: context.l10n.postDetailCommentsLoadError,
            tone: AppBannerTone.warn,
            actionLabel: context.l10n.retry,
            onAction: onRetry,
          ),
        if (comments.isEmpty && !loadFailed)
          Text(
            context.l10n.postDetailNoComments,
            style: AppText.body.copyWith(color: colors.muted),
          ),
        if (comments.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: comments.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) =>
                PostOverviewCommentTile(comment: comments[index]),
          ),
      ],
    );
  }
}
