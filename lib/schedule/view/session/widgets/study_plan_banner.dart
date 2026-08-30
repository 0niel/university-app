part of '../session_page.dart';

class _StudyPlanBanner extends StatelessWidget {
  const _StudyPlanBanner({required this.exams});

  final List<_Exam> exams;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final focus = exams.reduce((a, b) => a.readiness <= b.readiness ? a : b);

    return NinjaScheduleSurface(
      child: Row(
        children: [
          Container(
            width: NinjaMetrics.minTouchTarget,
            height: NinjaMetrics.minTouchTarget,
            decoration: BoxDecoration(
              color: colors.brandTint,
              shape: .circle,
            ),
            child: Center(
              child: AppLineIconWidget(
                .spark,
                size: 19,
                color: colors.brandInk,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.l10n.sessionStudyPlanText(
                focus.subject,
                (focus.readiness * 100).round(),
              ),
              style: NinjaText.subtext.copyWith(
                color: colors.ink,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 8),
          AppLineIconWidget(
            .chevronR,
            size: 16,
            color: colors.chevron,
          ),
        ],
      ),
    );
  }
}
