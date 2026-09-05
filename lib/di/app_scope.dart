import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:article_repository/article_repository.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:community_catalog_repository/community_catalog_repository.dart';
import 'package:community_repository/community_repository.dart';
import 'package:deep_link_client/deep_link_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:news_repository/news_repository.dart';
import 'package:nfc_pass_client/nfc_pass_client.dart';
import 'package:nfc_pass_repository/nfc_pass_repository.dart';
import 'package:package_info_client/package_info_client.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:promo_repository/promo_repository.dart';
import 'package:rtu_mirea_app/common/utils/logger.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/main/bootstrap/bloc_observer_initializer.dart';
import 'package:rtu_mirea_app/main/bootstrap/firebase_initializer.dart';
import 'package:rtu_mirea_app/main/bootstrap/hydrated_storage_initializer.dart';
import 'package:rtu_mirea_app/main/bootstrap/package_info_initializer.dart';
import 'package:rtu_mirea_app/main/bootstrap/shared_preferences_initializer.dart';
import 'package:rtu_mirea_app/main/bootstrap/supabase_initializer.dart';
import 'package:rtu_mirea_app/notifications/data/notification_inbox_repository.dart';
import 'package:schedule_exporter_repository/schedule_exporter_repository.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart' hide Scope;
import 'package:service_catalog_repository/service_catalog_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_groups_repository/study_groups_repository.dart';
import 'package:supabase_authentication_client/supabase_authentication_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yx_scope/yx_scope.dart';

abstract class AppScope implements Scope {
  UniversityConfig get universityConfig;
  AnalyticsRepository get analyticsRepository;
  CampusRepository get campusRepository;
  StudyGroupsRepository get studyGroupsRepository;
  FriendsRepository get friendsRepository;
  NotificationInboxRepository get notificationInboxRepository;
  GamificationRepository get gamificationRepository;
  ScheduleExporterRepository get scheduleExporterRepository;
  ScheduleRepository get scheduleRepository;
  PreferencesRepository get preferencesRepository;
  CommunityRepository get communityRepository;
  CommunityCatalogRepository get communityCatalogRepository;
  ServiceCatalogRepository get serviceCatalogRepository;
  PromoRepository get promoRepository;
  NewsRepository get newsRepository;
  ArticleRepository get articleRepository;
  NfcPassRepository get nfcPassRepository;
  LostFoundRepository get lostFoundRepository;
  MiniAppsRepository get miniAppsRepository;
  UserRepository get userRepository;
  LocalNotificationsRepository get localNotificationsRepository;
  SupabaseClient get supabaseClient;
}

class AppScopeContainer extends ScopeContainer implements AppScope {
  AppScopeContainer({required this.dev});

  final bool dev;

  late final AsyncDep<SharedPreferencesInitializer>
  _sharedPreferencesInitializerDep = asyncDep(
    SharedPreferencesInitializer.new,
  );
  late final AsyncDep<PackageInfoInitializer> _packageInfoInitializerDep =
      asyncDep(
        PackageInfoInitializer.new,
      );
  late final AsyncDep<FirebaseInitializer> _firebaseInitializerDep = asyncDep(
    FirebaseInitializer.new,
  );
  late final AsyncDep<SupabaseInitializer> _supabaseInitializerDep = asyncDep(
    SupabaseInitializer.new,
  );

  late final AsyncDep<HydratedStorageInitializer>
  _hydratedStorageInitializerDep = asyncDep(
    () => HydratedStorageInitializer(
      sharedPreferences: _sharedPreferencesInitializerDep.get.instance,
    ),
  );

  late final Dep<SharedPreferences> _sharedPreferencesDep = dep(
    () => _sharedPreferencesInitializerDep.get.instance,
  );
  late final Dep<PackageInfo> _packageInfoDep = dep(
    () => _packageInfoInitializerDep.get.instance,
  );
  late final Dep<SupabaseClient> _supabaseClientDep = dep(
    () => Supabase.instance.client,
  );
  late final Dep<UniversityConfig> _universityConfigDep = dep(
    () => UniversityConfig.current,
  );

  late final Dep<PersistentStorage> _persistentStorageDep = dep(
    () => PersistentStorage(sharedPreferences: _sharedPreferencesDep.get),
  );
  late final Dep<FlutterSecureStorage> _flutterSecureStorageDep = dep(
    () => const FlutterSecureStorage(),
  );
  late final Dep<SecureStorage> _secureStorageDep = dep(
    () => SecureStorage(_flutterSecureStorageDep.get),
  );
  late final Dep<DeepLinkService> _deepLinkServiceDep = dep(
    () => DeepLinkService(deepLinkClient: DeepLinkClient()),
  );
  late final Dep<PackageInfoClient> _packageInfoClientDep = dep(() {
    final packageInfo = _packageInfoDep.get;
    return PackageInfoClient(
      appName: dev ? '${packageInfo.appName} [DEV]' : packageInfo.appName,
      packageName: packageInfo.packageName,
      packageVersion: '${packageInfo.version}+${packageInfo.buildNumber}',
    );
  });

  late final Dep<SupabaseAuthenticationClient> _authenticationClientDep = dep(
    () => SupabaseAuthenticationClient(
      supabaseAuth: _supabaseClientDep.get.auth,
    ),
  );

  late final Dep<UserStorage> _userStorageDep = dep(
    () => UserStorage(storage: _persistentStorageDep.get),
  );
  late final Dep<UserRepository> _userRepositoryDep = dep(
    () => UserRepository(
      authenticationClient: _authenticationClientDep.get,
      packageInfoClient: _packageInfoClientDep.get,
      deepLinkService: _deepLinkServiceDep.get,
      storage: _userStorageDep.get,
      initializeUser: (userId) async {
        if (_supabaseClientDep.get.auth.currentUser?.id != userId) return;
        await _gamificationRepositoryDep.get.ensureAcademicProfile(
          _universityConfigDep.get.organizationId,
        );
      },
      onInitializationError: (error, stackTrace) {
        logger.e(
          'Academic profile initialization failed (${error.runtimeType}).',
        );
        unawaited(
          Sentry.captureException(
            StateError(
              'Academic profile initialization failed (${error.runtimeType}).',
            ),
            stackTrace: stackTrace,
          ),
        );
      },
    ),
  );
  late final Dep<ScheduleRepository> _scheduleRepositoryDep = dep(
    () => ScheduleRepository(
      supabaseClient: _supabaseClientDep.get,
      organizationId: _universityConfigDep.get.organizationId,
    ),
  );
  late final Dep<ScheduleExporterRepository> _scheduleExporterRepositoryDep =
      dep(
        () {
          final config = _universityConfigDep.get;
          final calendarEventUrl = config.calendarEventUrl;
          return ScheduleExporterRepository(
            eventUrl: calendarEventUrl == null
                ? null
                : Uri.parse(calendarEventUrl),
            calendarAccountName: config.universityName,
          );
        },
      );
  late final Dep<PreferencesRepository> _preferencesRepositoryDep = dep(
    () => PreferencesRepository(supabaseClient: _supabaseClientDep.get),
  );
  late final Dep<CommunityRepository> _communityRepositoryDep = dep(
    () => CommunityRepository(
      discourseBaseUrl: _universityConfigDep.get.communityForumUrl,
    ),
  );
  late final Dep<CommunityCatalogRepository> _communityCatalogRepositoryDep =
      dep(
        () => CommunityCatalogRepository(
          supabase: _supabaseClientDep.get,
          organizationId: _universityConfigDep.get.organizationId,
        ),
      );
  late final Dep<ServiceCatalogRepository> _serviceCatalogRepositoryDep = dep(
    () => ServiceCatalogRepository(
      supabase: _supabaseClientDep.get,
      organizationId: _universityConfigDep.get.organizationId,
    ),
  );
  late final Dep<PromoRepository> _promoRepositoryDep = dep(
    () => PromoRepository(
      supabase: _supabaseClientDep.get,
      organizationId: _universityConfigDep.get.organizationId,
      cache: _persistentStorageDep.get,
    ),
  );
  late final Dep<NewsRepository> _newsRepositoryDep = dep(
    () => NewsRepository(
      dataSource: SupabaseNewsRemoteDataSource(_supabaseClientDep.get),
      organizationId: _universityConfigDep.get.organizationId,
    ),
  );
  late final Dep<ArticleStorage> _articleStorageDep = dep(
    () => ArticleStorage(storage: _secureStorageDep.get),
  );
  late final Dep<ArticleRepository> _articleRepositoryDep = dep(
    () => ArticleRepository(
      supabase: _supabaseClientDep.get,
      organizationId: _universityConfigDep.get.organizationId,
      storage: _articleStorageDep.get,
    ),
  );
  late final Dep<NfcPassRepository> _nfcPassRepositoryDep = dep(
    () {
      final config = _universityConfigDep.get.nfcPass;
      return NfcPassRepository(
        storage: _secureStorageDep.get,
        configuration: NfcPassConfiguration(
          oauthUrl: Uri.parse(config.oauthUrl),
          expectedRedirectUrls: config.redirectUrls.map(Uri.parse).toList(),
          endpoints: NfcPassEndpoints(
            accessTokenUrl: Uri.parse(config.accessTokenUrl),
            sendVerificationCodeUrl: Uri.parse(config.sendVerificationCodeUrl),
            getDigitalPassUrl: Uri.parse(config.getDigitalPassUrl),
          ),
        ),
      );
    },
  );
  late final Dep<LostFoundRepository> _lostFoundRepositoryDep = dep(
    () => LostFoundRepository(
      supabase: _supabaseClientDep.get,
      organizationId: _universityConfigDep.get.organizationId,
    ),
  );
  late final Dep<MiniAppsRepository> _miniAppsRepositoryDep = dep(
    () => MiniAppsRepository(
      supabase: _supabaseClientDep.get,
      organizationId: _universityConfigDep.get.organizationId,
      cache: _persistentStorageDep.get,
    ),
  );
  late final Dep<GamificationRepository> _gamificationRepositoryDep = dep(
    () => GamificationRepository(supabase: _supabaseClientDep.get),
  );
  late final AsyncDep<FriendsRepository> _friendsRepositoryDep = rawAsyncDep(
    () => FriendsRepository(supabase: _supabaseClientDep.get),
    init: (_) => Future<void>.value(),
    dispose: (repository) async => repository.close(),
  );
  late final Dep<CampusRepository> _campusRepositoryDep = dep(
    () => CampusRepository(
      supabase: _supabaseClientDep.get,
      organizationId: _universityConfigDep.get.organizationId,
    ),
  );
  late final Dep<NotificationInboxRepository> _notificationInboxRepositoryDep =
      dep(
        () => SupabaseNotificationInboxRepository(_supabaseClientDep.get),
      );
  late final Dep<StudyGroupsRepository> _studyGroupsRepositoryDep = dep(
    () => StudyGroupsRepository(
      supabase: _supabaseClientDep.get,
      organizationId: _universityConfigDep.get.organizationId,
    ),
  );
  late final Dep<LocalNotificationsRepository>
  _localNotificationsRepositoryDep = dep(
    () => LocalNotificationsRepository(client: LocalNotificationsClient()),
  );
  late final Dep<AnalyticsRepository> _analyticsRepositoryDep = dep(() {
    if (!FirebaseRuntime.isInitialized) return const AnalyticsRepository();
    try {
      return AnalyticsRepository(.instance);
    } on Exception catch (e, st) {
      logger.e('Analytics init failed: $e');
      unawaited(Sentry.captureException(e, stackTrace: st));
      return const AnalyticsRepository();
    }
  });

  late final AsyncDep<BlocObserverInitializer> _blocObserverInitializerDep =
      asyncDep(
        () => BlocObserverInitializer(
          analyticsRepository: _analyticsRepositoryDep.get,
        ),
      );

  @override
  List<Set<AsyncDep<Object?>>> get initializeQueue => [
    {_sharedPreferencesInitializerDep},
    {
      _packageInfoInitializerDep,
      _firebaseInitializerDep,
      _supabaseInitializerDep,
    },
    {_hydratedStorageInitializerDep},
    {_blocObserverInitializerDep, _friendsRepositoryDep},
  ];

  @override
  UniversityConfig get universityConfig => _universityConfigDep.get;
  @override
  AnalyticsRepository get analyticsRepository => _analyticsRepositoryDep.get;
  @override
  ScheduleRepository get scheduleRepository => _scheduleRepositoryDep.get;
  @override
  PreferencesRepository get preferencesRepository =>
      _preferencesRepositoryDep.get;
  @override
  CommunityRepository get communityRepository => _communityRepositoryDep.get;
  @override
  CommunityCatalogRepository get communityCatalogRepository =>
      _communityCatalogRepositoryDep.get;
  @override
  ServiceCatalogRepository get serviceCatalogRepository =>
      _serviceCatalogRepositoryDep.get;
  @override
  PromoRepository get promoRepository => _promoRepositoryDep.get;
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
  MiniAppsRepository get miniAppsRepository => _miniAppsRepositoryDep.get;
  @override
  UserRepository get userRepository => _userRepositoryDep.get;
  @override
  GamificationRepository get gamificationRepository =>
      _gamificationRepositoryDep.get;
  @override
  FriendsRepository get friendsRepository => _friendsRepositoryDep.get;
  @override
  NotificationInboxRepository get notificationInboxRepository =>
      _notificationInboxRepositoryDep.get;
  @override
  CampusRepository get campusRepository => _campusRepositoryDep.get;
  @override
  StudyGroupsRepository get studyGroupsRepository =>
      _studyGroupsRepositoryDep.get;
  @override
  LocalNotificationsRepository get localNotificationsRepository =>
      _localNotificationsRepositoryDep.get;
  @override
  SupabaseClient get supabaseClient => _supabaseClientDep.get;
}

class AppScopeHolder extends ScopeHolder<AppScopeContainer> {
  AppScopeHolder({this.dev = false});

  final bool dev;

  @override
  AppScopeContainer createContainer() => .new(dev: dev);
}
