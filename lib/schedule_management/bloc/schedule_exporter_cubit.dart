import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_exporter_repository/schedule_exporter_repository.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'schedule_exporter_state.dart';
part 'schedule_exporter_cubit.freezed.dart';

class ScheduleExporterCubit extends Cubit<ScheduleExporterState> {
  ScheduleExporterCubit(this._scheduleExporterRepository)
    : super(const ScheduleExporterState());

  final ScheduleExporterRepository _scheduleExporterRepository;

  Future<void> exportSchedule({
    required String calendarName,
    required List<LessonSchedulePart> lessons,
    bool? includeEmojis,
    bool? includeShortTypeNames,
    List<int>? reminderMinutes,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        isSuccess: false,
        errorMessage: '',
      ),
    );
    try {
      await _scheduleExporterRepository.exportScheduleToCalendar(
        calendarName: calendarName,
        lessons: lessons,
        includeEmojis: includeEmojis ?? true,
        includeShortTypeNames: includeShortTypeNames ?? true,
        reminderMinutes: reminderMinutes ?? const [10, 30, 720],
      );
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } on Exception catch (e, st) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: e.toString(),
        ),
      );
      addError(e, st);
    }
  }
}
