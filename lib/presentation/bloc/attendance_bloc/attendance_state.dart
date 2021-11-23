part of 'attendance_bloc.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoadError extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List<Attendance> attendance;

  const AttendanceLoaded({
    required this.attendance,
  });

  @override
  List<Object> get props => [attendance];
}
