part of '../schedule_page.dart';

class _WeekParitySwitcher extends StatelessWidget {
  const _WeekParitySwitcher({
    required this.weekStart,
    required this.onPrev,
    required this.onNext,
  });

  final DateTime weekStart;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final weekEnd = weekStart.add(const Duration(days: 6));
    final week = studyWeekNumber(weekStart);

    return Padding(
      padding: const .symmetric(vertical: 3),
      child: Row(
        children: [
          NinjaIconButton(
            icon: AppLineIconWidget(
              AppLineIcon.chevronL,
              size: 18,
              color: colors.ink,
            ),
            tooltip: l10n.previousWeek,
            onPressed: onPrev,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  week > 0 ? l10n.studyWeekNumber(week) : '',
                  style: NinjaText.body.copyWith(color: colors.ink),
                ),
                const SizedBox(height: 2),
                Text(
                  '${DateFormat('d MMM', locale).format(weekStart)} – '
                  '${DateFormat('d MMM', locale).format(weekEnd)}',
                  style: NinjaText.subtext.copyWith(color: colors.mutedDark),
                ),
              ],
            ),
          ),
          NinjaIconButton(
            icon: AppLineIconWidget(
              AppLineIcon.chevronR,
              size: 18,
              color: colors.ink,
            ),
            tooltip: l10n.nextWeek,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
