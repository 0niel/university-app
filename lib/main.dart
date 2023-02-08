
import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/common/oauth.dart';
import 'package:rtu_mirea_app/common/widget_data_init.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rtu_mirea_app/presentation/bloc/about_app_bloc/about_app_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/announces_bloc/announces_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/app_cubit/app_cubit.dart';
import 'package:rtu_mirea_app/presentation/bloc/attendance_bloc/attendance_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/employee_bloc/employee_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/map_cubit/map_cubit.dart';
import 'package:rtu_mirea_app/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/schedule_bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/scores_bloc/scores_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/stories_bloc/stories_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/update_info_bloc/update_info_bloc.dart';
import 'package:rtu_mirea_app/presentation/core/routes/routes.gr.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:intl/intl_standalone.dart';
import 'package:rtu_mirea_app/service_locator.dart' as dependency_injection;
import 'package:url_strategy/url_strategy.dart';
import 'presentation/app_notifier.dart';
import 'package:intl/intl_browser.dart' as intl_browser;
import 'service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dependency_injection.setup();

  WidgetDataProvider.initData();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Crashlytics instance must be initialized only on non-web platforms. On web
  // platforms, it is throw an exception.
  if (!kIsWeb) {
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }
  }

  await FirebaseAnalytics.instance.logAppOpen();

  if (kDebugMode) {
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
    await intl_browser
        .findSystemLocale()
        .then((value) => Intl.systemLocale = value);
  } else {
    Intl.systemLocale = await findSystemLocale();
  }

  runApp(ChangeNotifierProvider<AppNotifier>(
    create: (context) => getIt<AppNotifier>(),
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  static final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    // blocking the orientation of the application to
    // vertical only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    return MultiBlocProvider(
      providers: [
        BlocProvider<ScheduleBloc>(
            create: (context) =>
                getIt<ScheduleBloc>()..add(ScheduleOpenEvent())),
        BlocProvider<MapCubit>(create: (context) => getIt<MapCubit>()),
        BlocProvider<NewsBloc>(create: (context) => getIt<NewsBloc>()),
        BlocProvider<AboutAppBloc>(
            create: (context) =>
                getIt<AboutAppBloc>()..add(AboutAppGetMembers())),
        BlocProvider<AuthBloc>(
            create: (context) => getIt<AuthBloc>()..add(AuthLogInFromCache())),
        BlocProvider<ProfileBloc>(create: (context) => getIt<ProfileBloc>()),
        BlocProvider<AnnouncesBloc>(
            create: (context) => getIt<AnnouncesBloc>()),
        BlocProvider<EmployeeBloc>(create: (context) => getIt<EmployeeBloc>()),
        BlocProvider<ScoresBloc>(create: (context) => getIt<ScoresBloc>()),
        BlocProvider<AttendanceBloc>(
            create: (context) => getIt<AttendanceBloc>()),
        BlocProvider<StoriesBloc>(create: (context) => getIt<StoriesBloc>()),
        BlocProvider<AppCubit>(create: (context) => getIt<AppCubit>()),
        BlocProvider<UpdateInfoBloc>(
          create: (_) => getIt<UpdateInfoBloc>(),
          lazy: false, // We need to init it as soon as possible
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
            routerDelegate: appRouter.delegate(
              navigatorObservers: () => [
                FirebaseAnalyticsObserver(
                  analytics: FirebaseAnalytics.instance,
                ),
                AutoRouteObserver(),
              ],
            ),
            routeInformationProvider: appRouter.routeInfoProvider(),
            routeInformationParser: appRouter.defaultRouteParser(),
            themeMode: AppTheme.themeMode,
            theme: AppTheme.theme,
            darkTheme: AppTheme.darkTheme,
          );
        },
      ),
    );
  }
}
