import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppNinjaMark', () {
    testWidgets('paints the mark', (tester) async {
      await tester.pumpWidget(wrap(const AppNinjaMark(size: 40)));

      expect(
        find.descendant(
          of: find.byType(AppNinjaMark),
          matching: find.byType(CustomPaint),
        ),
        findsWidgets,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('is static by default', (tester) async {
      await tester.pumpWidget(wrap(const AppNinjaMark(size: 40)));

      expect(
        find.descendant(
          of: find.byType(AppNinjaMark),
          matching: find.byType(RotationTransition),
        ),
        findsNothing,
      );
    });

    testWidgets('spin wraps the mark in a RotationTransition', (tester) async {
      await tester.pumpWidget(wrap(const AppNinjaMark(size: 40, spin: true)));
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.descendant(
          of: find.byType(AppNinjaMark),
          matching: find.byType(RotationTransition),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders solid (cutout: false) without error', (tester) async {
      await tester
          .pumpWidget(wrap(const AppNinjaMark(size: 40, cutout: false)));

      expect(find.byType(AppNinjaMark), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
