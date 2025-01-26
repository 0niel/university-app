import 'dart:io' show Platform;
import 'package:analytics_repository/analytics_repository.dart';
import 'package:community_repository/community_repository.dart';
import 'package:dio/dio.dart';
import 'package:discourse_api_client/discourse_api_client.dart';
import 'package:discourse_repository/discourse_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
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

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await yandex_maps_mapkit_lite.initMapkit(apiKey: Env.mapkitApiKey);
  final apiClient = ApiClient();
  final discourseApiClient = DiscourseApiClient(baseUrl: 'https://mirea.ninja');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dependency_injection.setup();

  if (Platform.isAndroid || Platform.isIOS) {
    await FirebaseAnalytics.instance.logAppOpen();
  }

  setPathUrlStrategy();

  Intl.defaultLocale = 'ru_RU';

  if (kIsWeb) {
    Intl.systemLocale = Intl.defaultLocale!;
  } else {
    Intl.systemLocale = await findSystemLocale();
  }

  final persistentStorage = PersistentStorage(
    sharedPreferences: getIt<SharedPreferences>(),
  );
  final secureStorage = SecureStorage(
    getIt<FlutterSecureStorage>(),
  );
  late final AnalyticsRepository analyticsRepository;
  try {
    analyticsRepository = AnalyticsRepository(FirebaseAnalytics.instance);
  } catch (e) {
    analyticsRepository = const AnalyticsRepository();
  }
  final schedule_repository.ScheduleRepository scheduleRepository =
      schedule_repository.ScheduleRepository(apiClient: apiClient);
  final communityRepository = CommunityRepository(apiClient: apiClient);
  final discourseRepository = DiscourseRepository(apiClient: discourseApiClient);
  // TODO: Remove service locator feature
  final storiesRepository = StoriesRepositoryImpl(remoteDataSource: getIt<StrapiRemoteData>());
  final newsRepository = getIt<NewsRepository>();
  final notificationsRepository = getIt<NotificationsRepository>();
  final scheduleExporterRepository = ScheduleExporterRepository();
  final nfcPassRepository = NfcPassRepository(storage: secureStorage);

  Bloc.observer = AppBlocObserver(analyticsRepository: analyticsRepository);

  HydratedBloc.storage = CustomHydratedStorage(sharedPreferences: getIt<SharedPreferences>());

  FlutterNativeSplash.remove();

  final neonDependencies = await initializeNeonDependencies(
    appImplementations: appImplementations,
    theme: neonTheme,
  );

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
    appRunner: () => runApp(
      /// When a user experiences an error, an exception or a crash,
      /// Sentry provides the ability to take a screenshot and include
      /// it as an attachment.
      SentryScreenshotWidget(
        child: DefaultAssetBundle(
          /// The AssetBundle instrumentation provides insight into how long
          /// app takes to load its assets, such as files
          bundle: SentryAssetBundle(),
          child: App(
            analyticsRepository: analyticsRepository,
            scheduleRepository: scheduleRepository,
            communityRepository: communityRepository,
            storiesRepository: storiesRepository,
            discourseRepository: discourseRepository,
            neonDependencies: neonDependencies,
            newsRepository: newsRepository,
            notificationsRepository: notificationsRepository,
            scheduleExporterRepository: scheduleExporterRepository,
            nfcPassRepository: nfcPassRepository,
            key: const Key('App'),
          ),
        ),
      ),
    ),
  ).then((value) {
    final Dio dio = getIt<Dio>();
    dio.addSentry();
  });
}
