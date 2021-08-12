import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/data/datasources/schedule_local.dart';
import 'package:rtu_mirea_app/data/datasources/schedule_remote.dart';
import 'package:rtu_mirea_app/data/models/schedule_model.dart';
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
        localDataSource.setGroupsToCache(groupsList);
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
        final ScheduleModel schedule =
            await remoteDataSource.getScheduleByGroup(group);
        try {
          final localSchedule = await localDataSource.getScheduleFromCache();

          bool found = false;
          for (int i = 0; i < localSchedule.length; i++) {
            // update schedule
            if (localSchedule[i].group == group) {
              localSchedule[i] = schedule;
              found = true;
            }
          }
          // If there is no schedule for this group, then we add it
          if (!found) localSchedule.add(schedule);

          localDataSource.setScheduleToCache(localSchedule);
        } on CacheException {
          localDataSource.setScheduleToCache([schedule]);
        }
        return Right(schedule);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localSchedule = await localDataSource.getScheduleFromCache();
        for (var schedule in localSchedule) {
          if (schedule.group == group) {
            return Right(schedule);
          }
        }
        // If the group is not downloaded
        return Left(CacheFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, String>> getActiveGroup() async {
    try {
      return Right(await localDataSource.getActiveGroupFromCache());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<void> setActiveGroup(String group) async {
    localDataSource.setActiveGroupToCache(group);
  }
}
