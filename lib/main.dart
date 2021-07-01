import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/screens/home/home_screen.dart';
import 'package:rtu_mirea_app/screens/onboarding/onboarding_screen.dart';
import 'package:rtu_mirea_app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('is_first_time') ?? false;
  await prefs.setBool("is_first_time", true);
  runApp(App(isFirstTime));
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

    return AdaptiveTheme(
      light: lightTheme,
      dark: darkTheme,
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Приложение РТУ МИРЭА',
        theme: theme,
        darkTheme: darkTheme,
        home: _showOnboarding ? OnboardingScreen() : HomeScreen(),
      ),
    );
  }
}
