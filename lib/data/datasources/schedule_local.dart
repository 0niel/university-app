import 'package:rtu_mirea_app/data/models/schedule_model.dart';

abstract class ScheduleLocalData {
  /// Gets the cached [List<ScheduleModel>] all saved schedules
  /// which were added using [addScheduleToCache].
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<ScheduleModel>> getScheduleFromCache();

  /// Gets the cached [List<String>] names of all available groups for
  /// which the server has a schedule.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<String>> getGroupsFromCache();

  /// Adds a [ScheduleModel] to the list of the all cached schedule.
  /// If the schedule with this [schedule.group] is already in the cache,
  /// it will be overwritten
  Future<void> addScheduleToCache(ScheduleModel schedule);

  /// Delete the schedule from cache by [group] name.
  ///
  /// Throws [CacheException] if the schedule with this [group] name
  /// is not in the cache.
  Future<void> deleteScheduleFromCache(String group);

  /// Adds a [List<String>] of [groups] to the cache. If the groups list
  /// is already in the cache, it will be overwritten by [groups] data.
  Future<void> addGroupsToCache(List<String> groups);
}

class ScheduleLocalDataImpl implements ScheduleLocalData {
  final sharedPreferences;

  ScheduleLocalDataImpl({this.sharedPreferences});

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
  Future<List<ScheduleModel>> getScheduleFromCache() async {
    // TODO: implement getScheduleFromCache
    throw UnimplementedError();
  }

  @override
  Future<void> deleteScheduleFromCache(String group) {
    // TODO: implement deleteScheduleFromCache
    throw UnimplementedError();
  }
}
