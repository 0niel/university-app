import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/theme/theme.dart';
import 'package:flutter/material.dart';

enum AppThemeType { light, dark, black }

/// [AppTheme] is a class that contains all the theme data for the app.
///
/// Every time the theme is changed, the [AppTheme.theme] is updated.
/// The [AppTheme.theme] is used to get the current theme data.
/// To change the theme, use [AppTheme.changeThemeType] method and pass the new
/// theme type ([AppThemeType]) as an argument.
class AppTheme {
  static final darkTheme = ThemeData.dark().copyWith(
    extensions: <ThemeExtension<dynamic>>[AppColors.dark],
    textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: AppColors.dark.active,
          displayColor: AppColors.dark.active,
        ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
          AppTextStyle.buttonS.copyWith(color: AppColors.dark.active),
        ),
      ),
    ),
    scaffoldBackgroundColor: AppColors.dark.background01,
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      titleSpacing: 24,
      backgroundColor: AppColors.dark.background01,
      shadowColor: Colors.transparent,
      titleTextStyle: AppTextStyle.title.copyWith(color: AppColors.dark.active),
      iconTheme: IconThemeData(color: AppColors.dark.active),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.dark.background02,
      disabledColor: AppColors.dark.background02,
      selectedColor: AppColors.dark.background02,
      secondarySelectedColor: AppColors.dark.background02,
      padding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      labelStyle: AppTextStyle.chip.copyWith(color: AppColors.dark.active),
      secondaryLabelStyle: AppTextStyle.chip.copyWith(color: AppColors.dark.active),
      brightness: Brightness.dark,
    ),
    cardTheme: CardTheme(
      color: AppColors.dark.background03,
      elevation: 4,
      shadowColor: AppColors.dark.background02.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    bottomNavigationBarTheme: ThemeData.dark().bottomNavigationBarTheme.copyWith(
          type: BottomNavigationBarType.shifting,
          backgroundColor: AppColors.dark.background01,
          selectedItemColor: AppColors.dark.active,
          unselectedItemColor: AppColors.dark.deactive,
          selectedLabelStyle: AppTextStyle.captionL,
          unselectedLabelStyle: AppTextStyle.captionS,
        ),
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leadingAndTrailingTextStyle: AppTextStyle.chip.copyWith(
        color: AppColors.dark.active,
      ),
      titleTextStyle: AppTextStyle.chip.copyWith(
        color: AppColors.dark.deactive,
      ),
      visualDensity: const VisualDensity(vertical: 4),
      subtitleTextStyle: AppTextStyle.titleM.copyWith(
        color: AppColors.dark.active,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.dark.divider,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.dark.background02,
      contentTextStyle: AppTextStyle.bodyBold.copyWith(
        color: AppColors.dark.active,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.all(16),
      elevation: 2,
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.dark.primary,
      secondary: AppColors.dark.background02,
      surface: AppColors.dark.background01,
      onSurface: AppColors.dark.active,
      onError: AppColors.dark.active,
      onPrimary: AppColors.light.white,
      onSecondary: AppColors.dark.active,
      error: AppColors.dark.colorful07,
      surfaceTint: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColors.dark.white),
        backgroundColor: WidgetStateProperty.all(AppColors.dark.primary),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        textStyle: WidgetStateProperty.all(
          AppTextStyle.buttonS.copyWith(
            color: AppColors.dark.white,
          ),
        ),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.dark.background02,
      textStyle: AppTextStyle.body.copyWith(
        color: AppColors.dark.active,
      ),
      elevation: 4,
      shadowColor: AppColors.dark.background02.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.dark.primary;
          }
          return AppColors.dark.primary.withOpacity(0.5);
        },
      ),
      trackColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.dark.primary.withOpacity(0.5);
          }
          return AppColors.dark.background01;
        },
      ),
      trackOutlineColor: WidgetStateProperty.all(AppColors.dark.background01),
      trackOutlineWidth: WidgetStateProperty.all(2),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.dark.primary;
          }
          return AppColors.dark.background01;
        },
      ),
      checkColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.dark.white;
          }
          return AppColors.dark.background01;
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      side: BorderSide(
        color: AppColors.dark.primary,
        width: 2,
      ),
    ),
  );

  static final lightTheme = ThemeData.light().copyWith(
    extensions: <ThemeExtension<dynamic>>[AppColors.light],
    textTheme: ThemeData.light().textTheme.apply(
          bodyColor: AppColors.light.active,
          displayColor: AppColors.light.active,
        ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
          AppTextStyle.buttonS.copyWith(color: AppColors.light.active),
        ),
      ),
    ),
    scaffoldBackgroundColor: AppColors.light.background01,
    appBarTheme: AppBarTheme(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 24,
      backgroundColor: AppColors.light.background01,
      shadowColor: Colors.transparent,
      titleTextStyle: AppTextStyle.title.copyWith(color: AppColors.light.active),
      iconTheme: IconThemeData(color: AppColors.light.active),
    ),
    bottomNavigationBarTheme: ThemeData.light().bottomNavigationBarTheme.copyWith(
          type: BottomNavigationBarType.shifting,
          backgroundColor: AppColors.light.background03,
          selectedItemColor: AppColors.light.active,
          unselectedItemColor: AppColors.light.deactive,
          selectedLabelStyle: AppTextStyle.captionL,
          unselectedLabelStyle: AppTextStyle.captionS,
        ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.light.background02,
      disabledColor: AppColors.light.background02,
      selectedColor: AppColors.light.background02,
      secondarySelectedColor: AppColors.light.background02,
      padding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      labelStyle: AppTextStyle.chip.copyWith(color: AppColors.light.active),
      secondaryLabelStyle: AppTextStyle.chip.copyWith(color: AppColors.light.active),
      brightness: Brightness.light,
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leadingAndTrailingTextStyle: AppTextStyle.chip.copyWith(
        color: AppColors.light.active,
      ),
      titleTextStyle: AppTextStyle.chip.copyWith(
        color: AppColors.light.deactive,
      ),
      visualDensity: const VisualDensity(vertical: 4),
      subtitleTextStyle: AppTextStyle.titleM.copyWith(
        color: AppColors.light.active,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.light.background02,
      contentTextStyle: AppTextStyle.bodyBold.copyWith(
        color: AppColors.light.active,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.all(16),
      elevation: 2,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.light.divider,
    ),
    cardTheme: CardTheme(
      color: AppColors.light.background02,
      elevation: 4,
      shadowColor: AppColors.light.background02.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.light.primary,
      secondary: AppColors.light.background02,
      surface: AppColors.light.background01,
      onSurface: AppColors.light.active,
      onError: AppColors.light.active,
      onPrimary: AppColors.light.white,
      onSecondary: AppColors.light.active,
      error: AppColors.light.colorful07,
      surfaceTint: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColors.light.white),
        backgroundColor: WidgetStateProperty.all(AppColors.light.primary),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        textStyle: WidgetStateProperty.all(
          AppTextStyle.buttonS.copyWith(
            color: AppColors.light.white,
          ),
        ),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.light.background02,
      textStyle: AppTextStyle.body.copyWith(
        color: AppColors.light.active,
      ),
      elevation: 4,
      shadowColor: AppColors.light.background02.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.light.primary;
          }
          return AppColors.light.primary.withOpacity(0.5);
        },
      ),
      trackColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.light.primary.withOpacity(0.5);
          }
          return AppColors.light.background01;
        },
      ),
      trackOutlineColor: WidgetStateProperty.all(AppColors.light.background01),
      trackOutlineWidth: WidgetStateProperty.all(2),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.light.primary;
          }
          return AppColors.light.background01;
        },
      ),
      checkColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.light.white;
          }
          return AppColors.light.background01;
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      // custom padding:
      side: BorderSide(
        color: AppColors.light.primary,
        width: 2,
      ),
    ),
  );
}
