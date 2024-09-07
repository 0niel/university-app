// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonComment _$LessonCommentFromJson(Map<String, dynamic> json) => LessonComment(
      subjectName: json['subjectName'] as String,
      lessonDate: DateTime.parse(json['lessonDate'] as String),
      lessonBells: LessonBells.fromJson(json['lessonBells'] as Map<String, dynamic>),
      text: json['text'] as String,
    );

Map<String, dynamic> _$LessonCommentToJson(LessonComment instance) => <String, dynamic>{
      'subjectName': instance.subjectName,
      'lessonDate': instance.lessonDate.toIso8601String(),
      'lessonBells': instance.lessonBells,
      'text': instance.text,
    };
