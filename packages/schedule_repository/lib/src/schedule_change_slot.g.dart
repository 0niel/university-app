// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_change_slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleChangeSlot _$ScheduleChangeSlotFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_ScheduleChangeSlot', json, ($checkedConvert) {
  final val = _ScheduleChangeSlot(
    start: $checkedConvert('start', (v) => v as String?),
    end: $checkedConvert('end', (v) => v as String?),
    subject: $checkedConvert('subject', (v) => v as String?),
    lessonType: $checkedConvert('lessonType', (v) => v as String?),
    lessonNumber: $checkedConvert('lessonNumber', (v) => (v as num?)?.toInt()),
    dates: $checkedConvert(
      'dates',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          const [],
    ),
    rooms: $checkedConvert(
      'rooms',
      (v) =>
          (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    ),
    teachers: $checkedConvert(
      'teachers',
      (v) =>
          (v as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    ),
  );
  return val;
});

Map<String, dynamic> _$ScheduleChangeSlotToJson(_ScheduleChangeSlot instance) =>
    <String, dynamic>{
      'start': instance.start,
      'end': instance.end,
      'subject': instance.subject,
      'lessonType': instance.lessonType,
      'lessonNumber': instance.lessonNumber,
      'dates': instance.dates.map((e) => e.toIso8601String()).toList(),
      'rooms': instance.rooms,
      'teachers': instance.teachers,
    };
