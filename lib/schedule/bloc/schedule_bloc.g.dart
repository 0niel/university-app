// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduleStateImpl _$$ScheduleStateImplFromJson(Map<String, dynamic> json) => _$ScheduleStateImpl(
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
              ?.map((e) => LessonComment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      showEmptyLessons: json['showEmptyLessons'] as bool? ?? false,
      showCommentsIndicators: json['showCommentsIndicators'] as bool? ?? true,
      isListModeEnabled: json['isListModeEnabled'] as bool? ?? false,
      scheduleComments: (json['scheduleComments'] as List<dynamic>?)
              ?.map((e) => ScheduleComment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      selectedSchedule: const SelectedScheduleConverter().fromJson(json['selectedSchedule'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$$ScheduleStateImplToJson(_$ScheduleStateImpl instance) => <String, dynamic>{
      'classroomsSchedule': instance.classroomsSchedule
          .map((e) => <String, dynamic>{
                r'$1': e.$1,
                r'$2': e.$2,
                r'$3': e.$3,
              })
          .toList(),
      'teachersSchedule': instance.teachersSchedule
          .map((e) => <String, dynamic>{
                r'$1': e.$1,
                r'$2': e.$2,
                r'$3': e.$3,
              })
          .toList(),
      'groupsSchedule': instance.groupsSchedule
          .map((e) => <String, dynamic>{
                r'$1': e.$1,
                r'$2': e.$2,
                r'$3': e.$3,
              })
          .toList(),
      'isMiniature': instance.isMiniature,
      'comments': instance.comments,
      'showEmptyLessons': instance.showEmptyLessons,
      'showCommentsIndicators': instance.showCommentsIndicators,
      'isListModeEnabled': instance.isListModeEnabled,
      'scheduleComments': instance.scheduleComments,
      'selectedSchedule': const SelectedScheduleConverter().toJson(instance.selectedSchedule),
    };

$Rec _$recordConvert<$Rec>(
  Object? value,
  $Rec Function(Map) convert,
) =>
    convert(value as Map<String, dynamic>);
