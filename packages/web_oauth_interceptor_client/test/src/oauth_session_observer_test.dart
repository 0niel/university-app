import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:web_oauth_interceptor_client/src/login_success_data.dart';
import 'package:web_oauth_interceptor_client/src/oauth_session_observer.dart';

const _authorizationUrl = 'https://pulse.example/api/auth/login';
const _callbackUrl = 'https://pulse.example/services';
const _sessionName = '.AspNetCore.Cookies';

void main() {
  testWidgets('reads the full callback path for a path-scoped cookie', (
    tester,
  ) async {
    final requested = <Uri>[];
    final harness = _SessionHarness(
      readCookies: (uri) async {
        requested.add(uri);
        return uri.path == '/services'
            ? {_sessionName: 'path-scoped-session'}
            : {};
      },
    );
    addTearDown(harness.observer.close);

    await harness.observer.observe(
      '$_callbackUrl?code=provider-code',
      loaded: true,
    );

    expect(requested.single.path, '/services');
    expect(requested.single.queryParameters, {'code': 'provider-code'});
    expect(harness.results.single.specialCookieValue, 'path-scoped-session');
    expect(harness.errors, 0);
  });

  testWidgets('a loaded history update completes on the trusted provider', (
    tester,
  ) async {
    var reads = 0;
    final harness = _SessionHarness(
      readCookies: (_) async {
        reads++;
        return {_sessionName: 'history-session'};
      },
    );
    addTearDown(harness.observer.close);

    await harness.observer.observe(_authorizationUrl, loaded: true);
    expect(reads, 0);
    expect(harness.results, isEmpty);

    await harness.observer.observe(
      'https://pulse.example/services/dashboard',
      loaded: true,
    );

    expect(harness.results.single.specialCookieValue, 'history-session');
    expect(harness.errors, 0);
  });

  for (final name in ['Pulse.Auth.Cookie', _sessionName]) {
    testWidgets('accepts the configured Pulse cookie family $name', (
      tester,
    ) async {
      final harness = _SessionHarness(
        specialCookieName: 'Pulse.Auth.Cookie',
        fallbackSpecialCookieNames: const [_sessionName],
        readCookies: (_) async => {name: 'session'},
      );
      addTearDown(harness.observer.close);

      await harness.observer.observe(_callbackUrl, loaded: true);

      expect(harness.results.single.specialCookieValue, 'session');
      expect(harness.results.single.allCookies[name], 'session');
      expect(harness.errors, 0);
    });
  }

  testWidgets('prefers the current Pulse cookie when both names are present', (
    tester,
  ) async {
    final harness = _SessionHarness(
      specialCookieName: 'Pulse.Auth.Cookie',
      fallbackSpecialCookieNames: const [_sessionName],
      readCookies: (_) async => {
        'Pulse.Auth.Cookie': 'current',
        _sessionName: 'legacy',
      },
    );
    addTearDown(harness.observer.close);

    await harness.observer.observe(_callbackUrl, loaded: true);

    expect(harness.results.single.specialCookieValue, 'current');
  });

  testWidgets('ignores a stale cookie before the callback has committed', (
    tester,
  ) async {
    var cookie = 'stale-session';
    var reads = 0;
    final harness = _SessionHarness(
      readCookies: (_) async {
        reads++;
        return {_sessionName: cookie};
      },
    );
    addTearDown(harness.observer.close);

    await harness.observer.observe(_callbackUrl);
    await tester.pump(const Duration(milliseconds: 500));
    expect(reads, 0);
    expect(harness.results, isEmpty);
    cookie = 'committed-session';
    await harness.observer.observe(_callbackUrl, loaded: true);

    expect(harness.results.single.specialCookieValue, 'committed-session');
    expect(reads, 1);
  });

  testWidgets('waits for current Pulse chunks instead of reusing legacy auth', (
    tester,
  ) async {
    var ready = false;
    final harness = _SessionHarness(
      specialCookieName: 'Pulse.Auth.Cookie',
      fallbackSpecialCookieNames: const [_sessionName],
      readCookies: (uri) async => uri.path == '/services'
          ? {
              'Pulse.Auth.Cookie': 'chunks-2',
              'Pulse.Auth.CookieC1': 'first',
              if (ready) 'Pulse.Auth.CookieC2': 'second',
              _sessionName: 'legacy',
            }
          : {_sessionName: 'legacy'},
    );
    addTearDown(harness.observer.close);

    await harness.observer.observe(_callbackUrl, loaded: true);
    expect(harness.results, isEmpty);
    ready = true;
    await tester.pump(const Duration(milliseconds: 500));

    expect(harness.results.single.specialCookieValue, 'chunks-2');
    expect(harness.results.single.allCookies['Pulse.Auth.CookieC2'], 'second');
  });

  testWidgets('does not accept similarly named or unrelated provider cookies', (
    tester,
  ) async {
    final harness = _SessionHarness(
      specialCookieName: 'Pulse.Auth.Cookie',
      fallbackSpecialCookieNames: const [_sessionName],
      readCookies: (_) async => {
        'Pulse.Auth.Cookie.evil': 'untrusted',
        '.AspNetCore.Cookies.evil': 'untrusted',
        '__ddg1_': 'unrelated',
      },
    );
    addTearDown(harness.observer.close);

    await harness.observer.observe(_callbackUrl, loaded: true);
    await tester.pump(const Duration(seconds: 1));

    expect(harness.results, isEmpty);
    expect(harness.errors, 0);
    harness.observer.close();
  });

  testWidgets('rechecks a session that appears after the first 500 ms', (
    tester,
  ) async {
    var ready = false;
    final harness = _SessionHarness(
      readCookies: (_) async => ready ? {_sessionName: 'late-session'} : {},
    );
    addTearDown(harness.observer.close);

    await harness.observer.observe(_callbackUrl, loaded: true);
    await tester.pump(const Duration(milliseconds: 500));
    expect(harness.results, isEmpty);

    ready = true;
    await tester.pump(const Duration(milliseconds: 500));

    expect(harness.results.single.specialCookieValue, 'late-session');
    expect(harness.errors, 0);
  });

  testWidgets('waits for every ASP.NET session chunk in one cookie read', (
    tester,
  ) async {
    var cookies = {_sessionName: 'chunks-2', '${_sessionName}C1': 'first'};
    final harness = _SessionHarness(readCookies: (_) async => cookies);
    addTearDown(harness.observer.close);

    await harness.observer.observe(_callbackUrl, loaded: true);
    await tester.pump(const Duration(milliseconds: 500));
    expect(harness.results, isEmpty);

    cookies = {
      _sessionName: 'chunks-2',
      '${_sessionName}C1': 'first',
      '${_sessionName}C2': 'second',
    };
    await tester.pump(const Duration(milliseconds: 500));

    expect(harness.results.single.allCookies, cookies);
    expect(harness.errors, 0);
  });

  testWidgets('completes once across repeated callbacks and polling', (
    tester,
  ) async {
    var reads = 0;
    final harness = _SessionHarness(
      readCookies: (_) async {
        reads++;
        return {_sessionName: 'session'};
      },
    );
    addTearDown(harness.observer.close);

    await harness.observer.observe(_callbackUrl);
    await harness.observer.observe(_callbackUrl, loaded: true);
    await tester.pump(const Duration(seconds: 30));

    expect(harness.results, hasLength(1));
    expect(reads, 1);
    expect(harness.errors, 0);
  });

  testWidgets('discards stale chunks after a session becomes unchunked', (
    tester,
  ) async {
    final harness = _SessionHarness(
      readCookies: (_) async => {
        _sessionName: 'new-session',
        '${_sessionName}C1': 'obsolete-chunk',
        'preference': 'retained',
      },
    );
    addTearDown(harness.observer.close);

    await harness.observer.observe(_callbackUrl, loaded: true);

    expect(harness.results.single.allCookies, {
      _sessionName: 'new-session',
      'preference': 'retained',
    });
    expect(harness.errors, 0);
  });

  testWidgets('retains only the declared chunks when a session shrinks', (
    tester,
  ) async {
    final harness = _SessionHarness(
      readCookies: (_) async => {
        _sessionName: 'chunks-1',
        '${_sessionName}C1': 'current-chunk',
        '${_sessionName}C2': 'obsolete-chunk',
        'preference': 'retained',
      },
    );
    addTearDown(harness.observer.close);

    await harness.observer.observe(_callbackUrl, loaded: true);

    expect(harness.results.single.allCookies, {
      _sessionName: 'chunks-1',
      '${_sessionName}C1': 'current-chunk',
      'preference': 'retained',
    });
    expect(harness.errors, 0);
  });

  testWidgets('a token-only callback works across different provider origins', (
    tester,
  ) async {
    final harness = _SessionHarness(
      oauthUrl: 'https://login.example/authorize',
      expectedRedirectUrls: const ['https://application.example/complete'],
      specialCookieName: '',
      readCookies: (_) async => {},
    );
    addTearDown(harness.observer.close);

    await harness.observer.observe(
      'https://application.example/complete?access_token=callback-token',
    );

    expect(harness.results.single.accessToken, 'callback-token');
    expect(harness.results.single.specialCookieValue, isNull);
    expect(harness.results.single.allCookies, isEmpty);
    expect(harness.errors, 0);
  });

  testWidgets(
      'waitForSpecialCookie requires a cookie beside the callback token', (
    tester,
  ) async {
    var ready = false;
    final harness = _SessionHarness(
      oauthUrl: 'https://login.example/authorize',
      expectedRedirectUrls: const ['https://application.example/complete'],
      waitForSpecialCookie: true,
      readCookies: (uri) async => ready && uri.host == 'application.example'
          ? {_sessionName: 'application-session'}
          : {},
    );
    addTearDown(harness.observer.close);

    await harness.observer.observe(
      'https://application.example/complete?access_token=callback-token',
      loaded: true,
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(harness.results, isEmpty);

    ready = true;
    await tester.pump(const Duration(milliseconds: 500));

    expect(harness.results.single.accessToken, 'callback-token');
    expect(harness.results.single.specialCookieValue, 'application-session');
    expect(harness.errors, 0);
  });

  testWidgets('closing during a cookie read ignores its result and timers', (
    tester,
  ) async {
    final cookies = Completer<Map<String, String>>();
    var reads = 0;
    final harness = _SessionHarness(
      readCookies: (_) {
        reads++;
        return cookies.future;
      },
    );
    addTearDown(harness.observer.close);

    final pending = harness.observer.observe(_callbackUrl, loaded: true);
    await tester.pump();
    expect(reads, 1);

    harness.observer.close();
    cookies.complete({_sessionName: 'session-after-close'});
    await pending;
    await tester.pump(const Duration(seconds: 30));

    expect(harness.results, isEmpty);
    expect(harness.errors, 0);
    expect(reads, 1);
  });

  testWidgets('never reads or accepts a cookie from an untrusted origin', (
    tester,
  ) async {
    final requested = <Uri>[];
    final harness = _SessionHarness(
      readCookies: (uri) async {
        requested.add(uri);
        return {_sessionName: 'session'};
      },
    );
    addTearDown(harness.observer.close);

    await harness.observer.observe(
      'https://pulse.example.attacker.invalid/services',
      loaded: true,
    );
    await tester.pump(const Duration(seconds: 1));

    expect(requested, isEmpty);
    expect(harness.results, isEmpty);
    expect(harness.errors, 0);

    await harness.observer.observe(_callbackUrl, loaded: true);
    expect(harness.results, hasLength(1));
    expect(requested.single.host, 'pulse.example');
  });

  testWidgets('retries transient cookie reads without failing the login', (
    tester,
  ) async {
    var failing = true;
    final harness = _SessionHarness(
      readCookies: (_) async {
        if (failing) throw Exception('Cookie store temporarily unavailable');
        return {_sessionName: 'recovered-session'};
      },
    );
    addTearDown(harness.observer.close);

    await harness.observer.observe(_callbackUrl, loaded: true);
    expect(harness.results, isEmpty);
    expect(harness.errors, 0);

    failing = false;
    await tester.pump(const Duration(milliseconds: 500));

    expect(harness.results.single.specialCookieValue, 'recovered-session');
    expect(harness.errors, 0);
  });

  testWidgets('an empty expected callback times out once and stops polling', (
    tester,
  ) async {
    var reads = 0;
    final harness = _SessionHarness(
      readCookies: (_) async {
        reads++;
        return {};
      },
      redirectTimeout: const Duration(seconds: 2),
    );
    addTearDown(harness.observer.close);

    await harness.observer.observe(_callbackUrl, loaded: true);
    await tester.pump(const Duration(seconds: 2));
    final readsAtTimeout = reads;
    await tester.pump(const Duration(seconds: 5));

    expect(harness.results, isEmpty);
    expect(harness.errors, 1);
    expect(reads, readsAtTimeout);
  });

  testWidgets('navigation to the identity provider invalidates a pending read',
      (
    tester,
  ) async {
    final cookies = Completer<Map<String, String>>();
    final harness = _SessionHarness(readCookies: (_) => cookies.future);
    addTearDown(harness.observer.close);

    final callback = harness.observer.observe(_callbackUrl, loaded: true);
    await tester.pump();
    final identityProvider = harness.observer.observe(
      'https://identity.example/sign-in',
      loaded: true,
    );
    await tester.pump();
    cookies.complete({_sessionName: 'stale-session'});
    await Future.wait([callback, identityProvider]);
    await tester.pump(const Duration(seconds: 25));

    expect(harness.results, isEmpty);
    expect(harness.errors, 0);
    harness.observer.close();
  });
}

class _SessionHarness {
  factory _SessionHarness({
    required Future<Map<String, String>> Function(Uri) readCookies,
    Duration redirectTimeout = const Duration(seconds: 20),
    String oauthUrl = _authorizationUrl,
    List<String> expectedRedirectUrls = const [_callbackUrl],
    String specialCookieName = _sessionName,
    bool waitForSpecialCookie = false,
    List<String> fallbackSpecialCookieNames = const [],
  }) {
    final results = <LoginSuccessData>[];
    final errors = <Object?>[];
    final observer = OAuthSessionObserver(
      oauthUrl: oauthUrl,
      expectedRedirectUrls: expectedRedirectUrls,
      specialCookieName: specialCookieName,
      waitForSpecialCookie: waitForSpecialCookie,
      fallbackSpecialCookieNames: fallbackSpecialCookieNames,
      readCookies: readCookies,
      onSuccess: results.add,
      onError: () => errors.add(null),
      redirectTimeout: redirectTimeout,
    );
    return _SessionHarness._(observer, results, errors);
  }

  const _SessionHarness._(this.observer, this.results, this._errors);

  final OAuthSessionObserver observer;
  final List<LoginSuccessData> results;
  final List<Object?> _errors;

  int get errors => _errors.length;
}
