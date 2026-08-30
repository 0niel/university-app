part of 'schedule_cubit.dart';

@freezed
sealed class ScheduleState with _$ScheduleState {
  const factory ScheduleState({
    String? scheduleName,
    List<SchedulePart>? scheduleParts,
    @Default(ScheduleStatus.initial) ScheduleStatus status,
    @Default(0) int currentDayIndex,
    @Default(false) bool isPaired,
    @Default(false) bool isReachable,
  }) = _ScheduleState;

  const ScheduleState._();

  List<LessonSchedulePart> get lessonsForCurrentDay {
    if (scheduleParts == null) return [];

    final now = DateTime.now();
    final targetDate = now.add(Duration(days: currentDayIndex));

    return scheduleParts!
        .whereType<LessonSchedulePart>()
        .where(
          (lesson) => lesson.dates.any(
            (date) =>
                date.year == targetDate.year &&
                date.month == targetDate.month &&
                date.day == targetDate.day,
          ),
        )
        .toList()
      ..sort((a, b) {
        final aTime = a.lessonBells.startTime;
        final bTime = b.lessonBells.startTime;
        if (aTime.hour != bTime.hour) {
          return aTime.hour.compareTo(bTime.hour);
        }
        return aTime.minute.compareTo(bTime.minute);
      });
  }

  List<DateTime> get availableDays {
    if (scheduleParts == null) return [];
    final uniqueDays = <DateTime>{};
    for (final part in scheduleParts!.whereType<LessonSchedulePart>()) {
      for (final date in part.dates) {
        uniqueDays.add(DateTime(date.year, date.month, date.day));
      }
    }
    final days = uniqueDays.toList()..sort();
    return days;
  }
}
