part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileContributorsLoading extends ProfileState {}

class ProfileContributorsLoaded extends ProfileState {
  final List<Contributor> contributors;

  ProfileContributorsLoaded({required this.contributors});

  @override
  List<Object> get props => [contributors];
}

class ProfileContributorsLoadError extends ProfileState {}
