part of 'notification_preferences_bloc.dart';

enum NotificationPreferencesStatus {
  initial,
  loading,
  success,
  failure,
}

class NotificationPreferencesState extends Equatable {
  const NotificationPreferencesState({
    required this.selectedCategories,
    required this.status,
    required this.categories,
  });

  NotificationPreferencesState.initial()
      : this(
          selectedCategories: {},
          status: NotificationPreferencesStatus.initial,
          categories: {},
        );

  final NotificationPreferencesStatus status;
  final Set<String> categories;
  final Set<String> selectedCategories;

  @override
  List<Object?> get props => [selectedCategories, status, categories];

  NotificationPreferencesState copyWith({
    Set<String>? selectedCategories,
    NotificationPreferencesStatus? status,
    Set<String>? categories,
  }) {
    return NotificationPreferencesState(
      selectedCategories: selectedCategories ?? this.selectedCategories,
      status: status ?? this.status,
      categories: categories ?? this.categories,
    );
  }
}
