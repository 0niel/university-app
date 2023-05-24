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
import 'package:auto_route/auto_route.dart' as _i20;
import 'package:auto_route/empty_router_widgets.dart' as _i4;
import 'package:flutter/material.dart' as _i21;
import 'package:rtu_mirea_app/domain/entities/news_item.dart' as _i24;
import 'package:rtu_mirea_app/domain/entities/story.dart' as _i23;
import 'package:rtu_mirea_app/domain/entities/user.dart' as _i25;
import 'package:rtu_mirea_app/presentation/core/routes/routes.dart' as _i22;
import 'package:rtu_mirea_app/presentation/pages/home_page.dart' as _i1;
import 'package:rtu_mirea_app/presentation/pages/login/login_page.dart' as _i12;
import 'package:rtu_mirea_app/presentation/pages/map/map_page.dart' as _i5;
import 'package:rtu_mirea_app/presentation/pages/news/news_details_page.dart'
    as _i10;
import 'package:rtu_mirea_app/presentation/pages/news/news_page.dart' as _i9;
import 'package:rtu_mirea_app/presentation/pages/news/widgets/stories_wrapper.dart'
    as _i3;
import 'package:rtu_mirea_app/presentation/pages/onboarding/onboarding_page.dart'
    as _i2;
import 'package:rtu_mirea_app/presentation/pages/profile/about_app_page.dart'
    as _i6;
import 'package:rtu_mirea_app/presentation/pages/profile/profile_announces_page.dart'
    as _i13;
import 'package:rtu_mirea_app/presentation/pages/profile/profile_attendance_page.dart'
    as _i14;
import 'package:rtu_mirea_app/presentation/pages/profile/profile_detail_page.dart'
    as _i15;
import 'package:rtu_mirea_app/presentation/pages/profile/profile_lectors_page.dart'
    as _i16;
import 'package:rtu_mirea_app/presentation/pages/profile/profile_nfc_pass_page.dart'
    as _i19;
import 'package:rtu_mirea_app/presentation/pages/profile/profile_page.dart'
    as _i11;
import 'package:rtu_mirea_app/presentation/pages/profile/profile_scores_page.dart'
    as _i17;
import 'package:rtu_mirea_app/presentation/pages/profile/profile_settings_page.dart'
    as _i18;
import 'package:rtu_mirea_app/presentation/pages/schedule/groups_select_page.dart'
    as _i8;
import 'package:rtu_mirea_app/presentation/pages/schedule/schedule_page.dart'
    as _i7;

class AppRouter extends _i20.RootStackRouter {
  AppRouter([_i21.GlobalKey<_i21.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i20.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.HomePage(),
      );
    },
    OnBoardingRoute.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.OnBoardingPage(),
      );
    },
    StoriesWrapperRoute.name: (routeData) {
      final args = routeData.argsAs<StoriesWrapperRouteArgs>();
      return _i20.CustomPage<dynamic>(
        routeData: routeData,
        child: _i3.StoriesWrapper(
          key: args.key,
          stories: args.stories,
          storyIndex: args.storyIndex,
        ),
        customRouteBuilder: _i22.transparentRoute,
        opaque: false,
        barrierDismissible: false,
      );
    },
    ScheduleRouter.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i4.EmptyRouterPage(),
      );
    },
    NewsRouter.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i4.EmptyRouterPage(),
      );
    },
    MapRoute.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i5.MapPage(),
      );
    },
    ProfileRouter.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i4.EmptyRouterPage(),
      );
    },
    AboutAppDesktopRoute.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i6.AboutAppPage(),
      );
    },
    ScheduleRoute.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i7.SchedulePage(),
      );
    },
    GroupsSelectRoute.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i8.GroupsSelectPage(),
      );
    },
    NewsRoute.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i9.NewsPage(),
      );
    },
    NewsDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<NewsDetailsRouteArgs>();
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i10.NewsDetailsPage(
          key: args.key,
          newsItem: args.newsItem,
        ),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i11.ProfilePage(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i12.LoginPage(),
      );
    },
    AboutAppRoute.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i6.AboutAppPage(),
      );
    },
    ProfileAnnouncesRoute.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i13.ProfileAnnouncesPage(),
      );
    },
    ProfileAttendanceRoute.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i14.ProfileAttendancePage(),
      );
    },
    ProfileDetailRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileDetailRouteArgs>();
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i15.ProfileDetailPage(
          key: args.key,
          user: args.user,
        ),
      );
    },
    ProfileLectrosRoute.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i16.ProfileLectrosPage(),
      );
    },
    ProfileScoresRoute.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i17.ProfileScoresPage(),
      );
    },
    ProfileSettingsRoute.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i18.ProfileSettingsPage(),
      );
    },
    ProfileNfcPassRoute.name: (routeData) {
      return _i20.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i19.ProfileNfcPassPage(),
      );
    },
  };

  @override
  List<_i20.RouteConfig> get routes => [
        _i20.RouteConfig(
          HomeRoute.name,
          path: '/',
          children: [
            _i20.RouteConfig(
              '#redirect',
              path: '',
              parent: HomeRoute.name,
              redirectTo: 'schedule',
              fullMatch: true,
            ),
            _i20.RouteConfig(
              ScheduleRouter.name,
              path: 'schedule',
              parent: HomeRoute.name,
              children: [
                _i20.RouteConfig(
                  ScheduleRoute.name,
                  path: '',
                  parent: ScheduleRouter.name,
                ),
                _i20.RouteConfig(
                  GroupsSelectRoute.name,
                  path: 'select-group',
                  parent: ScheduleRouter.name,
                ),
              ],
            ),
            _i20.RouteConfig(
              NewsRouter.name,
              path: 'news',
              parent: HomeRoute.name,
              children: [
                _i20.RouteConfig(
                  NewsRoute.name,
                  path: '',
                  parent: NewsRouter.name,
                ),
                _i20.RouteConfig(
                  NewsDetailsRoute.name,
                  path: 'details',
                  parent: NewsRouter.name,
                ),
              ],
            ),
            _i20.RouteConfig(
              MapRoute.name,
              path: 'map',
              parent: HomeRoute.name,
            ),
            _i20.RouteConfig(
              ProfileRouter.name,
              path: 'profile',
              parent: HomeRoute.name,
              children: [
                _i20.RouteConfig(
                  ProfileRoute.name,
                  path: '',
                  parent: ProfileRouter.name,
                ),
                _i20.RouteConfig(
                  LoginRoute.name,
                  path: 'login',
                  parent: ProfileRouter.name,
                ),
                _i20.RouteConfig(
                  AboutAppRoute.name,
                  path: 'about',
                  parent: ProfileRouter.name,
                ),
                _i20.RouteConfig(
                  ProfileAnnouncesRoute.name,
                  path: 'announces',
                  parent: ProfileRouter.name,
                ),
                _i20.RouteConfig(
                  ProfileAttendanceRoute.name,
                  path: 'attendance',
                  parent: ProfileRouter.name,
                ),
                _i20.RouteConfig(
                  ProfileDetailRoute.name,
                  path: 'details',
                  parent: ProfileRouter.name,
                ),
                _i20.RouteConfig(
                  ProfileLectrosRoute.name,
                  path: 'lectors',
                  parent: ProfileRouter.name,
                ),
                _i20.RouteConfig(
                  ProfileScoresRoute.name,
                  path: 'scores',
                  parent: ProfileRouter.name,
                ),
                _i20.RouteConfig(
                  ProfileSettingsRoute.name,
                  path: 'settings',
                  parent: ProfileRouter.name,
                ),
                _i20.RouteConfig(
                  ProfileNfcPassRoute.name,
                  path: 'nfc-pass',
                  parent: ProfileRouter.name,
                ),
              ],
            ),
            _i20.RouteConfig(
              AboutAppDesktopRoute.name,
              path: 'info',
              parent: HomeRoute.name,
            ),
          ],
        ),
        _i20.RouteConfig(
          OnBoardingRoute.name,
          path: '/onboarding',
        ),
        _i20.RouteConfig(
          StoriesWrapperRoute.name,
          path: '/story',
        ),
        _i20.RouteConfig(
          '*#redirect',
          path: '*',
          redirectTo: '/',
          fullMatch: true,
        ),
      ];
}

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i20.PageRouteInfo<void> {
  const HomeRoute({List<_i20.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i2.OnBoardingPage]
class OnBoardingRoute extends _i20.PageRouteInfo<void> {
  const OnBoardingRoute()
      : super(
          OnBoardingRoute.name,
          path: '/onboarding',
        );

  static const String name = 'OnBoardingRoute';
}

/// generated route for
/// [_i3.StoriesWrapper]
class StoriesWrapperRoute extends _i20.PageRouteInfo<StoriesWrapperRouteArgs> {
  StoriesWrapperRoute({
    _i21.Key? key,
    required List<_i23.Story> stories,
    required int storyIndex,
  }) : super(
          StoriesWrapperRoute.name,
          path: '/story',
          args: StoriesWrapperRouteArgs(
            key: key,
            stories: stories,
            storyIndex: storyIndex,
          ),
        );

  static const String name = 'StoriesWrapperRoute';
}

class StoriesWrapperRouteArgs {
  const StoriesWrapperRouteArgs({
    this.key,
    required this.stories,
    required this.storyIndex,
  });

  final _i21.Key? key;

  final List<_i23.Story> stories;

  final int storyIndex;

  @override
  String toString() {
    return 'StoriesWrapperRouteArgs{key: $key, stories: $stories, storyIndex: $storyIndex}';
  }
}

/// generated route for
/// [_i4.EmptyRouterPage]
class ScheduleRouter extends _i20.PageRouteInfo<void> {
  const ScheduleRouter({List<_i20.PageRouteInfo>? children})
      : super(
          ScheduleRouter.name,
          path: 'schedule',
          initialChildren: children,
        );

  static const String name = 'ScheduleRouter';
}

/// generated route for
/// [_i4.EmptyRouterPage]
class NewsRouter extends _i20.PageRouteInfo<void> {
  const NewsRouter({List<_i20.PageRouteInfo>? children})
      : super(
          NewsRouter.name,
          path: 'news',
          initialChildren: children,
        );

  static const String name = 'NewsRouter';
}

/// generated route for
/// [_i5.MapPage]
class MapRoute extends _i20.PageRouteInfo<void> {
  const MapRoute()
      : super(
          MapRoute.name,
          path: 'map',
        );

  static const String name = 'MapRoute';
}

/// generated route for
/// [_i4.EmptyRouterPage]
class ProfileRouter extends _i20.PageRouteInfo<void> {
  const ProfileRouter({List<_i20.PageRouteInfo>? children})
      : super(
          ProfileRouter.name,
          path: 'profile',
          initialChildren: children,
        );

  static const String name = 'ProfileRouter';
}

/// generated route for
/// [_i6.AboutAppPage]
class AboutAppDesktopRoute extends _i20.PageRouteInfo<void> {
  const AboutAppDesktopRoute()
      : super(
          AboutAppDesktopRoute.name,
          path: 'info',
        );

  static const String name = 'AboutAppDesktopRoute';
}

/// generated route for
/// [_i7.SchedulePage]
class ScheduleRoute extends _i20.PageRouteInfo<void> {
  const ScheduleRoute()
      : super(
          ScheduleRoute.name,
          path: '',
        );

  static const String name = 'ScheduleRoute';
}

/// generated route for
/// [_i8.GroupsSelectPage]
class GroupsSelectRoute extends _i20.PageRouteInfo<void> {
  const GroupsSelectRoute()
      : super(
          GroupsSelectRoute.name,
          path: 'select-group',
        );

  static const String name = 'GroupsSelectRoute';
}

/// generated route for
/// [_i9.NewsPage]
class NewsRoute extends _i20.PageRouteInfo<void> {
  const NewsRoute()
      : super(
          NewsRoute.name,
          path: '',
        );

  static const String name = 'NewsRoute';
}

/// generated route for
/// [_i10.NewsDetailsPage]
class NewsDetailsRoute extends _i20.PageRouteInfo<NewsDetailsRouteArgs> {
  NewsDetailsRoute({
    _i21.Key? key,
    required _i24.NewsItem newsItem,
  }) : super(
          NewsDetailsRoute.name,
          path: 'details',
          args: NewsDetailsRouteArgs(
            key: key,
            newsItem: newsItem,
          ),
        );

  static const String name = 'NewsDetailsRoute';
}

class NewsDetailsRouteArgs {
  const NewsDetailsRouteArgs({
    this.key,
    required this.newsItem,
  });

  final _i21.Key? key;

  final _i24.NewsItem newsItem;

  @override
  String toString() {
    return 'NewsDetailsRouteArgs{key: $key, newsItem: $newsItem}';
  }
}

/// generated route for
/// [_i11.ProfilePage]
class ProfileRoute extends _i20.PageRouteInfo<void> {
  const ProfileRoute()
      : super(
          ProfileRoute.name,
          path: '',
        );

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i12.LoginPage]
class LoginRoute extends _i20.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: 'login',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i6.AboutAppPage]
class AboutAppRoute extends _i20.PageRouteInfo<void> {
  const AboutAppRoute()
      : super(
          AboutAppRoute.name,
          path: 'about',
        );

  static const String name = 'AboutAppRoute';
}

/// generated route for
/// [_i13.ProfileAnnouncesPage]
class ProfileAnnouncesRoute extends _i20.PageRouteInfo<void> {
  const ProfileAnnouncesRoute()
      : super(
          ProfileAnnouncesRoute.name,
          path: 'announces',
        );

  static const String name = 'ProfileAnnouncesRoute';
}

/// generated route for
/// [_i14.ProfileAttendancePage]
class ProfileAttendanceRoute extends _i20.PageRouteInfo<void> {
  const ProfileAttendanceRoute()
      : super(
          ProfileAttendanceRoute.name,
          path: 'attendance',
        );

  static const String name = 'ProfileAttendanceRoute';
}

/// generated route for
/// [_i15.ProfileDetailPage]
class ProfileDetailRoute extends _i20.PageRouteInfo<ProfileDetailRouteArgs> {
  ProfileDetailRoute({
    _i21.Key? key,
    required _i25.User user,
  }) : super(
          ProfileDetailRoute.name,
          path: 'details',
          args: ProfileDetailRouteArgs(
            key: key,
            user: user,
          ),
        );

  static const String name = 'ProfileDetailRoute';
}

class ProfileDetailRouteArgs {
  const ProfileDetailRouteArgs({
    this.key,
    required this.user,
  });

  final _i21.Key? key;

  final _i25.User user;

  @override
  String toString() {
    return 'ProfileDetailRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i16.ProfileLectrosPage]
class ProfileLectrosRoute extends _i20.PageRouteInfo<void> {
  const ProfileLectrosRoute()
      : super(
          ProfileLectrosRoute.name,
          path: 'lectors',
        );

  static const String name = 'ProfileLectrosRoute';
}

/// generated route for
/// [_i17.ProfileScoresPage]
class ProfileScoresRoute extends _i20.PageRouteInfo<void> {
  const ProfileScoresRoute()
      : super(
          ProfileScoresRoute.name,
          path: 'scores',
        );

  static const String name = 'ProfileScoresRoute';
}

/// generated route for
/// [_i18.ProfileSettingsPage]
class ProfileSettingsRoute extends _i20.PageRouteInfo<void> {
  const ProfileSettingsRoute()
      : super(
          ProfileSettingsRoute.name,
          path: 'settings',
        );

  static const String name = 'ProfileSettingsRoute';
}

/// generated route for
/// [_i19.ProfileNfcPassPage]
class ProfileNfcPassRoute extends _i20.PageRouteInfo<void> {
  const ProfileNfcPassRoute()
      : super(
          ProfileNfcPassRoute.name,
          path: 'nfc-pass',
        );

  static const String name = 'ProfileNfcPassRoute';
}
