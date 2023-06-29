part of 'user_bloc.dart';

@freezed
class UserEvent with _$UserEvent {
  const factory UserEvent.started() = _Started;
  const factory UserEvent.logIn() = _LogIn;
  const factory UserEvent.logOut() = _LogOut;
  const factory UserEvent.getUserData() = _GetUserData;

  /// This event is used to set auntificated data to the state from another bloc
  /// (NfcPassBloc).
  const factory UserEvent.setAuntificatedData({
    required User user,
  }) = _SetAuntificatedData;
}
