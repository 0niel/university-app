import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  const options = [
    AppSegmentedOption(value: 0, label: 'Сегодня'),
    AppSegmentedOption(value: 1, label: 'Неделя'),
  ];

  testWidgets('segments are 38px pills inside a 4px padded track', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: AppSegmentedControl<int>(
            value: 1,
            onChanged: (_) {},
            options: options,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(AppSegmentedControl<int>)).height, 46);
  });

  testWidgets('wraps and stays tappable at large text scales', (tester) async {
    var picked = -1;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: AppSegmentedControl<int>(
            value: 0,
            onChanged: (value) => picked = value,
            options: options,
          ),
        ),
        textScale: 2,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Неделя'));
    expect(picked, 1);
  });

  testWidgets('exposes selected semantics', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: AppSegmentedControl<int>(
            value: 0,
            onChanged: (_) {},
            options: options,
          ),
        ),
      ),
    );

    final semantics = tester.getSemantics(find.text('Сегодня'));
    expect(semantics.label, 'Сегодня');
  });

  testWidgets('equal-width segments preserve more room for labels', (
    tester,
  ) async {
    for (final expanded in [true, false]) {
      await tester.pumpWidget(
        wrapKit(
          SizedBox(
            width: 350,
            child: AppSegmentedControl<int>(
              value: 0,
              expanded: expanded,
              onChanged: (_) {},
              options: options,
            ),
          ),
        ),
      );
      final segment = tester.widget<AnimatedContainer>(
        find.ancestor(
          of: find.text('Сегодня'),
          matching: find.byType(AnimatedContainer),
        ).first,
      );
      expect(
        segment.padding,
        EdgeInsets.symmetric(horizontal: expanded ? 6 : 14, vertical: 6),
      );
      expect(tester.takeException(), isNull);
    }
  });
}
