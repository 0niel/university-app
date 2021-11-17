part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class LogInError extends AuthState {
  final String cause;

  const LogInError({required this.cause});

  @override
  List<Object> get props => [cause];
}

class LogInSuccess extends AuthState {}
