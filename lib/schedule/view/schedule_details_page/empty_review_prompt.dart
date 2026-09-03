part of '../schedule_details_page.dart';

class _EmptyReviewPrompt extends StatelessWidget {
  const _EmptyReviewPrompt({super.key});

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
          Expanded(
            child: Text(
              context.l10n.lessonDetailsLeaveReview,
              style: AppText.body.copyWith(color: colors.ink),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppLineIconWidget(
            AppLineIcon.chevronR,
            size: 16,
            color: colors.muted2,
          ),
        ],
      ),
    );
  }
}
