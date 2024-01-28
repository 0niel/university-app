import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
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
  static ThemeColors colors = ThemeColors();
  static ThemeColors darkThemeColors = ThemeColors();
  static ThemeColors lightThemeColors = LightThemeColors();
  static ThemeColors blackThemeColors = AmoledDarkThemeColors();

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
      titleTextStyle: AppTextStyle.title.copyWith(color: darkThemeColors.active),
      iconTheme: IconThemeData(color: blackThemeColors.active),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: darkThemeColors.background02,
      disabledColor: darkThemeColors.background02,
      selectedColor: darkThemeColors.background02,
      secondarySelectedColor: darkThemeColors.background02,
      padding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      labelStyle: AppTextStyle.chip.copyWith(color: darkThemeColors.active),
      secondaryLabelStyle: AppTextStyle.chip.copyWith(color: darkThemeColors.active),
      brightness: Brightness.dark,
    ),
    cardTheme: CardTheme(
      color: darkThemeColors.background03,
      elevation: 4,
      shadowColor: darkThemeColors.background02.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    bottomNavigationBarTheme: ThemeData.dark().bottomNavigationBarTheme.copyWith(
          type: BottomNavigationBarType.shifting,
          backgroundColor: darkThemeColors.background01,
          selectedItemColor: darkThemeColors.active,
          unselectedItemColor: darkThemeColors.deactive,
          selectedLabelStyle: AppTextStyle.captionL,
          unselectedLabelStyle: AppTextStyle.captionS,
        ),
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leadingAndTrailingTextStyle: AppTextStyle.chip.copyWith(
        color: AppTheme.colors.active,
      ),
      titleTextStyle: AppTextStyle.chip.copyWith(
        color: AppTheme.colors.deactive,
      ),
      visualDensity: const VisualDensity(vertical: 4),
      subtitleTextStyle: AppTextStyle.titleM.copyWith(
        color: darkThemeColors.active,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: darkThemeColors.background02,
      thickness: 0.5,
      space: 0,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: darkThemeColors.background02,
      contentTextStyle: AppTextStyle.bodyBold.copyWith(
        color: darkThemeColors.active,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.all(16),
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
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 24,
      backgroundColor: lightThemeColors.background01,
      shadowColor: Colors.transparent,
      titleTextStyle: AppTextStyle.title.copyWith(color: lightThemeColors.active),
      iconTheme: IconThemeData(color: lightThemeColors.active),
    ),
    bottomNavigationBarTheme: ThemeData.light().bottomNavigationBarTheme.copyWith(
          type: BottomNavigationBarType.shifting,
          backgroundColor: lightThemeColors.background03,
          selectedItemColor: lightThemeColors.active,
          unselectedItemColor: lightThemeColors.deactive,
          selectedLabelStyle: AppTextStyle.captionL,
          unselectedLabelStyle: AppTextStyle.captionS,
        ),
    chipTheme: ChipThemeData(
      backgroundColor: lightThemeColors.background02,
      disabledColor: lightThemeColors.background02,
      selectedColor: lightThemeColors.background02,
      secondarySelectedColor: lightThemeColors.background02,
      padding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      labelStyle: AppTextStyle.chip.copyWith(color: lightThemeColors.active),
      secondaryLabelStyle: AppTextStyle.chip.copyWith(color: lightThemeColors.active),
      brightness: Brightness.light,
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leadingAndTrailingTextStyle: AppTextStyle.chip.copyWith(
        color: AppTheme.colors.active,
      ),
      titleTextStyle: AppTextStyle.chip.copyWith(
        color: AppTheme.colors.deactive,
      ),
      visualDensity: const VisualDensity(vertical: 4),
      subtitleTextStyle: AppTextStyle.titleM.copyWith(
        color: lightThemeColors.active,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: lightThemeColors.background02,
      contentTextStyle: AppTextStyle.bodyBold.copyWith(
        color: lightThemeColors.active,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.all(16),
    ),
    dividerTheme: DividerThemeData(
      color: lightThemeColors.deactiveDarker.withOpacity(0.25),
      thickness: 0.5,
      space: 0,
    ),
    cardTheme: CardTheme(
      color: lightThemeColors.background02,
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

  static ThemeColors colorsOf(BuildContext context) {
    final theme = AdaptiveTheme.of(context).mode;

    switch (theme) {
      case AdaptiveThemeMode.dark:
        return darkThemeColors;
      case AdaptiveThemeMode.light:
        return lightThemeColors;

      case AdaptiveThemeMode.system:
        if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
          return darkThemeColors;
        } else {
          return lightThemeColors;
        }
    }
  }
}
