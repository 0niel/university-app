import 'package:app_ui/src/glass/app_glass_lite_mesh.dart';
import 'package:app_ui/src/glass/app_glass_lite_mesh_cache.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('shares identical geometry and invalidates size, radius and fade', () {
    final cache = AppGlassLiteMeshCache();
    final original = cache.obtain(
      size: const Size(360, 120),
      radius: 24,
      borderAlpha: 1,
    );
    expect(original, isNotNull);
    expect(
      cache.obtain(size: const Size(360, 120), radius: 24, borderAlpha: 1),
      same(original),
    );
    expect(
      cache.obtain(size: const Size(360, 120), radius: 24, borderAlpha: 2),
      same(original),
    );
    for (final (size, radius, alpha) in [
      (const Size(360, 121), 24.0, 1.0),
      (const Size(360, 120), 28.0, 1.0),
      (const Size(360, 120), 24.0, .3),
    ]) {
      expect(
        cache.obtain(size: size, radius: radius, borderAlpha: alpha),
        isNot(same(original)),
      );
    }
  });

  test('bounded LRU keeps recently painted geometry alive', () {
    final cache = AppGlassLiteMeshCache(maxEntries: 2);
    AppGlassLiteMesh? obtain(double width) => cache.obtain(
      size: Size(width, 56),
      radius: 24,
      borderAlpha: 1,
    );
    final first = obtain(180);
    final second = obtain(200);
    expect(obtain(180), same(first));
    obtain(220);
    expect(cache.entryCount, 2);
    expect(obtain(180), same(first));
    expect(obtain(200), isNot(same(second)));
    expect(cache.entryCount, 2);
    expect(cache.byteSize, lessThanOrEqualTo(cache.maxBytes));
  });

  test('oversized entries can still render without exceeding cache budget', () {
    final cache = AppGlassLiteMeshCache(maxBytes: 1);
    final mesh = cache.obtain(
      size: const Size(360, 120),
      radius: 24,
      borderAlpha: 1,
    );
    expect(mesh, isNotNull);
    expect(mesh!.vertexCount, greaterThan(0));
    expect(mesh.triangleCount, greaterThan(0));
    expect(cache.entryCount, 0);
    expect(cache.byteSize, 0);
  });

  test(
    'invalid and completely transparent geometry does not fill the cache',
    () {
      final cache = AppGlassLiteMeshCache();
      for (final (size, radius, alpha) in [
        (Size.zero, 24.0, 1.0),
        (const Size(double.infinity, 56), 24.0, 1.0),
        (const Size(180, 56), double.nan, 1.0),
        (const Size(180, 56), 24.0, double.nan),
        (const Size(180, 56), 24.0, .0),
        (const Size(180, 56), 24.0, .00001),
      ]) {
        expect(
          cache.obtain(size: size, radius: radius, borderAlpha: alpha),
          isNull,
        );
      }
      expect(cache.entryCount, 0);
      expect(cache.byteSize, 0);
    },
  );
}
