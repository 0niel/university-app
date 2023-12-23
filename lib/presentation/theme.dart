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
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      titleSpacing: 24,
      backgroundColor: darkThemeColors.background01,
      shadowColor: Colors.transparent,
      titleTextStyle:
          AppTextStyle.title.copyWith(color: darkThemeColors.active),
      iconTheme: IconThemeData(color: blackThemeColors.active),
    ),
    cardTheme: CardTheme(
      color: darkThemeColors.background01,
      elevation: 4,
      shadowColor: darkThemeColors.background02.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    bottomNavigationBarTheme:
        ThemeData.dark().bottomNavigationBarTheme.copyWith(
              type: BottomNavigationBarType.shifting,
              backgroundColor: darkThemeColors.background01,
              selectedItemColor: darkThemeColors.active,
              unselectedItemColor: darkThemeColors.deactive,
              selectedLabelStyle: AppTextStyle.captionL,
              unselectedLabelStyle: AppTextStyle.captionS,
            ),
    listTileTheme: ListTileThemeData(
      tileColor: darkThemeColors.background01,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: darkThemeColors.background02,
      thickness: 0.5,
      space: 0,
    ),
    colorScheme: ColorScheme(
      background: darkThemeColors.background01,
      brightness: Brightness.dark,
      primary: darkThemeColors.primary,
      secondary: darkThemeColors.background02,
      surface: darkThemeColors.background01,
      onBackground: darkThemeColors.active,
      onSurface: darkThemeColors.active,
      onError: darkThemeColors.active,
      onPrimary: lightThemeColors.white,
      onSecondary: darkThemeColors.active,
      error: darkThemeColors.colorful07,
      surfaceTint: Colors.transparent,
    ),
  );

  static final lightTheme = ThemeData.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(
          bodyColor: lightThemeColors.active,
          displayColor: lightThemeColors.active,
        ),
    scaffoldBackgroundColor: lightThemeColors.background01,
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
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
    listTileTheme: ListTileThemeData(
      tileColor: lightThemeColors.background01,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: lightThemeColors.background02,
      thickness: 0.5,
      space: 0,
    ),
    cardTheme: CardTheme(
      color: lightThemeColors.background01,
      elevation: 4,
      shadowColor: lightThemeColors.background02.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    colorScheme: ColorScheme(
      background: lightThemeColors.background01,
      brightness: Brightness.light,
      primary: lightThemeColors.primary,
      secondary: lightThemeColors.background02,
      surface: lightThemeColors.background01,
      onBackground: lightThemeColors.active,
      onSurface: lightThemeColors.active,
      onError: lightThemeColors.active,
      onPrimary: lightThemeColors.white,
      onSecondary: lightThemeColors.active,
      error: lightThemeColors.colorful07,
      surfaceTint: Colors.transparent,
    ),
  );

  static ThemeData getDataByThemeType({AppThemeType? themeType}) {
    themeType ??= defaultThemeType;

    switch (themeType) {
      case AppThemeType.light:
        return lightTheme;
      case AppThemeType.dark:
        return darkTheme;
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
