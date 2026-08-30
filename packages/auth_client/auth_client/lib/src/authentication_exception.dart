abstract class AuthenticationException implements Exception {
  const AuthenticationException(this.error);

  final Object error;

  @override
  String toString() => '$runtimeType: $error';
}

class SendLoginEmailLinkFailure extends AuthenticationException {
  const SendLoginEmailLinkFailure(super.error);
}

class IsLogInWithEmailLinkFailure extends AuthenticationException {
  const IsLogInWithEmailLinkFailure(super.error);
}

class LogInWithEmailLinkFailure extends AuthenticationException {
  const LogInWithEmailLinkFailure(super.error);
}

class LogInWithPasswordFailure extends AuthenticationException {
  const LogInWithPasswordFailure(super.error);
}

class SignUpFailure extends AuthenticationException {
  const SignUpFailure(super.error);
}

class SignInAnonymouslyFailure extends AuthenticationException {
  const SignInAnonymouslyFailure(super.error);
}

class SendPasswordResetEmailFailure extends AuthenticationException {
  const SendPasswordResetEmailFailure(super.error);
}

class ResetPasswordFailure extends AuthenticationException {
  const ResetPasswordFailure(super.error);
}

class LogOutFailure extends AuthenticationException {
  const LogOutFailure(super.error);
}

class DeleteAccountFailure extends AuthenticationException {
  const DeleteAccountFailure(super.error);
}
