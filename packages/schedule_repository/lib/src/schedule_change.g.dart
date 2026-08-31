// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_change.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleChange _$ScheduleChangeFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_ScheduleChange', json, ($checkedConvert) {
  final val = _ScheduleChange(
    id: $checkedConvert('id', (v) => v as String),
    kind: $checkedConvert(
      'kind',
      (v) => $enumDecode(_$ScheduleChangeKindEnumMap, v),
    ),
    subject: $checkedConvert('subject', (v) => v as String),
    lessonDate: $checkedConvert(
      'lessonDate',
      (v) => DateTime.parse(v as String),
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    lessonNumber: $checkedConvert('lessonNumber', (v) => (v as num?)?.toInt()),
    oldValue: $checkedConvert(
      'oldValue',
      (v) => v == null
          ? const ScheduleChangeSlot()
          : ScheduleChangeSlot.fromJson(v as Map<String, dynamic>),
    ),
    newValue: $checkedConvert(
      'newValue',
      (v) => v == null
          ? const ScheduleChangeSlot()
          : ScheduleChangeSlot.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$ScheduleChangeToJson(_ScheduleChange instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': _$ScheduleChangeKindEnumMap[instance.kind]!,
      'subject': instance.subject,
      'lessonDate': instance.lessonDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'lessonNumber': instance.lessonNumber,
      'oldValue': instance.oldValue,
      'newValue': instance.newValue,
    };

const _$ScheduleChangeKindEnumMap = {
  ScheduleChangeKind.add: 'add',
  ScheduleChangeKind.cancel: 'cancel',
  ScheduleChangeKind.move: 'move',
  ScheduleChangeKind.room: 'room',
  ScheduleChangeKind.teacher: 'teacher',
};
