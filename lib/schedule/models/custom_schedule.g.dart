// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomScheduleImpl _$$CustomScheduleImplFromJson(Map<String, dynamic> json) => _$CustomScheduleImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  lessons:
      (json['lessons'] as List<dynamic>).map((e) => LessonSchedulePart.fromJson(e as Map<String, dynamic>)).toList(),
  description: json['description'] as String?,
  createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$CustomScheduleImplToJson(_$CustomScheduleImpl instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'lessons': instance.lessons,
  'description': instance.description,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
