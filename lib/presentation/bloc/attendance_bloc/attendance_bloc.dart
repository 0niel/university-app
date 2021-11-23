import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/domain/entities/attendance.dart';
import 'package:rtu_mirea_app/domain/usecases/get_attendance.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetAttendance getAttendance;

  AttendanceBloc({required this.getAttendance}) : super(AttendanceInitial()) {
    on<LoadAttendance>(_onLoadAttendance);
  }

  void _onLoadAttendance(
      LoadAttendance event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());

    final announces = await getAttendance(
        GetAttendanceParams(event.token, event.startDate, event.endDate));

    announces.fold((failure) => emit(AttendanceLoadError()),
        (result) => emit(AttendanceLoaded(attendance: result)));
  }
}
