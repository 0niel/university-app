import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:schedule_api_client/src/models/groups_response/groups_response.dart';
import 'package:schedule_api_client/src/models/schedule_response/schedule_response.dart';

/// Сигнатура функции, которая возвращает токен для авторизации.
///
/// Пример использования:
/// ```dart
/// final apiClient = LksApiClient(
///  tokenProvider: () async {
///   final token = await _authRepository.getToken();
///    return token;
///  },
///);
/// ```
typedef TokenProvider = Future<String?> Function();

/// {@template schedule_api_malformed_response}
/// Исключение, генерируемое при возникновении проблемы во время обработки тела
/// ответ.
/// {@endtemplate}
class LksApiMalformedResponse implements Exception {
  /// {@macro schedule_api_malformed_response}
  const LksApiMalformedResponse({required this.error});

  /// Связанная ошибка.
  final Object error;
}

/// {@template schedule_api_request_failure}
/// Исключение, генерируемое при ошибке во время http-запроса.
/// {@endtemplate}
class LksApiRequestFailure implements Exception {
  /// {@macro schedule_api_request_failure}
  const LksApiRequestFailure({
    required this.statusCode,
    required this.body,
  });

  /// Связанный http-статус код.
  final int statusCode;

  /// Связанное тело ответа.
  final Map<String, dynamic> body;
}

/// Dart API клиент для Schedule Mirea Ninja API.
class LksApiClient {
  /// Создает экземпляр [LksApiClient] для интеграции
  /// с удаленным API.
  LksApiClient({
    required TokenProvider tokenProvider,
    http.Client? httpClient,
  }) : this._(
          baseUrl: 'https://auth-app.mirea.ru',
          httpClient: httpClient,
          tokenProvider: tokenProvider,
        );

  LksApiClient._({
    required String baseUrl,
    required TokenProvider tokenProvider,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _tokenProvider = tokenProvider,
        _httpClient = httpClient ?? http.Client();

  final String _baseUrl;
  final http.Client _httpClient;
  final TokenProvider _tokenProvider;

  /// GET /?action=getData&url=https://lk.mirea.ru/profile/
  /// Запрос списка групп.
  Future<GroupsResponse> getProfile() async {
    final uri = Uri.parse('$_baseUrl/api/schedule/groups').replace();
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );
    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw LksApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return GroupsResponse.fromJson(body);
  }

  Future<Map<String, String>> _getRequestHeaders() async {
    final token = await _tokenProvider();
    return <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: ContentType.json.value,
      if (token != null) HttpHeaders.authorizationHeader: token,
    };
  }
}

/// Расширение для [http.Response], которое позволяет получить тело ответа
/// в виде `Map<String, dynamic>`. Если тело ответа не может быть преобразовано
/// в `Map<String, dynamic>`, то будет сгенерировано исключение
/// [LksApiMalformedResponse].
extension on http.Response {
  Map<String, dynamic> json() {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        LksApiMalformedResponse(error: error),
        stackTrace,
      );
    }
  }
}
