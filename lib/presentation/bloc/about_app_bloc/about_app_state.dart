part of 'about_app_bloc.dart';

abstract class AboutAppState extends Equatable {
  const AboutAppState();

  @override
  List<Object> get props => [];
}

class AboutAppInitial extends AboutAppState {}

class AboutAppContributorsLoading extends AboutAppState {}

class AboutAppContributorsLoaded extends AboutAppState {
  final List<Contributor> contributors;

  AboutAppContributorsLoaded({required this.contributors});

  @override
  List<Object> get props => [contributors];
}

class AboutAppContributorsLoadError extends AboutAppState {}
