// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomLesson _$CustomLessonFromJson(Map<String, dynamic> json) =>
    _CustomLesson(
      id: json['id'] as String,
      subject: json['subject'] as String,
      lessonType: $enumDecode(_$LessonTypeEnumMap, json['lessonType']),
      teachers: (json['teachers'] as List<dynamic>)
          .map((e) => Teacher.fromJson(e as Map<String, dynamic>))
          .toList(),
      classrooms: (json['classrooms'] as List<dynamic>)
          .map((e) => Classroom.fromJson(e as Map<String, dynamic>))
          .toList(),
      lessonBells: LessonBells.fromJson(
        json['lessonBells'] as Map<String, dynamic>,
      ),
      recurrence: CustomLessonRecurrence.fromJson(
        json['recurrence'] as Map<String, dynamic>,
      ),
      color: (json['color'] as num?)?.toInt(),
      reminderMinutes: (json['reminderMinutes'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CustomLessonToJson(_CustomLesson instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subject': instance.subject,
      'lessonType': _$LessonTypeEnumMap[instance.lessonType]!,
      'teachers': instance.teachers.map((e) => e.toJson()).toList(),
      'classrooms': instance.classrooms.map((e) => e.toJson()).toList(),
      'lessonBells': instance.lessonBells.toJson(),
      'recurrence': instance.recurrence.toJson(),
      'color': instance.color,
      'reminderMinutes': instance.reminderMinutes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
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
