// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $newsAppRoute,
    ];

RouteBase get $newsAppRoute => GoRouteData.$route(
      path: '/apps/news',
      name: 'news',
      factory: $NewsAppRouteExtension._fromState,
    );

extension $NewsAppRouteExtension on NewsAppRoute {
  static NewsAppRoute _fromState(GoRouterState state) => const NewsAppRoute();

  String get location => GoRouteData.$location(
        '/apps/news',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
