import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:web_oauth_interceptor_client/src/auto_fill_config.dart';
import 'package:web_oauth_interceptor_client/src/login_success_data.dart';
import 'package:web_oauth_interceptor_client/src/oauth_redirect_matcher.dart';

class WebOAuthInterceptorClient extends InAppBrowser {
  WebOAuthInterceptorClient({
    required this.oauthUrl,
    required this.expectedRedirectUrls,
    required this.specialCookieName,
    this.autoFillConfig,
    this.onLoginSuccess,
    this.onLoginError,
    this.onBrowserExit,
    this.extraHeaders = const {},
    this.waitForSpecialCookie = false,
  }) {
    // Extract unique domains from expectedRedirectUrls
    for (final url in expectedRedirectUrls) {
      final uri = Uri.parse(url);
      _targetDomains.add(uri.origin);
    }

    // Also add the domain of oauthUrl
    final oauthUri = Uri.parse(oauthUrl);
    _targetDomains.add(oauthUri.origin);
  }

  /// URL to initiate the OAuth authorization process.
  final String oauthUrl;

  /// List of URLs to which a redirect can occur upon successful authorization.
  /// Typically, this is the `redirect_uri` in the OAuth flow.
  final List<String> expectedRedirectUrls;

  /// Name of the cookie to wait for, indicating successful authorization.
  /// Can be left empty if a cookie is not required.
  final String specialCookieName;

  /// Optional configuration for auto-filling username/password fields.
  final AutoFillConfig? autoFillConfig;

  /// Callback invoked upon successful authorization.
  /// Provides access token, all cookies, and the special cookie value.
  final void Function(LoginSuccessData)? onLoginSuccess;

  /// Callback invoked upon authorization error or any other failure.
  final void Function(String error)? onLoginError;

  /// Callback invoked when the user closes the browser.
  final VoidCallback? onBrowserExit;

  /// Additional headers to include when opening the page, if needed.
  final Map<String, String> extraHeaders;

  final bool waitForSpecialCookie;

  /// Set of target domains extracted from expectedRedirectUrls and oauthUrl.
  final Set<String> _targetDomains = {};
  var _didComplete = false;

  @override
  Future<void> onLoadStart(WebUri? url) async {
    super.onLoadStart(url);
    if (url == null) return;
    final currentUrl = url.toString();
    if (_isRedirectUrl(currentUrl)) {
      await _handleOAuthRedirect(currentUrl);
    }
  }

  @override
  Future<void> onLoadStop(WebUri? url) async {
    super.onLoadStop(url);
    if (url == null) return;

    await Future<void>.delayed(const Duration(milliseconds: 500));

    final currentUri = Uri.parse(url.toString());
    final currentDomain = currentUri.origin;

    final domainsToCheck = {..._targetDomains, currentDomain};

    var specialCookieFound = false;
    String? specialCookieValue;
    final allCookies = <String, String>{};

    for (final domain in domainsToCheck) {
      final domainUri = Uri.parse(domain);
      final domainCookies = await CookieManager.instance()
          .getCookies(url: WebUri(domainUri.toString()));
      for (final cookie in domainCookies) {
        final value = cookie.value;
        if (value is! String) continue;
        allCookies[cookie.name] = value;
        if (cookie.name == specialCookieName) {
          specialCookieFound = true;
          specialCookieValue = value;
        }
      }
    }

    if (specialCookieFound &&
        (!waitForSpecialCookie ||
            (specialCookieValue != null && specialCookieValue.isNotEmpty))) {
      await _completeSuccess(
        LoginSuccessData(
          allCookies: allCookies,
          specialCookieValue: specialCookieValue,
        ),
      );
      return;
    }

    if (autoFillConfig != null) {
      await _tryAutoFillForm();
    }
  }

  @override
  void onReceivedError(WebResourceRequest request, WebResourceError error) {
    super.onReceivedError(request, error);
    if (request.isForMainFrame == false) return;
    _reportError('Load error (${error.type}).');
  }

  @override
  void onReceivedHttpError(
    WebResourceRequest request,
    WebResourceResponse errorResponse,
  ) {
    super.onReceivedHttpError(request, errorResponse);
    if (request.isForMainFrame == false) return;
    final statusCode = errorResponse.statusCode;
    _reportError(
      statusCode == null ? 'HTTP error.' : 'HTTP error (status $statusCode).',
    );
  }

  @override
  void onExit() {
    super.onExit();
    if (!_didComplete) onBrowserExit?.call();
  }

  /// Checks if the given URL is one of the expected redirect URLs.
  bool _isRedirectUrl(String url) {
    return OAuthRedirectMatcher.matches(url, expectedRedirectUrls);
  }

  /// Handles the OAuth redirect by extracting tokens and cookies.
  Future<void> _handleOAuthRedirect(String url) async {
    try {
      final uri = Uri.parse(url);
      final cookies = await CookieManager.instance()
          .getCookies(url: WebUri(uri.toString()));

      final token = _extractTokenFromUrl(url);

      final specialCookie = cookies
          .firstWhereOrNull((cookie) => cookie.name == specialCookieName)
          ?.value;
      final specialCookieValue = specialCookie is String ? specialCookie : null;

      final isBasicSuccess = (token != null && token.isNotEmpty) ||
          (specialCookieValue != null && specialCookieValue.isNotEmpty);

      final isSpecialCookieValid = !waitForSpecialCookie ||
          (specialCookieValue != null && specialCookieValue.isNotEmpty);

      if (isBasicSuccess && isSpecialCookieValid) {
        final allCookies = <String, String>{};
        for (final cookie in cookies) {
          final value = cookie.value;
          if (value is String) allCookies[cookie.name] = value;
        }

        await _completeSuccess(
          LoginSuccessData(
            accessToken: token,
            allCookies: allCookies,
            specialCookieValue: specialCookieValue,
          ),
        );
      }
    } on Exception {
      _reportError('Unable to complete OAuth login.');
    }
  }

  String? _extractTokenFromUrl(String url) {
    final uri = Uri.parse(url);
    return uri.queryParameters['access_token'];
  }

  Future<void> _tryAutoFillForm() async {
    final config = autoFillConfig;
    if (config == null) return;

    final usernameSel = config.usernameSelector;
    final passwordSel = config.passwordSelector;
    final submitBtnSel = config.submitButtonSelector;
    final defaultUsername = config.defaultUsername;
    final defaultPassword = config.defaultPassword;

    if ((usernameSel == null || defaultUsername == null) &&
        (passwordSel == null || defaultPassword == null)) {
      return;
    }

    final jsBuffer = StringBuffer();

    if (usernameSel != null && defaultUsername != null) {
      _appendInputAssignment(jsBuffer, usernameSel, defaultUsername);
    }

    if (passwordSel != null && defaultPassword != null) {
      _appendInputAssignment(jsBuffer, passwordSel, defaultPassword);
    }

    config.additionalFields.forEach((selector, value) {
      _appendInputAssignment(jsBuffer, selector, value);
    });

    if (submitBtnSel != null) {
      jsBuffer.writeln('''
        (function() {
          const button = document.querySelector(${jsonEncode(submitBtnSel)});
          if (button) button.click();
        })();
      ''');
    }

    try {
      await webViewController?.evaluateJavascript(source: jsBuffer.toString());
    } on Exception {
      // Autofill is optional; the user can continue in the interactive browser.
    }
  }

  Future<void> _completeSuccess(LoginSuccessData successData) async {
    if (_didComplete) return;
    _didComplete = true;
    try {
      onLoginSuccess?.call(successData);
    } finally {
      await _closeSafely();
    }
  }

  void _reportError(String message) {
    if (_didComplete) return;
    _didComplete = true;
    onLoginError?.call(message);
    unawaited(_closeSafely());
  }

  Future<void> _closeSafely() async {
    try {
      await close();
    } on Exception {
      // A redirect can dispose the browser before this close operation runs.
    }
  }

  void _appendInputAssignment(
    StringBuffer buffer,
    String selector,
    String value,
  ) {
    buffer.writeln('''
      (function() {
        const input = document.querySelector(${jsonEncode(selector)});
        if (!input) return;
        input.value = ${jsonEncode(value)};
        input.dispatchEvent(new Event('input', { bubbles: true }));
        input.dispatchEvent(new Event('change', { bubbles: true }));
      })();
    ''');
  }
}

/// Client class to initiate and handle the OAuth interception process.
class OAuthInterceptorClient {
  const OAuthInterceptorClient({
    required this.oauthUrl,
    required this.expectedRedirectUrls,
    required this.specialCookieName,
    this.waitForSpecialCookie = false,
    this.extraHeaders = const {},
    this.autoFillConfig,
    this.onLoginSuccess,
    this.onLoginError,
    this.onBrowserExit,
  });

  /// URL to initiate the OAuth authorization process.
  final String oauthUrl;

  /// List of possible redirect URLs to determine the completion of OAuth.
  final List<String> expectedRedirectUrls;

  /// Name of the special cookie that signals success.
  final String specialCookieName;

  final bool waitForSpecialCookie;

  /// Additional headers to include in the request, if needed.
  final Map<String, String> extraHeaders;

  /// Configuration for auto-filling form fields.
  final AutoFillConfig? autoFillConfig;

  /// Callback upon successful login.
  /// Provides access token, all cookies, and the special cookie value.
  final void Function(LoginSuccessData)? onLoginSuccess;

  /// Callback upon an error during the login process.
  final void Function(String error)? onLoginError;

  /// Callback when the user closes the browser.
  final VoidCallback? onBrowserExit;

  Future<LoginSuccessData> initiateOAuthFlow() async {
    final completer = Completer<LoginSuccessData>();

    final browser = WebOAuthInterceptorClient(
      oauthUrl: oauthUrl,
      expectedRedirectUrls: expectedRedirectUrls,
      specialCookieName: specialCookieName,
      waitForSpecialCookie: waitForSpecialCookie,
      extraHeaders: extraHeaders,
      autoFillConfig: autoFillConfig,
      onLoginSuccess: completer.complete,
      onLoginError: (error) => completer.completeError(
        error,
        StackTrace.current,
      ),
      onBrowserExit: () {
        if (!completer.isCompleted) {
          completer.completeError(
            'Browser exited before login.',
            StackTrace.current,
          );
        }
      },
    );

    try {
      await browser.openUrlRequest(
        urlRequest: URLRequest(
          url: WebUri(oauthUrl),
          headers: extraHeaders,
        ),
        settings: InAppBrowserClassSettings(
          browserSettings: InAppBrowserSettings(),
          webViewSettings: InAppWebViewSettings(
            useShouldInterceptRequest: true,
          ),
        ),
      );
    } on Exception catch (_, stackTrace) {
      if (!completer.isCompleted) {
        completer.completeError('Unable to open OAuth browser.', stackTrace);
      }
    }

    return completer.future;
  }
}
