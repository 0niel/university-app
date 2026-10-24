import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/glass/app_glass_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart' as renderer;

void main() {
  setUp(AppGlassBackend.reset);
  tearDown(AppGlassBackend.reset);

  test('capability is resolved once and defaults to GPU before warmup', () {
    var calls = 0;
    expect(AppGlassBackend.useGpu, isTrue);
    AppGlassBackend.capabilityProbeOverride = () {
      calls++;
      return false;
    };
    AppGlassBackend.initialize();
    AppGlassBackend.initialize();
    expect(calls, 1);
    expect(AppGlassBackend.useGpu, isFalse);
  });

  for (final available in [false, true]) {
    testWidgets('capability selects refractive backend, GPU=$available', (
      tester,
    ) async {
      AppGlassBackend.capabilityProbeOverride = () => available;
      AppGlassBackend.initialize();
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Center(
            child: AppGlassBatch.controls(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppGlassSurface(
                    role: AppGlassRole.control,
                    child: SizedBox(width: 80, height: 48),
                  ),
                  SizedBox(width: 12),
                  AppGlassSurface(
                    role: AppGlassRole.control,
                    child: SizedBox(width: 80, height: 48),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.byType(renderer.LiquidGlassLayer),
        available ? findsOneWidget : findsNothing,
      );
      final legacy = find.byType(LiquidGlassLens);
      expect(legacy, available ? findsNothing : findsNWidgets(2));
      if (!available) {
        final lenses = tester.widgetList<LiquidGlassLens>(legacy).toList();
        for (final lens in lenses) {
          expect(lens.style.liteGlass, isFalse);
          expect(lens.style.refractionIndex, greaterThan(1));
        }
        final elements = legacy.evaluate().toList();
        final backdrop = LiquidGlassBatch.backdropIdOf(elements.first);
        expect(backdrop, isNotNull);
        expect(LiquidGlassBatch.backdropIdOf(elements.last), backdrop);
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('legacy nested lenses keep independent backdrop reads', (
    tester,
  ) async {
    AppGlassBackend.capabilityProbeOverride = () => false;
    AppGlassBackend.initialize();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const Center(
          child: AppGlassBatch.controls(
            child: AppGlassSurface(
              role: AppGlassRole.control,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: AppGlassSurface(
                  role: AppGlassRole.control,
                  child: SizedBox(width: 80, height: 48),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final lenses = find.byType(LiquidGlassLens).evaluate().toList();
    expect(lenses, hasLength(2));
    final outer = LiquidGlassBatch.backdropIdOf(lenses.first);
    final inner = LiquidGlassBatch.backdropIdOf(lenses.last);
    expect(outer, isNotNull);
    expect(inner, isNotNull);
    expect(inner, isNot(outer));
    expect(tester.takeException(), isNull);
  });

  testWidgets('legacy rescue preserves editing when glass is toggled', (
    tester,
  ) async {
    AppGlassBackend.capabilityProbeOverride = () => false;
    AppGlassBackend.initialize();
    final controller = TextEditingController(text: 'Draft');
    final focus = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focus.dispose);
    var enabled = true;
    late StateSetter update;
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return MaterialApp(
            theme: AppTheme.generateTheme(
              AppColors.dark,
              Brightness.dark,
              glassEnabled: enabled,
            ),
            home: Scaffold(
              body: AppGlassBatch.controls(
                child: AppGlassSurface(
                  role: AppGlassRole.control,
                  child: TextField(controller: controller, focusNode: focus),
                ),
              ),
            ),
          );
        },
      ),
    );
    await tester.pumpAndSettle();
    final field = find.byType(TextField);
    final element = tester.element(field);
    final bounds = tester.getRect(field);
    await tester.enterText(field, 'Still editing');
    for (final next in [false, true]) {
      update(() => enabled = next);
      await tester.pumpAndSettle();
      expect(tester.element(field), same(element));
      expect(tester.getRect(field), bounds);
      expect(controller.text, 'Still editing');
      expect(focus.hasFocus, isTrue);
      expect(
        find.byType(LiquidGlassLens),
        next ? findsOneWidget : findsNothing,
      );
      expect(find.byType(renderer.LiquidGlassLayer), findsNothing);
    }
    expect(tester.takeException(), isNull);
  });
}
