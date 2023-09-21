/// {@template notification_exception}
/// Исключение клиента уведомлений.
/// {@endtemplate}
abstract class NotificationException implements Exception {
  /// {@macro notification_exception}
  const NotificationException(this.error);

  /// Связанная ошибка.
  final Object error;
}

/// {@template subscribe_to_category_failure}
/// Выбрасывается при ошибке подписки на категорию.
/// {@endtemplate}
class SubscribeToCategoryFailure extends NotificationException {
  /// {@macro subscribe_to_category_failure}
  const SubscribeToCategoryFailure(super.error);
}

/// {@template unsubscribe_from_category_failure}
/// Выбрасывается при ошибке отписки от категории.
/// {@endtemplate}
class UnsubscribeFromCategoryFailure extends NotificationException {
  /// {@macro unsubscribe_from_category_failure}
  const UnsubscribeFromCategoryFailure(super.error);
}

/// {@template notifications_client}
/// Клиент для работы с уведомлениями.
/// {@endtemplate}
abstract class NotificationsClient {
  /// Подписывает пользователя на группу уведомлений на основе [category].
  Future<void> subscribeToCategory(String category);

  /// Отписывает пользователя от группы уведомлений на основе [category].
  Future<void> unsubscribeFromCategory(String category);
}
