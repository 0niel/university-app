import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/article/view/article_page.dart';
import 'package:rtu_mirea_app/article/view/interstitial_ad_behavior.dart';
import 'package:rtu_mirea_app/communities/communities.dart';
import 'package:rtu_mirea_app/community/community.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/discourse_post_overview/discourse_post_overview.dart';
import 'package:rtu_mirea_app/feed/feed.dart';
import 'package:rtu_mirea_app/feed/view/news_feed_page.dart';
import 'package:rtu_mirea_app/free_rooms/free_rooms.dart';
import 'package:rtu_mirea_app/friends/friends.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/home/view/home_dashboard_page.dart';
import 'package:rtu_mirea_app/knowledge_bank/knowledge_bank.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';
import 'package:rtu_mirea_app/lost_and_found/lost_and_found.dart';
import 'package:rtu_mirea_app/map/map.dart';
import 'package:rtu_mirea_app/marketplace/marketplace.dart';
import 'package:rtu_mirea_app/mini_apps/mini_apps.dart';
import 'package:rtu_mirea_app/navigation/deep_links.dart';
import 'package:rtu_mirea_app/navigation/view/navigation_branch_container.dart';
import 'package:rtu_mirea_app/navigation/view/scaffold_navigation_shell.dart';
import 'package:rtu_mirea_app/nfc_pass/nfc_pass.dart';
import 'package:rtu_mirea_app/onboarding/view/onboarding_page.dart';
import 'package:rtu_mirea_app/people/people.dart';
import 'package:rtu_mirea_app/polls/polls.dart';
import 'package:rtu_mirea_app/profile/profile.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule_diff/view/view.dart';
import 'package:rtu_mirea_app/schedule_management/schedule_management.dart';
import 'package:rtu_mirea_app/search/view/search_page.dart';
import 'package:rtu_mirea_app/services/view/view.dart';
import 'package:rtu_mirea_app/tools/tools.dart';
import 'package:rtu_mirea_app/wallet/wallet.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'routes.g.dart';

abstract final class Routes {
  static List<RouteBase> get all => $appRoutes;
}

@TypedGoRoute<OnboardingRoute>(path: '/onboarding')
@immutable
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  const OnboardingRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OnBoardingPage();
}

@TypedGoRoute<AuthRoute>(path: '/auth')
@immutable
class AuthRoute extends GoRouteData with $AuthRoute {
  const AuthRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}

@TypedGoRoute<SignUpRoute>(path: '/sign-up')
@immutable
class SignUpRoute extends GoRouteData with $SignUpRoute {
  const SignUpRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignUpPage();
  }
}

@TypedGoRoute<PasswordResetRoute>(path: '/password-reset')
@immutable
class PasswordResetRoute extends GoRouteData with $PasswordResetRoute {
  const PasswordResetRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PasswordResetPage();
  }
}

@TypedGoRoute<LoginWithEmailRoute>(path: '/login-with-email')
@immutable
class LoginWithEmailRoute extends GoRouteData with $LoginWithEmailRoute {
  const LoginWithEmailRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginWithEmailPage();
  }
}

@TypedGoRoute<LoginEmailConfirmationRoute>(path: '/login-email-confirmation')
@immutable
class LoginEmailConfirmationRoute extends GoRouteData
    with $LoginEmailConfirmationRoute {
  const LoginEmailConfirmationRoute({required this.email});

  final String email;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LoginEmailConfirmationPage(email: email);
  }
}

@TypedGoRoute<GlobalSearchRoute>(path: '/search')
@immutable
class GlobalSearchRoute extends GoRouteData with $GlobalSearchRoute {
  const GlobalSearchRoute({this.query});

  final String? query;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SearchPage(query: query);
  }
}

@TypedStatefulShellRoute<ShellRouteData>(
  branches: [
    TypedStatefulShellBranch<FeedBranchData>(
      routes: [
        TypedGoRoute<FeedRoute>(
          path: '/feed',
          routes: [
            TypedGoRoute<NewsFeedRoute>(path: 'news'),
            TypedGoRoute<ArticleRoute>(path: 'article/:articleId'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<ScheduleBranchData>(
      routes: [
        TypedGoRoute<ScheduleRoute>(
          path: '/schedule',
          routes: [
            TypedGoRoute<CustomScheduleRoute>(path: 'custom'),
            TypedGoRoute<ScheduleDetailsRoute>(path: 'details'),
            TypedGoRoute<ScheduleDiffRoute>(path: 'diff'),
            TypedGoRoute<ScheduleChangesRoute>(path: 'changes'),
            TypedGoRoute<ScheduleCompareRoute>(path: 'compare'),
            TypedGoRoute<ScheduleAnalyticsRoute>(path: 'analytics'),
            TypedGoRoute<ScheduleCreateRoute>(path: 'create'),
            TypedGoRoute<ScheduleEditRoute>(path: 'edit/:scheduleId'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<MapBranchData>(
      routes: [TypedGoRoute<MapRoute>(path: '/services/map')],
    ),
    TypedStatefulShellBranch<ServicesBranchData>(
      routes: [
        TypedGoRoute<ServicesRoute>(
          path: '/services',
          routes: [
            TypedGoRoute<NfcPassRoute>(path: 'nfc'),
            TypedGoRoute<DiscoursePostOverviewRoute>(
              path: 'discourse-post-overview/:postId',
            ),
            TypedGoRoute<LostAndFoundRoute>(path: 'lost-and-found'),
            TypedGoRoute<MiniAppsRoute>(
              path: 'apps',
              routes: [
                TypedGoRoute<MiniAppSubmitRoute>(path: 'submit'),
                TypedGoRoute<MiniAppsModerationRoute>(path: 'moderation'),
                TypedGoRoute<MiniAppRunRoute>(path: ':slug/run'),
              ],
            ),
            TypedGoRoute<WalletRoute>(path: 'wallet'),
            TypedGoRoute<KnowledgeBankRoute>(path: 'knowledge-bank'),
            TypedGoRoute<MarketplaceRoute>(path: 'marketplace'),
            TypedGoRoute<PollsRoute>(path: 'polls'),
            TypedGoRoute<EventsRoute>(path: 'events'),
            TypedGoRoute<TeamFinderRoute>(path: 'team-finder'),
            TypedGoRoute<MentorshipRoute>(path: 'mentorship'),
            TypedGoRoute<FreeRoomsRoute>(path: 'free-rooms'),
            TypedGoRoute<DeadlinesRoute>(path: 'deadlines'),
            TypedGoRoute<CollabNotesRoute>(path: 'collab-notes'),
            TypedGoRoute<ToolsRoute>(path: 'tools'),
            TypedGoRoute<CommunitiesRoute>(path: 'communities'),
            TypedGoRoute<FriendsMapRoute>(path: 'friends-map'),
            TypedGoRoute<PeopleRoute>(
              path: 'people',
              routes: [
                TypedGoRoute<GroupSpaceRoute>(path: 'group-space'),
              ],
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<ProfileBranchData>(
      routes: [
        TypedGoRoute<ProfileRoute>(
          path: '/profile',
          routes: [
            TypedGoRoute<ScheduleManagementRoute>(path: 'schedule-management'),
            TypedGoRoute<AboutAppRoute>(path: 'about'),
            TypedGoRoute<AccountManagementRoute>(path: 'account'),
            TypedGoRoute<ProfileSettingsRoute>(
              path: 'settings',
              routes: [
                TypedGoRoute<NotificationsSettingsRoute>(path: 'notifications'),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
)
@immutable
class ShellRouteData extends StatefulShellRouteData {
  const ShellRouteData();

  static Widget $navigatorContainerBuilder(
    BuildContext _,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) {
    return NavigationBranchContainer(
      currentIndex: navigationShell.currentIndex,
      children: children,
    );
  }

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return ScaffoldNavigationShell(navigationShell: navigationShell);
  }
}

@immutable
class FeedBranchData extends StatefulShellBranchData {
  const FeedBranchData();
}

@immutable
class ScheduleBranchData extends StatefulShellBranchData {
  const ScheduleBranchData();
}

@immutable
class MapBranchData extends StatefulShellBranchData {
  const MapBranchData();
}

@immutable
class ServicesBranchData extends StatefulShellBranchData {
  const ServicesBranchData();
}

@immutable
class ProfileBranchData extends StatefulShellBranchData {
  const ProfileBranchData();
}

@immutable
class FeedRoute extends GoRouteData with $FeedRoute {
  const FeedRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeDashboardPage();
  }
}

@immutable
class NewsFeedRoute extends GoRouteData with $NewsFeedRoute {
  const NewsFeedRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NewsFeedPage();
  }
}

@immutable
class ArticleRoute extends GoRouteData with $ArticleRoute {
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
class SlideshowRoute extends GoRouteData with $SlideshowRoute {
  const SlideshowRoute({this.$extra});

  final Map<String, dynamic>? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final extra = (state.extra as Map<String, dynamic>?) ?? $extra ?? const {};
    final slideshow = extra['slideshow'] as SlideshowBlock?;
    if (slideshow == null) {
      final colors = context.ninja;
      return Scaffold(
        backgroundColor: colors.canvas,
        appBar: NinjaAppBar.inner(
          title: context.l10n.slideshow,
          backSemanticLabel: context.l10n.back,
          onBack: () => Navigator.of(context).maybePop(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(NinjaMetrics.screenPadding),
            child: NinjaEmptyState(
              icon: const AppLineIconWidget(AppLineIcon.image),
              title: context.l10n.loadingError,
              message: context.l10n.tryAgain,
            ),
          ),
        ),
      );
    }
    return Slideshow(
      block: slideshow,
      categoryTitle: context.l10n.slideshow,
      navigationLabel: '/',
    );
  }
}

@immutable
class ScheduleRoute extends GoRouteData with $ScheduleRoute {
  const ScheduleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SchedulePage();
  }
}

@immutable
class CustomScheduleRoute extends GoRouteData with $CustomScheduleRoute {
  const CustomScheduleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CustomSchedulesPage();
  }
}

@immutable
class ScheduleDetailsRoute extends GoRouteData with $ScheduleDetailsRoute {
  const ScheduleDetailsRoute({required this.$extra});

  final (LessonSchedulePart, DateTime) $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ScheduleDetailsPage(lesson: $extra.$1, selectedDate: $extra.$2);
  }
}

@immutable
class ScheduleChangesRoute extends GoRouteData with $ScheduleChangesRoute {
  const ScheduleChangesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChangesPage();
  }
}

@immutable
class ScheduleCompareRoute extends GoRouteData with $ScheduleCompareRoute {
  const ScheduleCompareRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ComparePage();
  }
}

@immutable
class ScheduleAnalyticsRoute extends GoRouteData with $ScheduleAnalyticsRoute {
  const ScheduleAnalyticsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AnalyticsPage();
  }
}

@immutable
class ScheduleCreateRoute extends GoRouteData with $ScheduleCreateRoute {
  const ScheduleCreateRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CreateSchedulePage();
  }
}

@immutable
class ScheduleEditRoute extends GoRouteData with $ScheduleEditRoute {
  const ScheduleEditRoute({required this.scheduleId});

  final String scheduleId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EditSchedulePage(scheduleId: scheduleId);
  }
}

@immutable
class ScheduleDiffRoute extends GoRouteData with $ScheduleDiffRoute {
  const ScheduleDiffRoute({required this.$extra});

  final (ScheduleUpdateDiff, String) $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final diff = $extra.$1;
    final title = $extra.$2;
    return ScheduleDiffView(diff: diff, title: title);
  }
}

@immutable
class ServicesRoute extends GoRouteData with $ServicesRoute {
  const ServicesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ServicesPage(
      initialEditMode: state.uri.queryParameters['configure'] == 'true',
    );
  }
}

@immutable
class NfcPassRoute extends GoRouteData with $NfcPassRoute {
  const NfcPassRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    if (!context.read<UniversityConfig>().isEnabled(.nfcPass)) {
      return const ServicesPage();
    }
    return const NfcPassPage();
  }
}

@immutable
class MapRoute extends GoRouteData with $MapRoute {
  const MapRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MapPage();
  }
}

@immutable
class DiscoursePostOverviewRoute extends GoRouteData
    with $DiscoursePostOverviewRoute {
  const DiscoursePostOverviewRoute({required this.postId});

  final int postId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DiscoursePostOverviewPageView(postId: postId);
  }
}

@immutable
class LostAndFoundRoute extends GoRouteData with $LostAndFoundRoute {
  const LostAndFoundRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LostFoundPage();
  }
}

@immutable
class MiniAppsRoute extends GoRouteData with $MiniAppsRoute {
  const MiniAppsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MiniAppsPage();
  }
}

@immutable
class MiniAppSubmitRoute extends GoRouteData with $MiniAppSubmitRoute {
  const MiniAppSubmitRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MiniAppSubmitPage();
  }
}

@immutable
class MiniAppsModerationRoute extends GoRouteData
    with $MiniAppsModerationRoute {
  const MiniAppsModerationRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MiniAppsModerationPage();
  }
}

@immutable
class MiniAppRunRoute extends GoRouteData with $MiniAppRunRoute {
  const MiniAppRunRoute({required this.slug, this.page});

  final String slug;

  final String? page;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MiniAppRunnerPage(slug: slug, initialPage: page);
  }
}

@immutable
class WalletRoute extends GoRouteData with $WalletRoute {
  const WalletRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const WalletPage();
  }
}

@immutable
class KnowledgeBankRoute extends GoRouteData with $KnowledgeBankRoute {
  const KnowledgeBankRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const KnowledgeBankPage();
  }
}

@immutable
class MarketplaceRoute extends GoRouteData with $MarketplaceRoute {
  const MarketplaceRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MarketplacePage();
  }
}

@immutable
class PollsRoute extends GoRouteData with $PollsRoute {
  const PollsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PollsPage();
  }
}

@immutable
class EventsRoute extends GoRouteData with $EventsRoute {
  const EventsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const EventsPage();
  }
}

@immutable
class TeamFinderRoute extends GoRouteData with $TeamFinderRoute {
  const TeamFinderRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TeamFinderPage();
  }
}

@immutable
class MentorshipRoute extends GoRouteData with $MentorshipRoute {
  const MentorshipRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MentorshipPage();
  }
}

@immutable
class FreeRoomsRoute extends GoRouteData with $FreeRoomsRoute {
  const FreeRoomsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FreeRoomsPage();
  }
}

@immutable
class DeadlinesRoute extends GoRouteData with $DeadlinesRoute {
  const DeadlinesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DeadlinesPage();
  }
}

@immutable
class CollabNotesRoute extends GoRouteData with $CollabNotesRoute {
  const CollabNotesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CollabNotesPage();
  }
}

@immutable
class ToolsRoute extends GoRouteData with $ToolsRoute {
  const ToolsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ToolsPage();
  }
}

@immutable
class CommunitiesRoute extends GoRouteData with $CommunitiesRoute {
  const CommunitiesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AllCommunitiesPage();
  }
}

@immutable
class FriendsMapRoute extends GoRouteData with $FriendsMapRoute {
  const FriendsMapRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FriendsMapPage();
  }
}

@immutable
class PeopleRoute extends GoRouteData with $PeopleRoute {
  const PeopleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PeoplePage();
  }
}

@immutable
class GroupSpaceRoute extends GoRouteData with $GroupSpaceRoute {
  const GroupSpaceRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GroupSpacePage();
  }
}

@immutable
class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfilePage();
  }
}

@immutable
class ScheduleManagementRoute extends GoRouteData
    with $ScheduleManagementRoute {
  const ScheduleManagementRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ScheduleManagementPage();
  }
}

@immutable
class AboutAppRoute extends GoRouteData with $AboutAppRoute {
  const AboutAppRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AboutAppPage();
  }
}

@immutable
class AccountManagementRoute extends GoRouteData with $AccountManagementRoute {
  const AccountManagementRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AccountManagementPage();
  }
}

@immutable
class ProfileSettingsRoute extends GoRouteData with $ProfileSettingsRoute {
  const ProfileSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (providerContext) {
        final cubit = ProfileCubit(
          gamificationRepository: providerContext.read(),
          organizationId: providerContext
              .read<UniversityConfig>()
              .organizationId,
          currentUser: providerContext.read<AppBloc>().state.user,
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const ProfileSettingsPage(),
    );
  }
}

@immutable
class NotificationsSettingsRoute extends GoRouteData
    with $NotificationsSettingsRoute {
  const NotificationsSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (providerContext) {
        final cubit = ProfileCubit(
          gamificationRepository: providerContext.read(),
          organizationId: providerContext
              .read<UniversityConfig>()
              .organizationId,
          currentUser: providerContext.read<AppBloc>().state.user,
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const NotificationsSettingsPage(),
    );
  }
}

GoRouter? _routerInstance;

GoRouter get appRouter {
  assert(
    _routerInstance != null,
    'createRouter() must be called before accessing appRouter',
  );
  return _routerInstance!;
}

const kAuthFlowLocations = [
  '/auth',
  '/sign-up',
  '/password-reset',
  '/login-with-email',
  '/login-email-confirmation',
];

bool _isAuthFlowLocation(String location) =>
    kAuthFlowLocations.any((path) => location.startsWith(path));

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<Object?> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}

GoRouter createRouter({
  Listenable? refreshListenable,
  AppBloc? appBloc,
  HomeCubit? homeCubit,
}) => _routerInstance = GoRouter(
  routes: Routes.all,
  initialLocation: '/feed',
  debugLogDiagnostics: kDebugMode,
  refreshListenable: refreshListenable,
  onException: (_, state, router) => router.go('/feed'),
  redirect: (context, state) {
    final deepLink = DeepLinks.normalize(state.uri);
    if (deepLink != null && deepLink != state.uri.toString()) {
      return deepLink;
    }

    final bloc = appBloc ?? context.read<AppBloc>();
    final isLoggedIn = bloc.state.status.isLoggedIn;
    final inAuthFlow = _isAuthFlowLocation(state.matchedLocation);

    if (!isLoggedIn && !inAuthFlow) return '/auth';

    final isMobile =
        !kIsWeb &&
        (defaultTargetPlatform == .android || defaultTargetPlatform == .iOS);
    final onboardingShown =
        (homeCubit ?? context.read<HomeCubit>()).state.settings.onboardingShown;
    if (isLoggedIn &&
        isMobile &&
        !onboardingShown &&
        state.matchedLocation != '/onboarding') {
      return '/onboarding';
    }

    if (isLoggedIn && inAuthFlow) return '/feed';

    return null;
  },
  observers: [
    if (FirebaseRuntime.isInitialized)
      FirebaseAnalyticsObserver(analytics: .instance),
    SentryNavigatorObserver(
      autoFinishAfter: const Duration(seconds: 5),
      setRouteNameAsTransaction: true,
    ),
  ],
);
