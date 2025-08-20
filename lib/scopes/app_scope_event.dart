part of 'app_scope_bloc.dart';

abstract class AppScopeEvent extends Equatable {
  const AppScopeEvent();

  @override
  List<Object> get props => [];
}

class AppScopeStarted extends AppScopeEvent {
  const AppScopeStarted();
}

class AppScopeUserChanged extends AppScopeEvent {
  const AppScopeUserChanged(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class AppScopeLogoutRequested extends AppScopeEvent {
  const AppScopeLogoutRequested();
}
