part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppOpened extends AppEvent {
  const AppOpened();
}

class InteractedMessageReceived extends AppEvent {
  const InteractedMessageReceived(this.message, {this.userId});

  final RemoteMessage message;
  final String? userId;

  @override
  List<Object?> get props => [message, userId];
}

class ThemeChanged extends AppEvent {
  const ThemeChanged({required this.isAmoled});

  final bool isAmoled;

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
