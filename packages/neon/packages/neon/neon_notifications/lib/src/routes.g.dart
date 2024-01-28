// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $notificationsAppRoute,
    ];

RouteBase get $notificationsAppRoute => GoRouteData.$route(
      path: '/apps/notifications',
      name: 'notifications',
      factory: $NotificationsAppRouteExtension._fromState,
    );

extension $NotificationsAppRouteExtension on NotificationsAppRoute {
  static NotificationsAppRoute _fromState(GoRouterState state) => const NotificationsAppRoute();

  String get location => GoRouteData.$location(
        '/apps/notifications',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
