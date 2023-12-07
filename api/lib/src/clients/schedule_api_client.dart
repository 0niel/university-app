import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:university_app_server_api/src/models/models.dart';

class ScheduleApiMalformedResponse implements Exception {
  const ScheduleApiMalformedResponse({required this.error});

  final Object error;
}

class ScheduleApiRequestFailure implements Exception {
  const ScheduleApiRequestFailure({
    required this.statusCode,
    required this.body,
  });

  final int statusCode;

  final Map<String, dynamic> body;
}

class ScheduleApiClient {
  ScheduleApiClient({
    http.Client? httpClient,
  }) : this._(
          baseUrl: 'https://app-api.mirea.ninja',
          httpClient: httpClient,
        );

  ScheduleApiClient.localhost({
    http.Client? httpClient,
  }) : this._(
          baseUrl: 'http://10.0.2.2:8080',
          httpClient: httpClient,
        );

  ScheduleApiClient._({
    required String baseUrl,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _httpClient = httpClient ?? http.Client();

  final String _baseUrl;
  final http.Client _httpClient;

  Future<ScheduleResponse> getSchedule({
    String? group,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/schedule/group/$group');

    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw ScheduleApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return ScheduleResponse.fromJson(body);
  }

  Future<SearchGroupsResponse> searchGroups({
    String query = '',
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/schedule/search/groups').replace(
      queryParameters: <String, String>{
        'query': query,
      },
    );
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw ScheduleApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return SearchGroupsResponse.fromJson(body);
  }

  Future<SearchClassroomsResponse> searchClassrooms({
    String query = '',
  }) async {
    final uri =
        Uri.parse('$_baseUrl/api/v1/schedule/search/classrooms').replace(
      queryParameters: <String, String>{
        'query': query,
      },
    );
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw ScheduleApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return SearchClassroomsResponse.fromJson(body);
  }

  Future<SearchTeachersResponse> searchTeachers({
    String query = '',
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/schedule/search/teachers').replace(
      queryParameters: <String, String>{
        'query': query,
      },
    );
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw ScheduleApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return SearchTeachersResponse.fromJson(body);
  }

  Future<ScheduleResponse> getTeacherSchedule({
    required String teacher,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/schedule/teacher/$teacher');

    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw ScheduleApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return ScheduleResponse.fromJson(body);
  }

  Future<ScheduleResponse> getClassroomSchedule({
    required String classroom,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/schedule/classroom/$classroom');

    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw ScheduleApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return ScheduleResponse.fromJson(body);
  }

  Future<Map<String, String>> _getRequestHeaders() async {
    return <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: ContentType.json.value,
    };
  }
}

/// Расширение для [http.Response], которое позволяет получить тело ответа
/// в виде `Map<String, dynamic>`. Если тело ответа не может быть преобразовано
/// в `Map<String, dynamic>`, то будет сгенерировано исключение
/// [ScheduleApiMalformedResponse].
extension on http.Response {
  Map<String, dynamic> json() {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ScheduleApiMalformedResponse(error: error),
        stackTrace,
      );
    }
  }
}
