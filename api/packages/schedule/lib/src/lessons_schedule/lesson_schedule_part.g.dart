// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'lesson_schedule_part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonSchedulePart _$LessonSchedulePartFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'LessonSchedulePart',
      json,
      ($checkedConvert) {
        final val = LessonSchedulePart(
          subject: $checkedConvert('subject', (v) => v as String),
          lessonType: $checkedConvert(
              'lesson_type', (v) => $enumDecode(_$LessonTypeEnumMap, v)),
          teachers: $checkedConvert(
              'teachers',
              (v) => (v as List<dynamic>)
                  .map((e) => Teacher.fromJson(e as Map<String, dynamic>))
                  .toList()),
          classroom: $checkedConvert('classroom',
              (v) => Classroom.fromJson(v as Map<String, dynamic>)),
          lessonBells: $checkedConvert('lesson_bells',
              (v) => LessonBells.fromJson(v as Map<String, dynamic>)),
          dates: $checkedConvert(
              'dates', (v) => const DatesConverter().fromJson(v as List)),
          type: $checkedConvert(
              'type', (v) => v as String? ?? LessonSchedulePart.identifier),
        );
        return val;
      },
      fieldKeyMap: const {
        'lessonType': 'lesson_type',
        'lessonBells': 'lesson_bells'
      },
    );

Map<String, dynamic> _$LessonSchedulePartToJson(LessonSchedulePart instance) =>
    <String, dynamic>{
      'type': instance.type,
      'subject': instance.subject,
      'lesson_type': _$LessonTypeEnumMap[instance.lessonType]!,
      'teachers': instance.teachers.map((e) => e.toJson()).toList(),
      'classroom': instance.classroom.toJson(),
      'lesson_bells': instance.lessonBells.toJson(),
      'dates': const DatesConverter().toJson(instance.dates),
    };

const _$LessonTypeEnumMap = {
  LessonType.practice: 'practice',
  LessonType.lecture: 'lecture',
  LessonType.laboratory: 'laboratory',
  LessonType.individual: 'individual',
  LessonType.physicalEducation: 'physicalEducation',
  LessonType.consultation: 'consultation',
  LessonType.exam: 'exam',
  LessonType.credit: 'credit',
  LessonType.courseWork: 'courseWork',
  LessonType.courseProject: 'courseProject',
  LessonType.other: 'other',
};
