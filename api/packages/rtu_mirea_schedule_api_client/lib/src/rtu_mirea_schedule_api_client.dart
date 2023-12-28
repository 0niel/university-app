import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rtu_mirea_schedule_api_client/rtu_mirea_schedule_api_client.dart';

class RtuMireaScheduleApiMalformedResponse implements Exception {
  const RtuMireaScheduleApiMalformedResponse({required this.error});

  final Object error;
}

class RtuMireaScheduleApiRequestFailure implements Exception {
  const RtuMireaScheduleApiRequestFailure({
    required this.statusCode,
    required this.body,
  });

  final int statusCode;

  final Map<String, dynamic> body;
}

/// {@template rtu_mirea_schedule_api_client}
/// A client for the RTU MIREA schedule API service that
/// is powered by the `schedule-of.mirea.ru` website. This client
/// is used to search for groups, teachers, and rooms, and to get
/// the schedule in the iCal format.
/// {@endtemplate}
class RtuMireaScheduleApiClient {
  /// {@macro rtu_mirea_schedule_api_client}
  RtuMireaScheduleApiClient({
    http.Client? httpClient,
  }) : this._(
          baseUrl: 'https://schedule-of.mirea.ru',
          httpClient: httpClient,
        );

  RtuMireaScheduleApiClient._({
    required String baseUrl,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _httpClient = httpClient ?? http.Client();

  final String _baseUrl;
  final http.Client _httpClient;

  /// Returns the [SearchData] for the specified query.
  Future<SearchData> search({
    required String query,
    int limit = 15,
  }) async {
    final uri = Uri.parse('$_baseUrl/schedule/api/search').replace(
      queryParameters: <String, String>{
        'limit': '$limit',
        'match': query,
      },
    );
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw RtuMireaScheduleApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return SearchData.fromJson(body);
  }

  /// Returns the schedule in the iCal format for the specified schedule target.
  /// The schedule target can be a group, a teacher, or a room.
  Future<String> getIcalContent({
    required int itemId,
    required int scheduleTargetId,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/schedule/api/ical/${_getApiPathNameByScheduleTarget(scheduleTargetId)}/$itemId?includeMeta=true',
    );

    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    final body = response.body;

    if (response.statusCode != HttpStatus.ok) {
      throw RtuMireaScheduleApiRequestFailure(
        body: {},
        statusCode: response.statusCode,
      );
    }

    return body;
  }

  String _getApiPathNameByScheduleTarget(int scheduleTarget) {
    switch (scheduleTarget) {
      case 1:
        return 'Group';
      case 2:
        return 'Teacher';
      case 3:
        return 'Auditorium';
      default:
        throw ArgumentError.value(
          scheduleTarget,
          'scheduleTarget',
          'The schedule target must be in range from 1 to 3.',
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

extension on http.Response {
  Map<String, dynamic> json() {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        RtuMireaScheduleApiMalformedResponse(error: error),
        stackTrace,
      );
    }
  }
}
