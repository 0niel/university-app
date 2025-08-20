// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeRoute,
      $onboardingRoute,
      $shellRouteData,
      $slideshowRoute,
    ];

RouteBase get $homeRoute => GoRouteData.$route(
      path: '/home',
      factory: $HomeRouteExtension._fromState,
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location(
        '/home',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $onboardingRoute => GoRouteData.$route(
      path: '/onboarding',
      factory: $OnboardingRouteExtension._fromState,
    );

extension $OnboardingRouteExtension on OnboardingRoute {
  static OnboardingRoute _fromState(GoRouterState state) =>
      const OnboardingRoute();

  String get location => GoRouteData.$location(
        '/onboarding',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $shellRouteData => StatefulShellRouteData.$route(
      factory: $ShellRouteDataExtension._fromState,
      branches: [
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/feed',
              factory: $FeedRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'article/:articleId',
                  factory: $ArticleRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/schedule',
              factory: $ScheduleRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'custom',
                  factory: $CustomScheduleRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'search',
                  factory: $ScheduleSearchRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'details',
                  factory: $ScheduleDetailsRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/services',
              factory: $ServicesRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'nfc',
                  factory: $NfcPassRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'map',
                  factory: $MapRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'discourse-post-overview/:postId',
                  factory: $DiscoursePostOverviewRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'rating-system-calculator',
                  factory: $RatingSystemCalculatorRouteExtension._fromState,
                  routes: [
                    GoRouteData.$route(
                      path: 'about',
                      factory: $AboutRatingSystemRouteExtension._fromState,
                    ),
                    GoRouteData.$route(
                      path: 'subject',
                      factory: $SubjectRouteExtension._fromState,
                    ),
                  ],
                ),
                GoRouteData.$route(
                  path: 'lost-and-found',
                  factory: $LostAndFoundRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/profile',
              factory: $ProfileRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'schedule-management',
                  factory: $ScheduleManagementRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'about',
                  factory: $AboutAppRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'settings',
                  factory: $ProfileSettingsRouteExtension._fromState,
                  routes: [
                    GoRouteData.$route(
                      path: 'notifications',
                      factory: $NotificationsSettingsRouteExtension._fromState,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/info',
              factory: $InfoRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );

extension $ShellRouteDataExtension on ShellRouteData {
  static ShellRouteData _fromState(GoRouterState state) =>
      const ShellRouteData();
}

extension $FeedRouteExtension on FeedRoute {
  static FeedRoute _fromState(GoRouterState state) => const FeedRoute();

  String get location => GoRouteData.$location(
        '/feed',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ArticleRouteExtension on ArticleRoute {
  static ArticleRoute _fromState(GoRouterState state) => ArticleRoute(
        articleId: state.pathParameters['articleId']!,
        isVideo: _$convertMapValue(
                'is-video', state.uri.queryParameters, _$boolConverter) ??
            false,
        adBehavior: _$convertMapValue('ad-behavior', state.uri.queryParameters,
                _$InterstitialAdBehaviorEnumMap._$fromName) ??
            InterstitialAdBehavior.onOpen,
      );

  String get location => GoRouteData.$location(
        '/feed/article/${Uri.encodeComponent(articleId)}',
        queryParams: {
          if (isVideo != false) 'is-video': isVideo.toString(),
          if (adBehavior != InterstitialAdBehavior.onOpen)
            'ad-behavior': _$InterstitialAdBehaviorEnumMap[adBehavior],
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

const _$InterstitialAdBehaviorEnumMap = {
  InterstitialAdBehavior.onOpen: 'on-open',
  InterstitialAdBehavior.onClose: 'on-close',
};

extension $ScheduleRouteExtension on ScheduleRoute {
  static ScheduleRoute _fromState(GoRouterState state) => const ScheduleRoute();

  String get location => GoRouteData.$location(
        '/schedule',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CustomScheduleRouteExtension on CustomScheduleRoute {
  static CustomScheduleRoute _fromState(GoRouterState state) =>
      const CustomScheduleRoute();

  String get location => GoRouteData.$location(
        '/schedule/custom',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ScheduleSearchRouteExtension on ScheduleSearchRoute {
  static ScheduleSearchRoute _fromState(GoRouterState state) =>
      ScheduleSearchRoute(
        query: state.uri.queryParameters['query'],
      );

  String get location => GoRouteData.$location(
        '/schedule/search',
        queryParams: {
          if (query != null) 'query': query,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ScheduleDetailsRouteExtension on ScheduleDetailsRoute {
  static ScheduleDetailsRoute _fromState(GoRouterState state) =>
      ScheduleDetailsRoute(
        $extra: state.extra as (LessonSchedulePart, DateTime),
      );

  String get location => GoRouteData.$location(
        '/schedule/details',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $ServicesRouteExtension on ServicesRoute {
  static ServicesRoute _fromState(GoRouterState state) => const ServicesRoute();

  String get location => GoRouteData.$location(
        '/services',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $NfcPassRouteExtension on NfcPassRoute {
  static NfcPassRoute _fromState(GoRouterState state) => const NfcPassRoute();

  String get location => GoRouteData.$location(
        '/services/nfc',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MapRouteExtension on MapRoute {
  static MapRoute _fromState(GoRouterState state) => const MapRoute();

  String get location => GoRouteData.$location(
        '/services/map',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DiscoursePostOverviewRouteExtension on DiscoursePostOverviewRoute {
  static DiscoursePostOverviewRoute _fromState(GoRouterState state) =>
      DiscoursePostOverviewRoute(
        postId: int.parse(state.pathParameters['postId']!)!,
      );

  String get location => GoRouteData.$location(
        '/services/discourse-post-overview/${Uri.encodeComponent(postId.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $RatingSystemCalculatorRouteExtension on RatingSystemCalculatorRoute {
  static RatingSystemCalculatorRoute _fromState(GoRouterState state) =>
      const RatingSystemCalculatorRoute();

  String get location => GoRouteData.$location(
        '/services/rating-system-calculator',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AboutRatingSystemRouteExtension on AboutRatingSystemRoute {
  static AboutRatingSystemRoute _fromState(GoRouterState state) =>
      const AboutRatingSystemRoute();

  String get location => GoRouteData.$location(
        '/services/rating-system-calculator/about',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SubjectRouteExtension on SubjectRoute {
  static SubjectRoute _fromState(GoRouterState state) => SubjectRoute(
        $extra: state.extra as Subject,
      );

  String get location => GoRouteData.$location(
        '/services/rating-system-calculator/subject',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $LostAndFoundRouteExtension on LostAndFoundRoute {
  static LostAndFoundRoute _fromState(GoRouterState state) =>
      const LostAndFoundRoute();

  String get location => GoRouteData.$location(
        '/services/lost-and-found',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProfileRouteExtension on ProfileRoute {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  String get location => GoRouteData.$location(
        '/profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ScheduleManagementRouteExtension on ScheduleManagementRoute {
  static ScheduleManagementRoute _fromState(GoRouterState state) =>
      const ScheduleManagementRoute();

  String get location => GoRouteData.$location(
        '/profile/schedule-management',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AboutAppRouteExtension on AboutAppRoute {
  static AboutAppRoute _fromState(GoRouterState state) => const AboutAppRoute();

  String get location => GoRouteData.$location(
        '/profile/about',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProfileSettingsRouteExtension on ProfileSettingsRoute {
  static ProfileSettingsRoute _fromState(GoRouterState state) =>
      const ProfileSettingsRoute();

  String get location => GoRouteData.$location(
        '/profile/settings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $NotificationsSettingsRouteExtension on NotificationsSettingsRoute {
  static NotificationsSettingsRoute _fromState(GoRouterState state) =>
      const NotificationsSettingsRoute();

  String get location => GoRouteData.$location(
        '/profile/settings/notifications',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $InfoRouteExtension on InfoRoute {
  static InfoRoute _fromState(GoRouterState state) => const InfoRoute();

  String get location => GoRouteData.$location(
        '/info',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}

extension<T extends Enum> on Map<T, String> {
  T? _$fromName(String? value) =>
      entries.where((element) => element.value == value).firstOrNull?.key;
}

RouteBase get $slideshowRoute => GoRouteData.$route(
      path: '/slideshow',
      factory: $SlideshowRouteExtension._fromState,
    );

extension $SlideshowRouteExtension on SlideshowRoute {
  static SlideshowRoute _fromState(GoRouterState state) => SlideshowRoute(
        $extra: state.extra as Map<String, dynamic>?,
      );

  String get location => GoRouteData.$location(
        '/slideshow',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}
