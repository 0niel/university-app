part of '../schedule_page.dart';

class _ScheduleHeader extends StatelessWidget {
  const _ScheduleHeader({
    required this.selectedDay,
    required this.lessons,
  });

  final DateTime selectedDay;
  final List<LessonSchedulePart> lessons;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final weekday = capitalizeFirst(
      DateFormat('EEEE', locale).format(selectedDay),
    );
    final date = DateFormat('d MMMM', locale).format(selectedDay);
    final dayInfo = RussianWorkCalendar.dayInfo(selectedDay);
    final campuses = _campusCount(lessons);
    final summary = [
      lessonCountText(l10n, lessons.length),
      if (campuses > 0) l10n.campusesCount(campuses),
    ].join(' · ');

    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        10,
        NinjaMetrics.screenPadding,
        8,
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Text(
            '$weekday, $date',
            maxLines: 2,
            overflow: .ellipsis,
            style: NinjaText.title.copyWith(color: colors.ink),
          ),
          if (dayInfo.isSpecial) ...[
            const SizedBox(height: 7),
            Align(
              alignment: Alignment.centerLeft,
              child: _ScheduleDayOffPill(info: dayInfo),
            ),
          ],
          if (!dayInfo.transferCalendarKnown) ...[
            const SizedBox(height: 7),
            Align(
              alignment: Alignment.centerLeft,
              child: _ScheduleTransferCoveragePill(year: selectedDay.year),
            ),
          ],
          const SizedBox(height: 3),
          Text(
            summary,
            maxLines: 2,
            overflow: .ellipsis,
            style: NinjaText.subtext.copyWith(
              color: colors.mutedDark,
            ),
          ),
        ],
      ),
    );
  }
}

int _campusCount(List<LessonSchedulePart> lessons) {
  final campuses = <String>{};
  for (final lesson in lessons) {
    for (final classroom in lesson.classrooms) {
      final campus = classroom.campus;
      if (campus == null) continue;
      final name = campus.shortName ?? campus.name;
      if (name.isNotEmpty) campuses.add(name);
    }
  }
  return campuses.length;
}
