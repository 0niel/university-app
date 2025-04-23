part of 'app_bloc.dart';

enum AppStatus {
  onboardingRequired(),
  authenticated(),
  unauthenticated();

  bool get isLoggedIn => this == AppStatus.authenticated || this == AppStatus.onboardingRequired;
}

class AppState extends Equatable {
  const AppState({this.isAmoled = false, this.discoursePostIdToOpen, required this.status, this.user = User.anonymous});

  const AppState.authenticated(User user) : this(status: AppStatus.authenticated, user: user);

  const AppState.onboardingRequired(User user) : this(status: AppStatus.onboardingRequired, user: user);

  const AppState.unauthenticated() : this(status: AppStatus.unauthenticated);

  final AppStatus status;
  final User user;
  final bool isAmoled;
  final int? discoursePostIdToOpen;

  AppState copyWith({bool? isAmoled, int? discoursePostIdToOpen, AppStatus? status, User? user}) {
    return AppState(
      isAmoled: isAmoled ?? this.isAmoled,
      discoursePostIdToOpen: discoursePostIdToOpen ?? this.discoursePostIdToOpen,
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [isAmoled, discoursePostIdToOpen];
}
