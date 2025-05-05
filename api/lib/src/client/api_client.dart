import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:university_app_server_api/client.dart';

/// {@template api_malformed_response}
/// An exception that is thrown when the API response is malformed. For example,
/// when the response body cannot be decoded as JSON.
/// {@endtemplate}
class ApiMalformedResponse implements Exception {
  /// {@macro api_malformed_response}
  const ApiMalformedResponse({required this.error});

  /// The error encountered while decoding the response.
  final Object error;
}

/// {@template api_request_failure}
/// An exception that is thrown when the API request fails.
/// {@endtemplate}
class ApiRequestFailure implements Exception {
  /// {@macro api_request_failure}
  const ApiRequestFailure({
    required this.statusCode,
    required this.body,
  });

  /// The status code of the response.
  final int statusCode;

  /// The body of the response.
  final Map<String, dynamic> body;
}

/// Signature for the authentication token provider.
typedef TokenProvider = Future<String?> Function();

class ApiClient {
  ApiClient({
    required TokenProvider tokenProvider,
    http.Client? httpClient,
  }) : this._(
          baseUrl: 'https://app-api.mirea.ninja',
          httpClient: httpClient,
          tokenProvider: tokenProvider,
        );

  ApiClient.localhost({
    required TokenProvider tokenProvider,
    http.Client? httpClient,
  }) : this._(
          baseUrl: 'http://localhost:8080',
          httpClient: httpClient,
          tokenProvider: tokenProvider,
        );

  /// Creates an [ApiClient] that connects to localhost on Android emulator.
  ApiClient.localhostFromEmulator({
    required TokenProvider tokenProvider,
    http.Client? httpClient,
  }) : this._(
          baseUrl: 'http://10.0.2.2:8080',
          httpClient: httpClient,
          tokenProvider: tokenProvider,
        );

  ApiClient._({
    required TokenProvider tokenProvider,
    required String baseUrl,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _httpClient = httpClient ?? http.Client(),
        _tokenProvider = tokenProvider;

  final String _baseUrl;
  final http.Client _httpClient;
  final TokenProvider _tokenProvider;

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

  // Lost and Found API methods

  /// Fetches a list of lost and found items with optional filtering.
  Future<LostFoundItemsResponse> getLostFoundItems({
    LostFoundItemStatus? status,
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, String>{
      if (limit != null) 'limit': '$limit',
      if (offset != null) 'offset': '$offset',
      if (status != null) 'status': status.toString().split('.').last,
    };

    final uri = Uri.parse('$_baseUrl/api/v1/lost-found/items').replace(
      queryParameters: queryParams,
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

    return LostFoundItemsResponse.fromJson(body);
  }

  /// Gets a specific lost or found item by its ID.
  Future<LostFoundItem> getLostFoundItem({
    required String itemId,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/lost-found/items/$itemId');

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

    return LostFoundItem.fromJson(body);
  }

  /// Creates a new lost or found item.
  Future<LostFoundItem> createLostFoundItem({
    required LostFoundItem item,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/lost-found/items');

    final response = await _httpClient.post(
      uri,
      headers: await _getRequestHeaders(),
      body: jsonEncode(item.toJson()),
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.created) {
      throw ApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return LostFoundItem.fromJson(body);
  }

  /// Updates an existing lost or found item.
  Future<LostFoundItem> updateLostFoundItem({
    required String itemId,
    required LostFoundItem item,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/lost-found/items/$itemId');

    final response = await _httpClient.put(
      uri,
      headers: await _getRequestHeaders(),
      body: jsonEncode(item.toJson()),
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw ApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return LostFoundItem.fromJson(body);
  }

  /// Updates just the status of a lost or found item.
  Future<LostFoundItem> updateLostFoundItemStatus({
    required String itemId,
    required LostFoundItemStatus status,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/lost-found/items/$itemId/status');

    final response = await _httpClient.patch(
      uri,
      headers: await _getRequestHeaders(),
      body: jsonEncode({'status': status.toString().split('.').last}),
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw ApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return LostFoundItem.fromJson(body);
  }

  /// Deletes a lost or found item.
  Future<void> deleteLostFoundItem({
    required String itemId,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/lost-found/items/$itemId');

    final response = await _httpClient.delete(
      uri,
      headers: await _getRequestHeaders(),
    );

    if (response.statusCode != HttpStatus.noContent) {
      final body = response.json();
      throw ApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }
  }

  /// Searches for lost and found items.
  Future<LostFoundItemsResponse> searchLostFoundItems({
    required String query,
    LostFoundItemStatus? status,
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, String>{
      'query': query,
      if (limit != null) 'limit': '$limit',
      if (offset != null) 'offset': '$offset',
      if (status != null) 'status': status.toString().split('.').last,
    };

    final uri = Uri.parse('$_baseUrl/api/v1/lost-found/search').replace(
      queryParameters: queryParams,
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

    return LostFoundItemsResponse.fromJson(body);
  }

  /// Gets items created by a specific user.
  Future<LostFoundItemsResponse> getUserLostFoundItems({
    required String authorId,
    LostFoundItemStatus? status,
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, String>{
      if (limit != null) 'limit': '$limit',
      if (offset != null) 'offset': '$offset',
      if (status != null) 'status': status.toString().split('.').last,
    };

    final uri = Uri.parse('$_baseUrl/api/v1/lost-found/user/$authorId').replace(
      queryParameters: queryParams,
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

    return LostFoundItemsResponse.fromJson(body);
  }

  /// Gets the count of lost and found items.
  Future<int> getLostFoundItemsCount({
    LostFoundItemStatus? status,
    String? authorId,
    String? searchQuery,
  }) async {
    final queryParams = <String, String>{
      if (status != null) 'status': status.toString().split('.').last,
      if (authorId != null) 'author_id': authorId,
      if (searchQuery != null) 'query': searchQuery,
    };

    final uri = Uri.parse('$_baseUrl/api/v1/lost-found/count').replace(
      queryParameters: queryParams,
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

    return body['count'] as int;
  }

  Future<SplashVideoResponse> getSplashVideo() async {
    final uri = Uri.parse('$_baseUrl/api/v1/splash-video');

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

    return SplashVideoResponse.fromJson(body);
  }

  Future<Map<String, String>> _getRequestHeaders() async {
    final token = await _tokenProvider();
    return <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: ContentType.json.value,
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
    };
  }
}

/// Extension on [http.Response] to decode the response body as JSON.
/// Throws [ApiMalformedResponse] if the response body cannot be decoded.
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
