import 'package:schedule_repository/schedule_repository.dart';

class OngoingLesson {
  const OngoingLesson({required this.lesson, required this.minutesLeft});

  final LessonSchedulePart lesson;
  final int minutesLeft;
}
