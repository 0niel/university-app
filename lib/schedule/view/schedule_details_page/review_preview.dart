part of '../schedule_details_page.dart';

class _ReviewPreview extends StatelessWidget {
  const _ReviewPreview({required this.review, super.key});

  final LessonReview review;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const .all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(AppRadius.card),
      ),
      child: Row(
        children: [
          AppAvatar(name: review.authorName, size: 32),
          const SizedBox(width: AppSpacing.gap),
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
              style: AppText.subtext.copyWith(color: colors.muted),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${review.likeCount}',
            style: AppText.tabular(
              AppText.subtext.copyWith(color: colors.muted),
            ),
          ),
        ],
      ),
    );
  }
}
