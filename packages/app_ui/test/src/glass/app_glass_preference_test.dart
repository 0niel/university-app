import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

void main() {
  for (final brightness in Brightness.values) {
    final colors = brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;
    for (final highlight in [false, true]) {
      testWidgets(
        'glass toggle preserves editing and scrolling, $brightness, $highlight',
        (tester) async {
          var enabled = true;
          var taps = 0;
          late StateSetter update;
          final controller = TextEditingController(text: 'Draft');
          final focus = FocusNode();
          final scroll = ScrollController();
          addTearDown(controller.dispose);
          addTearDown(focus.dispose);
          addTearDown(scroll.dispose);
          await tester.pumpWidget(
            StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                final content = Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: controller, focusNode: focus),
                    SizedBox(
                      height: 48,
                      child: ListView.builder(
                        controller: scroll,
                        scrollDirection: Axis.horizontal,
                        itemCount: 20,
                        itemBuilder: (_, index) => SizedBox(
                          width: 80,
                          child: Center(child: Text('Item $index')),
                        ),
                      ),
                    ),
                    AppButton.primary(
                      label: 'Continue',
                      onPressed: () => taps++,
                    ),
                  ],
                );
                return MaterialApp(
                  theme: AppTheme.generateTheme(
                    colors,
                    brightness,
                    glassEnabled: enabled,
                  ),
                  home: Scaffold(
                    body: Center(
                      child: SizedBox(
                        width: 280,
                        child: highlight
                            ? AppGlassHighlight(child: content)
                            : AppGlassSurface(child: content),
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
          await tester.enterText(field, 'Unfinished message');
          scroll.jumpTo(120);
          await tester.pump();
          expect(focus.hasFocus, isTrue);
          final glass = find.byType(
            highlight ? LiquidGlassLens : LiquidGlassLite,
          );
          expect(glass, findsOneWidget);

          for (final next in [false, true, false]) {
            update(() => enabled = next);
            await tester.pumpAndSettle();
            expect(tester.element(field), same(element));
            expect(tester.getRect(field), bounds);
            expect(controller.text, 'Unfinished message');
            expect(focus.hasFocus, isTrue);
            expect(scroll.offset, 120);
            expect(
              glass,
              next ? findsOneWidget : findsNothing,
            );
            if (!next) {
              expect(find.byType(BackdropFilter), findsNothing);
              final fallback = find.byWidgetPredicate(
                (widget) =>
                    widget is ColoredBox &&
                    widget.color == (highlight ? colors.tint : colors.surface),
              );
              expect(fallback, findsOneWidget);
            }
          }
          await tester.tap(find.text('Continue'));
          expect(taps, 1);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets('glass is enabled for default and custom themes', (tester) async {
    for (final theme in [AppTheme.darkTheme, ThemeData()]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: AppGlassSurface(child: SizedBox(width: 100, height: 80)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LiquidGlassLite), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
