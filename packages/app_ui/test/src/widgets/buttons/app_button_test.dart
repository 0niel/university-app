import 'dart:ui' show Tristate;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  RoundedRectangleBorder buttonShape(WidgetTester tester) {
    final material = tester.widget<Material>(
      find
          .descendant(
            of: find.byType(AppButton),
            matching: find.byType(Material),
          )
          .first,
    );
    return material.shape! as RoundedRectangleBorder;
  }

  group('AppButton', () {
    testWidgets('is a pill by default', (tester) async {
      await tester.pumpWidget(
        wrap(AppButton.primary(label: 'Войти', onPressed: () {})),
      );

      expect(
        buttonShape(tester).borderRadius,
        BorderRadius.circular(AppRadius.full),
      );
    });

    testWidgets('keeps the pill radius across sizes', (tester) async {
      for (final size in AppButtonSize.values) {
        await tester.pumpWidget(
          wrap(AppButton.primary(label: 'X', onPressed: () {}, size: size)),
        );
        expect(
          buttonShape(tester).borderRadius,
          BorderRadius.circular(AppRadius.full),
          reason: 'size $size should stay a pill',
        );
      }
    });

    testWidgets('a custom borderRadius still wins', (tester) async {
      await tester.pumpWidget(
        wrap(
          AppButton.primary(
            label: 'X',
            onPressed: () {},
            borderRadius: AppRadius.button,
          ),
        ),
      );

      expect(
        buttonShape(tester).borderRadius,
        BorderRadius.circular(AppRadius.button),
      );
    });

    testWidgets('large size is 52 tall (design primary CTA)', (tester) async {
      await tester.pumpWidget(
        wrap(
          AppButton.primary(
            label: 'Поставить напоминание',
            onPressed: () {},
            size: AppButtonSize.large,
          ),
        ),
      );

      final box = tester.widget<ConstrainedBox>(
        find
            .descendant(
              of: find.byType(AppButton),
              matching: find.byType(ConstrainedBox),
            )
            .first,
      );
      expect(box.constraints.minHeight, 52);
    });

    testWidgets('all sizes keep a minimum 44px touch target', (tester) async {
      for (final size in AppButtonSize.values) {
        await tester.pumpWidget(
          wrap(AppButton.primary(label: 'X', onPressed: () {}, size: size)),
        );
        final box = tester.widget<ConstrainedBox>(
          find
              .descendant(
                of: find.byType(AppButton),
                matching: find.byType(ConstrainedBox),
              )
              .first,
        );
        expect(box.constraints.minHeight, greaterThanOrEqualTo(44));
      }
    });

    testWidgets('exposes an enabled button semantic', (tester) async {
      await tester.pumpWidget(
        wrap(AppButton.primary(label: 'Отправить', onPressed: () {})),
      );

      final semantics = tester.getSemantics(find.byType(AppButton));
      expect(semantics.label, 'Отправить');
      expect(semantics.flagsCollection.isButton, isTrue);
      expect(semantics.flagsCollection.isEnabled, Tristate.isTrue);
    });

    testWidgets('renders the label and fires onPressed', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          AppButton.primary(
            label: 'Отправить',
            onPressed: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Отправить'), findsOneWidget);
      await tester.tap(find.byType(AppButton));
      expect(tapped, isTrue);
    });
  });
}
