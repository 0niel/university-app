import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

import 'package:local_auth_client/src/biometric_capability.dart';
import 'package:local_auth_client/src/biometric_kind.dart';
import 'package:local_auth_client/src/local_auth_failure.dart';

export 'biometric_capability.dart';
export 'biometric_kind.dart';
export 'local_auth_failure.dart';

class LocalAuthClient {
  LocalAuthClient({LocalAuthentication? localAuthentication})
    : _auth = localAuthentication ?? LocalAuthentication();

  final LocalAuthentication _auth;

  Future<BiometricCapability> capability() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      if (!supported || !canCheck) return BiometricCapability.unavailable;
      final types = await _auth.getAvailableBiometrics();
      if (types.isEmpty) return BiometricCapability.unavailable;
      return BiometricCapability(available: true, kind: _strongest(types));
    } on PlatformException catch (error, stackTrace) {
      Error.throwWithStackTrace(CheckBiometricFailure(error), stackTrace);
    }
  }

  Future<bool> authenticate({required String reason}) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(stickyAuth: true),
      );
    } on PlatformException catch (error, stackTrace) {
      if (error.code == auth_error.notAvailable ||
          error.code == auth_error.notEnrolled ||
          error.code == auth_error.passcodeNotSet) {
        Error.throwWithStackTrace(
          BiometricUnavailableFailure(error),
          stackTrace,
        );
      }
      Error.throwWithStackTrace(AuthenticateFailure(error), stackTrace);
    }
  }

  static BiometricKind _strongest(List<BiometricType> types) {
    if (types.contains(BiometricType.face)) return .face;
    if (types.contains(BiometricType.fingerprint) ||
        types.contains(BiometricType.strong) ||
        types.contains(BiometricType.weak)) {
      return .fingerprint;
    }
    if (types.contains(BiometricType.iris)) return .iris;
    return .none;
  }
}
