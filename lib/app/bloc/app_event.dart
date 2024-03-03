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
