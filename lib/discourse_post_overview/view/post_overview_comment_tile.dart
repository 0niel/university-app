import 'package:app_ui/app_ui.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/ninja_forum_avatar.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/post_overview_formatting.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/post_overview_html.dart';

class PostOverviewCommentTile extends StatelessWidget {
  const PostOverviewCommentTile({required this.comment, super.key});

  final DiscoursePostComment comment;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NinjaForumAvatar(
                  size: 38,
                  url: avatarUrl(
                    context.read<UniversityConfig>().communityForumUrl,
                    comment.avatarTemplate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.username,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: NinjaText.headline.copyWith(color: colors.ink),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formatPostDate(comment.createdAt),
                        style: NinjaText.helper.copyWith(color: colors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SelectionArea(child: PostOverviewHtml(data: comment.cooked)),
            if (comment.likeCount > 0) ...[
              const SizedBox(height: 8),
              Semantics(
                label: '${comment.likeCount}',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppLineIconWidget(
                      AppLineIcon.heart,
                      size: 16,
                      color: colors.scarlet,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${comment.likeCount}',
                      style: NinjaText.helper.copyWith(color: colors.muted),
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
