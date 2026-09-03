part of 'post_overview_body.dart';

class _PostAuthorHeader extends StatelessWidget {
  const _PostAuthorHeader({required this.post});

  final DiscoursePost post;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sectionGap),
        child: Row(
          children: [
            NinjaForumAvatar(
              name: post.username,
              size: PostOverviewMetrics.authorAvatar,
              url: avatarUrl(
                context.read<UniversityConfig>().communityForumUrl,
                post.avatarTemplate,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.username,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.headline.copyWith(color: colors.ink),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    formatPostDate(post.createdAt),
                    style: AppText.subtext.copyWith(color: colors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
