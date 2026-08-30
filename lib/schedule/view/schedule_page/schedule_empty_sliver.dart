part of '../schedule_page.dart';

class _ScheduleEmptySliver extends StatelessWidget {
  const _ScheduleEmptySliver({
    required this.day,
    required this.schedule,
    required this.onAddActivity,
    required this.onShowWeek,
    required this.onLessonTap,
  });

  final DateTime day;
  final List<SchedulePart> schedule;
  final VoidCallback onAddActivity;
  final VoidCallback onShowWeek;
  final void Function(LessonSchedulePart lesson, DateTime day) onLessonTap;

  ({DateTime day, LessonSchedulePart lesson})? _nearest() {
    for (var offset = 1; offset <= 14; offset++) {
      final candidate = dateOnly(day).add(Duration(days: offset));
      final lesson = _lessonsForDay(schedule, candidate).firstOrNull;
      if (lesson != null) return (day: candidate, lesson: lesson);
    }
    return null;
  }

  String _nearestText(
    BuildContext context,
    ({DateTime day, LessonSchedulePart lesson})? nearest,
  ) {
    final l10n = context.l10n;
    if (nearest == null) return l10n.noUpcomingLessons;
    final locale = Localizations.localeOf(context).toString();
    final dow = DateFormat('EEEE', locale).format(nearest.day);
    return l10n.nearestLessonText(
      dow,
      '${nearest.lesson.lessonBells.startTime}',
      nearest.lesson.subject,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dayInfo = RussianWorkCalendar.dayInfo(day);
    final activities = context.watch<UserActivitiesCubit>().state.forDay(day);
    final nearest = _nearest();

    final String title;
    final String message;
    if (dayInfo.isNonWorking) {
      title = _scheduleDayLabel(context, dayInfo);
      message = _nearestText(context, nearest);
    } else {
      final isToday = isSameDate(day, DateTime.now());
      title = isToday ? l10n.dayOffTitle : l10n.noLessonsSelectedDay;
      message = activities.isEmpty
          ? _nearestText(context, nearest)
          : l10n.dayOffWithActivities;
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        _ScheduleEmptyBlock(
          title: title,
          message: message,
          actions: [
            NinjaButton.primary(
              label: dayInfo.isNonWorking ? l10n.whatToDo : l10n.addActivity,
              size: .medium,
              expanded: true,
              onPressed: onAddActivity,
            ),
            NinjaButton.secondary(
              label: l10n.viewWeek,
              size: .medium,
              expanded: true,
              onPressed: onShowWeek,
            ),
          ],
        ),
        if (nearest != null)
          _ScheduleNextLessonCard(
            day: nearest.day,
            lesson: nearest.lesson,
            onTap: () => onLessonTap(nearest.lesson, nearest.day),
          ),
        for (final activity in activities) _ActivityRow(activity: activity),
        SizedBox(height: 112 + ninjaBottomInset(context)),
      ]),
    );
  }
}

Color _activityColor(NinjaColors colors, UserActivityType type) {
  final index = switch (type) {
    .event => 3,
    .retake => 2,
    .extra => 6,
    .personal => 4,
    .consult => 1,
  };
  final palette = colors.mireaAccentPalette;
  return colors.accentInk(palette.elementAtOrNull(index) ?? colors.brand);
}
