import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:schedule_fetcher/source_fetcher.dart';
import 'package:test/test.dart';

void main() {
  group('RetryingSourceClient', () {
    test('honors Retry-After before retrying', () async {
      var requests = 0;
      final delays = <Duration>[];
      final client = RetryingSourceClient(
        httpClient: MockClient((_) async {
          requests++;
          if (requests == 1) {
            return http.Response(
              'unavailable',
              HttpStatus.serviceUnavailable,
              headers: {HttpHeaders.retryAfterHeader: '7'},
            );
          }
          return http.Response('ok', HttpStatus.ok);
        }),
        delay: (duration) async => delays.add(duration),
      );

      final response = await client.get(
        Uri.https('relay.example', '/schedule/api/search'),
        accept: 'application/json',
        timeout: const Duration(seconds: 1),
        label: 'search',
      );

      expect(response.statusCode, HttpStatus.ok);
      expect(requests, 2);
      expect(delays, [const Duration(seconds: 7)]);
    });

    test('honors and caps JSON retry_after for a 530 response', () async {
      var requests = 0;
      final delays = <Duration>[];
      final client = RetryingSourceClient(
        httpClient: MockClient((_) async {
          requests++;
          if (requests == 1) {
            return http.Response(
              jsonEncode({'retry_after': 900}),
              530,
            );
          }
          return http.Response('ok', HttpStatus.ok);
        }),
        delay: (duration) async => delays.add(duration),
      );

      final response = await client.get(
        Uri.https('relay.example', '/schedule/api/search'),
        accept: 'application/json',
        timeout: const Duration(seconds: 1),
        label: 'search',
      );

      expect(response.statusCode, HttpStatus.ok);
      expect(requests, 2);
      expect(delays, [const Duration(minutes: 2)]);
    });

    test('falls back for invalid server retry delays', () async {
      var requests = 0;
      final delays = <Duration>[];
      final client = RetryingSourceClient(
        httpClient: MockClient((_) async {
          requests++;
          if (requests == 1) {
            return http.Response(
              jsonEncode({'retry_after': -10}),
              HttpStatus.tooManyRequests,
              headers: {HttpHeaders.retryAfterHeader: 'invalid'},
            );
          }
          return http.Response('ok', HttpStatus.ok);
        }),
        delay: (duration) async => delays.add(duration),
      );

      await client.get(
        Uri.https('relay.example', '/schedule/api/search'),
        accept: 'application/json',
        timeout: const Duration(seconds: 1),
        label: 'search',
      );

      expect(requests, 2);
      expect(delays, [const Duration(seconds: 2)]);
    });
  });

  group('ScheduleSearchPager', () {
    test('retries a page and forwards the next page token', () async {
      final queries = <Map<String, String>>[];
      final delays = <Duration>[];
      var requests = 0;
      final sourceClient = RetryingSourceClient(
        httpClient: MockClient((request) async {
          requests++;
          queries.add(request.url.queryParameters);
          if (requests == 1) {
            return http.Response(jsonEncode({'retry_after': 3}), 530);
          }
          if (requests == 2) {
            return http.Response(
              jsonEncode({
                'data': [
                  {'id': 1},
                ],
                'nextPageToken': 'page-2',
              }),
              HttpStatus.ok,
            );
          }
          return http.Response(
            jsonEncode({
              'data': [
                {'id': 2},
              ],
              'nextPageToken': null,
            }),
            HttpStatus.ok,
          );
        }),
        delay: (duration) async => delays.add(duration),
      );
      final pager = ScheduleSearchPager(
        sourceClient,
        Uri.https('relay.example'),
      );

      final items = await pager.fetch(match: ' group ').toList();

      expect(items.map((item) => item['id']), [1, 2]);
      expect(delays, [const Duration(seconds: 3)]);
      expect(queries, [
        {'match': 'group'},
        {'match': 'group'},
        {'pageToken': 'page-2', 'match': 'group'},
      ]);
    });

    test('rejects a repeated pagination token', () async {
      var requests = 0;
      final sourceClient = RetryingSourceClient(
        httpClient: MockClient((_) async {
          requests++;
          return http.Response(
            jsonEncode({
              'data': const <Object?>[],
              'nextPageToken': 'same-token',
            }),
            HttpStatus.ok,
          );
        }),
        delay: (_) async {},
      );
      final pager = ScheduleSearchPager(
        sourceClient,
        Uri.https('relay.example'),
      );

      await expectLater(
        pager.fetch().toList(),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('pagination token repeated'),
          ),
        ),
      );
      expect(requests, 2);
    });
  });
}
