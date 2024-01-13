part of 'user_bloc.dart';

abstract class UserEvent {}

class Started extends UserEvent {}

class LogInEvent extends UserEvent {}

class LogOutEvent extends UserEvent {}

class GetUserDataEvent extends UserEvent {}

class SetAuthenticatedData extends UserEvent with EquatableMixin {
  final User user;

  SetAuthenticatedData({required this.user});

  @override
  List<Object?> get props => [user];
}
