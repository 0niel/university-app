import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'schedule_changes_cubit.freezed.dart';
part 'schedule_changes_status.dart';
part 'schedule_changes_state.dart';

class ScheduleChangesCubit extends Cubit<ScheduleChangesState> {
  ScheduleChangesCubit({required ScheduleRepository scheduleRepository})
    : _repository = scheduleRepository,
      super(const ScheduleChangesState());

  final ScheduleRepository _repository;

  Future<void> load({
    required ScheduleTargetType targetType,
    required String target,
  }) async {
    emit(state.copyWith(status: .loading));
    try {
      final changes = await _repository.getScheduleChanges(
        targetType: targetType,
        target: target,
      );
      emit(
        state.copyWith(
          changes: changes,
          status: .populated,
        ),
      );
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }
}
