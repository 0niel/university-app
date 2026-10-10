import 'package:campus_repository/campus_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/teacher_account/domain/teacher_workload.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_dashboard_binding.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_resource.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_navigation.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_query.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_snapshot.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'teacher_dashboard_state.freezed.dart';

@freezed
abstract class TeacherDashboardState with _$TeacherDashboardState {
  const factory TeacherDashboardState({
    required DateTime now,
    required DateTime day,
    required TeacherDashboardBinding binding,
    required TeacherWorkload workload,
    @Default(TeacherResource<TeacherScheduleSnapshot>.idle())
    TeacherResource<TeacherScheduleSnapshot> schedule,
    @Default(TeacherResource<List<ScheduleChange>>.idle())
    TeacherResource<List<ScheduleChange>> changes,
    @Default(TeacherResource<TeacherProfile>.idle())
    TeacherResource<TeacherProfile> rating,
    @Default(TeacherScheduleNavigation.idle())
    TeacherScheduleNavigation navigation,
  }) = _TeacherDashboardState;

  const TeacherDashboardState._();

  Teacher? get teacher => binding.teacher;
  DateTime get week => day.subtract(Duration(days: day.weekday - 1));
  TeacherScheduleQuery? get query => teacher == null
      ? null
      : TeacherScheduleQuery(teacher: teacher!, week: week);
  TeacherLessonOccurrence? get preview => schedule.data == null
      ? null
      : workload.currentAt(now) ?? workload.nextAt(now);
}
