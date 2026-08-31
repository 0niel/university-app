// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_target_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleTargetRow _$ScheduleTargetRowFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_ScheduleTargetRow',
      json,
      ($checkedConvert) {
        final val = _ScheduleTargetRow(
          externalId: $checkedConvert('external_id', (v) => v as String),
          targetTitle: $checkedConvert('target_title', (v) => v as String),
          fullTitle: $checkedConvert('full_title', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'externalId': 'external_id',
        'targetTitle': 'target_title',
        'fullTitle': 'full_title',
      },
    );

Map<String, dynamic> _$ScheduleTargetRowToJson(_ScheduleTargetRow instance) =>
    <String, dynamic>{
      'external_id': instance.externalId,
      'target_title': instance.targetTitle,
      'full_title': instance.fullTitle,
    };
