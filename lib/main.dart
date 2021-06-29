import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/screens/home/home_screen.dart';
import 'package:rtu_mirea_app/theme.dart';

void main() {
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
        home: HomeScreen(), // виджет с нижней навигацией
      ),
    );
  }
}
