import 'dart:io' show Platform;
import 'package:analytics_repository/analytics_repository.dart';
import 'package:community_repository/community_repository.dart';
import 'package:dio/dio.dart';
import 'package:discourse_api_client/discourse_api_client.dart';
import 'package:discourse_repository/discourse_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:rtu_mirea_app/app/app.dart';
import 'package:rtu_mirea_app/app_bloc_observer.dart';
import 'package:rtu_mirea_app/common/hydrated_storage.dart';
import 'package:rtu_mirea_app/data/datasources/strapi_remote.dart';
import 'package:rtu_mirea_app/data/repositories/stories_repository_impl.dart';

import 'package:rtu_mirea_app/domain/repositories/news_repository.dart';
import 'package:rtu_mirea_app/neon/main.dart';

import 'package:intl/intl_standalone.dart';
import 'package:rtu_mirea_app/service_locator.dart' as dependency_injection;
import 'package:sentry_dio/sentry_dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university_app_server_api/client.dart';
import 'package:url_strategy/url_strategy.dart';
import 'common/constants.dart';
import 'service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:sentry_logging/sentry_logging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:schedule_repository/schedule_repository.dart' as schedule_repository;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiClient = ApiClient();
  final discourseApiClient = DiscourseApiClient(baseUrl: 'https://mirea.ninja');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dependency_injection.setup();

  if (Platform.isAndroid || Platform.isIOS) {
    await FirebaseAnalytics.instance.logAppOpen();
  }

  if (kDebugMode) {
    try {
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

      String? token = await firebaseMessaging.getToken();

      Logger().i('Firebase token: $token');

      // Clear Secure Storage
      // var secureStorage = getIt<FlutterSecureStorage>();
      // await secureStorage.deleteAll();

      // // Clear local dota
      // var prefs = getIt<SharedPreferences>();
      // await prefs.clear();

      // // Clear oauth tokens
      // var lksOauth2 = getIt<LksOauth2>();
      // await lksOauth2.oauth2Helper.removeAllTokens();
    } catch (e) {
      Logger().e('Firebase token error: $e');
    }
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

  Bloc.observer = AppBlocObserver(analyticsRepository: analyticsRepository);

  HydratedBloc.storage = CustomHydratedStorage(sharedPreferences: getIt<SharedPreferences>());

  final (neonTheme, neonProviders) = await runNeon();

  // blocking the orientation of the application to
  // vertical only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  await SentryFlutter.init(
    (options) {
      options.dsn = sentryDsn;

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
            neonTheme: neonTheme,
            neonProviders: neonProviders,
            newsRepository: newsRepository,
            notificationsRepository: notificationsRepository,
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
