import 'package:app_ui/src/glass/app_glass_lite_mesh.dart';
import 'package:app_ui/src/glass/app_glass_lite_mesh_cache.dart';
import 'package:flutter/widgets.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

class AppGlassLite extends StatelessWidget {
  const AppGlassLite({
    required this.shape,
    this.specular,
    this.glow,
    this.borderAlpha = 1,
    this.blur = 3,
    this.magnification = 1,
    this.color,
    this.shapeScale = const Offset(1, 1),
    this.child,
    super.key,
  });

  static const _rim = LiquidGlassLight.specular(
    thickness: 1.5,
    sharpness: .22,
    intensity: .45,
  );

  final LiquidGlassShape shape;
  final LiquidGlassLight? specular;
  final LiquidGlassLight? glow;
  final double borderAlpha;
  final double blur;
  final double magnification;
  final Color? color;
  final Offset shapeScale;
  final Widget? child;

  bool get _canCacheRim =>
      shape.runtimeType == LiquidGlassShape &&
      shape.cornerStyle == LiquidGlassCornerStyle.roundedRectangle &&
      shape.cornerRadius.isFinite &&
      shape.cornerRadius >= 0 &&
      shapeScale == const Offset(1, 1) &&
      magnification == 1 &&
      specular == _rim &&
      (glow == null || glow!.thickness <= 0) &&
      borderAlpha.isFinite &&
      borderAlpha > 0;

  @override
  Widget build(BuildContext context) {
    final cacheRim = _canCacheRim;
    final surface = LiquidGlassLite(
      shape: shape,
      specular: specular,
      glow: glow,
      borderAlpha: cacheRim ? 0 : borderAlpha,
      blur: blur,
      magnification: magnification,
      color: color,
      shapeScale: shapeScale,
      child: child,
    );
    if (!cacheRim) return surface;
    return CustomPaint(
      foregroundPainter: _AppGlassLiteRimPainter(
        radius: shape.cornerRadius,
        borderAlpha: borderAlpha,
      ),
      child: surface,
    );
  }
}

class _AppGlassLiteRimPainter extends CustomPainter {
  _AppGlassLiteRimPainter({required this.radius, required this.borderAlpha});

  static final _overlay = Paint()
    ..color = const Color(0xffffffff)
    ..blendMode = BlendMode.overlay;
  static final _screen = Paint()
    ..color = const Color.fromRGBO(255, 255, 255, .8)
    ..blendMode = BlendMode.screen;

  final double radius;
  final double borderAlpha;
  Size? _size;
  AppGlassLiteMesh? _mesh;

  @override
  void paint(Canvas canvas, Size size) {
    if (_size != size) {
      _mesh = AppGlassLiteMeshCache.shared.obtain(
        size: size,
        radius: radius,
        borderAlpha: borderAlpha,
      );
      _size = size;
    }
    final mesh = _mesh;
    if (mesh == null) return;
    canvas
      ..save()
      ..clipPath(mesh.path)
      ..drawVertices(mesh.vertices, BlendMode.modulate, _overlay)
      ..drawVertices(mesh.vertices, BlendMode.modulate, _screen)
      ..restore();
  }

  @override
  bool shouldRepaint(_AppGlassLiteRimPainter oldDelegate) =>
      oldDelegate.radius != radius || oldDelegate.borderAlpha != borderAlpha;
}
