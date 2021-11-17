part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileUnauthenticated extends ProfileState {}

class ProfileAuthenticated extends ProfileState {
  final User user;

  const ProfileAuthenticated({required this.user});
}
