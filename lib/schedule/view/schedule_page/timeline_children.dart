part of '../schedule_page.dart';

List<Widget> _timelineChildren({
  required BuildContext context,
  required List<LessonSchedulePart> lessons,
  required DateTime day,
  required void Function(LessonSchedulePart lesson, DateTime day) onLessonTap,
  required void Function(LessonSchedulePart lesson, DateTime day)
  onLessonActions,
  GlobalKey? nowMarkerKey,
  bool showGaps = true,
  List<UserActivity> activities = const [],
}) {
  final nextLesson = _nextLessonOf(lessons, day);

  Widget cardFor(LessonSchedulePart lesson) {
    final status = _lessonStatus(lesson, day);
    final isNext = identical(lesson, nextLesson) && !status.live;
    return _TimelineLessonCard(
      lesson: lesson,
      day: day,
      isNext: isNext,
      minutesToStart: isNext ? _minutesToStart(lesson, day) : null,
      onTap: () => onLessonTap(lesson, day),
      onActions: () => onLessonActions(lesson, day),
    );
  }

  final entries = <({int startMinute, int endMinute, Widget widget})>[
    for (final lesson in lessons)
      (
        startMinute: minutesOfDay(lesson.lessonBells.startTime),
        endMinute: minutesOfDay(lesson.lessonBells.endTime),
        widget: cardFor(lesson),
      ),
    for (final activity in activities)
      (
        startMinute: activity.startsAt.hour * 60 + activity.startsAt.minute,
        endMinute: _activityEndMinute(activity),
        widget: _ActivityRow(activity: activity),
      ),
  ]..sort((a, b) => a.startMinute.compareTo(b.startMinute));

  if (showGaps && entries.length > 1) {
    final withGaps = <({int startMinute, int endMinute, Widget widget})>[];
    var occupiedUntil = entries.first.endMinute;
    withGaps.add(entries.first);
    for (final entry in entries.skip(1)) {
      final gap = entry.startMinute - occupiedUntil;
      if (gap >= 30) {
        withGaps.add((
          startMinute: occupiedUntil,
          endMinute: entry.startMinute,
          widget: _GapRow(minutes: gap),
        ));
      }
      withGaps.add(entry);
      occupiedUntil = math.max(occupiedUntil, entry.endMinute);
    }
    entries
      ..clear()
      ..addAll(withGaps);
  }

  final children = [
    for (final (index, entry) in entries.indexed)
      entry.widget.animateListItem(index: index),
  ];
  final nowRow = _nowRowFor(
    context,
    day,
    entries,
    markerKey: nowMarkerKey,
  );
  if (nowRow != null) children.insert(nowRow.$1, nowRow.$2);
  return children;
}

int _activityEndMinute(UserActivity activity) {
  final start = activity.startsAt.hour * 60 + activity.startsAt.minute;
  final end = activity.endsAt;
  if (end == null) return start + 1;
  if (dateOnly(end).isAfter(dateOnly(activity.startsAt))) return 24 * 60;
  if (dateOnly(end).isBefore(dateOnly(activity.startsAt))) return start + 1;
  final endMinute = end.hour * 60 + end.minute;
  return math.max(start + 1, endMinute);
}

(int, Widget)? _nowRowFor(
  BuildContext context,
  DateTime day,
  List<({int startMinute, int endMinute, Widget widget})> entries, {
  GlobalKey? markerKey,
}) {
  final now = DateTime.now();
  if (!isSameDate(day, now) || entries.isEmpty) return null;

  final nowMinute = now.hour * 60 + now.minute;
  var index = entries.indexWhere(
    (entry) => entry.endMinute > nowMinute,
  );
  if (index < 0) index = entries.length;

  final time = DateFormat('HH:mm').format(now);
  final label = '${context.l10n.liveNow.toUpperCase()} $time';
  return (index, _ScheduleNowMarker(key: markerKey, label: label));
}
