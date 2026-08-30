import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  Finder dot() => find.descendant(
        of: find.byType(AppIconButton),
        matching: find.byType(IgnorePointer),
      );

  group('AppIconButton dot badge', () {
    testWidgets('shows a badge when dot: true', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppIconButton(
            icon: Icon(Icons.notifications_rounded),
            dot: true,
          ),
        ),
      );
      expect(dot(), findsOneWidget);
    });

    testWidgets('has no badge by default', (tester) async {
      await tester.pumpWidget(
        wrap(const AppIconButton(icon: Icon(Icons.notifications_rounded))),
      );
      expect(dot(), findsNothing);
    });
  });

  testWidgets('all icon button sizes keep a minimum 44px touch target', (
    tester,
  ) async {
    for (final size in AppButtonSize.values) {
      await tester.pumpWidget(
        wrap(
          AppIconButton(
            icon: const Icon(Icons.notifications_rounded),
            onPressed: () {},
            size: size,
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(IconButton)).shortestSide,
        greaterThanOrEqualTo(44),
      );
      if (size != AppButtonSize.small) {
        expect(
          tester.getSize(find.byType(IconButton)).shortestSide,
          greaterThanOrEqualTo(48),
        );
      }
    }
  });
}
