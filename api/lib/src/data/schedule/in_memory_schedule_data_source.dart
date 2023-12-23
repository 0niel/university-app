import 'package:schedule/schedule.dart';
import 'package:university_app_server_api/src/data/schedule/schedule_data_source.dart';

part 'static_schedule_data.dart';

/// {@template in_memory_news_data_source}
/// An implementation of [ScheduleDataSource] that
/// is powered by in-memory news content.
/// {@endtemplate}
class InMemoryScheduleDataSource implements ScheduleDataSource {
  /// {@macro in_memory_news_data_store}
  InMemoryScheduleDataSource();

  @override
  Future<List<SchedulePart>> getSchedule({required String group}) {
    return Future.value(schedules);
  }

  @override
  Future<List<SchedulePart>> getClassroomSchedule({required String classroom}) {
    // TODO: implement getClassroomSchedule
    throw UnimplementedError();
  }

  @override
  Future<List<SchedulePart>> getTeacherSchedule({required String teacher}) {
    // TODO: implement getTeacherSchedule
    throw UnimplementedError();
  }

  @override
  Future<List<Classroom>> searchClassrooms({required String query}) {
    // TODO: implement searchClassrooms
    throw UnimplementedError();
  }

  @override
  Future<List<Group>> searchGroups({required String query}) {
    // TODO: implement searchGroups
    throw UnimplementedError();
  }

  @override
  Future<List<Teacher>> searchTeachers({required String query}) {
    // TODO: implement searchTeachers
    throw UnimplementedError();
  }
}
