import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:university_app_server_api/src/models/models.dart';

class NewsApiMalformedResponse implements Exception {
  const NewsApiMalformedResponse({required this.error});

  final Object error;
}

class NewsApiRequestFailure implements Exception {
  const NewsApiRequestFailure({
    required this.statusCode,
    required this.body,
  });

  final int statusCode;

  final Map<String, dynamic> body;
}

class NewsApiClient {
  NewsApiClient({
    http.Client? httpClient,
  }) : this._(
          baseUrl: 'https://example-api.a.run.app',
          httpClient: httpClient,
        );

  NewsApiClient.localhost({
    http.Client? httpClient,
  }) : this._(
          baseUrl: 'http://localhost:8080',
          httpClient: httpClient,
        );

  NewsApiClient._({
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
      throw NewsApiRequestFailure(
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
      throw NewsApiRequestFailure(
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
      throw NewsApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return CategoriesResponse.fromJson(body);
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
/// [NewsApiMalformedResponse].
extension on http.Response {
  Map<String, dynamic> json() {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        NewsApiMalformedResponse(error: error),
        stackTrace,
      );
    }
  }
}
