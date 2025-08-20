part of 'app_scope_bloc.dart';

enum AppScopeStatus {
  initial,
  loading,
  ready,
  authenticated,
  unauthenticated,
  onboardingRequired,
  error,
}

class AppScopeState extends Equatable {
  const AppScopeState._({
    this.status = AppScopeStatus.initial,
    this.user = User.anonymous,
    this.errorMessage,
  });

  const AppScopeState.initial() : this._();

  const AppScopeState.loading() : this._(status: AppScopeStatus.loading);

  const AppScopeState.ready(User user) : this._(
    status: AppScopeStatus.ready,
    user: user,
  );

  const AppScopeState.authenticated(User user) : this._(
    status: AppScopeStatus.authenticated,
    user: user,
  );

  const AppScopeState.unauthenticated() : this._(
    status: AppScopeStatus.unauthenticated,
  );

  const AppScopeState.onboardingRequired(User user) : this._(
    status: AppScopeStatus.onboardingRequired,
    user: user,
  );

  const AppScopeState.error(String message) : this._(
    status: AppScopeStatus.error,
    errorMessage: message,
  );

  final AppScopeStatus status;
  final User user;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, user, errorMessage];
}
