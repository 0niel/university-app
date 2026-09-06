import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_overlap_switcher.dart';

import '../../../helpers/pump_app.dart';

void main() {
  Widget overlap({
    List<String> labels = const ['Короткая пара', 'Длинная пара'],
    bool compact = false,
    int initialIndex = 0,
    VoidCallback? onLesson,
  }) => ScheduleOverlapSwitcher(
    labels: labels,
    colors: [for (final _ in labels) const Color(0xff80aaff)],
    compact: compact,
    initialIndex: initialIndex,
    children: [
      for (final label in labels)
        AppPressable(
          onTap: onLesson,
          child: SizedBox(
            height: label == 'Длинная пара' ? 210 : 80,
            child: Center(child: Text(label)),
          ),
        ),
    ],
  );

  Future<void> open(
    WidgetTester tester,
    Widget child, {
    double width = 320,
    double scale = 1,
  }) => tester.pumpApp(
    Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(width: width, child: child),
      ),
    ),
    size: const Size(390, 844),
    textScaler: TextScaler.linear(scale),
  );

  testWidgets(
    'header and lesson share a clipped surface without outer outline',
    (
      tester,
    ) async {
      await open(tester, overlap());
      final card = find.byKey(const ValueKey('schedule-overlap-card'));
      final header = find.byKey(const ValueKey('schedule-overlap-next'));
      final content = find.byKey(const ValueKey('schedule-overlap-content'));
      expect(tester.getSize(header).height, 44);
      expect(
        tester.getRect(header).bottom,
        lessThan(tester.getRect(content).top),
      );
      expect(tester.getRect(card).bottom, tester.getRect(content).bottom);
      expect(
        find.ancestor(of: card, matching: find.byType(ClipRRect)),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('tap and both swipe directions switch variable-height lessons', (
    tester,
  ) async {
    var opened = 0;
    await open(tester, overlap(onLesson: () => opened++));
    final card = find.byKey(const ValueKey('schedule-overlap-card'));
    final header = find.byKey(const ValueKey('schedule-overlap-next'));
    final before = tester.getSize(card).height;
    await tester.tap(header);
    await tester.pumpAndSettle();
    expect(find.text('2/2'), findsOneWidget);
    expect(tester.getSize(card).height, before + 130);
    await tester.tap(find.text('Длинная пара'));
    expect(opened, 1);
    await tester.drag(find.text('Длинная пара'), const Offset(120, 0));
    await tester.pumpAndSettle();
    expect(find.text('1/2'), findsOneWidget);
    expect(tester.getSize(card).height, before);
    await tester.drag(find.text('Короткая пара'), const Offset(-120, 0));
    await tester.pumpAndSettle();
    expect(find.text('2/2'), findsOneWidget);
    expect(opened, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('retains selected lesson on reorder and clamps removed lessons', (
    tester,
  ) async {
    var labels = ['Короткая пара', 'Длинная пара', 'Третья пара'];
    late StateSetter rebuild;
    await open(
      tester,
      StatefulBuilder(
        builder: (context, setState) {
          rebuild = setState;
          return overlap(labels: labels, initialIndex: 1);
        },
      ),
    );
    rebuild(() => labels = ['Длинная пара', 'Короткая пара']);
    await tester.pumpAndSettle();
    expect(find.text('Длинная пара'), findsOneWidget);
    expect(find.text('1/2'), findsOneWidget);
    rebuild(() => labels = ['Короткая пара']);
    await tester.pumpAndSettle();
    expect(find.text('Короткая пара'), findsOneWidget);
    rebuild(() => labels = []);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('schedule-overlap-card')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final compact in [false, true]) {
    testWidgets('large text fits ${compact ? 'week cell' : 'phone card'}', (
      tester,
    ) async {
      await open(
        tester,
        overlap(compact: compact),
        width: compact ? 58 : 280,
        scale: 2,
      );
      await tester.tap(find.byKey(const ValueKey('schedule-overlap-next')));
      await tester.pumpAndSettle();
      expect(find.text('2/2'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('reduced motion switches immediately without outgoing content', (
    tester,
  ) async {
    await open(
      tester,
      Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: overlap(),
        ),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('schedule-overlap-next')));
    await tester.pump();
    expect(find.text('Короткая пара'), findsNothing);
    expect(find.text('Длинная пара'), findsOneWidget);
    expect(find.byType(AnimatedSize), findsNothing);
  });
}
