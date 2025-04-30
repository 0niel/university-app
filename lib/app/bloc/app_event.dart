part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppOpened extends AppEvent {
  const AppOpened();
}

class RecieveInteractedMessage extends AppEvent {
  final RemoteMessage message;

  const RecieveInteractedMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class ThemeChanged extends AppEvent {
  final bool isAmoled;

  const ThemeChanged(this.isAmoled);

  @override
  List<Object?> get props => [isAmoled];
}

class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}
