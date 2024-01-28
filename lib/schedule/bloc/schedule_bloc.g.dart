// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleState _$ScheduleStateFromJson(Map<String, dynamic> json) => ScheduleState(
      status: $enumDecode(_$ScheduleStatusEnumMap, json['status']),
      classroomsSchedule: (json['classroomsSchedule'] as List<dynamic>?)
              ?.map((e) => _$recordConvert(
                    e,
                    ($jsonValue) => (
                      $jsonValue[r'$1'] as String,
                      Classroom.fromJson($jsonValue[r'$2'] as Map<String, dynamic>),
                      ($jsonValue[r'$3'] as List<dynamic>)
                          .map((e) => SchedulePart.fromJson(e as Map<String, dynamic>))
                          .toList(),
                    ),
                  ))
              .toList() ??
          const [],
      teachersSchedule: (json['teachersSchedule'] as List<dynamic>?)
              ?.map((e) => _$recordConvert(
                    e,
                    ($jsonValue) => (
                      $jsonValue[r'$1'] as String,
                      Teacher.fromJson($jsonValue[r'$2'] as Map<String, dynamic>),
                      ($jsonValue[r'$3'] as List<dynamic>)
                          .map((e) => SchedulePart.fromJson(e as Map<String, dynamic>))
                          .toList(),
                    ),
                  ))
              .toList() ??
          const [],
      groupsSchedule: (json['groupsSchedule'] as List<dynamic>?)
              ?.map((e) => _$recordConvert(
                    e,
                    ($jsonValue) => (
                      $jsonValue[r'$1'] as String,
                      Group.fromJson($jsonValue[r'$2'] as Map<String, dynamic>),
                      ($jsonValue[r'$3'] as List<dynamic>)
                          .map((e) => SchedulePart.fromJson(e as Map<String, dynamic>))
                          .toList(),
                    ),
                  ))
              .toList() ??
          const [],
      isMiniature: json['isMiniature'] as bool? ?? false,
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => ScheduleComment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      showEmptyLessons: json['showEmptyLessons'] as bool? ?? false,
      showCommentsIndicators: json['showCommentsIndicators'] as bool? ?? true,
      selectedSchedule: const SelectedScheduleConverter().fromJson(json['selectedSchedule'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$ScheduleStateToJson(ScheduleState instance) => <String, dynamic>{
      'status': _$ScheduleStatusEnumMap[instance.status]!,
      'classroomsSchedule': instance.classroomsSchedule
          .map((e) => {
                r'$1': e.$1,
                r'$2': e.$2,
                r'$3': e.$3,
              })
          .toList(),
      'teachersSchedule': instance.teachersSchedule
          .map((e) => {
                r'$1': e.$1,
                r'$2': e.$2,
                r'$3': e.$3,
              })
          .toList(),
      'groupsSchedule': instance.groupsSchedule
          .map((e) => {
                r'$1': e.$1,
                r'$2': e.$2,
                r'$3': e.$3,
              })
          .toList(),
      'comments': instance.comments,
      'isMiniature': instance.isMiniature,
      'showCommentsIndicators': instance.showCommentsIndicators,
      'showEmptyLessons': instance.showEmptyLessons,
      'selectedSchedule': const SelectedScheduleConverter().toJson(instance.selectedSchedule),
    };

const _$ScheduleStatusEnumMap = {
  ScheduleStatus.initial: 'initial',
  ScheduleStatus.loading: 'loading',
  ScheduleStatus.failure: 'failure',
  ScheduleStatus.loaded: 'loaded',
};

$Rec _$recordConvert<$Rec>(
  Object? value,
  $Rec Function(Map) convert,
) =>
    convert(value as Map<String, dynamic>);
