import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/screens/schedule/schedule_screen.dart';
import 'package:rtu_mirea_app/screens/settings/settings_screen.dart';

final Map<String, WidgetBuilder> routes = {
  ScheduleScreen.routeName: (context) => ScheduleScreen(),
  SettingsScreen.routeName: (context) => SettingsScreen(),
};
