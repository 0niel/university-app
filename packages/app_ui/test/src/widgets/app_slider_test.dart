import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  testWidgets('renders a 44px control exposing slider semantics', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(AppSlider(value: 0.4, onChanged: (_) {})),
    );

    expect(find.byType(AppSlider), findsOneWidget);
    expect(tester.getSize(find.byType(AppSlider)).height, 44);

    final node = tester.getSemantics(find.byType(AppSlider));
    expect(node.getSemanticsData().flagsCollection.isSlider, isTrue);
    expect(node.value, '0.40');
  });

  testWidgets('dragging to the far edge reports max', (tester) async {
    double? received;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 200,
          child: AppSlider(value: 0, onChanged: (value) => received = value),
        ),
      ),
    );

    await tester.drag(find.byType(AppSlider), const Offset(150, 0));
    await tester.pump();

    expect(received, 1.0);
  });

  testWidgets('divisions snap the reported value to the nearest step', (
    tester,
  ) async {
    double? received;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 200,
          child: AppSlider(
            value: 0,
            divisions: 4,
            onChanged: (value) => received = value,
          ),
        ),
      ),
    );

    await tester.drag(find.byType(AppSlider), const Offset(60, 0));
    await tester.pump();

    expect(received, 0.75);
  });

  testWidgets('disabled slider ignores drags and dims to 40%', (
    tester,
  ) async {
    var called = false;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 200,
          child: AppSlider(
            value: 0.5,
            enabled: false,
            onChanged: (_) => called = true,
          ),
        ),
      ),
    );

    await tester.drag(find.byType(AppSlider), const Offset(100, 0));
    await tester.pump();
    expect(called, isFalse);

    final opacity = tester.widget<Opacity>(
      find.descendant(
        of: find.byType(AppSlider),
        matching: find.byType(Opacity),
      ),
    );
    expect(opacity.opacity, 0.4);
  });

  testWidgets('semantics exposes value and stepped increase/decrease', (
    tester,
  ) async {
    double? received;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 200,
          child: AppSlider(
            value: 0.5,
            onChanged: (value) => received = value,
          ),
        ),
      ),
    );

    final data = tester.getSemantics(find.byType(AppSlider)).getSemanticsData();
    expect(data.hasAction(ui.SemanticsAction.increase), isTrue);
    expect(data.hasAction(ui.SemanticsAction.decrease), isTrue);

    tester.semantics.increase(find.semantics.byValue('0.50'));
    expect(received, closeTo(0.55, 0.0001));
  });

  testWidgets('a null onChanged reports no increase/decrease actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(
        const SizedBox(
          width: 200,
          child: AppSlider(value: 0.5, onChanged: null),
        ),
      ),
    );

    final node = tester.getSemantics(find.byType(AppSlider));
    final data = node.getSemanticsData();
    expect(data.hasAction(ui.SemanticsAction.increase), isFalse);
    expect(data.hasAction(ui.SemanticsAction.decrease), isFalse);
  });
}
