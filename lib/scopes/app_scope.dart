import 'package:analytics_repository/analytics_repository.dart';
import 'package:article_repository/article_repository.dart';
import 'package:community_repository/community_repository.dart';
import 'package:discourse_api_client/discourse_api_client.dart';
import 'package:discourse_repository/discourse_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:news_repository/news_repository.dart';
import 'package:nfc_pass_repository/nfc_pass_repository.dart';
import 'package:package_info_client/package_info_client.dart';

import 'package:persistent_storage/persistent_storage.dart';
import 'package:rtu_mirea_app/ads/bloc/ads_bloc.dart';
import 'package:rtu_mirea_app/ads/bloc/full_screen_ads_bloc.dart';
import 'package:rtu_mirea_app/analytics/bloc/analytics_bloc.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/feed/feed.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/lost_and_found/lost_and_found.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_pass_cubit.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/scopes/auth_scope.dart';
import 'package:rtu_mirea_app/scopes/core_scope.dart';
import 'package:rtu_mirea_app/scopes/app_scope_bloc.dart';

import 'package:schedule_exporter_repository/schedule_exporter_repository.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:university_app_server_api/client.dart';
import 'package:yx_scope/yx_scope.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import 'package:platform/platform.dart';
import 'package:ads_ui/ads_ui.dart';

abstract class AppScope implements Scope {
  // Core dependencies
  SharedPreferences get sharedPreferences;
  AnalyticsRepository get analyticsRepository;
  PackageInfoClient get packageInfoClient;

  // Storage dependencies
  PersistentStorage get persistentStorage;
  SecureStorage get secureStorage;

  // Auth related
  AuthScopeHolder get authScopeHolder;

  // Router
  GoRouter get router;

  // Repositories
  ScheduleRepository get scheduleRepository;
  CommunityRepository get communityRepository;
  DiscourseRepository get discourseRepository;
  NewsRepository get newsRepository;
  ArticleRepository get articleRepository;
  ScheduleExporterRepository get scheduleExporterRepository;
  NfcPassRepository get nfcPassRepository;
  LostFoundRepository get lostFoundRepository;

  // Blocs and Cubits
  HomeCubit get homeCubit;
  ThemeCubit get themeCubit;
  AdsBloc get adsBloc;
  FullScreenAdsBloc get fullScreenAdsBloc;
  AnalyticsBloc get analyticsBloc;
  ScheduleBloc get scheduleBloc;
  NfcPassCubit get nfcPassCubit;
  CategoriesBloc get categoriesBloc;
  FeedBloc get feedBloc;
  LostFoundBloc get lostFoundBloc;

  // Firebase
  FirebaseMessaging get firebaseMessaging;

  // Supabase
  SupabaseClient get supabaseClient;

  // App Scope Bloc
  AppScopeBloc get appScopeBloc;
}

/// App Scope Container
class AppScopeContainer extends ScopeContainer implements AppScope {
  AppScopeContainer({
    required SharedPreferences sharedPreferences,
    required AnalyticsRepository analyticsRepository,
    required PackageInfoClient packageInfoClient,
    required SupabaseClient supabaseClient,
  }) : _sharedPreferences = sharedPreferences,
       _analyticsRepository = analyticsRepository,
       _packageInfoClient = packageInfoClient,
       _supabaseClient = supabaseClient;

  final SharedPreferences _sharedPreferences;
  final AnalyticsRepository _analyticsRepository;
  final PackageInfoClient _packageInfoClient;
  final SupabaseClient _supabaseClient;

  // Core dependencies
  @override
  SharedPreferences get sharedPreferences => _sharedPreferences;

  @override
  AnalyticsRepository get analyticsRepository => _analyticsRepository;

  @override
  PackageInfoClient get packageInfoClient => _packageInfoClient;

  @override
  SupabaseClient get supabaseClient => _supabaseClient;

  // Storage dependencies
  late final _persistentStorageDep = dep(
    () => PersistentStorage(sharedPreferences: _sharedPreferences),
  );

  @override
  PersistentStorage get persistentStorage => _persistentStorageDep.get;

  late final _flutterSecureStorageDep = dep(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );

  late final _secureStorageDep = dep(
    () => SecureStorage(_flutterSecureStorageDep.get),
  );

  @override
  SecureStorage get secureStorage => _secureStorageDep.get;

  // Firebase
  late final _firebaseMessagingDep = dep(() => FirebaseMessaging.instance);

  @override
  FirebaseMessaging get firebaseMessaging => _firebaseMessagingDep.get;

  // Auth Scope
  late final _authScopeHolderDep = dep(
    () => AuthScopeHolder(
      coreScope: CoreScopeContainer(
        persistentStorage: persistentStorage,
        secureStorage: secureStorage,
        supabaseClient: supabaseClient,
        packageInfoClient: packageInfoClient,
      ),
    ),
  );

  @override
  AuthScopeHolder get authScopeHolder => _authScopeHolderDep.get;

  // API Client
  late final _apiClientDep = dep(() {
    final authClient = _supabaseClient.auth;
    return ApiClient(
      tokenProvider: () async {
        final session = authClient.currentSession;
        return session?.accessToken;
      },
    );
  });

  ApiClient get _apiClient => _apiClientDep.get;

  // Discourse API Client
  late final _discourseApiClientDep = dep(
    () => DiscourseApiClient(baseUrl: 'https://mirea.ninja'),
  );

  DiscourseApiClient get _discourseApiClient => _discourseApiClientDep.get;

  // Repositories
  late final _scheduleRepositoryDep = dep(
    () => ScheduleRepository(apiClient: _apiClient),
  );

  @override
  ScheduleRepository get scheduleRepository => _scheduleRepositoryDep.get;

  late final _scheduleExporterRepositoryDep = dep(
    () => ScheduleExporterRepository(),
  );

  @override
  ScheduleExporterRepository get scheduleExporterRepository =>
      _scheduleExporterRepositoryDep.get;

  late final _communityRepositoryDep = dep(
    () => CommunityRepository(apiClient: _apiClient),
  );

  @override
  CommunityRepository get communityRepository => _communityRepositoryDep.get;

  late final _discourseRepositoryDep = dep(
    () => DiscourseRepository(apiClient: _discourseApiClient),
  );

  @override
  DiscourseRepository get discourseRepository => _discourseRepositoryDep.get;

  late final _newsRepositoryDep = dep(
    () => NewsRepository(apiClient: _apiClient),
  );

  @override
  NewsRepository get newsRepository => _newsRepositoryDep.get;

  late final _articleStorageDep = dep(
    () => ArticleStorage(storage: secureStorage),
  );

  late final _articleRepositoryDep = dep(
    () => ArticleRepository(
      apiClient: _apiClient,
      storage: _articleStorageDep.get,
    ),
  );

  @override
  ArticleRepository get articleRepository => _articleRepositoryDep.get;

  late final _nfcPassRepositoryDep = dep(
    () => NfcPassRepository(storage: secureStorage),
  );

  @override
  NfcPassRepository get nfcPassRepository => _nfcPassRepositoryDep.get;

  late final _lostFoundRepositoryDep = dep(
    () => LostFoundRepository(apiClient: _apiClient),
  );

  @override
  LostFoundRepository get lostFoundRepository => _lostFoundRepositoryDep.get;

  // Router
  late final _routerDep = dep(() => createRouter());

  @override
  GoRouter get router => _routerDep.get;

  // Cubits and Blocs
  late final _homeCubitDep = dep(() => HomeCubit());

  @override
  HomeCubit get homeCubit => _homeCubitDep.get;

  late final _themeCubitDep = dep(() => ThemeCubit());

  @override
  ThemeCubit get themeCubit => _themeCubitDep.get;

  late final _adsBlocDep = dep(() => AdsBloc());

  @override
  AdsBloc get adsBloc => _adsBlocDep.get;

  // Yandex Ads functions
  Future<void> _yandexInterstitialAdLoader({
    required String adUnitId,
    required AdRequestConfiguration adRequestConfiguration,
    required void Function(InterstitialAd ad) onAdLoaded,
    required void Function(Object error) onAdFailedToLoad,
  }) async {
    try {
      final loader = await InterstitialAdLoader.create(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      );
      await loader.loadAd(adRequestConfiguration: adRequestConfiguration);
    } catch (error) {
      onAdFailedToLoad(error);
    }
  }

  Future<void> _yandexRewardedAdLoader({
    required String adUnitId,
    required AdRequestConfiguration adRequestConfiguration,
    required void Function(RewardedAd ad) onAdLoaded,
    required void Function(Object error) onAdFailedToLoad,
  }) async {
    try {
      final loader = await RewardedAdLoader.create(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      );
      await loader.loadAd(adRequestConfiguration: adRequestConfiguration);
    } catch (error) {
      onAdFailedToLoad(error);
    }
  }

  late final _fullScreenAdsBlocDep = dep(
    () =>
        FullScreenAdsBloc(
            interstitialAdLoader: _yandexInterstitialAdLoader,
            rewardedAdLoader: _yandexRewardedAdLoader,
            adsRetryPolicy: const AdsRetryPolicy(),
            localPlatform: const LocalPlatform(),
          )
          ..add(const LoadInterstitialAdRequested())
          ..add(const LoadRewardedAdRequested()),
  );

  @override
  FullScreenAdsBloc get fullScreenAdsBloc => _fullScreenAdsBlocDep.get;

  late final _analyticsBlockDep = dep(
    () => AnalyticsBloc(analyticsRepository: analyticsRepository),
  );

  @override
  AnalyticsBloc get analyticsBloc => _analyticsBlockDep.get;

  late final _scheduleBlcDep = dep(
    () =>
        ScheduleBloc(scheduleRepository: scheduleRepository)
          ..add(const RefreshSelectedScheduleData()),
  );

  @override
  ScheduleBloc get scheduleBloc => _scheduleBlcDep.get;

  late final _nfcPassCubitDep = dep(
    () => NfcPassCubit(repository: nfcPassRepository),
  );

  @override
  NfcPassCubit get nfcPassCubit => _nfcPassCubitDep.get;

  late final _categoriesBlocDep = dep(
    () =>
        CategoriesBloc(newsRepository: newsRepository)
          ..add(const CategoriesRequested()),
  );

  @override
  CategoriesBloc get categoriesBloc => _categoriesBlocDep.get;

  late final _feedBlocDep = dep(() => FeedBloc(newsRepository: newsRepository));

  @override
  FeedBloc get feedBloc => _feedBlocDep.get;

  late final _lostFoundBlocDep = dep(() {
    final authScope = authScopeHolder.scope;
    final userRepository = authScope?.userRepository;

    return LostFoundBloc(
      repository: lostFoundRepository,
      userRepository: userRepository!,
    );
  });

  @override
  LostFoundBloc get lostFoundBloc => _lostFoundBlocDep.get;

  // App Scope Bloc
  late final _appScopeBlocDep = dep(
    () => AppScopeBloc(
      authScopeHolder: authScopeHolder,
      firebaseMessaging: firebaseMessaging,
    )..add(const AppScopeStarted()),
  );

  @override
  AppScopeBloc get appScopeBloc => _appScopeBlocDep.get;
}

/// App Scope Holder
class AppScopeHolder extends ScopeHolder<AppScopeContainer> {
  AppScopeHolder({
    required SharedPreferences sharedPreferences,
    required AnalyticsRepository analyticsRepository,
    required PackageInfoClient packageInfoClient,
    required SupabaseClient supabaseClient,
  }) : _sharedPreferences = sharedPreferences,
       _analyticsRepository = analyticsRepository,
       _packageInfoClient = packageInfoClient,
       _supabaseClient = supabaseClient;

  final SharedPreferences _sharedPreferences;
  final AnalyticsRepository _analyticsRepository;
  final PackageInfoClient _packageInfoClient;
  final SupabaseClient _supabaseClient;

  @override
  AppScopeContainer createContainer() => AppScopeContainer(
    sharedPreferences: _sharedPreferences,
    analyticsRepository: _analyticsRepository,
    packageInfoClient: _packageInfoClient,
    supabaseClient: _supabaseClient,
  );
}
