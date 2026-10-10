import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher_schedule_gap.freezed.dart';

@freezed
abstract class TeacherScheduleGap with _$TeacherScheduleGap {
  const factory TeacherScheduleGap({
    required DateTime date,
    required DateTime start,
    required DateTime end,
  }) = _TeacherScheduleGap;

  const TeacherScheduleGap._();

  Duration get duration => end.difference(start);
}
