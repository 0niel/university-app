import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'exam_readiness_cubit.freezed.dart';
part 'exam_readiness_status.dart';
part 'exam_readiness_state.dart';

class ExamReadinessCubit extends Cubit<ExamReadinessState> {
  ExamReadinessCubit({required ScheduleRepository scheduleRepository})
    : _repository = scheduleRepository,
      super(const ExamReadinessState());

  final ScheduleRepository _repository;

  Future<void> load() async {
    if (!_repository.hasAuthenticatedUser) return;
    emit(state.copyWith(status: .loading));
    try {
      final entries = await _repository.getExamReadiness();
      emit(
        state.copyWith(entries: entries, status: .populated),
      );
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  Future<void> setReadiness(String subjectName, int readiness) async {
    final previous = state.entries;
    final next = [
      ...previous.where((entry) => entry.subjectName != subjectName),
      ExamReadiness(
        subjectName: subjectName,
        readiness: readiness.clamp(0, 100),
      ),
    ];
    emit(state.copyWith(entries: next));

    try {
      await _repository.setExamReadiness(
        subjectName: subjectName,
        readiness: readiness,
      );
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(entries: previous));
      addError(error, stackTrace);
    }
  }
}
