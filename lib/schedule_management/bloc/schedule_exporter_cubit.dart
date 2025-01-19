import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:university_app_server_api/client.dart';
import 'package:schedule_exporter_repository/schedule_exporter_repository.dart';

part 'schedule_exporter_state.dart';

/// ScheduleExporterCubit manages the state of exporting a schedule to the calendar.
class ScheduleExporterCubit extends Cubit<ScheduleExporterState> {
  final ScheduleExporterRepository _scheduleExporterRepository;

  /// Creates an instance of [ScheduleExporterCubit].
  ///
  /// [scheduleExporterRepository] is the repository responsible for exporting schedules.
  ScheduleExporterCubit(this._scheduleExporterRepository) : super(const ScheduleExporterState());

  /// Exports the given [lessons] to the calendar with the specified [calendarName].
  ///
  /// The [includeEmojis], [includeShortTypeNames], and [reminderMinutes] configurations
  /// will be handled within the repository.
  Future<void> exportSchedule({
    required String calendarName,
    required List<LessonSchedulePart> lessons,
    bool? includeEmojis,
    bool? includeShortTypeNames,
    List<int>? reminderMinutes,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));
    try {
      await _scheduleExporterRepository.exportScheduleToCalendar(
        calendarName: calendarName,
        lessons: lessons,
        includeEmojis: includeEmojis ?? true,
        includeShortTypeNames: includeShortTypeNames ?? true,
        reminderMinutes: reminderMinutes ?? const [10, 30, 720],
      );
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
