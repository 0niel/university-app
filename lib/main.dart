import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/common/constants.dart';
import 'package:rtu_mirea_app/presentation/bloc/home_navigator_bloc/home_navigator_bloc.dart';
import 'package:rtu_mirea_app/presentation/pages/home/home_navigator_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/onboarding/onboarding_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/schedule/schedule_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/settings/settings_screen.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rtu_mirea_app/service_locator.dart' as dependencyInjection;
import 'service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dependencyInjection.setup();
  var prefs = getIt<SharedPreferences>();
  bool showOnboarding = prefs.getBool(PrefsKeys.onBoardingKey) ?? true;
  runApp(App(showOnboarding));
}

class App extends StatelessWidget {
  late final bool _showOnboarding;

  /// bool переменная [_showOnboarding] определяет, показывать ли
  /// intro (onboarding) экран при запуске приложения
  App(this._showOnboarding);

  @override
  Widget build(BuildContext context) {
    // блокируем ориентацию приложения на
    // только вертикальной
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeNavigatorBloc>(
            create: (context) => getIt<HomeNavigatorBloc>()),
      ],
      child: AdaptiveTheme(
        light: lightTheme,
        dark: darkTheme,
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Приложение РТУ МИРЭА',
          theme: theme,
          darkTheme: darkTheme,
          initialRoute: _showOnboarding
              ? OnBoardingScreen.routeName
              : HomeNavigatorScreen.routeName,
          routes: {
            '/': (context) => HomeNavigatorScreen(),
            ScheduleScreen.routeName: (context) => ScheduleScreen(),
            SettingsScreen.routeName: (context) => SettingsScreen(),
            OnBoardingScreen.routeName: (context) => OnBoardingScreen()
          },
        ),
      ),
    );
  }
}
