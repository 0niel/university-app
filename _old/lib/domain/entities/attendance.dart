import 'package:equatable/equatable.dart';

class Attendance extends Equatable {
  final String date;
  final String time;
  final String eventType;

  const Attendance({
    required this.date,
    required this.time,
    required this.eventType,
  });

  @override
  List<Object> get props => [date, time, eventType];
}
