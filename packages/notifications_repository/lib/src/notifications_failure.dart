import 'package:equatable/equatable.dart';

abstract class NotificationsFailure with EquatableMixin implements Exception {
  const NotificationsFailure(this.error);

  final Object error;

  @override
  List<Object> get props => [error];
}

class ToggleNotificationsFailure extends NotificationsFailure {
  const ToggleNotificationsFailure(super.error);
}

class FetchNotificationsEnabledFailure extends NotificationsFailure {
  const FetchNotificationsEnabledFailure(super.error);
}

class SetCategoriesPreferencesFailure extends NotificationsFailure {
  const SetCategoriesPreferencesFailure(super.error);
}

class FetchCategoriesPreferencesFailure extends NotificationsFailure {
  const FetchCategoriesPreferencesFailure(super.error);
}
