import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:university_app_server_api/api.dart';

import 'package:university_app_server_api/src/data/news/rtu_mirea_news_data_source/models/models.dart';

class RtuMireaNewsDataSourceMalformedResponse implements Exception {
  const RtuMireaNewsDataSourceMalformedResponse({required this.error});

  final Object error;
}

class RtuMireaNewsDataSourceRequestFailure implements Exception {
  const RtuMireaNewsDataSourceRequestFailure({
    required this.statusCode,
    required this.body,
  });

  final int statusCode;

  final String body;
}

class RtuMireNewsDataSource implements NewsDataSource {
  RtuMireNewsDataSource({
    http.Client? httpClient,
  }) : this._(
          baseUrl: 'https://mirea.ru/api/oCoGUGuMhQzPEDJYF6Qy.php',
          httpClient: httpClient,
        );

  RtuMireNewsDataSource._({
    required String baseUrl,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _httpClient = httpClient ?? http.Client();

  final String _baseUrl;
  final http.Client _httpClient;

  @override
  Future<List<Article>> getAds({int limit = 20, int offset = 0}) {
    return _fetchNews(
      limit: limit,
      offset: offset,
      requestAds: true,
    );
  }

  @override
  Future<List<String>> getCategories() async {
    final uri = Uri.parse('$_baseUrl?method=getNewsTags');

    final response = await _httpClient.get(uri, headers: _getRequestHeaders());

    if (response.statusCode != HttpStatus.ok) {
      throw RtuMireaNewsDataSourceRequestFailure(
        body: response.body,
        statusCode: response.statusCode,
      );
    }

    final responseJson = response.json();

    try {
      final tagsResult = responseJson['result'] as List<dynamic>;

      final tags =
          tagsResult.cast<Map<String, dynamic>>().where((element) => int.parse(element['CNT'] as String) > 3).toList()
            ..sort(
              (a, b) => int.parse(b['CNT'] as String).compareTo(int.parse(a['CNT'] as String)),
            );

      return tags.map((e) => e['NAME'] as String).toList();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        RtuMireaNewsDataSourceMalformedResponse(error: error),
        stackTrace,
      );
    }
  }

  @override
  Future<List<Article>> getNews({
    int limit = 20,
    int offset = 0,
    String? category,
  }) {
    return _fetchNews(
      limit: limit,
      offset: offset,
      tag: category,
    );
  }

  Future<List<Article>> _fetchNews({
    int limit = 20,
    int offset = 0,
    String? tag,
    bool requestAds = false,
  }) async {
    final page = offset ~/ limit + 1;
    final pageSize = limit;

    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: <String, String>{
        'method': !requestAds ? 'getNews' : 'getAds',
        'nPageSize': pageSize.toString(),
        'iNumPage': page.toString(),
        if (tag != null) 'tag': tag,
      },
    );

    final response = await _httpClient.get(
      uri,
      headers: _getRequestHeaders(),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw RtuMireaNewsDataSourceRequestFailure(
        body: response.body,
        statusCode: response.statusCode,
      );
    }

    try {
      final body = response.json();
      final rawNews = body['result'] as List<dynamic>;

      return List<Article>.from(
        rawNews.map((rawNewsItem) {
          return RtuMireaNewsItem.fromJson(rawNewsItem as Map<String, dynamic>).toArticle();
        }),
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        RtuMireaNewsDataSourceMalformedResponse(error: error),
        stackTrace,
      );
    }
  }
}

Map<String, String> _getRequestHeaders() {
  return <String, String>{
    HttpHeaders.contentTypeHeader: ContentType.json.value,
    HttpHeaders.acceptHeader: ContentType.json.value,
  };
}

extension on http.Response {
  Map<String, dynamic> json() {
    try {
      final decodedBody = utf8.decode(bodyBytes);
      return jsonDecode(decodedBody) as Map<String, dynamic>;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        RtuMireaNewsDataSourceMalformedResponse(error: error),
        stackTrace,
      );
    }
  }
}
