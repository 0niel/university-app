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
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:auto_route/empty_router_widgets.dart' as _i4;
import 'package:flutter/material.dart' as _i12;
import 'package:rtu_mirea_app/presentation/pages/dashboard/dashboard_page.dart'
    as _i7;
import 'package:rtu_mirea_app/presentation/pages/dashboard/lost_and_found_create_page.dart'
    as _i2;
import 'package:rtu_mirea_app/presentation/pages/dashboard/lost_and_found_service_page.dart'
    as _i8;
import 'package:rtu_mirea_app/presentation/pages/home/home_page.dart' as _i3;
import 'package:rtu_mirea_app/presentation/pages/news/news_details_page.dart'
    as _i1;
import 'package:rtu_mirea_app/presentation/pages/news/news_page.dart' as _i5;
import 'package:rtu_mirea_app/presentation/pages/profile/about_app_page.dart'
    as _i10;
import 'package:rtu_mirea_app/presentation/pages/profile/profile_page.dart'
    as _i9;
import 'package:rtu_mirea_app/presentation/pages/schedule/schedule_page.dart'
    as _i6;

class AppRouter extends _i11.RootStackRouter {
  AppRouter([_i12.GlobalKey<_i12.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i11.PageFactory> pagesMap = {
    NewsDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<NewsDetailsRouteArgs>();
      return _i11.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i1.NewsDetailsPage(key: args.key, isEvent: args.isEvent));
    },
    LostAndFoundCreateRoute.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i2.LostAndFoundCreatePage());
    },
    HomeRoute.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i3.HomePage());
    },
    NewsRouter.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.EmptyRouterPage());
    },
    ScheduleRouter.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.EmptyRouterPage());
    },
    DashboardRouter.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.EmptyRouterPage());
    },
    ProfileRouter.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.EmptyRouterPage());
    },
    NewsRoute.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i5.NewsPage());
    },
    ScheduleRoute.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
          routeData: routeData, child: _i6.SchedulePage());
    },
    DashboardRoute.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i7.DashboardPage());
    },
    LostAndFoundServiceRoute.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i8.LostAndFoundServicePage());
    },
    ProfileRoute.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i9.ProfilePage());
    },
    AboutAppRoute.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i10.AboutAppPage());
    }
  };

  @override
  List<_i11.RouteConfig> get routes => [
        _i11.RouteConfig(NewsDetailsRoute.name, path: 'news-details'),
        _i11.RouteConfig(LostAndFoundCreateRoute.name,
            path: 'lostandfound-create'),
        _i11.RouteConfig(HomeRoute.name, path: '/', children: [
          _i11.RouteConfig(NewsRouter.name,
              path: 'news',
              parent: HomeRoute.name,
              children: [
                _i11.RouteConfig(NewsRoute.name,
                    path: '', parent: NewsRouter.name)
              ]),
          _i11.RouteConfig(ScheduleRouter.name,
              path: 'schedule',
              parent: HomeRoute.name,
              children: [
                _i11.RouteConfig(ScheduleRoute.name,
                    path: '', parent: ScheduleRouter.name)
              ]),
          _i11.RouteConfig(DashboardRouter.name,
              path: 'dashboard',
              parent: HomeRoute.name,
              children: [
                _i11.RouteConfig(DashboardRoute.name,
                    path: '', parent: DashboardRouter.name),
                _i11.RouteConfig(LostAndFoundServiceRoute.name,
                    path: 'lost-and-found', parent: DashboardRouter.name)
              ]),
          _i11.RouteConfig(ProfileRouter.name,
              path: 'profile',
              parent: HomeRoute.name,
              children: [
                _i11.RouteConfig(ProfileRoute.name,
                    path: '', parent: ProfileRouter.name),
                _i11.RouteConfig(AboutAppRoute.name,
                    path: 'about', parent: ProfileRouter.name)
              ])
        ]),
        _i11.RouteConfig('*#redirect',
            path: '*', redirectTo: '/', fullMatch: true)
      ];
}

/// generated route for
/// [_i1.NewsDetailsPage]
class NewsDetailsRoute extends _i11.PageRouteInfo<NewsDetailsRouteArgs> {
  NewsDetailsRoute({_i12.Key? key, required bool isEvent})
      : super(NewsDetailsRoute.name,
            path: 'news-details',
            args: NewsDetailsRouteArgs(key: key, isEvent: isEvent));

  static const String name = 'NewsDetailsRoute';
}

class NewsDetailsRouteArgs {
  const NewsDetailsRouteArgs({this.key, required this.isEvent});

  final _i12.Key? key;

  final bool isEvent;

  @override
  String toString() {
    return 'NewsDetailsRouteArgs{key: $key, isEvent: $isEvent}';
  }
}

/// generated route for
/// [_i2.LostAndFoundCreatePage]
class LostAndFoundCreateRoute extends _i11.PageRouteInfo<void> {
  const LostAndFoundCreateRoute()
      : super(LostAndFoundCreateRoute.name, path: 'lostandfound-create');

  static const String name = 'LostAndFoundCreateRoute';
}

/// generated route for
/// [_i3.HomePage]
class HomeRoute extends _i11.PageRouteInfo<void> {
  const HomeRoute({List<_i11.PageRouteInfo>? children})
      : super(HomeRoute.name, path: '/', initialChildren: children);

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i4.EmptyRouterPage]
class NewsRouter extends _i11.PageRouteInfo<void> {
  const NewsRouter({List<_i11.PageRouteInfo>? children})
      : super(NewsRouter.name, path: 'news', initialChildren: children);

  static const String name = 'NewsRouter';
}

/// generated route for
/// [_i4.EmptyRouterPage]
class ScheduleRouter extends _i11.PageRouteInfo<void> {
  const ScheduleRouter({List<_i11.PageRouteInfo>? children})
      : super(ScheduleRouter.name, path: 'schedule', initialChildren: children);

  static const String name = 'ScheduleRouter';
}

/// generated route for
/// [_i4.EmptyRouterPage]
class DashboardRouter extends _i11.PageRouteInfo<void> {
  const DashboardRouter({List<_i11.PageRouteInfo>? children})
      : super(DashboardRouter.name,
            path: 'dashboard', initialChildren: children);

  static const String name = 'DashboardRouter';
}

/// generated route for
/// [_i4.EmptyRouterPage]
class ProfileRouter extends _i11.PageRouteInfo<void> {
  const ProfileRouter({List<_i11.PageRouteInfo>? children})
      : super(ProfileRouter.name, path: 'profile', initialChildren: children);

  static const String name = 'ProfileRouter';
}

/// generated route for
/// [_i5.NewsPage]
class NewsRoute extends _i11.PageRouteInfo<void> {
  const NewsRoute() : super(NewsRoute.name, path: '');

  static const String name = 'NewsRoute';
}

/// generated route for
/// [_i6.SchedulePage]
class ScheduleRoute extends _i11.PageRouteInfo<void> {
  const ScheduleRoute() : super(ScheduleRoute.name, path: '');

  static const String name = 'ScheduleRoute';
}

/// generated route for
/// [_i7.DashboardPage]
class DashboardRoute extends _i11.PageRouteInfo<void> {
  const DashboardRoute() : super(DashboardRoute.name, path: '');

  static const String name = 'DashboardRoute';
}

/// generated route for
/// [_i8.LostAndFoundServicePage]
class LostAndFoundServiceRoute extends _i11.PageRouteInfo<void> {
  const LostAndFoundServiceRoute()
      : super(LostAndFoundServiceRoute.name, path: 'lost-and-found');

  static const String name = 'LostAndFoundServiceRoute';
}

/// generated route for
/// [_i9.ProfilePage]
class ProfileRoute extends _i11.PageRouteInfo<void> {
  const ProfileRoute() : super(ProfileRoute.name, path: '');

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i10.AboutAppPage]
class AboutAppRoute extends _i11.PageRouteInfo<void> {
  const AboutAppRoute() : super(AboutAppRoute.name, path: 'about');

  static const String name = 'AboutAppRoute';
}
