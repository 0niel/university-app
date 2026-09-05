import 'package:app_ui/app_ui.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/ninja_forum_avatar.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/post_overview_formatting.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/post_overview_html.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/post_overview_metrics.dart';

class PostOverviewCommentTile extends StatelessWidget {
  const PostOverviewCommentTile({
    required this.comment,
    this.sourceUri,
    super.key,
  });

  final DiscoursePostComment comment;
  final Uri? sourceUri;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NinjaForumAvatar(
                  name: comment.username,
                  size: PostOverviewMetrics.commentAvatar,
                  url: avatarUrl(
                    context.read<UniversityConfig>().communityForumUrl,
                    comment.avatarTemplate,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.username,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.headline.copyWith(color: colors.ink),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        formatPostDate(comment.createdAt),
                        style: AppText.captionSmall.copyWith(
                          color: colors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.gap),
            SelectionArea(
              child: PostOverviewHtml(
                data: comment.cooked,
                sourceUri: sourceUri,
              ),
            ),
            if (comment.likeCount > 0) ...[
              const SizedBox(height: AppSpacing.sm),
              Semantics(
                label: '${comment.likeCount}',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppLineIconWidget(
                      AppLineIcon.heart,
                      size: 16,
                      color: colors.exam,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${comment.likeCount}',
                      style: AppText.captionSmall.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
