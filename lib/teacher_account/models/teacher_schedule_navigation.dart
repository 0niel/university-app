import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher_schedule_navigation.freezed.dart';

enum TeacherScheduleDestination { schedule, changes, calendar }

@freezed
sealed class TeacherScheduleNavigation with _$TeacherScheduleNavigation {
  const TeacherScheduleNavigation._();

  const factory TeacherScheduleNavigation.idle() = TeacherNavigationIdle;
  const factory TeacherScheduleNavigation.activating(
    TeacherScheduleDestination destination,
  ) = TeacherNavigationActivating;
  const factory TeacherScheduleNavigation.ready(
    TeacherScheduleDestination destination,
  ) = TeacherNavigationReady;
  const factory TeacherScheduleNavigation.failure(
    TeacherScheduleDestination destination,
  ) = TeacherNavigationFailure;

  bool get isBusy => this is TeacherNavigationActivating;
}
