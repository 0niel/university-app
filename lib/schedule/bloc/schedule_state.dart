part of 'schedule_bloc.dart';

enum ScheduleStatus {
  initial,
  loading,
  failure,
  loaded,
}

@freezed
class ScheduleChange with _$ScheduleChange {
  const factory ScheduleChange({
    required ChangeType type,
    required String title,
    required String description,
    required List<DateTime> dates,
    required LessonBells lessonBells,
  }) = _ScheduleChange;
}

enum ChangeType {
  added,
  removed,
  modified,
}

@freezed
class ScheduleDiff with _$ScheduleDiff {
  const factory ScheduleDiff({
    required Set<ScheduleChange> changes,
  }) = _ScheduleDiff;
}

@freezed
class ScheduleState with _$ScheduleState {
  const factory ScheduleState({
    @Default(ScheduleStatus.initial) @JsonKey(includeFromJson: false, includeToJson: false) ScheduleStatus status,
    @Default([]) List<(UID, Classroom, List<SchedulePart>)> classroomsSchedule,
    @Default([]) List<(UID, Teacher, List<SchedulePart>)> teachersSchedule,
    @Default([]) List<(UID, Group, List<SchedulePart>)> groupsSchedule,
    @Default(false) bool isMiniature,
    @Default([]) List<LessonComment> comments,
    @Default(false) bool showEmptyLessons,
    @Default(true) bool showCommentsIndicators,
    @Default(false) bool isListModeEnabled,
    @Default([]) List<ScheduleComment> scheduleComments,
    @SelectedScheduleConverter() SelectedSchedule? selectedSchedule,
    @Default({}) @JsonKey(includeFromJson: false, includeToJson: false) Set<SelectedSchedule> comparisonSchedules,
    @Default(false) @JsonKey(includeFromJson: false, includeToJson: false) bool isComparisonModeEnabled,
    @Default(null) @JsonKey(includeFromJson: false, includeToJson: false) ScheduleDiff? latestDiff,
    @Default(false) @JsonKey(includeFromJson: false, includeToJson: false) bool showScheduleDiffDialog,
  }) = _ScheduleState;

  const ScheduleState._();

  factory ScheduleState.fromJson(Map<String, dynamic> json) => _$ScheduleStateFromJson(json);
}

class SelectedScheduleConverter implements JsonConverter<SelectedSchedule?, Map<String, dynamic>?> {
  const SelectedScheduleConverter();

  @override
  Map<String, dynamic>? toJson(SelectedSchedule? selectedSchedule) => selectedSchedule?.toJson();

  @override
  SelectedSchedule? fromJson(Object? jsonString) =>
      jsonString != null ? SelectedSchedule.fromJson(jsonString as Map<String, dynamic>) : null;
}
