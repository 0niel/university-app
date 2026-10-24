import 'package:app_ui/src/glass/app_glass_backend.dart';
import 'package:app_ui/src/glass/app_glass_optics.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart' as renderer;

class AppGlassRenderer extends StatelessWidget {
  const AppGlassRenderer({
    required this.style,
    required this.borderRadius,
    super.key,
  });

  final LiquidGlassStyle style;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    if (!AppGlassBackend.useGpu) {
      final lens = LiquidGlassLens(
        style: style,
        child: const SizedBox.expand(),
      );
      return AppGlassPhysicalViewport(
        child: LiquidGlassBatch.backdropIdOf(context) == null
            ? LiquidGlassBatch(child: lens)
            : lens,
      );
    }
    final brightness = Theme.of(context).brightness;
    final appearance = renderer.LiquidGlassAppearance.ios27Regular(
      brightness: brightness,
      tint: AppGlassOptics.tintFor(style.color, brightness),
    );
    final shape = renderer.LiquidRoundedRectangle(borderRadius: borderRadius);
    if (AppGlassRendererScope.sharesLayerOf(context)) {
      return AppGlassPhysicalViewport(
        child: renderer.LiquidGlass(
          appearance: appearance,
          shape: shape,
          child: const SizedBox.expand(),
        ),
      );
    }
    return AppGlassPhysicalViewport(
      child: renderer.LiquidGlass.withOwnLayer(
        settings: AppGlassOptics.settingsFor(brightness),
        appearance: appearance,
        shape: shape,
        backdropKey: AppGlassRendererScope.of(context),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class AppGlassPhysicalViewport extends StatelessWidget {
  const AppGlassPhysicalViewport({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      MediaQuery.fromView(view: View.of(context), child: child);
}

class AppGlassRendererScope extends InheritedWidget {
  const AppGlassRendererScope({
    required this.backdropKey,
    required super.child,
    this.sharedLayer = false,
    super.key,
  });

  final BackdropKey? backdropKey;
  final bool sharedLayer;

  static BackdropKey? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<AppGlassRendererScope>()
      ?.backdropKey;

  static bool sharesLayerOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<AppGlassRendererScope>()
          ?.sharedLayer ??
      false;

  @override
  bool updateShouldNotify(AppGlassRendererScope oldWidget) =>
      backdropKey != oldWidget.backdropKey ||
      sharedLayer != oldWidget.sharedLayer;
}
