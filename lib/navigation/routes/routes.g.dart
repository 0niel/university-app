// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $onboardingRoute,
  $authRoute,
  $signUpRoute,
  $passwordResetRoute,
  $loginWithEmailRoute,
  $loginEmailConfirmationRoute,
  $globalSearchRoute,
  $shellRouteData,
  $slideshowRoute,
];

RouteBase get $onboardingRoute => GoRouteData.$route(
  path: '/onboarding',
  factory: $OnboardingRoute._fromState,
);

mixin $OnboardingRoute on GoRouteData {
  static OnboardingRoute _fromState(GoRouterState state) =>
      const OnboardingRoute();

  @override
  String get location => GoRouteData.$location('/onboarding');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $authRoute =>
    GoRouteData.$route(path: '/auth', factory: $AuthRoute._fromState);

mixin $AuthRoute on GoRouteData {
  static AuthRoute _fromState(GoRouterState state) => const AuthRoute();

  @override
  String get location => GoRouteData.$location('/auth');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signUpRoute =>
    GoRouteData.$route(path: '/sign-up', factory: $SignUpRoute._fromState);

mixin $SignUpRoute on GoRouteData {
  static SignUpRoute _fromState(GoRouterState state) => const SignUpRoute();

  @override
  String get location => GoRouteData.$location('/sign-up');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $passwordResetRoute => GoRouteData.$route(
  path: '/password-reset',
  factory: $PasswordResetRoute._fromState,
);

mixin $PasswordResetRoute on GoRouteData {
  static PasswordResetRoute _fromState(GoRouterState state) =>
      const PasswordResetRoute();

  @override
  String get location => GoRouteData.$location('/password-reset');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginWithEmailRoute => GoRouteData.$route(
  path: '/login-with-email',
  factory: $LoginWithEmailRoute._fromState,
);

mixin $LoginWithEmailRoute on GoRouteData {
  static LoginWithEmailRoute _fromState(GoRouterState state) =>
      const LoginWithEmailRoute();

  @override
  String get location => GoRouteData.$location('/login-with-email');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginEmailConfirmationRoute => GoRouteData.$route(
  path: '/login-email-confirmation',
  factory: $LoginEmailConfirmationRoute._fromState,
);

mixin $LoginEmailConfirmationRoute on GoRouteData {
  static LoginEmailConfirmationRoute _fromState(GoRouterState state) =>
      LoginEmailConfirmationRoute(email: state.uri.queryParameters['email']!);

  LoginEmailConfirmationRoute get _self => this as LoginEmailConfirmationRoute;

  @override
  String get location => GoRouteData.$location(
    '/login-email-confirmation',
    queryParams: {'email': _self.email},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $globalSearchRoute =>
    GoRouteData.$route(path: '/search', factory: $GlobalSearchRoute._fromState);

mixin $GlobalSearchRoute on GoRouteData {
  static GlobalSearchRoute _fromState(GoRouterState state) =>
      GlobalSearchRoute(query: state.uri.queryParameters['query']);

  GlobalSearchRoute get _self => this as GlobalSearchRoute;

  @override
  String get location => GoRouteData.$location(
    '/search',
    queryParams: {if (_self.query != null) 'query': _self.query},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $shellRouteData => StatefulShellRouteData.$route(
  navigatorContainerBuilder: ShellRouteData.$navigatorContainerBuilder,
  factory: $ShellRouteDataExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/feed',
          factory: $FeedRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'news',
              factory: $NewsFeedRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'article/:articleId',
              factory: $ArticleRoute._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/schedule',
          factory: $ScheduleRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'custom',
              factory: $CustomScheduleRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'details',
              factory: $ScheduleDetailsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'diff',
              factory: $ScheduleDiffRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'changes',
              factory: $ScheduleChangesRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'compare',
              factory: $ScheduleCompareRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'analytics',
              factory: $ScheduleAnalyticsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'create',
              factory: $ScheduleCreateRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'edit/:scheduleId',
              factory: $ScheduleEditRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'session',
              factory: $ScheduleSessionRoute._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/services/map',
          factory: $MapRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/services',
          factory: $ServicesRoute._fromState,
          routes: [
            GoRouteData.$route(path: 'nfc', factory: $NfcPassRoute._fromState),
            GoRouteData.$route(
              path: 'discourse-post-overview/:postId',
              factory: $DiscoursePostOverviewRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'lost-and-found',
              factory: $LostAndFoundRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'apps',
              factory: $MiniAppsRoute._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'submit',
                  factory: $MiniAppSubmitRoute._fromState,
                ),
                GoRouteData.$route(
                  path: 'moderation',
                  factory: $MiniAppsModerationRoute._fromState,
                ),
                GoRouteData.$route(
                  path: ':slug/run',
                  factory: $MiniAppRunRoute._fromState,
                ),
              ],
            ),
            GoRouteData.$route(
              path: 'wallet',
              factory: $WalletRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'knowledge-bank',
              factory: $KnowledgeBankRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'marketplace',
              factory: $MarketplaceRoute._fromState,
            ),
            GoRouteData.$route(path: 'polls', factory: $PollsRoute._fromState),
            GoRouteData.$route(
              path: 'events',
              factory: $EventsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'team-finder',
              factory: $TeamFinderRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'mentorship',
              factory: $MentorshipRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'free-rooms',
              factory: $FreeRoomsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'deadlines',
              factory: $DeadlinesRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'collab-notes',
              factory: $CollabNotesRoute._fromState,
            ),
            GoRouteData.$route(path: 'tools', factory: $ToolsRoute._fromState),
            GoRouteData.$route(
              path: 'communities',
              factory: $CommunitiesRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'friends-map',
              factory: $FriendsMapRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'friends',
              factory: $FriendsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'people',
              factory: $PeopleRoute._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'group-space',
                  factory: $GroupSpaceRoute._fromState,
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
          path: '/profile',
          factory: $ProfileRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'schedule-management',
              factory: $ScheduleManagementRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'about',
              factory: $AboutAppRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'account',
              factory: $AccountManagementRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'settings',
              factory: $ProfileSettingsRoute._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'notifications',
                  factory: $NotificationsSettingsRoute._fromState,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

extension $ShellRouteDataExtension on ShellRouteData {
  static ShellRouteData _fromState(GoRouterState state) =>
      const ShellRouteData();
}

mixin $FeedRoute on GoRouteData {
  static FeedRoute _fromState(GoRouterState state) => const FeedRoute();

  @override
  String get location => GoRouteData.$location('/feed');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $NewsFeedRoute on GoRouteData {
  static NewsFeedRoute _fromState(GoRouterState state) => const NewsFeedRoute();

  @override
  String get location => GoRouteData.$location('/feed/news');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ArticleRoute on GoRouteData {
  static ArticleRoute _fromState(GoRouterState state) => ArticleRoute(
    articleId: state.pathParameters['articleId']!,
    isVideo:
        _$convertMapValue(
          'is-video',
          state.uri.queryParameters,
          _$boolConverter,
        ) ??
        false,
    adBehavior:
        _$convertMapValue(
          'ad-behavior',
          state.uri.queryParameters,
          _$InterstitialAdBehaviorEnumMap._$fromName,
        ) ??
        InterstitialAdBehavior.onOpen,
  );

  ArticleRoute get _self => this as ArticleRoute;

  @override
  String get location => GoRouteData.$location(
    '/feed/article/${Uri.encodeComponent(_self.articleId)}',
    queryParams: {
      if (_self.isVideo != false) 'is-video': _self.isVideo.toString(),
      if (_self.adBehavior != InterstitialAdBehavior.onOpen)
        'ad-behavior': _$InterstitialAdBehaviorEnumMap[_self.adBehavior],
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

const _$InterstitialAdBehaviorEnumMap = {
  InterstitialAdBehavior.onOpen: 'on-open',
  InterstitialAdBehavior.onClose: 'on-close',
};

mixin $ScheduleRoute on GoRouteData {
  static ScheduleRoute _fromState(GoRouterState state) => const ScheduleRoute();

  @override
  String get location => GoRouteData.$location('/schedule');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CustomScheduleRoute on GoRouteData {
  static CustomScheduleRoute _fromState(GoRouterState state) =>
      const CustomScheduleRoute();

  @override
  String get location => GoRouteData.$location('/schedule/custom');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ScheduleDetailsRoute on GoRouteData {
  static ScheduleDetailsRoute _fromState(GoRouterState state) =>
      ScheduleDetailsRoute(
        $extra: state.extra as (LessonSchedulePart, DateTime),
      );

  ScheduleDetailsRoute get _self => this as ScheduleDetailsRoute;

  @override
  String get location => GoRouteData.$location('/schedule/details');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

mixin $ScheduleDiffRoute on GoRouteData {
  static ScheduleDiffRoute _fromState(GoRouterState state) =>
      ScheduleDiffRoute($extra: state.extra as (ScheduleUpdateDiff, String));

  ScheduleDiffRoute get _self => this as ScheduleDiffRoute;

  @override
  String get location => GoRouteData.$location('/schedule/diff');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

mixin $ScheduleChangesRoute on GoRouteData {
  static ScheduleChangesRoute _fromState(GoRouterState state) =>
      const ScheduleChangesRoute();

  @override
  String get location => GoRouteData.$location('/schedule/changes');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ScheduleCompareRoute on GoRouteData {
  static ScheduleCompareRoute _fromState(GoRouterState state) =>
      const ScheduleCompareRoute();

  @override
  String get location => GoRouteData.$location('/schedule/compare');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ScheduleAnalyticsRoute on GoRouteData {
  static ScheduleAnalyticsRoute _fromState(GoRouterState state) =>
      const ScheduleAnalyticsRoute();

  @override
  String get location => GoRouteData.$location('/schedule/analytics');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ScheduleCreateRoute on GoRouteData {
  static ScheduleCreateRoute _fromState(GoRouterState state) =>
      const ScheduleCreateRoute();

  @override
  String get location => GoRouteData.$location('/schedule/create');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ScheduleEditRoute on GoRouteData {
  static ScheduleEditRoute _fromState(GoRouterState state) =>
      ScheduleEditRoute(scheduleId: state.pathParameters['scheduleId']!);

  ScheduleEditRoute get _self => this as ScheduleEditRoute;

  @override
  String get location => GoRouteData.$location(
    '/schedule/edit/${Uri.encodeComponent(_self.scheduleId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ScheduleSessionRoute on GoRouteData {
  static ScheduleSessionRoute _fromState(GoRouterState state) =>
      const ScheduleSessionRoute();

  @override
  String get location => GoRouteData.$location('/schedule/session');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MapRoute on GoRouteData {
  static MapRoute _fromState(GoRouterState state) => const MapRoute();

  @override
  String get location => GoRouteData.$location('/services/map');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ServicesRoute on GoRouteData {
  static ServicesRoute _fromState(GoRouterState state) => const ServicesRoute();

  @override
  String get location => GoRouteData.$location('/services');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $NfcPassRoute on GoRouteData {
  static NfcPassRoute _fromState(GoRouterState state) => const NfcPassRoute();

  @override
  String get location => GoRouteData.$location('/services/nfc');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DiscoursePostOverviewRoute on GoRouteData {
  static DiscoursePostOverviewRoute _fromState(GoRouterState state) =>
      DiscoursePostOverviewRoute(
        postId: int.parse(state.pathParameters['postId']!),
      );

  DiscoursePostOverviewRoute get _self => this as DiscoursePostOverviewRoute;

  @override
  String get location => GoRouteData.$location(
    '/services/discourse-post-overview/${Uri.encodeComponent(_self.postId.toString())}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $LostAndFoundRoute on GoRouteData {
  static LostAndFoundRoute _fromState(GoRouterState state) =>
      const LostAndFoundRoute();

  @override
  String get location => GoRouteData.$location('/services/lost-and-found');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MiniAppsRoute on GoRouteData {
  static MiniAppsRoute _fromState(GoRouterState state) => const MiniAppsRoute();

  @override
  String get location => GoRouteData.$location('/services/apps');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MiniAppSubmitRoute on GoRouteData {
  static MiniAppSubmitRoute _fromState(GoRouterState state) =>
      const MiniAppSubmitRoute();

  @override
  String get location => GoRouteData.$location('/services/apps/submit');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MiniAppsModerationRoute on GoRouteData {
  static MiniAppsModerationRoute _fromState(GoRouterState state) =>
      const MiniAppsModerationRoute();

  @override
  String get location => GoRouteData.$location('/services/apps/moderation');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MiniAppRunRoute on GoRouteData {
  static MiniAppRunRoute _fromState(GoRouterState state) => MiniAppRunRoute(
    slug: state.pathParameters['slug']!,
    page: state.uri.queryParameters['page'],
  );

  MiniAppRunRoute get _self => this as MiniAppRunRoute;

  @override
  String get location => GoRouteData.$location(
    '/services/apps/${Uri.encodeComponent(_self.slug)}/run',
    queryParams: {if (_self.page != null) 'page': _self.page},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $WalletRoute on GoRouteData {
  static WalletRoute _fromState(GoRouterState state) => const WalletRoute();

  @override
  String get location => GoRouteData.$location('/services/wallet');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $KnowledgeBankRoute on GoRouteData {
  static KnowledgeBankRoute _fromState(GoRouterState state) =>
      const KnowledgeBankRoute();

  @override
  String get location => GoRouteData.$location('/services/knowledge-bank');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MarketplaceRoute on GoRouteData {
  static MarketplaceRoute _fromState(GoRouterState state) =>
      const MarketplaceRoute();

  @override
  String get location => GoRouteData.$location('/services/marketplace');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PollsRoute on GoRouteData {
  static PollsRoute _fromState(GoRouterState state) => const PollsRoute();

  @override
  String get location => GoRouteData.$location('/services/polls');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $EventsRoute on GoRouteData {
  static EventsRoute _fromState(GoRouterState state) => const EventsRoute();

  @override
  String get location => GoRouteData.$location('/services/events');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $TeamFinderRoute on GoRouteData {
  static TeamFinderRoute _fromState(GoRouterState state) =>
      const TeamFinderRoute();

  @override
  String get location => GoRouteData.$location('/services/team-finder');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MentorshipRoute on GoRouteData {
  static MentorshipRoute _fromState(GoRouterState state) =>
      const MentorshipRoute();

  @override
  String get location => GoRouteData.$location('/services/mentorship');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FreeRoomsRoute on GoRouteData {
  static FreeRoomsRoute _fromState(GoRouterState state) =>
      const FreeRoomsRoute();

  @override
  String get location => GoRouteData.$location('/services/free-rooms');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DeadlinesRoute on GoRouteData {
  static DeadlinesRoute _fromState(GoRouterState state) =>
      const DeadlinesRoute();

  @override
  String get location => GoRouteData.$location('/services/deadlines');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CollabNotesRoute on GoRouteData {
  static CollabNotesRoute _fromState(GoRouterState state) =>
      const CollabNotesRoute();

  @override
  String get location => GoRouteData.$location('/services/collab-notes');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ToolsRoute on GoRouteData {
  static ToolsRoute _fromState(GoRouterState state) => const ToolsRoute();

  @override
  String get location => GoRouteData.$location('/services/tools');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CommunitiesRoute on GoRouteData {
  static CommunitiesRoute _fromState(GoRouterState state) =>
      const CommunitiesRoute();

  @override
  String get location => GoRouteData.$location('/services/communities');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FriendsMapRoute on GoRouteData {
  static FriendsMapRoute _fromState(GoRouterState state) =>
      const FriendsMapRoute();

  @override
  String get location => GoRouteData.$location('/services/friends-map');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FriendsRoute on GoRouteData {
  static FriendsRoute _fromState(GoRouterState state) => const FriendsRoute();

  @override
  String get location => GoRouteData.$location('/services/friends');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PeopleRoute on GoRouteData {
  static PeopleRoute _fromState(GoRouterState state) => const PeopleRoute();

  @override
  String get location => GoRouteData.$location('/services/people');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $GroupSpaceRoute on GoRouteData {
  static GroupSpaceRoute _fromState(GoRouterState state) =>
      const GroupSpaceRoute();

  @override
  String get location => GoRouteData.$location('/services/people/group-space');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  @override
  String get location => GoRouteData.$location('/profile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ScheduleManagementRoute on GoRouteData {
  static ScheduleManagementRoute _fromState(GoRouterState state) =>
      const ScheduleManagementRoute();

  @override
  String get location => GoRouteData.$location('/profile/schedule-management');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AboutAppRoute on GoRouteData {
  static AboutAppRoute _fromState(GoRouterState state) => const AboutAppRoute();

  @override
  String get location => GoRouteData.$location('/profile/about');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AccountManagementRoute on GoRouteData {
  static AccountManagementRoute _fromState(GoRouterState state) =>
      const AccountManagementRoute();

  @override
  String get location => GoRouteData.$location('/profile/account');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProfileSettingsRoute on GoRouteData {
  static ProfileSettingsRoute _fromState(GoRouterState state) =>
      const ProfileSettingsRoute();

  @override
  String get location => GoRouteData.$location('/profile/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $NotificationsSettingsRoute on GoRouteData {
  static NotificationsSettingsRoute _fromState(GoRouterState state) =>
      const NotificationsSettingsRoute();

  @override
  String get location =>
      GoRouteData.$location('/profile/settings/notifications');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
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

RouteBase get $slideshowRoute =>
    GoRouteData.$route(path: '/slideshow', factory: $SlideshowRoute._fromState);

mixin $SlideshowRoute on GoRouteData {
  static SlideshowRoute _fromState(GoRouterState state) =>
      SlideshowRoute($extra: state.extra as Map<String, dynamic>?);

  SlideshowRoute get _self => this as SlideshowRoute;

  @override
  String get location => GoRouteData.$location('/slideshow');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}
