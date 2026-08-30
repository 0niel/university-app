part of 'schedule_changes_cubit.dart';

@freezed
abstract class ScheduleChangesState with _$ScheduleChangesState {
  const factory ScheduleChangesState({
    @Default(<ScheduleChange>[]) List<ScheduleChange> changes,
    @Default(ScheduleChangesStatus.initial) ScheduleChangesStatus status,
  }) = _ScheduleChangesState;

  const ScheduleChangesState._();

  bool get isLoading => status == .loading;
}
