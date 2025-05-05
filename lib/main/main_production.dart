import 'package:community_repository/community_repository.dart';
import 'package:deep_link_client/deep_link_client.dart';
import 'package:discourse_api_client/discourse_api_client.dart';
import 'package:discourse_repository/discourse_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:nfc_pass_repository/nfc_pass_repository.dart';
import 'package:package_info_client/package_info_client.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:rtu_mirea_app/app/app.dart';
import 'package:rtu_mirea_app/data/datasources/news_remote.dart';
import 'package:rtu_mirea_app/data/repositories/news_repository_impl.dart';
import 'package:rtu_mirea_app/env/env.dart';
import 'package:rtu_mirea_app/main/bootstrap/bootstrap.dart';
import 'package:rtu_mirea_app/neon/neon.dart';
import 'package:rtu_mirea_app/splash_video/api_client_adapter.dart';
import 'package:schedule_exporter_repository/schedule_exporter_repository.dart';
import 'package:schedule_repository/schedule_repository.dart' as schedule_repository;
import 'package:secure_storage/secure_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_authentication_client/supabase_authentication_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:token_storage/token_storage.dart';
import 'package:university_app_server_api/client.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:user_repository/user_repository.dart';
import 'package:splash_video_repository/splash_video_repository.dart';

void main() async {
  await bootstrap((sharedPreferences, analyticsRepository) async {
    // Initialize common services
    setPathUrlStrategy();

    final packageInfo = await PackageInfo.fromPlatform();
    final packageInfoClient = PackageInfoClient(
      appName: packageInfo.appName,
      packageName: packageInfo.packageName,
      packageVersion: '${packageInfo.version}+${packageInfo.buildNumber}',
    );

    final tokenStorage = InMemoryTokenStorage();
    final deepLinkService = DeepLinkService(deepLinkClient: DeepLinkClient());

    // Initialize Supabase
    final supabase = await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);
    final authClient = supabase.client.auth;

    // Initialize API clients
    final apiClient = ApiClient(
      tokenProvider: () async {
        final session = authClient.currentSession;
        return session?.accessToken;
      },
    );

    final discourseApiClient = DiscourseApiClient(baseUrl: 'https://mirea.ninja');

    // Initialize storages
    final persistentStorage = PersistentStorage(sharedPreferences: sharedPreferences);
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
    final secureStorage = SecureStorage(flutterSecureStorage);

    // Initialize splash video repository
    final splashVideoStorage = StorageBasedSplashVideoStorage(storage: persistentStorage);
    final apiClientAdapter = ApiClientAdapter(apiClient);
    final splashVideoRepository = ApiSplashVideoRepository(apiClient: apiClientAdapter, storage: splashVideoStorage);

    // Initialize repositories
    final userStorage = UserStorage(storage: persistentStorage);
    final authenticationClient = SupabaseAuthenticationClient(tokenStorage: tokenStorage, supabaseAuth: authClient);
    final userRepository = UserRepository(
      authenticationClient: authenticationClient,
      packageInfoClient: packageInfoClient,
      deepLinkService: deepLinkService,
      storage: userStorage,
    );
    final scheduleRepository = schedule_repository.ScheduleRepository(apiClient: apiClient);
    final scheduleExporterRepository = ScheduleExporterRepository();
    final communityRepository = CommunityRepository(apiClient: apiClient);
    final discourseRepository = DiscourseRepository(apiClient: discourseApiClient);
    final newsRepository = NewsRepositoryImpl(remoteDataSource: NewsRemoteDataImpl());
    final nfcPassRepository = NfcPassRepository(storage: secureStorage);
    final lostFoundRepository = LostFoundRepository(apiClient: apiClient);

    // Initialize Neon dependencies for mobile platforms
    NeonDependencies? neonDependencies;
    if (!kIsWeb) {
      try {
        neonDependencies = await initializeNeonDependencies(appImplementations: appImplementations, theme: neonTheme);
      } catch (e, stackTrace) {
        Logger().e('Neon dependencies initialization failed: $e');
        Logger().e(stackTrace);
        Sentry.captureException(e, stackTrace: stackTrace);
      }
    }

    return App(
      analyticsRepository: analyticsRepository,
      scheduleRepository: scheduleRepository,
      communityRepository: communityRepository,
      discourseRepository: discourseRepository,
      neonDependencies: neonDependencies,
      newsRepository: newsRepository,
      scheduleExporterRepository: scheduleExporterRepository,
      nfcPassRepository: nfcPassRepository,
      lostFoundRepository: lostFoundRepository,
      userRepository: userRepository,
      splashVideoRepository: splashVideoRepository,
      user: await userRepository.user.first,
    );
  });
}
