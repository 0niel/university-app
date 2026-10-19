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

class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}
