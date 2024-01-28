import 'package:equatable/equatable.dart';

class Lesson extends Equatable {
  const Lesson({
    required this.name,
    required this.weeks,
    required this.timeStart,
    required this.timeEnd,
    required this.types,
    required this.teachers,
    required this.rooms,
  });

  final String name;
  final List<int> weeks;
  final String timeStart;
  final String timeEnd;
  final String types;
  final List<String> teachers;
  final List<String> rooms;

  @override
  List<Object?> get props => [name, weeks, timeStart, timeEnd, types, teachers, rooms];
}
