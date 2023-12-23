import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rtu_mirea_app/common/oauth.dart';

import 'package:rtu_mirea_app/common/widget_data_init.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rtu_mirea_app/data/datasources/strapi_remote.dart';
import 'package:rtu_mirea_app/data/repositories/stories_repository_impl.dart';
import 'package:rtu_mirea_app/presentation/bloc/about_app_bloc/about_app_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/announces_bloc/announces_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/app_cubit/app_cubit.dart';
import 'package:rtu_mirea_app/presentation/bloc/attendance_bloc/attendance_bloc.dart';

import 'package:rtu_mirea_app/presentation/bloc/employee_bloc/employee_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/map_cubit/map_cubit.dart';
import 'package:rtu_mirea_app/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/nfc_feedback_bloc/nfc_feedback_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/nfc_pass_bloc/nfc_pass_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/notification_preferences/notification_preferences_bloc.dart';

import 'package:rtu_mirea_app/presentation/bloc/scores_bloc/scores_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:intl/intl_standalone.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/service_locator.dart' as dependency_injection;
import 'package:rtu_mirea_app/stories/bloc/stories_bloc.dart';
import 'package:sentry_dio/sentry_dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university_app_server_api/client.dart';
import 'package:url_strategy/url_strategy.dart';
import 'common/constants.dart';
import 'presentation/app_notifier.dart';
import 'service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:sentry_logging/sentry_logging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:schedule_repository/schedule_repository.dart'
    as schedule_repository;

class GlobalBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    Sentry.captureException(error, stackTrace: stackTrace);

    if (kDebugMode) {
      print(stackTrace);
    }

    super.onError(bloc, error, stackTrace);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dependency_injection.setup();

  WidgetDataProvider.initData();

  if (Platform.isAndroid || Platform.isIOS) {
    await FirebaseAnalytics.instance.logAppOpen();
  }

  if (kDebugMode) {
    // Clear Secure Storage
    var secureStorage = getIt<FlutterSecureStorage>();
    await secureStorage.deleteAll();

    // Clear local dota
    var prefs = getIt<SharedPreferences>();
    await prefs.clear();

    // Clear oauth tokens
    var lksOauth2 = getIt<LksOauth2>();
    await lksOauth2.oauth2Helper.removeAllTokens();
  }

  setPathUrlStrategy();

  Intl.defaultLocale = 'ru_RU';

  if (kIsWeb) {
    Intl.systemLocale = Intl.defaultLocale!;
  } else {
    Intl.systemLocale = await findSystemLocale();
  }

  Bloc.observer = GlobalBlocObserver();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationSupportDirectory(),
  );
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
          child: ChangeNotifierProvider<AppNotifier>(
            create: (context) => getIt<AppNotifier>(),
            child: const App(),
          ),
        ),
      ),
    ),
  ).then((value) {
    final Dio dio = getIt<Dio>();
    dio.addSentry();
  });
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = getIt<GoRouter>();

    // blocking the orientation of the application to
    // vertical only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    final apiClient = ScheduleApiClient();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
            value:
                schedule_repository.ScheduleRepository(apiClient: apiClient)),
        RepositoryProvider.value(
          value: StoriesRepositoryImpl(
              remoteDataSource: getIt<StrapiRemoteData>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ScheduleBloc>(
            create: (context) => ScheduleBloc(
              scheduleRepository:
                  context.read<schedule_repository.ScheduleRepository>(),
            )..add(const ScheduleResumed()),
          ),
          BlocProvider<StoriesBloc>(
            create: (context) => StoriesBloc(
              storiesRepository: context.read<StoriesRepositoryImpl>(),
            )..add(LoadStories()),
          ),
          BlocProvider<MapCubit>(create: (context) => getIt<MapCubit>()),
          BlocProvider<NewsBloc>(create: (context) => getIt<NewsBloc>()),
          BlocProvider<AboutAppBloc>(
              create: (context) =>
                  getIt<AboutAppBloc>()..add(AboutAppGetMembers())),
          BlocProvider<UserBloc>(create: (context) => getIt<UserBloc>()),
          BlocProvider<AnnouncesBloc>(
              create: (context) => getIt<AnnouncesBloc>()),
          BlocProvider<EmployeeBloc>(
              create: (context) => getIt<EmployeeBloc>()),
          BlocProvider<ScoresBloc>(create: (context) => getIt<ScoresBloc>()),
          BlocProvider<AttendanceBloc>(
              create: (context) => getIt<AttendanceBloc>()),
          BlocProvider<AppCubit>(create: (context) => getIt<AppCubit>()),
          if (Platform.isAndroid)
            BlocProvider<NfcPassBloc>(
              create: (_) => getIt<NfcPassBloc>()
                ..add(
                  const NfcPassEvent.fetchNfcCode(),
                ),
              lazy: false,
            ),
          BlocProvider<NfcFeedbackBloc>(
            create: (_) => getIt<NfcFeedbackBloc>(),
          ),
          BlocProvider<NotificationPreferencesBloc>(
            create: (_) => getIt<NotificationPreferencesBloc>(),
          ),
        ],
        child: Consumer<AppNotifier>(
          builder: (BuildContext context, AppNotifier value, Widget? child) {
            return MaterialApp.router(
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('ru'),
              ],
              locale: const Locale('ru'),
              debugShowCheckedModeBanner: false,
              title: 'Приложение РТУ МИРЭА',
              routerConfig: router,
              themeMode: AppTheme.themeMode,
              theme: AppTheme.theme,
              darkTheme: AppTheme.darkTheme,
            );
          },
        ),
      ),
    );
  }
}
