import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rtu_mirea_app/scopes/auth_scope.dart';
import 'package:user_repository/user_repository.dart';

part 'app_scope_event.dart';
part 'app_scope_state.dart';

/// AppScopeBloc manages the global app state and auth scope lifecycle
class AppScopeBloc extends Bloc<AppScopeEvent, AppScopeState> {
  AppScopeBloc({
    required AuthScopeHolder authScopeHolder,
    required FirebaseMessaging firebaseMessaging,
  }) : _authScopeHolder = authScopeHolder,
       super(const AppScopeState.initial()) {
    
    on<AppScopeStarted>(_onAppStarted);
    on<AppScopeUserChanged>(_onUserChanged);
    on<AppScopeLogoutRequested>(_onLogoutRequested);
  }

  final AuthScopeHolder _authScopeHolder;
  StreamSubscription<User>? _userSubscription;

  Future<void> _onAppStarted(AppScopeStarted event, Emitter<AppScopeState> emit) async {
    try {
      await _authScopeHolder.createWithAnonymousUser();
      
      final authScope = _authScopeHolder.scope;
      if (authScope != null) {
        _userSubscription = authScope.userRepository.user.listen(
          (user) => add(AppScopeUserChanged(user)),
        );
        
        emit(AppScopeState.ready(authScope.currentUser));
      } else {
        emit(const AppScopeState.error('Failed to initialize auth scope'));
      }
    } catch (e) {
      emit(AppScopeState.error('Initialization failed: $e'));
    }
  }

  Future<void> _onUserChanged(AppScopeUserChanged event, Emitter<AppScopeState> emit) async {
    final user = event.user;
    
    try {
      await _authScopeHolder.createWithUser(user);
      
      if (user == User.anonymous) {
        emit(const AppScopeState.unauthenticated());
      } else if (user.isNewUser) {
        emit(AppScopeState.onboardingRequired(user));
      } else {
        emit(AppScopeState.authenticated(user));
      }
    } catch (e) {
      emit(AppScopeState.error('User change failed: $e'));
    }
  }

  Future<void> _onLogoutRequested(AppScopeLogoutRequested event, Emitter<AppScopeState> emit) async {
    try {
      final authScope = _authScopeHolder.scope;
      if (authScope != null) {
        await authScope.userRepository.logOut();
      }
    } catch (e) {
      emit(AppScopeState.error('Logout failed: $e'));
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    _authScopeHolder.drop();
    return super.close();
  }
}
