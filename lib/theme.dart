import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/constants.dart';

final lightTextTheme = ThemeData.light().textTheme.copyWith(
      headline1:
          ThemeData.light().textTheme.headline1.copyWith(fontFamily: 'Oswald'),
      headline2:
          ThemeData.light().textTheme.headline2.copyWith(fontFamily: 'Oswald'),
      headline3:
          ThemeData.light().textTheme.headline3.copyWith(fontFamily: 'Oswald'),
      headline4:
          ThemeData.light().textTheme.headline4.copyWith(fontFamily: 'Oswald'),
      headline5:
          ThemeData.light().textTheme.headline5.copyWith(fontFamily: 'Oswald'),
      headline6: ThemeData.light().textTheme.headline6.copyWith(
            fontFamily: 'Oswald',
            color: LightThemeColors.grey800,
            fontSize: 32,
          ),
      bodyText1:
          ThemeData.light().textTheme.bodyText1.copyWith(fontFamily: 'Roboto'),
      bodyText2:
          ThemeData.light().textTheme.bodyText2.copyWith(fontFamily: 'Roboto'),
    );

final lightTheme = ThemeData.light().copyWith(
  backgroundColor: LightThemeColors.white,
  primaryColorDark: LightThemeColors.primary801,
  primaryColor: LightThemeColors.primary601,
  primaryColorLight: LightThemeColors.primary501,
  textTheme: lightTextTheme,
  appBarTheme: ThemeData.light().appBarTheme.copyWith(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        titleTextStyle: lightTextTheme.headline6,
        centerTitle: false,
      ),
);

// todo: сделать тёмную тему
final darkTheme = lightTheme;
