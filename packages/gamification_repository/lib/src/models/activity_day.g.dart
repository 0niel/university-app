// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityDay _$ActivityDayFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ActivityDay', json, ($checkedConvert) {
      final val = _ActivityDay(
        day: $checkedConvert('day', (v) => DateTime.parse(v as String)),
        count: $checkedConvert('count', (v) => (v as num?)?.toInt() ?? 0),
      );
      return val;
    });

Map<String, dynamic> _$ActivityDayToJson(_ActivityDay instance) =>
    <String, dynamic>{
      'day': instance.day.toIso8601String(),
      'count': instance.count,
    };
