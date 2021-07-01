import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/screens/home/home_screen.dart';
import 'package:rtu_mirea_app/screens/onBoard/screenBoard.dart';
import 'package:rtu_mirea_app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

int initScreen;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen ${initScreen}');
  runApp(App());
}

class App extends StatelessWidget {
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
        initialRoute: initScreen == 0 || initScreen == null ? "first" : "/",
        routes: {
          '/': (context) => HomeScreen(),
          "first": (context) => OnboardingScreen(),
        },
        // виджет с нижней навигацией
      ),
    );
  }
}
