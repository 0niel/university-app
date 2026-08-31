import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/login/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_repository/user_repository.dart';

export 'package:rtu_mirea_app/login/models/models.dart';

part 'login_event.dart';
part 'login_bloc.freezed.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required this.userRepository,
    List<String> allowedEmailDomains = const [],
  }) : _allowedEmailDomains = allowedEmailDomains,
       super(
         LoginState(email: Email.pure(allowedDomains: allowedEmailDomains)),
       ) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginWithPasswordSubmitted>(_onLoginWithPasswordSubmitted);
    on<EmailLinkRequested>(_onEmailLinkRequested);
    on<ContinueAsGuestRequested>(_onContinueAsGuestRequested);
  }

  final UserRepository userRepository;
  final List<String> _allowedEmailDomains;

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final email = Email.dirtyWithDomains(
      event.email.trim(),
      allowedDomains: _allowedEmailDomains,
    );
    emit(
      state.copyWith(
        email: email,
        isEmailValid: email.isValid,
        isValid: Formz.validate([email, state.password]),
        errorKind: null,
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.email, password]),
        errorKind: null,
      ),
    );
  }

  Future<void> _onLoginWithPasswordSubmitted(
    LoginWithPasswordSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: .inProgress, errorKind: null));
    try {
      await userRepository.logInWithPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: .success, errorKind: null));
    } on Exception catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: .failure,
          errorKind: _passwordErrorKind(error),
        ),
      );
      addError(error, stackTrace);
    }
  }

  Future<void> _onEmailLinkRequested(
    EmailLinkRequested event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.isEmailValid) return;
    emit(state.copyWith(status: .inProgress, errorKind: null));
    try {
      await userRepository.sendLoginEmailLink(email: state.email.value);
      emit(state.copyWith(status: .success, errorKind: null));
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure, errorKind: .generic));
      addError(error, stackTrace);
    }
  }

  Future<void> _onContinueAsGuestRequested(
    ContinueAsGuestRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: .inProgress, errorKind: null));
    try {
      await userRepository.signInAnonymously();
      emit(state.copyWith(status: .success, errorKind: null));
    } on Exception catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: .failure,
          errorKind: .guestUnavailable,
        ),
      );
      addError(error, stackTrace);
    }
  }

  LoginErrorKind _passwordErrorKind(Object error) {
    final cause = error is AuthenticationException ? error.error : error;
    return switch (cause) {
      AuthException(code: 'invalid_credentials') =>
        LoginErrorKind.invalidCredentials,
      _ => LoginErrorKind.generic,
    };
  }
}
