part of 'schedule_bloc.dart';

@freezed
abstract class ScheduleState with _$ScheduleState {
  const factory ScheduleState({
    @Default(ScheduleStatus.initial)
    @JsonKey(includeFromJson: false, includeToJson: false)
    ScheduleStatus status,
    @JsonKey(
      fromJson: _classroomSchedulesFromJson,
      toJson: _classroomSchedulesToJson,
    )
    @Default([])
    List<(UID, Classroom, List<SchedulePart>)> classroomsSchedule,
    @JsonKey(
      fromJson: _teacherSchedulesFromJson,
      toJson: _teacherSchedulesToJson,
    )
    @Default([])
    List<(UID, Teacher, List<SchedulePart>)> teachersSchedule,
    @JsonKey(fromJson: _groupSchedulesFromJson, toJson: _groupSchedulesToJson)
    @Default([])
    List<(UID, Group, List<SchedulePart>)> groupsSchedule,
    @SelectedScheduleConverter() SelectedSchedule? selectedSchedule,

    DateTime? lastSyncedAt,

    @Default(<UID, DateTime>{}) Map<UID, DateTime> scheduleSyncedAt,

    @Default(false)
    @JsonKey(includeFromJson: false, includeToJson: false)
    bool isOffline,
  }) = _ScheduleState;

  const ScheduleState._();

  factory ScheduleState.fromJson(Map<String, dynamic> json) =>
      _$ScheduleStateFromJson(json);
}

class SelectedScheduleConverter
    implements JsonConverter<SelectedSchedule?, Map<String, dynamic>?> {
  const SelectedScheduleConverter();

  @override
  Map<String, dynamic>? toJson(SelectedSchedule? selectedSchedule) =>
      selectedSchedule?.toJson();

  @override
  SelectedSchedule? fromJson(Object? jsonString) =>
      jsonString != null ? .fromJson(jsonString as Map<String, dynamic>) : null;
}

List<(UID, Classroom, List<SchedulePart>)> _classroomSchedulesFromJson(
  Object? value,
) => _schedulesFromJson(value, Classroom.fromJson);

List<(UID, Teacher, List<SchedulePart>)> _teacherSchedulesFromJson(
  Object? value,
) => _schedulesFromJson(value, Teacher.fromJson);

List<(UID, Group, List<SchedulePart>)> _groupSchedulesFromJson(Object? value) =>
    _schedulesFromJson(value, Group.fromJson);

List<Map<String, Object?>> _classroomSchedulesToJson(
  List<(UID, Classroom, List<SchedulePart>)> value,
) => _schedulesToJson(value, (classroom) => classroom.toJson());

List<Map<String, Object?>> _teacherSchedulesToJson(
  List<(UID, Teacher, List<SchedulePart>)> value,
) => _schedulesToJson(value, (teacher) => teacher.toJson());

List<Map<String, Object?>> _groupSchedulesToJson(
  List<(UID, Group, List<SchedulePart>)> value,
) => _schedulesToJson(value, (group) => group.toJson());

List<(UID, T, List<SchedulePart>)> _schedulesFromJson<T>(
  Object? value,
  T Function(Map<String, dynamic> json) entityFromJson,
) {
  if (value == null) return const [];
  if (value is! List) throw const FormatException('Expected a schedule list');
  return [
    for (final entry in value)
      _scheduleEntryFromJson(_jsonObject(entry), entityFromJson),
  ];
}

(UID, T, List<SchedulePart>) _scheduleEntryFromJson<T>(
  Map<String, dynamic> json,
  T Function(Map<String, dynamic> json) entityFromJson,
) {
  final id = json[r'$1'];
  if (id is! String) {
    throw const FormatException('Schedule identifier is invalid');
  }
  final parts = json[r'$3'];
  if (parts is! List) throw const FormatException('Schedule parts are invalid');
  return (
    id,
    entityFromJson(_jsonObject(json[r'$2'])),
    [for (final part in parts) SchedulePart.fromJson(_jsonObject(part))],
  );
}

List<Map<String, Object?>> _schedulesToJson<T>(
  List<(UID, T, List<SchedulePart>)> value,
  Map<String, dynamic> Function(T entity) entityToJson,
) => [
  for (final entry in value)
    {
      r'$1': entry.$1,
      r'$2': entityToJson(entry.$2),
      r'$3': [for (final part in entry.$3) part.toJson()],
    },
];

Map<String, dynamic> _jsonObject(Object? value) {
  if (value is! Map) throw const FormatException('Expected a JSON object');
  return Map.from(value);
}
