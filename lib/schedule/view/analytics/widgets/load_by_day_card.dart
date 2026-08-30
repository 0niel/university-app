part of '../analytics_page.dart';

class _LoadByDayCard extends StatelessWidget {
  const _LoadByDayCard({required this.stats});

  final AnalyticsStats stats;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final labels = [
      l10n.weekdayShortMon,
      l10n.weekdayShortTue,
      l10n.weekdayShortWed,
      l10n.weekdayShortThu,
      l10n.weekdayShortFri,
      l10n.weekdayShortSat,
      l10n.weekdayShortSun,
    ];
    final maxHours = stats.hoursByWeekday.values.fold<double>(
      1,
      (max, hours) => hours > max ? hours : max,
    );
    final overloaded = stats.hoursByWeekday.entries
        .where((entry) => entry.value >= 8)
        .toList();
    final overloadedDay = overloaded.firstOrNull;
    final overloadedDayLabel = overloadedDay == null
        ? null
        : labels.elementAtOrNull(overloadedDay.key - 1);

    return NinjaScheduleSurface(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            l10n.analyticsLoadByDay,
            style: NinjaText.headline.copyWith(color: colors.ink),
          ),
          const SizedBox(height: 4),
          Text(
            overloadedDay != null && overloadedDayLabel != null
                ? l10n.analyticsOverloadedDay(
                    overloadedDayLabel,
                    overloadedDay.value.toStringAsFixed(0),
                  )
                : l10n.analyticsBalancedWeek,
            style: NinjaText.subtext.copyWith(color: colors.muted),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 130,
            child: Row(
              crossAxisAlignment: .end,
              spacing: 8,
              children: [
                for (var weekday = 1; weekday <= 7; weekday++)
                  Expanded(
                    child: _DayBar(
                      label: labels.elementAtOrNull(weekday - 1) ?? '',
                      hours: stats.hoursByWeekday[weekday] ?? 0,
                      maxHours: maxHours,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
