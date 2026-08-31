import 'package:app_ui/src/colors/colors.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

@immutable
class NinjaColors extends ThemeExtension<NinjaColors> {
  const NinjaColors({
    required this.canvas,
    required this.ink,
    required this.onInk,
    required this.pressedInk,
    required this.indigo,
    required this.scarlet,
    required this.lime,
    required this.green,
    required this.orange,
    required this.amber,
    required this.amberInk,
    required this.surface,
    required this.surfaceAlt,
    required this.line,
    required this.lineSoft,
    required this.muted,
    required this.mutedDark,
    required this.disabled,
    required this.disabledLine,
    required this.chevron,
    required this.dangerTint,
    required this.dangerBorder,
    required this.warnTint,
    required this.warnBorder,
    required this.successTint,
    required this.successBorder,
    required this.infoTint,
    required this.infoBorder,
    required this.isDark,
  });

  factory NinjaColors.light() =>
      NinjaColors.fromAppColors(AppColors.light, isDark: false);

  factory NinjaColors.dark() =>
      NinjaColors.fromAppColors(AppColors.dark, isDark: true);

  factory NinjaColors.fromAppColors(
    AppColors colors, {
    required bool isDark,
  }) {
    final mutedDark = Color.alphaBlend(
      colors.active.withValues(alpha: isDark ? 0.72 : 0.68),
      colors.background01,
    );
    final disabled = Color.alphaBlend(
      colors.deactiveDarker,
      colors.background01,
    );
    return NinjaColors(
      canvas: colors.background01,
      ink: colors.active,
      onInk: colors.background01,
      pressedInk: colors.active.withValues(alpha: 0.82),
      indigo: colors.primary,
      scarlet: colors.error,
      lime: colors.primary,
      green: colors.success,
      orange: colors.colorful03,
      amber: colors.warning,
      amberInk: isDark ? colors.warning : const Color(0xFF704800),
      surface: colors.surface,
      surfaceAlt: colors.surfaceHigh,
      line: colors.divider,
      lineSoft: colors.divider.withValues(alpha: 0.55),
      muted: colors.deactive,
      mutedDark: mutedDark,
      disabled: disabled,
      disabledLine: colors.divider,
      chevron: disabled,
      dangerTint: colors.error.withValues(alpha: 0.1),
      dangerBorder: Colors.transparent,
      warnTint: colors.warning.withValues(alpha: 0.12),
      warnBorder: Colors.transparent,
      successTint: colors.success.withValues(alpha: 0.12),
      successBorder: Colors.transparent,
      infoTint: colors.primary.withValues(alpha: 0.12),
      infoBorder: Colors.transparent,
      isDark: isDark,
    );
  }

  final Color canvas;
  final Color ink;
  final Color onInk;
  final Color pressedInk;
  final Color indigo;
  final Color scarlet;
  final Color lime;
  final Color green;
  final Color orange;
  final Color amber;
  final Color amberInk;
  final Color surface;
  final Color surfaceAlt;
  final Color line;
  final Color lineSoft;
  final Color muted;
  final Color mutedDark;
  final Color disabled;
  final Color disabledLine;
  final Color chevron;
  final Color dangerTint;
  final Color dangerBorder;
  final Color warnTint;
  final Color warnBorder;
  final Color successTint;
  final Color successBorder;
  final Color infoTint;
  final Color infoBorder;
  final bool isDark;

  Color get brand => indigo;

  Color get brandInk {
    final tintSurface = Color.alphaBlend(brandTint, surface);
    final selectedSurface = Color.alphaBlend(
      brand.withValues(alpha: isDark ? 0.2 : 0.1),
      surface,
    );
    for (var step = 0; step <= 20; step++) {
      final candidate = Color.lerp(brand, ink, step / 20) ?? ink;
      if (_contrastRatio(candidate, tintSurface) >= 4.5 &&
          _contrastRatio(candidate, selectedSurface) >= 4.5) {
        return candidate;
      }
    }
    return ink;
  }

  Color get onBrand => contrastForeground(brand);
  Color get brandTint => infoTint;
  Color get accentSoft =>
      Color.lerp(brand, Colors.white, isDark ? 0.6 : 0.78) ?? brand;
  Color get onAccentSoft => const Color(0xFF0F1014);
  Color get onAccentSoftMuted => const Color(0xB30F1014);
  Color get onScarlet => isDark ? onInk : ink;
  Color get ninjaOnScarlet => onScarlet;

  Color contrastForeground(Color background) {
    final inkContrast = _contrastRatio(ink, background);
    final inverseContrast = _contrastRatio(onInk, background);
    return inkContrast >= inverseContrast ? ink : onInk;
  }

  List<Color> get mireaAccentPalette => const [
        Color(0xFFB26497),
        Color(0xFFEB7225),
        Color(0xFFB4462A),
        Color(0xFF731E6C),
        Color(0xFFEBB804),
        Color(0xFF086A81),
        Color(0xFF047A35),
        Color(0xFF706F6F),
      ];

  List<Color> get subjectPalette => [
        for (final accent in mireaAccentPalette) accentInk(accent),
      ];

  Color accentInk(Color accent) {
    for (var step = 0; step <= 24; step++) {
      final candidate = Color.lerp(accent, ink, step / 24) ?? ink;
      if (_contrastRatio(candidate, canvas) >= 4.5 &&
          _contrastRatio(candidate, surface) >= 4.5 &&
          _contrastRatio(candidate, surfaceAlt) >= 4.5) {
        return candidate;
      }
    }
    return ink;
  }

  Color accentOn(Color accent, Color background) {
    final target = contrastForeground(background);
    for (var step = 0; step <= 24; step++) {
      final candidate = Color.lerp(accent, target, step / 24) ?? target;
      if (_contrastRatio(candidate, background) >= 4.5) return candidate;
    }
    return target;
  }

  Color subjectBaseColor(String subject) {
    var hash = 0;
    for (final codeUnit in subject.codeUnits) {
      hash = (hash * 31 + codeUnit) & 0x7fffffff;
    }
    return mireaAccentPalette.elementAtOrNull(
          hash % mireaAccentPalette.length,
        ) ??
        brand;
  }

  Color subjectColor(String subject) => accentInk(subjectBaseColor(subject));

  @override
  NinjaColors copyWith({
    Color? canvas,
    Color? ink,
    Color? onInk,
    Color? pressedInk,
    Color? indigo,
    Color? scarlet,
    Color? lime,
    Color? green,
    Color? orange,
    Color? amber,
    Color? amberInk,
    Color? surface,
    Color? surfaceAlt,
    Color? line,
    Color? lineSoft,
    Color? muted,
    Color? mutedDark,
    Color? disabled,
    Color? disabledLine,
    Color? chevron,
    Color? dangerTint,
    Color? dangerBorder,
    Color? warnTint,
    Color? warnBorder,
    Color? successTint,
    Color? successBorder,
    Color? infoTint,
    Color? infoBorder,
    bool? isDark,
  }) {
    return NinjaColors(
      canvas: canvas ?? this.canvas,
      ink: ink ?? this.ink,
      onInk: onInk ?? this.onInk,
      pressedInk: pressedInk ?? this.pressedInk,
      indigo: indigo ?? this.indigo,
      scarlet: scarlet ?? this.scarlet,
      lime: lime ?? this.lime,
      green: green ?? this.green,
      orange: orange ?? this.orange,
      amber: amber ?? this.amber,
      amberInk: amberInk ?? this.amberInk,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      line: line ?? this.line,
      lineSoft: lineSoft ?? this.lineSoft,
      muted: muted ?? this.muted,
      mutedDark: mutedDark ?? this.mutedDark,
      disabled: disabled ?? this.disabled,
      disabledLine: disabledLine ?? this.disabledLine,
      chevron: chevron ?? this.chevron,
      dangerTint: dangerTint ?? this.dangerTint,
      dangerBorder: dangerBorder ?? this.dangerBorder,
      warnTint: warnTint ?? this.warnTint,
      warnBorder: warnBorder ?? this.warnBorder,
      successTint: successTint ?? this.successTint,
      successBorder: successBorder ?? this.successBorder,
      infoTint: infoTint ?? this.infoTint,
      infoBorder: infoBorder ?? this.infoBorder,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  NinjaColors lerp(ThemeExtension<NinjaColors>? other, double t) {
    if (other is! NinjaColors) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t) ?? a;
    return NinjaColors(
      canvas: mix(canvas, other.canvas),
      ink: mix(ink, other.ink),
      onInk: mix(onInk, other.onInk),
      pressedInk: mix(pressedInk, other.pressedInk),
      indigo: mix(indigo, other.indigo),
      scarlet: mix(scarlet, other.scarlet),
      lime: mix(lime, other.lime),
      green: mix(green, other.green),
      orange: mix(orange, other.orange),
      amber: mix(amber, other.amber),
      amberInk: mix(amberInk, other.amberInk),
      surface: mix(surface, other.surface),
      surfaceAlt: mix(surfaceAlt, other.surfaceAlt),
      line: mix(line, other.line),
      lineSoft: mix(lineSoft, other.lineSoft),
      muted: mix(muted, other.muted),
      mutedDark: mix(mutedDark, other.mutedDark),
      disabled: mix(disabled, other.disabled),
      disabledLine: mix(disabledLine, other.disabledLine),
      chevron: mix(chevron, other.chevron),
      dangerTint: mix(dangerTint, other.dangerTint),
      dangerBorder: mix(dangerBorder, other.dangerBorder),
      warnTint: mix(warnTint, other.warnTint),
      warnBorder: mix(warnBorder, other.warnBorder),
      successTint: mix(successTint, other.successTint),
      successBorder: mix(successBorder, other.successBorder),
      infoTint: mix(infoTint, other.infoTint),
      infoBorder: mix(infoBorder, other.infoBorder),
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}

double _contrastRatio(Color foreground, Color background) {
  final foregroundLuminance = foreground.computeLuminance();
  final backgroundLuminance = background.computeLuminance();
  final lighter = foregroundLuminance > backgroundLuminance
      ? foregroundLuminance
      : backgroundLuminance;
  final darker = foregroundLuminance > backgroundLuminance
      ? backgroundLuminance
      : foregroundLuminance;
  return (lighter + 0.05) / (darker + 0.05);
}

extension NinjaColorsX on BuildContext {
  NinjaColors get ninja => Theme.of(this).extension() ?? NinjaColors.light();
}
