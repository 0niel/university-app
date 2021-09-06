import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';
import 'package:rtu_mirea_app/domain/entities/schedule_settings.dart';

abstract class ScheduleRepository {
  Future<Either<Failure, Schedule>> getSchedule(String group, bool fromRemote);
  Future<Either<Failure, List<Schedule>>> getDownloadedSchedules();
  Future<Either<Failure, List<String>>> getAllGroups();
  Future<Either<Failure, String>> getActiveGroup();
  Future<void> setActiveGroup(String group);
  Future<void> deleteSchedule(String group);
  Future<void> setSettings(ScheduleSettings settings);
  Future<ScheduleSettings> getSettings();
}
