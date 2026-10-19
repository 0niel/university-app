import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:schedule_fetcher/source_fetcher.dart';
import 'package:test/test.dart';

const _calendar = 'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nEND:VCALENDAR\r\n';
const _authorization = 'Basic relay-only-test';
final _relay = Uri.https('relay.example');

http.Response _search({String? link}) => http.Response(
  jsonEncode({
    'data': [
      {
        'id': 7689752,
        'iCalLink':
            link ??
            'https://schedule-of.mirea.ru/schedule/api/ical/7689752?type=group',
      },
    ],
  }),
  200,
);

void expectRelayAuthorization(http.Request request) {
  final isRelay = request.url.host == _relay.host;
  expect(
    request.headers[HttpHeaders.authorizationHeader],
    isRelay ? _authorization : isNull,
  );
}

void main() {
  test(
    'selects official once after search and calendar without relay auth',
    () async {
      final requests = <http.Request>[];
      final selected = await selectScheduleSource(
        relayBaseUrl: _relay,
        relayAuthorization: _authorization,
        httpClient: MockClient((request) async {
          requests.add(request);
          expect(
            request.headers,
            isNot(contains(HttpHeaders.authorizationHeader)),
          );
          expect(request.followRedirects, isFalse);
          return request.url.path.endsWith('search')
              ? _search()
              : http.Response(_calendar, 200);
        }),
      );
      expect(selected.baseUrl, officialScheduleUri);
      expect(selected.usesRelay, isFalse);
      expect(requests.length, 2);
      expect(
        requests.every((r) => r.url.host == officialScheduleUri.host),
        isTrue,
      );
    },
  );

  for (final invalidCalendar in [false, true]) {
    test(
      'invalid official HTML falls back (calendar: $invalidCalendar)',
      () async {
        final requests = <http.Request>[];
        final selected = await selectScheduleSource(
          relayBaseUrl: _relay,
          relayAuthorization: _authorization,
          httpClient: MockClient((request) async {
            requests.add(request);
            final isRelay = request.url.host == _relay.host;
            expectRelayAuthorization(request);
            expect(request.followRedirects, isFalse);
            if (!isRelay &&
                (!invalidCalendar || !request.url.path.endsWith('search'))) {
              return http.Response('<html>Unavailable</html>', 200);
            }
            return request.url.path.endsWith('search')
                ? _search()
                : http.Response(_calendar, 200);
          }),
        );
        expect(selected.baseUrl, _relay);
        expect(selected.usesRelay, isTrue);
        final feed = requests.last.url;
        expect(feed.host, _relay.host);
        expect(feed.path, '/schedule/api/ical/7689752');
        expect(feed.queryParameters, {'type': 'group'});
        expect(requests.length, invalidCalendar ? 4 : 3);
      },
    );
  }

  test('rejects foreign calendar origins before requesting them', () async {
    final hosts = <String>[];
    final selected = await selectScheduleSource(
      relayBaseUrl: _relay,
      relayAuthorization: _authorization,
      httpClient: MockClient((request) async {
        hosts.add(request.url.host);
        if (request.url.host == officialScheduleUri.host) {
          return _search(link: 'https://foreign.example/schedule/api/ical/1');
        }
        return request.url.path.endsWith('search')
            ? _search()
            : http.Response(_calendar, 200);
      }),
    );
    expect(selected.usesRelay, isTrue);
    expect(hosts, [officialScheduleUri.host, _relay.host, _relay.host]);
  });

  test(
    'fails closed if neither source is healthy without exposing responses',
    () async {
      var requests = 0;
      await expectLater(
        selectScheduleSource(
          relayBaseUrl: _relay,
          relayAuthorization: _authorization,
          httpClient: MockClient((request) async {
            requests++;
            return http.Response(_authorization, 403);
          }),
        ),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            allOf(
              contains('Neither official'),
              isNot(contains(_authorization)),
            ),
          ),
        ),
      );
      expect(requests, 2);
    },
  );

  test('official timeout falls back without retrying the probe', () async {
    var officialRequests = 0;
    final selected = await selectScheduleSource(
      relayBaseUrl: _relay,
      timeout: const Duration(milliseconds: 10),
      httpClient: MockClient((request) {
        if (request.url.host == officialScheduleUri.host) {
          officialRequests++;
          return Completer<http.Response>().future;
        }
        return Future.value(
          request.url.path.endsWith('search')
              ? _search()
              : http.Response(_calendar, 200),
        );
      }),
    );
    expect(selected.usesRelay, isTrue);
    expect(officialRequests, 1);
  });

  test('does not treat official as an authenticated fallback', () async {
    var requests = 0;
    await expectLater(
      selectScheduleSource(
        relayBaseUrl: officialScheduleUri,
        relayAuthorization: _authorization,
        httpClient: MockClient((request) async {
          requests++;
          expect(
            request.headers,
            isNot(contains(HttpHeaders.authorizationHeader)),
          );
          return http.Response('Unavailable', 503);
        }),
      ),
      throwsStateError,
    );
    expect(requests, 1);
  });

  test(
    'waits for relay warmup without retrying the official source',
    () async {
      final started = DateTime.utc(2026);
      var now = started;
      var officialRequests = 0;
      var relayRequests = 0;
      final delays = <Duration>[];
      final diagnostics = <String>[];
      final selected = await selectScheduleSource(
        relayBaseUrl: _relay,
        relayAuthorization: _authorization,
        clock: () => now,
        delay: (duration) {
          delays.add(duration);
          now = now.add(duration);
          return .value();
        },
        log: diagnostics.add,
        httpClient: MockClient((request) async {
          expect(request.followRedirects, isFalse);
          if (request.url.host == officialScheduleUri.host) {
            officialRequests++;
            expect(request.headers[HttpHeaders.authorizationHeader], isNull);
            return http.Response('blocked', 403);
          }
          relayRequests++;
          expect(
            request.headers[HttpHeaders.authorizationHeader],
            _authorization,
          );
          if (now.difference(started) < const Duration(seconds: 50)) {
            return http.Response('Starting service $_authorization', 503);
          }
          return request.url.path.endsWith('search')
              ? _search()
              : http.Response(_calendar, 200);
        }),
      );
      expect(selected.usesRelay, isTrue);
      expect(officialRequests, 1);
      expect(relayRequests, 12);
      expect(delays, List.filled(10, const Duration(seconds: 5)));
      expect(
        diagnostics.first,
        'Schedule probe source=official stage=search category=http status=403',
      );
      expect(diagnostics.join(), isNot(contains(_authorization)));
    },
  );

  test(
    'retries transient calendar errors within the same warmup budget',
    () async {
      var now = DateTime.utc(2026);
      var searches = 0;
      var calendars = 0;
      final diagnostics = <String>[];
      final selected = await selectScheduleSource(
        relayBaseUrl: _relay,
        clock: () => now,
        delay: (duration) async => now = now.add(duration),
        log: diagnostics.add,
        httpClient: MockClient((request) async {
          if (request.url.host == officialScheduleUri.host) {
            return http.Response('blocked', 403);
          }
          if (request.url.path.endsWith('search')) {
            searches++;
            return _search();
          }
          calendars++;
          return calendars == 1
              ? http.Response('unavailable', 502)
              : http.Response(_calendar, 200);
        }),
      );
      expect(selected.usesRelay, isTrue);
      expect(searches, 2);
      expect(calendars, 2);
      expect(
        diagnostics.last,
        contains(
          'source=relay stage=calendar category=http status=502 attempt=1',
        ),
      );
    },
  );

  test(
    'bounds persistent relay failures to the shared warmup budget',
    () async {
      final started = DateTime.utc(2026);
      var now = started;
      var relayRequests = 0;
      await expectLater(
        selectScheduleSource(
          relayBaseUrl: _relay,
          clock: () => now,
          delay: (duration) async => now = now.add(duration),
          httpClient: MockClient((request) async {
            if (request.url.host == officialScheduleUri.host) {
              return http.Response('blocked', 403);
            }
            relayRequests++;
            return http.Response(_authorization, 503);
          }),
        ),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            allOf(
              contains('source=official stage=search category=http status=403'),
              contains('source=relay stage=search category=http status=503'),
              isNot(contains(_authorization)),
            ),
          ),
        ),
      );
      expect(relayRequests, 18);
      expect(now.difference(started), const Duration(seconds: 85));
    },
  );

  test('caps a hanging request at the remaining warmup deadline', () async {
    final elapsed = Stopwatch()..start();
    await expectLater(
      selectScheduleSource(
        relayBaseUrl: _relay,
        timeout: const Duration(seconds: 5),
        relayWarmupTimeout: const Duration(milliseconds: 20),
        httpClient: MockClient((request) {
          if (request.url.host == officialScheduleUri.host) {
            return Future.value(http.Response('blocked', 403));
          }
          return Completer<http.Response>().future;
        }),
      ),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('source=relay stage=search category=timeout'),
        ),
      ),
    );
    expect(elapsed.elapsed, lessThan(const Duration(seconds: 1)));
  });

  test('calendar failures do not restart the relay warmup budget', () async {
    var now = DateTime.utc(2026);
    var calendars = 0;
    await expectLater(
      selectScheduleSource(
        relayBaseUrl: _relay,
        relayWarmupTimeout: const Duration(seconds: 6),
        clock: () => now,
        delay: (duration) async => now = now.add(duration),
        httpClient: MockClient((request) async {
          if (request.url.host == officialScheduleUri.host) {
            return http.Response('blocked', 403);
          }
          if (request.url.path.endsWith('search')) return _search();
          calendars++;
          return http.Response('unavailable', 503);
        }),
      ),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('source=relay stage=calendar category=http status=503'),
        ),
      ),
    );
    expect(calendars, 2);
  });

  for (final status in [301, 401, 403, 404]) {
    test('does not retry permanent relay HTTP $status', () async {
      var relayRequests = 0;
      await expectLater(
        selectScheduleSource(
          relayBaseUrl: _relay,
          delay: (_) async => fail('Permanent failures must not wait'),
          httpClient: MockClient((request) async {
            if (request.url.host == _relay.host) relayRequests++;
            return http.Response(_authorization, status);
          }),
        ),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('source=relay stage=search category=http status=$status'),
          ),
        ),
      );
      expect(relayRequests, 1);
    });
  }

  for (final category in ['network', 'tls', 'invalid_response']) {
    test('redacts relay $category errors and diagnostics', () async {
      var now = DateTime.utc(2026);
      final diagnostics = <String>[];
      await expectLater(
        selectScheduleSource(
          relayBaseUrl: _relay,
          relayWarmupTimeout: const Duration(seconds: 6),
          clock: () => now,
          delay: (duration) async => now = now.add(duration),
          log: diagnostics.add,
          httpClient: MockClient((request) async {
            if (request.url.host == officialScheduleUri.host) {
              return http.Response('blocked', 403);
            }
            switch (category) {
              case 'network':
                throw http.ClientException(
                  _authorization,
                  Uri.https('secret.example', '/', {'token': _authorization}),
                );
              case 'tls':
                throw const HandshakeException(_authorization);
              default:
                return http.Response('$_authorization invalid json', 200);
            }
          }),
        ),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            allOf(
              contains('source=relay stage=search category=$category'),
              isNot(contains(_authorization)),
              isNot(contains('secret.example')),
            ),
          ),
        ),
      );
      expect(diagnostics.join(), isNot(contains(_authorization)));
      expect(diagnostics.join(), isNot(contains('secret.example')));
    });
  }

  test(
    'reports invalid relay origin before any authenticated request',
    () async {
      var requests = 0;
      await expectLater(
        selectScheduleSource(
          relayBaseUrl: Uri.parse('https://$_authorization@relay.example'),
          httpClient: MockClient((request) async {
            requests++;
            return http.Response('blocked', 403);
          }),
        ),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            allOf(
              contains('source=relay stage=origin category=invalid_response'),
              isNot(contains(_authorization)),
            ),
          ),
        ),
      );
      expect(requests, 1);
    },
  );

  test(
    'runtime client strips relay authorization on official origin',
    () async {
      final client = RetryingSourceClient(
        authorization: _authorization,
        httpClient: MockClient((request) async {
          expect(
            request.headers,
            isNot(contains(HttpHeaders.authorizationHeader)),
          );
          return http.Response('ok', 200);
        }),
      );
      await client.get(
        officialScheduleUri.resolve('/schedule/api/search'),
        accept: 'application/json',
        timeout: const Duration(seconds: 1),
        label: 'search',
      );
    },
  );

  test('authenticated runtime requests never follow redirects', () async {
    final client = RetryingSourceClient(
      authorization: _authorization,
      httpClient: MockClient((request) async {
        expect(request.followRedirects, isFalse);
        expect(
          request.headers[HttpHeaders.authorizationHeader],
          _authorization,
        );
        return http.Response(
          '',
          302,
          headers: {
            HttpHeaders.locationHeader: officialScheduleUri.toString(),
          },
        );
      }),
    );
    final response = await client.get(
      _relay.resolve('/schedule/api/search'),
      accept: 'application/json',
      timeout: const Duration(seconds: 1),
      label: 'search',
    );
    expect(response.statusCode, 302);
  });
}
