import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/glass/app_glass_role.dart';
import 'package:app_ui/src/glass/app_glass_tone.dart';
import 'package:flutter/painting.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

export 'app_glass_role.dart';
export 'app_glass_tone.dart';

abstract final class AppGlassStyle {
  static const rim = LiquidGlassLight.specular(
    thickness: 1.5,
    sharpness: .22,
    intensity: .45,
  );
  static const glow = LiquidGlassLight.glow(thickness: 4, intensity: .05);
  static const floatingRim = LiquidGlassLight.specular(
    thickness: 1.6,
    sharpness: .3,
    intensity: .65,
  );
  static const _noRim = LiquidGlassLight.specular(thickness: 0, intensity: 0);

  static LiquidGlassStyle surface({
    required AppColors colors,
    required double radius,
    required AppGlassTone tone,
    required bool highContrast,
    AppGlassRole role = AppGlassRole.content,
    Color? tint,
    Color? baseColor,
    bool selected = false,
  }) {
    final base =
        baseColor ??
        (selected
            ? highContrast
                  ? colors.tint
                  : colors.accent
            : tone == AppGlassTone.accent
            ? colors.tintOf(tint ?? colors.accent, .13)
            : colors.surface);
    final (opacity, blur, refraction, band) = switch (role) {
      AppGlassRole.content => (colors.isDark ? .94 : .97, 0.0, 1.0, 0.0),
      AppGlassRole.control => (colors.isDark ? .64 : .76, 6.0, 1.019, 12.0),
      AppGlassRole.pinned => (colors.isDark ? .9 : .94, 6.0, 1.0, 0.0),
      AppGlassRole.navigation => (colors.isDark ? .78 : .88, 8.0, 1.016, 12.0),
      AppGlassRole.overlay => (colors.isDark ? .9 : .95, 8.0, 1.012, 12.0),
      AppGlassRole.sheet => (colors.isDark ? .9 : .95, 6.0, 1.0, 0.0),
    };
    return LiquidGlassStyle(
      shape: LiquidGlassShape.roundedRectangle(cornerRadius: radius),
      specular: switch (role) {
        AppGlassRole.pinned || AppGlassRole.sheet => _noRim,
        AppGlassRole.content => rim,
        AppGlassRole.control ||
        AppGlassRole.navigation ||
        AppGlassRole.overlay => highContrast ? rim : floatingRim,
      },
      glow: glow,
      color: base.withValues(
        alpha: highContrast
            ? .98
            : selected
            ? .18
            : opacity,
      ),
      blur: switch (role) {
        AppGlassRole.content => 0,
        AppGlassRole.pinned || AppGlassRole.sheet => highContrast ? 0 : blur,
        AppGlassRole.control ||
        AppGlassRole.navigation ||
        AppGlassRole.overlay => highContrast ? 8 : blur,
      },
      refractionIndex: refraction,
      refractionWidth: band,
      liteGlass:
          highContrast ||
          role == AppGlassRole.content ||
          role == AppGlassRole.pinned ||
          role == AppGlassRole.sheet,
    );
  }
}
