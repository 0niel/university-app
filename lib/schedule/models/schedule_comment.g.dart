// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleComment _$ScheduleCommentFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ScheduleComment', json, ($checkedConvert) {
      final val = _ScheduleComment(
        scheduleName: $checkedConvert('scheduleName', (v) => v as String),
        text: $checkedConvert('text', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ScheduleCommentToJson(_ScheduleComment instance) =>
    <String, dynamic>{
      'scheduleName': instance.scheduleName,
      'text': instance.text,
    };
