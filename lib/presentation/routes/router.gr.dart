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
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:auto_route/empty_router_widgets.dart' as _i2;
import 'package:flutter/material.dart' as _i6;
import 'package:rtu_mirea_app/presentation/pages/home/home_page.dart' as _i1;
import 'package:rtu_mirea_app/presentation/pages/news/news_details_page.dart'
    as _i4;
import 'package:rtu_mirea_app/presentation/pages/news/news_page.dart' as _i3;

class AppRouter extends _i5.RootStackRouter {
  AppRouter([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i5.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i1.HomePage());
    },
    NewsRouter.name: (routeData) {
      return _i5.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    NewsRoute.name: (routeData) {
      return _i5.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i3.NewsPage());
    },
    NewsDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<NewsDetailsRouteArgs>();
      return _i5.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i4.NewsDetailsPage(key: args.key, isEvent: args.isEvent));
    }
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(HomeRoute.name, path: '/', children: [
          _i5.RouteConfig(NewsRouter.name,
              path: 'news',
              parent: HomeRoute.name,
              children: [
                _i5.RouteConfig(NewsRoute.name,
                    path: '', parent: NewsRouter.name),
                _i5.RouteConfig(NewsDetailsRoute.name,
                    path: 'details', parent: NewsRouter.name)
              ])
        ]),
        _i5.RouteConfig('*#redirect',
            path: '*', redirectTo: '/', fullMatch: true)
      ];
}

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i5.PageRouteInfo<void> {
  const HomeRoute({List<_i5.PageRouteInfo>? children})
      : super(HomeRoute.name, path: '/', initialChildren: children);

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i2.EmptyRouterPage]
class NewsRouter extends _i5.PageRouteInfo<void> {
  const NewsRouter({List<_i5.PageRouteInfo>? children})
      : super(NewsRouter.name, path: 'news', initialChildren: children);

  static const String name = 'NewsRouter';
}

/// generated route for
/// [_i3.NewsPage]
class NewsRoute extends _i5.PageRouteInfo<void> {
  const NewsRoute() : super(NewsRoute.name, path: '');

  static const String name = 'NewsRoute';
}

/// generated route for
/// [_i4.NewsDetailsPage]
class NewsDetailsRoute extends _i5.PageRouteInfo<NewsDetailsRouteArgs> {
  NewsDetailsRoute({_i6.Key? key, required bool isEvent})
      : super(NewsDetailsRoute.name,
            path: 'details',
            args: NewsDetailsRouteArgs(key: key, isEvent: isEvent));

  static const String name = 'NewsDetailsRoute';
}

class NewsDetailsRouteArgs {
  const NewsDetailsRouteArgs({this.key, required this.isEvent});

  final _i6.Key? key;

  final bool isEvent;

  @override
  String toString() {
    return 'NewsDetailsRouteArgs{key: $key, isEvent: $isEvent}';
  }
}
