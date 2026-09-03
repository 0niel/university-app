import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  const segments = [
    NinjaSegment(value: 0, label: 'День'),
    NinjaSegment(value: 1, label: 'Неделя'),
    NinjaSegment(value: 2, label: 'Месяц'),
  ];

  BoxDecoration containerOf(WidgetTester tester) => kitDecoration(
        tester,
        find
            .descendant(
              of: find.byType(NinjaSegmented<int>),
              matching: find.byType(Container),
            )
            .first,
      );

  BoxDecoration segmentOf(WidgetTester tester, String label) => kitDecoration(
        tester,
        find
            .ancestor(of: find.text(label), matching: find.byType(Container))
            .first,
      );

  testWidgets('container keeps 4px visual inset with 44px hit targets',
      (tester) async {
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: NinjaSegmented<int>(
            segments: segments,
            value: 0,
            onChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final decoration = containerOf(tester);
    expect(decoration.color, kitColors.canvas);
    expect(decoration.borderRadius, BorderRadius.circular(AppRadius.full));
    expect(
      tester
          .widget<Container>(
            find
                .descendant(
                  of: find.byType(NinjaSegmented<int>),
                  matching: find.byType(Container),
                )
                .first,
          )
          .padding,
      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
    );
    expect(tester.getSize(find.byType(NinjaSegmented<int>)).height, 46);
  });

  testWidgets('selected segment is an accent pill 38 tall', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: NinjaSegmented<int>(
            segments: segments,
            value: 1,
            onChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(segmentOf(tester, 'Неделя').color, kitColors.accent);
    expect(segmentOf(tester, 'День').color, Colors.transparent);
    expect(kitStyleOf(tester, 'Неделя')?.color, kitColors.onAccent);
    expect(kitStyleOf(tester, 'День')?.color, kitColors.muted);
    expect(kitStyleOf(tester, 'Неделя')?.fontSize, 13.5);
    expect(kitStyleOf(tester, 'Неделя')?.fontWeight, FontWeight.w700);
    expect(tester.getSize(find.text('Неделя').first).height, lessThan(38));
  });

  testWidgets('onCanvas swaps the container to surface', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: NinjaSegmented<int>(
            segments: segments,
            value: 0,
            onCanvas: true,
            onChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(containerOf(tester).color, kitColors.surface);
  });

  testWidgets('tapping a segment reports its value', (tester) async {
    int? picked;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: NinjaSegmented<int>(
            segments: segments,
            value: 0,
            onChanged: (value) => picked = value,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Месяц'));
    expect(picked, 2);
  });

  testWidgets('disabled dims the control', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        const SizedBox(
          width: 320,
          child: NinjaSegmented<int>(segments: segments, value: 0),
        ),
      ),
    );

    final opacity = tester.widget<Opacity>(
      find
          .descendant(
            of: find.byType(NinjaSegmented<int>),
            matching: find.byType(Opacity),
          )
          .first,
    );
    expect(opacity.opacity, 0.5);
  });

  testWidgets('AppSegmentedControl carries the same visuals', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: AppSegmentedControl<int>(
            value: 0,
            onChanged: (_) {},
            options: const [
              AppSegmentedOption(value: 0, label: 'День'),
              AppSegmentedOption(value: 1, label: 'Неделя'),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(segmentOf(tester, 'День').color, kitColors.accent);
  });
}
