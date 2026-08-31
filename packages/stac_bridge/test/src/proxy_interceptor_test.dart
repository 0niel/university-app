import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/src/proxy_interceptor.dart';
import 'package:stac_bridge/stac_bridge.dart';

class ProxyInterceptorTest extends MiniAppHost {
  const ProxyInterceptorTest();

  @override
  FutureOr<void> openLocation(String location) => Future.value();

  @override
  FutureOr<void> openExternalUrl(Uri url) => Future.value();

  @override
  FutureOr<void> openPage({required String path, String? title}) =>
      Future.value();

  @override
  FutureOr<void> openMiniApp({required String slug, String? path}) =>
      Future.value();

  @override
  FutureOr<void> reload() => Future.value();

  @override
  FutureOr<void> setStorage(String key, Object? value) => Future.value();

  @override
  FutureOr<Map<String, double>?> getLocation() => null;

  @override
  FutureOr<String?> pickImage({required bool fromCamera}) => null;

  @override
  FutureOr<String?> scanCode() => null;

  @override
  void closeMiniApp() => ();
}

/// Captures the interceptor verdict for a given request.
class _Capture extends RequestInterceptorHandler {
  RequestOptions? passed;
  DioException? rejected;

  @override
  void next(RequestOptions requestOptions) => passed = requestOptions;

  @override
  void reject(
    DioException error, [
    bool callFollowingErrorInterceptor = false,
  ]) {
    rejected = error;
  }
}

void main() {
  final config = StacBridgeConfig(
    proxyUrl: 'https://ref.supabase.co/functions/v1/miniapp-proxy',
    organizationId: 'mirea',
    onAccessTokenRequested: () async => 'jwt-token',
  );
  const session = MiniAppSession(slug: 'poll', host: ProxyInterceptorTest());

  late MiniAppProxyInterceptor interceptor;

  setUp(() {
    interceptor = MiniAppProxyInterceptor(config: config);
  });

  tearDown(() => MiniAppSessionStack.pop(session));

  group('MiniAppProxyInterceptor', () {
    test('wraps a relative request into a proxy POST with the JWT', () async {
      MiniAppSessionStack.push(session);
      final capture = _Capture();

      await interceptor.onRequest(
        RequestOptions(
          path: '/api/vote',
          method: 'POST',
          data: {'option': 'pizza'},
          queryParameters: {'week': 24},
        ),
        capture,
      );

      final passed = capture.passed;
      expect(capture.rejected, isNull);
      expect(passed, isNotNull);
      expect(passed?.method, 'POST');
      expect(passed?.path, config.proxyUrl);
      expect(passed?.headers['Authorization'], 'Bearer jwt-token');
      expect(passed?.data, {
        'organizationId': 'mirea',
        'slug': 'poll',
        'kind': 'api',
        'path': '/api/vote',
        'method': 'POST',
        'query': {'week': '24'},
        'body': {'option': 'pizza'},
      });
    });

    test(
      'rejects absolute URLs — mini apps must stay behind the proxy',
      () async {
        MiniAppSessionStack.push(session);
        final capture = _Capture();

        await interceptor.onRequest(
          RequestOptions(path: 'https://evil.example.com/steal'),
          capture,
        );

        expect(capture.passed, isNull);
        expect(capture.rejected?.message, contains('relative paths'));
      },
    );

    test('rejects requests without an active mini app session', () async {
      final capture = _Capture();

      await interceptor.onRequest(RequestOptions(path: '/api'), capture);

      expect(capture.passed, isNull);
      expect(capture.rejected?.message, contains('No mini app session'));
    });
  });

  group('MiniAppSessionStack', () {
    test('current follows push/pop order', () {
      const other = MiniAppSession(slug: 'other', host: ProxyInterceptorTest());
      expect(MiniAppSessionStack.current, isNull);
      MiniAppSessionStack.push(session);
      MiniAppSessionStack.push(other);
      expect(MiniAppSessionStack.current?.slug, 'other');
      MiniAppSessionStack.pop(other);
      expect(MiniAppSessionStack.current?.slug, 'poll');
    });
  });
}
