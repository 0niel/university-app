import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/app/theme/app_color_scheme.dart';

export 'app_color_scheme.dart';

class AppColorSchemes {
  static const AppColorScheme defaultScheme = .blue;

  static AppColors getLightColors(AppColorScheme scheme) {
    return _applyAccent(.light, scheme, isDark: false);
  }

  static AppColors getDarkColors(AppColorScheme scheme) {
    return _applyAccent(.dark, scheme, isDark: true);
  }

  static Color getSchemePreviewColor(AppColorScheme scheme) {
    return switch (scheme) {
      .blue => const Color(0xFF2F7AFF),
      .violet => const Color(0xFF8064FF),
      .yellow => const Color(0xFFE9B949),
      .red => const Color(0xFFE5484D),
      .green => const Color(0xFF3B8F78),
    };
  }

  static List<Color> getSchemePalette(AppColorScheme scheme) {
    final accent = getSchemePreviewColor(scheme);
    final onAccent = _foregroundFor(accent);

    return [
      accent,
      Color.alphaBlend(accent.withValues(alpha: 0.16), AppColors.light.surface),
      onAccent,
    ];
  }

  static AppColors _applyAccent(
    AppColors base,
    AppColorScheme scheme, {
    required bool isDark,
  }) {
    final accent = isDark ? _darkAccent(scheme) : getSchemePreviewColor(scheme);
    final onAccent = _foregroundFor(accent);

    return base.copyWith(
      primary: accent,
      accent: accent,
      secondary: accent,
      onAccent: onAccent,
    );
  }

  static Color _darkAccent(AppColorScheme scheme) => switch (scheme) {
    .blue => const Color(0xFF78A7FF),
    .violet => const Color(0xFFA18AFF),
    .yellow => const Color(0xFFF0C866),
    .red => const Color(0xFFFF7478),
    .green => const Color(0xFF55C7A4),
  };

  static Color _foregroundFor(Color background) {
    const ink = Color(0xFF101014);
    const white = Colors.white;
    return _contrast(ink, background) >= _contrast(white, background)
        ? ink
        : white;
  }

  static double _contrast(Color foreground, Color background) {
    final first = foreground.computeLuminance();
    final second = background.computeLuminance();
    final lighter = first > second ? first : second;
    final darker = first > second ? second : first;
    return (lighter + .05) / (darker + .05);
  }
}
