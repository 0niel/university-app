import 'dart:convert';

import 'package:schedule/schedule.dart';
import 'package:university_app_server_api/src/data/schedule/schedule_data_source.dart';
import 'package:university_app_server_api/src/models/models.dart';
import 'package:university_app_server_api/src/redis.dart';

class CachedScheduleDataSource implements ScheduleDataSource {
  CachedScheduleDataSource({
    required ScheduleDataSource delegate,
    required RedisClient redisClient,
    int ttl = 1800,
  })  : _delegate = delegate,
        _redisClient = redisClient,
        _ttl = ttl;

  final ScheduleDataSource _delegate;
  final RedisClient _redisClient;
  final int _ttl;

  @override
  Future<List<SchedulePart>> getSchedule({required String group}) async {
    final key = 'schedule:$group';
    try {
      final schedule = await _delegate.getSchedule(group: group);
      final scheduleData = ScheduleResponse(data: schedule).toJson();
      await _redisClient.command.send_object(['SET', key, json.encode(scheduleData), 'EX', _ttl]);
      return schedule;
    } catch (e) {
      final cached = await _redisClient.command.get(key);
      if (cached != null) {
        try {
          final decoded = json.decode(cached as String) as Map<String, dynamic>;
          return ScheduleResponse.fromJson(decoded).data;
        } catch (_) {}
      }
      rethrow;
    }
  }

  @override
  Future<List<SchedulePart>> getTeacherSchedule({required String teacher}) async {
    final key = 'schedule:teacher:$teacher';
    try {
      final schedule = await _delegate.getTeacherSchedule(teacher: teacher);
      final scheduleData = ScheduleResponse(data: schedule).toJson();
      await _redisClient.command.send_object(['SET', key, json.encode(scheduleData), 'EX', _ttl]);
      return schedule;
    } catch (e) {
      final cached = await _redisClient.command.get(key);
      if (cached != null) {
        try {
          final decoded = json.decode(cached as String) as Map<String, dynamic>;
          return ScheduleResponse.fromJson(decoded).data;
        } catch (_) {}
      }
      rethrow;
    }
  }

  @override
  Future<List<SchedulePart>> getClassroomSchedule({required String classroom}) async {
    final key = 'schedule:classroom:$classroom';
    try {
      final schedule = await _delegate.getClassroomSchedule(classroom: classroom);
      final scheduleData = ScheduleResponse(data: schedule).toJson();
      await _redisClient.command.send_object(['SET', key, json.encode(scheduleData), 'EX', _ttl]);
      return schedule;
    } catch (e) {
      final cached = await _redisClient.command.get(key);
      if (cached != null) {
        try {
          final decoded = json.decode(cached as String) as Map<String, dynamic>;
          return ScheduleResponse.fromJson(decoded).data;
        } catch (_) {}
      }
      rethrow;
    }
  }

  @override
  Future<List<Classroom>> searchClassrooms({required String query}) async {
    final key = 'schedule:search:classrooms:$query';
    try {
      final result = await _delegate.searchClassrooms(query: query);
      final encoded = json.encode(SearchClassroomsResponse(results: result).toJson());
      await _redisClient.command.send_object(['SET', key, encoded, 'EX', _ttl]);
      return result;
    } catch (e) {
      final cached = await _redisClient.command.get(key);
      if (cached != null) {
        try {
          final decoded = json.decode(cached as String) as Map<String, dynamic>;
          return SearchClassroomsResponse.fromJson(decoded).results;
        } catch (_) {}
      }
      rethrow;
    }
  }

  @override
  Future<List<Group>> searchGroups({required String query}) async {
    final key = 'schedule:search:groups:$query';
    try {
      final result = await _delegate.searchGroups(query: query);
      final encoded = json.encode(SearchGroupsResponse(results: result).toJson());
      await _redisClient.command.send_object(['SET', key, encoded, 'EX', _ttl]);
      return result;
    } catch (e) {
      final cached = await _redisClient.command.get(key);
      if (cached != null) {
        try {
          final decoded = json.decode(cached as String) as Map<String, dynamic>;
          return SearchGroupsResponse.fromJson(decoded).results;
        } catch (_) {}
      }
      rethrow;
    }
  }

  @override
  Future<List<Teacher>> searchTeachers({required String query}) async {
    final key = 'schedule:search:teachers:$query';
    try {
      final result = await _delegate.searchTeachers(query: query);
      final encoded = json.encode(SearchTeachersResponse(results: result).toJson());
      await _redisClient.command.send_object(['SET', key, encoded, 'EX', _ttl]);
      return result;
    } catch (e) {
      final cached = await _redisClient.command.get(key);
      if (cached != null) {
        try {
          final decoded = json.decode(cached as String) as Map<String, dynamic>;
          return SearchTeachersResponse.fromJson(decoded).results;
        } catch (_) {}
      }
      rethrow;
    }
  }
}
