// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'lesson_schedule_part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonSchedulePart _$LessonSchedulePartFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_LessonSchedulePart',
      json,
      ($checkedConvert) {
        final val = _LessonSchedulePart(
          subject: $checkedConvert('subject', (v) => v as String),
          lessonType: $checkedConvert(
            'lesson_type',
            (v) => $enumDecode(_$LessonTypeEnumMap, v),
          ),
          teachers: $checkedConvert(
            'teachers',
            (v) => (v as List<dynamic>)
                .map((e) => Teacher.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          classrooms: $checkedConvert(
            'classrooms',
            (v) => (v as List<dynamic>)
                .map((e) => Classroom.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          lessonBells: $checkedConvert(
            'lesson_bells',
            (v) => LessonBells.fromJson(v as Map<String, dynamic>),
          ),
          dates: $checkedConvert(
            'dates',
            (v) => const DatesConverter().fromJson(v as List),
          ),
          groups: $checkedConvert(
            'groups',
            (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
          ),
          groupEntities: $checkedConvert(
            'group_entities',
            (v) => (v as List<dynamic>?)
                ?.map((e) => Group.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          uid: $checkedConvert('uid', (v) => v as String?),
          color: $checkedConvert('color', (v) => (v as num?)?.toInt()),
          reminderMinutes: $checkedConvert(
            'reminder_minutes',
            (v) => (v as num?)?.toInt(),
          ),
          type: $checkedConvert(
            'type',
            (v) => v as String? ?? LessonSchedulePart.identifier,
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'lessonType': 'lesson_type',
        'lessonBells': 'lesson_bells',
        'groupEntities': 'group_entities',
        'reminderMinutes': 'reminder_minutes',
      },
    );

Map<String, dynamic> _$LessonSchedulePartToJson(
  _LessonSchedulePart instance,
) => <String, dynamic>{
  'subject': instance.subject,
  'lesson_type': _$LessonTypeEnumMap[instance.lessonType]!,
  'teachers': instance.teachers.map((e) => e.toJson()).toList(),
  'classrooms': instance.classrooms.map((e) => e.toJson()).toList(),
  'lesson_bells': instance.lessonBells.toJson(),
  'dates': const DatesConverter().toJson(instance.dates),
  'groups': ?instance.groups,
  'group_entities': ?instance.groupEntities?.map((e) => e.toJson()).toList(),
  'uid': ?instance.uid,
  'color': ?instance.color,
  'reminder_minutes': ?instance.reminderMinutes,
  'type': instance.type,
};

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
