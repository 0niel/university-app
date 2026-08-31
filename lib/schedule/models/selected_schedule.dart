import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/schedule/models/selected_schedule_type.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'selected_schedule.freezed.dart';
part 'selected_schedule.g.dart';

@Freezed(unionKey: 'type', unionValueCase: .none)
sealed class SelectedSchedule with _$SelectedSchedule {
  @FreezedUnionValue('group')
  @JsonSerializable(checked: true, explicitToJson: true)
  const factory SelectedSchedule.group({
    required Group group,
    @SchedulePartsConverter() required List<SchedulePart> schedule,
  }) = SelectedGroupSchedule;

  @FreezedUnionValue('teacher')
  @JsonSerializable(checked: true, explicitToJson: true)
  const factory SelectedSchedule.teacher({
    required Teacher teacher,
    @SchedulePartsConverter() required List<SchedulePart> schedule,
  }) = SelectedTeacherSchedule;

  @FreezedUnionValue('classroom')
  @JsonSerializable(checked: true, explicitToJson: true)
  const factory SelectedSchedule.classroom({
    required Classroom classroom,
    @SchedulePartsConverter() required List<SchedulePart> schedule,
  }) = SelectedClassroomSchedule;

  @FreezedUnionValue('custom')
  @JsonSerializable(checked: true, explicitToJson: true)
  const factory SelectedSchedule.custom({
    required String id,
    required String name,
    @SchedulePartsConverter() required List<SchedulePart> schedule,
    String? description,
  }) = SelectedCustomSchedule;

  const SelectedSchedule._();

  factory SelectedSchedule.fromJson(Map<String, Object?> json) {
    final dynamicJson = Map<String, dynamic>.from(json);
    return switch (SelectedScheduleType.parse(json['type'])) {
      .group => _$SelectedGroupScheduleFromJson(
        dynamicJson,
      ),
      .teacher => _$SelectedTeacherScheduleFromJson(
        dynamicJson,
      ),
      .classroom => _$SelectedClassroomScheduleFromJson(
        dynamicJson,
      ),
      .custom => _$SelectedCustomScheduleFromJson(
        dynamicJson,
      ),
    };
  }

  SelectedScheduleType get scheduleType => switch (this) {
    SelectedGroupSchedule() => .group,
    SelectedTeacherSchedule() => .teacher,
    SelectedClassroomSchedule() => .classroom,
    SelectedCustomSchedule() => .custom,
  };

  String get type => scheduleType.name;

  String get name => switch (this) {
    SelectedGroupSchedule(:final group) => group.name,
    SelectedTeacherSchedule(:final teacher) => teacher.name,
    SelectedClassroomSchedule(:final classroom) => classroom.name,
    SelectedCustomSchedule(name: final customName) => customName,
  };

  Map<String, dynamic> toJson() => switch (this) {
    final SelectedGroupSchedule value => {
      ..._$SelectedGroupScheduleToJson(value),
      'type': 'group',
    },
    final SelectedTeacherSchedule value => {
      ..._$SelectedTeacherScheduleToJson(value),
      'type': 'teacher',
    },
    final SelectedClassroomSchedule value => {
      ..._$SelectedClassroomScheduleToJson(value),
      'type': 'classroom',
    },
    final SelectedCustomSchedule value => {
      ..._$SelectedCustomScheduleToJson(value),
      'type': 'custom',
    },
  };

  static ScheduleTarget toScheduleTarget(String type) =>
      switch (SelectedScheduleType.parse(type)) {
        .group => .group,
        .teacher => .teacher,
        .classroom => .classroom,
        .custom => throw ArgumentError.value(
          type,
          'type',
          'Custom schedules do not have a repository target',
        ),
      };

  static SelectedSchedule createSelectedSchedule(
    Object scheduleEntity,
    List<SchedulePart> scheduleParts,
  ) => switch (scheduleEntity) {
    Group() => SelectedGroupSchedule(
      group: scheduleEntity,
      schedule: scheduleParts,
    ),
    Teacher() => SelectedTeacherSchedule(
      teacher: scheduleEntity,
      schedule: scheduleParts,
    ),
    Classroom() => SelectedClassroomSchedule(
      classroom: scheduleEntity,
      schedule: scheduleParts,
    ),
    _ => throw ArgumentError.value(
      scheduleEntity,
      'scheduleEntity',
      'Expected Group, Teacher, or Classroom',
    ),
  };

  static bool isScheduleSelected(
    SelectedSchedule? selectedSchedule,
    Object scheduleEntity,
  ) => switch ((selectedSchedule, scheduleEntity)) {
    (SelectedGroupSchedule(:final group), Group(:final name)) =>
      name == group.name,
    (SelectedTeacherSchedule(:final teacher), Teacher(:final name)) =>
      name == teacher.name,
    (SelectedClassroomSchedule(:final classroom), Classroom(:final name)) =>
      name == classroom.name,
    _ => false,
  };
}
