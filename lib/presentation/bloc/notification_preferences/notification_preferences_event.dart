part of 'notification_preferences_bloc.dart';

abstract class NotificationPreferencesEvent extends Equatable {
  const NotificationPreferencesEvent();
}

class CategoriesPreferenceToggled extends NotificationPreferencesEvent {
  const CategoriesPreferenceToggled({required this.category, required this.group});

  final String category;

  /// Название академической группы.
  final String group;

  @override
  List<Object?> get props => [category, group];
}

class InitialCategoriesPreferencesRequested extends NotificationPreferencesEvent {
  const InitialCategoriesPreferencesRequested({required this.group});

  /// Название академической группы.
  final String group;

  @override
  List<Object?> get props => [group];
}
