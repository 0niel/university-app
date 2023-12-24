import 'package:schedule/schedule.dart';

/// {@template news_data_source}
/// An interface for a schedule content data.
/// {@endtemplate}
abstract class ScheduleDataSource {
  /// {@macro news_data_source}
  const ScheduleDataSource();

  /// Fetches schedule for a given academic [group] identifier.
  Future<List<SchedulePart>> getSchedule({required String group});

  /// Search for academic groups by [query].
  Future<List<Group>> searchGroups({required String query});

  /// Search for classrooms by [query].
  Future<List<Classroom>> searchClassrooms({required String query});

  /// Search for teachers by [query].
  Future<List<Teacher>> searchTeachers({required String query});

  /// Fetches teacher's schedule by [teacher] unique identifier (may be a name
  /// or id).
  Future<List<SchedulePart>> getTeacherSchedule({required String teacher});

  /// Fetches classroom's schedule by [classroom] unique identifier (may be a
  /// classroom number or id).
  Future<List<SchedulePart>> getClassroomSchedule({required String classroom});
}
