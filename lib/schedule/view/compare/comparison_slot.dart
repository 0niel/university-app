import 'package:schedule_repository/schedule_repository.dart';

String _formatMinutes(int value) =>
    '${(value ~/ 60).toString().padLeft(2, '0')}:'
    '${(value % 60).toString().padLeft(2, '0')}';

class ComparisonSlot {
  const ComparisonSlot({
    required this.minute,
    this.mine,
    this.friend,
    this.bothFree = false,
    this.freeUntil,
  });

  final int minute;

  final LessonSchedulePart? mine;

  final LessonSchedulePart? friend;

  final bool bothFree;

  final int? freeUntil;

  bool get isTogether {
    final myLesson = mine;
    final friendLesson = friend;
    return myLesson != null &&
        friendLesson != null &&
        myLesson.subject == friendLesson.subject;
  }

  String get time => _formatMinutes(minute);

  String get untilTime {
    final until = freeUntil;
    return until == null ? '' : _formatMinutes(until);
  }
}
