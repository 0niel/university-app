// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonResponse _$LessonFromJson(Map<String, dynamic> json) => LessonResponse(
      name: json['name'] as String,
      weeks: (json['weeks'] as List<dynamic>).map((e) => e as int).toList(),
      timeStart: json['timeStart'] as String,
      timeEnd: json['timeEnd'] as String,
      types: json['types'] as String,
      teachers:
          (json['teachers'] as List<dynamic>).map((e) => e as String).toList(),
      rooms: (json['rooms'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$LessonToJson(LessonResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'weeks': instance.weeks,
      'timeStart': instance.timeStart,
      'timeEnd': instance.timeEnd,
      'types': instance.types,
      'teachers': instance.teachers,
      'rooms': instance.rooms,
    };
