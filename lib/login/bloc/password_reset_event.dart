part of 'password_reset_bloc.dart';

abstract class PasswordResetEvent extends Equatable {
  const PasswordResetEvent();

  @override
  List<Object?> get props => [];
}

class PasswordResetEmailChanged extends PasswordResetEvent {
  const PasswordResetEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class PasswordResetRequested extends PasswordResetEvent
    with AnalyticsEventMixin {
  @override
  AnalyticsEvent get event => const .new('PasswordResetRequested');
}

class PasswordResetCodeEntryRequested extends PasswordResetEvent {
  const PasswordResetCodeEntryRequested();
}

class PasswordResetEmailEntryRequested extends PasswordResetEvent {
  const PasswordResetEmailEntryRequested();
}

class PasswordResetCodeChanged extends PasswordResetEvent {
  const PasswordResetCodeChanged(this.code);

  final String code;

  @override
  List<Object> get props => [code];
}

class PasswordResetCodeSubmitted extends PasswordResetEvent {
  const PasswordResetCodeSubmitted();
}

class PasswordResetPasswordChanged extends PasswordResetEvent {
  const PasswordResetPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class PasswordResetConfirmPasswordChanged extends PasswordResetEvent {
  const PasswordResetConfirmPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class PasswordResetSubmitted extends PasswordResetEvent {
  const PasswordResetSubmitted();
}

class _PasswordResetCooldownTicked extends PasswordResetEvent {
  const _PasswordResetCooldownTicked();
}
