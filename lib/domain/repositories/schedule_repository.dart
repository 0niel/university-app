import 'package:rtu_mirea_app/domain/entities/schedule.dart';

abstract class ScheduleRepository {
  Future<Schedule> getSchedule(String group);
  Future<List<String>> getAllGroups();
  Future<bool> isGroupExist();
}
