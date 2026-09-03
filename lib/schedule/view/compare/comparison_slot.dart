import 'package:schedule_repository/schedule_repository.dart';

String _formatMinutes(int value) =>
    '${(value ~/ 60).toString().padLeft(2, '0')}:'
    '${(value % 60).toString().padLeft(2, '0')}';

class ComparisonSlot {
  const ComparisonSlot({
    required this.minute,
    this.mine,
    this.friend,
    this.mineLessons = const [],
    this.friendLessons = const [],
    this.bothFree = false,
    this.freeUntil,
  });

  final int minute;

  final LessonSchedulePart? mine;

  final LessonSchedulePart? friend;

  final List<LessonSchedulePart> mineLessons;

  final List<LessonSchedulePart> friendLessons;

  List<LessonSchedulePart> get allMine =>
      mineLessons.isEmpty ? [?mine] : mineLessons;

  List<LessonSchedulePart> get allFriends =>
      friendLessons.isEmpty ? [?friend] : friendLessons;

  final bool bothFree;

  final int? freeUntil;

  bool get isTogether {
    return allMine.any(
      (myLesson) => allFriends.any(
        (friendLesson) =>
            myLesson.subject == friendLesson.subject &&
            myLesson.lessonType == friendLesson.lessonType &&
            myLesson.lessonBells.startTime ==
                friendLesson.lessonBells.startTime &&
            myLesson.lessonBells.endTime == friendLesson.lessonBells.endTime &&
            (myLesson.classrooms.isEmpty ||
                friendLesson.classrooms.isEmpty ||
                myLesson.classrooms.any(
                  (room) => friendLesson.classrooms.any(
                    (other) =>
                        other.name == room.name && other.campus == room.campus,
                  ),
                )) &&
            (myLesson.teachers.isEmpty ||
                friendLesson.teachers.isEmpty ||
                myLesson.teachers.any(
                  (teacher) => friendLesson.teachers.any(
                    (other) => other.name == teacher.name,
                  ),
                )),
      ),
    );
  }

  String get time => _formatMinutes(minute);

  String get untilTime {
    final until = freeUntil;
    return until == null ? '' : _formatMinutes(until);
  }
}
