import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  AnimatedContainer track(WidgetTester tester) =>
      tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(AppToggle),
          matching: find.byType(AnimatedContainer),
        ),
      );

  group('AppToggle', () {
    testWidgets('fires onChanged with the flipped value on tap',
        (tester) async {
      bool? changed;
      await tester.pumpWidget(
        wrap(AppToggle(value: false, onChanged: (v) => changed = v)),
      );

      await tester.tap(find.byType(AppToggle));
      expect(changed, isTrue);
    });

    testWidgets('on uses the accent track, off uses surface-low',
        (tester) async {
      await tester.pumpWidget(
        wrap(AppToggle(value: true, onChanged: (_) {})),
      );
      final colors = tester.element(find.byType(AppToggle)).ninja;
      expect(
        (track(tester).decoration! as BoxDecoration).color,
        colors.brand,
      );

      await tester.pumpWidget(
        wrap(AppToggle(value: false, onChanged: (_) {})),
      );
      expect(
        (track(tester).decoration! as BoxDecoration).color,
        colors.line,
      );
    });

    testWidgets('keeps a 44px target and disables motion for accessibility', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const MediaQuery(
            data: MediaQueryData(accessibleNavigation: true),
            child: Scaffold(body: Center(child: AppToggle(value: true))),
          ),
        ),
      );

      expect(tester.getSize(find.byType(AppToggle)).height, 44);
      expect(track(tester).duration, Duration.zero);
    });
  });

  group('AppLangToggle', () {
    testWidgets('renders both options and fires onChanged', (tester) async {
      String? picked;
      await tester.pumpWidget(
        wrap(
          AppLangToggle(
            value: 'RU',
            options: const ['RU', 'EN'],
            onChanged: (v) => picked = v,
          ),
        ),
      );

      expect(find.text('RU'), findsOneWidget);
      expect(find.text('EN'), findsOneWidget);

      await tester.tap(find.text('EN'));
      expect(picked, 'EN');
      expect(tester.getSize(find.byType(AppLangToggle)).height, 44);
    });
  });
}
