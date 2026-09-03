import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  group('NinjaSkeleton', () {
    testWidgets('static bar renders without a group', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          const SizedBox(width: 200, child: NinjaSkeleton.bar(shimmer: false)),
        ),
      );

      expect(find.byType(NinjaSkeleton), findsOneWidget);
      expect(find.byType(NinjaSkeletonGroup), findsNothing);
      expect(tester.getSize(find.byType(NinjaSkeleton)).height, 12);
    });

    testWidgets('animated skeleton wraps itself in a group and pulses', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(const SizedBox(width: 200, child: NinjaSkeleton.tile())),
      );

      expect(find.byType(NinjaSkeletonGroup), findsOneWidget);
      expect(NinjaSkeletonGroup.period, const Duration(milliseconds: 1400));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump(const Duration(milliseconds: 700));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('widthFactor shrinks the bar', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          const SizedBox(
            width: 200,
            child: NinjaSkeleton.bar(widthFactor: .5, shimmer: false),
          ),
        ),
      );

      expect(
        tester
            .widget<FractionallySizedBox>(find.byType(FractionallySizedBox))
            .widthFactor,
        .5,
      );
    });

    testWidgets('group exposes a live region label', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          const NinjaSkeletonGroup(
            semanticsLabel: 'Загрузка',
            child: SizedBox(width: 200, child: NinjaSkeletonRow()),
          ),
          accessibleNavigation: true,
        ),
      );

      expect(find.bySemanticsLabel('Загрузка'), findsOneWidget);
      expect(find.byType(NinjaSkeleton), findsNWidgets(3));
    });
  });

  group('AppSkeletonRow', () {
    testWidgets('paints a canvas r20 row with tile, two lines and a pill', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(
          const SizedBox(width: 320, child: AppSkeletonRow()),
          accessibleNavigation: true,
        ),
      );

      final card = kitDecorationOf(tester, AppSkeletonRow);
      expect(card.color, kitColors.canvas);
      expect(card.borderRadius, BorderRadius.circular(AppRadius.lg));

      final blocks =
          tester.widgetList<NinjaSkeleton>(find.byType(NinjaSkeleton)).toList();
      expect(blocks, hasLength(4));
      expect(blocks.first.width, 44);
      expect(blocks.first.radius, 14);
      expect(blocks[1].widthFactor, .7);
      expect(blocks[2].widthFactor, .45);
      expect(blocks.last.width, 48);
      expect(blocks.last.height, 22);
    });

    testWidgets('can drop the trailing pill', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          const SizedBox(
            width: 320,
            child: AppSkeletonRow(showTrailing: false),
          ),
          accessibleNavigation: true,
        ),
      );

      expect(find.byType(NinjaSkeleton), findsNWidgets(3));
    });
  });

  group('NinjaSkeletonMedia', () {
    testWidgets('fills surface2 with a centered mark', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          const SizedBox(width: 200, child: NinjaSkeletonMedia(height: 120)),
          accessibleNavigation: true,
        ),
      );

      expect(
        tester
            .widget<ColoredBox>(
              find
                  .descendant(
                    of: find.byType(NinjaSkeletonMedia),
                    matching: find.byType(ColoredBox),
                  )
                  .first,
            )
            .color,
        kitColors.surface2,
      );
      expect(find.byType(NinjaSkeleton), findsOneWidget);
    });
  });

  test('App aliases point at the Ninja skeletons', () {
    expect(AppSkeleton, NinjaSkeleton);
    expect(AppSkeletonGroup, NinjaSkeletonGroup);
    expect(AppSkeletonMedia, NinjaSkeletonMedia);
  });
}
