import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/data/datasources/schedule_local.dart';
import 'package:rtu_mirea_app/data/datasources/schedule_remote.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';
import 'package:rtu_mirea_app/domain/repositories/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteData remoteDataSource;
  final ScheduleLocalData localDataSource;
  final InternetConnectionChecker connectionChecker;

  ScheduleRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, List<String>>> getAllGroups() async {
    if (await connectionChecker.hasConnection) {
      try {
        final groupsList = await remoteDataSource.getGroups();
        localDataSource.addGroupsToCache(groupsList);
        return Right(groupsList);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localGroupsList = await localDataSource.getGroupsFromCache();
        return Right(localGroupsList);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Schedule>> getSchedule(String group) async {
    if (await connectionChecker.hasConnection) {
      try {
        final schedule = await remoteDataSource.getScheduleByGroup(group);
        localDataSource.addScheduleToCache(schedule);
        return Right(schedule);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localSchedule = await localDataSource.getScheduleFromCache(group);
        return Right(localSchedule);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, bool>> isGroupExist() {
    // TODO: implement isGroupExist
    throw UnimplementedError();
  }
}
