import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:schedule_fetcher/retrying_source_client.dart';

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
