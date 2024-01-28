import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:university_app_server_api/src/models/models.dart';

class ApiMalformedResponse implements Exception {
  const ApiMalformedResponse({required this.error});

  final Object error;
}

class ApiRequestFailure implements Exception {
  const ApiRequestFailure({
    required this.statusCode,
    required this.body,
  });

  final int statusCode;

  final Map<String, dynamic> body;
}

class ApiClient {
  ApiClient({
    http.Client? httpClient,
  }) : this._(
          baseUrl: 'https://app-api.mirea.ninja',
          httpClient: httpClient,
        );

  ApiClient.localhost({
    http.Client? httpClient,
  }) : this._(
          baseUrl: 'http://localhost:8080',
          httpClient: httpClient,
        );

  /// Creates an [ApiClient] that connects to localhost on Android emulator.
  ApiClient.localhostFromEmulator({
    http.Client? httpClient,
  }) : this._(
          baseUrl: 'http://10.0.2.2:8080',
          httpClient: httpClient,
        );

  ApiClient._({
    required String baseUrl,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _httpClient = httpClient ?? http.Client();

  final String _baseUrl;
  final http.Client _httpClient;

  Future<NewsFeedResponse> getNews({
    int? limit,
    int? offset,
    String? category,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/news/').replace(
      queryParameters: <String, String>{
        if (limit != null) 'limit': '$limit',
        if (offset != null) 'offset': '$offset',
        if (category != null) 'category': category,
      },
    );
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw ApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return NewsFeedResponse.fromJson(body);
  }

  Future<NewsFeedResponse> getAds({
    int? limit,
    int? offset,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/news/ads').replace(
      queryParameters: <String, String>{
        if (limit != null) 'limit': '$limit',
        if (offset != null) 'offset': '$offset',
      },
    );
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw ApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return NewsFeedResponse.fromJson(body);
  }

  Future<CategoriesResponse> getCategories() async {
    final uri = Uri.parse('$_baseUrl/api/v1/news/categories');
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw ApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return CategoriesResponse.fromJson(body);
  }

  Future<ContributorsResponse> getContributors() async {
    final uri = Uri.parse('$_baseUrl/api/v1/community/contributors');

    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw ApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return ContributorsResponse.fromJson(body);
  }

  Future<SponsorsResponse> getSponsors() async {
    final uri = Uri.parse('$_baseUrl/api/v1/community/sponsors');

    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw ApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return SponsorsResponse.fromJson(body);
  }

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
      throw ApiRequestFailure(
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
      throw ApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return SearchGroupsResponse.fromJson(body);
  }

  Future<SearchClassroomsResponse> searchClassrooms({
    String query = '',
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/schedule/search/classrooms').replace(
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
      throw ApiRequestFailure(
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
      throw ApiRequestFailure(
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
      throw ApiRequestFailure(
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
      throw ApiRequestFailure(
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
/// [ApiMalformedResponse].
extension on http.Response {
  Map<String, dynamic> json() {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ApiMalformedResponse(error: error),
        stackTrace,
      );
    }
  }
}
