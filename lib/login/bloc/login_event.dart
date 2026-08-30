part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class LoginWithPasswordSubmitted extends LoginEvent with AnalyticsEventMixin {
  @override
  AnalyticsEvent get event => const .new('LoginWithPasswordSubmitted');
}

class EmailLinkRequested extends LoginEvent with AnalyticsEventMixin {
  @override
  AnalyticsEvent get event => const .new('SendEmailLinkSubmitted');
}

class ContinueAsGuestRequested extends LoginEvent with AnalyticsEventMixin {
  @override
  AnalyticsEvent get event => const .new('ContinueAsGuestRequested');
}
