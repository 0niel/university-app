// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_classroom_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectedClassroomSchedule _$SelectedClassroomScheduleFromJson(Map<String, dynamic> json) => SelectedClassroomSchedule(
      classroom: Classroom.fromJson(json['classroom'] as Map<String, dynamic>),
      schedule:
          (json['schedule'] as List<dynamic>).map((e) => SchedulePart.fromJson(e as Map<String, dynamic>)).toList(),
      type: json['type'] as String? ?? 'classroom',
    );

Map<String, dynamic> _$SelectedClassroomScheduleToJson(SelectedClassroomSchedule instance) => <String, dynamic>{
      'classroom': instance.classroom,
      'type': instance.type,
      'schedule': instance.schedule,
    };
