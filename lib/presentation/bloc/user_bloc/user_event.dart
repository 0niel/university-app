part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class Started extends UserEvent {
  @override
  List<Object?> get props => [];
}

class LogInEvent extends UserEvent with AnalyticsEventMixin {
  @override
  AnalyticsEvent get event => const AnalyticsEvent('LogIn');
}

class LogOutEvent extends UserEvent with AnalyticsEventMixin {
  @override
  AnalyticsEvent get event => const AnalyticsEvent('LogOut');
}

class GetUserDataEvent extends UserEvent with AnalyticsEventMixin {
  @override
  AnalyticsEvent get event => const AnalyticsEvent('GetUserData');
}

class SetAuthenticatedData extends UserEvent {
  final User user;

  const SetAuthenticatedData({required this.user});

  @override
  List<Object?> get props => [user];
}
