part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  final AppSettings settings;

  const HomeState({this.settings = const AppSettings(onboardingShown: false, lastUpdateVersion: '', theme: 'system')});

  @override
  List<Object> get props => [settings];
}

// Initial state of the app.
class AppInitial extends HomeState {
  const AppInitial({super.settings});
}

// Onboarding state of the app. It is shown only once after the first launch.
class AppOnboarding extends HomeState {
  const AppOnboarding({required super.settings});
}

// State of the app when new updates are available.
class AppUpdatesOnboarding extends HomeState {
  const AppUpdatesOnboarding({required super.settings});
}

class AppClean extends HomeState {
  const AppClean({required super.settings});
}
