// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleComment _$ScheduleCommentFromJson(Map<String, dynamic> json) => ScheduleComment(
      subjectName: json['subjectName'] as String,
      lessonDate: DateTime.parse(json['lessonDate'] as String),
      lessonBells: LessonBells.fromJson(json['lessonBells'] as Map<String, dynamic>),
      text: json['text'] as String,
    );

Map<String, dynamic> _$ScheduleCommentToJson(ScheduleComment instance) => <String, dynamic>{
      'subjectName': instance.subjectName,
      'lessonDate': instance.lessonDate.toIso8601String(),
      'lessonBells': instance.lessonBells,
      'text': instance.text,
    };
