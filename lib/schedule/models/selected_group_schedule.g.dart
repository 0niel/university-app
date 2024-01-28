// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_group_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectedGroupSchedule _$SelectedGroupScheduleFromJson(Map<String, dynamic> json) => SelectedGroupSchedule(
      group: Group.fromJson(json['group'] as Map<String, dynamic>),
      schedule:
          (json['schedule'] as List<dynamic>).map((e) => SchedulePart.fromJson(e as Map<String, dynamic>)).toList(),
      type: json['type'] as String? ?? 'group',
    );

Map<String, dynamic> _$SelectedGroupScheduleToJson(SelectedGroupSchedule instance) => <String, dynamic>{
      'group': instance.group,
      'type': instance.type,
      'schedule': instance.schedule,
    };
