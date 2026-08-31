import 'package:flutter_test/flutter_test.dart';
import 'package:web_oauth_interceptor_client/web_oauth_interceptor_client.dart';

class _TestInAppBrowser extends PlatformInAppBrowser {
  _TestInAppBrowser(super.params) : super.implementation();

  @override
  Future<void> close() async {}
}

class _TestInAppWebViewPlatform extends InAppWebViewPlatform {
  @override
  PlatformInAppBrowser createPlatformInAppBrowser(
    PlatformInAppBrowserCreationParams params,
  ) => _TestInAppBrowser(params);
}

void main() {
  setUpAll(() {
    InAppWebViewPlatform.instance = _TestInAppWebViewPlatform();
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
