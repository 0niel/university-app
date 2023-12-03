import 'package:schedule/schedule_parts.dart';
import 'package:university_app_server_api/src/data/schedule/schedule_data_source.dart';

part 'static_schedule_data.dart';

/// {@template in_memory_news_data_source}
/// An implementation of [NewsDataSource] which
/// is powered by in-memory news content.
/// {@endtemplate}
class InMemoryScheduleDataSource implements ScheduleDataSource {
  /// {@macro in_memory_news_data_store}
  InMemoryScheduleDataSource();

  @override
  Future<List<SchedulePart>> getSchedule({required String group}) {
    return Future.value(schedules);
  }
}
