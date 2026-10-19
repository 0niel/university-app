import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  for (final sample in [
    (width: 280.0, scale: 1.0, columns: 1),
    (width: 340.0, scale: 1.0, columns: 2),
    (width: 660.0, scale: 1.0, columns: 3),
    (width: 940.0, scale: 1.0, columns: 4),
    (width: 280.0, scale: 2.0, columns: 1),
  ]) {
    testWidgets(
      'sliver grid preserves ${sample.width}/${sample.scale} layout',
      (
        tester,
      ) async {
        tester.view.physicalSize = const Size(1000, 1200);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          wrapKit(
            SizedBox(
              width: sample.width,
              child: CustomScrollView(
                slivers: [
                  AppSliverAdaptiveGrid(
                    itemCount: 4,
                    itemBuilder: (context, index) => SizedBox(
                      key: ValueKey(index),
                      height: [20.0, 60.0, 30.0, 40.0][index],
                    ),
                  ),
                ],
              ),
            ),
            textScale: sample.scale,
            accessibleNavigation: true,
          ),
        );
        final first = tester.getRect(find.byKey(const ValueKey(0)));
        final second = tester.getRect(find.byKey(const ValueKey(1)));
        expect(
          first.width,
          closeTo(
            (sample.width - (sample.columns - 1) * 10) / sample.columns,
            .01,
          ),
        );
        if (sample.columns == 1) {
          expect(second.top - first.bottom, 10);
        } else {
          expect(first.top, second.top);
          expect(first.height, second.height);
          expect(second.left - first.right, 10);
        }
        expect(
          tester
              .widgetList<IndexedSemantics>(find.byType(IndexedSemantics))
              .map(
                (semantics) => semantics.index,
              ),
          [0, 1, 2, 3],
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('builds viewport rows and disposes distant rows when scrolling', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final built = <int>{};
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      wrapKit(
        CustomScrollView(
          controller: controller,
          slivers: [
            AppSliverAdaptiveGrid(
              itemCount: 1000,
              itemBuilder: (context, index) {
                built.add(index);
                return SizedBox(
                  key: ValueKey(index),
                  height: index.isEven ? 60 : 96,
                  child: Text('Service $index'),
                );
              },
            ),
          ],
        ),
        accessibleNavigation: true,
      ),
    );
    expect(built.length, lessThan(30));
    expect(find.byKey(const ValueKey(999)), findsNothing);
    expect(find.byKey(const ValueKey(0)), findsOneWidget);
    controller.jumpTo(5000);
    await tester.pump();
    expect(built.any((index) => index > 80), isTrue);
    expect(built.length, lessThan(150));
    expect(
      find.byType(IndexedSemantics).evaluate().length,
      lessThanOrEqualTo(30),
    );
    expect(find.byKey(const ValueKey(0)), findsNothing);
    expect(find.byKey(const ValueKey(999)), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('empty grid contributes no scroll extent', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      wrapKit(
        CustomScrollView(
          controller: controller,
          slivers: [
            AppSliverAdaptiveGrid(
              itemCount: 0,
              itemBuilder: (context, index) => const SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
    expect(controller.position.maxScrollExtent, 0);
    expect(tester.takeException(), isNull);
  });
}
