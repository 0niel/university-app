part of 'schedule_bloc.dart';

enum ScheduleStatus {
  initial,
  loading,
  failure,
  loaded,
}

@JsonSerializable()
class ScheduleState extends Equatable {
  const ScheduleState({
    required this.status,
    this.classroomsSchedule = const [],
    this.teachersSchedule = const [],
    this.groupsSchedule = const [],
    this.isMiniature = false,
    this.showEmptyLessons = false,
    this.selectedSchedule,
  });

  const ScheduleState.initial()
      : this(
          status: ScheduleStatus.initial,
        );

  factory ScheduleState.fromJson(Map<String, dynamic> json) =>
      _$ScheduleStateFromJson(json);

  final ScheduleStatus status;

  final List<(UID, Classroom, List<SchedulePart>)> classroomsSchedule;

  final List<(UID, Teacher, List<SchedulePart>)> teachersSchedule;

  final List<(UID, Group, List<SchedulePart>)> groupsSchedule;

  /// Miniature display mode for lesson cards.
  final bool isMiniature;

  /// Show empty lessons in schedule. If true, then cards from 1 to 6 lessons
  /// number will be displayed, even if there is no lesson in this time.
  final bool showEmptyLessons;

  @SelectedScheduleConverter()
  final SelectedSchedule? selectedSchedule;

  ScheduleState copyWith({
    ScheduleStatus? status,
    List<(UID, Classroom, List<SchedulePart>)>? classroomsSchedule,
    List<(UID, Teacher, List<SchedulePart>)>? teachersSchedule,
    List<(UID, Group, List<SchedulePart>)>? groupsSchedule,
    SelectedSchedule? selectedSchedule,
    bool? isMiniature,
    bool? showEmptyLessons,
  }) {
    return ScheduleState(
      status: status ?? this.status,
      classroomsSchedule: classroomsSchedule ?? this.classroomsSchedule,
      teachersSchedule: teachersSchedule ?? this.teachersSchedule,
      groupsSchedule: groupsSchedule ?? this.groupsSchedule,
      selectedSchedule: selectedSchedule ?? this.selectedSchedule,
      isMiniature: isMiniature ?? this.isMiniature,
      showEmptyLessons: showEmptyLessons ?? this.showEmptyLessons,
    );
  }

  Map<String, dynamic> toJson() => _$ScheduleStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        classroomsSchedule,
        teachersSchedule,
        groupsSchedule,
        isMiniature,
        selectedSchedule,
        showEmptyLessons,
      ];
}

class SelectedScheduleConverter
    implements JsonConverter<SelectedSchedule?, Map<String, dynamic>?> {
  const SelectedScheduleConverter();

  @override
  Map<String, dynamic>? toJson(SelectedSchedule? selectedSchedule) =>
      selectedSchedule?.toJson();

  @override
  SelectedSchedule? fromJson(Object? jsonString) => jsonString != null
      ? SelectedSchedule.fromJson(jsonString as Map<String, dynamic>)
      : null;
}
