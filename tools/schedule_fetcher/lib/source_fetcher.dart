import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

typedef RetryDelay = Future<void> Function(Duration duration);
typedef RetryLog = void Function(String message);
typedef UtcClock = DateTime Function();

final officialScheduleUri = Uri.https('schedule-of.mirea.ru');

class ScheduleSourceSelection {
  const ScheduleSourceSelection({
    required this.baseUrl,
    required this.usesRelay,
  });

  final Uri baseUrl;
  final bool usesRelay;
}

Future<ScheduleSourceSelection> selectScheduleSource({
  required http.Client httpClient,
  Uri? relayBaseUrl,
  String? relayAuthorization,
  Duration timeout = const Duration(seconds: 10),
}) async {
  Future<void> probe(Uri baseUrl, String? authorization) async {
    if (baseUrl.scheme != 'https' ||
        baseUrl.host.isEmpty ||
        baseUrl.port != 443 ||
        baseUrl.userInfo.isNotEmpty ||
        baseUrl.hasQuery ||
        baseUrl.hasFragment ||
        (baseUrl.path.isNotEmpty && baseUrl.path != '/')) {
      throw const FormatException('Invalid schedule source origin');
    }

    Future<http.Response> get(Uri uri, String accept) async {
      final request = http.Request('GET', uri)..followRedirects = false;
      request.headers[HttpHeaders.acceptHeader] = accept;
      if (authorization != null && authorization.isNotEmpty) {
        request.headers[HttpHeaders.authorizationHeader] = authorization;
      }
      final response = await httpClient
          .send(request)
          .then(http.Response.fromStream)
          .timeout(timeout);
      if (response.statusCode != HttpStatus.ok) {
        throw FormatException('Schedule probe returned ${response.statusCode}');
      }
      return response;
    }

    final search = await get(
      baseUrl.resolve('/schedule/api/search'),
      'application/json',
    );
    final decoded = jsonDecode(search.body);
    final data = decoded is Map<String, Object?> ? decoded['data'] : null;
    if (data is! List<Object?> || data.isEmpty) {
      throw const FormatException('Schedule probe has no targets');
    }
    Uri? calendar;
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
          (uri.host != baseUrl.host && uri.host != officialScheduleUri.host) ||
          !uri.path.startsWith('/schedule/api/ical/')) {
        throw const FormatException(
          'Schedule probe has an invalid calendar URL',
        );
      }
      calendar = baseUrl.replace(path: uri.path, query: uri.query);
      break;
    }
    if (calendar == null) {
      throw const FormatException('Schedule probe has no calendar feed');
    }
    final response = await get(calendar, 'text/calendar');
    final content = response.body.replaceFirst(RegExp(r'^\uFEFF'), '').trim();
    if (!RegExp(r'^BEGIN:VCALENDAR\r?\n').hasMatch(content) ||
        !RegExp(r'^VERSION:2\.0\r?$', multiLine: true).hasMatch(content) ||
        !RegExp(r'\r?\nEND:VCALENDAR$').hasMatch(content)) {
      throw const FormatException(
        'Schedule probe returned an invalid calendar',
      );
    }
  }

  try {
    await probe(officialScheduleUri, null);
    return ScheduleSourceSelection(
      baseUrl: officialScheduleUri,
      usesRelay: false,
    );
  } on Exception {
    if (relayBaseUrl == null || relayBaseUrl.host == officialScheduleUri.host) {
      throw StateError(
        'Official schedule source is unavailable; no relay configured',
      );
    }
  }
  try {
    await probe(relayBaseUrl, relayAuthorization);
    return ScheduleSourceSelection(baseUrl: relayBaseUrl, usesRelay: true);
  } on Exception {
    throw StateError(
      'Neither official schedule source nor relay passed health checks',
    );
  }
}

class RetryingSourceClient {
  RetryingSourceClient({
    required this.httpClient,
    this.authorization,
    RetryDelay? delay,
    this.log,
    UtcClock? clock,
    this.maxAttempts = 3,
    this.baseRetryDelay = const Duration(seconds: 2),
    this.maxRetryDelay = const Duration(minutes: 2),
  }) : _delay = delay ?? Future<void>.delayed,
       _clock = clock ?? (() => DateTime.now().toUtc()) {
    if (maxAttempts < 1) {
      throw ArgumentError.value(maxAttempts, 'maxAttempts');
    }
    if (baseRetryDelay.isNegative) {
      throw ArgumentError.value(baseRetryDelay, 'baseRetryDelay');
    }
    if (maxRetryDelay <= Duration.zero) {
      throw ArgumentError.value(maxRetryDelay, 'maxRetryDelay');
    }
  }

  final http.Client httpClient;
  final String? authorization;
  final RetryDelay _delay;
  final RetryLog? log;
  final UtcClock _clock;
  final int maxAttempts;
  final Duration baseRetryDelay;
  final Duration maxRetryDelay;

  Future<http.Response> get(
    Uri uri, {
    required String accept,
    required Duration timeout,
    required String label,
  }) async {
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      http.Response? response;
      try {
        final useAuthorization =
            authorization != null &&
            authorization!.isNotEmpty &&
            uri.host != officialScheduleUri.host;
        final request = http.Request('GET', uri)
          ..followRedirects = !useAuthorization
          ..headers.addAll({
            HttpHeaders.acceptHeader: accept,
            if (useAuthorization)
              HttpHeaders.authorizationHeader: authorization!,
            HttpHeaders.userAgentHeader: 'university-app-schedule-fetcher/0.1',
          });
        response = await httpClient
            .send(request)
            .then(http.Response.fromStream)
            .timeout(timeout);
        if (!isRetryableHttpStatus(response.statusCode) ||
            attempt == maxAttempts) {
          return response;
        }
      } on Object catch (error) {
        if (attempt == maxAttempts || !isRetryableHttpError(error)) rethrow;
      }

      final fallback = Duration(
        microseconds: baseRetryDelay.inMicroseconds * attempt,
      );
      final requested = response == null
          ? null
          : retryDelayFromResponse(
              response,
              now: _clock(),
              maximum: maxRetryDelay,
            );
      final retryDelay = _boundedDelay(requested ?? fallback, maxRetryDelay);
      log?.call(
        'Retry $label attempt=${attempt + 1} '
        'after ${retryDelay.inSeconds}s',
      );
      await _delay(retryDelay);
    }
    throw StateError('$label retry loop ended unexpectedly');
  }
}

class ScheduleSearchPager {
  const ScheduleSearchPager(this._sourceClient, this._scheduleBaseUrl);

  final RetryingSourceClient _sourceClient;
  final Uri _scheduleBaseUrl;

  Stream<Map<String, Object?>> fetch({String? match}) async* {
    final seenPageTokens = <String>{};
    String? nextPageToken;
    do {
      final query = <String, String>{};
      if (nextPageToken != null) query['pageToken'] = nextPageToken;
      if (match != null && match.trim().isNotEmpty) {
        query['match'] = match.trim();
      }

      final uri = _scheduleBaseUrl
          .resolve('/schedule/api/search')
          .replace(queryParameters: query.isEmpty ? null : query);
      final response = await _sourceClient.get(
        uri,
        accept: 'application/json',
        timeout: const Duration(seconds: 45),
        label: 'schedule search',
      );
      if (response.statusCode != HttpStatus.ok) {
        throw StateError(
          'Schedule search failed: ${response.statusCode} ${response.body}',
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, Object?>) {
        throw const FormatException(
          'Schedule search response is not an object',
        );
      }
      final rawNextPageToken = decoded['nextPageToken'];
      if (rawNextPageToken != null && rawNextPageToken is! String) {
        throw const FormatException('Schedule search page token is invalid');
      }
      final token = (rawNextPageToken as String?)?.trim();
      nextPageToken = token == null || token.isEmpty ? null : token;
      if (nextPageToken != null && !seenPageTokens.add(nextPageToken)) {
        throw StateError(
          'Schedule search pagination token repeated: $nextPageToken',
        );
      }

      final data = decoded['data'];
      if (data != null && data is! List<Object?>) {
        throw const FormatException('Schedule search data is not a list');
      }
      for (final item in (data as List<Object?>? ?? const [])) {
        if (item is Map<String, Object?>) yield item;
      }
    } while (nextPageToken != null);
  }
}

Duration? retryDelayFromResponse(
  http.Response response, {
  required DateTime now,
  required Duration maximum,
}) {
  if (maximum <= Duration.zero) {
    throw ArgumentError.value(maximum, 'maximum');
  }
  final candidates = <Duration>[];
  final retryAfterHeader = response.headers[HttpHeaders.retryAfterHeader];
  final headerDelay = retryAfterHeader == null
      ? null
      : _parseRetryAfterHeader(retryAfterHeader, now.toUtc());
  if (headerDelay != null) candidates.add(headerDelay);
  final bodyDelay = _parseRetryAfterBody(response.body);
  if (bodyDelay != null) candidates.add(bodyDelay);
  if (candidates.isEmpty) return null;
  final requested = candidates.reduce(
    (left, right) => left > right ? left : right,
  );
  return _boundedDelay(requested, maximum);
}

bool isRetryableHttpError(Object error) {
  return error is http.ClientException ||
      error is SocketException ||
      error is TimeoutException;
}

bool isRetryableHttpStatus(int statusCode) {
  return statusCode == HttpStatus.tooManyRequests || statusCode >= 500;
}

Duration _boundedDelay(Duration requested, Duration maximum) {
  if (requested.isNegative) return Duration.zero;
  return requested > maximum ? maximum : requested;
}

Duration? _parseRetryAfterHeader(String value, DateTime now) {
  final seconds = int.tryParse(value.trim());
  if (seconds != null) {
    if (seconds < 0) return null;
    return Duration(seconds: seconds);
  }
  try {
    final retryAt = HttpDate.parse(value).toUtc();
    final delay = retryAt.difference(now);
    return delay.isNegative ? null : delay;
  } on FormatException {
    return null;
  } on HttpException {
    return null;
  }
}

Duration? _parseRetryAfterBody(String body) {
  if (body.trim().isEmpty) return null;
  try {
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, Object?>) return null;
    final raw = decoded['retry_after'];
    final seconds = switch (raw) {
      final num value when value.isFinite => value.toDouble(),
      final String value => double.tryParse(value.trim()),
      _ => null,
    };
    if (seconds == null || !seconds.isFinite || seconds < 0) return null;
    return Duration(seconds: math.max(0, seconds.ceil()));
  } on FormatException {
    return null;
  }
}
