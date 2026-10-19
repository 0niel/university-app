import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:http/http.dart' as http;
import 'package:schedule_fetcher/source_transport.dart';

export 'package:schedule_fetcher/source_selection.dart';
export 'package:schedule_fetcher/source_transport.dart';

class RetryingSourceClient {
  RetryingSourceClient({
    required this.httpClient,
    this.authorization,
    RetryDelay? delay,
    RetryLog? log,
    UtcClock? clock,
    this.maxAttempts = 3,
    this.baseRetryDelay = const Duration(seconds: 2),
    this.maxRetryDelay = const Duration(minutes: 2),
  }) : onRetryLog = log,
       _onDelay = delay ?? Future<void>.delayed,
       _onClock = clock ?? (() => DateTime.now().toUtc()) {
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
  final RetryDelay _onDelay;
  final RetryLog? onRetryLog;
  final UtcClock _onClock;
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
              now: _onClock(),
              maximum: maxRetryDelay,
            );
      final retryDelay = _boundedDelay(requested ?? fallback, maxRetryDelay);
      onRetryLog?.call(
        'Retry $label attempt=${attempt + 1} '
        'after ${retryDelay.inSeconds}s',
      );
      await _onDelay(retryDelay);
    }
    throw StateError('$label retry loop ended unexpectedly');
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
