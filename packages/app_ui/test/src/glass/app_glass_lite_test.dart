import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/glass/app_glass_lite.dart';
import 'package:app_ui/src/glass/app_glass_lite_mesh_cache.dart';
import 'package:app_ui/src/glass/app_glass_lite_outline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

void main() {
  testWidgets('retains exact Lite pixels over an opaque detailed backdrop', (
    tester,
  ) async {
    for (final colors in [AppColors.dark, AppColors.light]) {
      for (final (size, radius) in [
        (const Size(44, 44), 22.0),
        (const Size(180, 56), 28.0),
        (const Size(360, 120), 24.0),
        (const Size(390.5, 82.25), 18.5),
        (const Size(96, 240), 16.0),
        (const Size(10, 10), .0),
      ]) {
        for (final role in [AppGlassRole.content, AppGlassRole.pinned]) {
          final style = AppGlassStyle.surface(
            colors: colors,
            radius: radius,
            tone: AppGlassTone.regular,
            highContrast: false,
            role: role,
          );
          final reference = <double, Uint8List>{};
          await tester.pumpWidget(
            _Fixture(
              size: size,
              child: _glass(style, radius: radius, cached: false),
            ),
          );
          for (final ratio in [1.0, 2.0, 3.0]) {
            reference[ratio] = await _pixels(tester, ratio);
            expect(reference[ratio]!.every((value) => value == 0), isFalse);
          }
          await tester.pumpWidget(
            _Fixture(
              size: size,
              child: _glass(style, radius: radius, cached: true),
            ),
          );
          expect(
            tester
                .widget<LiquidGlassLite>(find.byType(LiquidGlassLite))
                .borderAlpha,
            0,
          );
          for (final ratio in [1.0, 2.0, 3.0]) {
            final optimized = await _pixels(tester, ratio);
            expect(
              _firstDifference(reference[ratio]!, optimized),
              -1,
              reason:
                  '$role, $size, radius=$radius, '
                  'DPR=$ratio, dark=${colors.isDark}',
            );
          }
        }
      }
    }
  });

  testWidgets('preserves fade, custom lighting, shape and zoom behavior', (
    tester,
  ) async {
    const rim = AppGlassStyle.rim;
    for (final (shape, light, glow, zoom, alpha) in [
      (
        const LiquidGlassShape.roundedRectangle(cornerRadius: 24),
        rim,
        null,
        1.0,
        .01,
      ),
      (
        const LiquidGlassShape.roundedRectangle(cornerRadius: 24),
        rim,
        null,
        1.0,
        .3,
      ),
      (
        const LiquidGlassShape.roundedRectangle(cornerRadius: 24),
        rim,
        null,
        1.0,
        2.0,
      ),
      (
        const LiquidGlassShape.squircle(cornerRadius: 24),
        const LiquidGlassLight.specular(color: Colors.orange),
        const LiquidGlassLight.glow(intensity: .8),
        1.0,
        .7,
      ),
      (
        const LiquidGlassShape.roundedRectangle(cornerRadius: 24),
        rim,
        null,
        1.2,
        1.0,
      ),
    ]) {
      Widget glass({required bool cached}) => cached
          ? AppGlassLite(
              shape: shape,
              specular: light,
              glow: glow,
              magnification: zoom,
              borderAlpha: alpha,
              blur: 6,
              color: const Color(0x8917222d),
              child: const SizedBox.expand(),
            )
          : LiquidGlassLite(
              shape: shape,
              specular: light,
              glow: glow,
              magnification: zoom,
              borderAlpha: alpha,
              blur: 6,
              color: const Color(0x8917222d),
              child: const SizedBox.expand(),
            );
      await tester.pumpWidget(
        _Fixture(size: const Size(180, 56), child: glass(cached: false)),
      );
      final reference = await _pixels(tester, 2);
      await tester.pumpWidget(
        _Fixture(size: const Size(180, 56), child: glass(cached: true)),
      );
      expect(_firstDifference(reference, await _pixels(tester, 2)), -1);
    }
  });

  testWidgets('keeps frost active and retains two rim passes', (tester) async {
    final style = AppGlassStyle.surface(
      colors: AppColors.dark,
      radius: 24,
      tone: AppGlassTone.regular,
      highContrast: false,
      role: AppGlassRole.pinned,
    );
    await tester.pumpWidget(
      _Fixture(
        size: const Size(360, 120),
        child: _glass(style, radius: 24, cached: false),
      ),
    );
    final referencePainter = _foregroundPainter(tester, cached: false);
    await tester.pumpWidget(
      _Fixture(
        size: const Size(360, 120),
        child: _glass(style, radius: 24, cached: true),
      ),
    );
    final cachedPainter = _foregroundPainter(tester, cached: true);
    final frosted = await _pixels(tester, 2);
    await tester.pumpWidget(
      _Fixture(
        size: const Size(360, 120),
        child: _glass(style.copyWith(blur: 0), radius: 24, cached: true),
      ),
    );
    expect(_firstDifference(frosted, await _pixels(tester, 2)), isNot(-1));
    const size = Size(360, 120);
    expect(
      (Canvas canvas) => cachedPainter.paint(canvas, size),
      paintsExactlyCountTimes(#drawVertices, 2),
    );
    for (var index = 0; index < 10; index++) {
      _recordPaint(referencePainter, size);
      _recordPaint(cachedPainter, size);
    }
    const batchSize = 40;
    final referenceTimes = <int>[];
    final cachedTimes = <int>[];
    for (var batch = 0; batch < 5; batch++) {
      referenceTimes.add(_paintBatch(referencePainter, size, batchSize));
      cachedTimes.add(_paintBatch(cachedPainter, size, batchSize));
    }
    referenceTimes.sort();
    cachedTimes.sort();
    final mesh = AppGlassLiteMeshCache.shared.obtain(
      size: size,
      radius: 24,
      borderAlpha: 1,
    )!;
    final samples = AppGlassLiteOutline.build(size, 24)!.count;
    debugPrint(
      jsonEncode({
        'measurement': 'host_cpu_picture_recording_not_gpu_or_fps',
        'iterations_per_variant': batchSize * 5,
        'reference_median_us_per_paint': referenceTimes[2] / batchSize,
        'cached_median_us_per_paint': cachedTimes[2] / batchSize,
        'reference_vertices': samples * 9,
        'cached_vertices': mesh.vertexCount,
        'reference_triangles': samples * 16,
        'cached_triangles': mesh.triangleCount,
        'cached_mesh_bytes': mesh.byteSize,
        'draw_calls': 2,
      }),
    );
  });
}

Widget _glass(
  LiquidGlassStyle style, {
  required double radius,
  required bool cached,
}) {
  const glow = LiquidGlassLight.glow(thickness: 0);
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: cached
        ? AppGlassLite(
            shape: style.shape!,
            specular: style.specular,
            glow: glow,
            blur: style.blur,
            color: style.color,
            child: const SizedBox.expand(),
          )
        : LiquidGlassLite(
            shape: style.shape!,
            specular: style.specular,
            glow: glow,
            blur: style.blur,
            color: style.color,
            child: const SizedBox.expand(),
          ),
  );
}

CustomPainter _foregroundPainter(WidgetTester tester, {required bool cached}) =>
    tester
        .widget<CustomPaint>(
          find.descendant(
            of: cached
                ? find.byType(AppGlassLite)
                : find.byType(LiquidGlassLite),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is CustomPaint && widget.foregroundPainter != null,
            ),
          ),
        )
        .foregroundPainter!;

void _recordPaint(CustomPainter painter, Size size) {
  final recorder = ui.PictureRecorder();
  painter.paint(Canvas(recorder), size);
  recorder.endRecording().dispose();
}

int _paintBatch(CustomPainter painter, Size size, int count) {
  final watch = Stopwatch()..start();
  for (var index = 0; index < count; index++) {
    _recordPaint(painter, size);
  }
  watch.stop();
  return watch.elapsedMicroseconds;
}

Future<Uint8List> _pixels(WidgetTester tester, double ratio) async =>
    (await tester.runAsync(() async {
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(const ValueKey('capture')),
      );
      final image = await boundary.toImage(pixelRatio: ratio);
      try {
        return (await image.toByteData())!.buffer.asUint8List();
      } finally {
        image.dispose();
      }
    }))!;

int _firstDifference(Uint8List first, Uint8List second) {
  if (first.length != second.length) return 0;
  for (var index = 0; index < first.length; index++) {
    if (first[index] != second[index]) return index;
  }
  return -1;
}

class _Fixture extends StatelessWidget {
  const _Fixture({required this.size, required this.child});

  final Size size;
  final Widget child;

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Center(
      child: RepaintBoundary(
        key: const ValueKey('capture'),
        child: SizedBox(
          width: size.width + 2,
          height: size.height + 2,
          child: Stack(
            children: [
              const Positioned.fill(child: CustomPaint(painter: _Backdrop())),
              Positioned(
                left: .25,
                top: .375,
                width: size.width,
                height: size.height,
                child: child,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _Backdrop extends CustomPainter {
  const _Backdrop();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var row = 0; row * 16 < size.height; row++) {
      for (var column = 0; column * 16 < size.width; column++) {
        paint.color = (row + column).isEven
            ? const Color(0xff123a59)
            : const Color(0xffcf6b84);
        canvas.drawRect(
          Rect.fromLTWH(column * 16, row * 16, 16, 16),
          paint,
        );
      }
    }
    canvas.drawCircle(
      Offset(size.width * .3, size.height * .5),
      size.height * .3,
      paint..color = const Color(0xff45c9a3),
    );
  }

  @override
  bool shouldRepaint(_Backdrop oldDelegate) => false;
}
