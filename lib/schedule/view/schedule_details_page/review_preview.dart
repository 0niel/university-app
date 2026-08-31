part of '../schedule_details_page.dart';

class _ReviewPreview extends StatelessWidget {
  const _ReviewPreview({required this.review, super.key});

  final LessonReview review;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: Row(
        children: [
          NinjaAvatar(initials: _initialsOf(review.authorName), size: 32),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: review.authorName,
                    style: TextStyle(
                      color: colors.ink,
                      fontWeight: .w800,
                    ),
                  ),
                  TextSpan(text: ' · ${review.body}'),
                ],
              ),
              maxLines: 2,
              overflow: .ellipsis,
              style: NinjaText.subtext.copyWith(color: colors.muted),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${review.likeCount}',
            style: NinjaText.tabular(
              NinjaText.subtext.copyWith(color: colors.muted),
            ),
          ),
        ],
      ),
    );
  }
}
