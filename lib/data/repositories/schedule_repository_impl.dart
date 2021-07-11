import 'package:rtu_mirea_app/data/datasources/schedule_local.dart';
import 'package:rtu_mirea_app/data/datasources/schedule_remote.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';
import 'package:rtu_mirea_app/domain/repositories/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteData remoteDataSource;
  final ScheduleLocalData localDataSource;

  ScheduleRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<List<String>> getAllGroups() {
    // TODO: implement getAllGroups
    throw UnimplementedError();
  }

  @override
  Future<Schedule> getSchedule(String group) {
    // TODO: implement getSchedule
    throw UnimplementedError();
  }

  @override
  Future<bool> isGroupExist() {
    // TODO: implement isGroupExist
    throw UnimplementedError();
  }
}
