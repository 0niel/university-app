part of 'schedule_exporter_cubit.dart';

@freezed
abstract class ScheduleExporterState with _$ScheduleExporterState {
  const factory ScheduleExporterState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default('') String errorMessage,
  }) = _ScheduleExporterState;

  const ScheduleExporterState._();
}
