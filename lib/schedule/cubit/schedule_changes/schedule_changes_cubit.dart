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
  int _loadRevision = 0;
  (ScheduleTargetType, String)? _target;

  bool matchesTarget(ScheduleTargetType type, String target) =>
      _target == (type, target);

  void clear() {
    _loadRevision++;
    _target = null;
    emit(const ScheduleChangesState());
  }

  Future<void> load({
    required ScheduleTargetType targetType,
    required String target,
  }) async {
    final revision = ++_loadRevision;
    final changed = !matchesTarget(targetType, target);
    _target = (targetType, target);
    emit(
      (changed ? const ScheduleChangesState() : state).copyWith(
        status: .loading,
      ),
    );
    try {
      final changes = await _repository.getScheduleChanges(
        targetType: targetType,
        target: target,
      );
      if (isClosed || revision != _loadRevision) return;
      emit(
        state.copyWith(
          changes: changes,
          status: .populated,
        ),
      );
    } on Exception catch (error, stackTrace) {
      if (isClosed || revision != _loadRevision) return;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }
}
