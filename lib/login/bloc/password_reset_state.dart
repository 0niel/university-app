part of 'password_reset_bloc.dart';

@freezed
abstract class PasswordResetState with _$PasswordResetState {
  const factory PasswordResetState({
    @Default(PasswordResetStep.email) PasswordResetStep step,
    @Default(Email.pure()) Email email,
    @Default('') String code,
    @Default(Password.pure()) Password password,
    @Default(ConfirmedPassword.pure()) ConfirmedPassword confirmedPassword,
    String? verifiedUserId,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    PasswordResetError? error,
    @Default(0) int resendSeconds,
  }) = _PasswordResetState;

  const PasswordResetState._();

  bool get isBusy => status.isInProgress;

  bool get canResend => resendSeconds == 0 && !isBusy;

  bool get isValid => switch (step) {
    .email => email.isValid,
    .code => email.isValid && RegExp(r'^\d{6}$').hasMatch(code),
    .password =>
      verifiedUserId != null && Formz.validate([password, confirmedPassword]),
    .complete => false,
  };
}

enum PasswordResetStep { email, code, password, complete }

enum PasswordResetError {
  sendFailed,
  verificationFailed,
  invalidCode,
  rateLimited,
  weakPassword,
  samePassword,
  sessionExpired,
  updateFailed,
}
