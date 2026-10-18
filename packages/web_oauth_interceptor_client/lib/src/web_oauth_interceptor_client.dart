import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:web_oauth_interceptor_client/src/auto_fill_config.dart';
import 'package:web_oauth_interceptor_client/src/login_success_data.dart';
import 'package:web_oauth_interceptor_client/src/oauth_session_observer.dart';

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
    _session = OAuthSessionObserver(
      oauthUrl: oauthUrl,
      expectedRedirectUrls: expectedRedirectUrls,
      specialCookieName: specialCookieName,
      waitForSpecialCookie: waitForSpecialCookie,
      readCookies: _readCookies,
      onSuccess: (result) => unawaited(_completeSuccess(result)),
      onError: () => _reportError('Unable to complete OAuth login.'),
    );
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

  late final OAuthSessionObserver _session;
  var _didComplete = false;

  @override
  Future<void> onLoadStart(WebUri? url) async {
    super.onLoadStart(url);
    if (url == null) return;
    await _session.observe(url.toString());
  }

  @override
  Future<void> onLoadStop(WebUri? url) async {
    super.onLoadStop(url);
    if (url == null || _didComplete) return;
    await _session.observe(url.toString(), loaded: true);
    if (!_didComplete && autoFillConfig != null) {
      await _tryAutoFillForm();
    }
  }

  @override
  Future<void> onUpdateVisitedHistory(WebUri? url, bool? isReload) async {
    super.onUpdateVisitedHistory(url, isReload);
    if (url == null || _didComplete) return;
    await _session.observe(url.toString(), loaded: true);
  }

  Future<Map<String, String>> _readCookies(Uri uri) async {
    final cookies =
        await CookieManager.instance().getCookies(url: WebUri(uri.toString()));
    return {
      for (final cookie in cookies)
        if (cookie.value case final String value) cookie.name: value,
    };
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
    _session.close();
    if (_didComplete) return;
    _didComplete = true;
    onBrowserExit?.call();
  }

  @override
  Future<void> close() async {
    _session.close();
    await super.close();
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
    _session.close();
    try {
      onLoginSuccess?.call(successData);
    } finally {
      await _closeSafely();
    }
  }

  void _reportError(String message) {
    if (_didComplete) return;
    _didComplete = true;
    _session.close();
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

/// The user closed the browser before the OAuth flow completed.
class OAuthFlowCancelled implements Exception {
  const OAuthFlowCancelled();

  @override
  String toString() => 'Browser exited before login.';
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
      onLoginSuccess: (result) {
        if (!completer.isCompleted) completer.complete(result);
      },
      onLoginError: (error) {
        if (!completer.isCompleted) {
          completer.completeError(error, StackTrace.current);
        }
      },
      onBrowserExit: () {
        if (!completer.isCompleted) {
          completer.completeError(
            const OAuthFlowCancelled(),
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
      unawaited(browser._closeSafely());
    }

    return completer.future;
  }
}
