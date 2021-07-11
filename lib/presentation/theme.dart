import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';

final lightTextTheme = ThemeData.light().textTheme.copyWith(
      headline1: ThemeData.light()
          .textTheme
          .headline1
          ?.copyWith(fontFamily: 'Montserrat', color: LightThemeColors.grey800),
      headline2: ThemeData.light()
          .textTheme
          .headline2
          ?.copyWith(fontFamily: 'Montserrat', color: LightThemeColors.grey800),
      headline3: ThemeData.light()
          .textTheme
          .headline3
          ?.copyWith(fontFamily: 'Montserrat', color: LightThemeColors.grey800),
      headline4: ThemeData.light()
          .textTheme
          .headline4
          ?.copyWith(fontFamily: 'Montserrat', color: LightThemeColors.grey800),
      headline5: ThemeData.light()
          .textTheme
          .headline5
          ?.copyWith(fontFamily: 'Montserrat', color: LightThemeColors.grey800),
      headline6: ThemeData.light().textTheme.headline6?.copyWith(
            fontFamily: 'Oswald',
            color: LightThemeColors.grey800,
            fontSize: 32,
          ),
      bodyText1: ThemeData.light()
          .textTheme
          .bodyText1
          ?.copyWith(fontFamily: 'Montserrat', color: LightThemeColors.grey800),
      bodyText2: ThemeData.light()
          .textTheme
          .bodyText2
          ?.copyWith(fontFamily: 'Montserrat', color: LightThemeColors.grey800),
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
        iconTheme: IconThemeData(color: LightThemeColors.grey800),
      ),
);

// todo: сделать тёмную тему
final darkTheme = lightTheme;
