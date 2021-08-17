import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/home_navigator_bloc/home_navigator_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/map_cubit/map_cubit.dart';
import 'package:rtu_mirea_app/presentation/bloc/onboarding_cubit/onboarding_cubit.dart';
import 'package:rtu_mirea_app/presentation/bloc/schedule_bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/presentation/pages/home/home_navigator_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/map/map_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/onboarding/onboarding_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/schedule/schedule_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/profile_screen.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rtu_mirea_app/service_locator.dart' as dependencyInjection;
import 'service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dependencyInjection.setup();
  var prefs = getIt<SharedPreferences>();
  const String onboardingKey = 'show_onboarding';
  bool showOnboarding = prefs.getBool(onboardingKey) ?? true;
  if (showOnboarding) prefs.setBool(onboardingKey, false);

  // to debug:
  //await prefs.clear();

  initializeDateFormatting();
  runApp(App(showOnboarding: showOnboarding));
}

class App extends StatelessWidget {
  final bool showOnboarding;

  /// if [showOnboarding] is true, when start the application,
  /// the intro screen will be displayed
  App({required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    // blocking the orientation of the application to
    // vertical only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    // deleting the system status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return MultiBlocProvider(
      providers: [
        BlocProvider<ScheduleBloc>(create: (context) => getIt<ScheduleBloc>()),
        BlocProvider<HomeNavigatorBloc>(
            create: (context) => getIt<HomeNavigatorBloc>()),
        BlocProvider<OnboardingCubit>(
            create: (context) => getIt<OnboardingCubit>()),
        BlocProvider<MapCubit>(create: (context) => getIt<MapCubit>()),
      ],
      child: AdaptiveTheme(
        light: lightTheme,
        dark: darkTheme,
        initial: AdaptiveThemeMode.dark,
        builder: (theme, darkTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Приложение РТУ МИРЭА',
          theme: theme,
          initialRoute: showOnboarding
              ? OnBoardingScreen.routeName
              : HomeNavigatorScreen.routeName,
          routes: {
            '/': (context) =>
                showOnboarding ? OnBoardingScreen() : HomeNavigatorScreen(),
            ScheduleScreen.routeName: (context) => ScheduleScreen(),
            MapScreen.routeName: (context) => MapScreen(),
            ProfileScreen.routeName: (context) => ProfileScreen(),
            OnBoardingScreen.routeName: (context) => OnBoardingScreen()
          },
        ),
      ),
    );
  }
}
