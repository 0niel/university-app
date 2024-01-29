import 'dart:io' show Platform;
import 'package:analytics_repository/analytics_repository.dart';
import 'package:community_repository/community_repository.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rtu_mirea_app/analytics/bloc/analytics_bloc.dart';
import 'package:rtu_mirea_app/app_bloc_observer.dart';

import 'package:rtu_mirea_app/common/widget_data_init.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rtu_mirea_app/data/datasources/strapi_remote.dart';
import 'package:rtu_mirea_app/data/repositories/stories_repository_impl.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/neon/main.dart';
import 'package:rtu_mirea_app/presentation/bloc/announces_bloc/announces_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/attendance_bloc/attendance_bloc.dart';

import 'package:rtu_mirea_app/presentation/bloc/employee_bloc/employee_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/notification_preferences/notification_preferences_bloc.dart';

import 'package:rtu_mirea_app/presentation/bloc/scores_bloc/scores_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:intl/intl_standalone.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/service_locator.dart' as dependency_injection;
import 'package:rtu_mirea_app/stories/bloc/stories_bloc.dart';
import 'package:sentry_dio/sentry_dio.dart';
import 'package:university_app_server_api/client.dart';
import 'package:url_strategy/url_strategy.dart';
import 'common/constants.dart';
import 'service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:sentry_logging/sentry_logging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:schedule_repository/schedule_repository.dart' as schedule_repository;
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:neon_framework/models.dart' as neon_models;
import 'package:neon_framework/src/bloc/result.dart' as neon_bloc_result;
import 'package:nextcloud/core.dart' as neon_core;
import 'package:neon_framework/src/widgets/options_collection_builder.dart';
import 'package:neon_framework/src/utils/global_options.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:neon_framework/src/utils/provider.dart';
import 'package:neon_framework/l10n/localizations.dart' as neon_localizations;
import 'package:neon_framework/theme.dart' as neon_theme;
import 'package:neon_framework/src/theme/theme.dart' as app_neon_theme;
import 'package:neon_framework/src/theme/server.dart' as neon_server_theme;

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
    // var secureStorage = getIt<FlutterSecureStorage>();
    // await secureStorage.deleteAll();

    // // Clear local dota
    // var prefs = getIt<SharedPreferences>();
    // await prefs.clear();

    // // Clear oauth tokens
    // var lksOauth2 = getIt<LksOauth2>();
    // await lksOauth2.oauth2Helper.removeAllTokens();
  }

  setPathUrlStrategy();

  Intl.defaultLocale = 'ru_RU';

  if (kIsWeb) {
    Intl.systemLocale = Intl.defaultLocale!;
  } else {
    Intl.systemLocale = await findSystemLocale();
  }

  final analyticsRepository = AnalyticsRepository(FirebaseAnalytics.instance);

  Bloc.observer = AppBlocObserver(analyticsRepository: analyticsRepository);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getApplicationDocumentsDirectory(),
  );

  final (neonTheme, neonProviders) = await runNeon();

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
            providers: neonProviders,
            neonTheme: neonTheme,
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
  const App({
    required AnalyticsRepository analyticsRepository,
    required this.providers,
    required this.neonTheme,
    super.key,
  }) : _analyticsRepository = analyticsRepository;

  final AnalyticsRepository _analyticsRepository;
  final List<SingleChildWidget> providers;
  final neon_theme.NeonTheme neonTheme;

  @override
  Widget build(BuildContext context) {
    // blocking the orientation of the application to
    // vertical only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    final apiClient = ApiClient();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _analyticsRepository),
        RepositoryProvider.value(value: schedule_repository.ScheduleRepository(apiClient: apiClient)),
        RepositoryProvider.value(value: CommunityRepository(apiClient: apiClient)),
        RepositoryProvider.value(
          value: StoriesRepositoryImpl(remoteDataSource: getIt<StrapiRemoteData>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AnalyticsBloc(
              analyticsRepository: _analyticsRepository,
            ),
            lazy: false,
          ),
          BlocProvider<ScheduleBloc>(
            create: (context) => ScheduleBloc(
              scheduleRepository: context.read<schedule_repository.ScheduleRepository>(),
            )..add(const ScheduleResumed()),
          ),
          BlocProvider<StoriesBloc>(
            create: (context) => StoriesBloc(
              storiesRepository: context.read<StoriesRepositoryImpl>(),
            )..add(LoadStories()),
          ),
          BlocProvider<NewsBloc>(create: (context) => getIt<NewsBloc>()),
          BlocProvider<UserBloc>(create: (context) => getIt<UserBloc>()),
          BlocProvider<AnnouncesBloc>(create: (context) => getIt<AnnouncesBloc>()),
          BlocProvider<EmployeeBloc>(create: (context) => getIt<EmployeeBloc>()),
          BlocProvider<ScoresBloc>(create: (context) => getIt<ScoresBloc>()),
          BlocProvider<AttendanceBloc>(create: (context) => getIt<AttendanceBloc>()),
          BlocProvider<HomeCubit>(create: (context) => getIt<HomeCubit>()),
          BlocProvider<NotificationPreferencesBloc>(
            create: (_) => getIt<NotificationPreferencesBloc>(),
          ),
        ],
        child: MultiProvider(
          providers: providers,
          child: _NeonProvider(
            key: _neonWrapperKey,
            neonTheme: neonTheme,
            builder: (theme) {
              final light = AppTheme.lightTheme.copyWith(extensions: [
                theme.serverTheme,
                theme.neonTheme,
              ]);
              final dark = AppTheme.darkTheme.copyWith(extensions: [
                theme.serverTheme,
                theme.neonTheme,
              ]);
              return _MaterialApp(
                lightTheme: light,
                darkTheme: dark,
              );
            },
          ),
        ),
      ),
    );
  }
}

final _neonWrapperKey = GlobalKey<_NeonProviderState>();

class _NeonProvider extends StatefulWidget {
  const _NeonProvider({
    Key? key,
    required this.builder,
    required this.neonTheme,
  }) : super(key: key);

  final Widget Function(app_neon_theme.AppTheme) builder;
  final neon_theme.NeonTheme neonTheme;

  @override
  State<_NeonProvider> createState() => _NeonProviderState();
}

class _NeonProviderState extends State<_NeonProvider> {
  late final Iterable<neon_models.AppImplementation> _appImplementations;
  late final GlobalOptions _globalOptions;
  late final AccountsBloc _accountsBloc;

  @override
  void initState() {
    super.initState();

    _appImplementations = NeonProvider.of<Iterable<neon_models.AppImplementation>>(context);
    _globalOptions = NeonProvider.of<GlobalOptions>(context);
    _accountsBloc = NeonProvider.of<AccountsBloc>(context);
  }

  List<LocalizationsDelegate<dynamic>> getNeonLocalizationsDelegates() {
    return [
      ..._appImplementations.map((app) => app.localizationsDelegate),
      ...neon_localizations.NeonLocalizations.localizationsDelegates,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return OptionsCollectionBuilder(
      valueListenable: _globalOptions,
      builder: (context, options, _) => StreamBuilder<neon_models.Account?>(
        stream: _accountsBloc.activeAccount,
        builder: (context, activeAccountSnapshot) {
          return neon_bloc_result
              .ResultBuilder<neon_core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data?>.behaviorSubject(
            subject: activeAccountSnapshot.hasData
                ? _accountsBloc.getCapabilitiesBlocFor(activeAccountSnapshot.data!).capabilities
                : null,
            builder: (context, capabilitiesSnapshot) {
              final appTheme = app_neon_theme.AppTheme(
                serverTheme: neon_server_theme.ServerTheme(
                  nextcloudTheme: capabilitiesSnapshot.data?.capabilities.themingPublicCapabilities?.theming,
                ),
                useNextcloudTheme: false,
                deviceThemeLight: AppTheme.lightTheme.colorScheme,
                deviceThemeDark: AppTheme.darkTheme.colorScheme,
                appThemes: _appImplementations.map((a) => a.theme).whereType<ThemeExtension>(),
                neonTheme: widget.neonTheme,
              );

              return widget.builder(appTheme);
            },
          );
        },
      ),
    );
  }
}

class _MaterialApp extends StatefulWidget {
  const _MaterialApp({
    Key? key,
    required this.lightTheme,
    required this.darkTheme,
  }) : super(key: key);

  final ThemeData lightTheme;
  final ThemeData darkTheme;

  @override
  State<_MaterialApp> createState() => _MaterialAppState();
}

class _MaterialAppState extends State<_MaterialApp> {
  _MaterialAppState();

  late final GoRouter router;
  late final List<LocalizationsDelegate<dynamic>> neonLocalizationsDelegates;

  @override
  void initState() {
    super.initState();

    router = createRouter();
    neonLocalizationsDelegates =
        _neonWrapperKey.currentState!.getNeonLocalizationsDelegates().cast<LocalizationsDelegate<dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: widget.lightTheme,
      dark: widget.darkTheme,
      initial: AdaptiveThemeMode.dark,
      builder: (theme, darkTheme) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: theme.scaffoldBackgroundColor,
            statusBarColor: theme.scaffoldBackgroundColor,
            statusBarIconBrightness: theme.brightness == Brightness.light ? Brightness.light : Brightness.dark,
            systemNavigationBarIconBrightness:
                theme.brightness == Brightness.light ? Brightness.light : Brightness.dark));

        return MaterialApp.router(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            ...neonLocalizationsDelegates,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ru'),
          ],
          locale: const Locale('ru'),
          debugShowCheckedModeBanner: false,
          title: 'Приложение РТУ МИРЭА',
          routerConfig: router,
          theme: theme,
          darkTheme: darkTheme,
        );
      },
    );
  }
}
