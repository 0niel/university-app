import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:news_api_client/api_client.dart';

/// {@template schedule_api_malformed_response}
/// Исключение, генерируемое при возникновении проблемы во время обработки тела
/// ответ.
/// {@endtemplate}
class NewsApiMalformedResponse implements Exception {
  /// {@macro schedule_api_malformed_response}
  const NewsApiMalformedResponse({required this.error});

  /// Связанная ошибка.
  final Object error;
}

/// {@template schedule_api_request_failure}
/// Исключение, генерируемое при ошибке во время http-запроса.
/// {@endtemplate}
class NewsApiRequestFailure implements Exception {
  /// {@macro schedule_api_request_failure}
  const NewsApiRequestFailure({
    required this.statusCode,
    required this.body,
  });

  /// Связанный http-статус код.
  final int statusCode;

  /// Связанное тело ответа.
  final Map<String, dynamic> body;
}

/// Dart API клиент для Schedule Mirea Ninja API.
class NewsApiClient {
  /// Создает экземпляр [NewsApiClient] для интеграции
  /// с удаленным API.
  NewsApiClient({
    http.Client? httpClient,
  }) : this._(
          baseUrl: 'https://mirea.ru/api/oCoGUGuMhQzPEDJYF6Qy.php',
          httpClient: httpClient,
        );

  /// Создает экземпляр [NewsApiClient] для интеграции
  /// с локальным API.
  ///
  /// Используется для тестирования.
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

  /// Запрос на получения списка новостей.
  ///
  /// Доступные параметры:
  /// * [page] - номер страницы. Нумерация начинается с 1.
  /// * [pageSize] - количество новостей на странице.
  /// * [tag] - тег новости. Если не указан, то будут возвращены все новости.
  /// * [isImportant] - если `true`, то будут возвращены новости из раздела
  /// "Важное", иначе - новости из раздела "Новости".
  Future<List<NewsResponse>> getNews({
    int? page,
    int? pageSize,
    String? tag,
    bool isImportant = false,
  }) async {
    final methodUri = !isImportant ? '?method=getNews' : '?method=getAds';

    final uri = Uri.parse('$_baseUrl$methodUri').replace(
      queryParameters: <String, String>{
        if (page != null) 'iNumPage': page.toString(),
        if (pageSize != null) 'nPageSize': pageSize.toString(),
        if (tag != null) 'tag': tag,
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

    try {
      final rawNews = body['result'] as List<Map<String, dynamic>>;

      return List<NewsResponse>.from(
        rawNews.map((rawNewsItem) {
          return NewsResponse.fromJson(rawNewsItem);
        }),
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        NewsApiMalformedResponse(error: error),
        stackTrace,
      );
    }
  }

  /// Запрос на получение списка тегов новостей.
  ///
  /// Доступные параметры:
  /// * [tagUsageCount] - количество использований тега. Если не указано, то
  /// будут возвращены все теги.
  Future<List<String>> getTags({
    int tagUsageCount = 3,
  }) async {
    final uri = Uri.parse('$_baseUrl?method=getNewsTags');
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

    try {
      final rawTags = body['result'] as List<Map<String, dynamic>>;

      return List<String>.from(
        // Используем только те теги, которые были использованы более 3 раз.
        // Ключ 'CNT' - количество использований тега.
        rawTags
            .where(
                (rawTag) => int.parse(rawTag['CNT'] as String) > tagUsageCount,)
            .map((rawTag) => rawTag['NAME'] as String),
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        NewsApiMalformedResponse(error: error),
        stackTrace,
      );
    }
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
