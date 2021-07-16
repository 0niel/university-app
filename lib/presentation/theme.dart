import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';

final lightTextTheme = ThemeData.light().textTheme.copyWith(
      headline6:
          ThemeData.light().textTheme.headline6?.copyWith(color: Colors.white),
    );

final lightTheme = ThemeData.light().copyWith(
  primaryColorDark: LightThemeColors.primary801,
  primaryColor: LightThemeColors.primary601,
  primaryColorLight: LightThemeColors.primary501,
  textTheme: lightTextTheme,
  appBarTheme: ThemeData.light().appBarTheme.copyWith(
        centerTitle: false,
        iconTheme: IconThemeData(color: LightThemeColors.white),
      ),
);

// todo: сделать тёмную тему
final darkTheme = lightTheme;
