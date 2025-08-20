import 'package:article_repository/article_repository.dart';
import 'package:community_repository/community_repository.dart';
import 'package:deep_link_client/deep_link_client.dart';
import 'package:discourse_api_client/discourse_api_client.dart';
import 'package:discourse_repository/discourse_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:news_repository/news_repository.dart';
import 'package:nfc_pass_repository/nfc_pass_repository.dart';
import 'package:package_info_client/package_info_client.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:rtu_mirea_app/app/app.dart';
import 'package:rtu_mirea_app/env/env.dart';
import 'package:rtu_mirea_app/main/bootstrap/bootstrap.dart';
import 'package:schedule_exporter_repository/schedule_exporter_repository.dart';
import 'package:schedule_repository/schedule_repository.dart' as schedule_repository;
import 'package:secure_storage/secure_storage.dart';
import 'package:supabase_authentication_client/supabase_authentication_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:token_storage/token_storage.dart';
import 'package:university_app_server_api/client.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:user_repository/user_repository.dart';

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
    final newsRepository = NewsRepository(apiClient: apiClient);
    final articleStorage = ArticleStorage(storage: secureStorage);
    final articleRepository = ArticleRepository(apiClient: apiClient, storage: articleStorage);
    final nfcPassRepository = NfcPassRepository(storage: secureStorage);
    final lostFoundRepository = LostFoundRepository(apiClient: apiClient);

    return App(
      analyticsRepository: analyticsRepository,
      scheduleRepository: scheduleRepository,
      communityRepository: communityRepository,
      discourseRepository: discourseRepository,
      newsRepository: newsRepository,
      articleRepository: articleRepository,
      scheduleExporterRepository: scheduleExporterRepository,
      nfcPassRepository: nfcPassRepository,
      lostFoundRepository: lostFoundRepository,
      userRepository: userRepository,
      user: await userRepository.user.first,
    );
  });
}
