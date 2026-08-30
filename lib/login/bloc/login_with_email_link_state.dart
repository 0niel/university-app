part of 'login_with_email_link_bloc.dart';

@freezed
abstract class LoginWithEmailLinkState with _$LoginWithEmailLinkState {
  const factory LoginWithEmailLinkState({
    @Default(LoginWithEmailLinkStatus.initial) LoginWithEmailLinkStatus status,
  }) = _LoginWithEmailLinkState;

  const LoginWithEmailLinkState._();
}
