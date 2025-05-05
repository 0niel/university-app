import 'package:equatable/equatable.dart';

import 'lesson.dart';

class Schedule extends Equatable {
  const Schedule({required this.isRemote, required this.group, required this.schedule});

  final bool isRemote;
  final String group;
  final Map<String, ScheduleWeekdayValue> schedule;

  @override
  List<Object?> get props => [isRemote, group, schedule];
}

class ScheduleWeekdayValue extends Equatable {
  const ScheduleWeekdayValue({required this.lessons});

  final List<List<Lesson>> lessons;

  @override
  List<Object?> get props => [lessons];
}
