part of 'post_overview_body.dart';

class _PostAuthorHeader extends StatelessWidget {
  const _PostAuthorHeader({required this.post});

  final DiscoursePost post;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            NinjaForumAvatar(
              size: 46,
              url: avatarUrl(
                context.read<UniversityConfig>().communityForumUrl,
                post.avatarTemplate,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.username,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: NinjaText.headline.copyWith(color: colors.ink),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    formatPostDate(post.createdAt),
                    style: NinjaText.subtext.copyWith(color: colors.muted),
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
