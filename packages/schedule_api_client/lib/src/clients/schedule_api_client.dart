import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:schedule_api_client/src/models/groups_response/groups_response.dart';
import 'package:schedule_api_client/src/models/schedule_response/schedule_response.dart';

/// {@template schedule_api_malformed_response}
/// Исключение, генерируемое при возникновении проблемы во время обработки тела
/// ответ.
/// {@endtemplate}
class ScheduleApiMalformedResponse implements Exception {
  /// {@macro schedule_api_malformed_response}
  const ScheduleApiMalformedResponse({required this.error});

  /// Связанная ошибка.
  final Object error;
}

/// {@template schedule_api_request_failure}
/// Исключение, генерируемое при ошибке во время http-запроса.
/// {@endtemplate}
class ScheduleApiRequestFailure implements Exception {
  /// {@macro schedule_api_request_failure}
  const ScheduleApiRequestFailure({
    required this.statusCode,
    required this.body,
  });

  /// Связанный http-статус код.
  final int statusCode;

  /// Связанное тело ответа.
  final Map<String, dynamic> body;
}

/// Dart API клиент для Schedule Mirea Ninja API.
class ScheduleApiClient {
  /// Создает экземпляр [ScheduleApiClient] для интеграции
  /// с удаленным API.
  ScheduleApiClient({
    http.Client? httpClient,
  }) : this._(
          baseUrl: 'https://schedule.mirea.ninja',
          httpClient: httpClient,
        );

  /// Создает экземпляр [ScheduleApiClient] для интеграции
  /// с локальным API.
  ///
  /// Используется для тестирования.
  ScheduleApiClient.localhost({
    http.Client? httpClient,
  }) : this._(
          baseUrl: 'http://localhost:8080',
          httpClient: httpClient,
        );

  ScheduleApiClient._({
    required String baseUrl,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _httpClient = httpClient ?? http.Client();

  final String _baseUrl;
  final http.Client _httpClient;

  /// GET /api/schedule/groups
  /// Запрос списка групп.
  Future<GroupsResponse> getGroups() async {
    final uri = Uri.parse('$_baseUrl/api/schedule/groups').replace();
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

    return GroupsResponse.fromJson(body);
  }

  /// GET /api/schedule/{group}/full_schedule
  /// Запрос расписания занятий группы.
  Future<ScheduleResponse> getScheduleByGroup({required String group}) async {
    final uri = Uri.parse('$_baseUrl/api/schedule/$group/full_schedule')
        .replace(queryParameters: {'remote': 'true'});
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
