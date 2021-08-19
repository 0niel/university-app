import 'package:equatable/equatable.dart';

import 'lesson.dart';

class Schedule extends Equatable {
  const Schedule({
    required this.group,
    required this.schedule,
  });

  final String group;
  final Map<String, ScheduleWeekdayValue> schedule;

  @override
  List<Object?> get props => [group, schedule];
}

class ScheduleWeekdayValue extends Equatable {
  const ScheduleWeekdayValue({
    required this.lessons,
  });

  final List<List<Lesson>> lessons;

  @override
  List<Object?> get props => [lessons];
}
