import 'package:app_ui/src/glass/app_glass_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

class AppGlassLens extends StatelessWidget {
  const AppGlassLens({
    required this.style,
    required this.child,
    required this.borderRadius,
    required this.fallbackColor,
    super.key,
  });

  final LiquidGlassStyle style;
  final Widget child;
  final double borderRadius;
  final Color fallbackColor;

  @override
  Widget build(BuildContext context) {
    final enabled = AppGlassTheme.of(context).enabled;
    final Widget background;
    if (!enabled) {
      background = ColoredBox(color: fallbackColor);
    } else if (style.liteGlass) {
      final glass = LiquidGlassLite(
        shape:
            style.shape ??
            LiquidGlassShape.roundedRectangle(cornerRadius: borderRadius),
        specular: style.specular,
        glow: style.glow,
        blur: style.blur,
        magnification: style.magnification,
        color: style.color,
        child: const SizedBox.expand(),
      );
      background = style.magnification == 1
          ? RepaintBoundary(child: glass)
          : glass;
    } else {
      final media = MediaQuery.of(context);
      final view = View.of(context);
      background = MediaQuery(
        data: media.copyWith(
          size: view.physicalSize / view.devicePixelRatio,
          devicePixelRatio: view.devicePixelRatio,
        ),
        child: LiquidGlassLens(style: style, child: const SizedBox.expand()),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(
            child: ExcludeSemantics(
              child: IgnorePointer(
                child: background,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
