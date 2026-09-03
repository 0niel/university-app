part of 'teacher_profile_page.dart';

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review, this.compact = false});

  final TeacherReview review;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: compact
          ? const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 13)
          : const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            spacing: AppSpacing.gap,
            children: [
              if (!compact) AppAvatar(name: review.authorName, size: 32),
              Expanded(
                child: Text(
                  review.authorName,
                  style:
                      (compact
                              ? AppText.sans(12, FontWeight.w600)
                              : AppText.body)
                          .copyWith(color: compact ? colors.muted : colors.ink),
                ),
              ),
              Text(
                '★' * review.average.round(),
                style: AppText.subtext.copyWith(color: colors.accent),
              ),
            ],
          ),
          if (review.body.isNotEmpty) ...[
            SizedBox(height: compact ? 6 : 8),
            Text(
              review.body,
              style: AppText.sans(14, FontWeight.w400).copyWith(
                color: compact ? colors.ink : colors.muted,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
