part of 'login_bloc.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default(Email.pure()) Email email,
    @Default(Password.pure()) Password password,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default(false) bool isValid,
    @Default(false) bool isEmailValid,
    String? errorMessage,
    LoginErrorKind? errorKind,
  }) = _LoginState;

  const LoginState._();
}

enum LoginErrorKind { invalidCredentials, guestUnavailable, generic }
