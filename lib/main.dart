import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';
import 'service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dependency_injection.setup();

  WidgetDataProvider.initData();

  Platform.isAndroid
      ? await Firebase.initializeApp()
      : await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );

  await FirebaseAnalytics.instance.logAppOpen();

  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);

    // Clear local dota
    // var prefs = getIt<SharedPreferences>();
    // await prefs.clear();
  }

  setPathUrlStrategy();

  findSystemLocale().then((_) => runApp(const App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // blocking the orientation of the application to
    // vertical only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    // deleting the system status bar color
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    final _appRouter = AppRouter();

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
      child: AdaptiveTheme(
        light: lightTheme,
        dark: darkTheme,
        initial: AdaptiveThemeMode.dark,
        builder: (theme, darkTheme) => MaterialApp.router(
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
          theme: theme,
          routerDelegate: _appRouter.delegate(
            navigatorObservers: () => [
              FirebaseAnalyticsObserver(
                analytics: FirebaseAnalytics.instance,
              ),
            ],
          ),
          routeInformationProvider: _appRouter.routeInfoProvider(),
          routeInformationParser: _appRouter.defaultRouteParser(),
        ),
      ),
    );
  }
}
