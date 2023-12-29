import 'package:equatable/equatable.dart';
import 'package:university_app_server_api/client.dart';

/// {@template schedule_failure}
/// Base failure class for the schedule repository failures.
/// {@endtemplate}
abstract class ScheduleFailure with EquatableMixin implements Exception {
  /// {@macro schedule_failure}
  const ScheduleFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

class GetScheduleFailure extends ScheduleFailure {
  const GetScheduleFailure(super.error);
}

class SearchGroupsFailure extends ScheduleFailure {
  const SearchGroupsFailure(super.error);
}

class SearchClassroomsFailure extends ScheduleFailure {
  const SearchClassroomsFailure(super.error);
}

class SearchTeachersFailure extends ScheduleFailure {
  const SearchTeachersFailure(super.error);
}

class GetTeacherScheduleFailure extends ScheduleFailure {
  const GetTeacherScheduleFailure(super.error);
}

class GetClassroomScheduleFailure extends ScheduleFailure {
  const GetClassroomScheduleFailure(super.error);
}

/// {@template news_repository}
/// A repository that manages schedule data.
/// {@endtemplate}
class ScheduleRepository {
  /// {@macro news_repository}
  const ScheduleRepository({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Requests schedule for the provided [group]. Group is a unique name.
  Future<ScheduleResponse> getSchedule({
    required String group,
  }) async {
    try {
      return await _apiClient.getSchedule(
        group: group,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetScheduleFailure(error), stackTrace);
    }
  }

  Future<SearchGroupsResponse> searchGroups({
    String query = '',
  }) async {
    try {
      return await _apiClient.searchGroups(
        query: query,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SearchGroupsFailure(error), stackTrace);
    }
  }

  Future<SearchClassroomsResponse> searchClassrooms({
    String query = '',
  }) async {
    try {
      return await _apiClient.searchClassrooms(
        query: query,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SearchClassroomsFailure(error), stackTrace);
    }
  }

  Future<SearchTeachersResponse> searchTeachers({
    String query = '',
  }) async {
    try {
      return await _apiClient.searchTeachers(
        query: query,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SearchTeachersFailure(error), stackTrace);
    }
  }

  Future<ScheduleResponse> getTeacherSchedule({
    required String teacher,
  }) async {
    try {
      return await _apiClient.getTeacherSchedule(
        teacher: teacher,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetTeacherScheduleFailure(error), stackTrace);
    }
  }

  Future<ScheduleResponse> getClassroomSchedule({
    required String classroom,
  }) async {
    try {
      return await _apiClient.getClassroomSchedule(
        classroom: classroom,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetClassroomScheduleFailure(error), stackTrace);
    }
  }
}
