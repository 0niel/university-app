import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colors = NinjaColors.light();

  const segments = [
    NinjaSegment(value: 'day', label: 'День'),
    NinjaSegment(value: 'week', label: 'Неделя'),
  ];

  Widget wrap(Widget child, {bool dark = false}) => MaterialApp(
        theme: dark ? NinjaTheme.dark() : NinjaTheme.light(),
        home: Scaffold(body: Center(child: child)),
      );

  BoxDecoration segmentOf(WidgetTester tester, String label) {
    final container = tester.widget<AnimatedContainer>(
      find
          .ancestor(
            of: find.text(label),
            matching: find.byType(AnimatedContainer),
          )
          .first,
    );
    return container.decoration! as BoxDecoration;
  }

  group('NinjaSegmented', () {
    testWidgets('renders every label without an outer track', (tester) async {
      await tester.pumpWidget(
        wrap(
          NinjaSegmented<String>(
            segments: segments,
            value: 'day',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('День'), findsOneWidget);
      expect(find.text('Неделя'), findsOneWidget);

      expect(
        find.descendant(
          of: find.byType(NinjaSegmented<String>),
          matching: find.byType(DecoratedBox),
        ),
        findsNWidgets(segments.length),
      );
    });

    testWidgets('only the selected segment receives the brand fill', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          NinjaSegmented<String>(
            segments: segments,
            value: 'day',
            onChanged: (_) {},
          ),
        ),
      );

      final selected = segmentOf(tester, 'День');
      expect(selected.color, colors.brand);
      expect(selected.boxShadow, isNull);
      final labelStyle = DefaultTextStyle.of(
        tester.element(find.text('День')),
      ).style;
      expect(labelStyle.color, colors.onBrand);
      expect(labelStyle.fontSize, 12.5);

      final unselected = segmentOf(tester, 'Неделя');
      expect(unselected.color, Colors.transparent);
      expect(unselected.boxShadow, isNull);
    });

    testWidgets('dark mode keeps the brand fill without a shadow', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          NinjaSegmented<String>(
            segments: segments,
            value: 'day',
            onChanged: (_) {},
          ),
          dark: true,
        ),
      );

      final selected = segmentOf(tester, 'День');
      expect(selected.color, NinjaColors.dark().brand);
      expect(selected.boxShadow, isNull);
    });

    testWidgets('tapping a segment reports its value', (tester) async {
      String? changed;
      await tester.pumpWidget(
        wrap(
          NinjaSegmented<String>(
            segments: segments,
            value: 'day',
            onChanged: (value) => changed = value,
          ),
        ),
      );

      await tester.tap(find.text('Неделя'));
      expect(changed, 'week');
    });

    testWidgets('disabled dims the control', (tester) async {
      await tester.pumpWidget(
        wrap(
          const NinjaSegmented<String>(segments: segments, value: 'day'),
        ),
      );

      expect(
        tester
            .widget<Opacity>(
              find.descendant(
                of: find.byType(NinjaSegmented<String>),
                matching: find.byType(Opacity),
              ),
            )
            .opacity,
        0.5,
      );
    });

    testWidgets('uses 44px targets and stacks at 200 percent text', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          theme: NinjaTheme.dark(),
          home: MediaQuery(
            data: const MediaQueryData(
              textScaler: TextScaler.linear(2),
              accessibleNavigation: true,
            ),
            child: Scaffold(
              body: NinjaSegmented<String>(
                segments: segments,
                value: 'day',
                expanded: true,
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      for (final container in tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))) {
        expect(container.duration, Duration.zero);
        expect(container.constraints?.minHeight, greaterThanOrEqualTo(44));
      }
    });
  });
}
