import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/top_discussions/view/discourse_topic_utils.dart';

class TopicNewsCard extends StatelessWidget {
  const TopicNewsCard({required this.topic, super.key, this.author});

  final DiscourseTopic topic;
  final DiscourseUser? author;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final comments = (topic.postsCount - 1).clamp(0, 9999);
    final excerpt = topic.excerpt;
    final forumUrl = context.read<UniversityConfig>().communityForumUrl;

    return AppPressable(
      onTap: () => unawaited(openDiscourseTopic(forumUrl, topic.id)),
      semanticsLabel: topic.title,
      child: Container(
        width: 296,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Container(
                    width: 22,
                    height: 22,
                    color: colors.surface2,
                    child: Image.network(
                      discourseAvatarUrl(forumUrl, author),
                      excludeFromSemantics: true,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    author?.username ?? Uri.parse(forumUrl).host,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.subtext.copyWith(color: colors.ink),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  topicTimeAgo(context.l10n, topic.lastPostedAt),
                  style: AppText.captionSmall.copyWith(color: colors.muted),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              topic.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppText.headline.copyWith(color: colors.ink),
            ),
            if (excerpt != null && excerpt.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xsm),
              Text(
                excerpt,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.subtext.copyWith(
                  height: 1.45,
                  color: colors.muted,
                ),
              ),
            ],
            const Spacer(),
            Row(
              children: [
                Text(
                  '${topic.likeCount}',
                  style: AppText.tabular(
                    AppText.captionSmall.copyWith(color: colors.muted),
                  ),
                ),
                const SizedBox(width: 5),
                AppLineIconWidget(
                  AppLineIcon.heart,
                  size: 14,
                  color: colors.muted,
                ),
                const SizedBox(width: AppSpacing.sectionGap),
                Text(
                  '$comments',
                  style: AppText.tabular(
                    AppText.captionSmall.copyWith(color: colors.muted),
                  ),
                ),
                const SizedBox(width: 5),
                AppLineIconWidget(
                  AppLineIcon.message,
                  size: 14,
                  color: colors.muted,
                ),
                const Spacer(),
                AppLineIconWidget(
                  AppLineIcon.chevronR,
                  size: 16,
                  color: colors.muted2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
