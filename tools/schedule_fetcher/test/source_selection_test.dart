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
            expect(
              request.headers[HttpHeaders.authorizationHeader],
              isRelay ? _authorization : isNull,
            );
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
