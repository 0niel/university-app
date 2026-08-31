import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notifications_client/notifications_client.dart';

class FirebaseNotificationsClient implements NotificationsClient {
  const FirebaseNotificationsClient({
    required FirebaseMessaging firebaseMessaging,
  }) : _firebaseMessaging = firebaseMessaging;

  final FirebaseMessaging _firebaseMessaging;

  @override
  Future<void> subscribeToCategory(String category) async {
    try {
      await _firebaseMessaging.subscribeToTopic(category);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SubscribeToCategoryFailure(error), stackTrace);
    }
  }

  @override
  Future<void> unsubscribeFromCategory(String category) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(category);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        UnsubscribeFromCategoryFailure(error),
        stackTrace,
      );
    }
  }
}
