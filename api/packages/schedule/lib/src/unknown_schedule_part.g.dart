// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'unknown_schedule_part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnknownSchedulePart _$UnknownSchedulePartFromJson(Map<String, dynamic> json) => $checkedCreate(
      'UnknownSchedulePart',
      json,
      ($checkedConvert) {
        final val = UnknownSchedulePart(
          dates: $checkedConvert('dates', (v) => v == null ? const [] : const DatesConverter().fromJson(v as List)),
          type: $checkedConvert('type', (v) => v as String? ?? UnknownSchedulePart.identifier),
        );
        return val;
      },
    );

Map<String, dynamic> _$UnknownSchedulePartToJson(UnknownSchedulePart instance) => <String, dynamic>{
      'type': instance.type,
      'dates': const DatesConverter().toJson(instance.dates),
    };
