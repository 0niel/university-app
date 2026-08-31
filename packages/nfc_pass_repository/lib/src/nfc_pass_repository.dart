import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_pass_client/nfc_pass_client.dart';
import 'package:storage/storage.dart' as storage;
import 'package:web_oauth_interceptor_client/web_oauth_interceptor_client.dart';

/// OAuth and gRPC settings for an institution's NFC-pass provider.
final class NfcPassConfiguration {
  /// Creates settings for a provider that supports the digital-pass protocol.
  const NfcPassConfiguration({
    required this.oauthUrl,
    required this.expectedRedirectUrls,
    required this.endpoints,
  });

  /// Starts the provider's interactive authentication flow.
  final Uri oauthUrl;

  /// Redirect destinations that complete authentication successfully.
  final List<Uri> expectedRedirectUrls;

  /// gRPC-Web endpoints used after authentication.
  final NfcPassEndpoints endpoints;
}

/// {@template nfc_pass_failure}
/// Custom exceptions for NFC Pass operations.
/// {@endtemplate}
abstract class NfcPassFailure with EquatableMixin implements Exception {
  /// {@macro nfc_pass_failure}
  const NfcPassFailure(this.error);

  /// The original error/message.
  final Object error;

  @override
  List<Object> get props => [error];
}

/// {@template nfc_pass_login_failure}
/// Exception thrown during OAuth login.
/// {@endtemplate}
class NfcPassLoginFailure extends NfcPassFailure {
  /// {@macro nfc_pass_login_failure}
  const NfcPassLoginFailure(super.error);
}

/// {@template nfc_pass_jwt_failure}
/// Exception thrown when requesting JWT.
/// {@endtemplate}
class NfcPassJwtFailure extends NfcPassFailure {
  /// {@macro nfc_pass_jwt_failure}
  const NfcPassJwtFailure(super.error);
}

/// {@template nfc_pass_send_code_failure}
/// Exception thrown when sending verification code.
/// {@endtemplate}
class NfcPassSendCodeFailure extends NfcPassFailure {
  /// {@macro nfc_pass_send_code_failure}
  const NfcPassSendCodeFailure(super.error);
}

/// {@template nfc_pass_get_pass_failure}
/// Exception thrown when retrieving/verifying digital pass.
/// {@endtemplate}
class NfcPassGetPassFailure extends NfcPassFailure {
  /// {@macro nfc_pass_get_pass_failure}
  const NfcPassGetPassFailure(super.error);
}

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
  })  : _secureStorage = storage,
        _digitalPassChannel = digitalPassChannel ?? const DigitalPassChannel(),
        oauthInterceptorClient = oauthInterceptorClient ??
            OAuthInterceptorClient(
              oauthUrl: configuration.oauthUrl.toString(),
              expectedRedirectUrls: configuration.expectedRedirectUrls
                  .map((url) => url.toString())
                  .toList(growable: false),
              specialCookieName: '.AspNetCore.Cookies',
            ),
        _nfcPassClient = NfcPassClient(
          cookieProvider: () async {
            return await storage.read(key: _kKeyCookie) ?? '';
          },
          endpoints: configuration.endpoints,
          httpClient: httpClient,
        );

  final storage.Storage _secureStorage;

  /// Bridge to the native store the Android HCE service reads when answering a
  /// turnstile. flutter_secure_storage's own store is not readable natively.
  final DigitalPassChannel _digitalPassChannel;

  /// Client for OAuth flow in an embedded browser.
  final OAuthInterceptorClient oauthInterceptorClient;

  /// gRPC-Web клиент, которому мы передаём cookieProvider
  /// (чтобы он сам при каждом запросе подхватывал куку).
  final NfcPassClient _nfcPassClient;

  // Keys for SecureStorage
  static const _kKeyCookie = 'nfc_cookie';
  static const _kKeyJwt = 'nfc_jwt';
  static const _kKeyPassId = 'nfc_pass_id';

  /// Checks if the pass is already bound (if passId exists in local storage).
  Future<bool> isPassBound() async {
    final passId = await _secureStorage.read(key: _kKeyPassId);
    return passId != null;
  }

  /// Returns the saved passId (or null if not saved).
  ///
  /// Re-mirrors the id to the native store on every read so already-bound users
  /// self-heal when they open the pass screen (best-effort — a native hiccup
  /// must not break reading the pass).
  Future<int?> getPassId() async {
    final passIdString = await _secureStorage.read(key: _kKeyPassId);
    if (passIdString == null) return null;
    final passId = int.tryParse(passIdString);
    if (passId != null) {
      try {
        await _digitalPassChannel.savePassId(passId);
      } on Object {
        // Best-effort sync; ignore native errors.
      }
    }
    return passId;
  }

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

  /// Unbinds the pass (clears cookie, token, passId).
  Future<void> unbindPass() async {
    await _secureStorage.delete(key: _kKeyCookie);
    await _secureStorage.delete(key: _kKeyJwt);
    await _secureStorage.delete(key: _kKeyPassId);
    await _digitalPassChannel.clearPassId();
  }

  /// Initiates the authorization and code sending flow:
  ///
  /// 1. Opens OAuth flow in the browser, saves the cookie.
  /// 2. Calls gRPC method `GetAccessTokenForDigitalPass`, saves the JWT.
  /// 3. Calls `SendVerificationCode`.
  ///
  /// If successful, the user will receive a code via email.
  ///
  /// After this, you need to call [confirmBinding] with the 6-digit code.
  Future<void> bindPass() async {
    try {
      await _loginAndStoreCookie();
      final jwt = await _getJwtAndSave();
      await _sendVerificationCode(jwt);
    } on NfcPassFailure {
      rethrow;
    } catch (e, stackTrace) {
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
  }) async {
    try {
      final jwt = await _secureStorage.read(key: _kKeyJwt) ?? '';
      if (jwt.isEmpty) {
        throw const NfcPassJwtFailure(
          'JWT is missing. Call bindPass() first.',
        );
      }

      final passId = await _getDigitalPass(jwt, sixDigitCode, deviceName);
      return passId;
    } on NfcPassFailure {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(NfcPassGetPassFailure(e), stackTrace);
    }
  }

  Future<void> _loginAndStoreCookie() async {
    try {
      final result = await oauthInterceptorClient.initiateOAuthFlow();
      final cookieValue = result.allCookies['.AspNetCore.Cookies'] ?? '';
      if (cookieValue.isEmpty) {
        throw const NfcPassLoginFailure('Cookie not found');
      }
      await _secureStorage.write(key: _kKeyCookie, value: cookieValue);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(NfcPassLoginFailure(error), stackTrace);
    }
  }

  Future<String> _getJwtAndSave() async {
    try {
      final jwt = await _nfcPassClient.getAccessTokenForDigitalPass();
      await _secureStorage.write(key: _kKeyJwt, value: jwt);
      return jwt;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(NfcPassJwtFailure(error), stackTrace);
    }
  }

  Future<void> _sendVerificationCode(String jwt) async {
    try {
      await _nfcPassClient.sendVerificationCode(jwt);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(NfcPassSendCodeFailure(error), stackTrace);
    }
  }

  Future<int> _getDigitalPass(
    String jwt,
    String code,
    String deviceName,
  ) async {
    try {
      final passId = await _nfcPassClient.getDigitalPass(
        bearerToken: jwt,
        sixDigitCode: code,
        deviceName: deviceName,
      );
      await _secureStorage.write(key: _kKeyPassId, value: passId.toString());
      await _digitalPassChannel.savePassId(passId);
      return passId;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(NfcPassGetPassFailure(error), stackTrace);
    }
  }
}
