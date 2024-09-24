import 'package:analytics_repository/analytics_repository.dart';
import 'package:community_repository/community_repository.dart';
import 'package:discourse_repository/discourse_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:rtu_mirea_app/app/app.dart';
import 'package:rtu_mirea_app/domain/repositories/news_repository.dart';
import 'package:rtu_mirea_app/schedule_management/bloc/schedule_exporter_cubit.dart';
import 'package:rtu_mirea_app/service_locator.dart';
import 'package:schedule_exporter_repository/schedule_exporter_repository.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rtu_mirea_app/analytics/bloc/analytics_bloc.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rtu_mirea_app/data/repositories/stories_repository_impl.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/presentation/bloc/announces_bloc/announces_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/attendance_bloc/attendance_bloc.dart';

import 'package:rtu_mirea_app/presentation/bloc/employee_bloc/employee_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/notification_preferences/notification_preferences_bloc.dart';

import 'package:rtu_mirea_app/presentation/bloc/scores_bloc/scores_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/stories/bloc/stories_bloc.dart';

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

class App extends StatelessWidget {
  const App({
    required AnalyticsRepository analyticsRepository,
    required ScheduleRepository scheduleRepository,
    required CommunityRepository communityRepository,
    required StoriesRepositoryImpl storiesRepository,
    required DiscourseRepository discourseRepository,
    required NewsRepository newsRepository,
    required NotificationsRepository notificationsRepository,
    required ScheduleExporterRepository scheduleExporterRepository,
    required List<SingleChildWidget> neonProviders,
    required neon_theme.NeonTheme neonTheme,
    required super.key,
  })  : _analyticsRepository = analyticsRepository,
        _scheduleRepository = scheduleRepository,
        _communityRepository = communityRepository,
        _storiesRepository = storiesRepository,
        _discourseRepository = discourseRepository,
        _newsRepository = newsRepository,
        _notificationsRepository = notificationsRepository,
        _scheduleExporterRepository = scheduleExporterRepository,
        _neonTheme = neonTheme,
        _neonProviders = neonProviders;

  final AnalyticsRepository _analyticsRepository;
  final ScheduleRepository _scheduleRepository;
  final CommunityRepository _communityRepository;
  final StoriesRepositoryImpl _storiesRepository;
  final DiscourseRepository _discourseRepository;
  final NewsRepository _newsRepository;
  final NotificationsRepository _notificationsRepository;
  final neon_theme.NeonTheme _neonTheme;
  final List<SingleChildWidget> _neonProviders;
  final ScheduleExporterRepository _scheduleExporterRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _analyticsRepository),
        RepositoryProvider.value(value: _scheduleRepository),
        RepositoryProvider.value(value: _communityRepository),
        RepositoryProvider.value(value: _storiesRepository),
        RepositoryProvider.value(value: _discourseRepository),
        RepositoryProvider.value(value: _scheduleExporterRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ScheduleExporterCubit(_scheduleExporterRepository),
          ),
          BlocProvider(
            create: (_) => AppBloc(
              firebaseMessaging: FirebaseMessaging.instance,
            )..add(const AppOpened()),
          ),
          BlocProvider(
            create: (context) => AnalyticsBloc(
              analyticsRepository: _analyticsRepository,
            ),
            lazy: false,
          ),
          BlocProvider<ScheduleBloc>(
            create: (context) => ScheduleBloc(
              scheduleRepository: context.read<schedule_repository.ScheduleRepository>(),
            )..add(const RefreshSelectedScheduleData()),
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
          providers: _neonProviders,
          child: _NeonProvider(
            key: _neonWrapperKey,
            neonTheme: _neonTheme,
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
    super.key,
    required this.builder,
    required this.neonTheme,
  });

  final Widget Function(app_neon_theme.AppTheme) builder;
  final neon_theme.NeonTheme neonTheme;

  @override
  State<_NeonProvider> createState() => _NeonProviderState();
}

class _NeonProviderState extends State<_NeonProvider> {
  late final BuiltSet<neon_models.AppImplementation> _appImplementations;
  late final GlobalOptions _globalOptions;
  late final AccountsBloc _accountsBloc;

  @override
  void initState() {
    super.initState();

    _appImplementations = NeonProvider.of<BuiltSet<neon_models.AppImplementation>>(context);
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
    required this.lightTheme,
    required this.darkTheme,
  });

  final ThemeData lightTheme;
  final ThemeData darkTheme;

  @override
  State<_MaterialApp> createState() => _MaterialAppState();
}

class _MaterialAppState extends State<_MaterialApp> {
  late final GoRouter router;
  late final List<LocalizationsDelegate<dynamic>> neonLocalizationsDelegates;

  @override
  void initState() {
    super.initState();

    router = getIt<GoRouter>();
    neonLocalizationsDelegates =
        _neonWrapperKey.currentState!.getNeonLocalizationsDelegates().cast<LocalizationsDelegate<dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    final cupertinoLightTheme = MaterialBasedCupertinoThemeData(materialTheme: widget.lightTheme);
    final cupertinoDarkTheme = MaterialBasedCupertinoThemeData(materialTheme: widget.darkTheme);

    return PlatformProvider(
      initialPlatform: TargetPlatform.iOS,
      builder: (context) => AdaptiveTheme(
        light: widget.lightTheme,
        dark: widget.darkTheme,
        initial: AdaptiveThemeMode.dark,
        builder: (theme, darkTheme) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: theme.scaffoldBackgroundColor,
            statusBarColor: theme.scaffoldBackgroundColor,
            statusBarIconBrightness: theme.brightness == Brightness.light ? Brightness.dark : Brightness.light,
            systemNavigationBarIconBrightness:
                theme.brightness == Brightness.light ? Brightness.dark : Brightness.light,
          ));

          return PlatformTheme(
            themeMode: theme.brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark,
            materialLightTheme: widget.lightTheme,
            materialDarkTheme: widget.darkTheme,
            cupertinoLightTheme: cupertinoLightTheme,
            cupertinoDarkTheme: cupertinoDarkTheme,
            builder: (context) {
              return FirebaseInteractedMessageListener(
                child: PlatformApp.router(
                  restorationScopeId: "app",
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
