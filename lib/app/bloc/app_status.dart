part of 'app_bloc.dart';

enum AppStatus {
  onboardingRequired,
  authenticated,
  unauthenticated;

  bool get isLoggedIn => this == .authenticated || this == .onboardingRequired;
}
