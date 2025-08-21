import 'package:analytics_repository/analytics_repository.dart';
import 'package:article_repository/article_repository.dart';
import 'package:community_repository/community_repository.dart';
import 'package:deep_link_client/deep_link_client.dart';
import 'package:discourse_api_client/discourse_api_client.dart';
import 'package:discourse_repository/discourse_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:news_repository/news_repository.dart';
import 'package:nfc_pass_repository/nfc_pass_repository.dart';
import 'package:package_info_client/package_info_client.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:rtu_mirea_app/common/utils/logger.dart';
import 'package:rtu_mirea_app/main/bootstrap/app_bloc_observer.dart';
import 'package:schedule_exporter_repository/schedule_exporter_repository.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_authentication_client/supabase_authentication_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:token_storage/token_storage.dart';
import 'package:university_app_server_api/client.dart';
import 'package:user_repository/user_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:yx_scope/yx_scope.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:sentry_flutter/sentry_flutter.dart' hide Scope;

/// Public interface for the root application scope.
abstract class AppScope implements Scope {
  AnalyticsRepository get analyticsRepository;
  ScheduleExporterRepository get scheduleExporterRepository;
  ScheduleRepository get scheduleRepository;
  CommunityRepository get communityRepository;
  DiscourseRepository get discourseRepository;
  NewsRepository get newsRepository;
  ArticleRepository get articleRepository;
  NfcPassRepository get nfcPassRepository;
  LostFoundRepository get lostFoundRepository;
  UserRepository get userRepository;
  SupabaseClient get supabaseClient;
  ApiClient get apiClient;
}

/// Root scope container. Holds all long-living dependencies.
class AppScopeContainer extends ScopeContainer implements AppScope {
  AppScopeContainer({
    required SharedPreferences sharedPreferences,
    required PackageInfo packageInfo,
    required bool dev,
  }) : _sharedPreferences = sharedPreferences,
       _packageInfo = packageInfo,
       _dev = dev;

  final SharedPreferences _sharedPreferences;
  final PackageInfo _packageInfo;
  final bool _dev;

  // Primitive deps / platform services
  late final _sharedPreferencesDep = dep(() => _sharedPreferences);
  late final _supabaseClientDep = dep(() => Supabase.instance.client);

  // Networking/API
  late final _apiClientDep = dep(() {
    tokenProvider() async {
      final session = _supabaseClientDep.get.auth.currentSession;
      return session?.accessToken;
    }

    if (_dev) {
      logger.d('Using localhost API client (dev mode).');
      return ApiClient.localhostFromEmulator(tokenProvider: tokenProvider);
    }
    return ApiClient(tokenProvider: tokenProvider);
  });

  late final _discourseApiClientDep = dep(
    () => DiscourseApiClient(baseUrl: 'https://mirea.ninja'),
  );

  // Storage layer
  late final _persistentStorageDep = dep(
    () => PersistentStorage(sharedPreferences: _sharedPreferencesDep.get),
  );
  late final _flutterSecureStorageDep = dep(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );
  late final _secureStorageDep = dep(
    () => SecureStorage(_flutterSecureStorageDep.get),
  );
  late final _tokenStorageDep = dep(() => InMemoryTokenStorage());

  // External service abstractions
  late final _deepLinkServiceDep = dep(
    () => DeepLinkService(deepLinkClient: DeepLinkClient()),
  );
  late final _packageInfoClientDep = dep(
    () => PackageInfoClient(
      appName:
          kDebugMode ? '${_packageInfo.appName} [DEV]' : _packageInfo.appName,
      packageName: _packageInfo.packageName,
      packageVersion: '${_packageInfo.version}+${_packageInfo.buildNumber}',
    ),
  );

  // Auth
  late final _authenticationClientDep = dep(
    () => SupabaseAuthenticationClient(
      tokenStorage: _tokenStorageDep.get,
      supabaseAuth: _supabaseClientDep.get.auth,
    ),
  );

  // Repositories
  late final _userStorageDep = dep(
    () => UserStorage(storage: _persistentStorageDep.get),
  );
  late final _userRepositoryDep = dep(
    () => UserRepository(
      authenticationClient: _authenticationClientDep.get,
      packageInfoClient: _packageInfoClientDep.get,
      deepLinkService: _deepLinkServiceDep.get,
      storage: _userStorageDep.get,
    ),
  );
  late final _scheduleRepositoryDep = dep(
    () => ScheduleRepository(apiClient: _apiClientDep.get),
  );
  late final _scheduleExporterRepositoryDep = dep(
    () => ScheduleExporterRepository(),
  );
  late final _communityRepositoryDep = dep(
    () => CommunityRepository(apiClient: _apiClientDep.get),
  );
  late final _discourseRepositoryDep = dep(
    () => DiscourseRepository(apiClient: _discourseApiClientDep.get),
  );
  late final _newsRepositoryDep = dep(
    () => NewsRepository(apiClient: _apiClientDep.get),
  );
  late final _articleStorageDep = dep(
    () => ArticleStorage(storage: _secureStorageDep.get),
  );
  late final _articleRepositoryDep = dep(
    () => ArticleRepository(
      apiClient: _apiClientDep.get,
      storage: _articleStorageDep.get,
    ),
  );
  late final _nfcPassRepositoryDep = dep(
    () => NfcPassRepository(storage: _secureStorageDep.get),
  );
  late final _lostFoundRepositoryDep = dep(
    () => LostFoundRepository(apiClient: _apiClientDep.get),
  );
  late final _analyticsRepositoryDep = dep(() {
    try {
      return AnalyticsRepository(FirebaseAnalytics.instance);
    } catch (e, st) {
      logger.e('Analytics init failed: $e');
      Sentry.captureException(e, stackTrace: st);
      return const AnalyticsRepository();
    }
  });

  @override
  AnalyticsRepository get analyticsRepository => _analyticsRepositoryDep.get;
  @override
  ScheduleRepository get scheduleRepository => _scheduleRepositoryDep.get;
  @override
  CommunityRepository get communityRepository => _communityRepositoryDep.get;
  @override
  DiscourseRepository get discourseRepository => _discourseRepositoryDep.get;
  @override
  NewsRepository get newsRepository => _newsRepositoryDep.get;
  @override
  ArticleRepository get articleRepository => _articleRepositoryDep.get;
  @override
  ScheduleExporterRepository get scheduleExporterRepository =>
      _scheduleExporterRepositoryDep.get;
  @override
  NfcPassRepository get nfcPassRepository => _nfcPassRepositoryDep.get;
  @override
  LostFoundRepository get lostFoundRepository => _lostFoundRepositoryDep.get;
  @override
  UserRepository get userRepository => _userRepositoryDep.get;
  @override
  SupabaseClient get supabaseClient => _supabaseClientDep.get;
  @override
  ApiClient get apiClient => _apiClientDep.get;
}

/// Holder for the [AppScopeContainer].
class AppScopeHolder extends ScopeHolder<AppScopeContainer> {
  AppScopeHolder({
    required this.sharedPreferences,
    required this.packageInfo,
    this.dev = false,
  });

  final SharedPreferences sharedPreferences;
  final PackageInfo packageInfo;
  final bool dev;

  @override
  AppScopeContainer createContainer() => AppScopeContainer(
    sharedPreferences: sharedPreferences,
    packageInfo: packageInfo,
    dev: dev,
  );

  @override
  Future<void> create() async {
    await super.create();
    final scope = this.scope;
    if (scope != null) {
      Bloc.observer = AppBlocObserver(
        analyticsRepository: scope.analyticsRepository,
      );
    }
  }
}
