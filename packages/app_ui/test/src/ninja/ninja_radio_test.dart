import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colors = NinjaColors.light();

  Widget wrap(Widget child) => MaterialApp(
        theme: NinjaTheme.light(),
        home: Scaffold(body: Center(child: child)),
      );

  BoxDecoration ringOf(WidgetTester tester) {
    final box = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(NinjaRadio<String>),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    return box.decoration as BoxDecoration;
  }

  group('NinjaRadio', () {
    testWidgets('selected draws the 7px brand ring in a 44px target', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          NinjaRadio<String>(
            value: 'a',
            groupValue: 'a',
            onChanged: (_) {},
          ),
        ),
      );

      final decoration = ringOf(tester);
      expect(decoration.shape, BoxShape.circle);
      expect(decoration.border?.top.color, colors.brand);
      expect(decoration.border?.top.width, 7);
      expect(
        tester.getSize(find.byType(NinjaRadio<String>)),
        const Size.square(NinjaMetrics.minTouchTarget),
      );
    });

    testWidgets('empty draws the 1.5 disabledLine outline', (tester) async {
      await tester.pumpWidget(
        wrap(
          NinjaRadio<String>(
            value: 'a',
            groupValue: 'b',
            onChanged: (_) {},
          ),
        ),
      );

      final decoration = ringOf(tester);
      expect(decoration.border?.top.color, colors.disabledLine);
      expect(decoration.border?.top.width, NinjaMetrics.lineWidth);
    });

    testWidgets('tapping reports this button value', (tester) async {
      String? changed;
      await tester.pumpWidget(
        wrap(
          NinjaRadio<String>(
            value: 'a',
            groupValue: 'b',
            onChanged: (value) => changed = value,
          ),
        ),
      );

      await tester.tap(find.byType(NinjaRadio<String>));
      expect(changed, 'a');
    });

    testWidgets('disabled dims the ring and blocks taps', (tester) async {
      await tester.pumpWidget(
        wrap(const NinjaRadio<String>(value: 'a', groupValue: 'b')),
      );

      expect(
        tester
            .widget<Opacity>(
              find.descendant(
                of: find.byType(NinjaRadio<String>),
                matching: find.byType(Opacity),
              ),
            )
            .opacity,
        0.5,
      );

      await tester.tap(find.byType(NinjaRadio<String>));
    });
  });
}
