abstract class NotificationsClient {
  Future<void> subscribeToCategory(String category);

  Future<void> unsubscribeFromCategory(String category);
}
