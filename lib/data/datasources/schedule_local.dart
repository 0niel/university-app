import 'package:hive/hive.dart';
import 'package:rtu_mirea_app/data/models/schedule_model.dart';

abstract class ScheduleLocalData {
  Future<List<ScheduleModel>> getScheduleFromCache(String group);
  Future<List<String>> getGroupsFromCache();

  Future<void> addScheduleToCache(ScheduleModel schedule);
  Future<void> addGroupsToCache(List<String> groups);
}

class ScheduleLocalDataHive implements ScheduleLocalData {
  late final _box;

  ScheduleLocalDataHive() {
    _box = Hive.box('schedule');
  }

  @override
  Future<void> addGroupsToCache(List<String> groups) async {
    // TODO: implement addGroupsToCache
    throw UnimplementedError();
  }

  @override
  Future<void> addScheduleToCache(ScheduleModel schedule) async {
    // TODO: implement addScheduleToCache
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getGroupsFromCache() async {
    // TODO: implement getGroupsFromCache
    throw UnimplementedError();
  }

  @override
  Future<List<ScheduleModel>> getScheduleFromCache(String group) async {
    // TODO: implement getScheduleFromCache
    throw UnimplementedError();
  }
}
