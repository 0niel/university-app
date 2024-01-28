// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleResponse _$ScheduleResponseFromJson(Map<String, dynamic> json) => ScheduleResponse(
      data: (json['data'] as List<dynamic>).map((e) => SchedulePart.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$ScheduleResponseToJson(ScheduleResponse instance) => <String, dynamic>{
      'data': instance.data,
    };
