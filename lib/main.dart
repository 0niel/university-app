import 'dart:io' show Platform;
import 'package:analytics_repository/analytics_repository.dart';
import 'package:community_repository/community_repository.dart';
import 'package:dio/dio.dart';
import 'package:discourse_api_client/discourse_api_client.dart';
import 'package:discourse_repository/discourse_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:nfc_pass_repository/nfc_pass_repository.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:rtu_mirea_app/app/app.dart';
import 'package:rtu_mirea_app/app_bloc_observer.dart';
import 'package:rtu_mirea_app/common/hydrated_storage.dart';
import 'package:rtu_mirea_app/data/datasources/strapi_remote.dart';
import 'package:rtu_mirea_app/data/repositories/stories_repository_impl.dart';
import 'package:rtu_mirea_app/domain/repositories/news_repository.dart';
import 'package:rtu_mirea_app/env/env.dart';
import 'package:rtu_mirea_app/neon/neon.dart';
import 'package:intl/intl_standalone.dart';
import 'package:rtu_mirea_app/service_locator.dart' as dependency_injection;
import 'package:schedule_exporter_repository/schedule_exporter_repository.dart';
import 'package:sentry_dio/sentry_dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university_app_server_api/client.dart';
import 'package:url_strategy/url_strategy.dart';
import 'service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:sentry_logging/sentry_logging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:schedule_repository/schedule_repository.dart' as schedule_repository;
import 'package:yandex_maps_mapkit_lite/init.dart' as yandex_maps_mapkit_lite;

import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Yandex Mapkit.
  try {
    await yandex_maps_mapkit_lite.initMapkit(apiKey: Env.mapkitApiKey);
  } catch (e, stackTrace) {
    Logger().e('Yandex Mapkit initialization failed: $e');
    Logger().e(stackTrace);
    Sentry.captureException(e, stackTrace: stackTrace);
  }

  // Create API clients.
  late final ApiClient apiClient;
  try {
    apiClient = ApiClient();
  } catch (e, stackTrace) {
    Logger().e('ApiClient initialization failed: $e');
    Logger().e(stackTrace);
    Sentry.captureException(e, stackTrace: stackTrace);
    rethrow;
  }

  late final DiscourseApiClient discourseApiClient;
  try {
    discourseApiClient = DiscourseApiClient(baseUrl: 'https://mirea.ninja');
  } catch (e, stackTrace) {
    Logger().e('DiscourseApiClient initialization failed: $e');
    Logger().e(stackTrace);
    Sentry.captureException(e, stackTrace: stackTrace);
    rethrow;
  }

  // Initialize Firebase.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, stackTrace) {
    Logger().e('Firebase initialization failed: $e');
    Logger().e(stackTrace);
    Sentry.captureException(e, stackTrace: stackTrace);
    rethrow;
  }

  // Setup dependency injection.
  try {
    await dependency_injection.setup();
  } catch (e, stackTrace) {
    Logger().e('Dependency injection setup failed: $e');
    Logger().e(stackTrace);
    Sentry.captureException(e, stackTrace: stackTrace);
    rethrow;
  }

  // Log app open for Android/iOS.
  if (Platform.isAndroid || Platform.isIOS) {
    try {
      await FirebaseAnalytics.instance.logAppOpen();
    } catch (e, stackTrace) {
      Logger().e('FirebaseAnalytics.logAppOpen failed: $e');
      Logger().e(stackTrace);
      Sentry.captureException(e, stackTrace: stackTrace);
    }
  }

  // Set URL strategy.
  try {
    setPathUrlStrategy();
  } catch (e, stackTrace) {
    Sentry.captureException(e, stackTrace: stackTrace);
  }

  // Initialize locales.
  try {
    Intl.defaultLocale = 'ru_RU';
    if (kIsWeb) {
      Intl.systemLocale = Intl.defaultLocale!;
    } else {
      Intl.systemLocale = await findSystemLocale();
    }
  } catch (e, stackTrace) {
    Logger().e('Locales initialization failed: $e');
    Logger().e(stackTrace);
    Sentry.captureException(e, stackTrace: stackTrace);
  }

  // Initialize persistent storage.
  late final PersistentStorage persistentStorage;
  try {
    persistentStorage = PersistentStorage(
      sharedPreferences: getIt<SharedPreferences>(),
    );
  } catch (e, stackTrace) {
    Logger().e('PersistentStorage initialization failed: $e');
    Logger().e(stackTrace);
    Sentry.captureException(e, stackTrace: stackTrace);
    rethrow;
  }

  // Initialize secure storage.
  late final SecureStorage secureStorage;
  try {
    secureStorage = SecureStorage(getIt<FlutterSecureStorage>());
  } catch (e, stackTrace) {
    Logger().e('SecureStorage initialization failed: $e');
    Logger().e(stackTrace);
    Sentry.captureException(e, stackTrace: stackTrace);
    rethrow;
  }

  // Initialize analytics repository.
  late final AnalyticsRepository analyticsRepository;
  try {
    analyticsRepository = AnalyticsRepository(FirebaseAnalytics.instance);
  } catch (e, stackTrace) {
    Logger().e('AnalyticsRepository initialization failed: $e');
    Logger().e(stackTrace);
    Sentry.captureException(e, stackTrace: stackTrace);
    // Fallback to a no-op analytics repository.
    analyticsRepository = const AnalyticsRepository();
  }

  // Grouped initialization of repositories.
  late final schedule_repository.ScheduleRepository scheduleRepository;
  late final CommunityRepository communityRepository;
  late final DiscourseRepository discourseRepository;
  late final StoriesRepositoryImpl storiesRepository;
  late final NewsRepository newsRepository;
  late final NotificationsRepository notificationsRepository;
  late final ScheduleExporterRepository scheduleExporterRepository;
  late final NfcPassRepository nfcPassRepository;

  try {
    scheduleRepository = schedule_repository.ScheduleRepository(apiClient: apiClient);
    communityRepository = CommunityRepository(apiClient: apiClient);
    discourseRepository = DiscourseRepository(apiClient: discourseApiClient);
    storiesRepository = StoriesRepositoryImpl(remoteDataSource: getIt<StrapiRemoteData>());
    newsRepository = getIt<NewsRepository>();
    notificationsRepository = getIt<NotificationsRepository>();
    scheduleExporterRepository = ScheduleExporterRepository();
    nfcPassRepository = NfcPassRepository(storage: secureStorage);
  } catch (e, stackTrace) {
    Logger().e('Repositories initialization failed: $e');
    Logger().e(stackTrace);
    Sentry.captureException(e, stackTrace: stackTrace);
    rethrow;
  }

  // Setup Bloc observer.
  try {
    Bloc.observer = AppBlocObserver(analyticsRepository: analyticsRepository);
  } catch (e, stackTrace) {
    Logger().e('Bloc observer setup failed: $e');
    Logger().e(stackTrace);
    Sentry.captureException(e, stackTrace: stackTrace);
  }

  // Setup HydratedBloc storage.
  try {
    HydratedBloc.storage = CustomHydratedStorage(sharedPreferences: getIt<SharedPreferences>());
  } catch (e, stackTrace) {
    Logger().e('HydratedBloc storage setup failed: $e');
    Logger().e(stackTrace);
    Sentry.captureException(e, stackTrace: stackTrace);
  }

  // Initialize neon dependencies.
  late final NeonDependencies neonDependencies;
  try {
    neonDependencies = await initializeNeonDependencies(
      appImplementations: appImplementations,
      theme: neonTheme,
    );
  } catch (e, stackTrace) {
    Logger().e('Neon dependencies initialization failed: $e');
    Logger().e(stackTrace);
    Sentry.captureException(e, stackTrace: stackTrace);
    rethrow;
  }

  // Define a helper to run the app.
  void runMyApp() {
    runApp(
      SentryScreenshotWidget(
        child: DefaultAssetBundle(
          bundle: SentryAssetBundle(),
          child: App(
            analyticsRepository: analyticsRepository,
            scheduleRepository: scheduleRepository,
            communityRepository: communityRepository,
            storiesRepository: storiesRepository,
            discourseRepository: discourseRepository,
            neonDependencies: neonDependencies,
            newsRepository: newsRepository,
            scheduleExporterRepository: scheduleExporterRepository,
            nfcPassRepository: nfcPassRepository,
            key: const Key('App'),
          ),
        ),
      ),
    );
  }

  // Initialize Sentry and run the app.
  try {
    await SentryFlutter.init(
      (options) {
        options.dsn = Env.sentryDsn;
        options.enableAutoPerformanceTracing = true;
        // Set tracesSampleRate to 0.2 to capture 20% of transactions for
        // performance monitoring.
        options.tracesSampleRate = 0.2;
        options.attachScreenshot = true;
        options.addIntegration(LoggingIntegration());
      },
      appRunner: runMyApp,
    );
  } catch (e, stackTrace) {
    debugPrint('Sentry initialization failed: $e');
    Sentry.captureException(e, stackTrace: stackTrace);
    runMyApp();
  }

  try {
    final Dio dio = getIt<Dio>();
    dio.addSentry();
  } catch (e, stackTrace) {
    Logger().e('Dio Sentry integration failed: $e');
    Logger().e(stackTrace);
    await Sentry.captureException(e, stackTrace: stackTrace);
  }
}
