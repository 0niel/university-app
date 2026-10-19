import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'teacher_schedule_snapshot.freezed.dart';

@freezed
abstract class TeacherScheduleSnapshot with _$TeacherScheduleSnapshot {
  const factory TeacherScheduleSnapshot({
    required List<SchedulePart> schedule,
    required DateTime fetchedAt,
    @Default(TeacherScheduleSource.network) TeacherScheduleSource source,
  }) = _TeacherScheduleSnapshot;
}

enum TeacherScheduleSource { network, cache }
