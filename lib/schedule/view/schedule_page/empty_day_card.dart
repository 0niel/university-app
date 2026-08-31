part of '../schedule_page.dart';

class _EmptyDayCard extends StatelessWidget {
  const _EmptyDayCard({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dayInfo = RussianWorkCalendar.dayInfo(day);
    return _ScheduleEmptyBlock(
      title: dayInfo.isNonWorking
          ? _scheduleDayLabel(context, dayInfo)
          : l10n.dayOffTitle,
      message: l10n.noLessonsSelectedDay,
    );
  }
}
