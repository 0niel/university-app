import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/constants.dart';

final lightTheme = ThemeData.light().copyWith(
  primaryColorDark: LightThemeColors.primary801,
  primaryColor: LightThemeColors.primary601,
  primaryColorLight: LightThemeColors.primary501,
  appBarTheme: ThemeData.light().appBarTheme.copyWith(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        titleTextStyle: ThemeData.light().textTheme.headline6,
      ),
);

// todo: сделать тёмную тему
final darkTheme = lightTheme;
