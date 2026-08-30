part of '../schedule_details_page.dart';

class _EmptyReviewPrompt extends StatelessWidget {
  const _EmptyReviewPrompt({super.key});

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
          Expanded(
            child: Text(
              context.l10n.lessonDetailsLeaveReview,
              style: NinjaText.body.copyWith(color: colors.ink),
            ),
          ),
          const SizedBox(width: 8),
          AppLineIconWidget(
            AppLineIcon.chevronR,
            size: 16,
            color: colors.chevron,
          ),
        ],
      ),
    );
  }
}
