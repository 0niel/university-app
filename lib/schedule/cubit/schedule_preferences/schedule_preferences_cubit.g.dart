// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_preferences_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SchedulePreferencesState _$SchedulePreferencesStateFromJson(
  Map<String, dynamic> json,
) => _SchedulePreferencesState(
  isMiniature: json['isMiniature'] as bool? ?? false,
  showEmptyLessons: json['showEmptyLessons'] as bool? ?? false,
  isListModeEnabled: json['isListModeEnabled'] as bool? ?? false,
  showCommentsIndicators: json['showCommentsIndicators'] as bool? ?? true,
  showLectures: json['showLectures'] as bool? ?? true,
  showSeminars: json['showSeminars'] as bool? ?? true,
  showLabs: json['showLabs'] as bool? ?? true,
  showExams: json['showExams'] as bool? ?? true,
  showGaps: json['showGaps'] as bool? ?? true,
  collapsePast: json['collapsePast'] as bool? ?? true,
  hiddenSubjects:
      (json['hiddenSubjects'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$SchedulePreferencesStateToJson(
  _SchedulePreferencesState instance,
) => <String, dynamic>{
  'isMiniature': instance.isMiniature,
  'showEmptyLessons': instance.showEmptyLessons,
  'isListModeEnabled': instance.isListModeEnabled,
  'showCommentsIndicators': instance.showCommentsIndicators,
  'showLectures': instance.showLectures,
  'showSeminars': instance.showSeminars,
  'showLabs': instance.showLabs,
  'showExams': instance.showExams,
  'showGaps': instance.showGaps,
  'collapsePast': instance.collapsePast,
  'hiddenSubjects': instance.hiddenSubjects,
};
