// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_schedule_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomScheduleState _$CustomScheduleStateFromJson(Map<String, dynamic> json) =>
    _CustomScheduleState(
      customSchedules:
          (json['customSchedules'] as List<dynamic>?)
              ?.map((e) => CustomSchedule.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CustomScheduleStateToJson(
  _CustomScheduleState instance,
) => <String, dynamic>{
  'customSchedules': instance.customSchedules.map((e) => e.toJson()).toList(),
};
