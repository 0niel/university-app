import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_pass_client/nfc_pass_client.dart';
import 'package:storage/storage.dart' as storage;
import 'package:web_oauth_interceptor_client/web_oauth_interceptor_client.dart';

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
    OAuthInterceptorClient? oauthInterceptorClient,
    http.Client? httpClient,
  })  : _secureStorage = storage,
        oauthInterceptorClient = oauthInterceptorClient ??
            OAuthInterceptorClient(
              oauthUrl:
                  'https://attendance.mirea.ru/api/auth/login?redirectUri=https%3A%2F%2Fattendance-app.mirea.ru&rememberMe=True',
              expectedRedirectUrls: ['https://attendance-app.mirea.ru/'],
              specialCookieName: '.AspNetCore.Cookies',
            ),
        _nfcPassClient = NfcPassClient(
          cookieProvider: () async {
            return await storage.read(key: _kKeyCookie) ?? '';
          },
          httpClient: httpClient,
        );

  final storage.Storage _secureStorage;

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
  Future<int?> getPassId() async {
    final passIdString = await _secureStorage.read(key: _kKeyPassId);
    if (passIdString == null) return null;
    return int.tryParse(passIdString);
  }

  /// Unbinds the pass (clears cookie, token, passId).
  Future<void> unbindPass() async {
    await _secureStorage.delete(key: _kKeyCookie);
    await _secureStorage.delete(key: _kKeyJwt);
    await _secureStorage.delete(key: _kKeyPassId);
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

  Future<int> _getDigitalPass(String jwt, String code, String deviceName) async {
    try {
      final passId = await _nfcPassClient.getDigitalPass(
        bearerToken: jwt,
        sixDigitCode: code,
        deviceName: deviceName,
      );
      await _secureStorage.write(key: _kKeyPassId, value: passId.toString());
      return passId;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(NfcPassGetPassFailure(error), stackTrace);
    }
  }
}
