import 'package:flutter/material.dart';

enum AppAccent { blue, violet, green, red }

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.canvas,
    required this.surface,
    required this.surface2,
    required this.ink,
    required this.muted,
    required this.muted2,
    required this.line,
    required this.accent,
    required this.onAccent,
    required this.lecture,
    required this.practice,
    required this.lab,
    required this.exam,
    required this.warn,
    required this.scrim,
    required this.isDark,
  });

  final Color canvas;
  final Color surface;
  final Color surface2;
  final Color ink;
  final Color muted;
  final Color muted2;
  final Color line;
  final Color accent;
  final Color onAccent;
  final Color lecture;
  final Color practice;
  final Color lab;
  final Color exam;
  final Color warn;
  final Color scrim;
  final bool isDark;

  static const mapCanvasLight = Color(0xFFF1EFEA);
  static const mapCanvasDark = Color(0xFF171A20);

  static const AppColors light = AppColors(
    canvas: Color(0xFFF5F7FC),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFEBEFF7),
    ink: Color(0xFF111724),
    muted: Color(0xFF647086),
    muted2: Color(0xFFA3A8B3),
    line: Color.fromRGBO(21, 23, 28, .08),
    accent: Color(0xFF3063DE),
    onAccent: Color(0xFFFFFFFF),
    lecture: Color(0xFF0E8A63),
    practice: Color(0xFF2F7AFF),
    lab: Color(0xFF8B5CF6),
    exam: Color(0xFFE5484D),
    warn: Color(0xFFC77700),
    scrim: Color.fromRGBO(21, 23, 28, .42),
    isDark: false,
  );

  static const AppColors dark = AppColors(
    canvas: Colors.black,
    surface: Color(0xFF101012),
    surface2: Color(0xFF1B1C21),
    ink: Color(0xFFF5F7FC),
    muted: Color(0xFFA0AABC),
    muted2: Color(0xFF5F646E),
    line: Color.fromRGBO(236, 237, 239, .08),
    accent: Color(0xFFA8C4FF),
    onAccent: Color(0xFF0D1830),
    lecture: Color(0xFF69D8BA),
    practice: Color(0xFFA8C4FF),
    lab: Color(0xFFB7A0FF),
    exam: Color(0xFFFF718F),
    warn: Color(0xFFFFB56D),
    scrim: Color(0x99000000),
    isDark: true,
  );

  static Color accentColor(AppAccent accent, {required bool isDark}) {
    return switch (accent) {
      AppAccent.blue =>
        isDark ? const Color(0xFFA8C4FF) : const Color(0xFF3063DE),
      AppAccent.violet =>
        isDark ? const Color(0xFFA18AFF) : const Color(0xFF8064FF),
      AppAccent.green =>
        isDark ? const Color(0xFF55C7A4) : const Color(0xFF3B8F78),
      AppAccent.red =>
        isDark ? const Color(0xFFFF7478) : const Color(0xFFE5484D),
    };
  }

  AppColors withAccent(AppAccent selectedAccent) {
    final color = accentColor(selectedAccent, isDark: isDark);
    return copyWith(accent: color, practice: color);
  }

  double get tintMix => isDark ? .18 : .14;

  double get tint2Mix => isDark ? .34 : .28;

  Color tintOf(Color color, [double? amount]) {
    return Color.alphaBlend(
      color.withValues(alpha: amount ?? tintMix),
      surface,
    );
  }

  Color get tint => tintOf(accent);

  Color get tint2 => tintOf(accent, tint2Mix);

  Color get inkTint => tintOf(ink);

  Color get mutedTint => tintOf(muted);

  Color get lectureTint => tintOf(lecture);

  Color get practiceTint => tintOf(practice);

  Color get labTint => tintOf(lab);

  Color get examTint => tintOf(exam);

  Color get warnTint => tintOf(warn);

  Color get danger => exam;

  Color get dangerTint => examTint;

  Color get success => lecture;

  Color get successTint => lectureTint;

  Color get white => const Color(0xFFFFFFFF);

  Color get accentPressed =>
      Color.alphaBlend(ink.withValues(alpha: .18), accent);

  Color get primary => accent;

  Color get secondary => accent;

  Color get background01 => canvas;

  Color get background02 => surface;

  Color get background03 => surface2;

  Color get active => ink;

  Color get deactive => muted;

  Color get deactiveDarker => muted2;

  Color get activeLightMode => surface2;

  Color get divider => line;

  Color get surfaceHigh => surface2;

  Color get surfaceLow => surface2;

  Color get onSurface => ink;

  Color get warning => warn;

  Color get error => exam;

  Color get info => accent;

  Color get borderLight => line;

  Color get borderMedium => line;

  Color get cardShadowLight => const Color(0x00000000);

  Color get cardShadowDark => const Color(0x00000000);

  Color get shimmerBase => surface2;

  Color get shimmerHighlight => surface;

  Color get colorful01 => lab;

  Color get colorful02 => exam;

  Color get colorful03 => warn;

  Color get colorful04 => accent;

  Color get colorful05 => lecture;

  Color get colorful06 => warn;

  Color get colorful07 => exam;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppColors &&
          runtimeType == other.runtimeType &&
          canvas == other.canvas &&
          surface == other.surface &&
          surface2 == other.surface2 &&
          ink == other.ink &&
          muted == other.muted &&
          muted2 == other.muted2 &&
          line == other.line &&
          accent == other.accent &&
          onAccent == other.onAccent &&
          lecture == other.lecture &&
          practice == other.practice &&
          lab == other.lab &&
          exam == other.exam &&
          warn == other.warn &&
          scrim == other.scrim &&
          isDark == other.isDark;

  @override
  int get hashCode => Object.hash(
    runtimeType,
    canvas,
    surface,
    surface2,
    ink,
    muted,
    muted2,
    line,
    accent,
    onAccent,
    lecture,
    practice,
    lab,
    exam,
    warn,
    scrim,
    isDark,
  );

  @override
  AppColors copyWith({
    Color? canvas,
    Color? surface,
    Color? surface2,
    Color? ink,
    Color? muted,
    Color? muted2,
    Color? line,
    Color? accent,
    Color? onAccent,
    Color? lecture,
    Color? practice,
    Color? lab,
    Color? exam,
    Color? warn,
    Color? scrim,
    bool? isDark,
  }) {
    return AppColors(
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      muted2: muted2 ?? this.muted2,
      line: line ?? this.line,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      lecture: lecture ?? this.lecture,
      practice: practice ?? this.practice,
      lab: lab ?? this.lab,
      exam: exam ?? this.exam,
      warn: warn ?? this.warn,
      scrim: scrim ?? this.scrim,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t) ?? a;
    return AppColors(
      canvas: mix(canvas, other.canvas),
      surface: mix(surface, other.surface),
      surface2: mix(surface2, other.surface2),
      ink: mix(ink, other.ink),
      muted: mix(muted, other.muted),
      muted2: mix(muted2, other.muted2),
      line: mix(line, other.line),
      accent: mix(accent, other.accent),
      onAccent: mix(onAccent, other.onAccent),
      lecture: mix(lecture, other.lecture),
      practice: mix(practice, other.practice),
      lab: mix(lab, other.lab),
      exam: mix(exam, other.exam),
      warn: mix(warn, other.warn),
      scrim: mix(scrim, other.scrim),
      isDark: t < .5 ? isDark : other.isDark,
    );
  }
}

extension ThemeDataColorsX on ThemeData {
  AppColors get colors =>
      extension() ??
      (brightness == Brightness.dark ? AppColors.dark : AppColors.light);
}

extension BuildContextColorsX on BuildContext {
  AppColors get colors => Theme.of(this).colors;
}
