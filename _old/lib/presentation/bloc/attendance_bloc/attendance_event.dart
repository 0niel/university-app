part of 'attendance_bloc.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object> get props => [];
}

class LoadAttendance extends AttendanceEvent {
  final String token;
  final String startDate;
  final String endDate;

  const LoadAttendance({
    required this.token,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [token, startDate, endDate];
}
