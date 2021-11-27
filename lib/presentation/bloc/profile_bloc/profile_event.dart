part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileGetUserData extends ProfileEvent {
  final String token;

  const ProfileGetUserData(this.token);
}
