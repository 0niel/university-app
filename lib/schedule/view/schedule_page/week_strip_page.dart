part of '../schedule_page.dart';

class _WeekStripPage extends StatelessWidget {
  const _WeekStripPage({
    required this.days,
    required this.selectedDay,
    required this.lessonColors,
    required this.activities,
    required this.dayLayoutKeyBuilder,
    required this.onDaySelected,
  });

  final List<DateTime> days;
  final DateTime selectedDay;
  final Map<int, List<Color>> lessonColors;
  final UserActivitiesState activities;
  final GlobalKey Function(DateTime day) dayLayoutKeyBuilder;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
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
    final locale = Localizations.localeOf(context).toString();
    final today = DateTime.now();

    return Row(
      crossAxisAlignment: .stretch,
      children: [
        for (final (index, day) in days.indexed)
          Expanded(
            child: _ScheduleDayButton(
              day: day,
              lessonColors: lessonColors[_dayKey(day)] ?? const [],
              activityTypes: activities.typesOn(day),
              shortLabel: labels.elementAtOrNull(index) ?? '',
              selected: isSameDate(day, selectedDay),
              today: isSameDate(day, today),
              locale: locale,
              layoutKey: dayLayoutKeyBuilder(day),
              onTap: () => onDaySelected(day),
            ),
          ),
      ],
    );
  }
}
