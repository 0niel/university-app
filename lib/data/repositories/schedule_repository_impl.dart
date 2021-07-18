import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/data/datasources/schedule_local.dart';
import 'package:rtu_mirea_app/data/datasources/schedule_remote.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';
import 'package:rtu_mirea_app/domain/repositories/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteData remoteDataSource;
  final ScheduleLocalData localDataSource;
  final InternetConnectionChecker connectionChecker;

  ScheduleRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.connectionChecker});

  @override
  Future<Either<Failure, List<String>>> getAllGroups() {
    // TODO: implement getAllGroups
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Schedule>> getSchedule(String group) {
    // TODO: implement getSchedule
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> isGroupExist() {
    // TODO: implement isGroupExist
    throw UnimplementedError();
  }
}
