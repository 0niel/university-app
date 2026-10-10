import 'package:campus_repository/campus_repository.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_query.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_snapshot.dart';
import 'package:schedule_repository/schedule_repository.dart';

class TeacherDashboardRepository {
  const TeacherDashboardRepository({
    required this._schedules,
    required this._campus,
    required this._cache,
    required this._clock,
  });

  final ScheduleRepository _schedules;
  final CampusRepository _campus;
  final ScheduleState Function() _cache;
  final DateTime Function() _clock;

  TeacherScheduleSnapshot? cachedSchedule(TeacherScheduleQuery query) {
    final uid = query.teacher.uid;
    if (uid == null) return null;
    final cache = _cache();
    final fetchedAt = cache.scheduleSyncedAt[uid];
    if (fetchedAt == null) return null;
    final entry = cache.teachersSchedule
        .where(
          (entry) => entry.$1 == uid && entry.$2.uid == uid,
        )
        .firstOrNull;
    if (entry == null) return null;
    return TeacherScheduleSnapshot(
      schedule: entry.$3,
      fetchedAt: fetchedAt,
      source: TeacherScheduleSource.cache,
    );
  }

  Future<TeacherScheduleSnapshot> loadSchedule(
    TeacherScheduleQuery query,
  ) async {
    final response = await _schedules.getTeacherSchedule(
      teacher: query.target,
      dateFrom: query.week,
      dateTo: query.end,
    );
    return TeacherScheduleSnapshot(
      schedule: response.data,
      fetchedAt: _clock(),
    );
  }

  Future<List<ScheduleChange>> loadChanges(TeacherScheduleQuery query) =>
      _schedules.getScheduleChanges(
        targetType: ScheduleTargetType.teacher,
        target: query.target,
      );

  Future<TeacherProfile> loadRating(Teacher teacher) =>
      _campus.getTeacherProfile(teacher.name);
}
