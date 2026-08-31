// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleState _$ScheduleStateFromJson(Map<String, dynamic> json) =>
    _ScheduleState(
      classroomsSchedule: json['classroomsSchedule'] == null
          ? const []
          : _classroomSchedulesFromJson(json['classroomsSchedule']),
      teachersSchedule: json['teachersSchedule'] == null
          ? const []
          : _teacherSchedulesFromJson(json['teachersSchedule']),
      groupsSchedule: json['groupsSchedule'] == null
          ? const []
          : _groupSchedulesFromJson(json['groupsSchedule']),
      selectedSchedule: const SelectedScheduleConverter().fromJson(
        json['selectedSchedule'] as Map<String, dynamic>?,
      ),
      lastSyncedAt: json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
      scheduleSyncedAt:
          (json['scheduleSyncedAt'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, DateTime.parse(e as String)),
          ) ??
          const <UID, DateTime>{},
    );

Map<String, dynamic> _$ScheduleStateToJson(
  _ScheduleState instance,
) => <String, dynamic>{
  'classroomsSchedule': _classroomSchedulesToJson(instance.classroomsSchedule),
  'teachersSchedule': _teacherSchedulesToJson(instance.teachersSchedule),
  'groupsSchedule': _groupSchedulesToJson(instance.groupsSchedule),
  'selectedSchedule': const SelectedScheduleConverter().toJson(
    instance.selectedSchedule,
  ),
  'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
  'scheduleSyncedAt': instance.scheduleSyncedAt.map(
    (k, e) => MapEntry(k, e.toIso8601String()),
  ),
};
