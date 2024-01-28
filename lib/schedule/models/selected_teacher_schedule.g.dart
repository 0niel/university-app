// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_teacher_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectedTeacherSchedule _$SelectedTeacherScheduleFromJson(Map<String, dynamic> json) => SelectedTeacherSchedule(
      teacher: Teacher.fromJson(json['teacher'] as Map<String, dynamic>),
      schedule:
          (json['schedule'] as List<dynamic>).map((e) => SchedulePart.fromJson(e as Map<String, dynamic>)).toList(),
      type: json['type'] as String? ?? 'teacher',
    );

Map<String, dynamic> _$SelectedTeacherScheduleToJson(SelectedTeacherSchedule instance) => <String, dynamic>{
      'type': instance.type,
      'schedule': instance.schedule,
      'teacher': instance.teacher,
    };
