import 'package:flutter/widgets.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart' as renderer;

abstract final class AppGlassOptics {
  static renderer.LiquidGlassSettings settingsFor(Brightness brightness) {
    final settings = renderer.LiquidGlassSettings.ios27Regular(
      brightness: brightness,
    );
    if (brightness == Brightness.light) return settings;
    return settings.copyWith(
      refractionHeight: 5,
      refractionAmount: 8,
      highlight: .10,
      contourStrength: .12,
      bevelShadowStrength: .008,
    );
  }

  static Color tintFor(Color color, Brightness brightness) => color.withValues(
    alpha: color.a <= .3
        ? color.a
        : color.a * (brightness == Brightness.dark ? .94 : .22),
  );
}
