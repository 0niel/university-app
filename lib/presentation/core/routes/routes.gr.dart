// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i16;
import 'package:rtu_mirea_app/domain/entities/news_item.dart' as _i17;
import 'package:rtu_mirea_app/domain/entities/user.dart' as _i18;
import 'package:rtu_mirea_app/presentation/pages/auth/login_page.dart' as _i2;
import 'package:rtu_mirea_app/presentation/pages/home_page.dart' as _i1;
import 'package:rtu_mirea_app/presentation/pages/map/map_page.dart' as _i6;
import 'package:rtu_mirea_app/presentation/pages/news/news_details_page.dart'
    as _i8;
import 'package:rtu_mirea_app/presentation/pages/news/news_page.dart' as _i7;
import 'package:rtu_mirea_app/presentation/pages/onboarding/onboarding_page.dart'
    as _i3;
import 'package:rtu_mirea_app/presentation/pages/profile/about_app_page.dart'
    as _i10;
import 'package:rtu_mirea_app/presentation/pages/profile/profile_announces_page.dart'
    as _i11;
import 'package:rtu_mirea_app/presentation/pages/profile/profile_attendance_page.dart'
    as _i12;
import 'package:rtu_mirea_app/presentation/pages/profile/profile_detail_page.dart'
    as _i13;
import 'package:rtu_mirea_app/presentation/pages/profile/profile_lectors_page.dart'
    as _i14;
import 'package:rtu_mirea_app/presentation/pages/profile/profile_page.dart'
    as _i9;
import 'package:rtu_mirea_app/presentation/pages/profile/profile_scores_page.dart'
    as _i15;
import 'package:rtu_mirea_app/presentation/pages/schedule/schedule_page.dart'
    as _i5;

class AppRouter extends _i4.RootStackRouter {
  AppRouter([_i16.GlobalKey<_i16.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i4.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i1.HomePage());
    },
    LoginRoute.name: (routeData) {
      return _i4.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i2.LoginPage());
    },
    OnBoardingRoute.name: (routeData) {
      return _i4.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i3.OnBoardingPage());
    },
    NewsRouter.name: (routeData) {
      return _i4.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.EmptyRouterPage());
    },
    ScheduleRoute.name: (routeData) {
      return _i4.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i5.SchedulePage());
    },
    MapRoute.name: (routeData) {
      return _i4.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i6.MapPage());
    },
    ProfileRouter.name: (routeData) {
      return _i4.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.EmptyRouterPage());
    },
    NewsRoute.name: (routeData) {
      return _i4.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i7.NewsPage());
    },
    NewsDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<NewsDetailsRouteArgs>();
      return _i4.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i8.NewsDetailsPage(key: args.key, newsItem: args.newsItem));
    },
    ProfileRoute.name: (routeData) {
      return _i4.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i9.ProfilePage());
    },
    AboutAppRoute.name: (routeData) {
      return _i4.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i10.AboutAppPage());
    },
    ProfileAnnouncesRoute.name: (routeData) {
      return _i4.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i11.ProfileAnnouncesPage());
    },
    ProfileAttendanceRoute.name: (routeData) {
      return _i4.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i12.ProfileAttendancePage());
    },
    ProfileDetailRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileDetailRouteArgs>();
      return _i4.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i13.ProfileDetailPage(key: args.key, user: args.user));
    },
    ProfileLectrosRoute.name: (routeData) {
      return _i4.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i14.ProfileLectrosPage());
    },
    ProfileScoresRoute.name: (routeData) {
      return _i4.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i15.ProfileScoresPage());
    }
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(HomeRoute.name, path: '/', children: [
          _i4.RouteConfig(NewsRouter.name,
              path: 'news',
              parent: HomeRoute.name,
              meta: <String, dynamic>{
                'title': 'Новости',
                'hideAppBar': false
              },
              children: [
                _i4.RouteConfig(NewsRoute.name,
                    path: '', parent: NewsRouter.name),
                _i4.RouteConfig(NewsDetailsRoute.name,
                    path: 'details',
                    parent: NewsRouter.name,
                    meta: <String, dynamic>{
                      'title': 'Детали',
                      'hideAppBar': true
                    })
              ]),
          _i4.RouteConfig(ScheduleRoute.name,
              path: 'schedule',
              parent: HomeRoute.name,
              meta: <String, dynamic>{
                'title': 'Расписание',
                'hideAppBar': false
              }),
          _i4.RouteConfig(MapRoute.name,
              path: 'map',
              parent: HomeRoute.name,
              meta: <String, dynamic>{'title': 'Карта', 'hideAppBar': true}),
          _i4.RouteConfig(ProfileRouter.name,
              path: 'profile',
              parent: HomeRoute.name,
              meta: <String, dynamic>{
                'title': 'Профиль',
                'hideAppBar': false
              },
              children: [
                _i4.RouteConfig(ProfileRoute.name,
                    path: '',
                    parent: ProfileRouter.name,
                    meta: <String, dynamic>{
                      'title': 'Профиль',
                      'hideAppBar': false
                    }),
                _i4.RouteConfig(AboutAppRoute.name,
                    path: 'about',
                    parent: ProfileRouter.name,
                    meta: <String, dynamic>{
                      'title': 'О приложении',
                      'hideAppBar': false
                    }),
                _i4.RouteConfig(ProfileAnnouncesRoute.name,
                    path: 'announces',
                    parent: ProfileRouter.name,
                    meta: <String, dynamic>{
                      'title': 'Объявления',
                      'hideAppBar': false
                    }),
                _i4.RouteConfig(ProfileAttendanceRoute.name,
                    path: 'attendance',
                    parent: ProfileRouter.name,
                    meta: <String, dynamic>{
                      'title': 'Посещаемость',
                      'hideAppBar': false
                    }),
                _i4.RouteConfig(ProfileDetailRoute.name,
                    path: 'details',
                    parent: ProfileRouter.name,
                    meta: <String, dynamic>{
                      'title': 'Детали профиля',
                      'hideAppBar': false
                    }),
                _i4.RouteConfig(ProfileLectrosRoute.name,
                    path: 'lectors',
                    parent: ProfileRouter.name,
                    meta: <String, dynamic>{
                      'title': 'Преподаватели',
                      'hideAppBar': false
                    }),
                _i4.RouteConfig(ProfileScoresRoute.name,
                    path: 'scores',
                    parent: ProfileRouter.name,
                    meta: <String, dynamic>{
                      'title': 'Зачётная книжка',
                      'hideAppBar': false
                    })
              ])
        ]),
        _i4.RouteConfig(LoginRoute.name, path: '/login'),
        _i4.RouteConfig(OnBoardingRoute.name, path: '/onboarding'),
        _i4.RouteConfig('*#redirect',
            path: '*', redirectTo: '/', fullMatch: true)
      ];
}

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i4.PageRouteInfo<void> {
  const HomeRoute({List<_i4.PageRouteInfo>? children})
      : super(HomeRoute.name, path: '/', initialChildren: children);

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i2.LoginPage]
class LoginRoute extends _i4.PageRouteInfo<void> {
  const LoginRoute() : super(LoginRoute.name, path: '/login');

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i3.OnBoardingPage]
class OnBoardingRoute extends _i4.PageRouteInfo<void> {
  const OnBoardingRoute() : super(OnBoardingRoute.name, path: '/onboarding');

  static const String name = 'OnBoardingRoute';
}

/// generated route for
/// [_i4.EmptyRouterPage]
class NewsRouter extends _i4.PageRouteInfo<void> {
  const NewsRouter({List<_i4.PageRouteInfo>? children})
      : super(NewsRouter.name, path: 'news', initialChildren: children);

  static const String name = 'NewsRouter';
}

/// generated route for
/// [_i5.SchedulePage]
class ScheduleRoute extends _i4.PageRouteInfo<void> {
  const ScheduleRoute() : super(ScheduleRoute.name, path: 'schedule');

  static const String name = 'ScheduleRoute';
}

/// generated route for
/// [_i6.MapPage]
class MapRoute extends _i4.PageRouteInfo<void> {
  const MapRoute() : super(MapRoute.name, path: 'map');

  static const String name = 'MapRoute';
}

/// generated route for
/// [_i4.EmptyRouterPage]
class ProfileRouter extends _i4.PageRouteInfo<void> {
  const ProfileRouter({List<_i4.PageRouteInfo>? children})
      : super(ProfileRouter.name, path: 'profile', initialChildren: children);

  static const String name = 'ProfileRouter';
}

/// generated route for
/// [_i7.NewsPage]
class NewsRoute extends _i4.PageRouteInfo<void> {
  const NewsRoute() : super(NewsRoute.name, path: '');

  static const String name = 'NewsRoute';
}

/// generated route for
/// [_i8.NewsDetailsPage]
class NewsDetailsRoute extends _i4.PageRouteInfo<NewsDetailsRouteArgs> {
  NewsDetailsRoute({_i16.Key? key, required _i17.NewsItem newsItem})
      : super(NewsDetailsRoute.name,
            path: 'details',
            args: NewsDetailsRouteArgs(key: key, newsItem: newsItem));

  static const String name = 'NewsDetailsRoute';
}

class NewsDetailsRouteArgs {
  const NewsDetailsRouteArgs({this.key, required this.newsItem});

  final _i16.Key? key;

  final _i17.NewsItem newsItem;

  @override
  String toString() {
    return 'NewsDetailsRouteArgs{key: $key, newsItem: $newsItem}';
  }
}

/// generated route for
/// [_i9.ProfilePage]
class ProfileRoute extends _i4.PageRouteInfo<void> {
  const ProfileRoute() : super(ProfileRoute.name, path: '');

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i10.AboutAppPage]
class AboutAppRoute extends _i4.PageRouteInfo<void> {
  const AboutAppRoute() : super(AboutAppRoute.name, path: 'about');

  static const String name = 'AboutAppRoute';
}

/// generated route for
/// [_i11.ProfileAnnouncesPage]
class ProfileAnnouncesRoute extends _i4.PageRouteInfo<void> {
  const ProfileAnnouncesRoute()
      : super(ProfileAnnouncesRoute.name, path: 'announces');

  static const String name = 'ProfileAnnouncesRoute';
}

/// generated route for
/// [_i12.ProfileAttendancePage]
class ProfileAttendanceRoute extends _i4.PageRouteInfo<void> {
  const ProfileAttendanceRoute()
      : super(ProfileAttendanceRoute.name, path: 'attendance');

  static const String name = 'ProfileAttendanceRoute';
}

/// generated route for
/// [_i13.ProfileDetailPage]
class ProfileDetailRoute extends _i4.PageRouteInfo<ProfileDetailRouteArgs> {
  ProfileDetailRoute({_i16.Key? key, required _i18.User user})
      : super(ProfileDetailRoute.name,
            path: 'details',
            args: ProfileDetailRouteArgs(key: key, user: user));

  static const String name = 'ProfileDetailRoute';
}

class ProfileDetailRouteArgs {
  const ProfileDetailRouteArgs({this.key, required this.user});

  final _i16.Key? key;

  final _i18.User user;

  @override
  String toString() {
    return 'ProfileDetailRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i14.ProfileLectrosPage]
class ProfileLectrosRoute extends _i4.PageRouteInfo<void> {
  const ProfileLectrosRoute()
      : super(ProfileLectrosRoute.name, path: 'lectors');

  static const String name = 'ProfileLectrosRoute';
}

/// generated route for
/// [_i15.ProfileScoresPage]
class ProfileScoresRoute extends _i4.PageRouteInfo<void> {
  const ProfileScoresRoute() : super(ProfileScoresRoute.name, path: 'scores');

  static const String name = 'ProfileScoresRoute';
}
