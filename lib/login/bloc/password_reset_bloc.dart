import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/login/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;
import 'package:user_repository/user_repository.dart';

part 'password_reset_event.dart';
part 'password_reset_bloc.freezed.dart';
part 'password_reset_state.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  PasswordResetBloc({
    required this.userRepository,
    String initialEmail = '',
    List<String> allowedEmailDomains = const [],
    DateTime Function()? now,
  }) : _allowedEmailDomains = allowedEmailDomains,
       _now = now ?? DateTime.now,
       super(
         PasswordResetState(
           email: initialEmail.trim().isEmpty
               ? Email.pure(allowedDomains: allowedEmailDomains)
               : Email.dirtyWithDomains(
                   initialEmail.trim(),
                   allowedDomains: allowedEmailDomains,
                 ),
         ),
       ) {
    on<PasswordResetEmailChanged>(_onEmailChanged);
    on<PasswordResetRequested>(_onRequested);
    on<PasswordResetCodeEntryRequested>((event, emit) {
      if (state.step != .email || !state.email.isValid || state.isBusy) return;
      emit(state.copyWith(step: .code, status: .initial, error: null));
    });
    on<PasswordResetEmailEntryRequested>((event, emit) {
      if (state.step != .code || state.isBusy) return;
      emit(state.copyWith(step: .email, status: .initial, error: null));
    });
    on<PasswordResetCodeChanged>((event, emit) {
      if (state.step != .code || state.isBusy) return;
      emit(
        state.copyWith(code: event.code.trim(), status: .initial, error: null),
      );
    });
    on<PasswordResetCodeSubmitted>(_onCodeSubmitted);
    on<PasswordResetPasswordChanged>(_onPasswordChanged);
    on<PasswordResetConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<PasswordResetSubmitted>(_onSubmitted);
    on<_PasswordResetCooldownTicked>((event, emit) {
      final deadline = _resendAvailableAt;
      if (deadline == null) return;
      final seconds = (deadline.difference(_now()).inMilliseconds / 1000)
          .ceil()
          .clamp(0, resendCooldown.inSeconds);
      emit(state.copyWith(resendSeconds: seconds));
      if (seconds == 0) _cooldownTimer?.cancel();
    });
  }

  static const resendCooldown = Duration(seconds: 60);

  final UserRepository userRepository;
  final List<String> _allowedEmailDomains;
  final DateTime Function() _now;
  DateTime? _resendAvailableAt;
  Timer? _cooldownTimer;

  void _onEmailChanged(
    PasswordResetEmailChanged event,
    Emitter<PasswordResetState> emit,
  ) {
    if (state.step != .email || state.isBusy) return;
    final email = Email.dirtyWithDomains(
      event.email.trim(),
      allowedDomains: _allowedEmailDomains,
    );
    emit(state.copyWith(email: email, code: '', status: .initial, error: null));
  }

  Future<void> _onRequested(
    PasswordResetRequested event,
    Emitter<PasswordResetState> emit,
  ) async {
    if (!state.email.isValid ||
        !state.canResend ||
        (state.step != .email && state.step != .code)) {
      return;
    }
    emit(state.copyWith(status: .inProgress, error: null));
    try {
      await userRepository.sendPasswordResetEmail(email: state.email.value);
      if (emit.isDone) return;
      _startCooldown();
      emit(
        state.copyWith(
          step: .code,
          code: '',
          status: .initial,
          resendSeconds: resendCooldown.inSeconds,
        ),
      );
    } on Exception catch (error, stackTrace) {
      if (emit.isDone) return;
      final kind = _errorKind(error, .sendFailed);
      if (kind == .rateLimited) _startCooldown();
      emit(
        state.copyWith(
          step: kind == .rateLimited ? .code : state.step,
          status: .failure,
          error: kind,
          resendSeconds: kind == .rateLimited
              ? resendCooldown.inSeconds
              : state.resendSeconds,
        ),
      );
      addError(error, stackTrace);
    }
  }

  Future<void> _onCodeSubmitted(
    PasswordResetCodeSubmitted event,
    Emitter<PasswordResetState> emit,
  ) async {
    if (state.step != .code || !state.isValid || state.isBusy) return;
    emit(state.copyWith(status: .inProgress, error: null));
    try {
      final userId = await userRepository.verifyPasswordResetCode(
        email: state.email.value,
        code: state.code,
      );
      if (emit.isDone) return;
      emit(
        state.copyWith(
          step: .password,
          code: '',
          verifiedUserId: userId,
          status: .initial,
        ),
      );
    } on Exception catch (error, stackTrace) {
      if (emit.isDone) return;
      emit(
        state.copyWith(
          status: .failure,
          error: _errorKind(error, .verificationFailed),
        ),
      );
      addError(error, stackTrace);
    }
  }

  void _onPasswordChanged(
    PasswordResetPasswordChanged event,
    Emitter<PasswordResetState> emit,
  ) {
    if (state.step != .password || state.isBusy) return;
    final password = Password.dirty(event.password);
    final confirmedPassword = state.confirmedPassword.isPure
        ? const ConfirmedPassword.pure()
        : ConfirmedPassword.dirty(
            password: password.value,
            value: state.confirmedPassword.value,
          );
    emit(
      state.copyWith(
        password: password,
        confirmedPassword: confirmedPassword,
        status: .initial,
        error: null,
      ),
    );
  }

  void _onConfirmPasswordChanged(
    PasswordResetConfirmPasswordChanged event,
    Emitter<PasswordResetState> emit,
  ) {
    if (state.step != .password || state.isBusy) return;
    emit(
      state.copyWith(
        confirmedPassword: ConfirmedPassword.dirty(
          password: state.password.value,
          value: event.password,
        ),
        status: .initial,
        error: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    PasswordResetSubmitted event,
    Emitter<PasswordResetState> emit,
  ) async {
    final userId = state.verifiedUserId;
    if (state.step != .password ||
        !state.isValid ||
        state.isBusy ||
        userId == null) {
      return;
    }
    emit(state.copyWith(status: .inProgress, error: null));
    try {
      await userRepository.setAccountPassword(
        userId: userId,
        password: state.password.value,
      );
      if (emit.isDone) return;
      emit(
        state.copyWith(
          step: .complete,
          password: const Password.pure(),
          confirmedPassword: const ConfirmedPassword.pure(),
          verifiedUserId: null,
          status: .success,
        ),
      );
    } on Exception catch (error, stackTrace) {
      if (emit.isDone) return;
      final kind = _errorKind(error, .updateFailed);
      emit(
        state.copyWith(
          step: kind == .sessionExpired ? .code : .password,
          verifiedUserId: kind == .sessionExpired ? null : userId,
          status: .failure,
          error: kind,
        ),
      );
      addError(error, stackTrace);
    }
  }

  PasswordResetError _errorKind(Object error, PasswordResetError fallback) {
    final cause = error is AuthenticationException ? error.error : error;
    return switch (cause) {
      AuthException(statusCode: '429') ||
      AuthException(code: 'over_email_send_rate_limit') ||
      AuthException(code: 'over_request_rate_limit') => .rateLimited,
      AuthException(code: 'otp_expired') => .invalidCode,
      AuthException(code: 'weak_password') => .weakPassword,
      AuthException(code: 'same_password') => .samePassword,
      AuthException(code: 'session_not_found') ||
      AuthException(code: 'session_expired') ||
      AuthException(code: 'refresh_token_not_found') ||
      AuthException(code: 'bad_jwt') => .sessionExpired,
      StateError() when fallback == .updateFailed => .sessionExpired,
      _ => fallback,
    };
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    _resendAvailableAt = _now().add(resendCooldown);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isClosed) add(const _PasswordResetCooldownTicked());
    });
  }

  @override
  Future<void> close() {
    _cooldownTimer?.cancel();
    return super.close();
  }
}
