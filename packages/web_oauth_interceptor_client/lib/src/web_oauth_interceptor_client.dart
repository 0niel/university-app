import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Class representing configuration parameters for auto-filling form fields.
class AutoFillConfig {
  const AutoFillConfig({
    this.usernameSelector,
    this.passwordSelector,
    this.submitButtonSelector,
    this.defaultUsername,
    this.defaultPassword,
    this.additionalFields = const {},
  });

  /// Selector for the username input field (e.g., '#username' or 'input[name="login"]').
  final String? usernameSelector;

  /// Selector for the password input field (e.g., '#password' or 'input[name="password"]').
  final String? passwordSelector;

  /// Selector for the submit button (e.g., '#submit' or 'button[type="submit"]').
  final String? submitButtonSelector;

  /// Default value for the username.
  final String? defaultUsername;

  /// Default value for the password.
  final String? defaultPassword;

  /// Additional fields to populate in the form.
  /// Key is a valid selector, and value is the string to set in the field.
  final Map<String, String> additionalFields;
}

/// Data class containing information upon successful login.
class LoginSuccessData {
  LoginSuccessData({
    required this.allCookies,
    this.accessToken,
    this.specialCookieValue,
  });

  /// The access token extracted from the URL, if available.
  final String? accessToken;

  /// All cookies associated with the current session.
  final Map<String, String> allCookies;

  /// The value of the special cookie used to determine success.
  final String? specialCookieValue;
}

/// {@template web_oauth_interceptor_client}
/// Class that handles OAuth authorization within an in-app browser.
/// {@endtemplate}
class WebOAuthInterceptorClient extends InAppBrowser {
  /// {@macro web_oauth_interceptor_client}
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

  /// Determines whether to explicitly wait for the special cookie.
  /// If `true`, authorization does not complete until the special cookie is found (or the browser is closed).
  final bool waitForSpecialCookie;

  /// Current URL being loaded in the browser.
  String? _currentUrl;

  /// Set of target domains extracted from expectedRedirectUrls and oauthUrl.
  final Set<String> _targetDomains = {};

  @override
  void onBrowserCreated() {
    super.onBrowserCreated();
    debugPrint('[WebOAuthInterceptorClient] Browser Created');
  }

  @override
  Future<void> onLoadStart(WebUri? url) async {
    super.onLoadStart(url);
    if (url == null) return;
    _currentUrl = url.toString();

    debugPrint('[WebOAuthInterceptorClient] onLoadStart: $_currentUrl');

    if (_isRedirectUrl(_currentUrl!)) {
      await _handleOAuthRedirect(_currentUrl!);
    }
  }

  @override
  Future<void> onLoadStop(WebUri? url) async {
    super.onLoadStop(url);
    if (url == null) return;

    debugPrint('[WebOAuthInterceptorClient] onLoadStop: $url');

    // Add a slight delay to allow cookies to be set
    await Future.delayed(const Duration(milliseconds: 500));

    // Get the domain of the current URL
    final currentUri = Uri.parse(url.toString());
    final currentDomain = currentUri.origin;

    // Create a set of domains to check: current domain + target domains
    final domainsToCheck = Set<String>.from(_targetDomains)..add(currentDomain);

    debugPrint('=== Checking Cookies for Domains: $domainsToCheck ===');

    var specialCookieFound = false;
    String? specialCookieValue;
    final allCookies = <String, String>{};

    for (final domain in domainsToCheck) {
      final domainUri = Uri.parse(domain);
      final domainCookies = await CookieManager.instance().getCookies(url: WebUri(domainUri.toString()));
      debugPrint('=== COOKIES for $domain ===');
      for (final cookie in domainCookies) {
        debugPrint(
          'Cookie: ${cookie.name}=${cookie.value} | httpOnly=${cookie.isHttpOnly} | secure=${cookie.isSecure}',
        );
        allCookies[cookie.name] = cookie.value as String;
        if (cookie.name == specialCookieName) {
          debugPrint('--- Special Cookie Found on $domain ---');
          specialCookieFound = true;
          specialCookieValue = cookie.value as String;
        }
      }
    }

    // Check if the special cookie was found
    if (specialCookieFound &&
        (!waitForSpecialCookie || (specialCookieValue != null && specialCookieValue.isNotEmpty))) {
      debugPrint('=== OAuth SUCCESS ===');
      debugPrint('Special cookie [$specialCookieName]: $specialCookieValue');

      final successData = LoginSuccessData(
        allCookies: allCookies,
        specialCookieValue: specialCookieValue,
      );

      onLoginSuccess?.call(successData);

      try {
        await close();
      } catch (e) {
        debugPrint('[WebOAuthInterceptorClient] Browser already closed: $e');
      }
      return;
    }

    // Attempt to auto-fill the form if configured
    if (autoFillConfig != null) {
      await _tryAutoFillForm();
    }
  }

  @override
  void onLoadError(Uri? url, int code, String message) {
    super.onLoadError(url, code, message);
    debugPrint('[WebOAuthInterceptorClient] onLoadError: $message (code $code)');
    onLoginError?.call('Load error: $message (code $code)');
  }

  @override
  void onLoadHttpError(Uri? url, int statusCode, String description) {
    super.onLoadHttpError(url, statusCode, description);
    debugPrint('[WebOAuthInterceptorClient] onLoadHttpError: $description (status $statusCode)');
    onLoginError?.call('HTTP error: $description (code $statusCode)');
  }

  @override
  void onExit() {
    super.onExit();
    debugPrint('[WebOAuthInterceptorClient] onExit');
    onBrowserExit?.call();
  }

  /// Checks if the given URL is one of the expected redirect URLs.
  bool _isRedirectUrl(String url) {
    return expectedRedirectUrls.any(
      (expectedUrl) => url.startsWith(expectedUrl),
    );
  }

  /// Handles the OAuth redirect by extracting tokens and cookies.
  Future<void> _handleOAuthRedirect(String url) async {
    final uri = Uri.parse(url);
    final cookies = await CookieManager.instance().getCookies(url: WebUri(uri.toString()));

    final token = _extractTokenFromUrl(url);

    // Find the special cookie
    final specialCookieValue = cookies.firstWhereOrNull((cookie) => cookie.name == specialCookieName)?.value as String?;

    // Determine if authorization is successful
    final isBasicSuccess =
        (token != null && token.isNotEmpty) || (specialCookieValue != null && specialCookieValue.isNotEmpty);

    final isSpecialCookieValid = !waitForSpecialCookie || (specialCookieValue != null && specialCookieValue.isNotEmpty);

    if (isBasicSuccess && isSpecialCookieValid) {
      debugPrint('=== OAuth SUCCESS ===');
      debugPrint('Access token: $token');
      debugPrint('Special cookie [$specialCookieName]: $specialCookieValue');

      // Gather all cookies
      final allCookies = <String, String>{};
      for (final cookie in cookies) {
        allCookies[cookie.name] = cookie.value as String;
      }

      final successData = LoginSuccessData(
        accessToken: token,
        allCookies: allCookies,
        specialCookieValue: specialCookieValue,
      );

      onLoginSuccess?.call(successData);

      try {
        await close();
      } catch (e) {
        debugPrint('[WebOAuthInterceptorClient] Browser already closed: $e');
      }
    }
  }

  /// Helper method to extract `access_token` (or another parameter) from the URL query.
  String? _extractTokenFromUrl(String url) {
    final uri = Uri.parse(url);
    return uri.queryParameters['access_token'];
  }

  /// Method to auto-fill form fields on the page using JavaScript.
  /// Operates only if [autoFillConfig] is provided.
  Future<void> _tryAutoFillForm() async {
    if (autoFillConfig == null) return;

    final usernameSel = autoFillConfig!.usernameSelector;
    final passwordSel = autoFillConfig!.passwordSelector;
    final submitBtnSel = autoFillConfig!.submitButtonSelector;
    final defaultUsername = autoFillConfig!.defaultUsername;
    final defaultPassword = autoFillConfig!.defaultPassword;

    // If username/password selectors or values are not provided, do nothing
    if ((usernameSel == null || defaultUsername == null) && (passwordSel == null || defaultPassword == null)) {
      return;
    }

    // Build the JavaScript script for auto-filling the form
    final jsBuffer = StringBuffer();

    if (usernameSel != null && defaultUsername != null) {
      jsBuffer.writeln('''
        (function() {
          var el = document.querySelector("$usernameSel");
          if (el) { el.value = "$defaultUsername"; }
        })();
      ''');
    }

    if (passwordSel != null && defaultPassword != null) {
      jsBuffer.writeln('''
        (function() {
          var el = document.querySelector("$passwordSel");
          if (el) { el.value = "$defaultPassword"; }
        })();
      ''');
    }

    // Populate additional fields if any
    if (autoFillConfig!.additionalFields.isNotEmpty) {
      autoFillConfig!.additionalFields.forEach((selector, value) {
        jsBuffer.writeln('''
          (function() {
            var el = document.querySelector("$selector");
            if (el) { el.value = "$value"; }
          })();
        ''');
      });
    }

    // Click the submit button if a selector is provided
    if (submitBtnSel != null) {
      jsBuffer.writeln('''
        (function() {
          var btn = document.querySelector("$submitBtnSel");
          if (btn) { btn.click(); }
        })();
      ''');
    }

    // Execute the script in the WebView
    if (jsBuffer.isNotEmpty) {
      try {
        final script = jsBuffer.toString();
        await webViewController?.evaluateJavascript(source: script);
        debugPrint('[WebOAuthInterceptorClient] Auto-fill JS executed');
      } catch (e) {
        debugPrint('[WebOAuthInterceptorClient] Auto-fill JS error: $e');
      }
    }
  }
}

/// Client class to initiate and handle the OAuth interception process.
class OAuthInterceptorClient {
  OAuthInterceptorClient({
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

  /// Determines whether to explicitly wait for the special cookie before considering the process successful.
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

  /// Initiates the OAuth flow using a custom [WebOAuthInterceptorClient].
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
      onLoginError: completer.completeError,
      onBrowserExit: () {
        if (!completer.isCompleted) {
          completer.completeError('Browser exited before login.');
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
    } catch (e) {
      completer.completeError(e.toString());
    }

    return completer.future;
  }
}
