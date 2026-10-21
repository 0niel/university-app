import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

void main() {
  for (final dark in [false, true]) {
    for (final glass in [false, true]) {
      testWidgets('pinning preserves content, dark=$dark, glass=$glass', (
        tester,
      ) async {
        var elevated = false;
        late StateSetter update;
        final focus = FocusNode();
        final controller = TextEditingController();
        addTearDown(focus.dispose);
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.generateTheme(
              dark ? AppColors.dark : AppColors.light,
              dark ? Brightness.dark : Brightness.light,
              glassEnabled: glass,
            ),
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 280,
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      update = setState;
                      return AppPinnedSurface(
                        elevated: elevated,
                        child: TextField(
                          controller: controller,
                          focusNode: focus,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
        final field = find.byType(TextField);
        final element = tester.element(field);
        final bounds = tester.getRect(field);
        expect(find.byType(AppGlassSurface), findsNothing);
        await tester.enterText(field, 'Draft');
        for (final next in [true, false, true]) {
          update(() => elevated = next);
          await tester.pumpAndSettle();
          expect(tester.element(field), same(element));
          expect(tester.getRect(field), bounds);
          expect(focus.hasFocus, isTrue);
          expect(controller.text, 'Draft');
          expect(
            find.byType(AppGlassSurface),
            next ? findsOneWidget : findsNothing,
          );
          expect(
            find.byType(LiquidGlassLite),
            next && glass ? findsOneWidget : findsNothing,
          );
          expect(find.byType(LiquidGlassLens), findsNothing);
          if (next && glass) {
            final material = tester.widget<LiquidGlassLite>(
              find.byType(LiquidGlassLite),
            );
            expect(material.blur, 6);
            expect(material.magnification, 1);
            expect(material.specular, AppGlassStyle.rim);
            expect(material.glow, const LiquidGlassLight.glow(thickness: 0));
            expect(
              tester.layers.whereType<BackdropFilterLayer>(),
              hasLength(1),
            );
          }
          expect(tester.takeException(), isNull);
        }
      });
    }
  }
}
