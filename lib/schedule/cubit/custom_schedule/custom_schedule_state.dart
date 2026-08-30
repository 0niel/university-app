part of 'custom_schedule_cubit.dart';

@freezed
abstract class CustomScheduleState with _$CustomScheduleState {
  const factory CustomScheduleState({
    @Default([]) List<CustomSchedule> customSchedules,
    @Default(false)
    @JsonKey(includeFromJson: false, includeToJson: false)
    bool isCustomScheduleModeEnabled,
    @Default(RemotePreferenceSyncStatus.initial)
    @JsonKey(includeFromJson: false, includeToJson: false)
    RemotePreferenceSyncStatus syncStatus,
  }) = _CustomScheduleState;

  factory CustomScheduleState.fromJson(Map<String, dynamic> json) =>
      _$CustomScheduleStateFromJson(json);
}
