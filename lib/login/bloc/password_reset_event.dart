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
