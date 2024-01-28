// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'lesson_bells.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonBells _$LessonBellsFromJson(Map<String, dynamic> json) => $checkedCreate(
      'LessonBells',
      json,
      ($checkedConvert) {
        final val = LessonBells(
          number: $checkedConvert('number', (v) => v as int),
          startTime: $checkedConvert('start_time', (v) => LessonBells._timeFromJson(v as String)),
          endTime: $checkedConvert('end_time', (v) => LessonBells._timeFromJson(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {'startTime': 'start_time', 'endTime': 'end_time'},
    );

Map<String, dynamic> _$LessonBellsToJson(LessonBells instance) => <String, dynamic>{
      'number': instance.number,
      'start_time': LessonBells._timeToJson(instance.startTime),
      'end_time': LessonBells._timeToJson(instance.endTime),
    };
