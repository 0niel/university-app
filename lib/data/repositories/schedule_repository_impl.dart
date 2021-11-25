import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/data/datasources/schedule_local.dart';
import 'package:rtu_mirea_app/data/datasources/schedule_remote.dart';
import 'package:rtu_mirea_app/data/models/schedule_model.dart';
import 'package:rtu_mirea_app/data/models/schedule_settings_model.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';
import 'package:rtu_mirea_app/domain/entities/schedule_settings.dart';
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
    connectionChecker.checkInterval = const Duration(seconds: 2);
    if (await connectionChecker.hasConnection) {
      try {
        final groupsList = await remoteDataSource.getGroups();
        localDataSource.setGroupsToCache(groupsList);
        return Right(groupsList);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      try {
        final localGroupsList = await localDataSource.getGroupsFromCache();
        return Right(localGroupsList);
      } on CacheException {
        return const Left(CacheFailure());
      }
    }
  }

  Future<Either<Failure, Schedule>> _tryGetLocalSchedule(String group) async {
    try {
      final localSchedule = await localDataSource.getScheduleFromCache();
      for (var schedule in localSchedule) {
        if (schedule.group == group) {
          return Right(schedule);
        }
      }
      // If the group is not downloaded
      return const Left(CacheFailure());
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  Future<Either<Failure, Schedule>> _tryGetRemoteSchedule(String group) async {
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
        // If we have a ServerException, but we have an internet connection,
        // we can try to get the schedule from the local storage
        final localSchedule = await _tryGetLocalSchedule(group);
        if (localSchedule.isRight()) return localSchedule;
        return Left(ServerFailure());
      }
    } else {
      return await _tryGetLocalSchedule(group);
    }
  }

  @override
  Future<Either<Failure, Schedule>> getSchedule(
      String group, bool fromRemote) async {
    if (fromRemote) {
      return await _tryGetRemoteSchedule(group);
    } else {
      return await _tryGetLocalSchedule(group);
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

  @override
  Future<Either<Failure, List<Schedule>>> getDownloadedSchedules() async {
    try {
      final localSchedule = await localDataSource.getScheduleFromCache();
      return Right(localSchedule);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<void> deleteSchedule(String group) async {
    try {
      final localSchedule = await localDataSource.getScheduleFromCache();
      for (int i = 0; i < localSchedule.length; i++) {
        // update schedule
        if (localSchedule[i].group == group) {
          localSchedule.removeAt(i);
          break;
        }
      }
      localDataSource.setScheduleToCache(localSchedule);
    } on CacheException {
      return;
    }
  }

  @override
  Future<ScheduleSettings> getSettings() async {
    try {
      final localSettings = await localDataSource.getSettingsFromCache();
      return localSettings;
    } on CacheException {
      const newLocalSettings = ScheduleSettingsModel(
        showEmptyLessons: false,
        showLessonsNumbers: false,
        calendarFormat: 2,
      );
      await localDataSource.setSettingsToCache(newLocalSettings);
      return newLocalSettings;
    }
  }

  @override
  Future<void> setSettings(ScheduleSettings settings) async {
    localDataSource.setSettingsToCache(ScheduleSettingsModel(
      showEmptyLessons: settings.showEmptyLessons,
      showLessonsNumbers: settings.showLessonsNumbers,
      calendarFormat: settings.calendarFormat,
    ));
  }
}
