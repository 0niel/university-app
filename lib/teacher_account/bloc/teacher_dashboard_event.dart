import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_navigation.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_query.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'teacher_dashboard_event.freezed.dart';

enum TeacherDashboardRefreshScope { all, schedule, rating }

sealed class TeacherDashboardNavigationCommand
    implements TeacherDashboardEvent {}

@freezed
sealed class TeacherDashboardEvent with _$TeacherDashboardEvent {
  const factory TeacherDashboardEvent.accountChanged(
    AccountPersonaState account,
  ) = TeacherDashboardAccountChanged;
  const factory TeacherDashboardEvent.scheduleRequested(
    TeacherScheduleQuery query,
  ) = TeacherDashboardScheduleRequested;
  const factory TeacherDashboardEvent.ratingRequested(Teacher teacher) =
      TeacherDashboardRatingRequested;
  const factory TeacherDashboardEvent.refreshRequested({
    @Default(TeacherDashboardRefreshScope.all)
    TeacherDashboardRefreshScope scope,
  }) = TeacherDashboardRefreshRequested;
  const factory TeacherDashboardEvent.weekChanged(int delta) =
      TeacherDashboardWeekChanged;
  const factory TeacherDashboardEvent.daySelected(DateTime day) =
      TeacherDashboardDaySelected;
  const factory TeacherDashboardEvent.todayRequested() =
      TeacherDashboardTodayRequested;
  const factory TeacherDashboardEvent.clockTicked(DateTime now) =
      TeacherDashboardClockTicked;
  const factory TeacherDashboardEvent.activityChanged({required bool active}) =
      TeacherDashboardActivityChanged;
  @Implements<TeacherDashboardNavigationCommand>()
  const factory TeacherDashboardEvent.openScheduleRequested(
    TeacherScheduleDestination destination,
  ) = TeacherDashboardOpenScheduleRequested;
  @Implements<TeacherDashboardNavigationCommand>()
  const factory TeacherDashboardEvent.navigationCancelled() =
      TeacherDashboardNavigationCancelled;
  const factory TeacherDashboardEvent.navigationHandled() =
      TeacherDashboardNavigationHandled;
}
