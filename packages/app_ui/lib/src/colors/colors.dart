import 'package:flutter/material.dart';

/// {@template app_colors}
/// The app's full semantic color palette as a [ThemeExtension]: brand,
/// background, surface, text, status and decorative tokens, with [light] and
/// [dark] presets and theme-aware lerping.
/// {@endtemplate}
@immutable
class AppColors extends ThemeExtension<AppColors> {
  /// {@macro app_colors}
  const AppColors({
    required this.primary,
    required this.secondary,
    required this.background01,
    required this.background02,
    required this.background03,
    required this.colorful01,
    required this.colorful02,
    required this.colorful03,
    required this.colorful04,
    required this.colorful05,
    required this.colorful06,
    required this.colorful07,
    required this.white,
    required this.active,
    required this.deactive,
    required this.activeLightMode,
    required this.deactiveDarker,
    required this.divider,
    required this.surface,
    required this.surfaceHigh,
    required this.surfaceLow,
    required this.onSurface,
    required this.accent,
    required this.onAccent,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.borderLight,
    required this.borderMedium,
    required this.cardShadowLight,
    required this.cardShadowDark,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  /// Primary brand color.
  /// Use for primary buttons, links and prominent interactive elements.
  /// Example: `ElevatedButton` background.
  final Color primary;

  /// Secondary accent color.
  /// Use for secondary actions, badges and subtle highlights.
  /// Example: secondary `OutlinedButton` border or icon tint.
  final Color secondary;

  /// Main app background (canvas).
  /// Use as the scaffold/page background. Should usually be white or very light.
  /// Example: screen `Scaffold.backgroundColor`.
  final Color background01;

  /// Card/background variant 1 used for surfaces such as cards and panels.
  /// Use for card containers to separate them from the main background.
  /// Example: `Card` background.
  final Color background02;

  /// Card/background variant 2 for nested surfaces or subtle panels.
  /// Use for list tiles, grouped panels or slightly raised areas.
  /// Example: list section background.
  final Color background03;

  /// Decorative/palette color 1.
  /// Use for illustrations, gradients or emphasised UI accents.
  /// Example: subtle gradient stop in headers.
  final Color colorful01;

  /// Decorative/palette color 2.
  /// Use for soft highlights, success icons or non-critical accents.
  /// Example: avatar ring or tag background.
  final Color colorful02;

  /// Decorative/palette color 3.
  /// Use for tertiary accents and small UI ornaments.
  /// Example: small badges or badges on cards.
  final Color colorful03;

  /// Decorative/palette color 4.
  /// Use for neutral playful accents and illustrations.
  /// Example: illustration tint.
  final Color colorful04;

  /// Decorative/palette color 5.
  /// Use for positive emphasis and success-related visuals.
  /// Example: success chip background.
  final Color colorful05;

  /// Decorative/palette color 6.
  /// Use for warning highlights or muted accents.
  /// Example: pill background for warnings.
  final Color colorful06;

  /// Decorative/palette color 7.
  /// Use for error accents or attention-grabbing UI bits.
  /// Example: accent for critical badges.
  final Color colorful07;

  /// Pure white color utility.
  /// Use when a guaranteed white value is required.
  /// Example: icon on colored backgrounds.
  final Color white;

  /// Primary text / icon color on light surfaces.
  /// Use for main content text and important icons.
  /// Example: page titles, primary labels.
  final Color active;

  /// Secondary / muted text color.
  /// Use for helper text, captions and disabled-like visuals.
  /// Example: subtitles, timestamps.
  final Color deactive;

  /// Light-mode subtle background used for overlays and subtle surfaces.
  /// Use for gentle contrasts on top of `background01`.
  /// Example: input backgrounds.
  final Color activeLightMode;

  /// Darker variant of muted text for contrast adjustments.
  /// Use when a slightly stronger disabled tone is needed.
  /// Example: muted labels on cards.
  final Color deactiveDarker;

  /// Divider color used for separators.
  /// Use for rules between list items and form fields.
  /// Example: `Divider` and `ListTile` separators.
  final Color divider;

  /// Default surface color for components (cards, sheets).
  /// Use for component backgrounds that sit above the canvas.
  /// Example: `Card` and `BottomSheet` backgrounds.
  final Color surface;

  /// Elevated surface color (slightly different from `surface`).
  /// Use for highlighted surfaces or input fields.
  /// Example: focused input or tooltip background.
  final Color surfaceHigh;

  /// Lower-contrast surface color for subtle panels.
  /// Use for nested panels or disabled surfaces.
  /// Example: disabled card backgrounds.
  final Color surfaceLow;

  /// Color used for content displayed on surfaces (`surface`, `surfaceHigh`).
  /// Use as the `onSurface` color for icons and text inside surfaces.
  /// Example: text color inside cards.
  final Color onSurface;

  /// Accent color for interactive highlights.
  /// Use for focus rings, small accents and decorative strokes.
  /// Example: focused border or active icon tint.
  final Color accent;

  /// Text/icon color that sits on top of the active accent color.
  final Color onAccent;

  /// Success color.
  /// Use for success states, confirmations and positive badges.
  /// Example: success toast background or icon.
  final Color success;

  /// Warning color.
  /// Use for warnings and non-critical alerts.
  /// Example: warning chip or inline alert.
  final Color warning;

  /// Error color.
  /// Use for error states and destructive actions.
  /// Example: error text or destructive buttons.
  final Color error;

  /// Informational color.
  /// Use for info states and helpful messages.
  /// Example: info badge or helper text.
  final Color info;

  /// Light border color.
  /// Use for subtle borders around inputs and cards.
  /// Example: input enabled border.
  final Color borderLight;

  /// Medium border color used for stronger separators.
  /// Use where a more visible divide is required.
  /// Example: outer card border.
  final Color borderMedium;

  /// Light shadow color for cards (kept as utility; modern theme minimizes
  /// real shadows).
  /// Use only when subtle depth is necessary.
  /// Example: very soft card shadow overlay.
  final Color cardShadowLight;

  /// Darker shadow color for pronounced depth in dark themes.
  /// Use sparingly; modern UI prefers borders over heavy shadows.
  final Color cardShadowDark;

  /// Base color used by shimmer placeholders.
  /// Example: shimmer base for loading skeletons.
  final Color shimmerBase;

  /// Highlight color used by shimmer placeholders.
  /// Example: shimmer highlight in skeleton loaders.
  final Color shimmerHighlight;

  @override
  AppColors copyWith({
    Color? primary,
    Color? secondary,
    Color? background01,
    Color? background02,
    Color? background03,
    Color? colorful01,
    Color? colorful02,
    Color? colorful03,
    Color? colorful04,
    Color? colorful05,
    Color? colorful06,
    Color? colorful07,
    Color? white,
    Color? active,
    Color? deactive,
    Color? activeLightMode,
    Color? deactiveDarker,
    Color? divider,
    Color? surface,
    Color? surfaceHigh,
    Color? surfaceLow,
    Color? onSurface,
    Color? accent,
    Color? onAccent,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? borderLight,
    Color? borderMedium,
    Color? cardShadowLight,
    Color? cardShadowDark,
    Color? shimmerBase,
    Color? shimmerHighlight,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      background01: background01 ?? this.background01,
      background02: background02 ?? this.background02,
      background03: background03 ?? this.background03,
      colorful01: colorful01 ?? this.colorful01,
      colorful02: colorful02 ?? this.colorful02,
      colorful03: colorful03 ?? this.colorful03,
      colorful04: colorful04 ?? this.colorful04,
      colorful05: colorful05 ?? this.colorful05,
      colorful06: colorful06 ?? this.colorful06,
      colorful07: colorful07 ?? this.colorful07,
      white: white ?? this.white,
      active: active ?? this.active,
      deactive: deactive ?? this.deactive,
      activeLightMode: activeLightMode ?? this.activeLightMode,
      deactiveDarker: deactiveDarker ?? this.deactiveDarker,
      divider: divider ?? this.divider,
      surface: surface ?? this.surface,
      surfaceHigh: surfaceHigh ?? this.surfaceHigh,
      surfaceLow: surfaceLow ?? this.surfaceLow,
      onSurface: onSurface ?? this.onSurface,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      borderLight: borderLight ?? this.borderLight,
      borderMedium: borderMedium ?? this.borderMedium,
      cardShadowLight: cardShadowLight ?? this.cardShadowLight,
      cardShadowDark: cardShadowDark ?? this.cardShadowDark,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      secondary: Color.lerp(secondary, other.secondary, t) ?? secondary,
      background01:
          Color.lerp(background01, other.background01, t) ?? background01,
      background02:
          Color.lerp(background02, other.background02, t) ?? background02,
      background03:
          Color.lerp(background03, other.background03, t) ?? background03,
      colorful01: Color.lerp(colorful01, other.colorful01, t) ?? colorful01,
      colorful02: Color.lerp(colorful02, other.colorful02, t) ?? colorful02,
      colorful03: Color.lerp(colorful03, other.colorful03, t) ?? colorful03,
      colorful04: Color.lerp(colorful04, other.colorful04, t) ?? colorful04,
      colorful05: Color.lerp(colorful05, other.colorful05, t) ?? colorful05,
      colorful06: Color.lerp(colorful06, other.colorful06, t) ?? colorful06,
      colorful07: Color.lerp(colorful07, other.colorful07, t) ?? colorful07,
      white: Color.lerp(white, other.white, t) ?? white,
      active: Color.lerp(active, other.active, t) ?? active,
      deactive: Color.lerp(deactive, other.deactive, t) ?? deactive,
      activeLightMode: Color.lerp(activeLightMode, other.activeLightMode, t) ??
          activeLightMode,
      deactiveDarker:
          Color.lerp(deactiveDarker, other.deactiveDarker, t) ?? deactiveDarker,
      divider: Color.lerp(divider, other.divider, t) ?? divider,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      surfaceHigh: Color.lerp(surfaceHigh, other.surfaceHigh, t) ?? surfaceHigh,
      surfaceLow: Color.lerp(surfaceLow, other.surfaceLow, t) ?? surfaceLow,
      onSurface: Color.lerp(onSurface, other.onSurface, t) ?? onSurface,
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      onAccent: Color.lerp(onAccent, other.onAccent, t) ?? onAccent,
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      error: Color.lerp(error, other.error, t) ?? error,
      info: Color.lerp(info, other.info, t) ?? info,
      borderLight: Color.lerp(borderLight, other.borderLight, t) ?? borderLight,
      borderMedium:
          Color.lerp(borderMedium, other.borderMedium, t) ?? borderMedium,
      cardShadowLight: Color.lerp(cardShadowLight, other.cardShadowLight, t) ??
          cardShadowLight,
      cardShadowDark:
          Color.lerp(cardShadowDark, other.cardShadowDark, t) ?? cardShadowDark,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t) ?? shimmerBase,
      shimmerHighlight:
          Color.lerp(shimmerHighlight, other.shimmerHighlight, t) ??
              shimmerHighlight,
    );
  }

  static const AppColors light = AppColors(
    primary: Color(0xFF5147F8),
    secondary: Color(0xFF5147F8),
    background01: Color(0xFFF8F7F3),
    background02: Color(0xFFFFFFFF),
    background03: Color(0xFFF0EFEA),
    colorful01: Color(0xFFA45CFF),
    colorful02: Color(0xFFFF6FB1),
    colorful03: Color(0xFFFF8A2F),
    colorful04: Color(0xFF4DA8FF),
    colorful05: Color(0xFF1FB872),
    colorful06: Color(0xFFFFB020),
    colorful07: Color(0xFFFF4F4F),
    white: Color(0xFFFFFFFF),
    active: Color(0xFF111116),
    deactive: Color(0xFF62616A),
    activeLightMode: Color(0xFFF0EFEA),
    deactiveDarker: Color(0xFF414149),
    divider: Color(0x10000000),
    surface: Color(0xFFFFFFFF),
    surfaceHigh: Color(0xFFF0EFEA),
    surfaceLow: Color(0xFFE7E6E0),
    onSurface: Color(0xFF111116),
    accent: Color(0xFF5147F8),
    onAccent: Color(0xFFFFFFFF),
    success: Color(0xFF1FB872),
    warning: Color(0xFFFFB020),
    error: Color(0xFFFF5577),
    info: Color(0xFF4DA8FF),
    borderLight: Color(0x10000000),
    borderMedium: Color(0x18000000),
    cardShadowLight: Color(0x00000000),
    cardShadowDark: Color(0x00000000),
    shimmerBase: Color(0xFFE8E7E1),
    shimmerHighlight: Color(0xFFF8F7F3),
  );

  static const AppColors dark = AppColors(
    primary: Color(0xFF4F46E5),
    secondary: Color(0xFFFF6FB1),
    background01: Color(0xFF0F0F0F),
    background02: Color(0xFF1C1C1C),
    background03: Color(0xFF262626),
    colorful01: Color(0xFFA45CFF),
    colorful02: Color(0xFFFF6FB1),
    colorful03: Color(0xFFFF8A2F),
    colorful04: Color(0xFF4DA8FF),
    colorful05: Color(0xFF34D399),
    colorful06: Color(0xFFFFB020),
    colorful07: Color(0xFFFF4F4F),
    white: Color(0xFFFFFFFF),
    active: Color(0xFFFFFFFF),
    deactive: Color(0x99FFFFFF),
    activeLightMode: Color(0xFF333333),
    deactiveDarker: Color(0x61FFFFFF),
    divider: Color(0x0FFFFFFF),
    surface: Color(0xFF1C1C1C),
    surfaceHigh: Color(0xFF262626),
    surfaceLow: Color(0xFF333333),
    onSurface: Color(0xFFFFFFFF),
    accent: Color(0xFF4F46E5),
    onAccent: Color(0xFFFFFFFF),
    success: Color(0xFF34D399),
    warning: Color(0xFFFFB020),
    error: Color(0xFFFF5577),
    info: Color(0xFF4DA8FF),
    borderLight: Color(0x0FFFFFFF),
    borderMedium: Color(0x14FFFFFF),
    cardShadowLight: Color(0x00000000),
    cardShadowDark: Color(0x00000000),
    shimmerBase: Color(0xFF262626),
    shimmerHighlight: Color(0xFF333333),
  );
}

/// {@template theme_data_colors_x}
/// Adds a `colors` getter to [ThemeData] returning its [AppColors] extension,
/// falling back to the [AppColors.light]/[AppColors.dark] preset by brightness.
/// {@endtemplate}
extension ThemeDataColorsX on ThemeData {
  AppColors get colors =>
      extension() ??
      (brightness == Brightness.dark ? AppColors.dark : AppColors.light);
}

/// {@template build_context_colors_x}
/// Adds a `colors` getter to [BuildContext] for terse access to the ambient
/// [AppColors] via `context.colors`.
/// {@endtemplate}
extension BuildContextColorsX on BuildContext {
  AppColors get colors => Theme.of(this).colors;
}
