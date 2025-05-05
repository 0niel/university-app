import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:user_repository/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

/// Email Form Input Validation Error
enum EmailValidationError {
  /// Email is invalid (generic validation error)
  invalid,
}

/// {@template email}
/// Reusable email form input.
/// {@endtemplate}
class Email extends FormzInput<String, EmailValidationError> {
  /// {@macro email}
  const Email.pure() : super.pure('');

  /// {@macro email}
  const Email.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(r'^[a-zA-Z0-9._%-]+@(mirea\.ru|edu\.mirea\.ru)$');

  @override
  EmailValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : EmailValidationError.invalid;
  }
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required UserRepository userRepository}) : _userRepository = userRepository, super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<SendEmailLinkSubmitted>(_onSendEmailLinkSubmitted);
  }

  final UserRepository _userRepository;

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(email: email, valid: Formz.validate([email])));
  }

  Future<void> _onSendEmailLinkSubmitted(SendEmailLinkSubmitted event, Emitter<LoginState> emit) async {
    if (!state.valid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.sendLoginEmailLink(email: state.email.value);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }
}
