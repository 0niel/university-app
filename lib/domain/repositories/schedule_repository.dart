import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';

abstract class ScheduleRepository {
  Future<Either<Failure, Schedule>> getSchedule(String group);
  Future<Either<Failure, List<String>>> getAllGroups();
  Future<Either<Failure, bool>> isGroupExist();
}
