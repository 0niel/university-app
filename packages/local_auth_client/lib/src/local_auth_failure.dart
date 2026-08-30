abstract class LocalAuthFailure implements Exception {
  const LocalAuthFailure(this.error);

  final Object error;
}

class CheckBiometricFailure extends LocalAuthFailure {
  const CheckBiometricFailure(super.error);
}

class AuthenticateFailure extends LocalAuthFailure {
  const AuthenticateFailure(super.error);
}

class BiometricUnavailableFailure extends LocalAuthFailure {
  const BiometricUnavailableFailure(super.error);
}
