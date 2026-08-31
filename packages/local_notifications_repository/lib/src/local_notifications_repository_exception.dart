abstract class LocalNotificationsRepositoryException implements Exception {
  const LocalNotificationsRepositoryException(this.error);

  final Object error;
}

class SyncRemindersFailure extends LocalNotificationsRepositoryException {
  const SyncRemindersFailure(super.error);
}
