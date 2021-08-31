import 'package:equatable/equatable.dart';

class ScheduleSettings extends Equatable {
  const ScheduleSettings({
    required this.showEmptyLessons,
    required this.showLessonsNumbers,
  });

  final bool showEmptyLessons;
  final bool showLessonsNumbers;

  @override
  List<Object?> get props => [showEmptyLessons, showLessonsNumbers];
}
