part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

// Initial state of the app.
class AppInitial extends HomeState {}

// Onboarding state of the app. It is shown only once after the first launch.
class AppOnboarding extends HomeState {}

// State of the app when new updates are available.
class AppUpdatesOnboarding extends HomeState {}

class AppClean extends HomeState {}
