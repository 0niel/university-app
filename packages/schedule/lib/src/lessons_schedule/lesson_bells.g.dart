// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'lesson_bells.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonBells _$LessonBellsFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_LessonBells',
  json,
  ($checkedConvert) {
    final val = _LessonBells(
      startTime: $checkedConvert(
        'start_time',
        (v) => _timeFromJson(v as String),
      ),
      endTime: $checkedConvert('end_time', (v) => _timeFromJson(v as String)),
      number: $checkedConvert('number', (v) => (v as num?)?.toInt()),
    );
    return val;
  },
  fieldKeyMap: const {'startTime': 'start_time', 'endTime': 'end_time'},
);

Map<String, dynamic> _$LessonBellsToJson(_LessonBells instance) =>
    <String, dynamic>{
      'start_time': _timeToJson(instance.startTime),
      'end_time': _timeToJson(instance.endTime),
      'number': ?instance.number,
    };
