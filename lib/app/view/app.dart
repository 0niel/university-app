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
import 'package:rtu_mirea_app/neon/neon.dart';
import 'package:rtu_mirea_app/schedule_management/bloc/schedule_exporter_cubit.dart';
import 'package:rtu_mirea_app/service_locator.dart';
import 'package:schedule_exporter_repository/schedule_exporter_repository.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:flutter/services.dart';
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
import 'package:neon_framework/l10n/localizations.dart' as neon_localizations;

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
    required NeonDependencies neonDependencies,
    required super.key,
  })  : _analyticsRepository = analyticsRepository,
        _scheduleRepository = scheduleRepository,
        _communityRepository = communityRepository,
        _storiesRepository = storiesRepository,
        _discourseRepository = discourseRepository,
        _newsRepository = newsRepository,
        _notificationsRepository = notificationsRepository,
        _scheduleExporterRepository = scheduleExporterRepository,
        _neonDependencies = neonDependencies;

  final AnalyticsRepository _analyticsRepository;
  final ScheduleRepository _scheduleRepository;
  final CommunityRepository _communityRepository;
  final StoriesRepositoryImpl _storiesRepository;
  final DiscourseRepository _discourseRepository;
  final NewsRepository _newsRepository;
  final NotificationsRepository _notificationsRepository;
  final ScheduleExporterRepository _scheduleExporterRepository;
  final NeonDependencies _neonDependencies;

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
        child: _MaterialApp(
          neonDependencies: _neonDependencies,
        ),
      ),
    );
  }
}

class _MaterialApp extends StatefulWidget {
  const _MaterialApp({
    required this.neonDependencies,
  });

  final NeonDependencies neonDependencies;

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
    neonLocalizationsDelegates = getNeonLocalizationsDelegates().cast<LocalizationsDelegate<dynamic>>();
  }

  List<LocalizationsDelegate<dynamic>> getNeonLocalizationsDelegates() {
    return [
      ...widget.neonDependencies.appImplementations.map((app) => app.localizationsDelegate),
      ...neon_localizations.NeonLocalizations.localizationsDelegates,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final neonTheme = widget.neonDependencies.neonTheme;
    final cupertinoLightTheme =
        MaterialBasedCupertinoThemeData(materialTheme: AppTheme.lightTheme.copyWith(extensions: [neonTheme]));

    final cupertinoDarkTheme = MaterialBasedCupertinoThemeData(
        materialTheme: AppTheme.darkTheme.copyWith(
      extensions: [neonTheme],
    ));

    final lightTheme = AppTheme.lightTheme.copyWith(extensions: [neonTheme]);
    final darkTheme = AppTheme.darkTheme.copyWith(extensions: [neonTheme]);

    return PlatformProvider(
      initialPlatform: TargetPlatform.iOS,
      builder: (context) => AdaptiveTheme(
        light: lightTheme,
        dark: darkTheme,
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
            materialLightTheme: lightTheme,
            materialDarkTheme: darkTheme,
            cupertinoLightTheme: cupertinoLightTheme,
            cupertinoDarkTheme: cupertinoDarkTheme,
            builder: (context) {
              return FirebaseInteractedMessageListener(
                child: NeonAppProvider(
                  neonDependencies: widget.neonDependencies,
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
