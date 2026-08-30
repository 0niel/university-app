// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'unknown_schedule_part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UnknownSchedulePart _$UnknownSchedulePartFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_UnknownSchedulePart', json, ($checkedConvert) {
      final val = _UnknownSchedulePart(
        dates: $checkedConvert(
          'dates',
          (v) => v == null
              ? const <DateTime>[]
              : const DatesConverter().fromJson(v as List),
        ),
        type: $checkedConvert(
          'type',
          (v) => v as String? ?? UnknownSchedulePart.identifier,
        ),
      );
      return val;
    });

Map<String, dynamic> _$UnknownSchedulePartToJson(
  _UnknownSchedulePart instance,
) => <String, dynamic>{
  'dates': const DatesConverter().toJson(instance.dates),
  'type': instance.type,
};
