import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
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

  final Color primary;
  final Color secondary;
  final Color background01;
  final Color background02;
  final Color background03;
  final Color colorful01;
  final Color colorful02;
  final Color colorful03;
  final Color colorful04;
  final Color colorful05;
  final Color colorful06;
  final Color colorful07;
  final Color white;
  final Color active;
  final Color deactive;
  final Color activeLightMode;
  final Color deactiveDarker;
  final Color divider;
  final Color surface;
  final Color surfaceHigh;
  final Color surfaceLow;
  final Color onSurface;
  final Color accent;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;
  final Color borderLight;
  final Color borderMedium;
  final Color cardShadowLight;
  final Color cardShadowDark;
  final Color shimmerBase;
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
    Color? colorful7,
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
      colorful07: colorful7 ?? colorful07,
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
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      background01: Color.lerp(background01, other.background01, t)!,
      background02: Color.lerp(background02, other.background02, t)!,
      background03: Color.lerp(background03, other.background03, t)!,
      colorful01: Color.lerp(colorful01, other.colorful01, t)!,
      colorful02: Color.lerp(colorful02, other.colorful02, t)!,
      colorful03: Color.lerp(colorful03, other.colorful03, t)!,
      colorful04: Color.lerp(colorful04, other.colorful04, t)!,
      colorful05: Color.lerp(colorful05, other.colorful05, t)!,
      colorful06: Color.lerp(colorful06, other.colorful06, t)!,
      colorful07: Color.lerp(colorful07, other.colorful07, t)!,
      white: Color.lerp(white, other.white, t)!,
      active: Color.lerp(active, other.active, t)!,
      deactive: Color.lerp(deactive, other.deactive, t)!,
      activeLightMode: Color.lerp(activeLightMode, other.activeLightMode, t)!,
      deactiveDarker: Color.lerp(deactiveDarker, other.deactiveDarker, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceHigh: Color.lerp(surfaceHigh, other.surfaceHigh, t)!,
      surfaceLow: Color.lerp(surfaceLow, other.surfaceLow, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      borderMedium: Color.lerp(borderMedium, other.borderMedium, t)!,
      cardShadowLight: Color.lerp(cardShadowLight, other.cardShadowLight, t)!,
      cardShadowDark: Color.lerp(cardShadowDark, other.cardShadowDark, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
    );
  }

  static const AppColors light = AppColors(
    primary: Color(0xFF246BFD),
    secondary: Color(0xFFC25FFF),
    background01: Color(0xFFF5F5F5),
    background02: Color(0xFFFFFFFF),
    background03: Color(0xFFF8F8F8),
    colorful01: Color(0xFFA06AF9),
    colorful02: Color(0xFFFBA3FF),
    colorful03: Color(0xFF8E96FF),
    colorful04: Color(0xFF94F0F0),
    colorful05: Color(0xFF5DCD9B),
    colorful06: Color(0xFFFFDD72),
    colorful07: Color(0xFFFF968E),
    white: Color(0xFFFFFFFF),
    active: Color(0xFF0D0D0D),
    deactive: Color(0xFF5E6272),
    activeLightMode: Color(0xFFE0E0E0),
    deactiveDarker: Color(0xFFE0E0E0),
    divider: Color(0xFFE0E0E0),
    surface: Color(0xFFFFFFFF),
    surfaceHigh: Color(0xFFF9F9F9),
    surfaceLow: Color(0xFFF0F0F0),
    onSurface: Color(0xFF2C2C2C),
    accent: Color(0xFF4F7FFF),
    success: Color(0xFF4CAF50),
    warning: Color(0xFFFFC107),
    error: Color(0xFFFF5252),
    info: Color(0xFF2196F3),
    borderLight: Color(0xFFEAEAEA),
    borderMedium: Color(0xFFD0D0D0),
    cardShadowLight: Color(0x0A000000),
    cardShadowDark: Color(0x1A000000),
    shimmerBase: Color(0xFFF0F0F0),
    shimmerHighlight: Color(0xFFFFFFFF),
  );

  static const AppColors dark = AppColors(
    primary: Color(0xFF4A90E2),
    secondary: Color(0xFFA48AD4),
    background01: Color(0xFF000000),
    background02: Color(0xFF121212),
    background03: Color(0xFF1C1C1C),
    colorful01: Color(0xFFB39DDB),
    colorful02: Color(0xFFF8BBD0),
    colorful03: Color(0xFF90CAF9),
    colorful04: Color(0xFF80CBC4),
    colorful05: Color(0xFFA5D6A7),
    colorful06: Color(0xFFFFF59D),
    colorful07: Color(0xFFFFAB91),
    white: Color(0xFFFFFFFF),
    active: Color(0xFFEEEEEE),
    deactive: Color(0xFFAAAAAA),
    activeLightMode: Color(0xFF607D8B),
    deactiveDarker: Color(0xFF78909C),
    divider: Color(0xFF333333),
    surface: Color(0xFF121212),
    surfaceHigh: Color(0xFF1C1C1C),
    surfaceLow: Color(0xFF000000),
    onSurface: Color(0xFFEEEEEE),
    accent: Color(0xFF5B8CFF),
    success: Color(0xFF66BB6A),
    warning: Color(0xFFFFD54F),
    error: Color(0xFFFF5252),
    info: Color(0xFF42A5F5),
    borderLight: Color(0x26FFFFFF),
    borderMedium: Color(0x40FFFFFF),
    cardShadowLight: Color(0x12000000),
    cardShadowDark: Color(0x24000000),
    shimmerBase: Color(0xFF1A1A1A),
    shimmerHighlight: Color(0xFF2C2C2C),
  );
}
