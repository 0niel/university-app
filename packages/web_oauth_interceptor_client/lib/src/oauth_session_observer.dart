import 'dart:async';

import 'package:web_oauth_interceptor_client/src/login_success_data.dart';
import 'package:web_oauth_interceptor_client/src/oauth_redirect_matcher.dart';
import 'package:web_oauth_interceptor_client/src/oauth_session_cookies.dart';

class OAuthSessionObserver {
  OAuthSessionObserver({
    required this.oauthUrl,
    required this.expectedRedirectUrls,
    required this.specialCookieName,
    required this.readCookies,
    required this.onSuccess,
    required this.onError,
    this.waitForSpecialCookie = false,
    this.pollInterval = const Duration(milliseconds: 500),
    this.redirectTimeout = const Duration(seconds: 20),
  });

  final String oauthUrl;
  final List<String> expectedRedirectUrls;
  final String specialCookieName;
  final Future<Map<String, String>> Function(Uri) readCookies;
  final void Function(LoginSuccessData) onSuccess;
  final void Function() onError;
  final bool waitForSpecialCookie;
  final Duration pollInterval;
  final Duration redirectTimeout;

  Timer? _poll;
  Timer? _deadline;
  Future<void>? _pending;
  Uri? _current;
  var _loaded = false;
  var _closed = false;
  var _probeAgain = false;
  var _revision = 0;

  Future<void> observe(String url, {bool loaded = false}) async {
    if (_closed) return;
    _current = Uri.tryParse(url);
    _loaded = loaded;
    _revision++;
    _poll ??= Timer.periodic(pollInterval, (_) => unawaited(_probe()));
    if (OAuthRedirectMatcher.matches(url, expectedRedirectUrls)) {
      _deadline ??= Timer(redirectTimeout, () {
        if (_closed) return;
        close();
        onError();
      });
    } else {
      _deadline?.cancel();
      _deadline = null;
    }
    await _probe();
  }

  void close() {
    _closed = true;
    _poll?.cancel();
    _deadline?.cancel();
  }

  Future<void> _probe() {
    if (_closed) return Future.value();
    if (_pending case final pending?) {
      _probeAgain = true;
      return pending;
    }
    late final Future<void> pending;
    pending = _inspect().whenComplete(() {
      _pending = null;
      if (_probeAgain && !_closed) {
        _probeAgain = false;
        unawaited(_probe());
      }
    });
    _pending = pending;
    return pending;
  }

  Future<void> _inspect() async {
    final current = _current;
    if (current == null || !_trusted(current)) return;
    final expected = OAuthRedirectMatcher.matches(
      current.toString(),
      expectedRedirectUrls,
    );
    final authorization = Uri.tryParse(oauthUrl);
    if (!expected &&
        (!_loaded ||
            authorization != null &&
                _sameOrigin(current, authorization) &&
                current.path == authorization.path)) {
      return;
    }
    final revision = _revision;
    final token = expected ? current.queryParameters['access_token'] : null;
    final urls = {
      current.toString(),
      ...expectedRedirectUrls,
      oauthUrl,
    };
    for (final url in urls) {
      if (_closed || revision != _revision) return;
      final uri = Uri.tryParse(url);
      if (uri == null || !_cookieUrl(uri)) continue;
      Map<String, String> cookies;
      try {
        cookies = await readCookies(uri);
      } on Exception {
        continue;
      }
      if (_closed || revision != _revision) return;
      final complete = completeOAuthSessionCookies(cookies, specialCookieName);
      if (complete != null) {
        _complete(
          LoginSuccessData(
            accessToken: token,
            allCookies: complete,
            specialCookieValue: complete[specialCookieName],
          ),
        );
        return;
      }
    }
    if (!_closed &&
        revision == _revision &&
        !waitForSpecialCookie &&
        token != null &&
        token.isNotEmpty) {
      _complete(LoginSuccessData(accessToken: token, allCookies: const {}));
    }
  }

  bool _trusted(Uri current) =>
      current.userInfo.isEmpty &&
      [oauthUrl, ...expectedRedirectUrls].any((url) {
        final expected = Uri.tryParse(url);
        return expected != null && _sameOrigin(current, expected);
      });

  bool _sameOrigin(Uri first, Uri second) =>
      first.scheme == second.scheme &&
      first.host == second.host &&
      first.port == second.port;

  bool _cookieUrl(Uri uri) =>
      (uri.scheme == 'https' || uri.scheme == 'http') &&
      uri.host.isNotEmpty &&
      uri.userInfo.isEmpty;

  void _complete(LoginSuccessData result) {
    if (_closed) return;
    close();
    onSuccess(result);
  }
}
