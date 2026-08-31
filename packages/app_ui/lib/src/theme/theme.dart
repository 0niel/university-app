import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppThemeType { light, dark }

class AppTheme {
  static OutlinedBorder defaultCardShape(AppColors colors) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg));

  static BoxDecoration glassEffect(AppColors colors) => BoxDecoration(
        color: colors.surfaceHigh,
        borderRadius: BorderRadius.circular(AppRadius.md),
      );

  static final ThemeData lightTheme =
      _buildTheme(AppColors.light, Brightness.light);
  static final ThemeData darkTheme =
      _buildTheme(AppColors.dark, Brightness.dark);

  static ThemeData getThemeByType(AppThemeType type) {
    return switch (type) {
      AppThemeType.light => lightTheme,
      AppThemeType.dark => darkTheme,
    };
  }

  static ThemeData generateTheme(AppColors colors, Brightness brightness) {
    return _buildTheme(colors, brightness);
  }

  static ThemeData _buildTheme(AppColors colors, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      secondary: colors.secondary,
      surface: colors.surface,
      error: colors.error,
      onPrimary: colors.onAccent,
      onSecondary: colors.onAccent,
      onSurface: colors.onSurface,
      onError: colors.white,
      surfaceTint: Colors.transparent,
      tertiary: colors.info,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: FontFamily.onest,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background01,
      canvasColor: colors.background01,
      dividerColor: colors.divider,
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: colors.active.withValues(alpha: 0.04),
      disabledColor: colors.deactiveDarker,
      pageTransitionsTheme: NinjaPageTransitions.theme,
      extensions: <ThemeExtension<dynamic>>[
        colors,
        NinjaColors.fromAppColors(colors, isDark: isDark),
      ],
    );

    return base.copyWith(
      textTheme: _textTheme(colors),
      primaryTextTheme: _textTheme(colors),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: colors.background01,
        foregroundColor: colors.active,
        shadowColor: Colors.transparent,
        titleSpacing: 20,
        centerTitle: false,
        titleTextStyle: AppText.title.copyWith(color: colors.active),
        iconTheme: IconThemeData(color: colors.active),
        actionsIconTheme: IconThemeData(color: colors.active),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          systemStatusBarContrastEnforced: false,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness:
              isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarContrastEnforced: false,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: defaultCardShape(colors),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceLow,
        disabledColor: colors.surfaceHigh,
        selectedColor: colors.primary.withValues(alpha: isDark ? 0.18 : 0.10),
        secondarySelectedColor: colors.primary.withValues(
          alpha: isDark ? 0.18 : 0.10,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_rFull),
        ),
        labelStyle: AppText.caption.copyWith(color: colors.active),
        secondaryLabelStyle: AppText.caption.copyWith(color: colors.active),
        brightness: brightness,
        side: BorderSide.none,
      ),
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        iconColor: colors.deactive,
        textColor: colors.active,
        leadingAndTrailingTextStyle:
            AppText.body.copyWith(color: colors.active),
        titleTextStyle: AppText.body.copyWith(color: colors.active),
        subtitleTextStyle:
            AppText.caption.copyWith(color: colors.deactiveDarker),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        minLeadingWidth: 28,
        visualDensity: const VisualDensity(vertical: -1),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(colors.primary),
          textStyle: WidgetStateProperty.all(AppText.button),
          overlayColor: WidgetStateProperty.all(
            colors.primary.withValues(alpha: isDark ? 0.12 : 0.08),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(colors.onAccent),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? colors.surfaceLow
                : colors.primary,
          ),
          overlayColor: WidgetStateProperty.all(
            colors.white.withValues(alpha: isDark ? 0.12 : 0.08),
          ),
          elevation: WidgetStateProperty.all(0),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          textStyle: WidgetStateProperty.all(AppText.button),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(colors.active),
          backgroundColor: WidgetStateProperty.all(colors.surfaceHigh),
          side: WidgetStateProperty.all(BorderSide.none),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          textStyle: WidgetStateProperty.all(AppText.button),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: colors.surfaceHigh,
          foregroundColor: colors.active,
          disabledBackgroundColor: colors.surfaceHigh,
          disabledForegroundColor: colors.deactiveDarker,
          shape: const CircleBorder(),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceLow,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: _filledInputShape,
        enabledBorder: _filledInputShape,
        disabledBorder: _filledInputShape,
        focusedBorder: _filledInputShape,
        errorBorder: _filledInputShape,
        focusedErrorBorder: _filledInputShape,
        hintStyle: AppText.body.copyWith(color: colors.deactiveDarker),
        labelStyle: AppText.body.copyWith(color: colors.deactive),
        errorStyle: AppText.caption.copyWith(color: colors.error),
        prefixIconColor: colors.deactive,
        suffixIconColor: colors.deactive,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colors.surfaceHigh,
        textStyle: AppText.body.copyWith(color: colors.active),
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.surfaceHigh,
        contentTextStyle: AppText.bodyStrong.copyWith(color: colors.active),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        insetPadding: const EdgeInsets.all(16),
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        actionTextColor: colors.primary,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.onAccent
              : colors.deactiveDarker,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.primary
              : colors.surfaceLow,
        ),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.primary
              : colors.surfaceLow,
        ),
        checkColor: WidgetStateProperty.all(colors.onAccent),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        side: BorderSide.none,
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.primary
              : colors.deactiveDarker,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: colors.active,
        unselectedLabelColor: colors.deactiveDarker,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: colors.surfaceLow,
          borderRadius: BorderRadius.circular(_rFull),
        ),
        labelStyle: AppText.button,
        unselectedLabelStyle: AppText.button,
        overlayColor: WidgetStateProperty.all(
          colors.primary.withValues(alpha: isDark ? 0.12 : 0.08),
        ),
        dividerColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        titleTextStyle: AppText.title.copyWith(color: colors.active),
        contentTextStyle: AppText.body.copyWith(color: colors.active),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colors.surfaceLow,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        textStyle: AppText.caption.copyWith(color: colors.active),
      ),
      bannerTheme: MaterialBannerThemeData(
        backgroundColor: colors.surface,
        contentTextStyle: AppText.body.copyWith(color: colors.active),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        padding: const EdgeInsets.all(16),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surface,
        indicatorColor: colors.primary.withValues(alpha: isDark ? 0.18 : 0.10),
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? colors.primary : colors.deactiveDarker,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return AppText.caption.copyWith(
            color: selected ? colors.active : colors.deactiveDarker,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colors.surface,
        selectedItemColor: colors.primary,
        unselectedItemColor: colors.deactiveDarker,
        selectedLabelStyle:
            AppText.caption.copyWith(fontWeight: FontWeight.w700),
        unselectedLabelStyle: AppText.caption,
        elevation: 0,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colors.surface,
        indicatorColor: colors.primary.withValues(alpha: isDark ? 0.18 : 0.10),
        selectedIconTheme: IconThemeData(color: colors.primary),
        unselectedIconTheme: IconThemeData(color: colors.deactiveDarker),
        selectedLabelTextStyle: AppText.caption.copyWith(
          color: colors.active,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle:
            AppText.caption.copyWith(color: colors.deactiveDarker),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        modalBackgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        elevation: 0,
        modalElevation: 0,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? colors.primary
                : Colors.transparent,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? colors.onAccent
                : colors.deactive,
          ),
          side: WidgetStateProperty.all(BorderSide.none),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(_rFull)),
          ),
          textStyle: WidgetStateProperty.all(AppText.button),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
        circularTrackColor: colors.surfaceHigh,
        linearTrackColor: colors.surfaceHigh,
        refreshBackgroundColor: colors.surface,
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: colors.error,
        textColor: colors.error.computeLuminance() > 0.179
            ? const Color(0xFF101014)
            : colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        textStyle: AppText.captionSmall.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  static TextTheme _textTheme(AppColors colors) {
    return TextTheme(
      displayLarge: AppText.displayLarge.copyWith(color: colors.active),
      displayMedium: AppText.display.copyWith(color: colors.active),
      displaySmall: AppText.displaySmall.copyWith(color: colors.active),
      headlineLarge: AppText.title.copyWith(color: colors.active),
      headlineMedium: AppText.heading.copyWith(color: colors.active),
      headlineSmall: AppText.heading.copyWith(color: colors.active),
      titleLarge: AppText.title.copyWith(color: colors.active),
      titleMedium: AppText.heading.copyWith(color: colors.active),
      titleSmall: AppText.bodyStrong.copyWith(color: colors.active),
      bodyLarge: AppText.bodyLarge.copyWith(color: colors.active),
      bodyMedium: AppText.body.copyWith(color: colors.active),
      bodySmall: AppText.caption.copyWith(color: colors.deactive),
      labelLarge: AppText.buttonLarge.copyWith(color: colors.active),
      labelMedium: AppText.button.copyWith(color: colors.active),
      labelSmall: AppText.captionSmall.copyWith(color: colors.deactive),
    );
  }

  static final _filledInputShape = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.md),
    borderSide: BorderSide.none,
  );

  static const double _rFull = AppRadius.full;

  static BoxDecoration cardDecoration(
    BuildContext context, {
    bool isActive = false,
    Color? highlightColor,
  }) {
    final colors = Theme.of(context).colors;
    final accentColor = highlightColor ?? colors.accent;

    return BoxDecoration(
      color: isActive ? accentColor.withValues(alpha: 0.14) : colors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
    );
  }

  static BoxDecoration chipDecoration(
    BuildContext context, {
    bool isSelected = false,
    Color? color,
  }) {
    final colors = Theme.of(context).colors;
    final chipColor = color ?? colors.primary;

    return BoxDecoration(
      color: isSelected ? chipColor.withValues(alpha: 0.16) : colors.surfaceLow,
      borderRadius: BorderRadius.circular(_rFull),
    );
  }

  static BoxDecoration modalDecoration(BuildContext context) {
    final colors = Theme.of(context).colors;

    return BoxDecoration(
      color: colors.surface,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.xl),
      ),
    );
  }
}
