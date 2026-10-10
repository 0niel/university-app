import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'teacher_schedule_query.freezed.dart';

@freezed
abstract class TeacherScheduleQuery with _$TeacherScheduleQuery {
  const factory TeacherScheduleQuery({
    required Teacher teacher,
    required DateTime week,
  }) = _TeacherScheduleQuery;

  const TeacherScheduleQuery._();

  String get target => teacher.uid ?? teacher.name;
  DateTime get end => week.add(const Duration(days: 6));
}
