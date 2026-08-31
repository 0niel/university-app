part of 'schedule_preferences_cubit.dart';

@freezed
abstract class SchedulePreferencesState with _$SchedulePreferencesState {
  const factory SchedulePreferencesState({
    @Default(false) bool isMiniature,
    @Default(false) bool showEmptyLessons,
    @Default(false) bool isListModeEnabled,
    @Default(true) bool showCommentsIndicators,
    @Default(true) bool showLectures,
    @Default(true) bool showSeminars,
    @Default(true) bool showLabs,
    @Default(true) bool showExams,
    @Default(true) bool showGaps,
    @Default(true) bool collapsePast,
    @Default(<String>[]) List<String> hiddenSubjects,
  }) = _SchedulePreferencesState;

  factory SchedulePreferencesState.fromJson(Map<String, dynamic> json) =>
      _$SchedulePreferencesStateFromJson(json);
}
