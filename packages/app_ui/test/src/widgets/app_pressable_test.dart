import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppPressable', () {
    testWidgets('tap fires onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          AppPressable(
            onTap: () => tapped = true,
            child: const SizedBox(width: 40, height: 40),
          ),
        ),
      );

      await tester.tap(find.byType(AppPressable));
      expect(tapped, isTrue);
    });

    testWidgets('owned semantics node exposes label, flags, and tap action',
        (tester) async {
      final handle = tester.ensureSemantics();
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          AppPressable(
            onTap: () => tapped = true,
            semanticsLabel: 'Open',
            semanticsSelected: true,
            child: const SizedBox(width: 40, height: 40),
          ),
        ),
      );

      final node = tester.getSemantics(find.byType(AppPressable));
      expect(
        node,
        matchesSemantics(
          label: 'Open',
          isButton: true,
          hasSelectedState: true,
          isSelected: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasFocusAction: true,
          hasTapAction: true,
        ),
      );

      tester.semantics.tap(find.semantics.byLabel('Open'));
      expect(tapped, isTrue);
      handle.dispose();
    });

    testWidgets('disabled pressable with semantics reads as disabled button',
        (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          AppPressable(
            enabled: false,
            onTap: () {},
            semanticsLabel: 'Open',
            child: const SizedBox(width: 40, height: 40),
          ),
        ),
      );

      final node = tester.getSemantics(find.byType(AppPressable));
      expect(
        node,
        matchesSemantics(
          label: 'Open',
          isButton: true,
          hasEnabledState: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('disabled does nothing on tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          AppPressable(
            enabled: false,
            onTap: () => tapped = true,
            child: const SizedBox(width: 40, height: 40),
          ),
        ),
      );

      // Disabled means not interactive: no GestureDetector is mounted, so
      // tapping the area must be a no-op rather than invoking onTap.
      expect(find.byType(GestureDetector), findsNothing);
      await tester.tap(find.byType(AppPressable), warnIfMissed: false);
      expect(tapped, isFalse);
    });

    testWidgets('null onTap and onLongPress renders inert (no gesture)',
        (tester) async {
      await tester.pumpWidget(
        wrap(const AppPressable(child: SizedBox(width: 40, height: 40))),
      );

      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('scales down while pressed and springs back on release',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          AppPressable(
            pressedScale: 0.9,
            onTap: () {},
            child: const SizedBox(width: 40, height: 40),
          ),
        ),
      );

      AnimatedScale scale() => tester.widget<AnimatedScale>(
            find.byType(AnimatedScale),
          );

      expect(scale().scale, 1);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(AppPressable)),
      );
      await tester.pump();
      expect(scale().scale, 0.9);

      await gesture.up();
      await tester.pump();
      expect(scale().scale, 1);
    });

    testWidgets(
        'fires haptics-guarded onTap without throwing when haptics '
        'is enabled', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          AppPressable(
            haptics: true,
            onTap: () => tapped = true,
            child: const SizedBox(width: 40, height: 40),
          ),
        ),
      );

      await tester.tap(find.byType(AppPressable));
      expect(tapped, isTrue);
    });
  });
}
