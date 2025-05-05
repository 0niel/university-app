part of 'schedule_bloc.dart';

enum ScheduleStatus { initial, loading, failure, loaded }

@freezed
class FieldDiff with _$FieldDiff {
  const factory FieldDiff({
    /// Имя поля (например, "Даты", "Аудитории", "Преподаватели", "Время/номер пары")
    required String fieldName,

    /// Для не-дата полей можно оставить старое и новое значение в виде строки
    String? oldValue,
    String? newValue,

    /// Для поля «Даты»—детальный diff: какие даты добавлены
    List<DateTime>? addedDates,

    /// Для поля «Даты»—детальный diff: какие даты удалены
    List<DateTime>? removedDates,

    /// И какие даты остались без изменений (можно их просто вывести без подсветки)
    List<DateTime>? unchangedDates,
  }) = _FieldDiff;
}

enum ChangeType { added, removed, modified }

@freezed
class ScheduleChange with _$ScheduleChange {
  const factory ScheduleChange({
    /// Тип изменения: добавление, удаление, модификация
    required ChangeType type,

    /// Название предмета, служащее заголовком для данного diff‑блока
    required String subject,

    /// Список изменений по полям: для добавленных и удалённых уроков здесь будут все поля,
    /// для модифицированных – только те, что изменились.
    required List<FieldDiff> fieldDiffs,
  }) = _ScheduleChange;
}

@freezed
class ScheduleDiff with _$ScheduleDiff {
  const factory ScheduleDiff({
    /// Множество изменений в расписании (можно преобразовать в список для удобства отображения)
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

    // Desktop mode state properties
    @Default(false) @JsonKey(includeFromJson: false, includeToJson: false) bool isSplitViewEnabled,
    @Default(true) @JsonKey(includeFromJson: false, includeToJson: false) bool showAnalytics,

    // Custom schedules
    @Default([]) List<CustomSchedule> customSchedules,
    @Default(false) @JsonKey(includeFromJson: false, includeToJson: false) bool isCustomScheduleModeEnabled,
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
