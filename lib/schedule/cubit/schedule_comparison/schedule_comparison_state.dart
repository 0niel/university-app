part of 'schedule_comparison_cubit.dart';

@freezed
abstract class ScheduleComparisonState with _$ScheduleComparisonState {
  const factory ScheduleComparisonState({
    @Default(<SelectedSchedule>{}) Set<SelectedSchedule> schedules,
    @Default(false) bool isEnabled,
  }) = _ScheduleComparisonState;
}
