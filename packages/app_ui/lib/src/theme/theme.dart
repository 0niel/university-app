import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppThemeType { light, dark }

class AppTheme {
  static OutlinedBorder defaultCardShape(AppColors colors) =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      );

  static BoxDecoration glassEffect(AppColors colors) => BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(AppRadius.field),
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
      primary: colors.accent,
      secondary: colors.accent,
      surface: colors.surface,
      error: colors.exam,
      onPrimary: colors.onAccent,
      onSecondary: colors.onAccent,
      onSurface: colors.ink,
      onError: colors.white,
      surfaceTint: Colors.transparent,
      tertiary: colors.lecture,
      outline: colors.line,
      outlineVariant: colors.line,
      surfaceContainerHighest: colors.surface2,
      surfaceContainerHigh: colors.surface2,
      surfaceContainer: colors.surface,
      surfaceContainerLow: colors.canvas,
      surfaceContainerLowest: colors.canvas,
      onSurfaceVariant: colors.muted,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: AppText.sansFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.canvas,
      canvasColor: colors.canvas,
      dividerColor: colors.line,
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: colors.ink.withValues(alpha: 0.04),
      disabledColor: colors.muted2,
      pageTransitionsTheme: NinjaPageTransitions.theme,
      extensions: <ThemeExtension<dynamic>>[
        colors,
        NinjaColors.fromAppColors(colors, isDark: isDark),
      ],
    );

    final pill = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.full),
    );

    return base.copyWith(
      textTheme: _textTheme(colors),
      primaryTextTheme: _textTheme(colors),
      iconTheme: IconThemeData(color: colors.ink, size: AppIconSize.md),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: colors.canvas,
        foregroundColor: colors.ink,
        shadowColor: Colors.transparent,
        titleSpacing: AppSpacing.screen,
        centerTitle: false,
        titleTextStyle: AppText.sectionLarge.copyWith(color: colors.ink),
        iconTheme: IconThemeData(color: colors.ink),
        actionsIconTheme: IconThemeData(color: colors.ink),
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
        backgroundColor: colors.surface2,
        disabledColor: colors.canvas,
        selectedColor: colors.tint,
        secondarySelectedColor: colors.tint,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: pill,
        labelStyle: AppText.chip.copyWith(color: colors.muted),
        secondaryLabelStyle: AppText.chip.copyWith(color: colors.accent),
        brightness: brightness,
        side: BorderSide.none,
      ),
      dividerTheme: DividerThemeData(
        color: colors.line,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        iconColor: colors.muted,
        textColor: colors.ink,
        leadingAndTrailingTextStyle: AppText.body.copyWith(color: colors.muted),
        titleTextStyle: AppText.cell.copyWith(color: colors.ink),
        subtitleTextStyle: AppText.subtext.copyWith(color: colors.muted),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.tile),
        ),
        minLeadingWidth: 28,
        visualDensity: const VisualDensity(vertical: -1),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(colors.accent),
          textStyle: WidgetStateProperty.all(AppText.button),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          shape: WidgetStateProperty.all(pill),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? colors.muted2
                : colors.onAccent,
          ),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? colors.canvas
                : colors.accent,
          ),
          overlayColor: WidgetStateProperty.all(
            colors.ink.withValues(alpha: 0.12),
          ),
          elevation: WidgetStateProperty.all(0),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
          shape: WidgetStateProperty.all(pill),
          textStyle: WidgetStateProperty.all(AppText.button),
          minimumSize: WidgetStateProperty.all(
            const Size(0, AppControlSize.buttonMedium),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(colors.onAccent),
          backgroundColor: WidgetStateProperty.all(colors.accent),
          shape: WidgetStateProperty.all(pill),
          textStyle: WidgetStateProperty.all(AppText.button),
          minimumSize: WidgetStateProperty.all(
            const Size(0, AppControlSize.buttonMedium),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(colors.ink),
          backgroundColor: WidgetStateProperty.all(colors.surface2),
          side: WidgetStateProperty.all(BorderSide.none),
          shape: WidgetStateProperty.all(pill),
          textStyle: WidgetStateProperty.all(AppText.button),
          minimumSize: WidgetStateProperty.all(
            const Size(0, AppControlSize.buttonMedium),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: colors.surface,
          foregroundColor: colors.ink,
          disabledBackgroundColor: colors.canvas,
          disabledForegroundColor: colors.muted2,
          shape: const CircleBorder(),
          fixedSize: const Size.square(AppControlSize.iconButton),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface2,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: _filledInputShape,
        enabledBorder: _filledInputShape,
        disabledBorder: _filledInputShape,
        focusedBorder: _filledInputShape,
        errorBorder: _filledInputShape,
        focusedErrorBorder: _filledInputShape,
        hintStyle: AppText.body.copyWith(color: colors.muted2),
        labelStyle: AppText.caption.copyWith(color: colors.muted),
        errorStyle: AppText.captionSmall.copyWith(
          color: colors.exam,
          fontWeight: FontWeight.w500,
        ),
        prefixIconColor: colors.muted,
        suffixIconColor: colors.muted,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colors.surface,
        textStyle: AppText.cell.copyWith(color: colors.ink),
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.ink,
        contentTextStyle: AppText.compact.copyWith(color: colors.canvas),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
        ),
        insetPadding: const EdgeInsets.all(16),
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        actionTextColor: colors.accent,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(colors.white),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.accent
              : colors.surface2,
        ),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.accent
              : Colors.transparent,
        ),
        checkColor: WidgetStateProperty.all(colors.onAccent),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.checkbox),
        ),
        side: BorderSide(color: colors.muted2, width: 2),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.accent
              : colors.muted2,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: colors.ink,
        unselectedLabelColor: colors.muted,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: colors.accent,
        labelStyle: AppText.tab,
        unselectedLabelStyle: AppText.tab,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        dividerColor: colors.line,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.canvas,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.dialog),
        ),
        titleTextStyle: AppText.sans(17, FontWeight.w700, height: 1.2)
            .copyWith(color: colors.ink),
        contentTextStyle: AppText.compact
            .copyWith(color: colors.muted, fontWeight: FontWeight.w500),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colors.ink,
          borderRadius: BorderRadius.circular(AppRadius.iconTile),
        ),
        textStyle: AppText.subtextStrong.copyWith(color: colors.canvas),
      ),
      bannerTheme: MaterialBannerThemeData(
        backgroundColor: colors.tint,
        contentTextStyle: AppText.label.copyWith(color: colors.ink),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        padding: const EdgeInsets.all(14),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surface,
        indicatorColor: colors.accent,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        height: AppControlSize.bottomBar,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? colors.onAccent : colors.muted,
          );
        }),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colors.surface,
        selectedItemColor: colors.accent,
        unselectedItemColor: colors.muted,
        selectedLabelStyle: AppText.captionBold,
        unselectedLabelStyle: AppText.caption,
        elevation: 0,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colors.surface,
        indicatorColor: colors.accent,
        selectedIconTheme: IconThemeData(color: colors.onAccent),
        unselectedIconTheme: IconThemeData(color: colors.muted),
        selectedLabelTextStyle: AppText.captionBold.copyWith(color: colors.ink),
        unselectedLabelTextStyle: AppText.caption.copyWith(color: colors.muted),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.canvas,
        modalBackgroundColor: colors.canvas,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
        ),
        elevation: 0,
        modalElevation: 0,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? colors.accent
                : Colors.transparent,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? colors.onAccent
                : colors.muted,
          ),
          side: WidgetStateProperty.all(BorderSide.none),
          shape: WidgetStateProperty.all(pill),
          textStyle: WidgetStateProperty.all(AppText.segment),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.accent,
        circularTrackColor: colors.surface2,
        linearTrackColor: colors.surface2,
        refreshBackgroundColor: colors.surface,
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: colors.exam,
        textColor: colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        textStyle: AppText.countBadge,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: colors.accent,
        inactiveTrackColor: colors.surface2,
        thumbColor: colors.accent,
        overlayColor: Colors.transparent,
        trackHeight: 6,
      ),
    );
  }

  static TextTheme _textTheme(AppColors colors) {
    return TextTheme(
      displayLarge: AppText.displayLarge.copyWith(color: colors.ink),
      displayMedium: AppText.display.copyWith(color: colors.ink),
      displaySmall: AppText.displaySmall.copyWith(color: colors.ink),
      headlineLarge: AppText.sectionLarge.copyWith(color: colors.ink),
      headlineMedium: AppText.section.copyWith(color: colors.ink),
      headlineSmall: AppText.sectionSmall.copyWith(color: colors.ink),
      titleLarge: AppText.title.copyWith(color: colors.ink),
      titleMedium: AppText.headline.copyWith(color: colors.ink),
      titleSmall: AppText.cell.copyWith(color: colors.ink),
      bodyLarge: AppText.bodyLarge.copyWith(color: colors.ink),
      bodyMedium: AppText.body.copyWith(color: colors.ink),
      bodySmall: AppText.subtext.copyWith(color: colors.muted),
      labelLarge: AppText.buttonLarge.copyWith(color: colors.ink),
      labelMedium: AppText.button.copyWith(color: colors.ink),
      labelSmall: AppText.overline.copyWith(color: colors.muted),
    );
  }

  static final _filledInputShape = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.field),
    borderSide: BorderSide.none,
  );

  static BoxDecoration cardDecoration(
    BuildContext context, {
    bool isActive = false,
    Color? highlightColor,
  }) {
    final colors = Theme.of(context).colors;
    return BoxDecoration(
      color: isActive
          ? colors.tintOf(highlightColor ?? colors.accent)
          : colors.surface,
      borderRadius: BorderRadius.circular(AppRadius.card),
    );
  }

  static BoxDecoration chipDecoration(
    BuildContext context, {
    bool isSelected = false,
    Color? color,
  }) {
    final colors = Theme.of(context).colors;
    return BoxDecoration(
      color:
          isSelected ? colors.tintOf(color ?? colors.accent) : colors.surface2,
      borderRadius: BorderRadius.circular(AppRadius.full),
    );
  }

  static BoxDecoration modalDecoration(BuildContext context) {
    final colors = Theme.of(context).colors;
    return BoxDecoration(
      color: colors.canvas,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.sheet),
      ),
    );
  }
}
