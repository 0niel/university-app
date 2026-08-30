import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colors = NinjaColors.light();

  Widget wrap(
    Widget child, {
    bool dark = false,
    bool disableAnimations = false,
    bool accessibleNavigation = false,
  }) =>
      MaterialApp(
        theme: dark ? NinjaTheme.dark() : NinjaTheme.light(),
        home: MediaQuery(
          data: MediaQueryData(
            disableAnimations: disableAnimations,
            accessibleNavigation: accessibleNavigation,
          ),
          child: Scaffold(body: Center(child: child)),
        ),
      );

  BoxDecoration trackOf(WidgetTester tester) {
    final container = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(NinjaSwitch),
        matching: find.byType(AnimatedContainer),
      ),
    );
    return container.decoration! as BoxDecoration;
  }

  Finder knob() => find
      .descendant(
        of: find.byType(NinjaSwitch),
        matching: find.byType(DecoratedBox),
      )
      .last;

  group('NinjaSwitch', () {
    testWidgets('has a 48×44 target and flips on tap', (tester) async {
      bool? changed;
      await tester.pumpWidget(
        wrap(NinjaSwitch(value: false, onChanged: (value) => changed = value)),
      );

      expect(tester.getSize(find.byType(NinjaSwitch)), const Size(48, 44));

      await tester.tap(find.byType(NinjaSwitch));
      expect(changed, isTrue);
    });

    testWidgets('on is the accent track, off is #E3E3E8', (tester) async {
      await tester.pumpWidget(
        wrap(NinjaSwitch(value: true, onChanged: (_) {})),
      );
      expect(trackOf(tester).color, colors.indigo);

      await tester.pumpWidget(
        wrap(NinjaSwitch(value: false, onChanged: (_) {})),
      );
      await tester.pumpAndSettle();
      expect(trackOf(tester).color, const Color(0xFFE3E3E8));
    });

    testWidgets('the knob moves to the trailing edge when on', (tester) async {
      await tester.pumpWidget(
        wrap(NinjaSwitch(value: false, onChanged: (_) {})),
      );
      await tester.pumpAndSettle();
      final off = tester.getTopLeft(knob());

      await tester.pumpWidget(
        wrap(NinjaSwitch(value: true, onChanged: (_) {})),
      );
      await tester.pumpAndSettle();

      expect(tester.getTopLeft(knob()).dx, greaterThan(off.dx));
    });

    testWidgets('disabled dims the control and blocks taps', (tester) async {
      await tester.pumpWidget(wrap(const NinjaSwitch(value: false)));

      expect(trackOf(tester).color, colors.surface);
      expect(
        tester
            .widget<Opacity>(
              find.descendant(
                of: find.byType(NinjaSwitch),
                matching: find.byType(Opacity),
              ),
            )
            .opacity,
        0.5,
      );

      await tester.tap(find.byType(NinjaSwitch));
    });

    testWidgets('dark mode drops the knob shadow', (tester) async {
      await tester.pumpWidget(
        wrap(NinjaSwitch(value: false, onChanged: (_) {}), dark: true),
      );
      await tester.pumpAndSettle();

      final decoration =
          tester.widget<DecoratedBox>(knob()).decoration as BoxDecoration;
      expect(decoration.boxShadow, isNull);
    });

    testWidgets('uses zero duration when animations are disabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          NinjaSwitch(value: false, onChanged: (_) {}),
          disableAnimations: true,
        ),
      );

      expect(
        tester
            .widget<AnimatedContainer>(find.byType(AnimatedContainer))
            .duration,
        Duration.zero,
      );
      expect(
        tester.widget<AnimatedAlign>(find.byType(AnimatedAlign)).duration,
        Duration.zero,
      );

      await tester.pumpWidget(
        wrap(
          NinjaSwitch(value: true, onChanged: (_) {}),
          accessibleNavigation: true,
        ),
      );

      expect(
        tester
            .widget<AnimatedContainer>(find.byType(AnimatedContainer))
            .duration,
        Duration.zero,
      );
      expect(
        tester.widget<AnimatedAlign>(find.byType(AnimatedAlign)).duration,
        Duration.zero,
      );
    });
  });
}
