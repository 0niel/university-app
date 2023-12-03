import 'package:schedule/schedule_parts.dart';

/// {@template news_data_source}
/// An interface for a schedule content data.
/// {@endtemplate}
abstract class ScheduleDataSource {
  /// {@macro news_data_source}
  const ScheduleDataSource();

  /// Fetches schedule for a given academic [group].
  Future<List<SchedulePart>> getSchedule({required String group});
}
