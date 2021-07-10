import 'package:equatable/equatable.dart';

class Lesson extends Equatable {
  const Lesson({
    required this.name,
    required this.room,
    required this.teacher,
    required this.timeStart,
    required this.timeEnd,
    required this.type,
    required this.weeks,
  });

  final String name;
  final String room;
  final String teacher;
  final String timeStart;
  final String timeEnd;
  final String type;
  final List<int> weeks;

  @override
  List<Object?> get props =>
      [name, room, teacher, timeStart, timeEnd, type, weeks];
}
