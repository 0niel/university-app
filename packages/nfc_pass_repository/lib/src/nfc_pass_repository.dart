import 'package:http/http.dart' as http;
import 'package:nfc_pass_client/nfc_pass_client.dart';
import 'package:nfc_pass_repository/src/nfc_pass_configuration.dart';
import 'package:nfc_pass_repository/src/nfc_pass_failure.dart';
import 'package:nfc_pass_repository/src/storage/nfc_pass_store.dart';
import 'package:storage/storage.dart' as storage;
import 'package:web_oauth_interceptor_client/web_oauth_interceptor_client.dart';

/// {@template nfc_pass_repository}
/// Repository for managing NFC Pass operations.
/// {@endtemplate}
class NfcPassRepository {
  /// {@macro nfc_pass_repository}
  NfcPassRepository({
    required storage.Storage storage,
    required NfcPassConfiguration configuration,
    OAuthInterceptorClient? oauthInterceptorClient,
    http.Client? httpClient,
    DigitalPassChannel? digitalPassChannel,
  })  : _digitalPassChannel = digitalPassChannel ?? const DigitalPassChannel(),
        oauthInterceptorClient = oauthInterceptorClient ??
            OAuthInterceptorClient(
              oauthUrl: configuration.oauthUrl.toString(),
              expectedRedirectUrls: configuration.expectedRedirectUrls
                  .map((url) => url.toString())
                  .toList(growable: false),
              specialCookieName: '.AspNetCore.Cookies',
            ) {
    _store =
        NfcPassStore(storage: storage, digitalPassChannel: _digitalPassChannel);
    _nfcPassClient = NfcPassClient(
      cookieProvider: () async => await readSessionCookie() ?? '',
      endpoints: configuration.endpoints,
      httpClient: httpClient,
    );
  }

  late final NfcPassStore _store;

  /// Bridge to the native store the Android HCE service reads when answering a
  /// turnstile. flutter_secure_storage's own store is not readable natively.
  final DigitalPassChannel _digitalPassChannel;

  /// Client for OAuth flow in an embedded browser.
  final OAuthInterceptorClient oauthInterceptorClient;

  /// gRPC-Web клиент, которому мы передаём cookieProvider
  /// (чтобы он сам при каждом запросе подхватывал куку).
  late final NfcPassClient _nfcPassClient;

  Future<NfcVerificationResult>? _bindingOperation;
  DateTime? _verificationRetryAt;
  int? _verificationRevision;
  Future<int>? _confirmationOperation;
  (String, String)? _confirmationArguments;

  Future<void> synchronizeSessionAccount(String? accountId) =>
      _store.synchronizeSessionAccount(accountId);

  Future<String?> readSessionCookie() => _store.readSessionCookie();

  Future<void> setSessionCookie(String cookie) =>
      _store.setSessionCookie(cookie);

  Future<void> clearSessionCookie() => _store.clearSessionCookie();

  Future<bool> isPassBound() => _store.isPassBound();

  Future<int?> getPassId() => _store.getPassId();

  /// Whether the device can emulate the pass (NFC + HCE present).
  Future<bool> isNfcAvailable() => _digitalPassChannel.isHceAvailable();

  /// Whether turnstile card emulation is currently enabled.
  Future<bool> isNfcEnabled() => _digitalPassChannel.isHceEnabled();

  /// Turns turnstile card emulation on/off. When off, our app leaves NFC
  /// routing so a reader no longer offers it in the app-chooser.
  Future<void> setNfcEnabled({required bool enabled}) =>
      _digitalPassChannel.setHceEnabled(enabled: enabled);

  /// Makes our pass the foreground-preferred service ([enabled] true) so a tap
  /// skips the app-chooser, or releases that preference. Call when the pass
  /// screen opens/closes — it only applies while the app is in the foreground.
  Future<void> setForegroundPreference({required bool enabled}) =>
      _digitalPassChannel.setForegroundPreference(enabled: enabled);

  Future<void> unbindPass() => _store.unbindPass();

  /// Initiates the authorization and code sending flow:
  ///
  /// 1. Reuses the session or opens OAuth when authentication is needed.
  /// 2. Calls gRPC method `GetAccessTokenForDigitalPass`, saves the JWT.
  /// 3. Calls `SendVerificationCode`.
  ///
  /// After this, you need to call [confirmBinding] with the 6-digit code.
  Future<NfcVerificationResult> bindPass() =>
      _bindingOperation ??= _bindPass().whenComplete(() {
        _bindingOperation = null;
      });

  Future<NfcVerificationResult> _bindPass() async {
    try {
      final initialRevision = _store.sessionRevision;
      var (cookie, revision) = await _store.readSession();
      _store.checkSession(initialRevision);
      final retryAt = _verificationRetryAt;
      if (_verificationRevision == revision &&
          retryAt != null &&
          retryAt.isAfter(DateTime.now())) {
        return NfcVerificationCooldown(retryAt: retryAt);
      }
      var reusedSession = cookie != null && cookie.isNotEmpty;
      if (reusedSession) {
        try {
          nfcSessionCookieHeader(cookie);
        } on FormatException {
          reusedSession = false;
        }
      }
      if (!reusedSession) {
        await _loginAndStoreCookie(revision);
        (cookie, revision) = await _store.readSession();
      }
      String jwt;
      try {
        jwt = await _getJwtAndSave(cookie!, revision);
      } on NfcPassJwtFailure catch (error) {
        final cause = error.error;
        if (!reusedSession ||
            cause is! NfcPassTransportException ||
            !cause.requiresAuthentication) {
          rethrow;
        }
        revision = await _store.invalidateRejectedSession(revision);
        await _loginAndStoreCookie(revision);
        (cookie, revision) = await _store.readSession();
        jwt = await _getJwtAndSave(cookie!, revision);
      }
      _store.checkSession(revision);
      final result = await _sendVerificationCode(jwt, cookie);
      _store.checkSession(revision);
      _verificationRevision = revision;
      _verificationRetryAt = switch (result) {
        NfcVerificationCodeSent(:final retryAt) => retryAt,
        NfcVerificationCooldown(:final retryAt) => retryAt,
        NfcVerificationUnavailable() => null,
      };
      return result;
    } on NfcPassFailure {
      rethrow;
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(NfcPassLoginFailure(e), stackTrace);
    }
  }

  /// Completes the flow: enter the 6-digit code and device name,
  /// calls `GetDigitalPass`, saves the passId.
  ///
  /// Returns the passId (number).
  Future<int> confirmBinding({
    required String sixDigitCode,
    required String deviceName,
  }) {
    final pending = _confirmationOperation;
    if (pending != null) {
      if (_confirmationArguments == (sixDigitCode, deviceName)) return pending;
      return Future<int>.error(
        const NfcPassGetPassFailure(
          'A pass confirmation is already in progress.',
        ),
      );
    }
    _confirmationArguments = (sixDigitCode, deviceName);
    return _confirmationOperation = _confirmBinding(
      sixDigitCode: sixDigitCode,
      deviceName: deviceName,
    ).whenComplete(() {
      _confirmationOperation = null;
      _confirmationArguments = null;
    });
  }

  Future<int> _confirmBinding({
    required String sixDigitCode,
    required String deviceName,
  }) async {
    try {
      final (jwt, cookie, revision) = await _store.readConfirmation();
      if (jwt.isEmpty) {
        throw const NfcPassJwtFailure(
          'JWT is missing. Call bindPass() first.',
        );
      }

      final passId = await _getDigitalPass(
        jwt,
        sixDigitCode,
        deviceName,
        cookie,
        revision,
      );
      return passId;
    } on NfcPassFailure {
      rethrow;
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(NfcPassGetPassFailure(e), stackTrace);
    }
  }

  Future<void> _loginAndStoreCookie(int expectedRevision) async {
    try {
      final (revision, request) = await _store.captureLogin(expectedRevision);
      _store.checkSession(revision);
      final result = await oauthInterceptorClient.initiateOAuthFlow();
      if ((result.allCookies['.AspNetCore.Cookies'] ?? '').isEmpty) {
        throw const NfcPassLoginFailure('Cookie not found');
      }
      final cookieValue = nfcSessionCookieHeader(
        result.allCookies.entries
            .where(
              (entry) => RegExp(r'^\.AspNetCore\.Cookies(?:C[1-9][0-9]*)?$')
                  .hasMatch(entry.key),
            )
            .map((entry) => '${entry.key}=${entry.value}')
            .join('; '),
      );
      await _store.storeLoginCookie(cookieValue, revision, request);
    } on NfcPassFailure {
      rethrow;
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace(NfcPassLoginFailure(error), stackTrace);
    }
  }

  Future<String> _getJwtAndSave(String cookie, int revision) async {
    try {
      final jwt = await _nfcPassClient.getAccessTokenForDigitalPass(
        sessionCookie: cookie,
      );
      await _store.saveJwt(jwt, revision);
      return jwt;
    } on NfcPassFailure {
      rethrow;
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace(NfcPassJwtFailure(error), stackTrace);
    }
  }

  Future<NfcVerificationResult> _sendVerificationCode(
    String jwt,
    String cookie,
  ) async {
    try {
      return await _nfcPassClient.sendVerificationCode(
        jwt,
        sessionCookie: cookie,
      );
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace(NfcPassSendCodeFailure(error), stackTrace);
    }
  }

  Future<int> _getDigitalPass(
    String jwt,
    String code,
    String deviceName,
    String cookie,
    int revision,
  ) async {
    try {
      final passId = await _nfcPassClient.getDigitalPass(
        bearerToken: jwt,
        sixDigitCode: code,
        deviceName: deviceName,
        sessionCookie: cookie,
      );
      await _store.savePass(passId, revision);
      return passId;
    } on NfcVerificationException catch (error, stackTrace) {
      _store.checkSession(revision);
      Error.throwWithStackTrace(
        NfcPassVerificationFailure(error.failure),
        stackTrace,
      );
    } on NfcPassFailure {
      rethrow;
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace(NfcPassGetPassFailure(error), stackTrace);
    }
  }
}
