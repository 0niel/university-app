// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomSchedule _$CustomScheduleFromJson(Map<String, dynamic> json) =>
    _CustomSchedule(
      id: json['id'] as String,
      name: json['name'] as String,
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) => CustomLesson.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CustomScheduleToJson(_CustomSchedule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lessons': instance.lessons.map((e) => e.toJson()).toList(),
      'description': instance.description,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
