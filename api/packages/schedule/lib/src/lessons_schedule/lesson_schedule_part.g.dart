// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'lesson_schedule_part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonSchedulePart _$LessonSchedulePartFromJson(Map<String, dynamic> json) => $checkedCreate(
      'LessonSchedulePart',
      json,
      ($checkedConvert) {
        final val = LessonSchedulePart(
          subject: $checkedConvert('subject', (v) => v as String),
          lessonType: $checkedConvert('lesson_type', (v) => $enumDecode(_$LessonTypeEnumMap, v)),
          teachers: $checkedConvert(
              'teachers', (v) => (v as List<dynamic>).map((e) => Teacher.fromJson(e as Map<String, dynamic>)).toList()),
          classrooms: $checkedConvert('classrooms',
              (v) => (v as List<dynamic>).map((e) => Classroom.fromJson(e as Map<String, dynamic>)).toList()),
          lessonBells: $checkedConvert('lesson_bells', (v) => LessonBells.fromJson(v as Map<String, dynamic>)),
          dates: $checkedConvert('dates', (v) => const DatesConverter().fromJson(v as List)),
          groups: $checkedConvert('groups', (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          type: $checkedConvert('type', (v) => v as String? ?? LessonSchedulePart.identifier),
        );
        return val;
      },
      fieldKeyMap: const {'lessonType': 'lesson_type', 'lessonBells': 'lesson_bells'},
    );

Map<String, dynamic> _$LessonSchedulePartToJson(LessonSchedulePart instance) {
  final val = <String, dynamic>{
    'type': instance.type,
    'subject': instance.subject,
    'lesson_type': _$LessonTypeEnumMap[instance.lessonType]!,
    'teachers': instance.teachers.map((e) => e.toJson()).toList(),
    'classrooms': instance.classrooms.map((e) => e.toJson()).toList(),
    'lesson_bells': instance.lessonBells.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('groups', instance.groups);
  val['dates'] = const DatesConverter().toJson(instance.dates);
  return val;
}

const _$LessonTypeEnumMap = {
  LessonType.practice: 'practice',
  LessonType.lecture: 'lecture',
  LessonType.laboratoryWork: 'laboratoryWork',
  LessonType.individualWork: 'individualWork',
  LessonType.physicalEducation: 'physicalEducation',
  LessonType.consultation: 'consultation',
  LessonType.exam: 'exam',
  LessonType.credit: 'credit',
  LessonType.courseWork: 'courseWork',
  LessonType.courseProject: 'courseProject',
  LessonType.unknown: 'unknown',
};
