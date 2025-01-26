import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/view.dart';
import 'package:rtu_mirea_app/domain/entities/news_item.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';
import 'package:rtu_mirea_app/domain/entities/user.dart';
import 'package:rtu_mirea_app/home/view/home_page.dart';
import 'package:rtu_mirea_app/map/view/map_page_view.dart';
import 'package:rtu_mirea_app/nfc_pass/view/nfc_pass_page_view.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/notifications_settings_page.dart';
import 'package:rtu_mirea_app/navigation/view/scaffold_navigation_shell.dart';
import 'package:rtu_mirea_app/presentation/pages/news/news_details_page.dart';
import 'package:rtu_mirea_app/presentation/pages/news/news_page.dart';
import 'package:rtu_mirea_app/onboarding/view/onboarding_page.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/about_app_page.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/profile_announces_page.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/profile_attendance_page.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/profile_detail_page.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/profile_lectors_page.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/profile_scores_page.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/profile_settings_page.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/profile/profile.dart';
import 'package:rtu_mirea_app/rating_system_calculator/models/models.dart';
import 'package:rtu_mirea_app/rating_system_calculator/view/about_rating_system_page.dart';
import 'package:rtu_mirea_app/rating_system_calculator/view/subject_page.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_details_page.dart';
import 'package:rtu_mirea_app/rating_system_calculator/view/rating_system_calculator_page.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page.dart';
import 'package:rtu_mirea_app/schedule_management/schedule_management.dart';
import 'package:rtu_mirea_app/search/view/search_page.dart';
import 'package:rtu_mirea_app/services/view/view.dart';
import 'package:rtu_mirea_app/stories/stories.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:university_app_server_api/client.dart';
import 'package:neon_framework/src/router.dart' as neon;
import 'package:url_launcher/url_launcher_string.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _newsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'news');
final GlobalKey<NavigatorState> _scheduleNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'schedule');
final GlobalKey<NavigatorState> _servicesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'services');
final GlobalKey<NavigatorState> _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');
final GlobalKey<NavigatorState> _infoNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'info');

String _getNeonPathInCurrentRouter(String neonRouterPath) {
  late final String path;
  if (neonRouterPath.startsWith('/') && neonRouterPath.length > 1) {
    path = 'neon-${neonRouterPath.substring(1)}';
  } else if (neonRouterPath.startsWith('/') && neonRouterPath.length == 1) {
    path = 'neon';
  } else {
    path = neonRouterPath;
  }

  return path;
}

GoRouter createRouter() => GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/home',
      debugLogDiagnostics: kDebugMode,
      redirect: (context, state) {
        if (state.matchedLocation.contains('neon')) {
          final redirectPath = neon.redirect(context, state);

          if (redirectPath != null) {
            final pathInCurrentRouter = _getNeonPathInCurrentRouter(redirectPath);
            return '/services/$pathInCurrentRouter';
          } else if (state.matchedLocation.startsWith('neon')) {
            return '/services/${state.uri}';
          }
        }
        if (state.uri.scheme == 'http' || state.uri.scheme == 'https') {
          launchUrlString(state.uri.toString());
        }

        return null;
      },
      routes: [
        GoRoute(path: '/', redirect: (_, __) => '/schedule'),
        StatefulShellRoute.indexedStack(
          builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
            return ScaffoldNavigationShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(navigatorKey: _newsNavigatorKey, routes: [
              GoRoute(
                path: '/news',
                builder: (context, state) => const NewsPage(),
                routes: [
                  GoRoute(
                    path: 'details',
                    builder: (context, state) => NewsDetailsPage(newsItem: state.extra as NewsItem),
                    redirect: (context, state) {
                      if (state.extra == null) {
                        return '/news';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ]),
            StatefulShellBranch(navigatorKey: _scheduleNavigatorKey, routes: [
              GoRoute(
                path: '/schedule',
                builder: (context, state) => const SchedulePage(),
                routes: [
                  GoRoute(
                    path: 'search',
                    builder: (context, state) => SearchPage(query: state.extra as String?),
                  ),
                  GoRoute(
                    path: 'details',
                    redirect: (context, state) {
                      try {
                        state.extra as (LessonSchedulePart, DateTime);
                        return null;
                      } catch (e) {
                        return '/schedule';
                      }
                    },
                    builder: (context, state) {
                      final extra = state.extra as (LessonSchedulePart, DateTime);

                      return ScheduleDetailsPage(
                        lesson: extra.$1,
                        selectedDate: extra.$2,
                      );
                    },
                  ),
                ],
              ),
            ]),
            StatefulShellBranch(
              navigatorKey: _servicesNavigatorKey,
              routes: [
                GoRoute(
                  path: '/services',
                  builder: (context, state) => const ServicesPage(),
                  routes: [
                    GoRoute(path: 'nfc', builder: (context, state) => const NfcPassPageView()),
                    GoRoute(
                      path: 'map',
                      builder: (context, state) => const MapPageView(),
                    ),
                    GoRoute(
                      path: 'discourse-post-overview/:postId',
                      builder: (context, state) {
                        final postId = int.parse(state.pathParameters['postId'] ?? '0');
                        return DiscoursePostOverviewPageView(postId: postId);
                      },
                    ),
                    GoRoute(
                      path: 'rating-system-calculator',
                      builder: (context, state) => const RatingSystemCalculatorPage(),
                      routes: [
                        GoRoute(
                          path: 'about',
                          builder: (context, state) => const AboutRatingSystemPage(),
                        ),
                        GoRoute(
                          path: 'subject',
                          builder: (context, state) => SubjectPage(
                            subject: state.extra as Subject,
                          ),
                        ),
                      ],
                    ),
                    ...neon.$appRoutes.map((route) {
                      if (route is GoRoute) {
                        return GoRoute(
                          path: _getNeonPathInCurrentRouter(route.path),
                          name: route.name,
                          builder: route.builder != null
                              ? (context, state) {
                                  final theme = Theme.of(context).copyWith(
                                    listTileTheme: ListTileThemeData(
                                      tileColor: Colors.transparent,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                                      leadingAndTrailingTextStyle: AppTextStyle.chip.copyWith(
                                        color: Theme.of(context).extension<AppColors>()!.active,
                                      ),
                                      titleTextStyle: AppTextStyle.titleM.copyWith(
                                        color: Theme.of(context).extension<AppColors>()!.active,
                                      ),
                                      subtitleTextStyle: AppTextStyle.chip.copyWith(
                                        color: Theme.of(context).extension<AppColors>()!.deactive,
                                      ),
                                    ),
                                  );
                                  return Theme(data: theme, child: route.builder!(context, state));
                                }
                              : null,
                          redirect: route.redirect,
                          routes: route.routes,
                          pageBuilder: route.pageBuilder,
                          parentNavigatorKey: route.parentNavigatorKey,
                        );
                      }

                      return route;
                    }),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(navigatorKey: _profileNavigatorKey, routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'schedule-management',
                    builder: (context, state) => const ScheduleManagementPage(),
                  ),
                  GoRoute(
                    path: 'about',
                    builder: (context, state) => const AboutAppPage(),
                  ),
                  GoRoute(
                    path: 'announces',
                    builder: (context, state) => const ProfileAnnouncesPage(),
                  ),
                  GoRoute(
                    path: 'attendance',
                    builder: (context, state) => const ProfileAttendancePage(),
                  ),
                  GoRoute(
                    path: 'details',
                    builder: (context, state) => ProfileDetailPage(user: state.extra as User),
                    redirect: (context, state) {
                      if (state.extra == null) {
                        return '/profile';
                      }
                      return null;
                    },
                  ),
                  GoRoute(
                    path: 'lectors',
                    builder: (context, state) => const ProfileLectrosPage(),
                  ),
                  GoRoute(
                    path: 'scores',
                    builder: (context, state) => const ProfileScoresPage(),
                  ),
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const ProfileSettingsPage(),
                    routes: [
                      GoRoute(
                        path: 'notifications',
                        builder: (context, state) => const NotificationsSettingsPage(),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
            StatefulShellBranch(navigatorKey: _infoNavigatorKey, routes: [
              GoRoute(path: '/info', builder: (context, state) => const AboutAppPage()),
            ]),
          ],
        ),
        GoRoute(
          path: '/story/:index',
          pageBuilder: (context, state) => CustomTransitionPage(
            fullscreenDialog: true,
            opaque: false,
            transitionsBuilder: (_, __, ___, child) => child,
            child: StoriesPageView(
              stories: state.extra as List<Story>,
              storyIndex: int.parse(state.pathParameters['index'] ?? '0'),
            ),
          ),
          redirect: (context, state) {
            if (state.extra == null) {
              return '/schedule';
            }
            return null;
          },
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnBoardingPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/image',
          pageBuilder: (context, state) => CustomTransitionPage(
            fullscreenDialog: true,
            opaque: false,
            transitionsBuilder: (_, __, ___, child) => child,
            child: ImagesViewGallery(
              imageUrls: List<String>.from(state.extra as List<dynamic>),
            ),
          ),
        ),
      ],
      observers: [
        FirebaseAnalyticsObserver(
          analytics: FirebaseAnalytics.instance,
        ),
        SentryNavigatorObserver(
          autoFinishAfter: const Duration(seconds: 5),
          setRouteNameAsTransaction: true,
        ),
      ],
    );
