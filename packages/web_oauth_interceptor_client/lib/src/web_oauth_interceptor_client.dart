import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class OAuthInAppBrowser extends InAppBrowser {

  OAuthInAppBrowser(this.expectedRedirectUrls);
  final List<String> expectedRedirectUrls;

  @override
  Future onLoadStart(WebUri? url) async {
    if (url != null && _isRedirectUrl(url.toString())) {
      _handleOAuthRedirect(url.toString());
    }
  }

  @override
  void onExit() {
    print('Browser closed!');
  }

  bool _isRedirectUrl(String url) {
    return expectedRedirectUrls.any((expectedUrl) => url.startsWith(expectedUrl));
  }

  Future<void> _handleOAuthRedirect(String url) async {
    final cookies = await CookieManager.instance().getCookies(url: WebUri(url));
    final token = _extractTokenFromUrl(url);
    final sessKey = cookies.firstWhereOrNull((cookie) => cookie.name == 'sesskey')?.value as String?;

    if (token != null && (sessKey ?? '').isNotEmpty) {
      print('Access token: $token');
      print('Session key: $sessKey');
    }
  }

  String? _extractTokenFromUrl(String url) {
    final uri = Uri.parse(url);
    return uri.queryParameters['access_token'];
  }
}

class WebOAuthInterceptorClient {

  WebOAuthInterceptorClient({
    required this.oauthUrl,
    required this.expectedRedirectUrls,
    this.buttonSelectors = const {},
    this.formSelectors = const {},
  });
  final String oauthUrl;
  final List<String> expectedRedirectUrls;
  final Map<String, String> buttonSelectors;
  final Map<String, String> formSelectors;

  Future<void> initiateOAuthFlow(BuildContext context) async {
    final browser = OAuthInAppBrowser(expectedRedirectUrls);

    await browser.openUrlRequest(
      urlRequest: URLRequest(url: WebUri(oauthUrl)),
      settings: InAppBrowserClassSettings(
        browserSettings: InAppBrowserSettings(),
        webViewSettings: InAppWebViewSettings(),
      ),
    );
  }
}
