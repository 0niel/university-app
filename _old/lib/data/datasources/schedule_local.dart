import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/data/models/schedule_model.dart';
import 'package:rtu_mirea_app/data/models/schedule_settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ScheduleLocalData {
  /// Gets the cached [List<String>] names of all available groups for
  /// which the server has a schedule.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<String>> getGroupsFromCache();

  /// Gets the cached [List<ScheduleModel>] all saved schedules
  /// which were added using [setScheduleInCache].
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<ScheduleModel>> getScheduleFromCache();

  /// Update the schedule in cache. If there is no schedule in the cache
  /// it will create it, otherwise it will update it.
  Future<void> setScheduleToCache(List<ScheduleModel> schedules);

  /// Adds a [List<String>] of [groups] to the cache. If the groups list
  /// is already in the cache, it will be overwritten by [groups] data.
  Future<void> setGroupsToCache(List<String> groups);

  /// Gets the name of the currently active group from the cache or Null
  /// if the active group has not yet been installed.
  ///
  /// Throws [CacheException] if active group is not in the cache.
  Future<String> getActiveGroupFromCache();

  /// Set the active group for which the schedule will be taken. If the
  /// group is already installed, the name of the active group will be
  /// overwritten with [group].
  Future<void> setActiveGroupToCache(String group);

  Future<void> setSettingsToCache(ScheduleSettingsModel settings);
  Future<ScheduleSettingsModel> getSettingsFromCache();
}

class ScheduleLocalDataImpl implements ScheduleLocalData {
  final SharedPreferences sharedPreferences;

  ScheduleLocalDataImpl({required this.sharedPreferences});

  @override
  Future<bool> setGroupsToCache(List<String> groups) {
    return sharedPreferences.setStringList('groups', groups);
  }

  @override
  Future<void> setScheduleToCache(List<ScheduleModel> schedules) {
    final List<String> scheduleJsonList =
        schedules.map((schedule) => schedule.toRawJson()).toList();
    return sharedPreferences.setStringList('schedule', scheduleJsonList);
  }

  @override
  Future<List<String>> getGroupsFromCache() async {
    final groups = sharedPreferences.getStringList('groups');
    if (groups != null) return groups;
    throw CacheException('The list of groups is not set');
  }

  @override
  Future<List<ScheduleModel>> getScheduleFromCache() async {
    final jsonScheduleList = sharedPreferences.getStringList('schedule');
    if (jsonScheduleList != null) {
      return Future.value(jsonScheduleList
          .map((scheduleJson) => ScheduleModel.fromRawJson(scheduleJson))
          .toList());
    } else {
      throw CacheException('The list of schedule is not set');
    }
  }

  @override
  Future<String> getActiveGroupFromCache() async {
    String? activeGroup = sharedPreferences.getString('active_group');
    if (activeGroup == null) throw CacheException('Active groups are not set');
    return activeGroup;
  }

  @override
  Future<void> setActiveGroupToCache(String group) {
    return sharedPreferences.setString('active_group', group);
  }

  @override
  Future<ScheduleSettingsModel> getSettingsFromCache() {
    String? settings = sharedPreferences.getString('schedule_settings');
    if (settings == null) throw CacheException('The settings are not set');
    return Future.value(ScheduleSettingsModel.fromRawJson(settings));
  }

  @override
  Future<void> setSettingsToCache(ScheduleSettingsModel settings) {
    return sharedPreferences.setString(
        'schedule_settings', settings.toRawJson());
  }
}
