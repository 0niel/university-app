import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/home/view/home_dashboard_page.dart';
import 'package:rtu_mirea_app/home/view/home_day_pager.dart';

import '../../helpers/pump_app.dart';

class _SwipeHarness extends StatefulWidget {
  const _SwipeHarness({required this.days});

  final List<DateTime> days;

  @override
  State<_SwipeHarness> createState() => _SwipeHarnessState();
}

class _SwipeHarnessState extends State<_SwipeHarness> {
  int _index = kHomeDayWindowTodayIndex;
  bool _forward = true;

  void _select(int index) {
    if (_index == index) return;
    setState(() {
      _forward = index > _index;
      _index = index;
    });
  }

  void _step(HomeDayStep step) {
    final target = homeDayStepTarget(
      selectedIndex: _index,
      dayCount: widget.days.length,
      step: step,
    );
    if (target == null) return;
    _select(target);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HomeDayPager(
            days: widget.days,
            lessonCounts: List.filled(widget.days.length, 1),
            selectedIndex: _index,
            onSelected: _select,
          ),
          HomeDaySwipeSwitcher(
            forward: _forward,
            onStep: _step,
            child: SizedBox(
              key: ValueKey('board-$_index'),
              height: 120,
              width: double.infinity,
              child: Center(child: Text('day ${widget.days[_index].day}')),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  final days = homeDayWindow(DateTime(2026, 8, 18, 10));

  group('HomeDaySwipeSwitcher', () {
    testWidgets('a left flick moves to the next day', (tester) async {
      await tester.pumpApp(
        _SwipeHarness(days: days),
        size: const Size(360, 720),
      );
      await tester.pumpAndSettle();

      expect(find.text('day 18'), findsOneWidget);

      await tester.fling(find.text('day 18'), const Offset(-120, 0), 900);
      await tester.pumpAndSettle();

      expect(find.text('day 19'), findsOneWidget);
      expect(find.text('day 18'), findsNothing);
    });

    testWidgets('a right flick moves to the previous day', (tester) async {
      await tester.pumpApp(
        _SwipeHarness(days: days),
        size: const Size(360, 720),
      );
      await tester.pumpAndSettle();

      await tester.fling(find.text('day 18'), const Offset(120, 0), 900);
      await tester.pumpAndSettle();

      expect(find.text('day 17'), findsOneWidget);
    });

    testWidgets('a short drag stays on the same day', (tester) async {
      await tester.pumpApp(
        _SwipeHarness(days: days),
        size: const Size(360, 720),
      );
      await tester.pumpAndSettle();

      await tester.drag(find.text('day 18'), const Offset(-30, 0));
      await tester.pumpAndSettle();

      expect(find.text('day 18'), findsOneWidget);
    });

    testWidgets('the window edge rubber-bands instead of paging', (
      tester,
    ) async {
      await tester.pumpApp(
        _SwipeHarness(days: days),
        size: const Size(360, 720),
      );
      await tester.pumpAndSettle();

      await tester.fling(find.text('day 18'), const Offset(240, 0), 900);
      await tester.pumpAndSettle();
      await tester.fling(find.text('day 17'), const Offset(240, 0), 900);
      await tester.pumpAndSettle();
      await tester.fling(find.text('day 16'), const Offset(240, 0), 900);
      await tester.pumpAndSettle();

      expect(find.text('day 16'), findsOneWidget);
    });

    testWidgets('the outgoing day slides against the swipe', (tester) async {
      await tester.pumpApp(
        _SwipeHarness(days: days),
        size: const Size(360, 720),
      );
      await tester.pumpAndSettle();

      await tester.fling(find.text('day 18'), const Offset(-120, 0), 900);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));

      final incoming = tester.getTopLeft(find.text('day 19')).dx;
      final outgoing = tester.getTopLeft(find.text('day 18')).dx;
      expect(incoming, greaterThan(outgoing));
      await tester.pumpAndSettle();
    });

    testWidgets('the incoming day slides in from the left when going back', (
      tester,
    ) async {
      await tester.pumpApp(
        _SwipeHarness(days: days),
        size: const Size(360, 720),
      );
      await tester.pumpAndSettle();

      await tester.fling(find.text('day 18'), const Offset(120, 0), 900);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));

      final incoming = tester.getTopLeft(find.text('day 17')).dx;
      final outgoing = tester.getTopLeft(find.text('day 18')).dx;
      expect(incoming, lessThan(outgoing));
      await tester.pumpAndSettle();
    });
  });

  group('HomeDayPager', () {
    testWidgets('scrolls the rail so the swiped day stays visible', (
      tester,
    ) async {
      await tester.pumpApp(
        _SwipeHarness(days: days),
        size: const Size(360, 720),
      );
      await tester.pumpAndSettle();

      final rail = find.byKey(const ValueKey('home-day-strip'));
      expect(tester.widget<ListView>(rail).controller?.offset, 0);

      for (var step = 0; step < 8; step++) {
        await tester.fling(
          find.textContaining('day '),
          const Offset(-120, 0),
          900,
        );
        await tester.pumpAndSettle();
      }

      expect(find.text('day 26'), findsOneWidget);
      final controller = tester.widget<ListView>(rail).controller!;
      expect(controller.offset, greaterThan(0));
      expect(
        controller.offset,
        homeDayRailOffset(
          index: 10,
          cellWidth: 48,
          separator: 2,
          leadingInset: 2,
          viewport: controller.position.viewportDimension,
          maxScrollExtent: controller.position.maxScrollExtent,
        ),
      );
      expect(find.text('26'), findsOneWidget);
    });

    testWidgets('tapping a rail cell selects that day', (tester) async {
      await tester.pumpApp(
        _SwipeHarness(days: days),
        size: const Size(360, 720),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('20'));
      await tester.pumpAndSettle();

      expect(find.text('day 20'), findsOneWidget);
    });

    testWidgets('rail cells keep press feedback', (tester) async {
      await tester.pumpApp(
        _SwipeHarness(days: days),
        size: const Size(360, 720),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppPressable), findsWidgets);
      expect(find.byType(InkResponse), findsNothing);
    });
  });
}
