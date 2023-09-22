import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:schedule_api_client/api_client.dart';
import 'package:storage/storage.dart';

part 'schedule_storage.dart';

/// {@template news_failure}
/// Базовый класс для ошибок, связанных с расписанием.
/// {@endtemplate}
abstract class ScheduleFailure with EquatableMixin implements Exception {
  /// {@macro news_failure}
  const ScheduleFailure(this.error);

  /// Связанная ошибка.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// {@template get_feed_failure}
/// Вызывается при ошибке получения доступных групп.
/// {@endtemplate}
class GetGroupsFailure extends ScheduleFailure {
  /// {@macro get_feed_failure}
  const GetGroupsFailure(super.error);
}

/// {@template get_categories_failure}
/// Вызывается при ошибке получения расписания.
/// {@endtemplate}
class GetScheduleFailure extends ScheduleFailure {
  /// {@macro get_categories_failure}
  const GetScheduleFailure(super.error);
}

/// {@template news_repository}
/// Репозиторий для работы с расписанием.
/// {@endtemplate}
class ScheduleRepository {
  /// {@macro news_repository}
  const ScheduleRepository({
    required ScheduleApiClient apiClient,
    required ScheduleStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  final ScheduleApiClient _apiClient;
  final ScheduleStorage _storage;

  /// Запрашивает доступные группы.
  Future<GroupsResponse> getGroups() async {
    try {
      return await _apiClient.getGroups();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetGroupsFailure(error), stackTrace);
    }
  }

  /// Запрашивает расписание для группы.
  Future<ScheduleResponse> fetchSchedule({required String group}) async {
    try {
      final schedule = await _apiClient.getScheduleByGroup(group: group);
      await _storage.setSchedule(schedule);
      return schedule;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetScheduleFailure(error), stackTrace);
    }
  }
}
