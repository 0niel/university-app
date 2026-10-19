import 'package:app_ui/src/animations/app_reveal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget view({
    Object? identity,
    int index = 0,
    bool reduced = false,
    bool accessibleNavigation = false,
    Widget child = const SizedBox(
      key: ValueKey('content'),
      width: 200,
      height: 100,
    ),
  }) => MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(
        disableAnimations: reduced,
        accessibleNavigation: accessibleNavigation,
      ),
      child: Center(
        child: AppReveal(identity: identity, index: index, child: child),
      ),
    ),
  );

  double offset(WidgetTester tester) => tester
      .widget<Transform>(
        find
            .descendant(
              of: find.byType(AppReveal),
              matching: find.byType(Transform),
            )
            .first,
      )
      .transform
      .getTranslation()
      .y;

  testWidgets('entrance uses transforms without isolating glass opacity', (
    tester,
  ) async {
    await tester.pumpWidget(view());
    expect(offset(tester), 8);
    expect(
      find.descendant(
        of: find.byType(AppReveal),
        matching: find.byType(Opacity),
      ),
      findsNothing,
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(offset(tester), inExclusiveRange(0, 8));
    await tester.pumpAndSettle();
    expect(offset(tester), 0);
  });

  testWidgets('rebuild preserves content and only identity replays entrance', (
    tester,
  ) async {
    await tester.pumpWidget(view(identity: 'first'));
    final content = tester.element(find.byKey(const ValueKey('content')));
    await tester.pumpAndSettle();
    await tester.pumpWidget(view(identity: 'first', index: 10));
    expect(offset(tester), 0);
    expect(
      tester.element(find.byKey(const ValueKey('content'))),
      same(content),
    );
    await tester.pumpWidget(view(identity: 'second'));
    expect(offset(tester), 8);
    expect(
      tester.element(find.byKey(const ValueKey('content'))),
      same(content),
    );
    await tester.pumpAndSettle();
    expect(offset(tester), 0);
  });

  testWidgets('large indices cap the stagger delay at 140 milliseconds', (
    tester,
  ) async {
    await tester.pumpWidget(view(index: 10000));
    await tester.pump(const Duration(milliseconds: 139));
    expect(offset(tester), 8);
    await tester.pump(const Duration(milliseconds: 101));
    expect(offset(tester), inExclusiveRange(0, 8));
    await tester.pump(const Duration(milliseconds: 120));
    expect(offset(tester), 0);
  });

  for (final accessible in [false, true]) {
    testWidgets('reduced motion is immediate, accessible $accessible', (
      tester,
    ) async {
      await tester.pumpWidget(
        view(
          index: 100,
          reduced: !accessible,
          accessibleNavigation: accessible,
        ),
      );
      expect(offset(tester), 0);
      expect(tester.binding.transientCallbackCount, 0);
      await tester.pumpWidget(
        view(
          identity: 'changed',
          index: 100,
          reduced: !accessible,
          accessibleNavigation: accessible,
        ),
      );
      expect(offset(tester), 0);
      expect(tester.binding.transientCallbackCount, 0);
    });
  }

  testWidgets('enabling reduced motion finishes an active entrance', (
    tester,
  ) async {
    await tester.pumpWidget(view());
    await tester.pump(const Duration(milliseconds: 50));
    expect(offset(tester), greaterThan(0));
    await tester.pumpWidget(view(reduced: true));
    expect(offset(tester), 0);
    await tester.pumpWidget(view());
    expect(offset(tester), 0);
    expect(tester.takeException(), isNull);
  });
}
