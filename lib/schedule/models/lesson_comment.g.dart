// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonComment _$LessonCommentFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_LessonComment', json, ($checkedConvert) {
      final val = _LessonComment(
        subjectName: $checkedConvert('subjectName', (v) => v as String),
        lessonDate: $checkedConvert(
          'lessonDate',
          (v) => DateTime.parse(v as String),
        ),
        lessonBells: $checkedConvert(
          'lessonBells',
          (v) => LessonBells.fromJson(v as Map<String, dynamic>),
        ),
        text: $checkedConvert('text', (v) => v as String),
        isSharedWithGroup: $checkedConvert(
          'isSharedWithGroup',
          (v) => v as bool? ?? false,
        ),
      );
      return val;
    });

Map<String, dynamic> _$LessonCommentToJson(_LessonComment instance) =>
    <String, dynamic>{
      'subjectName': instance.subjectName,
      'lessonDate': instance.lessonDate.toIso8601String(),
      'lessonBells': instance.lessonBells.toJson(),
      'text': instance.text,
      'isSharedWithGroup': instance.isSharedWithGroup,
    };
