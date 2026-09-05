import 'dart:async';
import 'dart:developer';

import 'package:ads_ui/ads_ui.dart';
import 'package:connectivity_client/connectivity_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:local_auth_client/local_auth_client.dart';
import 'package:platform/platform.dart';
import 'package:rtu_mirea_app/ads/bloc/ads_bloc.dart';
import 'package:rtu_mirea_app/ads/bloc/full_screen_ads_bloc.dart';
import 'package:rtu_mirea_app/analytics/bloc/analytics_bloc.dart';
import 'package:rtu_mirea_app/app/app.dart';
import 'package:rtu_mirea_app/app/locale/locale_cubit.dart';
import 'package:rtu_mirea_app/app/services/device_token_sync_controller.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';
import 'package:rtu_mirea_app/app/view/app_boot_placeholder.dart';
import 'package:rtu_mirea_app/app/view/app_device_token_sync.dart';
import 'package:rtu_mirea_app/app/view/app_router_view.dart';
import 'package:rtu_mirea_app/app/widgets/user_preferences_scope.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/di/app_scope.dart';
import 'package:rtu_mirea_app/feed/feed.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/nfc_pass.dart';
import 'package:rtu_mirea_app/profile/cubit/sync_preferences_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';
import 'package:rtu_mirea_app/promo/promo.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule_management/bloc/schedule_exporter_cubit.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:rtu_mirea_app/watch/watch.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

class App extends StatelessWidget {
  const App({required this.user, super.key});

  final User user;

  bool get _supportsFirebaseMessaging => FirebaseRuntime.messagingAvailable;

  bool get _supportsYandexAds =>
      !kIsWeb &&
      (defaultTargetPlatform == .android || defaultTargetPlatform == .iOS);

  @override
  Widget build(BuildContext context) {
    return ScopeBuilder<AppScopeContainer>.withPlaceholder(
      builder: (context, appScope) {
        final tokenSyncController = _supportsFirebaseMessaging
            ? _createTokenSyncController(appScope.friendsRepository)
            : null;
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(
              value: appScope.universityConfig,
            ),
            RepositoryProvider.value(value: appScope.analyticsRepository),
            RepositoryProvider.value(value: appScope.scheduleRepository),
            RepositoryProvider.value(value: appScope.preferencesRepository),
            RepositoryProvider.value(value: appScope.communityRepository),
            RepositoryProvider.value(
              value: appScope.communityCatalogRepository,
            ),
            RepositoryProvider.value(value: appScope.newsRepository),
            RepositoryProvider.value(value: appScope.articleRepository),
            RepositoryProvider.value(
              value: appScope.scheduleExporterRepository,
            ),
            RepositoryProvider.value(value: appScope.nfcPassRepository),
            RepositoryProvider.value(value: appScope.lostFoundRepository),
            RepositoryProvider.value(value: appScope.miniAppsRepository),
            RepositoryProvider.value(value: appScope.userRepository),
            RepositoryProvider.value(value: appScope.gamificationRepository),
            RepositoryProvider.value(value: appScope.friendsRepository),
            RepositoryProvider.value(
              value: appScope.notificationInboxRepository,
            ),
            RepositoryProvider.value(value: appScope.campusRepository),
            RepositoryProvider.value(value: appScope.studyGroupsRepository),
            RepositoryProvider.value(value: appScope.serviceCatalogRepository),
            RepositoryProvider.value(value: appScope.promoRepository),
            RepositoryProvider.value(
              value: appScope.localNotificationsRepository,
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => HomeCubit()),
              BlocProvider(create: (_) => ThemeCubit()),
              BlocProvider(create: (_) => LocaleCubit()),
              BlocProvider(create: (_) => ScheduleDisplayCubit()),
              BlocProvider(create: (_) => LessonRemindersCubit()),
              BlocProvider(create: (_) => UiPreferencesCubit()),
              BlocProvider(
                create: (_) {
                  final cubit = FavoriteServicesCubit();
                  unawaited(cubit.load());
                  return cubit;
                },
              ),
              BlocProvider(
                create: (_) => ServiceCatalogCubit(
                  appScope.serviceCatalogRepository,
                ),
              ),
              BlocProvider(create: (_) => SyncPreferencesCubit()),
              BlocProvider(
                create: (_) => PromoBannersCubit(appScope.promoRepository),
              ),
              BlocProvider(create: (_) => PromoDismissalsCubit()),
              BlocProvider(
                create: (_) =>
                    PassSecurityCubit(localAuthClient: LocalAuthClient()),
              ),
              BlocProvider(
                create: (_) =>
                    CategoriesBloc(newsRepository: appScope.newsRepository)
                      ..add(const CategoriesRequested()),
              ),
              BlocProvider(
                create: (_) =>
                    FeedBloc(newsRepository: appScope.newsRepository),
              ),
              BlocProvider(create: (_) => AdsBloc()),
              BlocProvider(
                create: (_) => ScheduleExporterCubit(
                  appScope.scheduleExporterRepository,
                ),
              ),
              BlocProvider(
                create: (_) => AppBloc(
                  firebaseMessaging: _supportsFirebaseMessaging
                      ? FirebaseMessaging.instance
                      : null,
                  userRepository: appScope.userRepository,
                  user: user,
                  onBeforeLogout: tokenSyncController?.stopAndUnregister,
                )..add(const AppOpened()),
              ),
              BlocProvider(
                create: (_) => AnalyticsBloc(
                  analyticsRepository: appScope.analyticsRepository,
                ),
                lazy: false,
              ),
              BlocProvider(
                create: (context) {
                  final syncPreferences = context.read<SyncPreferencesCubit>();
                  return ScheduleBloc(
                    scheduleRepository: appScope.scheduleRepository,
                    preferencesRepository: appScope.preferencesRepository,
                    connectivityClient: ConnectivityClient(),
                    syncPolicy: () => syncPreferences.state,
                  )..add(const SelectedScheduleRefreshRequested());
                },
              ),
              BlocProvider(
                create: (_) => SchedulePreferencesCubit(
                  preferencesRepository: appScope.preferencesRepository,
                ),
              ),
              BlocProvider(
                create: (_) => LessonCommentsCubit(
                  preferencesRepository: appScope.preferencesRepository,
                ),
              ),
              BlocProvider(
                create: (_) => LessonReactionsCubit(
                  scheduleRepository: appScope.scheduleRepository,
                ),
              ),
              BlocProvider(
                create: (_) => UserActivitiesCubit(
                  scheduleRepository: appScope.scheduleRepository,
                ),
              ),
              BlocProvider(
                create: (_) => ClassmatesCubit(
                  friendsRepository: appScope.friendsRepository,
                ),
              ),
              BlocProvider(
                create: (_) => ExamReadinessCubit(
                  scheduleRepository: appScope.scheduleRepository,
                ),
              ),
              BlocProvider(
                create: (_) => ScheduleChangesCubit(
                  scheduleRepository: appScope.scheduleRepository,
                ),
              ),
              BlocProvider(
                create: (_) => CustomScheduleCubit(
                  preferencesRepository: appScope.preferencesRepository,
                  remindersRepository: appScope.localNotificationsRepository,
                ),
              ),
              BlocProvider(
                create: (_) => ScheduleComparisonCubit(),
              ),
              BlocProvider(
                create: (_) =>
                    NfcPassCubit(repository: appScope.nfcPassRepository),
              ),
              BlocProvider(
                create: (_) =>
                    NfcHceCubit(repository: appScope.nfcPassRepository),
              ),
              BlocProvider(
                create: (_) {
                  final bloc = FullScreenAdsBloc(
                    onLoadInterstitialAd: yandexInterstitialAdLoader,
                    onLoadRewardedAd: yandexRewardedAdLoader,
                    adsRetryPolicy: const AdsRetryPolicy(),
                    localPlatform: const LocalPlatform(),
                  );

                  if (_supportsYandexAds) {
                    bloc
                      ..add(const LoadInterstitialAdRequested())
                      ..add(const LoadRewardedAdRequested());
                  }

                  return bloc;
                },
                lazy: false,
              ),
              BlocProvider(create: (_) => WatchConnectivityCubit()),
            ],
            child: AppDeviceTokenSync(
              controller: tokenSyncController,
              child: const UserPreferencesScope(child: AppRouterView()),
            ),
          ),
        );
      },
      placeholder: const AppBootPlaceholder(),
    );
  }

  DeviceTokenSyncController _createTokenSyncController(
    FriendsRepository repository,
  ) {
    final messaging = FirebaseMessaging.instance;
    final platform = defaultTargetPlatform == .iOS ? 'ios' : 'android';
    return DeviceTokenSyncController(
      getToken: messaging.getToken,
      tokenRefresh: messaging.onTokenRefresh,
      register: (token) => repository.registerDevice(
        token: token,
        platform: platform,
      ),
      unregister: repository.unregisterDevice,
      deleteToken: messaging.deleteToken,
      onError: _logTokenSyncError,
    );
  }

  void _logTokenSyncError(Object error, StackTrace stackTrace) {
    log(
      'Device token sync failed',
      error: error,
      stackTrace: stackTrace,
      name: '_DeviceTokenSync',
    );
  }
}
