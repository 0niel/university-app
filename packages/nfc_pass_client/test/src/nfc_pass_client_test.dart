import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nfc_pass_client/nfc_pass_client.dart';

final _endpoints = NfcPassEndpoints(
  accessTokenUrl: Uri.https('pass.example', '/token'),
  sendVerificationCodeUrl: Uri.https('pass.example', '/send'),
  getDigitalPassUrl: Uri.https('pass.example', '/pass'),
);

const _headers = {'content-type': 'application/grpc-web+proto'};

List<int> _frame(List<int> payload, {int flags = 0}) => [
      flags,
      (payload.length >> 24) & 255,
      (payload.length >> 16) & 255,
      (payload.length >> 8) & 255,
      payload.length & 255,
      ...payload,
    ];

List<int> _trailers(String value) => _frame(ascii.encode(value), flags: 0x80);

List<int> _success(List<int> payload) => [
      ..._frame(payload),
      ..._trailers('grpc-status: 0\r\n'),
    ];

NfcPassClient _client(http.Client httpClient) => NfcPassClient(
      cookieProvider: () => 'session',
      endpoints: _endpoints,
      httpClient: httpClient,
    );

void main() {
  test('sends a binary unary request with the current session', () async {
    final client = _client(
      MockClient((request) async {
        expect(request.url, _endpoints.accessTokenUrl);
        expect(request.followRedirects, isFalse);
        expect(request.headers['cookie'], '.AspNetCore.Cookies=session');
        expect(request.headers['accept'], 'application/grpc-web+proto');
        expect(request.bodyBytes, [0, 0, 0, 0, 0]);
        return http.Response.bytes(
          _success([10, 3, ...ascii.encode('jwt')]),
          200,
          headers: _headers,
        );
      }),
    );

    expect(await client.getAccessTokenForDigitalPass(), 'jwt');
  });

  test('supports headers-only gRPC errors', () async {
    final client = _client(
      MockClient(
        (_) async => http.Response.bytes(
          [],
          200,
          headers: {..._headers, 'grpc-status': '16'},
        ),
      ),
    );

    await expectLater(
      client.getAccessTokenForDigitalPass(),
      throwsA(
        isA<NfcPassTransportException>().having(
          (error) => error.requiresAuthentication,
          'requiresAuthentication',
          isTrue,
        ),
      ),
    );
  });

  test('rejects a failed trailer even after a valid protobuf message',
      () async {
    final client = _client(
      MockClient(
        (_) async => http.Response.bytes(
          [
            ..._frame([10, 3, ...ascii.encode('jwt')]),
            ..._trailers('grpc-status: 7\r\ngrpc-message: denied\r\n'),
          ],
          200,
          headers: _headers,
        ),
      ),
    );

    await expectLater(
      client.getAccessTokenForDigitalPass(),
      throwsA(
        isA<NfcPassTransportException>()
            .having((error) => error.grpcStatus, 'grpcStatus', 7),
      ),
    );
  });

  for (final (name, body) in <(String, List<int>)>[
    ('partial header', [0, 0, 0]),
    ('partial payload', [0, 0, 0, 0, 4, 1]),
    ('oversized frame length', [0, 255, 255, 255, 255]),
    ('compressed message', _frame([], flags: 1)),
    ('unknown flags', _frame([], flags: 2)),
    ('multiple messages', [..._frame([]), ..._success([])]),
    ('message after trailers', [..._trailers('grpc-status: 0'), ..._frame([])]),
    ('missing status', _frame([])),
    ('malformed trailer', _trailers('grpc-status 0')),
    ('missing trailer status', _trailers('grpc-message: done')),
    ('duplicate status', _trailers('grpc-status: 0\r\ngrpc-status: 16')),
    ('invalid status', _trailers('grpc-status: success')),
    ('unknown status', _trailers('grpc-status: 99')),
    ('negative status', _trailers('grpc-status: -1')),
    ('empty token', _success([])),
  ]) {
    test('rejects $name without retrying', () async {
      var calls = 0;
      final client = _client(
        MockClient((_) async {
          calls++;
          return http.Response.bytes(body, 200, headers: _headers);
        }),
      );

      await expectLater(
        client.getAccessTokenForDigitalPass(),
        throwsA(isA<FormatException>()),
      );
      expect(calls, 1);
    });
  }

  test('rejects conflicting header and trailer statuses', () async {
    final client = _client(
      MockClient(
        (_) async => http.Response.bytes(
          _success([]),
          200,
          headers: {..._headers, 'grpc-status': '16'},
        ),
      ),
    );
    await expectLater(
      client.sendVerificationCode('jwt'),
      throwsA(isA<FormatException>()),
    );
  });

  test('does not accept a login HTML page as a protobuf response', () async {
    final client = _client(
      MockClient(
        (_) async => http.Response(
          '<html>Login</html>',
          200,
          headers: {'content-type': 'text/html'},
        ),
      ),
    );
    await expectLater(
      client.getAccessTokenForDigitalPass(),
      throwsA(isA<FormatException>()),
    );
  });

  for (final status in [302, 401, 403, 429, 500]) {
    test('preserves HTTP $status and never retries a code send', () async {
      var calls = 0;
      final client = _client(
        MockClient((_) async {
          calls++;
          return http.Response('', status);
        }),
      );
      await expectLater(
        client.sendVerificationCode('jwt'),
        throwsA(
          isA<NfcPassTransportException>()
              .having((error) => error.httpStatusCode, 'httpStatusCode', status)
              .having(
                (error) => error.requiresAuthentication,
                'requiresAuthentication',
                status == 401,
              ),
        ),
      );
      expect(calls, 1);
    });
  }

  test('rejects a trailers-only verification response', () async {
    final client = _client(
      MockClient(
        (_) async => http.Response.bytes(
          _trailers('grpc-status: 0'),
          200,
          headers: _headers,
        ),
      ),
    );
    await expectLater(
      client.sendVerificationCode('jwt'),
      throwsA(isA<FormatException>()),
    );
  });

  for (final (name, payload, matcher) in <(String, List<int>, Matcher)>[
    ('sent', [10, 0], isA<NfcVerificationCodeSent>()),
    (
      'sent with retry timestamp',
      [10, 8, 10, 6, 8, 128, 164, 167, 218, 6],
      isA<NfcVerificationCodeSent>().having(
        (result) => result.retryAt,
        'retryAt',
        DateTime.fromMillisecondsSinceEpoch(1800000000000, isUtc: true),
      ),
    ),
    (
      'cooldown',
      [18, 6, 8, 128, 164, 167, 218, 6],
      isA<NfcVerificationCooldown>().having(
        (result) => result.retryAt,
        'retryAt',
        DateTime.fromMillisecondsSinceEpoch(1800000000000, isUtc: true),
      ),
    ),
    ('unavailable', [26, 0], isA<NfcVerificationUnavailable>()),
  ]) {
    test('decodes the source verification $name outcome without replay',
        () async {
      var calls = 0;
      final client = _client(
        MockClient((_) async {
          calls++;
          return http.Response.bytes(_success(payload), 200, headers: _headers);
        }),
      );

      expect(await client.sendVerificationCode('jwt'), matcher);
      expect(calls, 1);
    });
  }

  for (final payload in <List<int>>[
    [],
    [34, 0],
    [18, 6, 16, 128, 148, 235, 220, 3],
  ]) {
    test('rejects an absent, unknown, or invalid verification outcome $payload',
        () async {
      final client = _client(
        MockClient(
          (_) async => http.Response.bytes(
            _success(payload),
            200,
            headers: _headers,
          ),
        ),
      );
      await expectLater(
        client.sendVerificationCode('jwt'),
        throwsA(isA<FormatException>()),
      );
    });
  }

  for (final (payload, failure) in [
    ([18, 0], NfcVerificationFailure.wrongCode),
    ([26, 0], NfcVerificationFailure.nfcError),
  ]) {
    test('preserves the ${failure.name} confirmation outcome without replay',
        () async {
      var calls = 0;
      final client = _client(
        MockClient((_) async {
          calls++;
          return http.Response.bytes(_success(payload), 200, headers: _headers);
        }),
      );
      await expectLater(
        client.getDigitalPass(
          bearerToken: 'jwt',
          sixDigitCode: '123456',
          deviceName: 'Phone',
        ),
        throwsA(
          isA<NfcVerificationException>().having(
            (error) => error.failure,
            'failure',
            failure,
          ),
        ),
      );
      expect(calls, 1);
    });
  }

  test('rejects a missing pass identifier', () async {
    final client = _client(
      MockClient(
        (_) async => http.Response.bytes(
          _success([]),
          200,
          headers: _headers,
        ),
      ),
    );
    await expectLater(
      client.getDigitalPass(
        bearerToken: 'jwt',
        sixDigitCode: '123456',
        deviceName: 'Phone',
      ),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects declared and streamed responses over the size limit', () async {
    for (final declared in [true, false]) {
      var cancelled = false;
      final stream = StreamController<List<int>>(
        onCancel: () => cancelled = true,
      )..add(List<int>.filled(64, 0));
      final client = NfcPassClient(
        cookieProvider: () => 'session',
        endpoints: _endpoints,
        maxResponseBytes: 32,
        httpClient: MockClient.streaming(
          (_, __) async => http.StreamedResponse(
            stream.stream,
            200,
            contentLength: declared ? 64 : null,
            headers: _headers,
          ),
        ),
      );
      await expectLater(
        client.getAccessTokenForDigitalPass(),
        throwsA(isA<FormatException>()),
      );
      expect(cancelled, isTrue);
      await stream.close();
    }
  });

  for (final waitingForHeaders in [true, false]) {
    test(
        'times out and aborts while waiting for '
        '${waitingForHeaders ? 'headers' : 'body'}', () async {
      final aborted = Completer<void>();
      final client = NfcPassClient(
        cookieProvider: () => 'session',
        endpoints: _endpoints,
        requestTimeout: const Duration(milliseconds: 20),
        httpClient: MockClient.streaming((request, _) async {
          final abort = (request as http.Abortable).abortTrigger!;
          if (waitingForHeaders) {
            await abort;
            aborted.complete();
            throw http.RequestAbortedException();
          }
          final stream = StreamController<List<int>>();
          unawaited(
            abort.then((_) async {
              aborted.complete();
              stream.addError(http.RequestAbortedException());
              await stream.close();
            }),
          );
          return http.StreamedResponse(stream.stream, 200, headers: _headers);
        }),
      );
      await expectLater(
        client.sendVerificationCode('jwt'),
        throwsA(isA<TimeoutException>()),
      );
      await aborted.future;
    });
  }

  test('rejects a malformed cookie before any network request', () async {
    var requests = 0;
    final client = _client(
      MockClient((_) async {
        requests++;
        return http.Response('', 200);
      }),
    );
    await expectLater(
      client.getAccessTokenForDigitalPass(sessionCookie: 'session; injected=x'),
      throwsA(isA<FormatException>()),
    );
    expect(requests, 0);
  });
}
