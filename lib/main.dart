import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/routes.dart';
import 'package:rtu_mirea_app/screens/schedule/schedule_screen.dart';
import 'constants.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Приложение РТУ МИРЭА',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        accentColor: kPrimaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: ScheduleScreen.routeName,
      routes: routes,
    );
  }
}
