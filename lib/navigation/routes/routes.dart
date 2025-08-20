import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/article/view/article_page.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/view.dart';

import 'package:rtu_mirea_app/home/view/home_page.dart';
import 'package:rtu_mirea_app/lost_and_found/lost_and_found.dart';
import 'package:rtu_mirea_app/map/view/map_page_view.dart';
import 'package:rtu_mirea_app/nfc_pass/view/nfc_pass_page_view.dart';
import 'package:rtu_mirea_app/profile/profile.dart';
import 'package:rtu_mirea_app/profile/view/notifications_settings_page.dart';
import 'package:rtu_mirea_app/navigation/view/scaffold_navigation_shell.dart';
import 'package:rtu_mirea_app/feed/feed.dart';
import 'package:rtu_mirea_app/onboarding/view/onboarding_page.dart';
import 'package:rtu_mirea_app/profile/view/profile_settings_page.dart';
import 'package:rtu_mirea_app/rating_system_calculator/models/subject.dart';
import 'package:rtu_mirea_app/rating_system_calculator/view/about_rating_system_page.dart';
import 'package:rtu_mirea_app/rating_system_calculator/view/rating_system_calculator_page.dart';
import 'package:rtu_mirea_app/rating_system_calculator/view/subject_page.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';

import 'package:rtu_mirea_app/schedule_management/schedule_management.dart';
import 'package:rtu_mirea_app/search/view/search_page.dart';
import 'package:rtu_mirea_app/services/view/view.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:university_app_server_api/client.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'routes.g.dart';

@TypedGoRoute<HomeRoute>(path: '/home')
class HomeRoute extends GoRouteData {
  const HomeRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

@TypedGoRoute<OnboardingRoute>(path: '/onboarding')
class OnboardingRoute extends GoRouteData {
  const OnboardingRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OnBoardingPage();
}

@TypedStatefulShellRoute<ShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<FeedBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<FeedRoute>(
          path: '/feed',
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<ArticleRoute>(path: 'article/:articleId'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<ScheduleBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ScheduleRoute>(
          path: '/schedule',
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<CustomScheduleRoute>(path: 'custom'),
            TypedGoRoute<ScheduleSearchRoute>(path: 'search'),
            TypedGoRoute<ScheduleDetailsRoute>(path: 'details'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<ServicesBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ServicesRoute>(
          path: '/services',
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<NfcPassRoute>(path: 'nfc'),
            TypedGoRoute<MapRoute>(path: 'map'),
            TypedGoRoute<DiscoursePostOverviewRoute>(
              path: 'discourse-post-overview/:postId',
            ),
            TypedGoRoute<RatingSystemCalculatorRoute>(
              path: 'rating-system-calculator',
              routes: <TypedRoute<RouteData>>[
                TypedGoRoute<AboutRatingSystemRoute>(path: 'about'),
                TypedGoRoute<SubjectRoute>(path: 'subject'),
              ],
            ),
            TypedGoRoute<LostAndFoundRoute>(path: 'lost-and-found'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<ProfileBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ProfileRoute>(
          path: '/profile',
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<ScheduleManagementRoute>(path: 'schedule-management'),
            TypedGoRoute<AboutAppRoute>(path: 'about'),
            TypedGoRoute<ProfileSettingsRoute>(
              path: 'settings',
              routes: <TypedRoute<RouteData>>[
                TypedGoRoute<NotificationsSettingsRoute>(path: 'notifications'),
              ],
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<InfoBranchData>(
      routes: <TypedRoute<RouteData>>[TypedGoRoute<InfoRoute>(path: '/info')],
    ),
  ],
)
class ShellRouteData extends StatefulShellRouteData {
  const ShellRouteData();
  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return ScaffoldNavigationShell(navigationShell: navigationShell);
  }
}

class FeedBranchData extends StatefulShellBranchData {
  const FeedBranchData();
}

class ScheduleBranchData extends StatefulShellBranchData {
  const ScheduleBranchData();
}

class ServicesBranchData extends StatefulShellBranchData {
  const ServicesBranchData();
}

class ProfileBranchData extends StatefulShellBranchData {
  const ProfileBranchData();
}

class InfoBranchData extends StatefulShellBranchData {
  const InfoBranchData();
}

class FeedRoute extends GoRouteData {
  const FeedRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FeedView();
  }
}

class ArticleRoute extends GoRouteData {
  const ArticleRoute({
    required this.articleId,
    this.isVideo = false,
    this.adBehavior = InterstitialAdBehavior.onOpen,
  });

  final String articleId;
  final bool isVideo;
  final InterstitialAdBehavior adBehavior;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ArticlePage(
      id: articleId,
      isVideoArticle: isVideo,
      interstitialAdBehavior: adBehavior,
    );
  }
}

@TypedGoRoute<SlideshowRoute>(path: '/slideshow')
class SlideshowRoute extends GoRouteData {
  const SlideshowRoute({this.$extra});

  final Map<String, dynamic>? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final extra = (state.extra as Map<String, dynamic>?) ?? $extra ?? const {};
    final slideshow = extra['slideshow'] as SlideshowBlock?;
    if (slideshow == null) {
      return const Scaffold(body: SizedBox());
    }
    return Slideshow(
      block: slideshow,
      categoryTitle: context.l10n.slideshow,
      navigationLabel: '/',
    );
  }
}

class ScheduleRoute extends GoRouteData {
  const ScheduleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SchedulePage();
  }
}

class CustomScheduleRoute extends GoRouteData {
  const CustomScheduleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CustomSchedulesPage();
  }
}

class ScheduleSearchRoute extends GoRouteData {
  const ScheduleSearchRoute({this.query});

  final String? query;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SearchPage(query: query);
  }
}

class ScheduleDetailsRoute extends GoRouteData {
  const ScheduleDetailsRoute({required this.$extra});

  final (LessonSchedulePart, DateTime) $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ScheduleDetailsPage(lesson: $extra.$1, selectedDate: $extra.$2);
  }
}

class ServicesRoute extends GoRouteData {
  const ServicesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ServicesPage();
  }
}

class NfcPassRoute extends GoRouteData {
  const NfcPassRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NfcPassPageView();
  }
}

class MapRoute extends GoRouteData {
  const MapRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MapPageView();
  }
}

class DiscoursePostOverviewRoute extends GoRouteData {
  const DiscoursePostOverviewRoute({required this.postId});

  final int postId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DiscoursePostOverviewPageView(postId: postId);
  }
}

class RatingSystemCalculatorRoute extends GoRouteData {
  const RatingSystemCalculatorRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RatingSystemCalculatorPage();
  }
}

class AboutRatingSystemRoute extends GoRouteData {
  const AboutRatingSystemRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AboutRatingSystemPage();
  }
}

class SubjectRoute extends GoRouteData {
  const SubjectRoute({required this.$extra});

  final Subject $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SubjectPage(subject: $extra);
  }
}

class LostAndFoundRoute extends GoRouteData {
  const LostAndFoundRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LostFoundPage();
  }
}

class ProfileRoute extends GoRouteData {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfilePage();
  }
}

class ScheduleManagementRoute extends GoRouteData {
  const ScheduleManagementRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ScheduleManagementPage();
  }
}

class AboutAppRoute extends GoRouteData {
  const AboutAppRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AboutAppPage();
  }
}

class ProfileSettingsRoute extends GoRouteData {
  const ProfileSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfileSettingsPage();
  }
}

class NotificationsSettingsRoute extends GoRouteData {
  const NotificationsSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NotificationsSettingsPage();
  }
}

class InfoRoute extends GoRouteData {
  const InfoRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AboutAppPage();
  }
}

GoRouter createRouter() => GoRouter(
  routes: $appRoutes,
  initialLocation: '/home',
  debugLogDiagnostics: kDebugMode,
  observers: [
    FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
    SentryNavigatorObserver(
      autoFinishAfter: const Duration(seconds: 5),
      setRouteNameAsTransaction: true,
    ),
  ],
);
