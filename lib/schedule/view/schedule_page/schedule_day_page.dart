part of '../schedule_page.dart';

class _ScheduleDayPage extends StatelessWidget {
  const _ScheduleDayPage({
    required this.day,
    required this.parts,
    required this.preferences,
    required this.activities,
    required this.filter,
    required this.showPast,
    required this.nowMarkerKey,
    required this.onRefresh,
    required this.onTogglePast,
    required this.onAddActivity,
    required this.onShowWeek,
    required this.onFilterChanged,
    required this.onLessonTap,
    required this.onLessonActions,
    super.key,
  });

  final DateTime day;
  final List<SchedulePart> parts;
  final SchedulePreferencesState preferences;
  final UserActivitiesState activities;
  final _ScheduleFilter filter;
  final bool showPast;
  final GlobalKey? nowMarkerKey;
  final Future<void> Function() onRefresh;
  final VoidCallback onTogglePast;
  final VoidCallback onAddActivity;
  final VoidCallback onShowWeek;
  final ValueChanged<_ScheduleFilter> onFilterChanged;
  final void Function(LessonSchedulePart lesson, DateTime day) onLessonTap;
  final void Function(LessonSchedulePart lesson, DateTime day) onLessonActions;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final model = _ScheduleDayModel.resolve(
      parts: parts,
      day: day,
      preferences: preferences,
      activities: activities,
      filter: filter,
    );

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: colors.ink,
      backgroundColor: colors.canvas,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: _agendaSlivers(
          day: day,
          parts: parts,
          model: model,
          filter: filter,
          showPast: showPast,
          nowMarkerKey: nowMarkerKey,
          onTogglePast: onTogglePast,
          onAddActivity: onAddActivity,
          onShowWeek: onShowWeek,
          onFilterChanged: onFilterChanged,
          onLessonTap: onLessonTap,
          onLessonActions: onLessonActions,
        ),
      ),
    );
  }
}
