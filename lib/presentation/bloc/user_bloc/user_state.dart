part of 'user_bloc.dart';

@freezed
class UserState with _$UserState {
  const factory UserState.unauthorized() = _Unauthorized;
  const factory UserState.loading() = _Loading;
  const factory UserState.logInError(String cause) = _LogInError;
  const factory UserState.logInSuccess(User user) = _LogInSuccess;
}
