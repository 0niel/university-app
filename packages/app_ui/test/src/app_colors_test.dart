import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('palette equality includes every semantic token', () {
    const colors = AppColors.dark;
    expect(colors.copyWith(), colors);
    expect(colors.copyWith().hashCode, colors.hashCode);
    final variants = [
      colors.copyWith(canvas: Colors.red),
      colors.copyWith(surface: Colors.red),
      colors.copyWith(surface2: Colors.red),
      colors.copyWith(ink: Colors.red),
      colors.copyWith(muted: Colors.red),
      colors.copyWith(muted2: Colors.red),
      colors.copyWith(line: Colors.red),
      colors.copyWith(accent: Colors.red),
      colors.copyWith(onAccent: Colors.red),
      colors.copyWith(lecture: Colors.red),
      colors.copyWith(practice: Colors.red),
      colors.copyWith(lab: Colors.red),
      colors.copyWith(exam: Colors.red),
      colors.copyWith(warn: Colors.red),
      colors.copyWith(scrim: Colors.red),
      colors.copyWith(isDark: false),
    ];
    for (final variant in variants) {
      expect(variant, isNot(colors));
    }
  });

  test('divider opacity matches the reference and softens multiplicatively',
      () {
    for (final colors in [AppColors.light, AppColors.dark]) {
      expect(colors.line.a, .08);
      final bridge = NinjaColors.fromAppColors(colors, isDark: colors.isDark);
      expect(bridge.line, colors.line);
      expect(bridge.lineSoft.a, closeTo(.044, .0000001));
    }
    expect(AppColors.light.scrim.a, .42);
  });

  testWidgets('bridge fallback follows dark theme without its extension', (
    tester,
  ) async {
    late NinjaColors colors;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(brightness: Brightness.dark),
        home: Builder(
          builder: (context) {
            colors = context.ninja;
            return const SizedBox();
          },
        ),
      ),
    );
    expect(colors.canvas, AppColors.dark.canvas);
    expect(colors.surface, AppColors.dark.surface);
    expect(colors.ink, AppColors.dark.ink);
    expect(colors.isDark, isTrue);
  });
}
