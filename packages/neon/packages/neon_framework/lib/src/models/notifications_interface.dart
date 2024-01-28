import 'package:meta/meta.dart';
import 'package:neon_framework/src/bloc/bloc.dart';
import 'package:neon_framework/src/models/app_implementation.dart';
import 'package:neon_framework/src/settings/models/options_collection.dart';

/// The interface of the notifications client implementation.
///
/// Use this to access the notifications client from other Neon clients.
abstract interface class NotificationsAppInterface<T extends NotificationsBlocInterface,
    R extends AppImplementationOptions> extends AppImplementation<T, R> {
  /// Creates a new notifications client.
  NotificationsAppInterface();

  @override
  @mustBeOverridden
  R get options => throw UnimplementedError();
}

/// The interface of the bloc used by the notifications client.
abstract interface class NotificationsBlocInterface extends InteractiveBloc {
  /// Deletes the notification with the given [id].
  void deleteNotification(int id);
}
