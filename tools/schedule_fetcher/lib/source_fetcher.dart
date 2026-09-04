import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

typedef RetryDelay = Future<void> Function(Duration duration);
typedef RetryLog = void Function(String message);
typedef UtcClock = DateTime Function();

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
        response = await httpClient
            .get(
              uri,
              headers: {
                HttpHeaders.acceptHeader: accept,
                if (authorization != null && authorization!.isNotEmpty)
                  HttpHeaders.authorizationHeader: authorization!,
                HttpHeaders.userAgentHeader:
                    'university-app-schedule-fetcher/0.1',
              },
            )
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
