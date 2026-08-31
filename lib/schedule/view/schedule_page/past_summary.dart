part of '../schedule_page.dart';

class _PastSummary extends StatelessWidget {
  const _PastSummary({
    required this.count,
    required this.expanded,
    required this.onTap,
  });

  final int count;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        10,
      ),
      child: AppPressable(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const .symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: colors.surfaceAlt,
            borderRadius: .circular(NinjaRadius.pill),
          ),
          child: Row(
            children: [
              AppLineIconWidget(
                expanded ? AppLineIcon.hide : AppLineIcon.clock,
                size: 18,
                color: colors.mutedDark,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  expanded
                      ? l10n.hidePastLessons
                      : l10n.pastTodaySummary(lessonCountText(l10n, count)),
                  style: NinjaText.body.copyWith(color: colors.mutedDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
