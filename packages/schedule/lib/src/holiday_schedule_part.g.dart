// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'holiday_schedule_part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HolidaySchedulePart _$HolidaySchedulePartFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_HolidaySchedulePart', json, ($checkedConvert) {
      final val = _HolidaySchedulePart(
        title: $checkedConvert('title', (v) => v as String),
        dates: $checkedConvert(
          'dates',
          (v) => const DatesConverter().fromJson(v as List),
        ),
        type: $checkedConvert(
          'type',
          (v) => v as String? ?? HolidaySchedulePart.identifier,
        ),
      );
      return val;
    });

Map<String, dynamic> _$HolidaySchedulePartToJson(
  _HolidaySchedulePart instance,
) => <String, dynamic>{
  'title': instance.title,
  'dates': const DatesConverter().toJson(instance.dates),
  'type': instance.type,
};
