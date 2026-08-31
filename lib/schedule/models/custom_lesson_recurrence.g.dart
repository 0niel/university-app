// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_lesson_recurrence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomLessonWeeklyRecurrence _$CustomLessonWeeklyRecurrenceFromJson(
  Map<String, dynamic> json,
) => CustomLessonWeeklyRecurrence(
  weekday: (json['weekday'] as num).toInt(),
  pattern:
      $enumDecodeNullable(_$CustomLessonWeekPatternEnumMap, json['pattern']) ??
      CustomLessonWeekPattern.every,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$CustomLessonWeeklyRecurrenceToJson(
  CustomLessonWeeklyRecurrence instance,
) => <String, dynamic>{
  'weekday': instance.weekday,
  'pattern': _$CustomLessonWeekPatternEnumMap[instance.pattern]!,
  'type': instance.$type,
};

const _$CustomLessonWeekPatternEnumMap = {
  CustomLessonWeekPattern.every: 'every',
  CustomLessonWeekPattern.even: 'even',
  CustomLessonWeekPattern.odd: 'odd',
};

CustomLessonDatesRecurrence _$CustomLessonDatesRecurrenceFromJson(
  Map<String, dynamic> json,
) => CustomLessonDatesRecurrence(
  dates: (json['dates'] as List<dynamic>)
      .map((e) => DateTime.parse(e as String))
      .toList(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$CustomLessonDatesRecurrenceToJson(
  CustomLessonDatesRecurrence instance,
) => <String, dynamic>{
  'dates': instance.dates.map((e) => e.toIso8601String()).toList(),
  'type': instance.$type,
};
