part of 'about_app_bloc.dart';

abstract class AboutAppState extends Equatable {
  const AboutAppState();

  @override
  List<Object> get props => [];
}

class AboutAppInitial extends AboutAppState {}

class AboutAppMembersLoading extends AboutAppState {}

class AboutAppMembersLoaded extends AboutAppState {
  final List<ForumMember> patrons;
  final List<Contributor> contributors;

  const AboutAppMembersLoaded(
      {required this.patrons, required this.contributors});

  @override
  List<Object> get props => [patrons, contributors];
}

class AboutAppMembersLoadError extends AboutAppState {
  final bool contributorsLoadError;
  final bool patronsLoadError;

  const AboutAppMembersLoadError(
      {required this.contributorsLoadError, required this.patronsLoadError});
  @override
  List<Object> get props => [contributorsLoadError, patronsLoadError];
}
