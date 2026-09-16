import 'package:equatable/equatable.dart';
import 'package:nfc_pass_client/nfc_pass_client.dart';

/// {@template nfc_pass_failure}
/// Custom exceptions for NFC Pass operations.
/// {@endtemplate}
abstract class NfcPassFailure with EquatableMixin implements Exception {
  /// {@macro nfc_pass_failure}
  const NfcPassFailure(this.error);

  /// The original error/message.
  final Object error;

  /// The innermost cause, unwrapping failures that wrap other failures.
  Object get rootCause {
    var cause = error;
    while (cause is NfcPassFailure) {
      cause = cause.error;
    }
    return cause;
  }

  /// The pass backend could not be reached (timeout, DNS, TCP or TLS
  /// failure). Retrying makes sense; re-authenticating does not.
  NfcPassUnreachableException? get unreachable {
    final cause = rootCause;
    return cause is NfcPassUnreachableException ? cause : null;
  }

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

final class NfcPassVerificationFailure extends NfcPassFailure {
  const NfcPassVerificationFailure(this.reason) : super(reason);

  final NfcVerificationFailure reason;
}
