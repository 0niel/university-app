import 'package:schedule_repository/schedule_repository.dart';

LessonSchedulePart scheduleTestLesson({
  String subject = 'Математика',
  DateTime? day,
  int start = 540,
  int end = 630,
  LessonType type = LessonType.lecture,
}) => LessonSchedulePart(
  subject: subject,
  lessonType: type,
  teachers: const [Teacher(name: 'Преподаватель')],
  classrooms: const [Classroom(name: 'А-101')],
  lessonBells: LessonBells(
    startTime: TimeOfDay(hour: start ~/ 60, minute: start % 60),
    endTime: TimeOfDay(hour: end ~/ 60, minute: end % 60),
  ),
  dates: [day ?? DateTime(2026, 9, 2)],
);
