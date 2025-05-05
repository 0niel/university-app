import 'dart:convert';

import 'package:schedule/schedule.dart';
import 'package:university_app_server_api/src/data/schedule/schedule_data_source.dart';
import 'package:university_app_server_api/src/models/models.dart';
import 'package:university_app_server_api/src/redis.dart';

/// {@template RedisCachedScheduleDataSource}
/// A data source that caches schedule data in Redis.
///
/// This class implements the [ScheduleDataSource] interface and uses a
/// Redis client to cache schedule data for a specified time-to-live (TTL).
///
/// The cached data is stored in Redis with a key based on the type of
/// schedule data being requested (e.g., group, teacher, classroom).
///
/// The cache is used to avoid redundant network requests and improve
/// performance. If remote data fetching fails, the cache is checked for
/// previously stored data. If cached data is found, it is returned instead
/// of throwing an error.
/// {@endtemplate}
class RedisCachedScheduleDataSource implements ScheduleDataSource {
  /// {@macro RedisCachedScheduleDataSource}
  RedisCachedScheduleDataSource({
    required ScheduleDataSource delegate,
    required RedisClient redisClient,
    int ttl = 1800,
  })  : _delegate = delegate,
        _redisClient = redisClient,
        _ttl = ttl;

  final ScheduleDataSource _delegate;
  final RedisClient _redisClient;
  final int _ttl;

  Future<T> _cacheOrFallback<T>({
    required String key,
    required Future<T> Function() fetch,
    required Map<String, dynamic> Function(T) toJson,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final result = await fetch();
      final encoded = json.encode(toJson(result));
      await _redisClient.command.send_object(['SET', key, encoded, 'EX', _ttl]);
      return result;
    } catch (e) {
      print(e);
      final cached = await _redisClient.command.get(key);
      if (cached != null) {
        try {
          final decoded = json.decode(cached as String) as Map<String, dynamic>;
          return fromJson(decoded);
        } catch (_) {}
      }
      rethrow;
    }
  }

  @override
  Future<List<SchedulePart>> getSchedule({required String group}) async {
    final key = 'schedule:$group';
    return _cacheOrFallback<List<SchedulePart>>(
      key: key,
      fetch: () => _delegate.getSchedule(group: group),
      toJson: (data) => ScheduleResponse(data: data).toJson(),
      fromJson: (json) => ScheduleResponse.fromJson(json).data,
    );
  }

  @override
  Future<List<SchedulePart>> getTeacherSchedule(
      {required String teacher,}) async {
    final key = 'schedule:teacher:$teacher';
    return _cacheOrFallback<List<SchedulePart>>(
      key: key,
      fetch: () => _delegate.getTeacherSchedule(teacher: teacher),
      toJson: (data) => ScheduleResponse(data: data).toJson(),
      fromJson: (json) => ScheduleResponse.fromJson(json).data,
    );
  }

  @override
  Future<List<SchedulePart>> getClassroomSchedule(
      {required String classroom,}) async {
    final key = 'schedule:classroom:$classroom';
    return _cacheOrFallback<List<SchedulePart>>(
      key: key,
      fetch: () => _delegate.getClassroomSchedule(classroom: classroom),
      toJson: (data) => ScheduleResponse(data: data).toJson(),
      fromJson: (json) => ScheduleResponse.fromJson(json).data,
    );
  }

  @override
  Future<List<Classroom>> searchClassrooms({required String query}) async {
    final key = 'schedule:search:classrooms:$query';
    return _cacheOrFallback<List<Classroom>>(
      key: key,
      fetch: () => _delegate.searchClassrooms(query: query),
      toJson: (data) => SearchClassroomsResponse(results: data).toJson(),
      fromJson: (json) => SearchClassroomsResponse.fromJson(json).results,
    );
  }

  @override
  Future<List<Group>> searchGroups({required String query}) async {
    final key = 'schedule:search:groups:$query';
    return _cacheOrFallback<List<Group>>(
      key: key,
      fetch: () => _delegate.searchGroups(query: query),
      toJson: (data) => SearchGroupsResponse(results: data).toJson(),
      fromJson: (json) => SearchGroupsResponse.fromJson(json).results,
    );
  }

  @override
  Future<List<Teacher>> searchTeachers({required String query}) async {
    final key = 'schedule:search:teachers:$query';
    return _cacheOrFallback<List<Teacher>>(
      key: key,
      fetch: () => _delegate.searchTeachers(query: query),
      toJson: (data) => SearchTeachersResponse(results: data).toJson(),
      fromJson: (json) => SearchTeachersResponse.fromJson(json).results,
    );
  }
}
