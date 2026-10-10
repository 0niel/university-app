import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'teacher_dashboard_binding.freezed.dart';

@freezed
sealed class TeacherDashboardBinding with _$TeacherDashboardBinding {
  const TeacherDashboardBinding._();

  const factory TeacherDashboardBinding.restoring() = TeacherBindingRestoring;
  const factory TeacherDashboardBinding.unselected() = TeacherBindingUnselected;
  const factory TeacherDashboardBinding.unavailable() =
      TeacherBindingUnavailable;
  const factory TeacherDashboardBinding.ready(Teacher value) =
      TeacherBindingReady;

  factory TeacherDashboardBinding.fromAccount(AccountPersonaState account) {
    final teacher = account.teacher;
    if (account.isTeacher &&
        account.persona.teacherAvailable &&
        teacher != null) {
      return TeacherDashboardBinding.ready(teacher);
    }
    if (!account.loaded && account.loading) {
      return const TeacherDashboardBinding.restoring();
    }
    return account.isTeacher && account.persona.teacherId != null
        ? const TeacherDashboardBinding.unavailable()
        : const TeacherDashboardBinding.unselected();
  }

  Teacher? get teacher => switch (this) {
    TeacherBindingReady(:final value) => value,
    _ => null,
  };
}
