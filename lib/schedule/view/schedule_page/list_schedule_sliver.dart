part of '../schedule_page.dart';

class _ListScheduleSliver extends StatelessWidget {
  const _ListScheduleSliver({
    required this.day,
    required this.lessons,
    required this.filtered,
    required this.showPast,
    required this.nowMarkerKey,
    required this.onTogglePast,
    required this.onLessonTap,
    required this.onLessonActions,
  });

  final DateTime day;
  final List<LessonSchedulePart> lessons;
  final bool filtered;
  final bool showPast;
  final GlobalKey? nowMarkerKey;
  final VoidCallback onTogglePast;
  final void Function(LessonSchedulePart lesson, DateTime day) onLessonTap;
  final void Function(LessonSchedulePart lesson, DateTime day) onLessonActions;

  @override
  Widget build(BuildContext context) {
    final preferences = context.watch<SchedulePreferencesCubit>().state;
    final isToday = isSameDate(day, DateTime.now());
    final effectiveShowPast =
        showPast || filtered || !preferences.collapsePast || !isToday;
    final visibleLessons = effectiveShowPast
        ? lessons
        : lessons.where((lesson) => !_lessonStatus(lesson, day).past).toList();
    final pastCount = lessons
        .where((lesson) => _lessonStatus(lesson, day).past)
        .length;
    final activities = context.watch<UserActivitiesCubit>().state.forDay(day);

    return SliverPadding(
      padding: .only(top: 6, bottom: 84 + ninjaBottomInset(context)),
      sliver: SliverToBoxAdapter(
        child: NinjaStateSwitcher(
          child: Column(
            key: ValueKey(day),
            crossAxisAlignment: .stretch,
            children: [
              if (isToday &&
                  !filtered &&
                  preferences.collapsePast &&
                  pastCount > 0)
                _PastSummary(
                  count: pastCount,
                  expanded: showPast,
                  onTap: onTogglePast,
                ),
              if (visibleLessons.isEmpty && activities.isEmpty)
                _EmptyDayCard(day: day)
              else if (visibleLessons.isNotEmpty || activities.isNotEmpty)
                ..._timelineChildren(
                  context: context,
                  lessons: visibleLessons,
                  day: day,
                  nowMarkerKey: nowMarkerKey,
                  showGaps: preferences.showGaps,
                  onLessonTap: onLessonTap,
                  onLessonActions: onLessonActions,
                  activities: activities,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
