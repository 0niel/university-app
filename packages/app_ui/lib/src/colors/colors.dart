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
    activeLightMode: Color(0xFF200745),
    deactiveDarker: Color(0xFF3A3D46),
    divider: Color(0xFFE5E5E5),
  );

  static const AppColors dark = AppColors(
    primary: Color(0xFF246BFD),
    secondary: Color(0xFFC25FFF),
    background01: Color(0xFF181A20),
    background02: Color(0xFF262A34),
    background03: Color(0xFF1F222A),
    colorful01: Color(0xFFA06AF9),
    colorful02: Color(0xFFFBA3FF),
    colorful03: Color(0xFF8E96FF),
    colorful04: Color(0xFF94F0F0),
    colorful05: Color(0xFFA5F59C),
    colorful06: Color(0xFFFFDD72),
    colorful07: Color(0xFFFF968E),
    white: Color(0xFFFFFFFF),
    active: Color(0xFFFFFFFF),
    deactive: Color(0xFF5E6272),
    activeLightMode: Color(0xFF200745),
    deactiveDarker: Color(0xFF3A3D46),
    divider: Color(0x403A3D46),
  );
}
