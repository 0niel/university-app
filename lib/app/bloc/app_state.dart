part of 'app_bloc.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState({
    @Default(AppStatus.unauthenticated) AppStatus status,
    @Default(User.anonymous) User user,
    int? discoursePostIdToOpen,
    String? routeToOpen,
    @Default(0) int notificationNavigationId,
  }) = _AppState;

  const AppState._();

  AppState withNotificationDestination({int? discoursePostId, String? route}) {
    return AppState(
      discoursePostIdToOpen: discoursePostId,
      routeToOpen: discoursePostId == null ? route : null,
      notificationNavigationId: notificationNavigationId + 1,
      status: status,
      user: user,
    );
  }
}
