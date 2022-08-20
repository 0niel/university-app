// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:auto_route/empty_router_widgets.dart' as _i3;
import 'package:flutter/material.dart' as _i7;
import 'package:rtu_mirea_app/presentation/pages/dashboard/dashboard_page.dart'
    as _i5;
import 'package:rtu_mirea_app/presentation/pages/home/home_page.dart' as _i2;
import 'package:rtu_mirea_app/presentation/pages/news/news_details_page.dart'
    as _i1;
import 'package:rtu_mirea_app/presentation/pages/news/news_page.dart' as _i4;

class AppRouter extends _i6.RootStackRouter {
  AppRouter([_i7.GlobalKey<_i7.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    NewsDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<NewsDetailsRouteArgs>();
      return _i6.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i1.NewsDetailsPage(key: args.key, isEvent: args.isEvent));
    },
    HomeRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i2.HomePage());
    },
    NewsRouter.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i3.EmptyRouterPage());
    },
    DashboardRouter.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i3.EmptyRouterPage());
    },
    NewsRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.NewsPage());
    },
    DashboardRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i5.DashboardPage());
    }
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig(NewsDetailsRoute.name, path: 'news-details'),
        _i6.RouteConfig(HomeRoute.name, path: '/', children: [
          _i6.RouteConfig(NewsRouter.name,
              path: 'news',
              parent: HomeRoute.name,
              children: [
                _i6.RouteConfig(NewsRoute.name,
                    path: '', parent: NewsRouter.name)
              ]),
          _i6.RouteConfig(DashboardRouter.name,
              path: 'dashboard',
              parent: HomeRoute.name,
              children: [
                _i6.RouteConfig(DashboardRoute.name,
                    path: '', parent: DashboardRouter.name)
              ])
        ]),
        _i6.RouteConfig('*#redirect',
            path: '*', redirectTo: '/', fullMatch: true)
      ];
}

/// generated route for
/// [_i1.NewsDetailsPage]
class NewsDetailsRoute extends _i6.PageRouteInfo<NewsDetailsRouteArgs> {
  NewsDetailsRoute({_i7.Key? key, required bool isEvent})
      : super(NewsDetailsRoute.name,
            path: 'news-details',
            args: NewsDetailsRouteArgs(key: key, isEvent: isEvent));

  static const String name = 'NewsDetailsRoute';
}

class NewsDetailsRouteArgs {
  const NewsDetailsRouteArgs({this.key, required this.isEvent});

  final _i7.Key? key;

  final bool isEvent;

  @override
  String toString() {
    return 'NewsDetailsRouteArgs{key: $key, isEvent: $isEvent}';
  }
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i6.PageRouteInfo<void> {
  const HomeRoute({List<_i6.PageRouteInfo>? children})
      : super(HomeRoute.name, path: '/', initialChildren: children);

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i3.EmptyRouterPage]
class NewsRouter extends _i6.PageRouteInfo<void> {
  const NewsRouter({List<_i6.PageRouteInfo>? children})
      : super(NewsRouter.name, path: 'news', initialChildren: children);

  static const String name = 'NewsRouter';
}

/// generated route for
/// [_i3.EmptyRouterPage]
class DashboardRouter extends _i6.PageRouteInfo<void> {
  const DashboardRouter({List<_i6.PageRouteInfo>? children})
      : super(DashboardRouter.name,
            path: 'dashboard', initialChildren: children);

  static const String name = 'DashboardRouter';
}

/// generated route for
/// [_i4.NewsPage]
class NewsRoute extends _i6.PageRouteInfo<void> {
  const NewsRoute() : super(NewsRoute.name, path: '');

  static const String name = 'NewsRoute';
}

/// generated route for
/// [_i5.DashboardPage]
class DashboardRoute extends _i6.PageRouteInfo<void> {
  const DashboardRoute() : super(DashboardRoute.name, path: '');

  static const String name = 'DashboardRoute';
}
