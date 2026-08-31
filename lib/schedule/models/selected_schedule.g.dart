// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectedGroupSchedule _$SelectedGroupScheduleFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SelectedGroupSchedule', json, ($checkedConvert) {
  final val = SelectedGroupSchedule(
    group: $checkedConvert(
      'group',
      (v) => Group.fromJson(v as Map<String, dynamic>),
    ),
    schedule: $checkedConvert(
      'schedule',
      (v) => const SchedulePartsConverter().fromJson(v as List),
    ),
  );
  return val;
});

Map<String, dynamic> _$SelectedGroupScheduleToJson(
  SelectedGroupSchedule instance,
) => <String, dynamic>{
  'group': instance.group.toJson(),
  'schedule': const SchedulePartsConverter().toJson(instance.schedule),
};

SelectedTeacherSchedule _$SelectedTeacherScheduleFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SelectedTeacherSchedule', json, ($checkedConvert) {
  final val = SelectedTeacherSchedule(
    teacher: $checkedConvert(
      'teacher',
      (v) => Teacher.fromJson(v as Map<String, dynamic>),
    ),
    schedule: $checkedConvert(
      'schedule',
      (v) => const SchedulePartsConverter().fromJson(v as List),
    ),
  );
  return val;
});

Map<String, dynamic> _$SelectedTeacherScheduleToJson(
  SelectedTeacherSchedule instance,
) => <String, dynamic>{
  'teacher': instance.teacher.toJson(),
  'schedule': const SchedulePartsConverter().toJson(instance.schedule),
};

SelectedClassroomSchedule _$SelectedClassroomScheduleFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SelectedClassroomSchedule', json, ($checkedConvert) {
  final val = SelectedClassroomSchedule(
    classroom: $checkedConvert(
      'classroom',
      (v) => Classroom.fromJson(v as Map<String, dynamic>),
    ),
    schedule: $checkedConvert(
      'schedule',
      (v) => const SchedulePartsConverter().fromJson(v as List),
    ),
  );
  return val;
});

Map<String, dynamic> _$SelectedClassroomScheduleToJson(
  SelectedClassroomSchedule instance,
) => <String, dynamic>{
  'classroom': instance.classroom.toJson(),
  'schedule': const SchedulePartsConverter().toJson(instance.schedule),
};

SelectedCustomSchedule _$SelectedCustomScheduleFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SelectedCustomSchedule', json, ($checkedConvert) {
  final val = SelectedCustomSchedule(
    id: $checkedConvert('id', (v) => v as String),
    name: $checkedConvert('name', (v) => v as String),
    schedule: $checkedConvert(
      'schedule',
      (v) => const SchedulePartsConverter().fromJson(v as List),
    ),
    description: $checkedConvert('description', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$SelectedCustomScheduleToJson(
  SelectedCustomSchedule instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'schedule': const SchedulePartsConverter().toJson(instance.schedule),
  'description': instance.description,
};
