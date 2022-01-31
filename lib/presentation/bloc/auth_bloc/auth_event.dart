part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLogInEvent extends AuthEvent {
  final String login;
  final String password;

  const AuthLogInEvent({required this.login, required this.password});

  @override
  List<Object> get props => [login, password];
}

class AuthLogInFromCache extends AuthEvent {}

class AuthLogOut extends AuthEvent {}
