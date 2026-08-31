import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/login/models/models.dart';
import 'package:user_repository/user_repository.dart';

part 'password_reset_event.dart';
part 'password_reset_bloc.freezed.dart';
part 'password_reset_state.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  PasswordResetBloc({
    required this.userRepository,
    List<String> allowedEmailDomains = const [],
  }) : _allowedEmailDomains = allowedEmailDomains,
       super(
         PasswordResetState(
           email: Email.pure(allowedDomains: allowedEmailDomains),
         ),
       ) {
    on<PasswordResetEmailChanged>(_onEmailChanged);
    on<PasswordResetRequested>(_onRequested);
  }

  final UserRepository userRepository;
  final List<String> _allowedEmailDomains;

  void _onEmailChanged(
    PasswordResetEmailChanged event,
    Emitter<PasswordResetState> emit,
  ) {
    final email = Email.dirtyWithDomains(
      event.email.trim(),
      allowedDomains: _allowedEmailDomains,
    );
    emit(state.copyWith(email: email, isValid: Formz.validate([email])));
  }

  Future<void> _onRequested(
    PasswordResetRequested event,
    Emitter<PasswordResetState> emit,
  ) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: .inProgress));
    try {
      await userRepository.sendPasswordResetEmail(email: state.email.value);
      emit(state.copyWith(status: .success));
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }
}
