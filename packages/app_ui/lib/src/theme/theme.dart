import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

enum AppThemeType { light, dark }

/// [AppTheme] is a class that contains all the theme data for the app.
class AppTheme {
  static const _defaultRadius = 16.0;
  static const _cardRadius = 14.0;
  static const _smallRadius = 10.0;
  static const _buttonRadius = 12.0;

  // Common component builders
  static OutlinedBorder defaultCardShape(AppColors colors) => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cardRadius),
      );

  static BoxDecoration glassEffect(AppColors colors) => BoxDecoration(
        color: colors.surfaceHigh.withOpacity(0.7),
        borderRadius: BorderRadius.circular(_defaultRadius),
        border: Border.all(color: colors.borderLight, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
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
          AppTextStyle.buttonS.copyWith(color: AppColors.light.accent),
        ),
        overlayColor: WidgetStateProperty.all(AppColors.light.accent.withOpacity(0.08)),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
      titleTextStyle: AppTextStyle.title.copyWith(
        color: AppColors.light.active,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: AppColors.light.active),
      centerTitle: false,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.light.surfaceHigh,
      disabledColor: AppColors.light.surfaceLow,
      selectedColor: AppColors.light.accent.withOpacity(0.15),
      secondarySelectedColor: AppColors.light.surfaceHigh,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_smallRadius)),
      labelStyle: AppTextStyle.body.copyWith(color: AppColors.light.active),
      secondaryLabelStyle: AppTextStyle.body.copyWith(color: AppColors.light.active),
      brightness: Brightness.light,
      side: BorderSide(color: AppColors.light.borderLight, width: 0.5),
    ),
    cardTheme: CardTheme(
      color: AppColors.light.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: defaultCardShape(AppColors.light),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.light.surfaceHigh,
      selectedItemColor: AppColors.light.primary,
      unselectedItemColor: AppColors.light.deactive,
      selectedLabelStyle: AppTextStyle.captionL.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: AppTextStyle.captionS,
      elevation: 0,
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leadingAndTrailingTextStyle: AppTextStyle.chip.copyWith(color: AppColors.light.active),
      titleTextStyle: AppTextStyle.body.copyWith(color: AppColors.light.active),
      subtitleTextStyle: AppTextStyle.captionL.copyWith(color: AppColors.light.deactive),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_smallRadius)),
      minLeadingWidth: 24,
      visualDensity: const VisualDensity(vertical: -1),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.light.divider,
      thickness: 0.5,
      space: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.light.surfaceHigh,
      contentTextStyle: AppTextStyle.bodyBold.copyWith(color: AppColors.light.active),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_defaultRadius)),
      insetPadding: const EdgeInsets.all(16),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      actionTextColor: AppColors.light.accent,
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.light.primary,
      secondary: AppColors.light.secondary,
      surface: AppColors.light.surface,
      error: AppColors.light.error,
      onPrimary: AppColors.light.white,
      onSecondary: AppColors.light.white,
      onSurface: AppColors.light.onSurface,
      onError: AppColors.light.white,
      surfaceTint: Colors.transparent,
      tertiary: AppColors.light.accent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColors.light.white),
        backgroundColor: WidgetStateProperty.all(AppColors.light.primary),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(_buttonRadius)),
        ),
        textStyle: WidgetStateProperty.all(
          AppTextStyle.buttonS.copyWith(
            color: AppColors.light.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
        overlayColor: WidgetStateProperty.all(AppColors.light.white.withOpacity(0.1)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: AppColors.light.background03),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.light.surfaceHigh,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_smallRadius),
        borderSide: BorderSide(color: AppColors.light.borderLight, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_smallRadius),
        borderSide: BorderSide(color: AppColors.light.borderLight, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_smallRadius),
        borderSide: BorderSide(color: AppColors.light.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_smallRadius),
        borderSide: BorderSide(color: AppColors.light.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_smallRadius),
        borderSide: BorderSide(color: AppColors.light.error, width: 1.5),
      ),
      hintStyle: AppTextStyle.body.copyWith(color: AppColors.light.deactive),
      errorStyle: AppTextStyle.captionL.copyWith(color: AppColors.light.error),
      prefixIconColor: AppColors.light.deactive,
      suffixIconColor: AppColors.light.deactive,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.light.surfaceHigh,
      textStyle: AppTextStyle.body.copyWith(color: AppColors.light.active),
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_smallRadius),
        side: BorderSide(color: AppColors.light.borderLight, width: 0.5),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>(
        (states) =>
            states.contains(WidgetState.selected) ? AppColors.light.primary : AppColors.light.deactive.withOpacity(0.5),
      ),
      trackColor: WidgetStateProperty.resolveWith<Color>(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.light.primary.withOpacity(0.3)
            : AppColors.light.surfaceHigh,
      ),
      trackOutlineColor: WidgetStateProperty.resolveWith<Color>(
        (states) => states.contains(WidgetState.selected) ? Colors.transparent : AppColors.light.borderLight,
      ),
      trackOutlineWidth: WidgetStateProperty.all(1),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>(
        (states) => states.contains(WidgetState.selected) ? AppColors.light.primary : Colors.transparent,
      ),
      checkColor: WidgetStateProperty.resolveWith<Color>(
        (states) => states.contains(WidgetState.selected) ? AppColors.light.white : Colors.transparent,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: BorderSide(color: AppColors.light.borderMedium, width: 1.5),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>(
        (states) => states.contains(WidgetState.selected) ? AppColors.light.primary : AppColors.light.deactive,
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: AppColors.light.primary,
      unselectedLabelColor: AppColors.light.deactive,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.light.primary, width: 2),
        ),
      ),
      labelStyle: AppTextStyle.bodyBold,
      unselectedLabelStyle: AppTextStyle.body,
      overlayColor: WidgetStateProperty.all(AppColors.light.primary.withOpacity(0.08)),
      dividerColor: AppColors.light.divider,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.light.surfaceHigh,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_defaultRadius),
        side: BorderSide(color: AppColors.light.borderLight, width: 0.5),
      ),
      titleTextStyle: AppTextStyle.title.copyWith(
        color: AppColors.light.active,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: AppTextStyle.body.copyWith(color: AppColors.light.active),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.light.surfaceHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.light.borderLight, width: 0.5),
      ),
      textStyle: AppTextStyle.captionL.copyWith(color: AppColors.light.active),
    ),
    bannerTheme: MaterialBannerThemeData(
      backgroundColor: AppColors.light.surfaceHigh,
      contentTextStyle: AppTextStyle.body.copyWith(color: AppColors.light.active),
      elevation: 0,
      padding: const EdgeInsets.all(16),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: AppColors.light.surfaceHigh,
      selectedIconTheme: IconThemeData(color: AppColors.light.primary),
      unselectedIconTheme: IconThemeData(color: AppColors.light.deactive),
      selectedLabelTextStyle: AppTextStyle.captionL.copyWith(
        color: AppColors.light.primary,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: AppTextStyle.captionL.copyWith(color: AppColors.light.deactive),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.light.surfaceHigh,
      indicatorColor: AppColors.light.primary.withOpacity(0.1),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: AppColors.light.primary);
        }
        return IconThemeData(color: AppColors.light.deactive);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTextStyle.captionL.copyWith(
            color: AppColors.light.primary,
            fontWeight: FontWeight.w600,
          );
        }
        return AppTextStyle.captionL.copyWith(color: AppColors.light.deactive);
      }),
      elevation: 0,
      height: 64,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.light.surface,
      modalBackgroundColor: AppColors.light.surfaceHigh,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: AppColors.light.borderLight, width: 0.5),
      ),
      elevation: 0,
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) =>
              states.contains(WidgetState.selected) ? AppColors.light.primary.withOpacity(0.2) : Colors.transparent,
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => states.contains(WidgetState.selected) ? AppColors.light.primary : AppColors.light.deactive,
        ),
        side: WidgetStateProperty.all(BorderSide(color: AppColors.light.borderLight)),
      ),
    ),
  );

  static final darkTheme = ThemeData.dark().copyWith(
    extensions: <ThemeExtension<dynamic>>[AppColors.dark],
    textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: AppColors.dark.active,
          displayColor: AppColors.dark.active,
        ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
          AppTextStyle.buttonS.copyWith(color: AppColors.dark.accent),
        ),
        overlayColor: WidgetStateProperty.all(AppColors.dark.accent.withOpacity(0.08)),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        ),
      ),
    ),
    scaffoldBackgroundColor: AppColors.dark.background01,
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      titleSpacing: 24,
      backgroundColor: AppColors.dark.background01,
      shadowColor: Colors.transparent,
      titleTextStyle: AppTextStyle.title.copyWith(
        color: AppColors.dark.active,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: AppColors.dark.active),
      centerTitle: false,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.dark.surfaceHigh,
      disabledColor: AppColors.dark.surfaceLow,
      selectedColor: AppColors.dark.accent.withOpacity(0.15),
      secondarySelectedColor: AppColors.dark.surfaceHigh,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_smallRadius)),
      labelStyle: AppTextStyle.body.copyWith(color: AppColors.dark.active),
      secondaryLabelStyle: AppTextStyle.body.copyWith(color: AppColors.dark.active),
      brightness: Brightness.dark,
      side: BorderSide(color: AppColors.dark.borderLight, width: 0.5),
    ),
    cardTheme: CardTheme(
      color: AppColors.dark.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: defaultCardShape(AppColors.dark),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.dark.surfaceHigh,
      selectedItemColor: AppColors.dark.primary,
      unselectedItemColor: AppColors.dark.deactive,
      selectedLabelStyle: AppTextStyle.captionL.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: AppTextStyle.captionS,
      elevation: 0,
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leadingAndTrailingTextStyle: AppTextStyle.chip.copyWith(color: AppColors.dark.active),
      titleTextStyle: AppTextStyle.body.copyWith(color: AppColors.dark.active),
      subtitleTextStyle: AppTextStyle.captionL.copyWith(color: AppColors.dark.deactive),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_smallRadius)),
      minLeadingWidth: 24,
      visualDensity: const VisualDensity(vertical: -1),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.dark.divider,
      thickness: 0.5,
      space: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.dark.surfaceHigh,
      contentTextStyle: AppTextStyle.bodyBold.copyWith(color: AppColors.dark.active),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_defaultRadius)),
      insetPadding: const EdgeInsets.all(16),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      actionTextColor: AppColors.dark.accent,
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.dark.primary,
      secondary: AppColors.dark.secondary,
      surface: AppColors.dark.surface,
      error: AppColors.dark.error,
      onPrimary: AppColors.dark.white,
      onSecondary: AppColors.dark.white,
      onSurface: AppColors.dark.onSurface,
      onError: AppColors.dark.white,
      surfaceTint: Colors.transparent,
      tertiary: AppColors.dark.accent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColors.dark.white),
        backgroundColor: WidgetStateProperty.all(AppColors.dark.primary),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(_buttonRadius)),
        ),
        textStyle: WidgetStateProperty.all(
          AppTextStyle.buttonS.copyWith(
            color: AppColors.dark.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
        overlayColor: WidgetStateProperty.all(AppColors.dark.white.withOpacity(0.1)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: AppColors.dark.background03),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.dark.surfaceHigh,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_smallRadius),
        borderSide: BorderSide(color: AppColors.dark.borderLight, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_smallRadius),
        borderSide: BorderSide(color: AppColors.dark.borderLight, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_smallRadius),
        borderSide: BorderSide(color: AppColors.dark.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_smallRadius),
        borderSide: BorderSide(color: AppColors.dark.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_smallRadius),
        borderSide: BorderSide(color: AppColors.dark.error, width: 1.5),
      ),
      hintStyle: AppTextStyle.body.copyWith(color: AppColors.dark.deactive),
      errorStyle: AppTextStyle.captionL.copyWith(color: AppColors.dark.error),
      prefixIconColor: AppColors.dark.deactive,
      suffixIconColor: AppColors.dark.deactive,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.dark.surfaceHigh,
      textStyle: AppTextStyle.body.copyWith(color: AppColors.dark.active),
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_smallRadius),
        side: BorderSide(color: AppColors.dark.borderLight, width: 0.5),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>(
        (states) =>
            states.contains(WidgetState.selected) ? AppColors.dark.primary : AppColors.dark.deactive.withOpacity(0.5),
      ),
      trackColor: WidgetStateProperty.resolveWith<Color>(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.dark.primary.withOpacity(0.3)
            : AppColors.dark.surfaceHigh,
      ),
      trackOutlineColor: WidgetStateProperty.resolveWith<Color>(
        (states) => states.contains(WidgetState.selected) ? Colors.transparent : AppColors.dark.borderLight,
      ),
      trackOutlineWidth: WidgetStateProperty.all(1),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>(
        (states) => states.contains(WidgetState.selected) ? AppColors.dark.primary : Colors.transparent,
      ),
      checkColor: WidgetStateProperty.resolveWith<Color>(
        (states) => states.contains(WidgetState.selected) ? AppColors.dark.white : Colors.transparent,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: BorderSide(color: AppColors.dark.borderMedium, width: 1.5),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>(
        (states) => states.contains(WidgetState.selected) ? AppColors.dark.primary : AppColors.dark.deactive,
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: AppColors.dark.primary,
      unselectedLabelColor: AppColors.dark.deactive,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.dark.primary, width: 2),
        ),
      ),
      labelStyle: AppTextStyle.bodyBold,
      unselectedLabelStyle: AppTextStyle.body,
      overlayColor: WidgetStateProperty.all(AppColors.dark.primary.withOpacity(0.08)),
      dividerColor: AppColors.dark.divider,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.dark.surfaceHigh,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_defaultRadius),
        side: BorderSide(color: AppColors.dark.borderLight, width: 0.5),
      ),
      titleTextStyle: AppTextStyle.title.copyWith(
        color: AppColors.dark.active,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: AppTextStyle.body.copyWith(color: AppColors.dark.active),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.dark.surfaceHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.dark.borderLight, width: 0.5),
      ),
      textStyle: AppTextStyle.captionL.copyWith(color: AppColors.dark.active),
    ),
    bannerTheme: MaterialBannerThemeData(
      backgroundColor: AppColors.dark.surfaceHigh,
      contentTextStyle: AppTextStyle.body.copyWith(color: AppColors.dark.active),
      elevation: 0,
      padding: const EdgeInsets.all(16),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: AppColors.dark.surfaceHigh,
      selectedIconTheme: IconThemeData(color: AppColors.dark.primary),
      unselectedIconTheme: IconThemeData(color: AppColors.dark.deactive),
      selectedLabelTextStyle: AppTextStyle.captionL.copyWith(
        color: AppColors.dark.primary,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: AppTextStyle.captionL.copyWith(color: AppColors.dark.deactive),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.dark.surfaceHigh,
      indicatorColor: AppColors.dark.primary.withOpacity(0.1),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: AppColors.dark.primary);
        }
        return IconThemeData(color: AppColors.dark.deactive);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTextStyle.captionL.copyWith(
            color: AppColors.dark.primary,
            fontWeight: FontWeight.w600,
          );
        }
        return AppTextStyle.captionL.copyWith(color: AppColors.dark.deactive);
      }),
      elevation: 0,
      height: 64,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.dark.surface,
      modalBackgroundColor: AppColors.dark.surfaceHigh,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: AppColors.dark.borderLight, width: 0.5),
      ),
      elevation: 0,
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) =>
              states.contains(WidgetState.selected) ? AppColors.dark.primary.withOpacity(0.2) : Colors.transparent,
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => states.contains(WidgetState.selected) ? AppColors.dark.primary : AppColors.dark.deactive,
        ),
        side: WidgetStateProperty.all(BorderSide(color: AppColors.dark.borderLight)),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.dark.primary,
      circularTrackColor: AppColors.dark.surfaceHigh,
      linearTrackColor: AppColors.dark.surfaceHigh,
      refreshBackgroundColor: AppColors.dark.surface,
    ),
    badgeTheme: BadgeThemeData(
      backgroundColor: AppColors.dark.error,
      textColor: AppColors.dark.white,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      textStyle: AppTextStyle.captionS.copyWith(fontWeight: FontWeight.w600),
    ),
  );

  static ThemeData getThemeByType(AppThemeType type) {
    switch (type) {
      case AppThemeType.light:
        return lightTheme;
      case AppThemeType.dark:
        return darkTheme;
    }
  }

  // Utility functions for common UI elements
  static BoxDecoration cardDecoration(BuildContext context, {bool isActive = false, Color? highlightColor}) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final accentColor = highlightColor ?? colors.accent;

    return BoxDecoration(
      color: isActive ? accentColor.withOpacity(0.05) : colors.surface,
      borderRadius: BorderRadius.circular(_cardRadius),
    );
  }

  static BoxDecoration chipDecoration(BuildContext context, {bool isSelected = false, Color? color}) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final chipColor = color ?? colors.primary;

    return BoxDecoration(
      color: isSelected ? chipColor.withOpacity(0.15) : colors.surface,
      borderRadius: BorderRadius.circular(_smallRadius),
      border: Border.all(
        color: isSelected ? chipColor.withOpacity(0.5) : colors.borderLight,
      ),
    );
  }

  static BoxDecoration modalDecoration(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return BoxDecoration(
      color: colors.surfaceHigh,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      boxShadow: [
        BoxShadow(
          color: colors.cardShadowDark,
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ],
    );
  }
}
