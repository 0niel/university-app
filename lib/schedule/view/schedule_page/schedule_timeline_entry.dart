import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_status.dart';
import 'package:schedule_repository/schedule_repository.dart';

sealed class ScheduleTimelineEntry {
  const ScheduleTimelineEntry();
}

class ScheduleLessonEntry extends ScheduleTimelineEntry {
  const ScheduleLessonEntry({
    required this.lesson,
    required this.status,
    required this.isNew,
    required this.isNext,
    this.change,
  });

  final LessonSchedulePart lesson;
  final LessonDayStatus status;
  final ScheduleChange? change;
  final bool isNew;
  final bool isNext;

  bool get cancelled => isCancelled(change);

  bool get moved => isMoved(change);

  String? get previousRoom => change?.oldValue.rooms.firstOrNull;
}

class ScheduleGapEntry extends ScheduleTimelineEntry {
  const ScheduleGapEntry(this.minutes);

  final int minutes;
}

class ScheduleNowEntry extends ScheduleTimelineEntry {
  const ScheduleNowEntry(this.at);

  final DateTime at;
}
