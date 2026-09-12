import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nfc_pass_client/nfc_pass_client.dart';
import 'package:nfc_pass_repository/nfc_pass_repository.dart';
import 'package:storage/storage.dart';
import 'package:web_oauth_interceptor_client/web_oauth_interceptor_client.dart'
    show LoginSuccessData, OAuthFlowCancelled, OAuthInterceptorClient;

class _Storage extends Mock implements Storage {}

class _OAuth extends Mock implements OAuthInterceptorClient {}

class _Channel extends Mock implements DigitalPassChannel {}

final _configuration = NfcPassConfiguration(
  oauthUrl: Uri.https('pass.example', '/login'),
  expectedRedirectUrls: [Uri.https('pass.example', '/')],
  endpoints: NfcPassEndpoints(
    accessTokenUrl: Uri.https('pass.example', '/token'),
    sendVerificationCodeUrl: Uri.https('pass.example', '/send'),
    getDigitalPassUrl: Uri.https('pass.example', '/pass'),
  ),
);

List<int> _frame(List<int> payload, {int flags = 0}) => [
      flags,
      0,
      0,
      (payload.length >> 8) & 255,
      payload.length & 255,
      ...payload,
    ];

http.Response _response(List<int> payload, {int status = 0}) =>
    http.Response.bytes(
      [
        ..._frame(payload),
        ..._frame(ascii.encode('grpc-status: $status\r\n'), flags: 0x80),
      ],
      200,
      headers: {'content-type': 'application/grpc-web+proto'},
    );

void main() {
  late Map<String, String> values;
  late _Storage storage;
  late _OAuth oauth;
  late _Channel channel;
  late List<http.Request> requests;
  late Future<http.Response> Function(http.Request) handler;
  late NfcPassRepository repository;

  NfcPassRepository createRepository() => NfcPassRepository(
        storage: storage,
        configuration: _configuration,
        oauthInterceptorClient: oauth,
        digitalPassChannel: channel,
        httpClient: MockClient((request) async {
          requests.add(request);
          return handler(request);
        }),
      );

  setUp(() {
    values = {};
    requests = [];
    storage = _Storage();
    oauth = _OAuth();
    channel = _Channel();
    when(() => storage.read(key: any(named: 'key'))).thenAnswer(
      (call) async => values[call.namedArguments[#key]],
    );
    when(
      () => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((call) async {
      values[call.namedArguments[#key] as String] =
          call.namedArguments[#value] as String;
    });
    when(() => storage.delete(key: any(named: 'key'))).thenAnswer((call) async {
      values.remove(call.namedArguments[#key]);
    });
    when(() => channel.savePassId(any())).thenAnswer((_) async {});
    when(() => channel.clearPassId()).thenAnswer((_) async {});
    when(() => oauth.initiateOAuthFlow()).thenAnswer(
      (_) async =>
          LoginSuccessData(allCookies: {'.AspNetCore.Cookies': 'fresh'}),
    );
    handler = (request) async => switch (request.url.path) {
          '/token' => _response([10, 3, ...ascii.encode('jwt')]),
          '/pass' => _response([10, 2, 8, 42]),
          _ => _response([10, 0]),
        };
    repository = createRepository();
  });

  test('authenticateSession shares the browser login with the pass', () async {
    await repository.synchronizeSessionAccount('mirea:student-a');
    when(() => oauth.initiateOAuthFlow()).thenAnswer(
      (_) async => LoginSuccessData(
        allCookies: {
          '.AspNetCore.Cookies': 'chunks-1',
          '.AspNetCore.CookiesC1': 'chunk',
          'unrelated': 'ignored',
        },
      ),
    );
    final cookie = await repository.authenticateSession();
    expect(cookie, '.AspNetCore.Cookies=chunks-1; .AspNetCore.CookiesC1=chunk');
    expect(await repository.readSessionCookie(), cookie);
    await repository.bindPass();
    expect(requests.map((request) => request.url.path), ['/token', '/send']);
    verify(() => oauth.initiateOAuthFlow()).called(1);
  });

  test('authenticateSession returns null when the browser is closed', () async {
    await repository.synchronizeSessionAccount('mirea:student-a');
    when(() => oauth.initiateOAuthFlow()).thenThrow(const OAuthFlowCancelled());
    expect(await repository.authenticateSession(), isNull);
    expect(await repository.readSessionCookie(), isNull);
  });

  test('authenticateSession reports missing cookies and browser failures',
      () async {
    await repository.synchronizeSessionAccount('mirea:student-a');
    when(() => oauth.initiateOAuthFlow())
        .thenAnswer((_) async => LoginSuccessData(allCookies: const {}));
    await expectLater(
      repository.authenticateSession(),
      throwsA(isA<NfcPassLoginFailure>()),
    );
    when(() => oauth.initiateOAuthFlow()).thenThrow('Unable to open browser');
    await expectLater(
      repository.authenticateSession(),
      throwsA(isA<NfcPassLoginFailure>()),
    );
    expect(await repository.readSessionCookie(), isNull);
  });

  test('restores the same account after restart without repeating OAuth',
      () async {
    await repository.synchronizeSessionAccount('mirea:student-a');
    await repository.setSessionCookie('session');
    values.addAll({'nfc_jwt': 'pending', 'nfc_pass_id': '42'});

    repository = createRepository();
    await repository.synchronizeSessionAccount('mirea:student-a');

    expect(await repository.readSessionCookie(), 'session');
    expect(values['nfc_jwt'], 'pending');
    expect(values['nfc_pass_id'], '42');
    await repository.bindPass();
    expect(requests.map((request) => request.url.path), ['/token', '/send']);
    verifyNever(() => oauth.initiateOAuthFlow());
    verifyNever(() => channel.clearPassId());
  });

  test('a different account on cold start cannot reuse the previous session',
      () async {
    await repository.synchronizeSessionAccount('mirea:student-a');
    await repository.setSessionCookie('session');
    values.addAll({'nfc_jwt': 'pending', 'nfc_pass_id': '42'});

    repository = createRepository();
    await repository.synchronizeSessionAccount('mirea:student-b');

    expect(await repository.readSessionCookie(), isNull);
    expect(values['nfc_jwt'], isNull);
    expect(values['nfc_session_account'], 'mirea:student-b');
    expect(values['nfc_pass_id'], '42');
    verifyNever(() => oauth.initiateOAuthFlow());
    verifyNever(() => channel.clearPassId());
  });

  test('unowned legacy auth is removed only once without unbinding the pass',
      () async {
    values.addAll({
      'nfc_cookie': 'unowned',
      'nfc_jwt': 'pending',
      'nfc_pass_id': '42',
    });
    await repository.synchronizeSessionAccount('mirea:student-a');
    expect(await repository.readSessionCookie(), isNull);
    expect(values['nfc_jwt'], isNull);
    expect(values['nfc_pass_id'], '42');

    await repository.setSessionCookie('owned');
    for (var restart = 0; restart < 2; restart++) {
      repository = createRepository();
      await repository.synchronizeSessionAccount('mirea:student-a');
      expect(await repository.readSessionCookie(), 'owned');
    }
  });

  test('a rapid logout and same-account login does not revive old auth',
      () async {
    await repository.synchronizeSessionAccount('mirea:student-a');
    await repository.setSessionCookie('session');
    final logout = repository.synchronizeSessionAccount(null);
    final login = repository.synchronizeSessionAccount('mirea:student-a');
    await Future.wait([logout, login]);
    expect(await repository.readSessionCookie(), isNull);
    expect(values['nfc_session_account'], 'mirea:student-a');
  });

  test('the same user in another organization cannot reuse the session',
      () async {
    await repository.synchronizeSessionAccount('mirea:student-a');
    await repository.setSessionCookie('session');
    repository = createRepository();
    await repository.synchronizeSessionAccount('other:student-a');
    expect(await repository.readSessionCookie(), isNull);
  });

  test('an anonymous account cannot start OAuth or adopt a shared session',
      () async {
    await repository.synchronizeSessionAccount('mirea:student-a');
    await repository.setSessionCookie('session');
    await repository.synchronizeSessionAccount(null);
    await expectLater(
      repository.bindPass(),
      throwsA(isA<NfcPassLoginFailure>()),
    );
    await expectLater(
      repository.setSessionCookie('replacement'),
      throwsA(isA<NfcPassLoginFailure>()),
    );
    repository = createRepository();
    await repository.synchronizeSessionAccount(null);
    expect(await repository.readSessionCookie(), isNull);
    expect(requests, isEmpty);
    verifyNever(() => oauth.initiateOAuthFlow());
  });

  test('a late OAuth result cannot attach to a different app account',
      () async {
    await repository.synchronizeSessionAccount('mirea:student-a');
    final started = Completer<void>();
    final login = Completer<LoginSuccessData>();
    when(() => oauth.initiateOAuthFlow()).thenAnswer((_) {
      started.complete();
      return login.future;
    });
    final binding = repository.bindPass();
    final result = expectLater(binding, throwsA(isA<NfcPassLoginFailure>()));
    await started.future;
    await repository.synchronizeSessionAccount('mirea:student-b');
    login
        .complete(LoginSuccessData(allCookies: {'.AspNetCore.Cookies': 'old'}));
    await result;
    expect(await repository.readSessionCookie(), isNull);
    expect(values['nfc_session_account'], 'mirea:student-b');
    expect(requests, isEmpty);
  });

  test('account changes invalidate queued writes before storage is available',
      () async {
    await repository.synchronizeSessionAccount('mirea:student-a');
    final setter = repository.setSessionCookie('session-a');
    final result = expectLater(setter, throwsA(isA<NfcPassLoginFailure>()));
    await repository.synchronizeSessionAccount('mirea:student-b');
    await result;
    expect(await repository.readSessionCookie(), isNull);
    await repository.setSessionCookie('session-b');
    expect(await repository.readSessionCookie(), 'session-b');
  });

  test('a failed logout cleanup cannot restore auth after process restart',
      () async {
    await repository.synchronizeSessionAccount('mirea:student-a');
    await repository.setSessionCookie('session');
    when(() => storage.delete(key: 'nfc_cookie'))
        .thenThrow(StateError('Storage unavailable'));
    await expectLater(repository.clearSessionCookie(), throwsStateError);
    expect(values['nfc_session_account'], '');
    expect(values['nfc_cookie'], 'session');

    when(() => storage.delete(key: 'nfc_cookie')).thenAnswer((_) async {
      values.remove('nfc_cookie');
    });
    repository = createRepository();
    await repository.synchronizeSessionAccount('mirea:student-a');
    expect(await repository.readSessionCookie(), isNull);
  });

  test('failed account restoration blocks OAuth and session adoption',
      () async {
    when(() => storage.read(key: 'nfc_session_account'))
        .thenThrow(StateError('Storage unavailable'));
    await expectLater(
      repository.synchronizeSessionAccount('mirea:student-a'),
      throwsStateError,
    );
    await expectLater(
      repository.setSessionCookie('session'),
      throwsA(isA<NfcPassLoginFailure>()),
    );
    await expectLater(
      repository.bindPass(),
      throwsA(isA<NfcPassLoginFailure>()),
    );
    expect(requests, isEmpty);
    verifyNever(() => oauth.initiateOAuthFlow());
  });

  test('sharing and clearing a session preserves the bound native pass',
      () async {
    values.addAll({'nfc_pass_id': '42', 'nfc_jwt': 'pending'});

    await repository.setSessionCookie('session');
    expect(await repository.readSessionCookie(), 'session');
    expect(values['nfc_jwt'], isNull);
    expect(values['nfc_pass_id'], '42');

    await repository.clearSessionCookie();
    expect(await repository.readSessionCookie(), isNull);
    expect(values['nfc_pass_id'], '42');
    expect(requests, isEmpty);
    verifyNever(() => channel.clearPassId());
    verifyNever(() => channel.savePassId(any()));
    verifyNever(() => oauth.initiateOAuthFlow());
  });

  test('saving an unchanged session preserves pending verification', () async {
    values.addAll({'nfc_cookie': 'session', 'nfc_jwt': 'jwt'});
    await repository.setSessionCookie('session');
    expect(values['nfc_jwt'], 'jwt');
  });

  test('fails closed when secure storage cannot delete the previous session',
      () async {
    values.addAll({
      'nfc_cookie': 'previous',
      'nfc_jwt': 'previous-token',
      'nfc_pass_id': '42',
    });
    when(() => storage.delete(key: 'nfc_cookie'))
        .thenThrow(StateError('Storage unavailable'));

    await expectLater(repository.clearSessionCookie(), throwsStateError);
    expect(await repository.readSessionCookie(), isNull);
    await expectLater(
      repository.confirmBinding(sixDigitCode: '123456', deviceName: 'Phone'),
      throwsA(isA<NfcPassJwtFailure>()),
    );
    when(() => oauth.initiateOAuthFlow()).thenThrow(StateError('Login closed'));
    await expectLater(
      repository.bindPass(),
      throwsA(isA<NfcPassLoginFailure>()),
    );
    expect(requests, isEmpty);
    expect(values['nfc_pass_id'], '42');
    verify(() => oauth.initiateOAuthFlow()).called(1);
    verifyNever(() => channel.clearPassId());

    await repository.setSessionCookie('replacement');
    expect(await repository.readSessionCookie(), 'replacement');
  });

  test('a clear invalidates queued session writes synchronously', () async {
    values['nfc_cookie'] = 'previous';
    final setter = repository.setSessionCookie('replacement');
    final result = expectLater(setter, throwsA(isA<NfcPassLoginFailure>()));
    await repository.clearSessionCookie();
    await result;
    expect(await repository.readSessionCookie(), isNull);
    expect(values['nfc_cookie'], isNull);
  });

  test('a new owned session survives delayed cleanup and process restart',
      () async {
    await repository.synchronizeSessionAccount('mirea:student-a');
    await repository.setSessionCookie('previous');
    values['nfc_jwt'] = 'previous-token';
    final deletionStarted = Completer<void>();
    final releaseDeletion = Completer<void>();
    when(() => storage.delete(key: 'nfc_cookie')).thenAnswer((_) async {
      deletionStarted.complete();
      await releaseDeletion.future;
      values.remove('nfc_cookie');
    });

    final clearing = repository.clearSessionCookie();
    await deletionStarted.future;
    var saved = false;
    final saving = repository.setSessionCookie('replacement').then((_) {
      saved = true;
    });
    await Future<void>.delayed(Duration.zero);
    expect(saved, isFalse);
    expect(values['nfc_cookie'], 'previous');
    expect(values['nfc_jwt'], 'previous-token');
    expect(values['nfc_session_account'], '');

    releaseDeletion.complete();
    await Future.wait([clearing, saving]);
    expect(values['nfc_cookie'], 'replacement');
    expect(values['nfc_jwt'], isNull);
    expect(values['nfc_session_account'], 'mirea:student-a');

    repository = createRepository();
    await repository.synchronizeSessionAccount('mirea:student-a');
    expect(await repository.readSessionCookie(), 'replacement');
    expect(values['nfc_jwt'], isNull);
    verifyNever(() => oauth.initiateOAuthFlow());
  });

  test('a failed clear still invalidates an in-flight token response',
      () async {
    values['nfc_cookie'] = 'previous';
    final started = Completer<void>();
    final token = Completer<http.Response>();
    handler = (_) async {
      started.complete();
      return token.future;
    };
    final binding = repository.bindPass();
    final result = expectLater(binding, throwsA(isA<NfcPassLoginFailure>()));
    await started.future;
    when(() => storage.delete(key: 'nfc_cookie'))
        .thenThrow(StateError('Storage unavailable'));
    await expectLater(repository.clearSessionCookie(), throwsStateError);
    token.complete(_response([10, 3, ...ascii.encode('jwt')]));
    await result;
    expect(await repository.readSessionCookie(), isNull);
    expect(values['nfc_jwt'], isNull);
    expect(requests.map((request) => request.url.path), ['/token']);
  });

  test('reuses a stored session and sends exactly one verification', () async {
    values['nfc_cookie'] = 'session';
    await repository.bindPass();

    expect(requests.map((request) => request.url.path), ['/token', '/send']);
    expect(requests.last.headers['cookie'], '.AspNetCore.Cookies=session');
    expect(values['nfc_jwt'], 'jwt');
    verifyNever(() => oauth.initiateOAuthFlow());
    verifyNever(() => channel.savePassId(any()));
  });

  test('a cooldown response is not a sent code and prevents another send',
      () async {
    values['nfc_cookie'] = 'session';
    handler = (request) async => request.url.path == '/token'
        ? _response([10, 3, ...ascii.encode('jwt')])
        : _response([18, 6, 8, 128, 164, 167, 218, 6]);

    expect(await repository.bindPass(), isA<NfcVerificationCooldown>());
    expect(await repository.bindPass(), isA<NfcVerificationCooldown>());
    expect(requests.map((request) => request.url.path), ['/token', '/send']);
    expect(values['nfc_cookie'], 'session');
    verifyNever(() => channel.savePassId(any()));
  });

  test('a successful send also enforces the server retry timestamp', () async {
    values['nfc_cookie'] = 'session';
    handler = (request) async => request.url.path == '/token'
        ? _response([10, 3, ...ascii.encode('jwt')])
        : _response([10, 8, 10, 6, 8, 128, 164, 167, 218, 6]);

    expect(await repository.bindPass(), isA<NfcVerificationCodeSent>());
    expect(await repository.bindPass(), isA<NfcVerificationCooldown>());
    expect(requests.length, 2);

    await repository.setSessionCookie('replacement');
    expect(await repository.bindPass(), isA<NfcVerificationCodeSent>());
    expect(requests.length, 4);
  });

  test('an unavailable verification method keeps the bound native pass',
      () async {
    values.addAll({'nfc_cookie': 'session', 'nfc_pass_id': '42'});
    handler = (request) async => request.url.path == '/token'
        ? _response([10, 3, ...ascii.encode('jwt')])
        : _response([26, 0]);

    expect(await repository.bindPass(), isA<NfcVerificationUnavailable>());
    expect(values['nfc_pass_id'], '42');
    expect(values['nfc_cookie'], 'session');
    verifyNever(() => channel.clearPassId());
  });

  for (final (payload, failure) in [
    ([18, 0], NfcVerificationFailure.wrongCode),
    ([26, 0], NfcVerificationFailure.nfcError),
  ]) {
    test('a ${failure.name} response never saves or replays a pass', () async {
      values.addAll({'nfc_cookie': 'session', 'nfc_jwt': 'jwt'});
      handler = (_) async => _response(payload);

      await expectLater(
        repository.confirmBinding(sixDigitCode: '123456', deviceName: 'Phone'),
        throwsA(
          isA<NfcPassVerificationFailure>().having(
            (error) => error.reason,
            'reason',
            failure,
          ),
        ),
      );
      expect(requests.length, 1);
      expect(values['nfc_pass_id'], isNull);
      expect(values['nfc_cookie'], 'session');
      verifyNever(() => channel.savePassId(any()));
    });
  }

  test('an unknown send outcome fails without claiming success or retrying',
      () async {
    values['nfc_cookie'] = 'session';
    handler = (request) async => request.url.path == '/token'
        ? _response([10, 3, ...ascii.encode('jwt')])
        : _response([34, 0]);

    await expectLater(
      repository.bindPass(),
      throwsA(isA<NfcPassSendCodeFailure>()),
    );
    expect(requests.length, 2);
    expect(values['nfc_pass_id'], isNull);
  });

  test('coalesces concurrent binding requests into one email', () async {
    values['nfc_cookie'] = 'session';
    final token = Completer<http.Response>();
    handler = (request) async =>
        request.url.path == '/token' ? token.future : _response([10, 0]);

    final first = repository.bindPass();
    final second = repository.bindPass();
    token.complete(_response([10, 3, ...ascii.encode('jwt')]));
    await Future.wait([first, second]);

    expect(requests.map((request) => request.url.path), ['/token', '/send']);
  });

  for (final grpcAuth in [true, false]) {
    test('recovers an expired ${grpcAuth ? 'gRPC' : 'HTTP'} session once',
        () async {
      values['nfc_cookie'] = 'expired';
      handler = (request) async {
        if (request.headers['cookie'] == '.AspNetCore.Cookies=expired') {
          return grpcAuth ? _response([], status: 16) : http.Response('', 401);
        }
        return request.url.path == '/token'
            ? _response([10, 3, ...ascii.encode('jwt')])
            : _response([10, 0]);
      };

      await repository.bindPass();

      expect(requests.map((request) => request.url.path), [
        '/token',
        '/token',
        '/send',
      ]);
      verify(() => oauth.initiateOAuthFlow()).called(1);
    });
  }

  test('does not loop when the replacement session is also rejected', () async {
    values['nfc_cookie'] = 'expired';
    handler = (_) async => _response([], status: 16);
    await expectLater(repository.bindPass(), throwsA(isA<NfcPassJwtFailure>()));
    expect(requests.map((request) => request.url.path), ['/token', '/token']);
    verify(() => oauth.initiateOAuthFlow()).called(1);
  });

  test('does not open OAuth for permissions or transient read errors',
      () async {
    for (final status in [7, 14]) {
      values['nfc_cookie'] = 'session';
      handler = (_) async => _response([], status: status);
      await expectLater(
        repository.bindPass(),
        throwsA(isA<NfcPassJwtFailure>()),
      );
    }
    expect(requests.length, 2);
    verifyNever(() => oauth.initiateOAuthFlow());
  });

  test('never retries a rejected verification-code send', () async {
    values['nfc_cookie'] = 'session';
    handler = (request) async => request.url.path == '/token'
        ? _response([10, 3, ...ascii.encode('jwt')])
        : _response([], status: 16);

    await expectLater(
      repository.bindPass(),
      throwsA(isA<NfcPassSendCodeFailure>()),
    );
    expect(requests.map((request) => request.url.path), ['/token', '/send']);
    verifyNever(() => oauth.initiateOAuthFlow());
  });

  test('invalidates a late token response after the session changes', () async {
    values['nfc_cookie'] = 'first';
    final started = Completer<void>();
    final token = Completer<http.Response>();
    handler = (_) async {
      started.complete();
      return token.future;
    };
    final binding = repository.bindPass();
    final result = expectLater(binding, throwsA(isA<NfcPassLoginFailure>()));
    await started.future;
    await repository.setSessionCookie('second');
    token.complete(_response([10, 3, ...ascii.encode('jwt')]));
    await result;

    expect(values['nfc_cookie'], 'second');
    expect(values['nfc_jwt'], isNull);
    expect(requests.map((request) => request.url.path), ['/token']);
  });

  test('does not restore an OAuth session after it was cleared', () async {
    final started = Completer<void>();
    final login = Completer<LoginSuccessData>();
    when(() => oauth.initiateOAuthFlow()).thenAnswer((_) {
      started.complete();
      return login.future;
    });
    final binding = repository.bindPass();
    final result = expectLater(binding, throwsA(isA<NfcPassLoginFailure>()));
    await started.future;
    await repository.clearSessionCookie();
    login
        .complete(LoginSuccessData(allCookies: {'.AspNetCore.Cookies': 'old'}));
    await result;

    expect(values['nfc_cookie'], isNull);
    expect(requests, isEmpty);
  });

  test('never saves a pass returned after a session switch', () async {
    values
        .addAll({'nfc_cookie': 'first', 'nfc_jwt': 'jwt', 'nfc_pass_id': '11'});
    final started = Completer<void>();
    final pass = Completer<http.Response>();
    handler = (_) async {
      started.complete();
      return pass.future;
    };
    final binding = repository.confirmBinding(
      sixDigitCode: '123456',
      deviceName: 'Phone',
    );
    final result = expectLater(binding, throwsA(isA<NfcPassLoginFailure>()));
    await started.future;
    await repository.setSessionCookie('second');
    pass.complete(_response([10, 2, 8, 42]));
    await result;

    expect(values['nfc_pass_id'], '11');
    verifyNever(() => channel.savePassId(any()));
    expect(requests.length, 1);
  });

  test('persists and mirrors a pass from the same authenticated session',
      () async {
    values.addAll({'nfc_cookie': 'session', 'nfc_jwt': 'jwt'});
    expect(
      await repository.confirmBinding(
        sixDigitCode: '123456',
        deviceName: 'Phone',
      ),
      42,
    );
    expect(values['nfc_pass_id'], '42');
    verify(() => channel.savePassId(42)).called(1);
  });

  test('coalesces identical confirmations and rejects conflicting ones',
      () async {
    values.addAll({'nfc_cookie': 'session', 'nfc_jwt': 'jwt'});
    final pass = Completer<http.Response>();
    handler = (_) => pass.future;
    final first = repository.confirmBinding(
      sixDigitCode: '123456',
      deviceName: 'Phone',
    );
    final second = repository.confirmBinding(
      sixDigitCode: '123456',
      deviceName: 'Phone',
    );
    await expectLater(
      repository.confirmBinding(sixDigitCode: '654321', deviceName: 'Phone'),
      throwsA(isA<NfcPassGetPassFailure>()),
    );
    pass.complete(_response([10, 2, 8, 42]));
    expect(await Future.wait([first, second]), [42, 42]);
    expect(requests.length, 1);
    verify(() => channel.savePassId(42)).called(1);
  });

  test('restores the previous pass when logout interrupts a local pass write',
      () async {
    values.addAll(
      {'nfc_cookie': 'session', 'nfc_jwt': 'jwt', 'nfc_pass_id': '11'},
    );
    final started = Completer<void>();
    final written = Completer<void>();
    when(() => storage.write(key: 'nfc_pass_id', value: '42'))
        .thenAnswer((_) async {
      started.complete();
      await written.future;
      values['nfc_pass_id'] = '42';
    });
    final confirmation = repository.confirmBinding(
      sixDigitCode: '123456',
      deviceName: 'Phone',
    );
    final result =
        expectLater(confirmation, throwsA(isA<NfcPassLoginFailure>()));
    await started.future;
    final clearing = repository.clearSessionCookie();
    written.complete();
    await result;
    await clearing;
    expect(values['nfc_pass_id'], '11');
    verifyNever(() => channel.savePassId(any()));
    verifyNever(() => channel.clearPassId());
  });

  test('preserves all ASP.NET chunks in shared and OAuth sessions', () async {
    const cookie = '.AspNetCore.Cookies=chunks-2; '
        '.AspNetCore.CookiesC1=first; .AspNetCore.CookiesC2=second';
    await repository.setSessionCookie(cookie);
    await repository.bindPass();
    expect(requests.first.headers['cookie'], cookie);

    await repository.clearSessionCookie();
    requests.clear();
    when(() => oauth.initiateOAuthFlow()).thenAnswer(
      (_) async => LoginSuccessData(
        allCookies: {
          '.AspNetCore.Cookies': 'chunks-2',
          '.AspNetCore.CookiesC2': 'second',
          '.AspNetCore.CookiesC1': 'first',
          'unrelated': 'ignored',
        },
      ),
    );
    await repository.bindPass();
    expect(requests.first.headers['cookie'], cookie);
  });
}
