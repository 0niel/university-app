part of 'app_cubit.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

// Initial state of the app.
class AppInitial extends AppState {}

// Onboarding state of the app. It is shown only once after the first launch.
class AppOnboarding extends AppState {}

// State of the app when new updates are available.
class AppUpdatesOnboarding extends AppState {}

class AppClean extends AppState {}
