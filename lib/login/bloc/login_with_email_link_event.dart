part of 'login_with_email_link_bloc.dart';

abstract class LoginWithEmailLinkEvent extends Equatable {
  const LoginWithEmailLinkEvent();
}

class LoginWithEmailCodeResetRequested extends LoginWithEmailLinkEvent {
  const LoginWithEmailCodeResetRequested();

  @override
  List<Object> get props => [];
}

class LoginWithEmailLinkSubmitted extends LoginWithEmailLinkEvent
    with AnalyticsEventMixin {
  const LoginWithEmailLinkSubmitted(this.emailLink);

  final Uri emailLink;

  @override
  AnalyticsEvent get event => const .new('LoginWithEmailLinkSubmitted');

  @override
  List<Object> get props => [emailLink, event];
}

class LoginWithEmailCodeSubmitted extends LoginWithEmailLinkEvent
    with AnalyticsEventMixin {
  const LoginWithEmailCodeSubmitted({required this.email, required this.code});

  final String email;
  final String code;

  @override
  AnalyticsEvent get event => const .new('LoginWithEmailCodeSubmitted');

  @override
  List<Object> get props => [email, code, event];
}
