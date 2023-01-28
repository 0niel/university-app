import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

enum AppThemeType { light, dark, black }

/// [AppTheme] is a class that contains all the theme data for the app.
///
/// Every time the theme is changed, the [AppTheme.theme] is updated.
/// The [AppTheme.theme] is used to get the current theme data.
/// To change the theme, use [AppTheme.changeThemeType] method and pass the new
/// theme type ([AppThemeType]) as an argument.
class AppTheme {
  static ThemeColors darkThemeColors = ThemeColors();
  static ThemeColors lightThemeColors = LightThemeColors();
  static ThemeColors blackThemeColors = AmoledDarkThemeColors();

  static AppThemeType defaultThemeType = AppThemeType.dark;
  static ThemeMode defaultThemeMode = ThemeMode.dark;

  static ThemeData theme = AppTheme.getDataByThemeType();

  static final darkTheme = ThemeData.dark().copyWith(
    textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: darkThemeColors.active,
          displayColor: darkThemeColors.active,
        ),
    scaffoldBackgroundColor: darkThemeColors.background01,
    backgroundColor: darkThemeColors.background01,
    appBarTheme: AppBarTheme(
      titleSpacing: 24,
      backgroundColor: darkThemeColors.background01,
      shadowColor: Colors.transparent,
      titleTextStyle:
          AppTextStyle.title.copyWith(color: darkThemeColors.active),
      iconTheme: IconThemeData(color: blackThemeColors.active),
    ),
    bottomNavigationBarTheme:
        ThemeData.dark().bottomNavigationBarTheme.copyWith(
              type: BottomNavigationBarType.shifting,
              backgroundColor: darkThemeColors.background03,
              selectedItemColor: darkThemeColors.active,
              unselectedItemColor: darkThemeColors.deactive,
              selectedLabelStyle: AppTextStyle.captionL,
              unselectedLabelStyle: AppTextStyle.captionS,
            ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: NoShadowCupertinoPageTransitionsBuilder(),
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    }),
  );

  static final lightTheme = ThemeData.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(
          bodyColor: lightThemeColors.active,
          displayColor: lightThemeColors.active,
        ),
    scaffoldBackgroundColor: lightThemeColors.background01,
    backgroundColor: lightThemeColors.background01,
    appBarTheme: AppBarTheme(
      titleSpacing: 24,
      backgroundColor: lightThemeColors.background01,
      shadowColor: Colors.transparent,
      titleTextStyle:
          AppTextStyle.title.copyWith(color: lightThemeColors.active),
      iconTheme: IconThemeData(color: lightThemeColors.active),
    ),
    bottomNavigationBarTheme:
        ThemeData.light().bottomNavigationBarTheme.copyWith(
              type: BottomNavigationBarType.shifting,
              backgroundColor: lightThemeColors.background03,
              selectedItemColor: lightThemeColors.active,
              unselectedItemColor: lightThemeColors.deactive,
              selectedLabelStyle: AppTextStyle.captionL,
              unselectedLabelStyle: AppTextStyle.captionS,
            ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: NoShadowCupertinoPageTransitionsBuilder(),
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    }),
  );

  static final blackTheme = ThemeData.dark().copyWith(
    textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: blackThemeColors.active,
          displayColor: blackThemeColors.active,
        ),
    scaffoldBackgroundColor: blackThemeColors.background01,
    backgroundColor: blackThemeColors.background01,
    appBarTheme: AppBarTheme(
      titleSpacing: 24,
      backgroundColor: blackThemeColors.background01,
      shadowColor: Colors.transparent,
      titleTextStyle: AppTextStyle.title,
      iconTheme: IconThemeData(color: blackThemeColors.active),
    ),
    bottomNavigationBarTheme:
        ThemeData.dark().bottomNavigationBarTheme.copyWith(
              type: BottomNavigationBarType.shifting,
              backgroundColor: blackThemeColors.background03,
              selectedItemColor: blackThemeColors.active,
              unselectedItemColor: blackThemeColors.deactive,
              selectedLabelStyle: AppTextStyle.captionL,
              unselectedLabelStyle: AppTextStyle.captionS,
            ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: NoShadowCupertinoPageTransitionsBuilder(),
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    }),
  );

  static ThemeData getDataByThemeType({AppThemeType? themeType}) {
    themeType ??= defaultThemeType;

    switch (themeType) {
      case AppThemeType.light:
        return lightTheme;
      case AppThemeType.black:
        return blackTheme;
      default:
        return darkTheme;
    }
  }

  static ThemeMode getThemeModeByType({AppThemeType? themeType}) {
    themeType ??= defaultThemeType;

    switch (themeType) {
      case AppThemeType.light:
        return ThemeMode.light;
      case AppThemeType.black:
        return ThemeMode.dark;
      default:
        return ThemeMode.dark;
    }
  }

  static void changeThemeType(AppThemeType? themeType) {
    defaultThemeType = themeType ?? AppThemeType.light;
    defaultThemeMode = getThemeModeByType(themeType: defaultThemeType);
    theme = AppTheme.getDataByThemeType();

    // deleting the system status bar color and updating navigation bar color
    // overlay
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppTheme.colors.background01));
  }

  static ThemeColors getColorsByMode({AppThemeType? themeType}) {
    themeType ??= defaultThemeType;

    switch (themeType) {
      case AppThemeType.light:
        return LightThemeColors();
      case AppThemeType.black:
        return AmoledDarkThemeColors();
      default:
        return ThemeColors();
    }
  }

  /// Returns the current theme data. If the theme is changed, the data will be
  /// updated.
  static ThemeMode get themeMode => getThemeModeByType();

  /// Returns the current theme colors. If the theme is changed, the colors
  /// will be updated.
  static ThemeColors get colors => getColorsByMode();
}
