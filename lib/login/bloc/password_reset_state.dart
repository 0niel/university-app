part of 'password_reset_bloc.dart';

@freezed
abstract class PasswordResetState with _$PasswordResetState {
  const factory PasswordResetState({
    @Default(Email.pure()) Email email,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default(false) bool isValid,
  }) = _PasswordResetState;

  const PasswordResetState._();
}
