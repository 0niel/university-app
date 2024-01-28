// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $dashboardAppRoute,
    ];

RouteBase get $dashboardAppRoute => GoRouteData.$route(
      path: '/apps/dashboard',
      name: 'dashboard',
      factory: $DashboardAppRouteExtension._fromState,
    );

extension $DashboardAppRouteExtension on DashboardAppRoute {
  static DashboardAppRoute _fromState(GoRouterState state) => const DashboardAppRoute();

  String get location => GoRouteData.$location(
        '/apps/dashboard',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
