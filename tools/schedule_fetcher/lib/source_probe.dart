import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:schedule_fetcher/source_probe_failure.dart';
import 'package:schedule_fetcher/source_transport.dart';

class ScheduleSourceProbe {
  const ScheduleSourceProbe({
    required this.httpClient,
    required this.timeout,
    required this.clock,
  });

  final http.Client httpClient;
  final Duration timeout;
  final UtcClock clock;

  Future<void> check(
    Uri baseUrl,
    String? authorization, {
    DateTime? deadline,
  }) async {
    if (baseUrl.scheme != 'https' ||
        baseUrl.host.isEmpty ||
        baseUrl.port != 443 ||
        baseUrl.userInfo.isNotEmpty ||
        baseUrl.hasQuery ||
        baseUrl.hasFragment ||
        (baseUrl.path.isNotEmpty && baseUrl.path != '/')) {
      throw const ScheduleProbeFailure(
        stage: ScheduleProbeStage.origin,
        category: ScheduleProbeCategory.invalidResponse,
      );
    }

    final search = await _get(
      baseUrl.resolve('/schedule/api/search'),
      accept: 'application/json',
      stage: ScheduleProbeStage.search,
      authorization: authorization,
      deadline: deadline,
    );
    final calendar = _calendarUri(baseUrl, search);
    final response = await _get(
      calendar,
      accept: 'text/calendar',
      stage: ScheduleProbeStage.calendar,
      authorization: authorization,
      deadline: deadline,
    );
    _validateCalendar(response);
  }

  Future<http.Response> _get(
    Uri uri, {
    required String accept,
    required ScheduleProbeStage stage,
    required String? authorization,
    required DateTime? deadline,
  }) async {
    try {
      final remaining = deadline?.difference(clock());
      if (remaining != null && remaining <= Duration.zero) {
        throw TimeoutException('Schedule probe deadline reached');
      }
      final requestTimeout = remaining != null && remaining < timeout
          ? remaining
          : timeout;
      final request = http.Request('GET', uri)..followRedirects = false;
      request.headers[HttpHeaders.acceptHeader] = accept;
      if (authorization != null && authorization.isNotEmpty) {
        request.headers[HttpHeaders.authorizationHeader] = authorization;
      }
      final response = await httpClient
          .send(request)
          .then(http.Response.fromStream)
          .timeout(requestTimeout);
      if (response.statusCode != HttpStatus.ok) {
        throw ScheduleProbeFailure(
          stage: stage,
          category: ScheduleProbeCategory.http,
          status: response.statusCode,
        );
      }
      return response;
    } on ScheduleProbeFailure {
      rethrow;
    } on Exception catch (error) {
      throw ScheduleProbeFailure.fromException(error, stage: stage);
    }
  }

  Uri _calendarUri(Uri baseUrl, http.Response search) {
    try {
      final decoded = jsonDecode(search.body);
      final data = decoded is Map<String, Object?> ? decoded['data'] : null;
      if (data is! List<Object?> || data.isEmpty) {
        throw const FormatException('Schedule probe has no targets');
      }
      for (final target in data) {
        if (target is! Map<String, Object?>) continue;
        final link = target['iCalLink'];
        if (link is! String || link.isEmpty) continue;
        final uri = Uri.tryParse(link);
        if (uri == null ||
            uri.scheme != 'https' ||
            uri.port != 443 ||
            uri.userInfo.isNotEmpty ||
            uri.hasFragment ||
            (uri.host != baseUrl.host &&
                uri.host != officialScheduleUri.host) ||
            !uri.path.startsWith('/schedule/api/ical/')) {
          throw const FormatException(
            'Schedule probe has an invalid calendar URL',
          );
        }
        return baseUrl.replace(path: uri.path, query: uri.query);
      }
      throw const FormatException('Schedule probe has no calendar feed');
    } on Exception catch (error) {
      throw ScheduleProbeFailure.fromException(
        error,
        stage: ScheduleProbeStage.search,
        status: search.statusCode,
      );
    }
  }

  void _validateCalendar(http.Response response) {
    try {
      final content = response.body.replaceFirst(RegExp(r'^\uFEFF'), '').trim();
      if (!RegExp(r'^BEGIN:VCALENDAR\r?\n').hasMatch(content) ||
          !RegExp(r'^VERSION:2\.0\r?$', multiLine: true).hasMatch(content) ||
          !RegExp(r'\r?\nEND:VCALENDAR$').hasMatch(content)) {
        throw const FormatException(
          'Schedule probe returned an invalid calendar',
        );
      }
    } on Exception catch (error) {
      throw ScheduleProbeFailure.fromException(
        error,
        stage: ScheduleProbeStage.calendar,
        status: response.statusCode,
      );
    }
  }
}
