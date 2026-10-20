import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web_oauth_interceptor_client/web_oauth_interceptor_client.dart';

class TestInAppBrowser extends PlatformInAppBrowser {
  TestInAppBrowser(super.params, this.owner) : super.implementation();

  final TestInAppWebViewPlatform owner;

  @override
  PlatformInAppWebViewController? get webViewController => owner.controller;

  @override
  Future<void> openUrlRequest({
    required URLRequest urlRequest,
    Object? options,
    InAppBrowserClassSettings? settings,
  }) async {
    if (owner.failOpening) throw Exception('Opening failed');
  }

  @override
  Future<void> close() async {
    owner.closes++;
    if (owner.closing case final closing?) await closing.future;
    eventHandler?.onExit();
  }
}

class _TestCookies extends PlatformCookieManager {
  _TestCookies(super.params, this.owner) : super.implementation();

  final TestInAppWebViewPlatform owner;

  @override
  Future<List<Cookie>> getCookies({
    required WebUri url,
    PlatformInAppWebViewController? iosBelow11WebViewController,
    PlatformInAppWebViewController? webViewController,
  }) {
    owner.cookieController = webViewController;
    return owner.onReadCookies(url);
  }
}

class _WebViewController extends Mock
    implements PlatformInAppWebViewController {}

class TestInAppWebViewPlatform extends InAppWebViewPlatform {
  Future<List<Cookie>> Function(WebUri) onReadCookies = (_) async => [];
  TestInAppBrowser? browser;
  PlatformInAppWebViewController? controller;
  PlatformInAppWebViewController? cookieController;
  Completer<void>? closing;
  int closes = 0;
  bool failOpening = false;

  @override
  PlatformInAppBrowser createPlatformInAppBrowser(
    PlatformInAppBrowserCreationParams params,
  ) =>
      browser = TestInAppBrowser(params, this);

  @override
  PlatformCookieManager createPlatformCookieManager(
    PlatformCookieManagerCreationParams params,
  ) =>
      _TestCookies(params, this);
}

void main() {
  final platform = TestInAppWebViewPlatform();
  setUpAll(() {
    InAppWebViewPlatform.instance = platform;
  });
  setUp(() {
    platform
      ..closes = 0
      ..closing = null
      ..controller = _WebViewController()
      ..cookieController = null
      ..failOpening = false
      ..onReadCookies = (_) async => [];
  });

  const loginUrl = 'https://pulse.example/api/auth/login';
  const returnUrl = 'https://pulse.example/services';
  OAuthInterceptorClient client() => const OAuthInterceptorClient(
        oauthUrl: loginUrl,
        expectedRedirectUrls: [returnUrl],
        specialCookieName: '.AspNetCore.Cookies',
      );

  WebOAuthInterceptorClient handler() =>
      platform.browser!.eventHandler! as WebOAuthInterceptorClient;

  testWidgets('native history callback returns the session and closes once', (
    tester,
  ) async {
    final paths = <String>[];
    platform.onReadCookies = (url) async {
      paths.add(url.path);
      return [Cookie(name: '.AspNetCore.Cookies', value: 'provider-session')];
    };
    final login = client().initiateOAuthFlow();
    await tester.pump();
    final browser = handler();
    await browser.onUpdateVisitedHistory(WebUri(returnUrl), false);
    expect((await login).specialCookieValue, 'provider-session');
    await browser.onLoadStop(WebUri(returnUrl));
    await tester.pump();
    expect(paths, ['/services']);
    expect(platform.cookieController, same(platform.controller));
    expect(platform.closes, 1);
  });

  testWidgets('late cookie returns without another document navigation', (
    tester,
  ) async {
    var ready = false;
    platform.onReadCookies = (_) async => ready
        ? [Cookie(name: '.AspNetCore.Cookies', value: 'late-session')]
        : [];
    final login = client().initiateOAuthFlow();
    var returned = false;
    unawaited(login.then((_) => returned = true));
    await tester.pump();
    await handler().onLoadStop(WebUri(returnUrl));
    await tester.pump(const Duration(seconds: 1));
    expect(returned, isFalse);
    ready = true;
    await tester.pump(const Duration(milliseconds: 500));
    expect((await login).specialCookieValue, 'late-session');
    expect(platform.closes, 1);
  });

  for (final name in ['Pulse.Auth.Cookie', '.AspNetCore.Cookies']) {
    testWidgets('the browser returns and closes for Pulse cookie $name', (
      tester,
    ) async {
      platform.onReadCookies = (_) async => [
            Cookie(name: name, value: 'provider-session', isHttpOnly: true),
          ];
      final login = const OAuthInterceptorClient(
        oauthUrl: loginUrl,
        expectedRedirectUrls: [returnUrl],
        specialCookieName: 'Pulse.Auth.Cookie',
        fallbackSpecialCookieNames: ['.AspNetCore.Cookies'],
      ).initiateOAuthFlow();
      await tester.pump();

      await handler().onLoadStop(WebUri(returnUrl));

      expect((await login).specialCookieValue, 'provider-session');
      expect(platform.closes, 1);
    });
  }

  testWidgets('exiting cancels the flow and ignores a pending cookie read', (
    tester,
  ) async {
    final cookies = Completer<List<Cookie>>();
    platform.onReadCookies = (_) => cookies.future;
    final login = client().initiateOAuthFlow();
    final cancelled = expectLater(login, throwsA(isA<OAuthFlowCancelled>()));
    await tester.pump();
    final browser = handler();
    final loaded = browser.onLoadStop(WebUri(returnUrl));
    browser.onExit();
    await cancelled;
    cookies.complete([
      Cookie(name: '.AspNetCore.Cookies', value: 'cancelled-session'),
    ]);
    await loaded;
    await tester.pump(const Duration(seconds: 30));
    expect(platform.closes, 0);
  });

  testWidgets('opening errors propagate while browser cleanup is pending', (
    tester,
  ) async {
    platform
      ..failOpening = true
      ..closing = Completer<void>();
    await expectLater(
      client().initiateOAuthFlow(),
      throwsA('Unable to open OAuth browser.'),
    );
    expect(platform.closes, 1);
    platform.closing!.complete();
    await tester.pump();
  });

  test('ignores HTTP failures from subresources', () {
    String? reportedError;
    WebOAuthInterceptorClient(
      oauthUrl: 'https://login.example.com',
      expectedRedirectUrls: const ['https://app.example.com/services'],
      specialCookieName: 'session',
      onLoginError: (error) => reportedError = error,
    ).onReceivedHttpError(
      WebResourceRequest(
        url: WebUri('https://login.example.com/favicon.ico'),
        isForMainFrame: false,
      ),
      WebResourceResponse(statusCode: 404),
    );

    expect(reportedError, isNull);
  });

  test('reports HTTP failures from the main frame', () {
    String? reportedError;
    WebOAuthInterceptorClient(
      oauthUrl: 'https://login.example.com',
      expectedRedirectUrls: const ['https://app.example.com/services'],
      specialCookieName: 'session',
      onLoginError: (error) => reportedError = error,
    ).onReceivedHttpError(
      WebResourceRequest(
        url: WebUri('https://login.example.com'),
        isForMainFrame: true,
      ),
      WebResourceResponse(statusCode: 503),
    );

    expect(reportedError, 'HTTP error (status 503).');
  });
}
