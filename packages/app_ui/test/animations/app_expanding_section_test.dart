import 'package:app_ui/src/animations/app_expanding_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget view({
    required bool expanded,
    bool reduced = false,
    Widget child = const SizedBox(
      key: ValueKey('content'),
      height: 100,
      width: 200,
    ),
  }) => MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(disableAnimations: reduced),
      child: Scaffold(
        body: Column(
          children: [
            AppExpandingSection(expanded: expanded, child: child),
            TextButton(onPressed: () {}, child: const Text('Outside')),
          ],
        ),
      ),
    ),
  );

  double height(WidgetTester tester) =>
      tester.getSize(find.byType(AppExpandingSection)).height;

  testWidgets(
    'collapsed content remains mounted and rapid reversals stay smooth',
    (tester) async {
      await tester.pumpWidget(view(expanded: false));
      final content = tester.element(find.byKey(const ValueKey('content')));
      expect(height(tester), 0);
      await tester.pumpWidget(view(expanded: true));
      await tester.pump(const Duration(milliseconds: 110));
      final beforeClose = height(tester);
      expect(beforeClose, inExclusiveRange(0, 100));
      await tester.pumpWidget(view(expanded: false));
      expect(height(tester), closeTo(beforeClose, .001));
      await tester.pump(const Duration(milliseconds: 30));
      final beforeOpen = height(tester);
      expect(beforeOpen, lessThan(beforeClose));
      await tester.pumpWidget(view(expanded: true));
      expect(height(tester), closeTo(beforeOpen, .001));
      await tester.pumpAndSettle();
      expect(height(tester), 100);
      expect(
        tester.element(find.byKey(const ValueKey('content'))),
        same(content),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('closing excludes semantics and taps immediately', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var taps = 0;
    final child = SizedBox(
      height: 100,
      width: 200,
      child: TextButton(
        onPressed: () => taps++,
        child: const Text('Hidden action'),
      ),
    );
    await tester.pumpWidget(view(expanded: true, child: child));
    expect(find.semantics.byLabel('Hidden action'), findsOneWidget);
    await tester.tap(find.text('Hidden action'));
    await tester.pumpAndSettle();
    expect(taps, 1);
    await tester.pumpWidget(view(expanded: false, child: child));
    expect(find.semantics.byLabel('Hidden action'), findsNothing);
    await tester.tapAt(
      tester.getTopLeft(find.byType(AppExpandingSection)) + const Offset(50, 8),
    );
    await tester.pumpAndSettle();
    expect(taps, 1);
    expect(height(tester), 0);
    expect(find.text('Hidden action'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('collapsed fields lose focus and retain their entered value', (
    tester,
  ) async {
    final focus = FocusNode();
    final controller = TextEditingController();
    addTearDown(focus.dispose);
    addTearDown(controller.dispose);
    final child = TextField(
      key: const ValueKey('field'),
      focusNode: focus,
      controller: controller,
    );
    await tester.pumpWidget(view(expanded: true, child: child));
    final field = tester.element(find.byKey(const ValueKey('field')));
    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'Preserved text');
    expect(focus.hasFocus, isTrue);
    await tester.pumpWidget(view(expanded: false, child: child));
    await tester.pumpAndSettle();
    expect(focus.hasFocus, isFalse);
    focus.requestFocus();
    await tester.pump();
    expect(focus.hasFocus, isFalse);
    await tester.pumpWidget(view(expanded: true, child: child));
    await tester.pumpAndSettle();
    expect(controller.text, 'Preserved text');
    expect(tester.element(find.byKey(const ValueKey('field'))), same(field));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('reduced motion toggles directly without remounting content', (
    tester,
  ) async {
    await tester.pumpWidget(view(expanded: false, reduced: true));
    final content = tester.element(find.byKey(const ValueKey('content')));
    expect(height(tester), 0);
    await tester.pumpWidget(view(expanded: true, reduced: true));
    expect(height(tester), 100);
    await tester.pumpWidget(view(expanded: false, reduced: true));
    expect(height(tester), 0);
    expect(
      tester.element(find.byKey(const ValueKey('content'))),
      same(content),
    );
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('enabling reduced motion finishes the current expansion', (
    tester,
  ) async {
    await tester.pumpWidget(view(expanded: false));
    await tester.pumpWidget(view(expanded: true));
    await tester.pump(const Duration(milliseconds: 50));
    expect(height(tester), inExclusiveRange(0, 100));
    await tester.pumpWidget(view(expanded: true, reduced: true));
    expect(height(tester), 100);
    expect(tester.takeException(), isNull);
  });
}
